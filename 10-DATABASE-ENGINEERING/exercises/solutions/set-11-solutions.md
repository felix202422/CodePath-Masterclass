# Solutions — Set 11: Indexes · query plans and optimization →
`indexes.md` · `query-plans-and-optimization.md`

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.
> Executed on the authoring machine: PostgreSQL 18.6; every number below is a real capture from
> the lessons' probe tables (`idx.big_order`, 100,000 rows).

## Exercise 1 — Measure, then index

**Predicted before each run:** no index → sequential scan; after `create index` →
bitmap/index scan. **Executed (the lesson's pair):**

```
-- without index:                                        -- with index:
Seq Scan on big_order        Seq Scan ... becomes:
  (actual time=13.164 .. …)      ->  Bitmap Index Scan on big_order_pkey...
  Rows Removed by Filter: 99980     (actual time=0.700 .. …)
  Buffers: shared hit=637           Buffers: shared hit=22
```

- **13.164 ms → 0.700 ms** for the same 20-row answer; rows removed **99,980** — the
  seq scan read the whole table to reject almost all of it; the index read 22 buffers
  instead of 637.
- **Size on disk (the price):** index **776 kB** over a **5,096 kB** table — real bytes
  from `pg_relation_size`. Every index is storage, write amplification on every
  insert/update, and planner surface; the timing win is what you buy with them.
- **The planner's decline, executed:** on a predicate matching **12%** of rows the
  planner *chose the seq scan* — the crossover is real, and "index always" is as wrong
  as "index never."

**Honesty line for your notes:** one run proves the difference exists, not that it is
stable — a measurement series (3 runs, `explain analyze` each) is what you'd defend in
review; the captures above are quoted from the lesson's series.

## Exercise 2 — Read a plan you did not write

The annotation method (apply it to whatever your plan actually is):

1. **Top node = what the client receives.** Read bottom-up for execution order: scan
   nodes gather rows, join nodes combine, the top node delivers.
2. **Join order/inner-outer:** the *indented* side is the inner relation (probed once per
   outer row). A hash join with the small table inner is the normal healthy shape; the
   big table inner means a re-probe per outer row — name which you have.
3. **Scan types:** `Seq Scan` (whole table), `Index Scan` (sorted walk), `Bitmap Index
   Scan` (gather ids, then fetch by heap order — the two-step shows as two nodes).
4. **Where filtering happened:** `Filter:` = after fetch (rows read then discarded —
   watch `Rows Removed by Filter`); `Index Cond:` = before (the storage did the
   narrowing). Buffers tell you the real I/O cost; `actual time` in ms is wall time of
   that node.

**Triple-table prediction** (then verify): 3× rows → the seq scan grows ~3× linearly;
the indexed point lookup grows ~log n (nearly flat); a `limit` query with an index on
the sort key stays cheap, without it degrades to sort-all-then-slice. The re-run with
`explain (analyze, buffers)` confirms your reading of your own annotation — a plan read
that isn't checked against a re-run is a story, not an analysis.

## Exercise 3 — Index choice under constraint

**The choice table, written first:**

| Query | Index | Serves |
|---|---|---|
| point lookup `where sku = 'X'` | btree on `sku` (shipped lab already has it — `product_sku_key`) | equality |
| `where name like 'Mono%'` | btree on `name` | **prefix** `like` only — `like '%top'` cannot use it (leading wildcard) |
| `order by category_id, price` | btree `(category_id, price)` | sort without a sort node — the composite's order is the sort order |

**Plan evidence per index:** equality → `Index Scan`/`Bitmap Index Scan` with
`Index Cond`; prefix like → same, with the `Index Cond` carrying `name >= 'Mono' AND
name < 'Monp'`-style bounds (the range form of a prefix match); the composite → the
`Sort` node disappears or becomes `Scan` + no sort (the plan *is* the proof — a created
index the planner ignores has earned no bytes).

**Size cost summed:** from `pg_relation_size` per index — real figures from the lessons:
a single-column btree on 100k rows ran **776 kB**; sum yours the same way and put the
total next to the table size (a 15% overhead *per index* is the number that makes
"just index everything" untenable).

**The query your indexes do not help, named:** the `%term%` contains-search — no btree
condition matches a leading wildcard, and the honest answers are (a) a trigram GIN index
(`pg_trgm`) or (b) a search engine, both outside this set's scope. Naming the unhelped
query is the criterion; pretending no such query exists is the failure mode.

## Exercise 4 — Diagnose, fix narrowly, guard (reference shape)

The graded beats, each with the evidence a reviewer demands:

1. **Before capture** — `explain (analyze, buffers)` on the real query at a stated row
   volume; the bottleneck named *from the numbers*: `Rows Removed by Filter` huge →
   selectivity problem (index); `actual time` dominated by a `Sort` with `Disk Usage` →
   memory/work_mem or an index-on-sort; buffers high for a nested loop over a big inner
   → join shape/`join_collapse_limit` territory.
2. **The narrowest fix** tied to that measurement — one index (say `(status, created_at)`
   for a status-filtered, date-ordered feed) or one `ANALYZE` when the diagnosis is stale
   statistics (the lesson executed exactly this: estimate gaps closing after `ANALYZE`,
   turning a wrong join order into a right one *without any schema change*).
3. **After capture** — same query, same volume, the delta quoted (lesson's class of
   number: seq → bitmap at 13.164 → 0.700 ms; sort spill 223.199 ms external-merge vs
   top-N's 57.862 ms — both remind you the *shape* of the fix, not just the ms).
4. **The regression guard, executable** — the check CI runs: a small script that runs
   `explain (format json)` and asserts the plan property you're relying on (`"Node
   Type": "Index Scan"` under the key, or `Sort Method` ≠ `external merge`, or estimated
   rows within a factor of N of actual). Plans flip when data grows or stats drift —
   an assertion on the *property*, not on a timing (timings are noisy in CI; node types
   are stable).
5. **What it doesn't fix:** one honest sentence — the index speeds that predicate and
   costs every write; a *different* query in the same table may still seq-scan, and the
   guard you wrote watches one plan, not the workload.

---

*Criteria cross-check: both plans with real timings and rows-removed quoted, prediction
vs actual, sizes on disk ✓, annotated plan with the size-tripling prediction checked ✓,
choice table before execution with plan evidence per index, size summed, unhelped query
named ✓, before/after tied to measurement, executable plan-property guard, honest limits
✓.*
