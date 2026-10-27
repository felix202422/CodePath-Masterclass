# 10 — Database Engineering

This subject teaches how data is actually stored: relational modelling, the SQL language
from `SELECT` through joins and aggregation, and the design discipline (keys, constraints,
normalization, transactions) that keeps a database correct once real traffic and real
mistakes arrive. Everything here runs against a real PostgreSQL server — the lessons' value
is in executed queries and their honest outputs, not in syntax shown on a slide.

## What this subject covers

- Database fundamentals: tables, rows, columns, types, Primary/foreign keys, and the
  client/server path a query travels.
- Relational databases: relationships (one-to-one, one-to-many, many-to-many), referential
  integrity, and what the engine enforces for you.
- SQL fundamentals: `CREATE`, `INSERT`, `SELECT`, `WHERE`, ordering and limiting — with
  every statement executed and its result captured.
- Filtering and aggregation: comparison and logical operators, `GROUP BY`, `HAVING`,
  aggregate functions, and `NULL`'s three-valued logic.
- Joins and subqueries: inner/left/right/full joins, multi-join queries, derived tables
  and correlated subqueries.
- Database design: turning requirements into a schema, keys, and the cost/benefit line of
  denormalization.
- ER diagrams: entities, attributes, cardinality, and reading a diagram back into DDL.
- Normalization: first, second, and third normal form — with an executed
  denormalization-and-repair round trip.
- Constraints and relationships: `NOT NULL`, `UNIQUE`, `CHECK`, foreign keys, and the
  failures they reject (each rejection captured).
- Transactions: ACID, `BEGIN`/`COMMIT`/`ROLLBACK`, isolation levels, and the concurrency
  anomalies each level permits.
- Indexes, query plans, and the practical performance surface a backend developer must read.
- Migrations, backups, and recovery: versioned schema change, logical dump/restore drills,
  and the honest line between what a dump covers and what it does not.
- Security: roles, grants down to column and sequence level, and row-level policies —
  each denial captured.
- NoSQL fundamentals: document semantics executed against `jsonb`, and the access-shape
  argument for when relational is and is not the right engine.

## Why it matters

Every application that remembers anything is a database with a frontend attached. The
failure modes are structural, not cosmetic: a missing foreign key turns a typo into
corrupt data, a wrong normalization decision makes an update unsynchronizable, a skipped
transaction turns one business action into half-recorded state, and an unindexed join
only fails when real volume arrives. PostgreSQL is the industry's most widely deployed
open-source relational engine, so the SQL and the reasoning transfer to MySQL, SQLite, and
the warehouses built on the same model.

## Prerequisites

- [02-PROGRAMMING-FUNDAMENTALS](../02-PROGRAMMING-FUNDAMENTALS/README.md) — variables,
  data types, tables, and loops; SQL's mental model assumes them.
- [06-INTERNET-AND-WEB-FOUNDATIONS](../06-INTERNET-AND-WEB-FOUNDATIONS/README.md) — helpful:
  the client/server model is exactly how `psql`/your app talks to the engine.

## Lessons

Versions pinned in [VERSIONS.md](../VERSIONS.md); transcripts run against **PostgreSQL 18**
on the authoring machine, with the machine's seams recorded honestly in each lesson.

- `database-fundamentals.md` · `relational-databases.md` · `sql-fundamentals.md`
- `filtering-and-aggregation.md` · `joins-and-subqueries.md`
- `database-design.md` · `er-diagrams.md` · `normalization.md`
- `constraints-and-relationships.md` · `transactions.md`
- `indexes.md` · `query-plans-and-optimization.md` · `concurrency-and-isolation.md`
- `migrations.md` · `backups-and-recovery.md` · `database-security.md` ·
  `nosql-fundamentals.md`

## Exercises and practice

`exercises/` holds the query sets — each mirrors its lesson's ladder (introductory →
intermediate → independent) with observable completion criteria: predicted result first,
executed result second, every mismatch explained. Separated solutions live in
`exercises/solutions/`. Query work belongs on a database you may destroy and recreate
freely; the laboratory's project briefs are where a schema becomes a real application
([20-PROJECT-LABORATORY](../20-PROJECT-LABORATORY/README.md)).

## Expected outcomes

You can derive a schema from a written requirement and justify its normalization level;
write a query with multiple joins and an aggregate and predict its result before running
it; explain what happens to a row from `INSERT` to disk and back; prove the difference
between isolation levels with a reproduced conflict; and name which integrity rule is the
database's job and which is the application's.

## Common blockers

- **Treating `NULL` as zero or empty.** It is "unknown" — and `= NULL` never matches.
  Filtering and aggregating around it is a distinct skill, drilled in the aggregation
  lesson.
- **Skipping keys and constraints because "the app checks it."** The application checks
  what you remembered to check; the database checks everything, once, in one place.
- **Learning JOIN syntax without predicting results.** A join you can't hand-trace is a
  join you will debug at 2 a.m.; every lesson set demands the prediction first.
- **Denormalizing before measuring.** Duplicate data is a permanent update cost paid for a
  speculative read win — the design lessons put the measurement before the decision.

## Next

[11-BACKEND-ENGINEERING](../11-BACKEND-ENGINEERING/README.md) — the other half of the
data story: the server that queries this database, validates what arrives, and exposes it
over HTTP.
