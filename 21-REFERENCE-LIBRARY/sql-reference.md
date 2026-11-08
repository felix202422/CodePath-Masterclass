# SQL Reference (PostgreSQL)

Query and schema patterns for the database work in this curriculum, written for PostgreSQL 18. Every
statement on this page was executed against a real server; the outputs quoted are the captures, not
reconstructions.

> **Baseline.** PostgreSQL 18.6. Verified on 2026-11-08 against a throwaway cluster created with
> `initdb --auth=trust` on port 55432, using the `psql` 18.6 client. Sample schema used throughout:
> `customers(id, email, name, created_at)` and `orders(id, customer_id, status, total, created_at)`.
> Syntax that PostgreSQL-specific is marked **PG**; everything else is standard SQL.

## Clause order is not execution order

You write a query in one order and the server evaluates it in another. The difference explains most
"why can't I use that alias here" errors.

| You write | The server does |
|---|---|
| `SELECT` | `FROM` / `JOIN` — build the row sources |
| `FROM` | `WHERE` — filter individual rows |
| `WHERE` | `GROUP BY` — collapse into groups |
| `GROUP BY` | `HAVING` — filter groups |
| `HAVING` | `SELECT` — compute output columns and aliases |
| `ORDER BY` | `DISTINCT`, then `ORDER BY` |
| `LIMIT` | `LIMIT` / `OFFSET` — discard rows last |

Two consequences: a `SELECT` alias is not visible in `WHERE` (the alias does not exist yet), and
filtering in `WHERE` is cheaper than filtering in `HAVING` because fewer rows reach the grouping step.

## Schema: tables, keys and constraints

```sql
create table orders (
    id          bigint generated always as identity primary key,
    customer_id bigint not null references customers (id) on delete cascade,
    status      text not null default 'pending'
                check (status in ('pending', 'paid', 'shipped')),
    total       numeric(10, 2) not null check (total > 0),
    created_at  timestamptz not null default now()
);
```

- `generated always as identity` is the modern replacement for `serial`; it cannot be overridden by a plain `INSERT`.
- `references ... on delete cascade` deletes child rows with the parent. The alternatives are `restrict` (default), `set null` and `set default` — choose deliberately, because a wrong choice silently destroys or blocks data.
- `check` constraints run in the database, so no client can bypass them. `numeric(10,2)` is exact money; `double precision` is not.
- `timestamptz` stores an instant and renders it in the session time zone; `timestamp` stores a wall clock with no zone and is almost never what you want.

**Verified:** `CREATE TABLE` and `CREATE INDEX` both succeeded on the throwaway cluster.

## Insert, upsert, returning

```sql
-- multi-row insert
insert into customers (email, name) values
    ('ada@example.com',   'Ada'),
    ('grace@example.com', 'Grace');

-- upsert: insert, or update the row that conflicts on the unique column
insert into customers (email, name) values ('ada@example.com', 'Ada Lovelace')
on conflict (email) do update set name = excluded.name
returning id, name, (xmax = 0) as inserted;

-- do nothing instead, when a duplicate is not an error
insert into customers (email, name) values ('ada@example.com', 'Ada')
on conflict (email) do nothing;
```

**Verified output of the upsert:**

```text
 id |     name     | inserted
----+--------------+----------
  1 | Ada Lovelace | f
(1 row)
```

- `excluded` is the pseudo-table holding the row you tried to insert.
- `(xmax = 0)` is the usual way to tell an insert from an update in the `RETURNING` list; `true` means inserted.
- `on conflict` needs a unique or exclusion constraint to conflict on — a plain index is not enough.

## Filtering

| Need | Syntax | Note |
|---|---|---|
| Match a pattern, case-sensitive | `where name like 'Ad%'` | `%` any run, `_` one character. |
| Case-insensitive match | `where name ilike 'ad%'` | **PG**; `lower(name) like 'ad%'` works everywhere. |
| Set membership | `where status in ('paid', 'shipped')` | `not in` with a `NULL` in the list matches nothing — a classic bug. |
| Range | `where total between 10 and 100` | Inclusive on both ends. |
| Absent values | `where email is null` | `= null` is never true; `is distinct from` compares `NULL` safely. |
| Time window | `where created_at >= now() - interval '7 days'` | Use `timestamptz` and UTC boundaries. |
| Pattern from a table | `where name similar to 'A.*'` | Rarely needed; `like` covers most cases. |

**NULL semantics in one line:** `NULL` means unknown, so any comparison with it yields unknown, and
`WHERE` keeps only rows where the condition is true.

## Joins

| Join | Returns | Use when |
|---|---|---|
| `inner join` | Rows matching in both tables. | You need both sides to exist. |
| `left join` | All left rows, plus matches or `NULL`s. | "Customers and their orders, including customers with none." |
| `right join` | Mirror of `left join`. | Rarely used — rewrite as `left` for readability. |
| `full join` | All rows from both sides. | Reconciliation between two sources. |
| `cross join` | Cartesian product. | With `lateral`, or for deliberate combinations. |
| `cross join lateral` | A subquery that may reference the left row. | "Top 3 orders per customer." |

```sql
select c.name, count(o.id) as order_count
from customers c
left join orders o on o.customer_id = c.id
group by c.id, c.name
order by order_count desc, c.name;
```

**Verified output:**

```text
 name  | order_count
-------+-------------
 Ada   |           2
 Grace |           2
 Alan  |           1
(3 rows)
```

`count(o.id)` counts non-`NULL` values, so a customer with no orders counts `0`; `count(*)` would
count the `NULL`-padded row and return `1`. That single difference is the most common join bug.

## Aggregation

```sql
select c.name, count(*) as order_count, sum(o.total) as lifetime
from customers c
join orders o on o.customer_id = c.id
group by c.id, c.name
having sum(o.total) > 100
order by lifetime desc;
```

**Verified output:**

```text
 name  | order_count | lifetime
-------+-------------+----------
 Grace |           2 |   225.25
 Ada   |           2 |   200.50
(2 rows)
```

| Pattern | Syntax | Note |
|---|---|---|
| Conditional count | `count(*) filter (where status = 'paid')` | **PG**; standard SQL uses `sum(case when ... then 1 else 0 end)`. |
| Conditional sum, no `NULL`s | `coalesce(sum(total) filter (where status <> 'pending'), 0)` | `sum` over no rows is `NULL`; `coalesce` turns it into `0`. |
| Distinct count | `count(distinct customer_id)` | Cannot be combined with `filter` in one call. |
| Group by expression | `group by date_trunc('month', created_at)` | The expression must match the `select` list exactly. |
| Group by position | `group by 1, 2` | Convenient in `psql`, fragile when the `select` list changes. |
| Grand total in the same result | `group by rollup (status)` | Adds a `NULL`-keyed total row. |

## Window functions

A window function aggregates without collapsing rows: every input row survives, with the computed
value attached.

```sql
select c.name,
       o.created_at::date as day,
       o.total,
       sum(o.total) over (partition by o.customer_id order by o.created_at
                          rows between unbounded preceding and current row) as running_total
from orders o
join customers c on c.id = o.customer_id
order by c.name, o.created_at;
```

**Verified output (excerpt):**

```text
 name  |    day     | total  | running_total
-------+------------+--------+---------------
 Ada   | 2026-01-05 | 120.00 |        120.00
 Ada   | 2026-01-19 |  80.50 |        200.50
 Alan  | 2026-03-01 |  42.00 |         42.00
(3 rows shown of 5)
```

| Need | Function |
|---|---|
| Rank with gaps | `rank() over (order by total desc)` |
| Rank without gaps | `dense_rank() over (order by total desc)` |
| Row number within a group | `row_number() over (partition by customer_id order by created_at)` |
| Previous row's value | `lag(total) over (partition by customer_id order by created_at)` |
| Next row's value | `lead(created_at) over (order by created_at)` |
| Share of group total | `total / sum(total) over (partition by customer_id)` |
| Moving average | `avg(total) over (order by created_at rows between 6 preceding and current row)` |
| Bucket into quartiles | `ntile(4) over (order by total)` |

`partition by` is to a window what `group by` is to an aggregate; without an `order by`, the frame is
the whole partition.

## CTEs and `distinct on`

```sql
with recent as (
    select * from orders where created_at >= '2026-02-01'
)
select distinct on (customer_id) customer_id, id, status, created_at
from recent
order by customer_id, created_at desc;
```

**Verified output:**

```text
 customer_id | id | status  |       created_at
-------------+----+---------+------------------------
           2 |  4 | paid    | 2026-02-03 13:00:00+03
           3 |  5 | shipped | 2026-03-01 13:00:00+03
(2 rows)
```

- `distinct on (x)` keeps the first row per `x` according to `order by` — **PG**-specific, and much faster than a `row_number()` filter for "latest row per group".
- Recursive CTE for hierarchies: `with recursive tree as (select ... union all select ... from tree join ...) select * from tree;`
- PostgreSQL 12+ inlines most CTEs; add `materialized` to force one evaluation when the planner's choice is wrong.

## `LATERAL`: top-N per group

```sql
select c.name, o.id, o.created_at::date
from customers c
cross join lateral (
    select id, created_at from orders
    where customer_id = c.id
    order by created_at desc
    limit 3
) o
order by c.name, o.created_at desc;
```

The subquery can reference `c`, which is exactly what a plain subquery in `FROM` cannot do. `left
join lateral ... on true` keeps groups with no matching rows.

## Dates, times and series

| Need | Expression |
|---|---|
| Current instant | `now()` (transaction start) or `clock_timestamp()` (actual clock) |
| Truncate to month | `date_trunc('month', created_at)` |
| Format | `to_char(created_at, 'YYYY-MM-DD HH24:MI')` |
| Parse | `to_date('2026-01-05', 'YYYY-MM-DD')` |
| Add an interval | `created_at + interval '7 days'` |
| Difference | `end_at - start_at` (an `interval`), or `age(end_at, start_at)` |
| Days between | `(end_at::date - start_at::date)` (an `integer`) |
| A series of days | `generate_series(date '2026-01-01', date '2026-01-05', interval '1 day')` |
| First day of month | `date_trunc('month', created_at)::date` |
| Time zone conversion | `created_at at time zone 'Europe/Berlin'` |

**Verified:** `generate_series(date '2026-01-01', date '2026-01-05', interval '2 days')` returned
`2026-01-01`, `2026-01-03`, `2026-01-05`.

## JSONB and arrays

```sql
select jsonb_build_object('orders', count(*), 'revenue', sum(total)) from orders;
-- {"orders": 5, "revenue": 467.75}

select array_agg(status order by status) as statuses from orders;
-- {paid,pending,shipped,shipped,shipped}
```

| Need | Operator |
|---|---|
| Field as JSON | `payload -> 'user'` |
| Field as text | `payload ->> 'user'` |
| Nested path | `payload #>> '{user,email}'` |
| Contains | `payload @> '{"status":"paid"}'` |
| Key exists | `payload ? 'status'` |
| Expand an array to rows | `jsonb_array_elements(payload -> 'items')` |
| Index for containment | `create index on t using gin (payload jsonb_path_ops);` |
| Array contains | `tags @> array['sql']` |
| Array overlap | `tags && array['sql', 'postgres']` |

## Transactions, isolation and locking

```sql
begin;
set transaction isolation level read committed;   -- PostgreSQL's default
select status from orders where id = 1 for update; -- lock the row against concurrent writes
update orders set status = 'shipped' where id = 1;
commit;                                            -- or rollback;
```

| Level | Prevents | Still possible | Cost |
|---|---|---|---|
| `read committed` | Dirty reads | Non-repeatable reads, phantoms | Default; cheapest. |
| `repeatable read` | Dirty and non-repeatable reads | Serialisation failures on conflict (retry) | Snapshot per transaction. |
| `serializable` | All of the above, including phantoms | Nothing — but transactions abort and must retry | Highest contention cost. |

- `select ... for update` blocks other writers until commit; `for update nowait` fails fast; `for share` blocks writers but allows other readers.
- Never hold a transaction open across a network call or user think-time: it pins locks and a connection.
- A serialisation failure (`could not serialize access`) is expected under `repeatable read`/`serializable`; retry the whole transaction.

## Indexes

```sql
create index orders_customer_idx on orders (customer_id, created_at desc);
create index orders_open_idx on orders (status, created_at) where status <> 'shipped';
```

| Kind | Syntax | Use |
|---|---|---|
| B-tree (default) | `create index on t (col)` | Equality and range on sortable values. |
| Composite | `create index on t (a, b)` | Queries filtering on `a`, or `a` and `b` — not on `b` alone. |
| Partial | `create index on t (col) where status <> 'shipped'` | Hot subset only; smaller and cheaper to maintain. |
| Expression | `create index on t (lower(email))` | The query must use the same expression. |
| Unique | `create unique index on t (email)` | Enforces the rule and serves lookups. |
| GIN | `create index on t using gin (payload)` | JSONB containment, arrays, full-text. |
| Covering | `create index on t (a) include (b)` | Index-only scans for `select a, b`. |

An index is not free: every `insert`, `update` and `delete` maintains it. Unused indexes are pure
write cost — `pg_stat_user_indexes.idx_scan` tells you which are never read.

## Reading `EXPLAIN`

```sql
explain (costs off)
select id from orders where customer_id = 1 order by created_at desc limit 5;
```

**Verified output:**

```text
                         QUERY PLAN
------------------------------------------------------------
 Limit
   ->  Sort
         Sort Key: created_at DESC
         ->  Bitmap Heap Scan on orders
               Recheck Cond: (customer_id = 1)
               ->  Bitmap Index Scan on orders_customer_idx
                     Index Cond: (customer_id = 1)
(7 rows)
```

| Node | Meaning | Suspicious when |
|---|---|---|
| `Seq Scan` | Every row read. | On a large table with a selective filter. |
| `Index Scan` | Index lookup, then heap fetch per row. | Fine; watch for many random fetches. |
| `Bitmap Index Scan` + `Bitmap Heap Scan` | Index finds row locations, heap read in physical order. | Good for medium selectivity. |
| `Index Only Scan` | All columns come from the index. | The ideal; requires a matching index. |
| `Nested Loop` | For each outer row, probe the inner side. | Slow when the outer side is large and the inner is unindexed. |
| `Hash Join` | Build a hash of one side, probe with the other. | Memory-heavy on huge inputs. |
| `Sort` | Explicit sort, possibly spilling to disk. | `Sort Method: external merge` means it spilled — raise `work_mem` or add an index. |

Read plans inside-out: the deepest node runs first. `explain analyze` actually executes the statement
and adds real times and row counts — the estimates next to them show where the planner is wrong.

## Type choices

| Need | Type | Do not use |
|---|---|---|
| Money | `numeric(12,2)` | `float`/`double` — binary floating point cannot represent 0.10 exactly. |
| Identifier | `bigint` (identity) or `uuid` | `text` for a surrogate key. |
| Instant | `timestamptz` | `timestamp` without a zone. |
| Duration | `interval` | `integer` seconds with no unit in the name. |
| Enum-like value | `text` + `check`, or a lookup table | A native `enum` type, which is painful to alter. |
| Free-form structure | `jsonb` | `json` (no indexing, keeps duplicate keys and whitespace). |
| Short labels | `text` | `varchar(n)` — the limit buys nothing and costs a migration later. |
| Boolean tri-state | `boolean` nullable | `char(1)` flags. |

## Related pages

- [Common Errors](common-errors.md) — the messages these statements produce when they fail
- [Glossary](glossary.md) — isolation, normalisation, N+1 and the rest of the vocabulary
- [10-DATABASE-ENGINEERING/sql-fundamentals.md](../10-DATABASE-ENGINEERING/sql-fundamentals.md) — the lesson these patterns come from
- [10-DATABASE-ENGINEERING/query-plans-and-optimization.md](../10-DATABASE-ENGINEERING/query-plans-and-optimization.md) — reading plans properly
