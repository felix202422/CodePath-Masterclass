# Set 6 solutions — Test-driven development → `test-driven-development.md`

*Executed in the batch's Maven lab: `TddCycleTest` (red state) and `TddGreenTest`
(green/refactor states), Java 25.*

## 1. The cycle on your own rule

The lessons' executed three runs, with the reason lines:

```
RED:    [ERROR] TddCycleTest.loyaltyDiscount:15 expected: <95.0> but was: <100.0>
        [ERROR] Tests run: 1, Failures: 1   BUILD FAILURE
        (right value missing, right reason: production is still the identity stub)

GREEN:  [INFO] Tests run: 1, Failures: 0    BUILD SUCCESS
        (minimum behavior: net >= 100.00 → 5% off; nothing else touched — the twin
         test proves shippingBoundaries and lineTotal assertions are unchanged)

REFACTOR: extract LOYALTY_RATE constant, rerun → [INFO] Tests run: 1, Failures: 0
```

The criteria to quote: the red is an **assertion** failure about the missing rule (not a
compile error), the green changes only what the red demanded, and the refactor changes
structure with the same green. Write each prediction — "I expect `expected: <95.0>`" —
before running; a red you did not predict is a debugging session, not TDD.

## 2. The wrong red

Make the test call a non-existent method:

```
[ERROR] ... cannot find symbol: method discountedTotal2(100.0)
        → COMPILE-TIME red
```

Classification: **wrong red** — it fails for a reason unrelated to the rule (it does not say
anything about the loyalty discount). Restore the right test → assertion red → implement →
green. The distinction you must be able to state: an assertion red tells you *what behavior
is missing*; a compile red tells you only *what does not exist yet*.

## 3. Red as design feedback

Shape: the test needs four collaborators wired before it can assert one thing. Split the
unit — record before/after constructor arity (e.g. `4 → 2`), rerun green. The lesson's point
to echo: TDD's real output is not the tests, it is the *design pressure*; a hard-to-write
test is the design telling you the unit has too many reasons to change. If a cycle produces
no design feedback, that is data too — use a coarser granularity and move on.

## 4. Independent — test-first vs test-after (reference comparison)

Two branches, same feature, measure:

| | test-first | test-after |
|---|---|---|
| time to green | | |
| defects shipped (bugs you later found) | | |
| design notes (splits, renames the test forced) | | |

Verdict format: "the feedback that differed was X" — not which feels virtuous. The
honest expected finding from the lessons' framing: test-first changes *when* you discover
the awkward API (during the red, when it is cheap), test-after discovers it during the
green (when the code already exists and resists). Defect counts on a small feature may tie;
the design column usually does not.