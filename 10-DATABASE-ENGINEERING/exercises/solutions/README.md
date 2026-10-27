# Solutions — 10 Database Engineering

**⚠ Attempt the sets first.** Reading a solution produces recognition, which feels like
knowledge and is not. One week after reading any solution here, rebuild that answer from a
blank page — the second attempt is the one you keep.

One solution file per set, matching the lessons of the same name. Transcripts marked as
*authoring machine* were executed during this batch against PostgreSQL **18.6** on a
scratch cluster (Windows 11 / Git Bash, psql 18.6) and against the shipped
[postgresql/](../../postgresql/README.md) lab — the same server whose captures you can
reproduce with `bash verify.sh`. Your versions' exact text will differ — the **behaviour
and the reasoning** are the criteria; your own captured output is your evidence.

| Set | Lesson(s) | File |
|---|---|---|
| 1 | Database fundamentals | [set-1-solutions.md](set-1-solutions.md) |
| 2 | Relational databases | [set-2-solutions.md](set-2-solutions.md) |
| 3 | SQL fundamentals | [set-3-solutions.md](set-3-solutions.md) |
| 4 | Filtering and aggregation | [set-4-solutions.md](set-4-solutions.md) |
| 5 | Joins and subqueries | [set-5-solutions.md](set-5-solutions.md) |
| 6 | Database design | [set-6-solutions.md](set-6-solutions.md) |
| 7 | ER diagrams | [set-7-solutions.md](set-7-solutions.md) |
| 8 | Normalization | [set-8-solutions.md](set-8-solutions.md) |
| 9 | Constraints and relationships | [set-9-solutions.md](set-9-solutions.md) |
| 10 | Transactions · concurrency and isolation | [set-10-solutions.md](set-10-solutions.md) |
| 11 | Indexes · query plans and optimization | [set-11-solutions.md](set-11-solutions.md) |
| 12 | Migrations · backups · security · NoSQL | [set-12-solutions.md](set-12-solutions.md) |

**About reference transcripts:** where a solution quotes output, it is the authoring
machine's real capture — the lesson probes (identity, guard rejections, two-session
isolation runs, `explain analyze` before/after indexing), the lab's `q1`–`q7` expected
files, and this batch's `verify.sh` run (`7 passed, 0 failed`). Where a solution gives a
*shape* (a mapping table, a checklist, an audit sheet), no single correct text exists —
the criteria in the set's [README](../README.md) define what a reviewer looks for.

**Executed corrections worth knowing** (re-verified while writing these solutions): a
Windows psql writes **CRLF** to stdout, so byte-comparing captures across platforms needs
the CR stripped (that is what the lab's `verify.sh` does — the diff is otherwise all
lines, all at once, and looks like seven wrong answers when nothing is wrong); `where x =
NULL` matches **zero** rows and `where x not in (subquery)` containing a NULL also returns
zero rows — both are three-valued logic, not bugs; and `serializable` is proved by the
*error* it raises (`could not serialize access due to…`), which a level-by-level table
with no failing capture has not demonstrated.
