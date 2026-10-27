# The PostgreSQL lab (`shop`)

The subject's shared sample database, shipped as plain SQL so every learner — and every
reviewer — can rebuild the exact schema the lessons execute against, then diff their own
results against captured ones. Nothing here needs Docker or a local install: any
reachable PostgreSQL server works.

## Contents

| Path | What it is |
|---|---|
| `scripts/shop.sql` | One-file build: schema + seed (equivalent to `01-schema.sql` then `02-seed.sql`) |
| `scripts/01-schema.sql` | `pg_dump`-style DDL only: 5 tables, keys, CHECKs, FKs, indexes in schema `shop` |
| `scripts/02-seed.sql` | The lesson's fixed rows: 3 categories, 2 customers, 4 products, 2 orders, 3 lines |
| `scripts/queries/q1…q7` | Seven checks: counts, order totals, orphans-free FKs, CHECK inventory, jsonb, revenue |
| `expected/q1…q7.txt` | The captured output of each query, byte-for-byte (LF line endings) |
| `verify.sh` | Builds a scratch database from the scripts and diffs every query against `expected/` |

## Quick start

```bash
cd 10-DATABASE-ENGINEERING/postgresql

# one-shot verification (creates and drops a scratch database named shop_verify):
PGHOST=127.0.0.1 PGPORT=5432 PGUSER=you bash verify.sh
```

`verify.sh` exits `0` only when all seven queries match their expected files; on a mismatch
it prints the unified diff and exits `1`. Override the scratch database name with
`VERIFY_DB=other_db`.

Manual build instead (what `verify.sh` does internally):

```bash
createdb shop_lab
psql -v ON_ERROR_STOP=1 -d shop_lab -f scripts/01-schema.sql
psql -v ON_ERROR_STOP=1 -d shop_lab -f scripts/02-seed.sql
psql -d shop_lab -f scripts/queries/q7-revenue-by-category.sql
```

## What the data is

A miniature shop, deliberately: three tables hang off `category`, `customer`, and
`product` (`order` and `order_line`), with every integrity device the lessons teach
visible in one schema — surrogate keys, `unique` natural keys, an optional FK
(`product.category_id`), money CHECKs, an enum-as-CHECK `status`, a
`unique (order_id, product_id)` line constraint, `on delete cascade` on order lines, and
one honest `jsonb` column (`product.attrs`) for attributes that vary by product.

## How the lessons use it

- `database-design.md` Example 1 is this DDL; its Example 2 money query and Example 3
  rejections run against this seed.
- The filter/aggregation, joins, constraints, and query-plan lessons query the same
  schema, so one build serves the whole ladder.
- Expected outputs were captured with **psql 18.6** on Windows; `verify.sh` strips the
  CR psql writes on Windows before diffing, so results are identical on Linux/macOS.

## Version note

The `.sql` dumps were produced by `pg_dump` 18.6 and contain psql's `\restrict`
meta-command, so the **client** must be psql **16.4 or newer** (the hardening release
that added it). The server itself is ordinary SQL — anything from PostgreSQL 12 onward
runs it.

## Re-capturing expected outputs

If your server's formatting ever differs (widths are derived from the data, so they
shouldn't), regenerate rather than edit by hand:

```bash
for q in scripts/queries/q*.sql; do
  psql -X -d shop_lab -f "$q" | sed 's/\r$//' > "expected/$(basename "$q" .sql).txt"
done
bash verify.sh
```
