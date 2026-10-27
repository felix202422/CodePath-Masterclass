# Solutions — Set 9: Constraints and relationships → `constraints-and-relationships.md`

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.
> Executed on the authoring machine: PostgreSQL 18.6; every rejection quoted is a real capture
> from the lesson's probe battery.

## Exercise 1 — The full battery, five rejections

The lesson's executed battery (scratch table, each violation run for real):

```sql
create table account (
  id     integer primary key,
  email  text not null,
  label  text unique,
  balance numeric not null check (balance >= 0)
);
```

| Violation | Verbatim core of the capture | Constraint named in the message |
|---|---|---|
| `insert (…, null, …)` into `email` | `null value in column "email" violates not-null constraint` | the column's `not null` |
| second row with the same `label` | `duplicate key value violates unique constraint "account_label_key"` | `account_label_key` |
| `balance = -5` | `new row for relation "account" violates check constraint "account_balance_check"` | `account_balance_check` |
| duplicate `id` | `duplicate key value violates unique constraint "account_pkey"` | the PK |
| orphan FK (lesson 1's) | `insert or update on table "orders" violates foreign key constraint …` + `DETAIL` | the FK |

Plus the lesson's extras worth having: defaults proven with `returning` (the value you
didn't supply comes back), and the FK added *after* the fact with `alter table … add
constraint … foreign key` — refused when bad rows already exist, which is exactly the
proof that the constraint is the database's memory, not a startup check.

## Exercise 2 — Diagnostic triage

| Message (match first, run second) | Fix layer |
|---|---|
| `invalid input syntax for type integer: "abc"` | **data** — the value can never be that type; convert or reject at input |
| `violates check constraint "…_balance_check"` | **data vs rule** — value fits the column but not the business rule; fix the value or revisit the rule |
| `null value in column "email" violates not-null` | **data** (or the app's optional-field handling); if nulls are legal, the *schema* is wrong |
| `duplicate key value violates unique constraint "…_email_key"` | **data**, but the UX bug is upstream: show the "account exists" path, don't swallow the error |
| `violates foreign key constraint "…_fkey"` | **SQL statement order** (parent first) or **data** (a typo'd id); `DETAIL` says which |

Two of the five reproduced to confirm the diagnosis — the point of predicting the layer
*before* running is that identical-looking symptoms (a "wrong value" error) land in three
different layers, and each layer's fix belongs in a different place (input validation /
statement / schema change).

## Exercise 3 — Adding `not null` to a table with NULLs

Executed sequence and why each step exists:

```sql
alter table t add column flag boolean;          -- (a) new column: nullable, no rewrite surprise
update t set flag = false where flag is null;   -- (b) backfill — in batches on real volume
alter table t alter column flag set not null;   -- (c) now the catalog flips
```

- **Step (a) refused?** No — adding a nullable column always works. The refusal is
  `set not null` while NULLs remain:
  `column "flag" contains null values`.
- **Row counts before/after** (the criterion): `count(*)` unchanged by (a) and (c);
  `count(*) filter (where flag is null)` is non-zero after (a), **0** after (b) — that
  zero is the gate for (c).
- **The sentence for your notes:** `attnotnull` flipping from `f` to `t` is a
  *schema-level* event — it changes what every future writer is allowed to send, which
  is why it comes *after* the data is ready, never before.

## Exercise 4 — The constraint audit of `shop` (independent)

**Enforced rules, from catalog queries only** (`q4`, `q5`, plus `pg_constraint` index
rows) — the table you build looks like set 6's, with the audit's two extra columns
(`enforced by`, `what it rejects`). Eight-plus rows come from: 5 primary keys, 5 unique
(5 serial sequences are *not* unique — the keys are: `customers_email_key`,
`product_sku_key`, the junction's composite, …), 4 FKs, 4 checks, `not null` on every
`not null` column. Re-run `q4`/`q5` in your audit; they are two-thirds of the evidence.

**Rules the database cannot express — each demonstrated live:**

1. *"An order must contain at least one line."* Execute: `begin; insert into
   shop."order" (customer_id) values (1); commit;` → **succeeds**. The database has no
   "row exists in another table" constraint (a `check` sees one row; an FK points the
   other direction). Enforcement place: application transaction (insert order + first
   line together) or a constraint trigger.
2. *"A customer may not order their own product"* — or any cross-row/cross-table
   invariant: insert it and watch zero rejections. Enforcement: application logic,
   tested.
3. *"A slot must be in the future"* — `check` cannot read the clock meaningfully (it
   evaluates against a value, and `now()` frozen at insert ages instantly).

**The honest control for each:** state the application-side rule, the transaction that
keeps it atomic, and the test that fails when someone removes it — a database that
enforces everything it can see, plus a tested app that enforces the rest, is the full
answer; either half alone is the defect.

---

*Criteria cross-check: five verbatim rejections with constraint names quoted ✓, the
five-way layer match written before reproduction with two confirmed ✓, failed `set not
null` + backfill + counts + `attnotnull` as a schema event ✓, ≥8-row enforced table from
catalog evidence with ≥2 un-expressible rules each shown accepted by the database and
given an application control ✓.*
