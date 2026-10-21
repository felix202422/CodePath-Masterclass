# Solutions — Set 12: Ordering disciplines

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.
> Reference numbers below were executed on the authoring machine (JDK 25.0.4.1,
> `javac --release 21`).

## Exercise 1 — Base-run counters predicted then run

Input `[5, 2, 8, 1, 9, 3, 7, 6, 4]`, n = 9.

- **Bubble sort** (with the early-exit flag's comparison counted): n(n−1)/2 = **36** —
  executed: `36`. The input has inversions, so no early exit.
- **Insertion sort** (counting inner while-tests, the comparison that fails included):
  **23** — executed: `23`. The count equals inversions + (n − 1): this input has 15
  inversions, 15 + 8 = 23. The identity is the lesson's point — insertion sort's cost *is*
  the inversion count, which is why nearly-sorted input costs ~n.

**Criteria check:** ☐ 36 predicted/printed ☐ 23 predicted/printed ☐ inversion identity noted.

## Exercise 2 — Stability, both directions

The witness: records with equal sort keys but distinguishable payloads, e.g.
`(key=1, tag=A), (key=0, tag=X), (key=1, tag=B)` — stable sorts must output
`X, A, B` (A before B); an unstable sort *may* output `X, B, A`.

- **Stable pair confirmed:** your insertion/merge sort preserve A-before-B on every size.
- **The witness hunt:** if no flip appears at your sizes, that is a *finding* — some unstable
  sorts (e.g. classic Lomuto quicksort on small inputs) may coincidentally preserve order;
  scale n until equal-key pairs land on opposite sides of a pivot. If you still see none,
  instrument: log every swap of two equal-key records with their tags — the log *is* the
  witness, even when the final order happens to agree. Reporting "no flip found, here's the
  swap log proving stability at these sizes" is a better answer than a fake flip.

**Criteria check:** ☐ stable direction confirmed ☐ real witness or instrumented swap-log
evidence ☐ payload order stated.

## Exercise 3 — Quicksort's worst case, then the fix

Sorted input, Lomuto with last pivot, n = 10,000: every pivot is the maximum of its subarray,
partitions are 0|n−1, and comparisons ≈ n(n−1)/2 ≈ **5×10⁷** — executed: the ≈n² row.
Random pivot on the same input: ≈ **1.4·n·log₂ n** comparisons — the ≈1.39 n ln n constant
showing up in your counter.

**Why sorted input is the adversary for *this* rule:** the last element of a sorted array is
its maximum — the pivot rule *chooses* the worst possible split every time, and the input
guarantees it. Random pivot (or median-of-three) breaks the adversary's knowledge: the input
can't be pre-sorted against a pivot chosen at runtime. The fix's residual risk: an adversary
that *knows your RNG seed* — state that the fix changes worst case to expected, it doesn't
delete it.

**Criteria check:** ☐ ≈n² counted row ☐ ≈1.4 n log n counted row ☐ mechanism + residual risk.

## Exercise 4 — Top-100 of a stream (independent)

**Reference shape.** "Top-k over a stream, memory capped" is the bounded max-heap from set 8:

- Keep a size-100 **max-heap** of the best records seen: per record, if it beats the root,
  replace root and sift-down — **Θ(log 100) ≈ 7** ops per record; otherwise discard.
  Memory: **100 records**, regardless of stream length — that's the requirement met, not a
  side effect.
- **Per-query cost:** the heap holds the top 100 *unordered*; a query either returns the
  root (the current #1, Θ(1)) or a sorted view (Θ(k log k) copy-sort of 100 elements —
  cache it and invalidate on update if queries are frequent).
- **Verification:** stream n = 1,000,000 fixed-seed values through the heap; ground-truth via
  full `Arrays.sort` of a retained copy (only in the test, where memory is allowed); the
  heap's contents must equal the sort's last 100 **as a set** (order differs — that's the
  heap's refusal, from set 7's list).

**Criteria check:** ☐ both classes derived ☐ equality against full-sort ground truth ☐ memory
claim = k, stated as the requirement met.

---

Next: [set-13-solutions.md](set-13-solutions.md)
