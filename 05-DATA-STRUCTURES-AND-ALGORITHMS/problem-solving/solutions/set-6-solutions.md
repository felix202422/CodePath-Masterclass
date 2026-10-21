# Solutions — Set 6: Keyed access

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.
> Reference numbers below were executed on the authoring machine (JDK 25.0.4.1,
> `javac --release 21`) where marked.

## Exercise 1 — Hand-hash three keys

`"cat".hashCode()` — executed: **98262** (derivable: h = ((99·31) + 97)·31 + 116 for c,a,t).
Slot in a 16-slot table: `(98262 & 0x7fffffff) % 16` = **6**.
`"dog".hashCode()` — executed: **99644**, slot **12**. Both odd → positive, so the
`& 0x7fffffff` mask changes nothing here (it exists for *negative* hashCodes, e.g. any key
whose hash overflows — try `"polygenelubricants"`, which hashes to 0).

Third key prediction: whatever you chose, the method is the same — write `h`, mask, mod. The
insertion order matters only for chains: a third key landing in slot 6 or 12 extends that
chain, and load = 3/16 = 0.19 after three inserts.

**Criteria check:** ☐ three predictions ☐ three printed rows ☐ index formula written.

## Exercise 2 — The contract test

The `Point(x, y)` with `equals` only: default `hashCode` is *identity-based* — two equal
points at `p1(1,2)` and `p2(1,2)` land in different buckets. Executed shape: `map.get(p2)`
returns **null** after `map.put(p1, 1)`, and `map.size()` is 1 — the entry is *there*,
unreachable by value. That is the wrong-answer row: no exception, a silent miss.

Add `hashCode` returning `31*x + y`, re-run: `get(p2)` returns 1.

**The tree-map sentence:** `TreeMap` orders by *comparison*, not hashing — it has no
`hashCode` contract at all. The failure mode moves: a broken `compareTo` (inconsistent with
`equals`) makes two equal keys *distinct entries* in a TreeMap instead of unreachable ones.
One contract per lookup discipline: equals+hashCode for hashing, compareTo+equals-consistency
for ordering.

**Criteria check:** ☐ failing row ☐ fixed row ☐ tree-map contrast sentence.

## Exercise 3 — Load-factor experiment

At n = 100,000 with three resize triggers:

| factor | expected shape | trade-off |
|---|---|---|
| 0.5 | short chains (avg ≈ 1.5 visits), ~2× memory for the table | fast lookups, more copying on resize |
| 0.75 | Java's default — avg ≈ 2 visits | balanced |
| 0.9 | longer chains (avg ≈ 2.5+), tail spikes worse than the mean | memory-cheap, degradation *before* the resize, and resize itself copies more per event |

The row to report: **average probe/visit count per factor** (instrument it — count `equals`
calls). Mean chain length is load/(1−load) in a good hash's expectation, but the *max* chain
is what users feel: report both, because the max is your worst-case O(n) exposure.

**Criteria check:** ☐ three-row table ☐ visits instrumented ☐ memory-vs-probes stated with
your numbers.

## Exercise 4 — Dense ids with range queries (independent)

**Reference shape.** The two demands — keyed lookup *and* `[a, b]` range — select the
structure jointly:

- **Choice: direct-address array** (`Entry[] table` indexed by id) — lookup Θ(1) worst (not
  even amortized), and the range query is a Θ(b − a) scan of contiguous slots. Dense ids
  (0..maxId with few holes) make memory ≈ maxId × 8 B, acceptable when ids are dense by
  definition.
- **Disqualified: hash table** — its range query is Θ(n) full scan (no order exists); the
  class that fails is the *range* class, by construction.
- **Disqualified: BST** — it answers both (Θ(h) lookup, Θ(h + k) range) but its worst lookup
  is Θ(n) on adversarial insert order unless balanced, and the workload said *dense small
  ints* — where the tree's log factor buys nothing the array doesn't already guarantee in O(1).
- **Range result verified:** pick a `[a, b]`, print matches, cross-check against a brute-force
  scan of your own inserted set — the two lists must agree exactly.

**Criteria check:** ☐ choice justified by access *and* range classes ☐ one alternative named
with its failing class ☐ range result verified against brute force.

---

Next: [set-7-solutions.md](set-7-solutions.md)
