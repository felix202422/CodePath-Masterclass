# Solutions — Set 13: Divide, and recursion's bill

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.
> Reference numbers below were executed on the authoring machine (JDK 25.0.4.1,
> `javac --release 21`).

## Exercise 1 — fib(6) call tree, drawn then counted

The tree with values (each node = one call):

```
                        fib(6)
              fib(5)            fib(4)
         fib(4)   fib(3)    fib(3)   fib(2)
       fib(3) fib(2)  fib(2) fib(1)  ·  ·
     fib(2) fib(1)   ·  ·   ·  ·
    ·  ·
```

Count the nodes: with base `fib(1) = fib(2) = 1` (so fib(0) is never called), the tree has
**15 calls** — closed form **calls(n) = 2·fib(n) − 1**, derived from
 calls(n) = 1 + calls(n−1) + calls(n−2) with calls(1) = calls(2) = 1: check n=3 → 3 = 2·2−1
✓, n=4 → 5 = 2·3−1 ✓, n=6 → 15 = 2·8−1 ✓.

**Convention warning:** a harness with base `n <= 1` (which also calls fib(0)) satisfies
calls(0) = calls(1) = 1 and gives **calls(n) = 2·fib(n+1) − 1** instead — that is the
convention behind exercise 2's executed numbers (fib(33) → 11405773 = 2·fib(34) − 1).
Derive *your* constant from *your* base case and let the counter adjudicate; a mismatch is a
base-case question, not a mathematics question.

**The double-counting, pointed at in the tree:** fib(4) appears **twice**, fib(3) **three
times** — the same subproblem computed again and again. That's the visual form of the
overlap that set 16's DP removes.

**Criteria check:** ☐ tree drawn ☐ 15 nodes counted (25 under the n≤1 base — stated which)
☐ closed form derived from your base case ☐ repeated subproblems named from the drawing.

## Exercise 2 — The φⁿ ratio, predicted then run

Calls(n) = 2·fib(n+1) − 1 (the n ≤ 1 base case of exercise 2's harness) ≈ 2φⁿ⁺¹/√5.
Predictions and the executed instrument:

| n | predicted calls ≈ 2·fib(n+1) | executed calls | ratio to n−1 |
|---|---|---|---|
| 33 | ~1.14×10⁷ | **11405773** | — |
| 34 | ~1.85×10⁷ | **18454929** | 1.6180… |
| 35 | ~2.99×10⁷ | **29860703** | 1.6180… |

All three executed on this machine; the measured ratios converge on **φ = 1.6180339…** — one
more digit per step, exactly as the closed form predicts. If your predicted and actual
disagree: check your base case (fib(0) vs fib(1) shifts everything by one) before doubting
the mathematics.

**Criteria check:** ☐ three predictions with tolerance ☐ measured ratios ≈ 1.618 printed.

## Exercise 3 — Merge sort, counted and stability-checked

- **Comparison counts:** merge sort does between n⌈log₂ n⌉/2 and n log₂ n − n + 1
  comparisons depending on merge implementation (the in-place-prefill variant hits the lower
  bound by skipping equal-prefill comparisons). Sorted, reversed, and random inputs produce
  **nearly identical counts** — merge sort is *not* adaptive; that column in the sorting
  lesson's table has now cost you two counters to see.
- **Stability:** the merge's tie rule decides it — `if (right[j] < left[i]) take right else
  take left` (taking **left** on equality) preserves the original relative order of equal
  keys. Quote the line from your own code that implements it; deleting the `else`'s tie
  direction and re-running the tagged records shows the flip.

**Criteria check:** ☐ three counted rows ☐ stability verdict with the tie rule quoted from
your code.

## Exercise 4 — Merge of two sorted runs, skewed inputs (independent)

**Reference shape.** The 2-pointer merge, measured on three families where one side is
exhausted early:

| family | comparisons | why |
|---|---|---|
| A = n/2 copies of x, B = n/2 copies of y, x < y | **n/2** | B's head always loses; A drains, B's head never advances until the end |
| interleaved distinct keys (a₁ < b₁ < a₂ < b₂ …) | **n − 1** | every element but the last wins a comparison |
| one side length 1, other n (worst for the 1-side) | **1** | the single element wins or loses once, then the long side drains free |

The structure explaining it: the comparison loop advances the side with the smaller head, and
**each comparison advances exactly one pointer** — total comparisons = (elements advanced) −
1 + ties, so it's bounded by n − 1 *always*, and collapses to min(m, n) when one side's head
loses every round. The "nearly exhausted" production case is the last row: the last element
of the short side costs one comparison and the rest of the long side merges free — Θ(n) total
with a tiny constant, which is why streaming merges of a 1-record buffer into a long run are
cheap.

**Criteria check:** ☐ three counted families ☐ explanation naming the advancing-pointer loop ☐
the Θ(n)-with-tiny-constant observation.

---

Next: [set-14-solutions.md](set-14-solutions.md)
