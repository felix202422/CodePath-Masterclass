# Solutions — Set 18: Everything, composed

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.
> Figures below match the executed runs in [graph-algorithms.md](../../graph-algorithms.md)
> and this batch's verification harness where marked.

## Exercise 1 — BFS metrics, predicted from the picture

Three counters readable *before* running, because the picture determines them:

- **Visited** = size of the reachable set from the source (vertices behind the frontier's
  reach are never touched).
- **Edges examined** = sum of out-degrees over visited vertices (BFS reads every neighbor
  list entry of every visited vertex once).
- **Max frontier** = the widest BFS level — a picture count, and the memory signature of BFS
  (the queue's high-water mark).

Components tool: the union-find cross-check from set 10, now on the lesson's protocol —
both counts must agree.

**Criteria check:** ☐ all three predicted ☐ matched ☐ component count verified against
union-find.

## Exercise 2 — Kahn's tie-break robustness

FIFO Kahn's emits *a* valid order; min-heap Kahn's emits the **lexicographically smallest**
valid order (among zero-indegree choices, always take the smallest label). Both outputs
verify acyclic-valid by checking every dependency edge. The use case to name: **reproducible
builds and deterministic schedules** — two machines must produce the same build order from
the same dependency graph, and FIFO order depends on *insertion order*, which is exactly the
kind of input-order dependence a build system cannot rely on. (The heaps lesson earns its
second appearance: this is its "priority + DAG" composition.)

**Criteria check:** ☐ both orders printed ☐ both verified ☐ determinism use case stated.

## Exercise 3 — The decision sheet

| workload | algorithm | the precondition that selects it |
|---|---|---|
| unweighted social hops | **BFS** (graphs.md) | every edge weight = 1 — hop count *is* distance |
| weighted airfares, non-negative | **Dijkstra** (graph-algorithms.md) | **all weights ≥ 0** — the iff from set 17 |
| a few negative edges, no negative cycle | **Bellman-Ford** | negatives allowed; V−1 full relaxation passes buy correctness at Θ(V·E) |
| DAG with edge costs | **DP over topological order** | acyclicity — one pass in topo order, each edge relaxed exactly once, Θ(V + E) |

The row that must not be swapped: Dijkstra "because it's faster" on the negative-edge row
returns the set-17 wrong answer (2 vs −7) — *silently*. The precondition column is the
algorithm selector; speed is a tie-break among algorithms whose preconditions all hold.

**Criteria check:** ☐ four assignments ☐ four preconditions ☐ the swap-refusal explained with
the executed wrong value.

## Exercise 4 — Delivery planner (capstone, independent)

**Reference shape.** "Shortest route visiting all stops from a depot" on one-way streets with
travel times = **directed TSP**, answered exactly by **Held-Karp** (bitmask DP — the DP
lesson's 2ⁿ states × n positions, composed with the graph lesson's adjacency):

- **State:** `best[S][v]` = shortest path visiting exactly the stops in bitmask S, ending at
  v. Transition: for each u in S\{v}: `best[S][v] = min(best[S−{v}][u] + w(u,v))`. States =
  2ⁿ·n, work per state = O(n) → **Θ(2ⁿ·n²)**, Θ(2ⁿ·n) memory.
- **Exact for n ≤ 15:** 2¹⁵·15² ≈ 7.4×10⁶ operations — comfortably a second; n = 20 is
  ~10¹⁰ — a different problem, by a factor of a thousand. That cliff *is* the complexity
  class doing its job in the answer.
- **Brute-force cross-check at n ≤ 8:** enumerate all (n−1)! orderings from the depot,
  take the min — must equal Held-Karp's answer on 10 fixed-seed instances. The two
  algorithms share no code path; agreement is a real proof, the two-algorithm pattern the
  whole subject has trained.
- **One-way streets matter:** the directed version cannot reuse the undirected shortcut
  (symmetry); with asymmetric costs, even the triangle inequality cannot be assumed — state
  what your implementation does when `w(u,v) ≠ w(v,u)` (it must, or the answer is fiction).
- **The honest guarantee, stated:** exact-optimal *for the given graph*, assuming travel
  times are deterministic (they aren't — traffic), visiting *every* stop exactly once (no
  re-fueling, no split deliveries). The approximate alternative: **nearest-neighbor + 2-opt**
  (greedy construction, local swaps) — runs in Θ(n²) per pass, guarantee: *no better than
  "within a factor"* — for metric TSP nearest-neighbor is within ~(log n)/2 of optimal and
  2-opt typically lands near it, but neither carries an exactness certificate; you trade the
  guarantee for the scale.

**Criteria check:** ☐ exact solver ☐ brute-force agreement on 10 instances ☐ Θ(2ⁿ·n²)
derived from the state space ☐ approximate alternative with its guarantee stated honestly.

---

Next: back to the index — [../README.md](../README.md)
