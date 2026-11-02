# Set 3 solutions — Integration testing → `integration-testing.md`

*Executed in the batch's Maven lab (Java 25, `@SpringBootTest`, H2). Blocks marked
*reference* are shapes to run in your own lab.*

## 1. Wiring test and round-trip

The lessons' executed pair:

```
CTX-LOAD: beans wired
PERSIST: id=2 rows 0 -> 1
```

The wiring test loads the real application context and asserts a collaborator is present —
that is its *entire* failure class: broken wiring, missing beans, bad property binding. Write
the honest sentence under it: this test cannot catch wrong business logic; if it ever fails,
look at configuration, not calculations.

The round-trip goes save → read → assert → cleanup in one test (or one `@Transactional` that
rolls back), so the capture shows the row count moving and returning: `rows 0 -> 1 -> 0`.
A test that leaves `id=2` behind has converted your suite into an ordering dependency — the
exact disease set 1 diagnosed.

## 2. The rollback probe

Both halves in one capture (the lessons' line):

```
ROLLBACK: before=0 after=0 -> exception propagated AND the row is gone
```

Structure: call the `@Transactional` method inside `assertThrows`, then query the table in
a **separate** transaction (the same one would see uncommitted state and lie). One assertion
per half — the exception type *and* the row count — because a method that rethrows after
committing, or swallows without rolling back, fails exactly one of them.

## 3. The never-ran incident

The lessons' execution: a green run reported `Tests run: 22`, and `OrderServiceIT` was not
among them — its name fell outside surefire's `*Test` include pattern. Rename it back
(`OrderServiceIT` → `OrderServiceTest`, or configure the include), rerun:

```
before: Tests run: 22   (OrderServiceIT absent — empty-run evidence: 0 tests matched)
after:  Tests run: 25   (3 integration tests present)
```

Why this is in an *integration* set: wiring tests are long and live in different source
roots, so they are the class most often excluded "accidentally" — and an exclusion is
indistinguishable from passing. Cheap prevention: assert the expected test count somewhere
(a build-level check), or make the CI print the per-class list.

## 4. Independent — engine strategy (reference decision table)

| Layer | Engine | Proves | Runs in CI as |
|---|---|---|---|
| Mapping/query syntax | H2 (or SQLite) | SQL parses, JPA maps, transactions demarcate | default, seconds |
| Engine-specific SQL | the real engine (Postgres container) | dialect, constraints, isolation | nightly / label-gated, ~cold-start seconds |
| Full app wiring | H2 + `@SpringBootTest` | context loads, filters/filtersets wired | per push |

Fill the "cold-start" cells with **your** measured numbers (the lessons measured Spring
context loads at ~1.8–2.7 s per test class — context caching is what keeps that affordable).
Then execute one test on the engine you ship against, once, and quote it: everything else
is argument, that run is evidence.