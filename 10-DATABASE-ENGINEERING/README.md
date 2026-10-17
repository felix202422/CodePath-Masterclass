# 10 — Database Engineering

Data outlives the code that writes it. This subject teaches you to model data so it stays correct,
query it so it stays fast, and operate it so it survives. It uses one consistent sample database
across every lesson so you see a schema evolve rather than restart.

## What this subject covers

- Database fundamentals: what a database is, why dedicated ones exist, DBMS roles.
- Relational databases: tables, rows, columns, keys, and the relational model's promise.
- SQL fundamentals: `SELECT`, `WHERE`, ordering, and limiting — with correct mental models.
- Filtering and aggregation: `GROUP BY`, `HAVING`, and the order SQL clauses are evaluated in.
- Joins and subqueries: inner/outer joins, self-joins, and when a subquery is clearer than a join.
- Database design: from requirements to entities, attributes, and relationships.
- ER diagrams: crow's-foot notation and reading one at a glance.
- Normalization: 1NF–3NF with the *trade-offs*, including when denormalization is right.
- Constraints and relationships: primary/foreign keys, uniqueness, checks, and what they prevent.
- Transactions: ACID, boundaries, and what "atomic" buys you.
- Indexes: B-trees, composite order, and what an index costs on write.
- Query plans and optimization: reading `EXPLAIN`, and fixing what it shows.
- Concurrency and isolation: dirty reads, phantom reads, and the isolation-level ladder.
- Migrations: versioning schema safely in a team.
- Backups and recovery: what a backup is worth until you have restored one.
- Database security: least privilege, injection defense at the data layer.
- NoSQL fundamentals: document/key-value/graph stores and when the relational model is wrong.
- `postgresql/` — administration, scripts, sample data, and expected results for every query.

## Why it matters

Backend architecture is mostly database architecture with HTTP attached. Data integrity is
enforced here or nowhere; performance is usually decided here before any code is optimized; and the
most expensive outages in industry are data-loss events. The subject is placed before backend
engineering so that when you write persistence code you are *expressing* a model, not inventing one
on the fly.

## Prerequisites

- [02-PROGRAMMING-FUNDAMENTALS](../02-PROGRAMMING-FUNDAMENTALS/README.md) — set and loop thinking
  maps directly onto rows and joins.
- [01-COMPUTER-FOUNDATIONS](../01-COMPUTER-FOUNDATIONS/README.md) — files, memory, and the
  storage-hierarchy reasoning behind indexes.

## Lessons

Exercises run against PostgreSQL 18 (see `postgresql/` for setup, sample data, and expected
results; version pinned in [VERSIONS.md](../VERSIONS.md)).

- `database-fundamentals.md` · `relational-databases.md`
- `sql-fundamentals.md` · `filtering-and-aggregation.md` · `joins-and-subqueries.md`
- `database-design.md` · `er-diagrams.md` · `normalization.md` · `constraints-and-relationships.md`
- `transactions.md` · `indexes.md` · `query-plans-and-optimization.md` · `concurrency-and-isolation.md`
- `migrations.md` · `backups-and-recovery.md` · `database-security.md` · `nosql-fundamentals.md`

## Exercises and practice

Every lesson has a runnable script in `postgresql/` with sample data and **expected results printed
alongside the query**, so you can compare your output exactly. Problem sets progress from writing
the query, to designing the schema, to reading a real query plan and making a justified change; the
independent task per section is a design problem (e.g. "normalize this spreadsheet export and
document each decision").

## Expected outcomes

You can derive a normalized schema from written requirements and defend each choice; write queries
with multiple joins and aggregates and predict their results; explain ACID with a concrete failure
each property prevents; choose an index and justify it with an `EXPLAIN` before/after; and restore
a database from a backup you actually made.

## Common blockers

- **Learning SQL as "the SELECT clause".** Clause evaluation order is why `GROUP BY` behaves the
  way it does; the lesson teaches the order, not just the syntax.
- **Indexes as free speed.** An index is a write cost and a storage cost; every index must earn
  its place.
- **Skipping transactions until production.** Integrity bugs found in production have usually
  already corrupted data.

## Next

[11-BACKEND-ENGINEERING](../11-BACKEND-ENGINEERING/README.md) — build the services that sit on top
of this data: HTTP, REST, Spring Boot, and tested persistence.