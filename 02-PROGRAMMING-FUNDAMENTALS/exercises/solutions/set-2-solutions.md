# Solutions — Set 2: Algorithms and Pseudocode

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.

## Exercise 1 — Trace linear search

**Answer.**

| Step | index | value | comparisons | found? |
|---|---|---|---|---|
| 1 | 0 | 7 | 1 | no |
| 2 | 1 | 2 | 2 | no |
| 3 | 2 | 9 | 3 | **yes → return (2, 3)** |

Running the lesson's `linear_search` prints the same three comparison lines and
`found 9 at index 2 after 3 comparisons`.

**Criteria check:** ☐ table complete ☐ matches real program output ☐ both verified on your
machine.

## Exercise 2 — Binary search at scale

**Answer.** 2^20 = 1,048,576 > 1,000,000, so halving reaches the target in **at most 20
comparisons** (worst case: absent target, range shrinks to empty). Linear search checks every
item when absent: up to **1,000,000** comparisons. Same guarantee of correctness; the difference
is growth: linear grows with n, binary grows with log₂ n.

**Criteria check:** ☐ ~20 with halving arithmetic ☐ linear contrast ☐ growth stated in one
sentence.

## Exercise 3 — Edge cases in pseudocode

**Answer.** Adding to the lesson's `LINEAR_SEARCH`:

```text
    IF LENGTH(items) = 0 THEN
        RETURN -1, 0        # empty: nothing to compare
    ...
    # 'all larger than target' needs no special case: the loop checks every
    # element and falls through to RETURN -1, comparisons - but TRACE it once
    # to confirm the comparison count is len(items), not len(items) + 1.
```

The trace row for the all-larger case (items `[5, 6, 7]`, target `1`): three "no match" rows,
final `RETURN -1, 3`.

**Criteria check:** ☐ empty case defined with count ☐ all-larger traced ☐ count justified.

## Exercise 4 — Generator: pseudocode, trace, code (independent)

**Answer.** Skeleton trace for input `4 8 15 16 23 42`:

| Pass | value | count | total | min | max |
|---|---|---|---|---|---|
| 1 | 4 | 1 | 4 | 4 | 4 |
| 2 | 8 | 2 | 12 | 4 | 8 |
| 3 | 15 | 3 | 27 | 4 | 15 |
| 4 | 16 | 4 | 43 | 4 | 16 |
| 5 | 23 | 5 | 66 | 4 | 23 |
| 6 | 42 | 6 | 108 | 4 | 42 |

Expected output line: `average = 108 / 6 = 18.0`. The implementation's real output must match
this table and line exactly — that agreement *is* the completion criterion, and it is what makes
this exercise the subject's bridge from planning to coding.

**Criteria check:** ☐ pseudocode covers all three input cases ☐ hand-trace complete ☐ real
output matches line for line.

**Reviewer note:** if the trace and the program disagree, do not "fix the trace" — the trace
came from the requirement; the program is what is wrong (the debugging lesson's rule).
