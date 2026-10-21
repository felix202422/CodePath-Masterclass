# Solutions — Set 15: When greedy suffices, and when it lies

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.
> Reference numbers below were executed on the authoring machine (JDK 25.0.4.1,
> `javac --release 21`).

## Exercise 1 — {1, 3, 4}, target 6: the exchange argument's failure point

**Executed:** greedy (largest-first) = **3 coins** (4 + 1 + 1); DP/optimal = **2 coins**
(3 + 3). The verification harness swept targets 1–10 and greedy == dp for every t < 6 — 6 is
the first divergence.

**The exchange argument, and where it dies.** The standard argument says: given an optimal
solution using a smaller coin where the greedy used a large one, swap the smaller coins for
an equal-or-better large one — the count doesn't rise. For target 6 the greedy picks {4,1,1}.
To *exchange* the two 1s toward optimality you'd replace `1+1` with... nothing useful: the
only coin ≤ 2 is 1 itself, and `3+3` uses a structure ({3,3}) that never passes through the
greedy's first choice. The failing step is precisely: **"replace the smaller coins with one
larger coin without increasing the count"** — for 1+1 there is no larger coin ≤ 2 that fits,
so the exchange is impossible, and with it the proof.

**Criteria check:** ☐ greedy = 3, optimal = 2 ☐ failing step named.

## Exercise 2 — Smallest failing target, tabulated

The DP sweep 1–10 (executed):

| t | 1 | 2 | 3 | 4 | 5 | **6** | 7 | 8 | 9 | 10 |
|---|---|---|---|---|---|---|---|---|---|---|
| greedy | 1 | 2 | 1 | 1 | 2 | **3** | 2 | 2 | 3 | **4** |
| dp | 1 | 2 | 1 | 1 | 2 | **2** | 2 | 2 | 3 | **3** |

**First failure: t = 6.** A second divergence at t = 10 (greedy 4 = 4+4+1+1, dp 3 =
4+3+3).

**The canonical escape:** if every coin ≥ (sum of all smaller coins) + 1 — equivalently for
{1,3,4}: is 3 ≥ 1+1 = 2 ✓, is 4 ≥ 1+3+1 = 5 ✗ — greedy cannot be trapped, because the greedy
choice always covers the remaining range the smaller coins couldn't. {1,3,4} fails the test
at exactly the coin (4 < 5) that produces the t = 6 trap: 6 needs two 3s, but greedy spends
its budget on 4 first and can't recover with 1s.

**Criteria check:** ☐ table with both rows ☐ t = 6 identified ☐ canonical inequality checked
against {1,3,4} and failing at coin 4.

## Exercise 3 — Fractional vs 0-1, hand-worked

Items (v, w): (40,3), (45,4), (50,5), (90,9); capacity 10. Densities v/w:
**13.33, 11.25, 10.0, 10.0**.

- **Fractional (density greedy):** take (40,3) whole — cost 3, value 40; take (45,4) whole —
  cost 7, value 85; 3 capacity left; next density is a **tie at 10.0** between (50,5) and
  (90,9) — either gives the same value per weight, take 3/5 of (50,5): +30. **Total = 115.**
- **0-1 (enumeration over 2⁴ = 16 subsets):** the winner is {(45,4), (50,5)} — weight 9 ≤ 10,
  **value 95**. Also-rans: {(40,3),(45,4)} = 85; {(90,9)} = 90; {(40,3),(50,5)} = 90.

**The property that separates them:** fractional knapsack's feasible set is **downward-closed
with divisible items** — taking a prefix of the density order is always legal, so the greedy
prefix is optimal. 0-1's feasible sets are *integer subsets*: the density prefix
{(40,3),(45,4),⅗(50,5)} has no integer analogue, and the best integer subset (95) is *not*
the truncation of the fractional one. The invariant "each next choice is safe given the
previous" holds only where partial choices remain extendable — which is the whole
sufficiency question for every greedy.

**Criteria check:** ☐ fractional = 115 with split item named ☐ 0-1 = 95 with subset listed ☐
downward-closure stated as the difference.

## Exercise 4 — Activity selection: prove it, then break the variant (independent)

**Reference shape.** Maximum *count* of compatible intervals — earliest-finish-time greedy,
proved by exchange: take any optimal solution's first activity; if it finishes later than
the greedy's first pick, swap it for the greedy pick — the swap leaves room for everything
that followed (the greedy pick ends no later), so the optimal solution with the greedy's
first choice is at least as good. Induction completes it.

**The variant that breaks it:** maximum *total value* (each activity has a value; goal =
maximize the sum). Same greedy fails: intervals A = [0,2] v=100, B = [1,3] v=1, C = [2,4]
v=100 — earliest-finish picks A first, then C is incompatible with A? (A ends 2, C starts 2
— compatible if touching counts; make C = [2.5, 4] if not). The failing instance: greedy
takes A + nothing-else-fitting after B-conflicts... simplest witness: A=[0,2] v=2, B=[1,3]
v=100, C=[2,3] v=2 — greedy takes A (finishes first), then C: total 4; optimal takes B
alone: 100. **Why the argument broke:** the exchange step's invariant was "swapping in the
earliest finisher never removes feasible successors" — true for *counting* (the resource is
"time available"), false for *valued* choices where the swapped-out activity's value was the
objective. The greedy property lives in the objective, not the constraint.

**Criteria check:** ☐ exchange argument written ☐ failing instance with both totals ☐ the
invariant named as objective-dependent.

---

Next: [set-16-solutions.md](set-16-solutions.md)
