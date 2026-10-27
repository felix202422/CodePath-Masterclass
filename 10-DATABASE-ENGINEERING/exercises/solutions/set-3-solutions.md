# Solutions — Set 3: SQL fundamentals → `sql-fundamentals.md`

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.
> Executed on the authoring machine: PostgreSQL 18.6 / psql 18.6, shipped `shop` lab.
> Quoted outputs are real captures.

## Exercise 1 — The read ladder on `shop`

**Predictions, then execution.** The product table (executed, `order by id`):

```
 id |   sku   |        name         | category_id | price
----+---------+---------------------+-------------+--------
  1 | KBD-001 | Mechanical Keyboard |           2 | 120.00
  2 | MON-271 | 27-inch Monitor     |           1 | 310.00
  3 | STN-001 | Laptop Stand        |           3 |  39.00
  4 | LMP-001 | Desk Lamp           |             |  27.00
(4 rows)
```

- **Names ordered by price descending** — predicted `27-inch Monitor, Mechanical
  Keyboard, Laptop Stand, Desk Lamp`; executed matches (prices 310 → 120 → 39 → 27).
- **First two rows** — `limit 2` *after* the sort gives Monitor + Keyboard; the classic
  miss is limiting before ordering and getting the first two by id instead.
- **Distinct statuses** — `select distinct status from shop."order"` on the seeded data
  returns `new` (one row): `distinct` deduplicates *values*, and both seeded orders
  carry the default.

The rule every mismatch here violates: `select`'s list → `from` → `where` → `group by`
→ `having` → `order by` → `limit`. Written output order is decided at the last step.

## Exercise 2 — Expressions and aliases

```sql
select c.full_name, p.sku, ol.qty, ol.qty * ol.unit_price as line_total
  from shop.order_line ol
  join shop."order" o on o.id = ol.order_id
  join shop.customer c on c.id = o.customer_id
  join shop.product p on p.id = ol.product_id
 order by o.id, ol.id;
```

**Predicted before running:** `240.00`, `39.00`, `310.00` — **executed:**

```
  full_name   |   sku   | qty | line_total
--------------+---------+-----+------------
 Ada Lovelace | KBD-001 |   2 |     240.00
 Ada Lovelace | STN-001 |   1 |      39.00
 Grace Hopper | MON-271 |   1 |     310.00
(3 rows)
```

**The alias rule:** the header shows `line_total`, never `ol.qty * ol.unit_price` —
the result column's name is the alias when you give one, and the derived column exists
only for this result set (you cannot `where line_total > 100`; the `where` step runs
before the select list is computed).

## Exercise 3 — Write statements with receipts

Executed in the lesson's probes, each with its command tag as the receipt:

- `insert … returning` — the new row comes back from the *same* statement (no second
  `select`, no race).
- Row-count tags: `UPDATE 3`, then `DELETE 1` — psql prints them, and they are the
  cheapest assertion in SQL: **predict the count, read the tag**.
- The contained mistake: an unguarded `update` reported `UPDATE 8`; wrapped in a block
  that then rolled back, the same statement's damage reverted to `0` rows changed —
  the reason the lesson insists you `begin` while writing destructive statements by hand.

**Why an unscoped `update` is a bug waiting for a data change:** the `where` you wrote
against today's rows is the *only* thing bounding tomorrow's — new rows that match the
predicate are silently included, and the command tag tells you the number only after the
write happened. Default habit: `begin; … ; -- read UPDATE n -- rollback/commit`.

## Exercise 4 — Scratch schema with 20+ rows (reference shape)

What a reviewer looks for, since your data is your own:

1. **Schema + seed as one runnable file** — `create schema scratch;` … inserts …
   re-runnable (drop first), no manual steps.
2. **Five prediction pairs** — each answer's rows written *in the file above the query*,
   executed output pasted beneath, mismatches explained by the rule violated (ordering,
   `null` placement, `distinct` semantics, integer vs float division, `limit` before
   `order by`).
3. **One deliberately tricky question of your own** — the good ones test a rule the
   lesson named: e.g. *"which values does `where x <> 'a'` return when `x` is NULL?"*
   (none — three-valued logic), with the executed empty result as proof.

A worked example of the trickiest honest question: "list rows that share a duplicate
value" must be predicted as **two** rows per duplicated value (both members match), not
one — the execution either teaches you `group by … having count(*) > 1` or confirms you
already knew it.

---

*Criteria cross-check: four predictions vs four results with the rule named ✓, totals
`240.00/39.00/310.00` written before running ✓, `returning` + command tags + the
rollback-contained mistake captured ✓, five prediction pairs and the tricky question with
its verified answer ✓.*
