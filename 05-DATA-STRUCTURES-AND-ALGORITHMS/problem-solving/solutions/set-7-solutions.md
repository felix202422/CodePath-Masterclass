# Solutions — Set 7: Hierarchies

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.

## Exercise 1 — BST insert/remove traced

Insert sequence `50, 30, 70, 20, 40, 60, 80` builds the perfectly balanced 3-level tree with
50 at the root, 30/70 as children, and 20/40/60/80 as leaves. In-order: `20 30 40 50 60 70 80`
— sorted, always, for every BST: that is the invariant doing all the work.

**The successor rule, written first:** removing a two-children node = find the *smallest key
in its right subtree* (leftmost node), copy that key into the node, then remove *that
successor node* — which by construction has no left child, so it's a leaf or one-child case.

Hand trace of removing 50 (two children): successor = leftmost of right subtree = **60**.
Copy 60 into the root, then delete the 60-node (a leaf). Tree becomes root 60, right subtree
70/80 with 70 promoted... in-order after each removal: `20 30 40 60 70 80`, then
`20 30 40 60 70` (removing a leaf), etc. Each executed in-order matches the trace — and
staying sorted after every removal *is* the passing `validate()` row.

**Common failure:** removing a two-children node by promoting the whole right subtree —
breaks the BST invariant below the promotion point. The successor rule preserves it because
the successor is the *boundary* key.

**Criteria check:** ☐ rule written before code ☐ two-children hand trace ☐ in-orders matched.

## Exercise 2 — Shape battery (1,000 keys)

| Shape | height | depthOf(maxKey) | reading |
|---|---|---|---|
| ascending | ≈ 1000 | ≈ 999 | degenerate path — every insert went right |
| descending | ≈ 1000 | ≈ 1 | same path, mirrored — maxKey is now near the root |
| shuffled | typically 13–30 | ≈ height | O(log n)-shaped; report your height/log₂(1000) ratio (log₂ n ≈ 10, so expect ratio ~2–3) |

**The class statement from your numbers:** lookup cost is Θ(h) — so the two sorted shapes
give Θ(n) lookup from an O(log n)-*named* structure, and the shuffled shape gives what the
name promises. The `depthOf(maxKey)` column is the sharpest single witness: it jumps from ~1
to ~999 purely from input *order*, with identical key sets.

**Criteria check:** ☐ three heights ☐ shuffled ratio reported ☐ O(h)-with-h range stated.

## Exercise 3 — Disproving "BST lookup is O(log n)"

The claim is falsified by the ascending build: same structure, same n, lookup of the max key
takes ~1000 comparisons where log₂(1000) ≈ 10. One counterexample kills a universal claim —
that's the whole method from the algorithm-analysis lesson, applied to a data structure.

**The corrected claim, precisely:** *lookup is O(h) where h ∈ [log₂(n+1) − 1, n−1]; h = O(log
n) holds for randomly-ordered insertions in expectation, and for **balanced** trees
(AVL/Red-black) by enforced invariant — never for arbitrary insertion order on a plain BST.*

**Criteria check:** ☐ counter-run ☐ corrected claim naming h and its conditions.

## Exercise 4 — Always-the-minimum stream (independent)

**Reference shape.** "Always the minimum, fast inserts, streaming keys" is a **min-heap**
(the heaps lesson, inverted):

- Inserts are sift-up Θ(log n); `peekMin` is Θ(1) — the root *is* the answer by the heap
  invariant. A counted 1,000,000-op run: total sift ops ≈ n log n ≈ 2×10⁷ territory, all
  within the Θ(log n)-per-insert class.
- **What it refuses, each with an answering structure:**
  1. *Sorted traversal on demand* — a heap enumerates unsorted (Θ(n) drain gives sorted, but
     destroys it); the **BST** (trees lesson) answers in-order Θ(n) with sorted output.
  2. *Lookup by key* — a heap cannot find an arbitrary key better than Θ(n); the **hash
     table** answers Θ(1).
  3. *The k-th smallest, not the smallest* — a heap of size n doesn't index ranks;
     a **sorted array or BST with subtree sizes** does (Θ(log n) with size caching).

**Criteria check:** ☐ counted 1M run within class ☐ three refusals ☐ named structure per
refusal.

---

Next: [set-8-solutions.md](set-8-solutions.md)
