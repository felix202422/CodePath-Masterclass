# Exercises — 14 Testing and Quality

**Lessons:** this subject's eleven lessons, in order, plus the subject README.
**How to use these sets:** attempt first; solutions live in
[solutions/](solutions/README.md) behind a warning. The 15-minute rule from
[learning-method](../../00-START-HERE/learning-method.md) applies — record which hint you used.

Sets 1–11 correspond to the lessons named in their titles and mirror each lesson's exercise
ladder (introductory → intermediate → independent) with observable completion criteria.
Set 12 covers the three topics the subject README promises without a dedicated lesson:
regression testing, frontend testing, and mobile testing — each leaning on the lab where
it was already executed ([09-FRONTEND](../../09-FRONTEND-ENGINEERING/README.md),
[12-MOBILE](../../12-MOBILE-DEVELOPMENT/README.md)). Completing all twelve sets *is* this
subject's half of the milestone gate in [ROADMAP.md](../../ROADMAP.md) Milestone 8
(architecture, testing, and security).

**The lab you need.** Sets 1–11 run against a Spring Boot lab shaped like the lessons'
(the lessons were executed with **Java 25**, `spring-boot-starter-parent` 4.1.1, Maven,
JaCoCo 0.8.13 on Windows). Set 12 uses subject 09's Vitest lab and subject 12's Flutter
scaffold:

```bash
mkdir test-lab && cd test-lab          # sets 1–11: Maven + JUnit 5 + JaCoCo
mvn -version                           # Java 21+ compiles every probe here
cd ../frontend-lab && npx vitest run   # set 12 frontend half (subject 09's scaffold)
cd ../scaffold && flutter test         # set 12 mobile half (subject 12's scaffold)
```

Each set's probe is reconstructible from the code blocks quoted in its lesson: the lesson
shows the source *and* the transcript it produced on the authoring machine (see
[VERSIONS.md](../../VERSIONS.md) for the policy — where your versions differ, the
**behaviour** is the criterion and the exact text is yours to capture). Tests named in the
lessons (`PrintTrapTest`, `SecurityBatteryTest`, `PerformanceBatteryTest`, the six-cell API
battery, `gate.sh`, …) are the authoring names for batteries you rebuild from the lesson's
quotes; rebuilding them is part of the exercise, and sets that say "run the battery" accept
your reconstruction as long as the assertion logic matches.

**Predict before you run.** Every set below that says "predict" means paper first: write the
expected exit code, percentile, coverage ratio, or failing assertion *before* you run it —
a prediction you did not write down is not a prediction. Where a set says "drill", it means
the deliberate-break shape used throughout the lessons: green → plant the violation → red
with the reason visible → revert → green (that exact drill is sets 9 and 11's closing
exercise).

---

## Set 1 — Testing fundamentals → `testing-fundamentals.md`

1. Turn a print-only check into a real test, then write three AAA tests for one function,
   one per boundary.
   **Criteria:** the red capture when the value is wrong and the green when it is right;
   each test's arrange/act/assert visible; all green in one run.
2. Build an order-dependent pair deliberately: prove green together, red alone with
   `-Dtest=…#method`, fix it, and show the isolated green (the lessons' `value=seeded-by-first-test`
   vs `was: <null>` shape).
   **Criteria:** all three captures, plus one sentence on why your CI would have shipped
   the bug — the lessons' pair ran green inside `Tests run: 22 … BUILD SUCCESS`.
3. Price the pyramid with your own numbers: run one unit test class and one full-stack
   test, report both wall times (the lessons measured `16 tests 0.216s` vs `3 tests 12.60s`).
   **Criteria:** both timings captured, and the cost per test stated.
4. **Independent:** a teammate's suite is green in CI but a bug shipped. Investigate and
   produce the verdict from executed evidence.
   **Criteria:** at least one of — a print-only test, an unrun class, an assertion on the
   wrong value — with the run that exposes it and a one-line prevention for each.

## Set 2 — Unit testing → `unit-testing.md`

1. Write the boundary table for a function you own, on paper first, then execute it.
   **Criteria:** every row predicted before running; the executed table with your captures.
2. Add guard tests with messages to three throwing methods.
   **Criteria:** each `assertThrows` also asserts the message names the input that caused it.
3. Run the rename drill on your own suite: rename one private field, run, classify every
   red (the lessons' `rate → taxRate` killed exactly `implementationTest` —
   `NoSuchFieldException: rate`, 15/16 others green).
   **Criteria:** the red capture; the list of tests that died; a verdict per test —
   behavior or implementation?
4. **Independent:** audit 10 tests a colleague claims "cover the service".
   **Criteria:** for each — the failure class it can catch; the count that are
   implementation-coupled or assertion-free, with quotes.

## Set 3 — Integration testing → `integration-testing.md`

1. Write the wiring test for your own app context and a round-trip test through your real
   mapping.
   **Criteria:** an executed `CTX-LOAD`-style line; save → read → assert → cleanup captured
   green; one sentence on which failure classes these catch (and that they catch nothing else).
2. Reproduce the rollback probe on a `@Transactional` method you own.
   **Criteria:** both halves captured — exception propagated *and* row/state unchanged
   (the lessons' `ROLLBACK: before=0 after=0 → exception propagated AND the row is gone`).
3. Reproduce the never-ran incident: rename a test class out of the include pattern, watch
   the count drop, rename it back (the lessons found `OrderServiceIT` absent from a green
   22-test run).
   **Criteria:** both counts and the empty-run evidence.
4. **Independent:** design your suite's engine strategy — what H2/SQLite proves, what needs
   the real engine, how each runs in CI.
   **Criteria:** a decision table with your measured cold-start times and one executed test
   on the engine you actually ship against.

## Set 4 — End-to-end testing → `end-to-end-testing.md`

1. Run the HTTP-seat E2E against a jar **you** built and started.
   **Criteria:** both captures — 201 with `Location`, and 401 without a token — from the
   deployed process, not from inside the test JVM.
2. Add the "wrong target" check: start two servers, point the test at the wrong one.
   **Criteria:** the failed assertion and the sentence identifying which process answered.
3. Drive one full browser journey on your own frontend (page → API → persisted result) and
   replace one fixed `sleep` with a condition wait.
   **Criteria:** the rendered success text plus the negative path's rendered error; flake
   count before/after over 10 repetitions.
4. **Independent:** design your suite's E2E budget.
   **Criteria:** the journey list (≤ 10), each mapped to a user goal, measured wall clock,
   and one sentence per *excluded* path naming which lower level covers it.

## Set 5 — Mocking and test doubles → `mocking-and-test-doubles.md`

1. Stub, spy, and fake one collaborator three ways.
   **Criteria:** three green tests plus one line each — what does this variant prove that
   the others don't?
2. Run the divergence pair: mock-green while the real collaborator rejects the same call
   (the lessons' `quote(-5.00, 1) = -5.35` green vs real `IllegalArgumentException`).
   **Criteria:** both captures, and the impossible world named in one sentence.
3. Fix the divergence the lesson's way: guard before the collaborator, capture run 2 (mock
   test dies), rewrite with `verify(never())`, capture run 3 green.
   **Criteria:** all three runs; the collaborator stays mocked while the assertion moves to
   behavior true in both worlds.
4. **Independent:** remove all mocks from one test class.
   **Criteria:** the class runs against real collaborators; each mock you keep has a named
   reason (external / slow / nondeterministic) and each you drop has one too.

## Set 6 — Test-driven development → `test-driven-development.md`

1. Replay the executed cycle on your own rule.
   **Criteria:** three captured runs — assertion-red, green, refactor-green — each with the
   reason line (the lessons' red was `expected: <95.0> but was: <100.0>` against a stub).
2. Deliberately produce a *wrong* red (call a nonexistent method), then restore the right one.
   **Criteria:** both captures and the classification of each red.
3. Do a cycle where the red is design feedback: the test needs four collaborators, so split
   the unit.
   **Criteria:** before/after constructor arity and the green run after the split.
4. **Independent:** run test-first and test-after on the *same* small feature in two
   branches, then compare.
   **Criteria:** time per branch, defect count, and your verdict — which feedback was
   different, not which feels virtuous.

## Set 7 — API testing → `api-testing.md`

1. Run the six-cell battery as-is and map each test to its matrix cell, then add one
   endpoint of your own with both a 401 and a 400 cell.
   **Criteria:** the matrix filled and named by test method; four captures for your endpoint
   (success, validation, no token, wrong token).
2. Pin the 401 bodies as byte-identical (the lessons pin `no token` vs `wrong token`
   against a future information leak).
   **Criteria:** the identity assertion in place, and one sentence on what an attacker
   learns if it ever fails.
3. Break the API deliberately: make the 404 return 200 with `null`.
   **Criteria:** the red capture, the revert, the green — plus why status-only tests would
   have missed it.
4. **Independent:** design the API test plan for a service you own.
   **Criteria:** matrix on one page, harness choice with justification, the authz non-leak
   property stated as an assertion, and at least eight executed cells.

## Set 8 — Performance testing → `performance-testing.md`

1. Add a p50 assertion to P1 with a 20 µs budget, and run P2 with the pause every 250th
   call instead of every 83rd — predict p99 first.
   **Criteria:** the suite stays green with p50 well under budget; your prediction and the
   printed `p99=` agree, with the percentile arithmetic stated.
2. Add a P4 that budgets the whole path at the API layer: time 100 `RANDOM_PORT` GETs,
   assert p95 under a budget you justify from a measured baseline.
   **Criteria:** green twice in a row (noise margin), and what the budget excludes named.
3. Break the gate two ways: (a) tighten the budget below p95, (b) replace the indexed lookup
   with the naive scan (the lessons captured `naive=944ms (budget 50ms) → OVER |
   indexed=0ms → PASS`).
   **Criteria:** two distinct red captures, both reverted to green, each with the failing
   assertion line quoted (the lessons' break drill printed `p95 100ns exceeds budget 10ns`).
4. **Independent:** your feed endpoint's p99 doubled after a release while the average
   barely moved. Design the test that would have caught it.
   **Criteria:** metric, percentile, budget, where it runs, and runner-noise policy — with
   the executed local probe and any staging-only part labelled reference.

## Set 9 — Security testing → `security-testing.md`

1. Add a probe asserting `Content-Type` on the 401 body is `application/problem+json`, and
   run the secrets scan over your own project.
   **Criteria:** the assertion passes on the fixed app (and you can say what breaks if it
   returns `text/html`); the scan's command, match count, and a two-line interpretation.
2. Turn the authorization check into a table test over three roles × two endpoints.
   **Criteria:** 6 parameterized cases green, anonymous/wrong-token bodies asserted
   identical per endpoint.
3. Deliberately reintroduce one of the two real gaps (remove the `WWW-Authenticate` line),
   run, capture the red, restore (the lessons' first run failed with
   `401 must include a WWW-Authenticate challenge` and `nosniff … was: <<absent>>`).
   **Criteria:** both transcripts quoted — the battery must be able to fail again — and the
   fix recorded as a production-code change, never an assertion change.
4. **Independent:** a file-upload endpoint accepts `filename` from the client. Specify (and
   where possible execute) the path-traversal test for the *stored* filename.
   **Criteria:** payload + assertion point + expected-failure transcript for a naive
   implementation; anything you cannot run locally labelled reference with the exact
   environment it needs.

## Set 10 — Test coverage → `test-coverage.md`

1. Re-run the lab report and say in your own words what the app entry point's 37.5% means;
   then delete the gap-closing tests and reproduce the baseline.
   **Criteria:** your baseline matches the lessons' shape (93.2% instruction / 79.4% branch /
   94.0% line), and you can name the four classes that lose coverage and why those four.
2. Add a new production class with two methods and no tests; watch the bundle ratio fall;
   then cover one method only and observe which counter moves.
   **Criteria:** three ratios captured (before / untested / half-covered), each with the
   `clean` build that produced it.
3. Write a test that executes every *line* of a branchy method but only half the branches,
   and show the report disagreeing with your line count.
   **Criteria:** 100% lines next to <100% branches in the same report.
4. **Independent:** design the coverage policy for a team that ships weekly.
   **Criteria:** counter, floor, how the floor moves, what a developer sees on failure, and
   the unreachable-line exemption — the floor justified against a measured baseline, never
   a round number.

## Set 11 — Quality gates → `quality-gates.md`

1. Run a three-stage gate (structure → references → tests + coverage floor) and record each
   stage individually; then break only stage 2.
   **Criteria:** a table of stage, exit code, wall time; a transcript showing
   `GATE: FAIL at stage 2 (references)`, exit 1, with no Maven output — cheap stages must
   fail first.
2. Reproduce the planted-violation drill on your own copy of the lab: add an untested
   production class, watch the gate block, close the gap with tests.
   **Criteria:** three captured runs (green → below floor → above floor) with the test count
   and exit code from each — the lessons went `0.987 → 0.749 (exit 1) → 0.9901 (exit 0)`
   with **54 tests green in the blocked run**.
3. Add a fourth stage that fails the gate when test output contains `MISMATCH`.
   **Criteria:** exit 1 on today's lab while the print-trap is present, exit 0 after you
   turn the printed comparison into a real assertion — no other stage changed.
4. **Independent:** design the gate policy for a team shipping weekly.
   **Criteria:** per push / per merge / per release stages with a runtime budget each, floor
   numbers with the measurements behind them, and the exact failure message per stage.

## Set 12 — Regression, frontend, and mobile testing → subject README promise

1. **Regression:** take a bug that shipped and write the test that would have caught it —
   then prove the class of bug, not just the instance: mutate the fixed line and watch the
   new test fail (the lessons' drill shape).
   **Criteria:** red on the mutation, green on the fix, and one sentence on which other
   inputs the test does *not* protect.
2. **Flaky E2E:** take any test with a fixed wait, replace it with a condition wait, and run
   it 10 times both ways.
   **Criteria:** flake counts before/after, and the condition stated as an observable
   predicate, not a duration.
3. **Frontend:** rebuild subject 09's role-query pair — same UI, rewritten markup, selector
   that survives — plus one async transition driven through the loading state
   (the executed probes: `getByRole("button", { name: "Save" })` finds both versions,
   `findByText` passes *through* loading; `npx vitest run → 6 passed`).
   **Criteria:** both components pass with one query, the markup rewrite captured, and one
   line on why a test-id or CSS selector would have failed the rewrite.
4. **Mobile:** run subject 12's three-level suite, then the print-vs-assert drill: a test
   that printed the bug and stayed green, made to fail, reverted (the executed shape:
   `+25: All tests passed!` → print-only round green with the bug visible → `Found 0
   widgets with text "Enter an email"` → `Some tests failed` exit 1 → revert → 25 green).
   **Criteria:** all four captures at unit/widget/integration level, with the failure class
   each level can and cannot detect.
5. **Independent:** state this subject's answer to "our tests are green, so we're safe":
   one page naming every claim the green suite makes and the five it does not, each with the
   lesson transcript that proves the gap (print-trap, unrun class, mock divergence,
   coverage-without-assertion, gate-blind spot).
   **Criteria:** five claim/gap pairs, each citing a specific executed transcript from a
   lesson of this subject.

*Solutions: attempt first. They live in [`solutions/`](solutions/README.md) of this subject.*