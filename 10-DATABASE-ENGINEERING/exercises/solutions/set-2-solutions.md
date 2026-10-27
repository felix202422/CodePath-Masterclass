# Solutions — Set 2: Relational databases → `relational-databases.md`

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.
> Executed on the authoring machine: PostgreSQL 18.6 scratch cluster; captures quoted from
> the lesson's probes and the shipped `shop` lab.

## Exercise 1 — One-to-many under the engine

**Prediction first** (written before running): valid pair *succeeds*; orphan *fails*;
`restrict` delete *fails* with the parent intact.

**Executed, the default rejection** (lesson probe):

```
ERROR:  update or delete on table "customers" violates foreign key constraint "orders_customer_id_fkey" on table "orders"
DETAIL:  Key (id)=(1) is still referenced from table "orders".
```

**Executed, `on delete cascade`** — child count `1 → 0` with the parent's delete
returning success. **Executed, `on delete set null`** — the FK column flips to NULL on
the child row instead of dying with the parent.

Three for three against the prediction. The referential action is not a cleanup
preference: `restrict`/`no action` (the default) makes orphaning *impossible*, `cascade`
makes deletion *transitive*, `set null` makes it *soft*. `\d orders` quotes the action
back to you — read it before debugging a delete.

## Exercise 2 — Many-to-many through a junction

**The junction DDL shape:**

```sql
create table order_line (
  order_id   integer not null references "order"(id),
  product_id integer not null references product(id),
  primary key (order_id, product_id)      -- the pair is the identity
;
```

**Duplicate pair, rejected (executed):** inserting the same
`(order_id, product_id)` twice:

```
ERROR:  duplicate key value violates unique constraint "order_line_pkey"
DETAIL:  Key (order_id, product_id)=(1, 2) already exists.
```

**The three-table join, traced then executed** — hand-trace first (order 1 contains
KBD-001 ×2 and STN-001 ×1), then:

```
  full_name   |   sku   | qty | line_total
--------------+---------+-----+------------
 Ada Lovelace | KBD-001 |   2 |     240.00
 Ada Lovelace | STN-001 |   1 |      39.00
 Grace Hopper | MON-271 |   1 |     310.00
(3 rows)
```

(The lab's own money query — `verify.sh` reproduces it via `q2`/`q7`.) The join goes
customer → order → line → product: the junction carries both FKs, so *both* directions
are one join away.

## Exercise 3 — One-to-one via a unique foreign key

```sql
create table profile (
  user_id integer primary key references "user"(id)   -- PK alone: one row per user
);
```

The lesson's execution: a **second profile for the same user was rejected** — the
`primary key` on the FK column is both the identifier *and* the uniqueness proof, so no
separate `unique` is needed when the FK is already the PK. Read back from the catalog:

```
Indexes:
    "profile_pkey" PRIMARY KEY, btree (user_id)
Foreign-key constraints:
    "profile_user_id_fkey" FOREIGN KEY (user_id) REFERENCES "user"(id)
```

**One sentence on why `unique`, not a separate table:** in SQL the *shape* of one-to-one
is simply a child table whose key is also unique — you add a `unique` constraint when the
FK is not already the key (say, `user_id` plus a nullable `secondary_id` arrangement).
There is no `one-to-one` keyword because none is needed: cardinality falls out of key
uniqueness, which is exactly what the engine enforces.

## Exercise 4 — Three relationship sentences (reference shape)

| Sentence | Cardinality + optionality | Shape | Executed rejection |
|---|---|---|---|
| students ↔ sections | many-to-many, both optional-ish | junction `enrollment(student_id, section_id)` with PK on the pair, plus its own attributes (`role`, `joined_at`) | duplicate enrollment → `duplicate key … enrollment_pkey` |
| doctors ↔ patients | many-to-many with history | junction `visit(doctor_id, patient_id, seen_at)` — **not** a plain pair-key: visits repeat, so the pair isn't the identity (its PK is `id`, with `unique (doctor_id, patient_id, seen_at)`) | two visits in the same minute → unique rejection |
| tracks ↔ playlists | many-to-many with ordering | junction `playlist_track(playlist_id, track_id, position)` | duplicate `(playlist, track)` → PK rejection; position collisions → `unique (playlist_id, position)` if you want ordered distinctness |

The design call worth writing down: the junction's **identity** (what "duplicate" means)
differs per case — pair-only for pure membership, an own id when the same pair recurs
with a timestamp. The engine enforces whichever you declare; choosing it *is* the
modelling work.

---

*Criteria cross-check: predictions written before all three attempts ✓, the referential
action quoted from `\d` and stated in words ✓, duplicate pair rejected verbatim ✓, join
hand-traced before execution ✓, three diagrams with optionality words and one rejection
per relationship ✓.*
