# Exercises — 10 Database Engineering

**Lessons:** this subject's seventeen lessons, in order.
**How to use these sets:** attempt first; solutions live in
[solutions/](solutions/README.md) behind a warning. The 15-minute rule from
[learning-method](../../00-START-HERE/learning-method.md) applies — record which hint you used.

Sets 1–12 correspond to the lessons named in their titles and mirror each lesson's exercise
ladder (introductory → intermediate → independent) with observable completion criteria.
Completing all twelve sets *is* this subject's half of the milestone gate in
[ROADMAP.md](../../ROADMAP.md) Milestone 6 ("all SQL sets against a real PostgreSQL
instance").

**The lab you need.** Every set runs against a database you may destroy and recreate at
will. The subject ships its own:

```bash
cd 10-DATABASE-ENGINEERING/postgresql
createdb shop_lab
psql -v ON_ERROR_STOP=1 -d shop_lab -f scripts/01-schema.sql
psql -v ON_ERROR_STOP=1 -d shop_lab -f scripts/02-seed.sql
bash verify.sh          # 7 passed, 0 failed — your server matches the captures
```

The `shop` schema (5 tables, the lesson's exact DDL) is what most sets query; scratch
schemas (`create schema scratch;`) are where you build and break things. Setup details,
connection variables, and re-capture instructions are in the lab's
[README](../postgresql/README.md) and [LABS.md](../../LABS.md). Authoring transcripts ran
against **PostgreSQL 18.6 / psql 18.6** — policy matches [VERSIONS.md](../../VERSIONS.md):
where your versions differ, the *behaviour* is the criterion and the exact text is yours
to capture.

**Predict before you run.** Every set below that says "predict" means paper first: write
the rows you expect *before* pressing Enter — a prediction you did not write down is not a
prediction. Every rejection you trigger must be quoted verbatim with its error message;
the message is the evidence.

---

## Set 1 — Database fundamentals → `database-fundamentals.md`

1. Identity and catalog: capture `select version()`, `current_user`,
   `current_database()`; then list every column, type, and nullability of `shop.product`
   from `information_schema.columns` — predict the three rows before running.
   **Criteria:** four captured outputs; the client/server path written (your keystroke →
   connection → parser/plan → executor → rows), naming where each of your four queries
   travelled.
2. The three guard rejections, executed: insert `'not-a-number'` into a `numeric`
   column, insert a duplicate primary key, insert an orphan foreign key — capture each
   error verbatim and name the layer that rejected it (type system / PK / FK).
   **Criteria:** three verbatim errors, each labelled with its layer and its fix (change
   the value; change the id; insert the parent first — or fix the data you meant).
3. NULL arithmetic: on a table where one row's numeric column is NULL, capture
   `col + 1` for that row and `count(*)` vs `count(col)` — predict both first.
   **Criteria:** two predictions vs two results; one sentence stating what NULL is
   (*unknown*, not empty or zero) and why `coalesce` is a decision, not a patch.
4. **Independent:** from a written requirement ("a clinic books patients with a
   preferred practitioner; appointments may have no practitioner yet"), create the tables,
   then prove each column's intent by breaking it — wrong type, taken slot key, missing
   reference — and write which rule you *could not* express in SQL at all.
   **Criteria:** schema executes; three rejections captured; the un-expressible rule
   named with its enforcement place (application) and why that split is honest.

## Set 2 — Relational databases → `relational-databases.md`

1. One-to-many under the engine: `customer → order` in a scratch schema with an FK;
   insert a valid pair, then an orphan (captured rejection), then delete the parent under
   `restrict` — predict which of the three attempts fails before running.
   **Criteria:** three attempts with outcomes predicted first; the referential action
   quoted from `\d` and stated in words ("the engine refuses to orphan the child").
2. Many-to-many through a junction: model `order ↔ product` with
   `unique (order_id, product_id)`; insert the same pair twice (captured rejection), then
   write the three-table join that answers "what did order 1 contain?".
   **Criteria:** the duplicate rejection verbatim; the join hand-traced on paper (expected
   rows drawn) before execution; executed result matching the trace.
3. One-to-one via a `unique` foreign key (a user with at most one profile); prove the
   second profile is rejected, then read the constraint back from the catalog
   (`pg_constraint` or `\d`).
   **Criteria:** the rejection captured; the catalog row quoted; one sentence on why
   `unique` on the FK — not a separate table — expresses one-to-one in SQL.
4. **Independent:** given three relationship sentences (students ↔ sections, doctors ↔
   patients, tracks ↔ playlists), draw each as cardinality + optionality, choose the
   table shape, and execute one rejection per relationship as evidence the shape holds.
   **Criteria:** three diagrams with the optionality word written (mandatory/optional);
   three executed rejections; one case where you changed your first design and why.

## Set 3 — SQL fundamentals → `sql-fundamentals.md`

1. The read ladder on `shop`: predict, then execute — every product with price and sku;
   names only, ordered by price descending; the first two rows; distinct statuses of
   `shop."order"`.
   **Criteria:** four predicted row-sets (rows *and* order written out) vs four executed
   results; any mismatch explained by the rule it violated (ordering before `order by`,
   `limit` applying after sort).
2. Expressions and aliases: compute `qty * unit_price` as `line_total` for every order
   line with the customer's name beside it; capture the result set.
   **Criteria:** predicted totals for the three seeded lines (`240.00`, `39.00`,
   `310.00`) written before running; the alias rule stated (the header shows the alias,
   not the expression).
3. Write statements with receipts: `insert … returning`, `update … returning`, and a
   `delete` scoped by a `where` you can count before and after (`count(*)` around each).
   **Criteria:** three `returning` captures; before/after counts for the delete; one
   sentence on why an unscoped `update` is a bug waiting for a data change.
4. **Independent:** build a scratch schema with 20+ rows of your own data, then answer
   five written questions about it — each answer predicted on paper first, executed
   second, mismatch explained.
   **Criteria:** five prediction pairs; the schema + seed as one runnable file; one
   deliberately tricky question of your own with its answer verified.

## Set 4 — Filtering and aggregation → `filtering-and-aggregation.md`

1. Operator sweep on `shop`: products priced between two bounds, statuses that are
   *not* `new`, skus matching a `like` pattern, and a range combined with a negation —
   predict the row count of each before running (`count(*)` proves you).
   **Criteria:** four predicted counts vs four executed counts; the operator-precedence
   note written for the combined one (why the parentheses changed the result).
2. Group and filter groups: revenue per category (the lab's `q7` query), then the same
   with `having revenue > 100` — predict both result sets first.
   **Criteria:** two predictions vs two captures; the `where`-vs-`having` rule stated in
   one line each (rows in, groups out).
3. The NULL traps, executed: `= NULL` matching nothing; `not in` with a NULL in the
   subquery returning *no* rows; the `coalesce` fix returning the expected rows.
   **Criteria:** three captures (empty result, empty result, fixed result); the
   three-valued logic explanation in one sentence — why `x <> all(...)` is unknown when
   one element is unknown.
4. **Independent:** a reporting query for "monthly revenue per category including
   categories with zero orders" (a `left join` + `coalesce`), predicted on paper as a row
   list, executed, with the zero-row visibly zero and not absent.
   **Criteria:** predicted rows written first; executed result matching; the `left join`
   vs `inner join` row-count difference proven with a `count(*)` pair.

## Set 5 — Joins and subqueries → `joins-and-subqueries.md`

1. Inner vs left: products without a category must appear under `left join` and vanish
   under `inner join` — predict both counts, then prove with the lab's `q3` query and an
   inner-join variant.
   **Criteria:** two predicted counts, two captures; the join-type rule written as a row
   retention table (match / no-match × inner / left).
2. The multi-join money query (the design lesson's Example 2): hand-trace the three
   seeded rows with their line totals *before* running, then execute `q`-style joins and
   compare line by line.
   **Criteria:** the paper trace (names, skus, totals) before the run; executed output
   matching all three rows; the `unit_price` freeze explained (why line money doesn't
   follow today's price).
3. Subquery ladder: a scalar subquery (average price), an `IN` subquery (products in a
   category that has orders), and a correlated subquery (orders whose total exceeds the
   overall average) — predict which return rows before each run.
   **Criteria:** three predictions vs three captures; the correlated row-by-row re-run
   described in your own words; one version rewritten as a join with identical results.
4. **Independent:** investigate an anomaly ("customer X's total looks wrong"): write the
   three queries that would prove or disprove it, each with the expected output written
   first, then execute and conclude from the evidence alone.
   **Criteria:** three query/prediction pairs; a conclusion citing only executed rows; the
   one question your three queries *cannot* answer, named honestly.

## Set 6 — Database design → `database-design.md`

1. Requirements → schema: given a written requirement (an online course platform:
   courses, instructors, enrollments, lesson completion), write the tables, keys, and
   constraints on paper, then execute the DDL and `\d` each table back.
   **Criteria:** paper schema before DDL; five catalog outputs; every constraint mapped
   to the requirement sentence that demanded it.
2. The denormalization decision, measured: take the report query from set 4, measure it
   on `shop` (`explain analyze`), then write the *update* cost of storing the report's
   value in the row — with the sync bug scenario spelled out.
   **Criteria:** a real timing capture; the cost paragraph (which writes would go stale);
   your verdict (keep normalized / denormalize) with the trigger condition ("when the
   measurement says X").
3. Reverse the shipped schema: run the lab's `q4` and `q5` (foreign keys, check
   constraints) against `shop` and map every catalog row to the requirement it enforces —
   including `product.attrs`, the schema's one deliberate flexibility valve.
   **Criteria:** both captures; a mapping table ≥9 rows (object → requirement); one
   sentence on what `attrs` must *not* be used for ("no schema at all").
4. **Independent:** design a schema for a domain of yours (from a job, a hobby, a game),
   justify surrogate-vs-natural keys per table, execute the DDL, and stage a design
   review: a reviewer asks "what breaks if this requirement changes?" — answer five such
   questions from your catalog output.
   **Criteria:** the DDL executes; the key-choice column with reasons; five review
   Q&As answered from `\d`/`pg_constraint` evidence, not memory.

## Set 7 — ER diagrams → `er-diagrams.md`

1. Diagram → DDL: from a provided ER diagram (three entities, one one-to-many optional,
   one many-to-many), write the DDL, execute it, and `\d` the junction table to confirm
   the composite key.
   **Criteria:** DDL executes; the composite PK confirmed in catalog output; every
   diagram line (cardinality marker, optionality dot) reflected in a nullability or
   constraint you can point at.
2. DDL → diagram, from the *live* database: derive an ER diagram for `shop` using only
   catalog queries (tables + column counts, FKs with their actions, optionality from
   `attnotnull`), written as a valid mermaid `erDiagram`.
   **Criteria:** the three catalog captures feeding the diagram; the mermaid source
   parses (render it); every relationship's `||`/`o|` markers justified by a catalog row.
3. Round-trip check: take your diagram from exercise 2 and re-derive three catalog facts
   from it (which FK is optional, which cascades, which side is mandatory) — then compare
   against fresh catalog output.
   **Criteria:** three predictions from the diagram vs three live outputs; any mismatch
   fixed *in the diagram* with the correction noted (the diagram serves the database).
4. **Independent:** ER diagram + DDL + one executed rejection for every relationship in a
   written requirement of yours, plus the two design questions a diagram review always
   asks: "where does this attribute live?" and "what happens to children when the parent
   is deleted?"
   **Criteria:** diagram parses; DDL executes; one rejection per relationship; both review
   questions answered by execution (the delete actually run).

## Set 8 — Normalization → `normalization.md`

1. Classify four given relations (some already normalized, some not) into 1NF/2NF/3NF by
   writing each relation's functional dependencies and determinant sets first — no
   execution needed for the verdict, but execute a violating update for each unnormalized
   one to show the anomaly it permits.
   **Criteria:** FD lists with keys named; the anomaly demonstrated per relation (update
   requiring N rows changed / one row un-updatable); the rule in one line per normal
   form.
2. The executed round trip: flatten `shop`'s three main tables into one denormalized
   table, insert the seeded data duplicated, then *show the anomaly* (change a category
   name — one of three rows updates), normalize back to three tables, and show the single
   update that now suffices.
   **Criteria:** the flat DDL + seed executes; the partial-update anomaly captured; the
   normalized fix captured with row counts proving consistency; the rows-lost-or-
   duplicated check (`count(*)` both sides).
3. Find candidate keys from data: given a table with a functional dependency hiding in
   its columns (e.g., `zip → city`), detect it with a `group by` query that finds
   violating groups (`count(distinct city) > 1` per zip proves it *not* a FD) and state
   the key.
   **Criteria:** the detection query with its output; the FD stated with determinants; the
   split into tables that makes the FD the key.
4. **Independent:** pick one attribute in your set-6 schema and argue *for*
   denormalizing it: the measurement you'd take, the write-path bug it could cause, the
   invalidation strategy if you proceed — then argue against, and write your verdict with
   the condition that would flip it.
   **Criteria:** the measurement plan (query + metric); the bug scenario concretely
   written; a verdict with a flip condition; no "it depends" without the two things it
   depends on.

## Set 9 — Constraints and relationships → `constraints-and-relationships.md`

1. The full battery on a scratch table: `not null`, `unique`, `check`, primary key, and
   foreign key — violate each one, capture each error verbatim, and quote the constraint
   name from the message.
   **Criteria:** five rejections with constraint names quoted; the table's DDL shown
   beside them; one sentence on constraint names being part of your debugging API.
2. Diagnostic triage: given five error messages (one type error, one check, one null
   violation, one unique, one FK), match each to its fix layer *before* running anything,
   then reproduce two of them to confirm your diagnosis.
   **Criteria:** the five-way match written first; two reproduced messages confirming it;
   the layer table (data / SQL statement / schema / application) with one fix per layer.
3. Constraints on existing data: add a `not null` to a column that already has NULLs —
   capture the failure, then the backfill + `set not null` sequence that succeeds, with
   row counts before and after.
   **Criteria:** failed `alter` captured; the backfill executed with counts; one sentence
   on why the catalog's `attnotnull` flipping is a schema-level event.
4. **Independent:** a constraint audit of `shop`: enumerate every rule the database
   enforces (from catalog queries only), then write the business rules it *cannot* express
   ("an order must contain at least one line", "a customer may not order their own
   product" — invent two of your own) with the enforcement place for each and a failing
   example showing the database lets it through.
   **Criteria:** the enforced-rules table from catalog evidence (≥8 rows); ≥2
   un-expressible rules each with an executed demonstration that the DB accepts the bad
   state; the application-side control named for each.

## Set 10 — Transactions · concurrency and isolation →
`transactions.md` · `concurrency-and-isolation.md`

1. Atomicity by hand: a two-account transfer inside `begin`/`commit` where you kill the
   block between the two `update`s (`rollback` as the crash) — predict both balances
   after each exit path, then execute.
   **Criteria:** predictions for commit-path and crash-path balances; both captures; the
   ACID letter this demonstrates stated with what "atomic" rules out (half a transfer).
2. Savepoints and the aborted-state rule: open a block, run a failing statement, watch
   the block enter the aborted state (the next statement's `current transaction is
   aborted` error — captured), roll back to a savepoint, and continue successfully.
   **Criteria:** the aborted-state message captured verbatim; the savepoint recovery
   transcript; one line on why `rollback to` — not a new `begin` — is the recovery move.
3. The isolation ladder, two sessions: run the same conflict (session A reads a value,
   session B changes and commits it, A reads again) under `read committed`,
   `repeatable read`, and `serializable` — capture A's two reads at each level and the
   error `serializable` raises.
   **Criteria:** a three-row table (level → second read / error) from captures; the
   anomaly each level permits named (non-repeatable read / phantom / serialization
   failure); the two-session method written (two psql prompts, explicit `begin`).
4. **Independent:** reproduce one real anomaly end to end — lost update or write skew —
   on your own schema, with the timing that triggers it, then fix it twice (isolation
   level, then application-side `select … for update` or atomic `update`), capturing both
   fixes and stating which you'd ship and why.
   **Criteria:** the anomaly captured with timestamps or ordering evidence; both fixes
   executed; the verdict with the cost each approach pays (throughput vs app
   complexity).

## Set 11 — Indexes · query plans and optimization →
`indexes.md` · `query-plans-and-optimization.md`

1. Measure, then index: on a large scratch table (100k rows like the lesson's), capture
   `explain analyze` for a selective filter *without* an index, create the index, capture
   it again — predict which plan (seq scan / index scan) before each run.
   **Criteria:** both plans with real timings and `Rows Removed by Filter` quoted; the
   prediction vs actual; the index's size on disk (`pg_relation_size`) beside the table's.
2. Read a plan you did not write: given a captured `explain (analyze, buffers)` of a join,
   name the join order, the inner/outer sides, the scan type of each node, and where the
   rows were filtered — then verify your reading by re-running with the same options.
   **Criteria:** the annotated plan (each node interpreted); one prediction of what
   changes if a table triples in size; the re-run confirming your reading.
3. Index choice under constraint: three queries on the same table (point lookup, prefix
   `like 'x%'`, sort by second column) — write which index(es) you'd create and which
   query each serves, create them, and confirm the planner uses each (plan evidence);
   record the total added bytes.
   **Criteria:** the choice table before execution; three plans showing the intended scan
   shapes; the size cost summed; one query your indexes do *not* help, named.
4. **Independent:** take the slowest query you actually have (or the lesson's report
   query scaled up), diagnose it with `explain analyze`, apply the *narrowest* fix that
   targets the measured bottleneck, re-measure, and write the regression guard — the plan
   fragment or timing threshold you'd assert in CI so the fix can't silently rot.
   **Criteria:** before/after captures with the same data volume; the fix tied to the
   measurement (not to taste); the guard written as an executable check (query + expected
   property); one honest "what this fix doesn't fix."

## Set 12 — Migrations · backups · security · NoSQL →
`migrations.md` · `backups-and-recovery.md` · `database-security.md` · `nosql-fundamentals.md`

1. Migration discipline: write the pair of migrations that adds a `not null` column with
   a backfill to a table that already has rows (add nullable → backfill in batches →
   `set not null`), execute them against your set-6 schema, and write the down
   migration — then argue whether you'd run the down in production.
   **Criteria:** the three-statement sequence executed with row counts between steps; the
   down migration written with its data-loss caveat; the batching note (why one giant
   `update` locks too long).
2. Backup and restore drill: `pg_dump` the lab database, drop it, restore from the dump,
   and prove integrity with the lab's `verify.sh` (or your own row-count + checksum
   queries) — capturing each step.
   **Criteria:** dump file created (size quoted); the deliberate drop; restored database
   passing verification; the logical-vs-physical distinction in two lines (what this dump
   does not capture — WAL, roles, config).
3. Least privilege, executed: create a read-only role, grant it `select` on `shop`'s
   tables, connect as it (or `set role`), capture a successful read and a denied write,
   then revoke and capture the now-denied read.
   **Criteria:** four captures (read ok, write denied, revoke, read denied); the grants
   quoted from `pg_roles`/`information_schema`; the default-privilege rule stated ("new
   objects inherit nothing until you say so").
4. **Independent:** the engine-choice memo: a written requirement with two access
   patterns (one key-document read, one multi-table aggregate) — decide relational vs
   document vs key-value *for each pattern*, execute the relational version of both
   queries as your baseline, and write the sentence that would flip your decision (what
   scale or shape change moves you off PostgreSQL); finish with the security checklist
   applied to your own set-6 deployment (password/auth, TLS, least privilege, backups on,
   migrations versioned — each with the command or setting you'd verify).
   **Criteria:** both baseline queries executed; a per-pattern verdict with reasons tied
   to query shape, not fashion; the flip condition written quantitatively; the checklist
   with one verification command per line, five lines minimum.

---

## Answer key

Solutions: [solutions/](solutions/README.md).

**⚠ Attempt the sets first.** Reading a solution gives recognition, not skill. If you
peeked, redo the affected exercise one week later without looking — that second attempt is
the one you keep.
