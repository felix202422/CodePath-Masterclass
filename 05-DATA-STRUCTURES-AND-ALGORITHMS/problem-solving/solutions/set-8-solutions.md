# Solutions — Set 8: Priority access

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.
> Reference numbers below were executed on the authoring machine (JDK 25.0.4.1,
> `javac --release 21`) where marked.

## Exercise 1 — Floyd heapify traced

Array `[7, 3, 9, 1, 5, 2]`, n = 6. Last parent index = n/2 − 1 = **2** (derive: parents occupy
indices 0…⌊n/2⌋−1 because each parent i has children 2i+1, 2i+2, and the last child index
n−1 belongs to parent ⌊(n−1−1)/2⌋).

Children of i are 2i+1 and 2i+2. Process parents right-to-left:

1. Index 2 (value 9): only child in range is index 5 (value 2). 9 > 2 → swap →
   `[7, 3, 2, 1, 5, 9]`. Sift 2 further down: child 5 is now 9, 2 < 9, stop.
2. Index 1 (value 3): children 3 (value 1) and 4 (value 5); min child = index 3. 3 > 1 →
   swap → `[7, 1, 2, 3, 5, 9]`. Index 3 is a leaf, stop.
3. Index 0 (value 7): children 1 (value 1) and 2 (value 2); min child = **index 1** (1 < 2).
   7 > 1 → swap → `[1, 7, 2, 3, 5, 9]`. Sift 7 from index 1: children 3 (value 3) and 4
   (value 5); min child = index 3. 7 > 3 → swap → `[1, 3, 2, 7, 5, 9]`. Index 3 is a leaf,
   stop.

Final heap array: `[1, 3, 2, 7, 5, 9]` — 8 sift steps total across the three parents
(2 + 1 + 5? — recount from your own trace: parent 2 moved 9 once, parent 1 moved 3 once,
parent 0 moved 7 twice = **4 sift steps**). The executed drain prints `1 2 3 5 7 9` (note:
heapify does **not** produce a sorted array — only the *drain* is sorted).

**Criteria check:** ☐ paper trace ends `[1, 3, 2, 7, 5, 9]` ☐ drain = executed poll order
`1 2 3 5 7 9` ☐ n/2 − 1 derived, not remembered.

## Exercise 2 — Top-k three ways (10 smallest of 1,000,000)

All three must agree — that agreement *is* the correctness check:

| method | time class | memory |
|---|---|---|
| (a) full sort | Θ(n log n) | Θ(n) |
| (b) size-k min-heap + counter (track k smallest seen: push, evict max when > k) | Θ(n log k) | Θ(k) |
| (c) bounded max-heap of size k | Θ(n log k) | Θ(k) |

(b) and (c) are the same algorithm with different eviction direction; the executed heap-op
counts should be ~n·log₂(10) ≈ 3.3n sift ops each — compare your counters to that. The
**measured memory**: k = 10 slots vs 1,000,000-element array — with boxed ints, ~40 B vs
~4 MB+; the top-k pattern's payoff is storing the *answer size*, not the *input size*.

**Criteria check:** ☐ three-way agreement ☐ op counts for (b)/(c) ☐ memory measured.

## Exercise 3 — Heapify vs n adds, counted

Same 100,000 elements, both paths, sift-op counters:

- **Floyd heapify:** ≤ 2n sift operations (each node sifts down at most its height; the sum
  over all nodes is bounded by 2n) — **linear**, the point of build-heap.
- **n adds:** each add sifts up ≤ log n — total ≈ n log n ≈ 100,000 × 17 ≈ 1.7×10⁶ ops,
  an order of magnitude more.

Both give *a valid heap*; only the counters distinguish them. The class conclusion: build
Θ(n), insert-each Θ(n log n) — always heapify an existing array.

**Criteria check:** ☐ both counts ☐ comparison to n·log n prediction ☐ class conclusion from
counters.

## Exercise 4 — Scheduler with priority drops (independent)

**Reference shape.** Two ways to lower the priority of a queued job (lower value = higher
priority, say):

- **(a) `removeAt(i)` + re-insert** — true decrease-key. Needs the element's index (keep a
  jobId→index map, updating it on swaps). removeAt = sift *up* then sift *down*, Θ(log n).
- **(b) Lazy re-insert** — insert a fresh entry with the new priority; mark the old entry
  stale; skip stale entries at poll time. The heaps lesson's approach — no `removeAt` needed.

**Counted comparison at n = 10,000** (say 5,000 inserts + 2,000 priority drops + 5,000 polls):

- (a): drop cost = 1 removeAt + 1 add = Θ(log n) each — total ops track the drop count ×
  log n, and the heap never holds more than the live set.
- (b): drop cost = 1 add, but every poll may skip stale entries — the skip count is the debt,
  and the heap holds up to (live + drops) entries — memory grows with the *history* of drops.

**Recommendation, cited:** (a) when drops are frequent relative to polls (your op counters
show skips dominating); (b) when drops are rare and `removeAt` isn't available (e.g. raw
arrays). **Correctness caveat for (b):** the skip loop must discard *any* stale entry at the
root, not just the first — and if all entries are stale, the "empty" check must look through
the garbage or the queue falsely reports empty.

**Criteria check:** ☐ both counted transcripts ☐ recommendation citing counts ☐ lazy caveat
stated.

---

Next: [set-9-solutions.md](set-9-solutions.md)
