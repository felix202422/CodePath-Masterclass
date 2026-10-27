# Solutions — Set 5: Joins and subqueries → `joins-and-subqueries.md`

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.
> Executed on the authoring machine: PostgreSQL 18.6; captures from the lesson's probes and
> the shipped `shop` lab (`verify.sh`).

## Exercise 1 — Inner vs left, counts predicted first

**Prediction:** products without a category appear under `left join` and vanish under
`inner join`. **Executed on `shop`** (this batch):

```
 inner_join_rows
-----------------
               3

 left_join_rows
----------------
              4
```

And the lesson's own query, `q3` (reproduced by `verify.sh`), names the retained row:

```
 id |   name
----+-----------
  4 | Desk Lamp
(1 row)
```

**The retention table** (draw it, don't memorize it):

| match | inner | left |
|---|---|---|
| yes | kept | kept |
| no (left side) | dropped | **kept, right side NULL** |

Right join is the mirror (right side kept, left NULL-ed); full outer is both sides kept.
The lesson's executed reconciliation — inner 8, left 8-with-coalesced-0s, right/left
equivalence `10 = 10`, cross join 32 — is this same table at row counts.

## Exercise 2 — The multi-join money query, traced first

**Hand-trace before running** (seed read as tables): order 1 = Ada → KBD-001 ×2
@120.00 = 240.00, STN-001 ×1 @39.00 = 39.00; order 2 = Grace → MON-271 ×1 @310.00.
**Executed:**

```
  full_name   |   sku   | qty | line_total
--------------+---------+-----+------------
 Ada Lovelace | KBD-001 |   2 |     240.00
 Ada Lovelace | STN-001 |   1 |      39.00
 Grace Hopper | MON-271 |   1 |     310.00
(3 rows)
```

Three for three against the trace. **Why the money doesn't follow today's price:**
`unit_price` lives on the *line* — it is the price the two parties agreed at order time.
If KBD-001 is repriced to 149.00 tomorrow, this historical report must still say
240.00; joining `product.price` instead would silently rewrite history (and break
invoice-grade correctness). The line's frozen value is a design decision the schema
enforces by *where the column lives*.

## Exercise 3 — Subquery ladder, three predictions

| Subquery | Predicted | Notes from execution |
|---|---|---|
| scalar: products above average price | 1 row (MON-271 at 310.00; avg of 120/310/39/27 = 124.00) | `select … where price > (select avg(price) …)` — aggregate computed once, then compared |
| `in` subquery: products in a category that has orders | 3 rows (categories 1–3 have orders; Desk Lamp's NULL category is never equal-matched) | the lesson's executed IN version returned the same 6 names as EXISTS — the equivalence worth proving once |
| correlated: order lines whose line total exceeds the overall average line total | 2 rows (240.00 and 310.00 exceed avg (240+39+310)/3 = 196.33) | the outer row is re-evaluated per inner row — the definition; time it against the set-based rewrite to *see* the difference at volume |

**Rewritten as a join with identical results:** the correlated `exists` becomes
`join (select … group by …) x on x.key = outer.key` — the lesson's executed pair shows
both forms returning the same 6 names. Rule of thumb you can now defend: correlated =
readable for single-row lookups; set-based = predictable cost at volume — decide with
`explain analyze`, not taste.

**The error you must not skip:** joining two tables that share a column name without an
alias qualification raises `ERROR: column reference "id" is ambiguous` — captured in the
lesson. The fix is the habit: alias every table the moment the query has two sources.

## Exercise 4 — Investigating "the total looks wrong" (reference shape)

The three queries a reviewer expects, each with expected output written first:

1. **The customer's lines, unaggregated** — `select o.id, p.sku, ol.qty, ol.unit_price
   from … where c.email = '…'`. Expectation: N rows whose *sums* should equal the claim.
2. **The aggregate from two directions** — `sum(qty * unit_price)` per order vs the
   stored/computed total you distrusted. Expect: identical; if not, one side includes
   something (shipping? a discount?) the other doesn't — name it from the rows.
3. **The join fan-out check** — `count(*)` vs `count(distinct ol.id)` for the same
   filter. Expect: equal; if `count(*)` is larger, a join multiplied rows (the classic
   "total too high" cause) and the fix is the join condition, not the math.

**The honest limitation:** these three can prove *where* the number diverges, but not
*which side is the business truth* — if a discount table exists and query 1 doesn't join
it, your evidence is complete and your conclusion still wrong. The question your three
queries cannot answer: *what should the total have been?* — that lives in the
requirements, not in the data.

---

*Criteria cross-check: two counts predicted then captured (3 vs 4) with the retention
table ✓, paper trace before execution matching all three rows with the freeze explained ✓,
three predictions vs three subquery results + the ambiguous-column error ✓, three
queries with written expectations and the un-answerable question named ✓.*
