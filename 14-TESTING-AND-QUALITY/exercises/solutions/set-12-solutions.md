# Set 12 solutions — Regression, frontend, and mobile testing → subject README promise

*Frontend and mobile transcripts were executed in subjects 09 and 12's labs (Vitest + React
Testing Library; Flutter). Regression and the claim/gap page draw on this subject's executed
transcripts. Cross-browser grid runs are labelled reference.*

## 1. The regression test, then the mutation

Method: write the test that fails on the buggy line — capture red — apply the fix — capture
green — then **mutate the fixed line back** and confirm the same test goes red again. That
last step is the exercise: a test written from the bug report may pass for the wrong reason.

```
red on bug:      expected: <…> but was: <…>
green on fix:    Tests run: N, Failures: 0
mutation red:    same test, same assertion line, failing again  → then revert
```

The sentence you owe: which other inputs the test does *not* protect (the bug class vs the
instance) — e.g. an off-by-one at one boundary says nothing about the other boundary. The
lessons' drill shape (green → plant → red with the reason visible → revert → green) is the
same three-step proof applied to a gate rather than a test.

## 2. Flaky E2E → condition wait

Both runs, 10 repetitions each:

```
fixed sleep:      N flake(s) in 10 runs   (the sleep races the slow path)
condition wait:   0 flake(s) in 10 runs
```

The condition must be an observable predicate of the state you wait for
(`[data-status="saved"]`, a row appearing, a spinner disappearing) — not a duration. If you
cannot name the condition, the flake was hiding an actual race, and the sleep was
suppressing the symptom: write what could go wrong in one line as part of the deliverable.

## 3. Frontend: the role-query pair (executed in subject 09's lab)

The executed probes:

```
// probe-n.test.tsx — npx vitest run (executed: 6 passed)
render(<SaveV1 />);  getByRole("button", { name: "Save" });   // ✓
render(<SaveV2 />);  getByRole("button", { name: "Save" });   // ✓  (new markup)

await screen.findByText(/loaded \(attempts: 2\)/);   // passed THROUGH loading
```

Same UI, fully rewritten markup, one query finds both — the whole argument for querying by
role/name instead of structure. The one line requested: a CSS selector (`.btn-save`) or a
structural path (`form > div:nth-child(3) > button`) would have failed V2 outright, turning a
pure refactor into a red suite — the selector had coupled the test to markup, not behavior.
The async half: `findBy*` drives the transition the way a user experiences it (loading →
loaded), asserting the intermediate state rather than sleeping past it.

## 4. Mobile: three levels + print-vs-assert drill (executed in subject 12's scaffold)

The four captures:

```
1. flutter test                →  +25: All tests passed!   (~13s)
2. print-only round            →  bug VISIBLE in output, suite still green (print ≠ assert)
3. assertions added            →  Found 0 widgets with text "Enter an email"
                                 Some tests failed   (exit 1)
4. revert                      →  +25: All tests passed!
```

Failure classes per level: **unit** catches logic errors (pure Dart, milliseconds); **widget**
catches rendering and wiring errors (`Enter an email` never rendered — a controller not
attached); **integration** catches navigation/permission flows, at seconds per test and
highest flake. None of the three catches a broken backend contract — that class lives in
subject 11's API battery.

## 5. Independent — "our tests are green, so we're safe" (the claim/gap page)

Five claim/gap pairs, each citing an executed transcript from this subject:

| The green suite claims… | …but this transcript proves otherwise |
|---|---|
| the checked values are right | print-trap: `PRINT-TRAP: expected=19.9 actual=19.8 MISMATCH` inside `Tests run: 22 … BUILD SUCCESS` |
| every test ran | `OrderServiceIT` absent from a green 22-test run (include pattern), and the stale-class incident at 52 tests |
| the code matches its collaborators | divergence pair: mock `quote(-5.00,1) = -5.35` green while the real collaborator throws |
| the code is exercised | coverage `98.7%` beside `main()` uncovered, and the honest run still printing a wrong value with `EXIT=0` |
| the change is safe to merge | gate drill: 54 tests green while the gate exited 1 at `0.749 < 0.90` |

The page's conclusion, in your own words: green is a statement about *the checks that were
written* — every row above is a place where the check and the claim came apart, and each was
found by executing something, never by looking at the badge.