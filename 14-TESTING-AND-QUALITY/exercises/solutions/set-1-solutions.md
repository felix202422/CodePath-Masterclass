# Set 1 solutions — Testing fundamentals → `testing-fundamentals.md`

*Executed in the batch's Maven lab (Java 25, Spring Boot 4.1.1, Windows). Blocks marked
*reference* are shapes to run in your own lab.*

## 1. Print-only → real assertion, plus three boundary tests

The lesson's `PrintTrapTest`, in its *before* state — the check exists, the value is wrong,
the run is green:

```
PRINT-TRAP: expected=19.9 actual=19.8 MISMATCH
[INFO] Tests run: 22, Failures: 0, Errors: 0, Skipped: 0
[INFO] BUILD SUCCESS
```

Convert it: replace the print with `assertEquals(want, got)` and the same wrong value now
produces `[ERROR] Tests run: 22, Failures: 1 … expected: <19.9> but was: <19.8>`. Fix the
value → green. The three boundary tests (below/at/above threshold) go green in one run and
each shows its AAA sections as comments or methods named `given…when…then` — the shape that
matters is one act per test, not the naming scheme.

**Verdict to write:** the print-only check was not a weaker test; it was not a test at all.
It executed the code (which is why coverage counted it) and asserted nothing.

## 2. The order-dependent pair

Executed shape (the lessons' `IsolationSeedTest` / `IsolationDependentTest` pair):

```
# together, surefire's default order:
ISOLATION: value=seeded-by-first-test      → Tests run: 2, Failures: 0  (green)

# isolated, -Dtest=IsolationDependentTest:
AssertionFailedError: shared state missing when this test runs alone
  ==> expected: <seeded-by-first-test> but was: <null>                  → exit 1
```

Fix it with `@TestMethodOrder` **or** (better) by giving the dependent test its own arrange —
then run the isolated command again: green. The one sentence your CI needs: two tests that
pass only in one order are one test with a hidden dependency, and any parallelization,
filtering, or `-Dtest` run breaks it silently — the lessons later *lost* exactly this class
of test to stale build output (set 10).

## 3. Price the pyramid yourself

The lessons' measurement:

```
unit class:        Tests run: 16, Time elapsed: 0.216 s
full-stack class:  Tests run: 3,  Time elapsed: 12.60 s
```

≈ 0.014 s/test vs ≈ 4.2 s/test — a ~300× price per test. Your numbers will differ; the
criterion is that both timings come from your machine, in the same run style (warm, same
build), and that your cost-per-test is computed, not guessed. The conclusion you should
reach: the pyramid is a *budget* argument — every full-stack test you add must buy a failure
class the unit tier cannot detect.

## 4. Independent — "green in CI, bug shipped" (reference verdict shape)

Investigation order, cheapest first, each step ending in an executed run:

1. **Does the test that covers the bug's line run at all?** Rename check: compare the class
   name against surefire's include pattern (`*Test`). The lessons' incident: `OrderServiceIT`
   was *absent* from a green 22-test run — a green suite that never executed the code.
2. **Does it assert?** Grep the test for prints vs assertions; run it with the value broken.
   The lessons' incident: `PRINT-TRAP … MISMATCH` inside `BUILD SUCCESS`.
3. **Does it test the real collaborator?** If it mocks the boundary, run the divergence pair
   (set 5) — mock-green while the real call throws.
4. **Order dependence** (item 2 above): run the suspect test alone with `-Dtest=…#method`.

Deliverable: the verdict with its run attached — "the bug was in X's failure path; no test
executed/asserted it; here is the red run of the test I wrote" — plus the prevention that
matches the failure class, not a generic "write more tests."