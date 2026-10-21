# Solutions — Set 14: Exhaustive search

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.
> Reference numbers below were executed on the authoring machine (JDK 25.0.4.1,
> `javac --release 21`).

## Exercise 1 — Placement sum, derived then confirmed

At choice-depth d (0-based), the number of partial paths is the number of ordered selections
of d+1 of n elements: P(n, d+1) = n!/(n−1−d)!. Total placements = Σ over levels:

- n = 4: 4 + 12 + 24 + 24 = **64** — the lesson's own executed figure.
- n = 5: 5 + 20 + 60 + 120 + 120 = **325** — executed by this batch's verification harness.

The instrumented solver must print the same. The formula written from the trace is the real
deliverable: placements count **partial paths**, not solutions — the two-counter discipline
(lesson backtracking.md) again.

**Criteria check:** ☐ formula written ☐ 325 derived ☐ 325 executed ☐ equal.

## Exercise 2 — N-queens against the known sequence

Executed counts for n = 1..10 must equal **1, 0, 1, 2, 10, 4, 40, 92, 352, 724** — all ten
rows, no skipping. n = 4's two solutions: columns `[1, 3, 0, 2]` and `[2, 0, 3, 1]` (column
per row) — the lesson prints both; verify attack-free by hand: no two share a column (all
distinct by construction) and no two share a diagonal (|Δrow| = |Δcol| for every pair — check
each of the 6 pairs per board).

A wrong count at some n localizes the bug: n = 2 and n = 3 returning nonzero means the safety
test checks columns but not diagonals; n = 4 wrong means even the column check is broken.

**Criteria check:** ☐ ten matching rows ☐ both n=4 boards printed ☐ one board hand-verified.

## Exercise 3 — The broken un-choose

Removing the swap-back line from `permute`'s loop corrupts the **caller's** array across
recursive levels: level k's iteration swaps, recurses, and — without the restoring swap —
the array arrives at level k+1 already permuted from a *different* base than level k expects.
The first solution still prints correctly (the deepest level's path was valid when recorded);
subsequent ones print permutations **of a corrupted array** — often with duplicate elements
and missing ones, because a swap without restore can put the same value in two positions of
the *shared backing array* the path views.

The lesson to carry: `choose → recurse → un-choose` is a *pair*; the un-choose is what makes
the recursion share one array instead of copying per branch — the memory/speed trade, paid
with discipline.

**Criteria check:** ☐ corrupted output captured ☐ mechanism = un-restored shared state across
levels ☐ why solution #1 survives explained.

## Exercise 4 — Subset counting with a multiset (independent)

**Reference shape.** Count subsets summing to target from a multiset: recursion over index i
(take-if-fits / skip), **sort first and skip duplicates at the same level** (the
choose/avoid-duplicates rule) so `{1,2}` and `{2,1}` count once — the sort makes equal values
adjacent, making the skip a local test.

- **Ground truth:** brute-force enumerator generating all 2ⁿ subsets for n ≤ 15, counting
  matches — agree on 10 fixed-seed random instances (multisets with repeated values, targets
  near half the total sum, so both pruned and unpruned branches do real work).
- **The prune and its safety:** pruning "skip branches whose partial sum already exceeds
  target" (with all-positive values) is safe because sums are monotone — no extension of an
  over-target prefix can come back under. State *your* values' sign assumption; with
  negatives the prune is unsound and must go — that's the two-sentence argument.

**Criteria check:** ☐ 10-instance agreement with brute force ☐ duplicate handling by
sort+skip ☐ prune safety argued with the sign assumption named.

---

Next: [set-15-solutions.md](set-15-solutions.md)
