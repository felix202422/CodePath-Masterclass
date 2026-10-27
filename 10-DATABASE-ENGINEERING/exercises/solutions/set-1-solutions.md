# Solutions — Set 1: Database fundamentals → `database-fundamentals.md`

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.
> Executed on the authoring machine: PostgreSQL 18.6 / psql 18.6 scratch cluster and the
> shipped `postgresql/` lab. Quoted outputs are real captures.

## Exercise 1 — Identity and catalog

**Identity (executed):**

```
                                 version
-------------------------------------------------------------------------
 PostgreSQL 18.6 on x86_64-windows, compiled by msvc-19.44.35228, 64-bit
(1 row)

 current_user | current_database
--------------+------------------
 lab          | codepath_lab
(1 row)
```

**Catalog, `shop.product` (executed):**

```
 column_name | data_type | is_nullable
-------------+-----------+-------------
 id          | integer   | NO
 sku         | text      | NO
 name        | text      | NO
 category_id | integer   | YES
 price       | numeric   | NO
 attrs       | jsonb     | NO
(6 rows)
```

The prediction that catches people: `category_id` **YES** (the optional FK) and `attrs`
**NO** with a default — nullability is about the column, not about whether you supply the
value on insert.

**The path, named:** your keystroke → `psql` (client) → the wire protocol over the
connection → server parser (SQL → parse tree) → rewriter → planner/executor (scan,
filter, join) → rows returned → `psql` formats them. The four queries above each travelled
the whole road; only the last leg (catalog vs heap) differs — the first two read
`pg_catalog`/`information_schema` views, the row-shaped ones read the table's own pages.

## Exercise 2 — The three guard rejections (verbatim)

```
psql:…/db02-probes.sql:34: ERROR:  invalid input syntax for type numeric: "not-a-number"
LINE 1: ...me, credit) values ('bad@example.org', 'Bad Row', 'not-a-num…
```

```
psql:…/db02-probes.sql:38: ERROR:  duplicate key value violates unique constraint "customers_pkey"
DETAIL:  Key (id)=(1) already exists.
```

```
psql:…/db02-probes.sql:42: ERROR:  insert or update on table "orders" violates foreign key constraint "orders_customer_id_fkey"
DETAIL:  Key (customer_id)=(999) is not present in table "customers".
```

| Rejection | Layer | Fix |
|---|---|---|
| `invalid input syntax for type numeric` | type system, before storage | supply `'12.50'`-shaped input; convert in the app |
| `duplicate key … customers_pkey` | primary key constraint | let the id default assign, or use a genuinely new id |
| `violates foreign key … orders_customer_id_fkey` | foreign key constraint | insert the parent first — or fix the id you meant to reference |

The third message's `DETAIL` is the debugging gift: it tells you *which* key and *where*
it should have existed.

## Exercise 3 — NULL arithmetic (executed)

```
 credit | plus_one 
--------+----------
        |         
(1 row)

 rows_total | rows_with_credit 
------------+------------------
          3 |                2
(1 row)
```

So: `credit + 1` for the NULL row returned **NULL**, and the count pair was `3 | 2` —
three rows exist, only two have a known credit.

Prediction before the run is the whole exercise: `null + 1` is *unknown*, not `1`, and
`count(col)` skips unknowns while `count(*)` counts rows. **NULL is unknown** — that is
why `coalesce(credit, 0)` is a *decision about what unknown means here* (a gift card with
no balance?), not a formatting convenience.

## Exercise 4 — Independent schema (reference shape)

A reviewer's checklist for your clinic schema — no single correct text exists, so the
criteria are what gets audited:

- **Tables:** `practitioner`, `patient`, `appointment` — each column's type chosen (why
  `timestamptz` for slots?).
- **Expressible rules, each with its executed rejection:** wrong type on the slot time
  (type guard), double-booking the same slot (`unique (slot, practitioner)` — or the
  *absence* of it if overlap is allowed), missing practitioner reference (FK).
- **The un-expressible rule**, almost always: "an appointment must be in the future" or
  "a patient may not book before they exist" — `check` cannot see other rows or the
  clock (a `check (slot > now())` is frozen at insert-time evaluation and ages
  incorrectly). Enforcement place: the application (or a `constraint trigger`, which is
  the advanced name for the same idea). The honest sentence: *the database checks
  everything it can see in one row, once — the application checks everything else, and
  must be tested for it too.*

---

*Criteria cross-check: four captures with the path named ✓, three verbatim errors labelled
by layer ✓, NULL predicted then captured with the meaning stated ✓, the schema's
rejections executed and the un-expressible rule named with its enforcement place ✓.*
