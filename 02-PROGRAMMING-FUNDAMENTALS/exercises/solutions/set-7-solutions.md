# Solutions — Set 7: Conditional Statements

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.

## Exercise 1 — Predict the chain

**Answer.**

| Input | Branch path | Result |
|---|---|---|
| `-1` | `<= 0` yes | invalid order |
| `9.999` | `<=0` no, `<10` yes | standard (3) |
| `10.0` | `<=0` no, `<10` **no** (10 is not < 10), `<50` yes | express (7) |
| `49.999` | `<10` no, `<50` yes | express (7) |
| `100` | all no → `else` | free |

The boundary insight: `10.0` fails the `< 10` test because the chain's partition is
`[0,10) → standard`, `[10,50) → express`, `[50,∞) → free` — half-open intervals, no gaps.

**Criteria check:** ☐ five predictions ☐ five actuals ☐ boundary explanation (half-open ranges).

## Exercise 2 — Truthiness predictions

**Answer.**

| Value | Predicted | Actual | Why |
|---|---|---|---|
| `"False"` | **truthy** | True | non-empty string; the *word* "False" is not the value `False` |
| `{}` | falsy | False | empty dict |
| `[0]` | truthy | True | non-empty list — element values do not matter |
| `0j` | falsy | False | complex zero; numeric zero in any form |
| `""` | falsy | False | empty string |
| `" "` | truthy | True | one space — not empty |

The surprise for most: `"False"` is truthy. Truthiness asks only "is it empty/zero/None?", never
"does it look falsey?".

**Criteria check:** ☐ six predictions ☐ surprising one explained ☐ verified with `bool()`.

## Exercise 3 — The shadowed chain

**Answer.** `if score >= 60: "pass" elif score >= 90: "honours"` — for 95, the **first** branch
matches (first-true-wins) and the `elif` is never evaluated, so 95 prints "pass" forever; the
honours branch is dead code. Fix — order specific → general:

```python
if score >= 90:
    result = "honours"
elif score >= 60:
    result = "pass"
else:
    result = "fail"
```

Real run: `score = 95` now yields `honours`.

**Criteria check:** ☐ diagnosis names skip/first-true-wins ☐ rewrite makes all three reachable
☐ 95 → honours in a real run.

## Exercise 4 — Ticket pricer (independent)

**Answer.** One valid rule pipeline, in a deliberate order:

1. Time base: `price = base` if hour < 17 and day is weekday; else `price = base * 1.5`.
2. Age discount (applies to the time-based price): `if age < 12 or age >= 65: price *= 0.5`.
3. Group discount last (composes on the already-discounted price): `if group >= 10: price *= 0.9`.

The order is a *requirement* decision — "50% off the time-based price" and "extra 10% off"
compose multiplicatively in the sequence stated; a different order changes prices for combined
cases, which is why your spec must fix it. Boundary evidence: age 11 → discount, 12 → no
discount; 64 → no, 65 → yes. Six combinations covering each rule plus two compound cases (child
in a peak group; senior off-peak alone) each traceable through the chain.

**Criteria check:** ☐ six rule-traceable combinations ☐ boundary ages 11/12 and 64/65 ☐ two
combined-rule cases ☐ validated inputs via the retry loop.

**Reviewer note:** the classic miss is applying discounts to the *base* instead of the running
price — the requirement's phrase "off the time-based price" pins the sequence; when in doubt,
write the invariant: "at every step, `price` is the current best-known cost."
