# Solutions — Set 8: Normalization → `normalization.md`

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.
> Executed on the authoring machine: PostgreSQL 18.6; the anomaly and repair captures are the
> lesson's real probe outputs.

## Exercise 1 — Classify four relations by their FDs

The method, stated once: for each relation, list functional dependencies (what
determines what), mark the determinant sets, and the *leftmost unnormalized form* falls
out — 1NF: no repeating groups; 2NF: no partial dependency on part of a composite key;
3NF: no transitive dependency (non-key → non-key).

| Relation sketch | Verdict | Why (FDs) |
|---|---|---|
| `order(id, product_id, qty, product_name)` with PK `(id, product_id)` | **1NF only** | `product_id → product_name` is a partial dependency on part of the key — fix: move products out (2NF) |
| `customer(id, zip, city)` | **2NF, not 3NF** | `zip → city` is transitive (`id → zip → city`) — fix: `zip_code(zip, city)` |
| `line(id, order_id, qty, unit_price)` PK `id` | **3NF** | all non-keys depend on the key, the whole key, and nothing but the key |
| a table with a `phones` multi-value cell | **not even 1NF** | repeating group — fix: child table |

**The executed anomaly per unnormalized relation** (lesson's captures on a flat table —
one row holding facts about two things): the **update anomaly** left `truths = 2`
(one city name stored two ways, disagreeing); the **insertion anomaly** refused a
`not null` row (a customer with no order could not be represented at all — *the customer
deleted with their orders* case); the **deletion anomaly** took unrelated truths with it.
Three anomalies, three captures — the unnormalized table doesn't just "look messy", it
permits states the business forbids.

## Exercise 2 — The executed round trip

The lesson's actual sequence, abbreviated to its receipts:

1. **Flatten** `shop`'s facts into one table, seed it duplicated (a category name now
   appears on every product row).
2. **Show the anomaly:** rename a category for *one* of its rows → executed partial
   update: the table now holds **two names for one category** (`truths = 2`). No
   constraint fires — nothing is *invalid*, the data is just *untrue*.
3. **Normalize back** into `category` / `product` / `order_line` and re-run the same
   rename → one `update`, `UPDATE 1`, every row consistent because there is only one
   copy.
4. **Prove lossless:** the rebuilt tables joined back to the flat shape return the same
   row count (`view = 3 rows` matching the original facts) and `count(*)` matches on
   both sides — *lossless* means the join reproduces the original without duplicates or
   drops.
5. **Anomaly re-runs disappear:** the same three operations that produced the anomalies
   in step 2 now either succeed once or are correctly refused — "anomaly re-runs
   disappearing" is the repair's acceptance test, not the DDL's.

**The rule in one line per form:** 1NF — facts in cells, one value per cell; 2NF — every
fact depends on the *whole* key; 3NF — every fact depends on the key, the whole key, and
nothing but the key.

## Exercise 3 — Detect a hidden FD from data

```sql
-- does zip determine city?  FD holds iff NO group has two cities:
select zip, count(distinct city) as cities
  from address
 group by zip
having count(distinct city) > 1;     -- rows returned => FD is FALSE
```

**Prediction discipline:** empty result → for this data, `zip → city` holds — promote it
to a constraint (`unique(zip)` on a `zip_code` table + FK) *because data agreeing today
is not enforcement*. Rows returned → the FD is false; the "city column" you were about
to drop is carrying information the zip doesn't. Either way you then **state the key:**
`zip_code(zip pk, city)` referenced by `address`, or keep both columns with a
`check`-style application rule — and write which you chose and why.

## Exercise 4 — Argue *for* denormalization (reference shape)

The four beats a reviewer grades, with the lesson's evidence shapes:

1. **The measurement plan:** the exact query, the row volume at which it was timed
   (`explain analyze` output — the lesson's pattern: `13.164 ms` seq scan → `0.700 ms`
   indexed is the *class* of number you need), and the budget it misses (state the ms).
2. **The write-path bug:** concretely — "every `order_line` insert must also
   `update product.revenue`"; the race (two concurrent inserts read the same old
   total — the isolation lesson's executed `150` clobbering `200`), and the detection
   story (nothing fails loudly; the report just lies).
3. **The invalidation strategy:** atomic same-transaction update, or rebuild-on-write,
   or a scheduled reconciliation with a stated staleness window *and* how the UI labels
   it.
4. **The verdict with a flip condition:** "not yet — denormalize when p95 of the report
   exceeds 200 ms at production volume *and* the write path is single-writer (which
   makes the race impossible)"; the flip in the other direction: "revert when the sync
   bug ships once." A verdict without both conditions is a preference, not a decision.

---

*Criteria cross-check: FD lists with keys named and one anomaly executed per bad
relation ✓, flat-table anomaly captured, single-update repair proven with row counts on
both sides ✓, detection query with its empty/row-returning interpretation ✓, measurement
plan + bug scenario + invalidation + verdict with flip condition ✓.*
