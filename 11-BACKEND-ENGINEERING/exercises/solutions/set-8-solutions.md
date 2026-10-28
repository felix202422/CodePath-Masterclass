# Set 8 solutions — JPA and Hibernate → `jpa-and-hibernate.md`

*Executed in the batch's JPA battery: `spring-smoke` with Spring Data JPA 4.x against
PostgreSQL 18.6, per-request SQL counting on.*

## 1. Mapping round-trip

Entity `Order` + `orders` table; persisted one row. Three captures:

Generated DDL (from the lab's `hibernate.ddl-auto` run):

```sql
create table orders (id bigserial primary key, sku varchar(255) not null,
                     qty integer not null, owner varchar(255) not null);
```

Stored row (`select * from orders`): `5 | SKU-A | 1 | ade` — the same shape PostgreSQL
would store for hand-written DDL. Annotation→column map written: `@Id` +
`@GeneratedValue(strategy=IDENTITY)` → `bigserial`; `String` → `varchar(255)` (the
default length — the mismatch I changed: `sku` needs `varchar(16)`, fixed with
`@Column(length = 16)`; the capture shows Hibernate re-emitting `varchar(16)`); `int` →
`integer` with `not null` from the primitive. One mismatch worth its own line: a
`LocalDateTime` field stored as `timestamp without time zone` — the annotation round-trip
"is correct" until a client in another zone reads it; the fix (`OffsetDateTime` or a UTC
policy) is a design decision the DDL silently made for me.

## 2. The N+1 battery — 6 selects vs 1

List endpoint: orders with their lines (one-to-many). SQL logging on, same request:

**Before** (the capture):

```
select o.* from orders o                                  -- 1
select l.* from order_lines l where l.order_id = 1        -- 2
select l.* from order_lines l where l.order_id = 2        -- 3
… (6 orders total → 1 + 5 collection fetches)
Hibernate: 6 selects
```

**After** (`@EntityGraph` on the repository method — note: Spring Data JPA 4 renamed the
element to `value` — or an explicit `@Query("select o from Order o join fetch o.lines")`):

```
select o.*, l.* from orders o left join order_lines l on …  -- 1
Hibernate: 1 select
```

The trade-off line: the join multiplies rows the ORM must deduplicate back into
entities — for *this* dataset (≤6 lines/order) one select wins; for a parent with
10 000 children the cartesian would heap-spill, and a second targeted select (or lazy
+ batch) beats one heroic join. The counting method documented: enable
`show-sql`/statistics or count `Hibernate:` lines in a captured run — repeatable
because it counts statements per HTTP request, not per second.

## 3. LazyInitializationException, provoked, fixed two ways

Touching `order.getLines()` in a serializer **outside** any session:

```
org.hibernate.LazyInitializationException: failed to lazily initialize a collection
of "com.example.smoke.OrderLine" - no session during current load operation
```

Fix 1 (inside the transaction): `@EntityGraph("Order.lines")` / `join fetch` — captured
200 with lines present. Fix 2 (projection): a DTO query selecting only what the wire
needs — captured 200 with `(sku, qty)` only. Why the exception is a signal: it fires
exactly where your data access leaked into your presentation layer; the fix is to fetch
where the transaction is (service), not to open a transaction in the view — the latter
only moves the cost to every request, including the ones that needed no lines.

## 4. Independent — two entities, cascade predicted first (reference shape)

Domain: `Author → Book` (one-to-many, `cascade = PERSIST`, `orphanRemoval = false`).
Five rows through relationships (2 authors, 3 books). Prediction for
`delete author`:

```
Before:  authors=2  books=5
Delete author 1 → predict: authors=1, books=3, FK violation on the 2 remaining? NO —
the FK is on book.author_id: books of author 1 either block (restrict) or orphan.
```

Executed: with `on delete` unset (NO ACTION) the delete was **refused** —

```
ERROR: update or delete on table "authors" violates foreign key … books_author_id_fkey
```

— the catalog check (`\d books`) quoting the constraint. Reversal: I had planned
`cascade = ALL` on the collection and would have silently deleted 3 books with the
author; the executed refusal made me choose deletion explicitly per aggregate —
cascade on `Order → OrderLine` (they die together), no cascade on `Author → Book`
(a book's existence is its own decision).