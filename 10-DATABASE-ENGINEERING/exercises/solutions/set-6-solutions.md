# Solutions — Set 6: Database design → `database-design.md`

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.
> Executed on the authoring machine: PostgreSQL 18.6; captures from the lesson's probes and
> the shipped `shop` lab.

## Exercise 1 — Requirements → schema → catalog

A reviewer's paper schema for the course platform (one workable shape):

- `instructor(id pk, name, email unique)`
- `course(id pk, title, instructor_id not null fk → instructor)` — a course needs its
  author (mandatory side) unless your requirement says otherwise
- `enrollment(course_id fk → course, student_id fk → student, pk(course_id, student_id),
  enrolled_at default now())` — membership repeats, so the pair is the identity
- `lesson(id pk, course_id fk, position int check (position > 0), unique(course_id, position))`
- `completion(student_id, lesson_id, completed_at, pk(student_id, lesson_id))`

**DDL executed, then `\d` each table back** — the criterion is that every catalog row
maps to a requirement sentence: `unique(email)` ← "no duplicate accounts";
`unique(course_id, position)` ← "lessons ordered within a course";
`check (position > 0)` ← "positions start at 1". A constraint you cannot point back to a
sentence for is either (a) an invented rule — delete it, or (b) a rule you forgot to
write down — write it now; both outcomes are the review working.

## Exercise 2 — The denormalization decision, measured

**The measurement** (lesson's executed plan evidence): the report query on lesson-scale
data runs as a filter plan whose honest numbers were captured with
`explain analyze` — e.g. the index lesson's `13.164 ms` seq scan with
`Rows Removed by Filter: 99980` against `0.700 ms` for the indexed equivalent. That is
the *shape* of evidence required: a timing and a rows-processed figure, same data both
times.

**The update cost of storing the report in the row:** if `product.revenue` is a column,
every line insert must add to it — so a refunded/cancelled line, a corrected qty, or a
double-write race all desynchronize it. The bug scenario to spell out: two concurrent
`update product set revenue = revenue + 240` statements read the same old value (the
application-level lost update the isolation lesson *executes*: `150` clobbering `200`)
— the report is now wrong **and nothing in the database notices**, because the duplicate
violates no constraint.

**Verdict template:** keep normalized *until* the measured query misses its budget at
real volume *and* the write path can carry the sync with a single atomic statement (or a
transaction covering both writes). Flip condition: the measurement says X (say, p95 >
200 ms on production-shaped rows) — until then the duplicate is a permanent write cost
paid for a speculative read win.

## Exercise 3 — Reverse the shipped schema from the catalog

**`q4` (executed, reproduced by `verify.sh`):**

```
   child_table   | column_name | parent_table  | on_delete
------------------+-------------+---------------+-----------
 shop."order"    | customer_id | shop.customer | a
 shop.order_line | order_id    | shop."order"  | c
 shop.order_line | product_id  | shop.product  | a
 shop.product    | category_id | shop.category | a
(4 rows)
```

**`q5` (executed):**

```
           conname           |                                      expression
-----------------------------+---------------------------------------------------------------------------------------
 order_line_qty_check        | (qty > 0)
 order_line_unit_price_check | (unit_price >= (0)::numeric)
 order_status_check          | (status = ANY (ARRAY['new'::text, 'paid'::text, 'shipped'::text, 'cancelled'::text]))
 product_price_check         | (price >= (0)::numeric)
(4 rows)
```

**The mapping table** (nine rows minimum — object → requirement):

| Catalog object | Requirement sentence it enforces |
|---|---|
| `product_sku_key` unique | "SKUs identify products; never two products, one SKU" |
| `product_pkey` / all serial PKs | "every row is addressable and stably referenceable" |
| `order_line_order_id_fkey` + `on delete cascade` | "lines belong to an order; deleting an order takes its lines (a lineless order is meaningless)" |
| `order_line_product_id_fkey` | "no line may reference a product that doesn't exist" |
| `order_line (order_id, product_id)` unique | "the same product appears at most once per order (qty carries repetition)" |
| `product_category_id_fkey` (nullable) | "products may be unclassified at entry — optionality is a requirement, not an oversight" |
| `order_status_check` | "status is one of four business states — a closed set" |
| `price/qty/unit_price` checks | "money and quantities are non-negative — negatives come from bugs, not commerce" |
| `product.attrs jsonb default '{}'` | "attributes vary by product (switch type, panel Hz) — a flexible valve for sparse, heterogeneous facts" |

**What `attrs` must not become:** the escape hatch that ends modelling — if a field is
queried, joined, constrained, or reported on, it is a column (or a table). `jsonb` earns
its place only for the sparse *presentation* attributes; the moment you filter 50,000
rows by `attrs->>'switch'` you are back to needing a GIN index, which the NoSQL lesson
executes (`13.549 ms` seq scan over 50,004 rows before the index discussion) — the
flexibility was never free.

## Exercise 4 — Independent design review (reference shape)

What makes the five review Q&As credible: **answered from `\d` and `pg_constraint`
output, not memory**. The five reliable questions and the evidence each demands:

1. *"What breaks if requirement R changes?"* → show which constraint/col couples the
   tables; the catalog row is your exhibit.
2. *"Where does this attribute live?"* → `information_schema.columns` says which table —
   and your FD argument says why.
3. *"What happens when the parent is deleted?"* → `q4`-style query on *your* schema; the
   `on_delete` column is the answer, and you've run the delete.
4. *"Which key is natural, which surrogate, and why?"* → the key-choice column with
   reasons: natural when it's stable and truly unique (email — with the caveat that
   emails get recycled), surrogate when the natural key is volatile or wide.
5. *"What can the database not enforce here?"* → your set-9 preview: cross-row/timing
   rules, named with their application-side control.

---

*Criteria cross-check: paper schema before DDL with every constraint mapped to a sentence
✓, real timing captured with the staleness scenario spelled out and a flip condition ✓,
`q4`/`q5` mapped into a ≥9-row table with the `attrs` boundary sentence ✓, five review
Q&As answered from catalog evidence ✓.*
