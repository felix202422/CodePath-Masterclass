# Set 10 solutions — Test coverage → `test-coverage.md`

*Executed in the batch's Maven lab: JaCoCo 0.8.13 over the lab's suite, Java 25. Always
`clean` before comparing two reports — that rule is itself part of the answer.*

## 1. The baseline, reproduced

Delete the gap-closing tests, `mvn clean test`, open `jacoco.csv`:

```
TOTAL instruction 93.2% (358/384)  branch 79.4% (27/34)  line 94.0% (78/83)

TaxCalculator            86.0%  87.5%    CheckoutService  80.0%  75.0%
OrdersController        100.0%  70.0%    ApiAuthFilter    100.0%  75.0%
LabApplication           37.5%   n/a
```

The four classes that lose the closed tests are exactly the four with missed lines/branches:
`TaxCalculator` (guards + `getRate`), `CheckoutService` (`quantity <= 0`), `OrdersController`
(validation branches), `ApiAuthFilter` (the non-`/api/` false arm) — because coverage
follows execution: tests deleted, instructions unrun. The `main()` verdict: 37.5% is an
entry point with no assertions over its behavior — argue either side in three sentences,
but if you exclude it, write the reason next to the exclusion.

## 2. New class, no tests, then half-covered

The lessons' numbers for this exact drill (after their own 98.7% state):

```
before (all covered):    379/384 = 0.987
untested new class:      379/506 = 0.749   (AuditLogger: 0/122 instructions covered)
one method covered only: watch the INSTRUCTION counter move first;
                         BRANCH follows only when an if-arm is taken
```

What to report: three ratios from three `clean` builds, each with its test count. The
observation the criteria want: instruction coverage moves the moment *any* line of the new
code executes; branch coverage moves only when you take a previously untaken arm — so
"cover one method" moves the ratio but leaves the branch counter behind, and the gap you
care about is the guard you never triggered.

## 3. Lines green, branches not

Method with `switch` or chained `&&`: write a test passing inputs that hit every *line*
once, leaving one arm untaken. The report that proves it (lessons' shape):

```
TaxCalculator.java  L41:branch missed 1/2   ← line executed, one arm never taken
                    L41:instr covered, L42:instr missed
```

Your capture must show 100% line coverage on that method next to <100% branch coverage in
the same report — the disagreement is the point; line coverage reads greener than the code
is.

## 4. Independent — the weekly-ship coverage policy (reference shape)

The lessons' five fields, filled against a baseline, not a round number:

1. **Counter:** instructions (and branches for logic modules) — never lines alone.
2. **Floor:** e.g. 0.90 bundle — justified because the measured baseline is 0.987; a floor
   above today's number blocks everything, far below it blocks nothing.
3. **Movement:** ratchet up only; lowering requires its own commit with a reason
   (unreachable line, generated code) — never in the same commit as the red it silences.
4. **What the developer sees:** the failing rule and the reproduction command — the lessons'
   real failure text was `Coverage checks have not been met` + `GATE: FAIL at stage 3`,
   with the report showing `0.749 < 0.90`.
5. **Exemption path:** exclude at class/line level with a comment saying why (`main()` —
   structurally unreachable), sized so exclusions are visible in review.

Bonus (exercise 6): the two-build harness — `clean` on both sides, print the delta of the
feature branch. Without `clean` on both, you are comparing two different *test sets* (the
lessons' stale-class incident proved that: 52 tests, one failing, sources long gone).