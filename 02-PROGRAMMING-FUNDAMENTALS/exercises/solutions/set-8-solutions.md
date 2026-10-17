# Solutions — Set 8: Loops

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.

## Exercise 1 — Predict the ranges

**Answer.**

| Expression | Predicted | Why |
|---|---|---|
| `list(range(3, 10, 4))` | `[3, 7]` | start 3, +4 → 7, next 11 ≥ stop 10 → excluded |
| `list(range(10, 3, -3))` | `[10, 7, 4]` | descending; 4 > 3 kept, next 1 ≤ 3 → excluded |
| `list(range(4))` | `[0, 1, 2, 3]` | implicit start 0, stop excluded |

The rule in one line: **start included, stop excluded, direction from the step's sign** — the
same contract in all three cases.

**Criteria check:** ☐ three predictions ☐ three results ☐ start/stop/step cited.

## Exercise 2 — Characters with positions

**Answer.**

```python
word = "programming"
for i in range(len(word)):
    print(f"{i}: {word[i]}")
```

Ten lines, positions 0–9: `0: p`, `1: r`, … `9: a`, `10: m`, `11: g`. (The `enumerate` variant
— `for i, ch in enumerate(word):` — is the same output with the index handed to you; both are
acceptable, value iteration is preferred when the index is genuinely needed.)

**Criteria check:** ☐ 10 lines ☐ positions 0–9 ☐ characters correct.

## Exercise 3 — Fix the boundary twice

**Answer.** The bug: `for i in range(1, len(xs))` starts at **1**, skipping index 0 (value 3 →
total 11, not 14). Fix A: `range(len(xs))` — indexes 0..4. Fix B: `for x in xs: total += x` —
no index at all. Why B cannot off-by-one: it never mentions positions; the iteration *is* the
list, so there is no boundary to mis-state — the lesson's "iterate values" rule, demonstrated on
the bug that rule exists for.

**Criteria check:** ☐ both fixes print 14 ☐ one-sentence reasoning (no index → no boundary).

## Exercise 4 — Statistics reporter (independent)

**Answer.** Shape and its evidence:

```python
values = []
while True:
    raw = input("number (q to stop): ")
    if raw == "q":
        break
    try:
        values.append(float(raw))
    except ValueError:
        print(f"  '{raw}' is not a number")
        continue

if not values:
    print("no data")
else:
    print(f"count: {len(values)}")
    print(f"min:   {min(values)}")
    print(f"max:   {max(values)}")
    print(f"mean:  {sum(values) / len(values):.2f}")
    for v in values:
        print(f"{v:>5.0f} " + "*" * int(v))
```

Hand-check on `[3, 1, 4, 1, 5]`: count 5, min 1, max 5, mean 14/5 = 2.80; the histogram's
bucket rule (star count = integer part) verified per value. Empty input prints `no data` — the
`if not values` guard, not a crash from `min([])`. Non-numeric entries print a message and re-ask
without entering the list — the retry pattern, now feeding a loop.

**Criteria check:** ☐ empty case handled ☐ stats hand-checked ☐ histogram verified ☐ only
`len/min/max/sum` used.
