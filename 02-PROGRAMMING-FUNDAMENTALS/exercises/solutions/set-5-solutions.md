# Solutions — Set 5: Operators

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.

## Exercise 1 — The six results

**Answer.** (All verified by running; the lesson's sign rules decide the negatives.)

| Expression | Result | Rule |
|---|---|---|
| `20 / 6` | `3.3333333333333335` | true division, always float (binary approximation — 01's lesson) |
| `20 // 6` | `3` | floor toward −∞ |
| `20 % 6` | `2` | 20 = 3×6 + 2 |
| `6 % 20` | `6` | divisor larger than dividend → dividend is the remainder |
| `-20 // 6` | `-4` | **not** −3: −20/6 ≈ −3.33 floors to −4 |
| `-20 % 6` | `4` | sign follows the divisor: −20 = (−4)×6 + **4** |

The identity check for the last row: `(−4) × 6 + 4 = −24 + 4 = −20`. ✓

**Criteria check:** ☐ six predictions ☐ six real results ☐ mismatches explained by the sign or
flooring rule.

## Exercise 2 — Digits of 4827

**Answer.**

- Last digit: `4827 % 10` → **7**.
- Second digit: `(4827 // 10) % 10` → `482 % 10` → **8**.
- Odd/even: `4827 % 2` → `1` → **odd**.

Each is `%`-and-`//` only — the digit toolbox from section 5.1, no strings.

**Criteria check:** ☐ three values ☐ expressions shown ☐ arithmetic traceable.

## Exercise 3 — Chains

**Answer.** `0 <= x <= 100` (for `x = 50` → True) and `-1 < y < 1` (for `y = −0.5` → True). The
chained form evaluates the shared middle variable **once per comparison pair** and cannot drift:
`x >= 0 and x <= 100` repeats the name, and a typo in the second `x` compiles silently in
C-family languages. Python's chain reads like the requirement because it *is* the requirement's
mathematics notation.

**Criteria check:** ☐ both chains written ☐ results confirmed by run.

## Exercise 4 — The precedence bug (independent)

**Answer.** Intent: `total > 100 and (urgent or repeat)`. Written: `total > 100 and urgent or
repeat`. Precedence binds it as `(total > 100 and urgent) or repeat` — so a **repeat customer
with a total of 10** evaluates True, but the intent says False. Counterexample row: `total=10,
urgent=False, repeat=True` → code True, intent False. Fix: parenthesise the `or`:
`total > 100 and (urgent or repeat)`.

**Criteria check:** ☐ counterexample row ☐ corrected expression ☐ precedence rule named
(`and` binds tighter than `or`).

## Exercise 5 — Clock arithmetic (independent)

**Answer.** The modulo shape, no conditionals:

```python
def after_hours(hour, n):
    return (hour + n) % 24


def to_12(hour24):
    h = hour24 % 12
    return 12 if h == 0 else h      # 0 maps to 12 on a 12-hour clock
```

Test pairs: `(23 + 5) % 24` → 4; `(2 + −5) % 24` → 21 (negative wrap — the `%` sign rule doing
the work); `(0 + 24) % 24` → 0; `(11 + 1) % 12` → 0 → displayed as 12; `(12 + 12) % 24` → 0 →
12-hour 12.

**Criteria check:** ☐ wrap-around correct ☐ negative case correct ☐ zero `if` statements in the
24-hour path ☐ five pairs shown.

**Reviewer note:** the `to_12` ternary is a *display* rule, not time arithmetic — the exercise
allowed conditionals nowhere in the hour calculation, and this respects that line.
