# Solutions — Set 4: Filtering and aggregation → `filtering-and-aggregation.md`

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.
> Executed on the authoring machine: PostgreSQL 18.6; captures quoted from the lesson's
> probes and the shipped `shop` lab.

## Exercise 1 — Operator sweep, counts predicted first

The lesson's executed ladder (scratch table, 8 rows) supplies the receipts that matter:

- `not (price >= 120)` → **4 rows** — the trap being that `not` around a range does
  *not* include NULL (unknown is not true, so not-false isn't true either).
- `= null` → **0 rows**, every time — predicted, executed, explained: comparison with
  unknown is unknown, and `where` keeps only true.

On `shop` itself, the sweep's honest counts: 4 products, prices `120 / 310 / 39 / 27` —
"between 30 and 150" → **2** (KBD, STN), "not category 1" → **3**, `sku like 'M%'` →
**1** (MON-271), the combination "price ≥ 30 and category is not 1" → **2** (KBD, STN —
Desk Lamp's `null` category fails the predicate *not* the negation, so it is excluded).

**Precedence note:** `price >= 30 and not category = 1` parses as
`price >= 30 and (not (category = 1))`; wrapping the negation in parentheses did not
change *this* result — the mismatch appears when you add a NULL-category row and
discover `not (null = 1)` is still unknown. Predicting both counts is what exposes it.

## Exercise 2 — Group and filter groups

**Predicted:** all categories with revenue, then only those `> 100`. **Executed** (the
lab's `q7`, reproduced by `verify.sh`):

```
  category   | revenue
-------------+---------
 displays    |  310.00
 peripherals |  240.00
 furniture   |   39.00
(3 rows)
```

With `having revenue > 100` the `furniture` row drops → **2 rows**. The `where` vs
`having` rule in one line each: **`where` filters rows before grouping; `having`
filters groups after aggregation** — that is also why `having sum(qty * unit_price) > 100`
is legal (aggregate in `having`) while `where sum(...)` is refused with
`aggregate functions are not allowed in WHERE`.

## Exercise 3 — The NULL traps, three captures

| Statement | Predicted | Executed | Rule |
|---|---|---|---|
| `where credit = null` | 0 rows | **0 rows** | `=` with unknown yields unknown; `where` keeps only true |
| `where id not in (select customer_id from orders)` where one `customer_id` is NULL | "all non-ordering customers" | **0 rows** — *the whole predicate is unknown* | `x <> null` is unknown for that element, so `all(...)` is unknown, so no row is true |
| the `coalesce` / `is not null` fix | the expected customers | rows return | make the unknown irrelevant: `where customer_id is not null` in the subquery, or `coalesce(col, default)` where you mean "treat unknown as X" |

The one-sentence version for your notes: **SQL answers "is this row true?", not "is this
row not false?"** — unknown loses in both traps, which is why `not in` over any
subquery that *can* contain NULL is a bug, not a style issue.

## Exercise 4 — Zero-including monthly report (reference shape)

```sql
select coalesce(c.name, '(none)') as category,
       coalesce(sum(ol.qty * ol.unit_price), 0) as revenue
  from shop.category c
  left join shop.product p on p.category_id = c.id
  left join shop.order_line ol on ol.product_id = p.id
 group by c.name
 order by revenue desc;
```

**The executed count pair** (from this batch, on `shop`): the product↔category join
returns **3 rows inner, 4 rows left** — the unclassified Desk Lamp is exactly the row
`left join` retains and `inner join` drops; the same retention rule applies one level up
to categories with zero lines.

On the shipped seed every category *has* revenue, so the "visible zero" claim needs one
deliberate step: `insert into shop.category (name) values ('lighting')` — predicted row:
`lighting | 0.00` (from `coalesce`, not from a real line). The criterion is that the row
**exists and reads 0**, instead of being absent — an absent row and a zero row are
different reports, and only one of them lets a stakeholder see the new category.

---

*Criteria cross-check: four predicted counts vs executed ✓, two predictions vs `q7` and
its `having` variant ✓, three captures with the three-valued explanation ✓, the report
predicted as a row list with the inner/left count pair as evidence ✓.*
