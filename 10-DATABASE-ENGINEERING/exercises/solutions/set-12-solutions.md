# Solutions — Set 12: Migrations · backups · security · NoSQL →
`migrations.md` · `backups-and-recovery.md` · `database-security.md` · `nosql-fundamentals.md`

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.
> Executed on the authoring machine: PostgreSQL 18.6 / psql 18.6. All quoted outputs are real
> captures from the lessons' probes.

## Exercise 1 — The add-not-null migration pair

**The executed sequence** (this lesson's pattern, run against a table with rows):

```sql
-- 0004_add_flag_not_null.sql
alter table t add column flag boolean;              -- (a) nullable: instant, no rewrite
update t set flag = false where flag is null;       -- (b) backfill — batches on real volume
alter table t alter column flag set not null;       -- (c) gate: fails while any NULL remains
create index on t (flag);                           -- (d) optional: after data exists
```

Captured: `count(*) filter (where flag is null)` = non-zero after (a), **0** after (b);
step (c) executed cleanly. **Why batches:** one giant `update` on a 50M-row table holds
locks (and WAL) for its whole duration — `where id % 1000 = 0`-style chunking with a
sleep bounds the lock window; the *schema* step (c) itself is metadata-only in modern
PostgreSQL but still needs an `ACCESS EXCLUSIVE` lock, so it waits for traffic to drain.

**The down migration, argued honestly:** for (a) the down is `alter column flag drop
not null` (safe, metadata-only); for (b) the down is `update t set flag = null where …`
— **data loss for any row written since deploy**, which is why the honest production
answer is "down = roll *forward* with 0005, not back" for anything that touched data.
The rule: reversible DDL is cheap; reversible *data* migrations are a claim about what
your users did in between, and usually false.

The lesson's runner evidence worth re-running: psql's single-transaction flag — without
`-1`, a two-statement file left `mig_note` with **1 of 2 inserts**; with `-1`, the whole
file rolled back and the table never existed. Migration atomicity is a tool setting, not
a hope.

## Exercise 2 — Backup and restore drill

**The executed drill** (lesson captures, verbatim sizes):

```console
$ pg_dump -Fc -f shop.dump codepath_lab          # custom format
$ psql -c 'drop schema shop cascade' -d codepath_lab
$ psql -c "select count(*) from shop.product"    → ERROR: relation "shop.product" does not exist
$ pg_restore -d codepath_lab shop.dump
$ psql -c "select count(*) from shop.product"    → 4   (customers=2, lines=3 — all back)
```

- **Three dumps of one database (executed):** `2,969,654 B` plain SQL /
  `1,039,646 B` custom (`-Fc`, compressed) / `9,896 B` with `-n shop` schema-scoped —
  the sizes *are* the argument for `-Fc` at scale, and the scoped dump is what makes the
  schema-drill above a 10-second recovery instead of a full-database event.
- **The integrity proof:** row counts (and/or `verify.sh`'s 7 queries) pass after
  restore — plus the sequence check: every restore's output includes `setval` lines
  (executed: `3 2 3 4 5` for the five shop tables), so the next insert continues the
  original numbering — no duplicate-key surprise on the first row after recovery.
- **The `pg_restore -l` pre-read:** five `SCHEMA` entries (cons, idx, norm, shop, txn)
  — you know what the restore will touch *before* it touches it.

**Logical vs physical in two lines:** a logical dump is *statements/rows* — portable
across machines and versions, restorable into a running server, but it captures **no
WAL, no roles, no config**, so it cannot replay a point in time between backups; physical
(WAL/base backup) recovery covers that window but is version- and platform-locked. The
lesson's honest line: this drill executed logical dump/restore; PITR is *cited*, not
executed here.

## Exercise 3 — Least privilege, executed

The lesson's run, four captures:

```console
create role reader nologin; grant select on shop.product to reader;
set role reader;  select count(*) from shop.product;    → 4          -- read ok
                insert into shop.product …             → ERROR: permission denied for table product
set role lab; revoke select on shop.product from reader;
set role reader;  select count(*) from shop.product;    → ERROR: permission denied for table product
```

Plus the three footnotes the criteria insist on:

1. **Sequences are separate objects** — the lesson's `permission denied for sequence
   note_id_seq` fired even with table `insert` granted: `serial` needs
   `grant usage on sequence …` too. A role that can insert but can't own the next id is
   a bug you find in production otherwise.
2. **Column-level grants** as a narrower cut: `body` readable while `secret` column
   returns `permission denied for column` — least privilege has a per-column setting.
3. **Defaults inherit nothing:** `create table …` under the admin gives the admin's
   grants; a brand-new role sees **zero** objects until granted (the `rolsuper/
   rolsuper`-style catalog check in the lesson: `analyst`, `reader` all `f` for
   `rolsuper`/`rolcreatedb`/`rolbypassrls`, and has-table-privilege moving `f f → t`
   only after the `grant`). New tables under `alter default privileges` are the *one*
   mechanism that changes "nothing by default" deliberately — and it must be set
   explicitly.

## Exercise 4 — The engine-choice memo + security checklist (reference shape)

**Baseline executed (relational, both patterns)** — your two queries against `shop`:
the key-shaped read (`where sku = 'KBD-001'` — 1 row, index-backed) and the aggregate
(`q7`-style revenue by category — 3 rows, group over a join). These are the numbers the
memo compares against.

**The NoSQL lesson's executed counterweights** (citing real captures rather than vibes):

- Document model *inside* PostgreSQL: `jsonb` `->` vs `->>` type split (jsonb `12` vs
  text `12`), `jsonb_typeof` distinguishing JSON `null` from a **missing key**, duplicate
  keys collapsing to the last value — the exact semantics a document store would impose,
  executed without leaving SQL.
- The containment query `@>` selecting **12,501 of 50,004 rows in 13.549 ms** as a seq
  scan — and the GIN discussion where **37,503 rows were discarded by filters** before
  the index question is asked. The trade is real: document flexibility with a GIN
  footprint vs relational rigidity with btrees.

**The per-pattern verdict** (template): *key-document read* — document store wins only
when the whole aggregate is read together, always, and the shape is stable (a product
catalog page); relational wins here because the same read is one index probe.
*Multi-table aggregate* — relational wins structurally: the engine was built to join;
the document version needs the data duplicated and a reconciliation story. **Flip
condition, quantitative:** "move to a document store when the document-shaped read is
>80% of traffic *and* p95 for the join-shaped report exceeds budget at production
volume *and* the duplication is owned by one writer" — three conditions, each measurable;
"when it gets slow" is not a flip condition.

**The security checklist, one verification command per line (five+):**

| Line | Verify with |
|---|---|
| password/auth | `pg_hba.conf` method + `select rolname from pg_roles where rolcanlogin` review |
| TLS on the wire | `show ssl;` → `on`, and `\conninfo` shows `SSL on` |
| least privilege | `has_table_privilege('reader','shop.product','select')` per role — expect exactly the grants you intended |
| backups on | the dump file's mtime *and* a restored-copy drill (an untested backup is a hypothesis) |
| migrations versioned | ledger table row count = file count (`select count(*) from schema_migrations` vs `ls migrations \| wc -l`) |
| rows-level isolation (bonus) | the lesson's RLS capture: `reader` sees **1 of 5** rows, superuser all 5 |

---

*Criteria cross-check: three-step sequence with counts between steps + down-migration
data-loss caveat + batching note ✓, dump/drop/restore/verify with sizes, `setval`, and
the logical-vs-physical line ✓, four captures with sequence and default-privilege
footnotes ✓, both baselines executed, per-pattern verdict with a quantitative flip
condition, checklist ≥5 lines with verification commands ✓.*
