# Solutions — Set 10: Transactions · concurrency and isolation →
`transactions.md` · `concurrency-and-isolation.md`

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.
> Executed on the authoring machine: PostgreSQL 18.6; the two-session captures are real —
> two psql prompts, explicit `begin` in each.

## Exercise 1 — Atomicity by hand

**Prediction written first:** commit path → both balances move (`-100` / `+100`);
crash path (rollback between the two updates) → both balances unchanged — *no state in
which exactly one side moved*.

**Executed pair from the lesson** (the rollback/commit probe): inside the block the
balance reads `100`; after `rollback` the same read returns the original value — the
statement ran, was visible *within* the block, and never existed outside it. The
mid-block failure variant makes the same point harder: a successful `update` followed by
an error, rolled back — the successful update is **discarded** along with the failed
statement. That is atomicity, and it is the ACID letter **A**: the block is all-or-
nothing, so "half a transfer" is not a state the database can be found in.

**The contrast worth capturing too:** the same two updates run as autocommit statements
(one per statement, no block) leave exactly the half-transferred state — the lesson
executes this contrast so you have *both* transcripts, because the crash always arrives
between statements.

## Exercise 2 — Savepoints and the aborted-state rule

The executed sequence, with the two messages that are the exercise:

```sql
begin;
insert into audit (msg) values ('first');     -- ok
savepoint sp1;
insert into audit (msg) values (null);         -- ERROR: null value in column "msg"
insert into audit (msg) values ('second');
-- ERROR: current transaction is aborted, commands ignored until end of transaction block
rollback to savepoint sp1;
insert into audit (msg) values ('second');     -- now succeeds
commit;
```

**Captured verbatim:** `current transaction is aborted, commands ignored until end of
transaction block` — after *any* error inside a block, PostgreSQL refuses every further
statement (the one exception: `rollback to savepoint`). **Why `rollback to` and not a
new `begin`:** a new `begin` warns `there is already a transaction in progress` and
changes nothing — the aborted state is *of the current block*, and only unwinding to a
savepoint (or ending the block with `rollback`/`commit`) clears it. Rule for your
notes: **savepoints are checkpoints inside a transaction; the escape from an aborted
state is a savepoint or the block's end, nothing else.**

## Exercise 3 — The isolation ladder, two sessions

The executed three-row table (same conflict, three levels — session A reads, session B
changes and commits, A reads again):

| Level | A's second read | The anomaly it permits |
|---|---|---|
| `read committed` | **200** (B's committed value) — `100 → 200` captured | non-repeatable read: the same row, same transaction, two different answers |
| `repeatable read` | **100** (A's snapshot: `100 → 100` captured) | phantom / write skew: B's change invisible to A entirely |
| `serializable` | A gets an **error**: `could not serialize access due to …` (40001 captured) | nothing — by *refusing* the interleaving |

Two execution notes that are part of the criteria: the two sessions are two `psql`
prompts with an explicit `begin` in each (autocommit would make the window a
microsecond), and the `serializable` row is proved by the *error* — a table with no
failing capture has not demonstrated serialization at all (it would be indistinguishable
from repeatable read).

The fourth capture worth having: the application-level **lost update** — both sessions
`select` the balance (`200`), both compute `+50` from what they read, both write; the
second write clobbers the first (`150` clobbering `200` in the lesson's run — arithmetic
that never existed in the database). It happens *under* read committed and even
repeatable read, because the read-modify-write happened in application memory.

## Exercise 4 — Reproduce one anomaly, fix it twice (reference shape)

A reviewer's checklist against your own schema:

1. **The anomaly captured with ordering evidence** — timestamps or interleaved prompt
   output showing session 1's read before session 2's commit and session 1's write
   after it. Without ordering evidence, "I saw stale data" is an anecdote.
2. **Fix A — isolation level:** `begin isolation level serializable` (or
   `repeatable read` for the non-repeatable case) → the same interleaving now raises
   `40001`; capture the error. Cost written: your throughput/availability budget takes
   the retry burden (who retries — the app, with what backoff?).
3. **Fix B — application side:** `select … for update` (row lock makes session 2 wait) or
   the atomic `update … set balance = balance + 50` (no read-modify-write window at
   all) → re-run the interleaving, capture the correct final value. Cost written: the
   lock ordering discipline (deadlocks are possible — which order do you always lock
   in?).
4. **The verdict:** the atomic `UPDATE` is the usual ship — it fixes *this* anomaly with
   no level change and no retry logic, and only `for update`/serializable when the
   decision spans multiple rows whose *set* must be stable (the seat-booking case).
   Name the case where you'd flip: cross-row invariants → the predicate lock buys
   something the single-row update cannot.

---

*Criteria cross-check: predictions for both exit paths vs captures with "atomic" stated
against half-a-transfer ✓, aborted-state message quoted with the savepoint-recovery
transcript and the `begin`-vs-`rollback to` rule ✓, three-level table from two-session
runs incl. the 40001 error ✓, anomaly with ordering evidence, both fixes executed, verdict
with costs ✓.*
