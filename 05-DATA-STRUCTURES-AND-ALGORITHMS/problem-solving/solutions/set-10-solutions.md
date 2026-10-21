# Solutions — Set 10: Reachability

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.

## Exercise 1 — BFS and DFS orders from B

**The frontier sentence first:** BFS's frontier is a **FIFO queue** (the graphs lesson's ring
queue — set 5's structure earned its keep); DFS's is a **LIFO stack**, typically the recursion
call stack itself. Same graph, same start vertex, different order — because the *admission
policy* differs, not the traversal logic (mark visited on entry, loop over neighbors).

Predict both on paper by maintaining the frontier contents per step, then run. Any mismatch
between your paper order and the program's means your paper frontier used the wrong discipline
— that's the diagnostic, and it's why the trace is per-frontier, not per-vertex.

**Criteria check:** ☐ both orders predicted ☐ both printed ☐ frontier discipline named.

## Exercise 2 — Components tool

The sweep: `for each vertex v: if not visited[v]: components++; bfs(v)`. Each BFS marks its
whole reachable set; the loop's unvisited survivors *are* the components.

**Ground truth:** union-find (union every edge's endpoints, count distinct roots) — an
independent algorithm whose answer must agree. Deliberate isolated vertices ensure the count
isn't accidentally 1; report at least one isolated vertex's component of size 1.

Both methods printing the same count is a two-algorithm proof — the pattern the whole subject
has hammered (counters before clocks, two ways or none).

**Criteria check:** ☐ counts agree ☐ isolated vertex present ☐ method named for ground truth.

## Exercise 3 — Diameter via all-pairs BFS

**Derivation first:** BFS from one source is Θ(V + E); from every source: **Θ(V·(V + E))**.
Eccentricity of v = max BFS-distance from v; diameter = max eccentricity.

On a 6-vertex sample: compute every BFS tree by hand, take per-source maxima, take the max —
the executed diameter must equal that hand value. On the larger fixed-seed graph, the sweep
just runs; the sample check is what proves the *code*, the big run is what reports the number.

Worth stating: this is the naive diameter algorithm; for large sparse graphs the
two-BFS approximation (pick arbitrary s, BFS to farthest t, BFS from t) is Θ(V + E) and
*exact* for trees, approximate otherwise — name which guarantee your use case needs.

**Criteria check:** ☐ O(V·(V+E)) written first ☐ sample diameter hand-verified ☐ approximation
mentioned or justified away.

## Exercise 4 — Shortest chain between two users (independent)

**Reference shape.** BFS *unweighted* — every edge weight 1, so the first time BFS reaches
the target is via a shortest chain. Reconstruct the path by walking parents[] from target to
source (the arrays lesson's discipline: store, then trace back).

- **Path verified edge-by-edge:** each consecutive pair must be an actual edge — check
  against the adjacency structure, not against your own output.
- **The visited count:** BFS touches every vertex within the answer's distance d before
  finding it — the number that matters at scale is **the frontier's size**, which grows
  exponentially in d for a well-connected graph. That's the six-degrees phenomenon *and* the
  reason the same algorithm is cheap on social graphs of 10⁸ users: the answer distance is
  small, so the visited set stays small relative to V. Report visited/total as the honest
  cost metric — the runtime is Θ(visited + edges examined), not Θ(V).

**Criteria check:** ☐ path verified edge-by-edge ☐ visited count reported ☐ frontier-growth
argument in terms of d.

---

Next: [set-11-solutions.md](set-11-solutions.md)
