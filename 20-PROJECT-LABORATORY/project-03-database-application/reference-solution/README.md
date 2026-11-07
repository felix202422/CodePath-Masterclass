# Reference solution guide — Project 03

> **Stop.** Build the schema, then read this. The interesting failure in this project is a race that
> only appears with two connections, and no amount of reading substitutes for watching your own
> `SELECT`-then-`INSERT` lose.

The schema decisions that matter, with the alternatives that also pass.

## Where the "one active loan" invariant lives

Three workable answers, in ascending order of database dependence:

1. **Application transaction with a row lock.** `SELECT ... FROM tools WHERE id = $1 FOR UPDATE`, check
   no active loan, `INSERT`. Correct under `READ COMMITTED` because the lock serialises the two
   sessions on the tool row. Portable to SQLite only if SQLite's own write lock is understood.
2. **Partial unique index.** `CREATE UNIQUE INDEX one_active_loan ON loans (tool_id) WHERE returned_at
   IS NULL;`. The second insert fails with a unique violation; the application maps that to `Conflict`.
   Fewer round trips, and the invariant holds even for a `psql` session a human opens.
3. **Exclusion constraint** on `(tool_id WITH =, tstzrange(lent_at, returned_at) WITH &&)`. Elegant, and
   it also prevents overlapping historical loans; `btree_gist` is required and SQLite cannot do it.

The guide uses **(2) plus (1)**: the index is the guarantee, the `FOR UPDATE` gives a clean error before
the constraint fires. A solution with only (1) passes `AC-2` and `AC-3`; it fails the spirit of `AC-2`
because a manual insert bypasses it. A solution with only (2) passes both and is simpler — say so in
your ADR if you chose it.

## Schema, condensed

```sql
CREATE TABLE members (
  id          bigserial PRIMARY KEY,
  email       text NOT NULL UNIQUE CHECK (email = lower(email) AND email LIKE '%@%'),
  display_name text NOT NULL CHECK (length(trim(display_name)) > 0),
  joined_at   timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE tools (
  id        bigserial PRIMARY KEY,
  asset_tag text NOT NULL UNIQUE,
  name      text NOT NULL,
  category  text NOT NULL,
  condition text NOT NULL CHECK (condition IN ('new','good','fair','retired'))
);

CREATE TABLE loans (
  id          bigserial PRIMARY KEY,
  tool_id     bigint NOT NULL REFERENCES tools(id) ON DELETE RESTRICT,
  member_id   bigint NOT NULL REFERENCES members(id) ON DELETE RESTRICT,
  lent_at     date NOT NULL,
  due_at      date NOT NULL,
  returned_at date,
  CHECK (due_at > lent_at),
  CHECK (returned_at IS NULL OR returned_at >= lent_at)
);

CREATE UNIQUE INDEX one_active_loan ON loans (tool_id) WHERE returned_at IS NULL;
CREATE INDEX loans_due_open ON loans (due_at) WHERE returned_at IS NULL;
```

Two index notes. `one_active_loan` is the invariant *and* the lookup an availability check needs.
`loans_due_open` is what keeps the overdue report off a sequential scan at 5,000 rows (`AC-10`); a
plain index on `due_at` would also work but carries returned rows it never needs.

The `email` check constraint is a judgement call: it lowercases at the boundary rather than trusting
the caller, and it refuses an address with no `@`. It is not email validation — that belongs in the
application, because a `CHECK` cannot do it properly and will reject valid addresses if it tries.

## Availability query

The subtle requirement is FR-6: a tool due back **today** counts as available.

```sql
SELECT t.id, t.asset_tag, t.name, t.category
FROM tools t
WHERE t.condition <> 'retired'
  AND NOT EXISTS (
    SELECT 1 FROM loans l
    WHERE l.tool_id = t.id
      AND l.returned_at IS NULL
      AND l.due_at > $1          -- due today is available today
  )
ORDER BY t.category, t.name;
```

`NOT EXISTS` rather than `NOT IN`: a `NULL` in the subquery would make `NOT IN` return no rows at all,
which is the classic way this query silently returns an empty list. The comparison is `due_at > $1`,
not `>=`, and that one character is the difference between `AC-5` passing and failing.

Overdue:

```sql
SELECT l.id, m.display_name, t.name, ($1::date - l.due_at) AS days_overdue
FROM loans l
JOIN members m ON m.id = l.member_id
JOIN tools t   ON t.id = l.tool_id
WHERE l.returned_at IS NULL AND l.due_at < $1
ORDER BY days_overdue DESC, l.due_at;
```

Date subtraction in PostgreSQL yields an integer number of days; in SQLite it is `julianday($1) -
julianday(due_at)`, which is why portability is an ADR item rather than an afterthought.

## Transactions and error mapping

```python
class Conflict(Exception): ...

def lend(conn, tag, email, days):
    with conn.transaction():
        tool = conn.execute(
            "SELECT id FROM tools WHERE asset_tag = %s FOR UPDATE", (tag,)
        ).fetchone()
        if tool is None:
            raise NotFound("tool")
        member = conn.execute("SELECT id FROM members WHERE email = %s", (email,)).fetchone()
        if member is None:
            raise NotFound("member")
        try:
            row = conn.execute(
                "INSERT INTO loans (tool_id, member_id, lent_at, due_at) "
                "VALUES (%s, %s, current_date, current_date + %s) RETURNING id, due_at",
                (tool["id"], member["id"], days),
            ).fetchone()
        except UniqueViolation:
            raise Conflict("tool is already on loan") from None
    return row
```

`from None` matters: the raw driver exception carries the tool id and the index name, which is exactly
what the brief forbids leaking (`FR-5`, section 8). The transaction helper must roll back on any
exception, including the `Conflict` — a common bug is catching the conflict outside the `with`, after a
rollback has already happened, and then writing a log row that claims a lend occurred.

## Reservations

The model is a queue, not a lock. On return, the earliest open reservation becomes "ready" but is not
auto-lent — the member still has to collect it. That choice avoids a loan with no `lent_at`, and it is
the one most tool libraries make in practice.

```sql
UPDATE reservations SET fulfilled_at = now()
WHERE id = (
  SELECT id FROM reservations
  WHERE tool_id = $1 AND fulfilled_at IS NULL
  ORDER BY created_at, id
  LIMIT 1
  FOR UPDATE SKIP LOCKED
);
```

`FOR UPDATE SKIP LOCKED` is optional at this scale; it is here because two volunteers returning and
reserving at the same moment is the realistic race, and the clause documents the intent.

## Testing the race

The test that earns `AC-3` needs two real connections and a barrier:

```python
def test_two_sessions_one_loan(db):
    a, b = db.connect(), db.connect()
    ready = threading.Barrier(2)
    results = []
    def attempt(conn):
        ready.wait()
        try:
            results.append(lend(conn, "DRILL-01", "sam@example.org", 14))
        except Conflict:
            results.append("conflict")
    threads = [threading.Thread(target=attempt, args=(c,)) for c in (a, b)]
    [t.start() for t in threads]; [t.join() for t in threads]
    assert results.count("conflict") == 1
    assert db.scalar("SELECT count(*) FROM loans WHERE returned_at IS NULL") == 1
```

A single-threaded test that calls `lend` twice proves the check exists, not that it is atomic. The
barrier makes the two sessions overlap reliably; without it the test passes for the wrong reason
roughly half the time.

For `AC-9`, force the failure *after* the first write: insert the loan, then raise from a trigger or
monkeypatched log call inside the same transaction, and assert both `loans` and the audit table are
unchanged. Asserting on the loan alone can pass while an orphan log row remains.

## Trade-offs and alternatives

- **PostgreSQL versus SQLite.** Postgres gives partial indexes, exclusion constraints and real
  concurrency, which is most of this project's grading. SQLite is one file and no server, and it can
  enforce the invariant with a partial unique index too — but the concurrency test becomes a test of
  SQLite's write lock. Choose Postgres unless deployment constraints say otherwise.
- **Dates versus timestamps for loans.** Dates are what the library means ("due Friday") and avoid
  time-zone confusion at midnight. Timestamps are needed for an audit trail. The guide uses dates for
  the loan period and `now()` for `created_at`.
- **Fines as a table versus a computed query.** A table preserves the fine as charged; a query
  recomputes it when the rules change, which is wrong for money already billed. The table wins once
  fines are real; before that, a query is less to maintain.
- **CLI versus web UI.** A CLI keeps the focus on data. A web page adds input validation and state
  handling that belong to project 04. Either passes; the CLI is faster to make correct.

## What is deliberately missing

The seed data and the reporting queries. Seed data is where you discover whether your constraints are
too strict, and that discovery is the point. The three queries above are the ones with a trap in them;
everything else in `003_reporting.sql` is ordinary SQL you have already written.
