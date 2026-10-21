# Solutions — Set 17: Costs over graphs

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.
> Dijkstra distances and Kahn outputs below match the executed runs in
> [graph-algorithms.md](../../graph-algorithms.md) (same graphs, same seeds).

## Exercise 1 — Dijkstra predicted then run

On the lesson's weighted graph from A: write tentative distances, settle the smallest
tentative each step, freeze it. The executed settle order and final distances (from the
lesson's harness, verified by hand this batch): **B = 7, C = 9, F = 11, D = 20, E = 20**.

The discipline that catches prediction errors: a vertex's distance updates *only* through
unfrozen neighbors — the moment you relax through a frozen vertex on paper, your trace has
Dijkstra's bug built in (see exercise 3).

**Criteria check:** ☐ seven predicted distances ☐ matched ☐ settle order predicted.

## Exercise 2 — Kahn by hand

The per-step protocol: compute in-degrees; repeatedly remove a zero-indegree vertex, decrement
its successors' in-degrees, repeat. Your hand queue state per step must produce a valid order;
the executed run may pick a *different* valid order at any tie (two vertices at zero at the
same moment) — that's not a mismatch, it's topological order's non-uniqueness. Verify yours:
every edge (u, v) has u before v in your sequence.

**Criteria check:** ☐ hand order valid ☐ tie-break freedom noted ☐ edge-order verified.

## Exercise 3 — The negative-weight diagnostic

Lesson graph (directed): `A→B(1), A→C(2), C→B(−10), B→D(1)`, source A.

- **Dijkstra** settles A(0); the smallest tentative is B(1), so B settles at **1**; then
  C(2); C's edge to B would improve B to 2 + (−10) = **−8** — but B is already settled, and
  **settled is forever**: the relaxation is dropped (the executed run prints
  `stale entries dropped=1`), and D settles at 1 + 1 = **2**. Reported: `A→D = 2`.
- **Bellman-Ford** has no settle step — V−1 rounds relaxing *every* edge: round 1 sets
  B = −8 once C's distance is known, and D picks it up next round → **A→D = −7** via
  A→C→B→D. The executed pair: **2 vs −7**.

**The exact failure moment:** B settling at 1 *before* the improving −10 edge's tail (C)
was known. The lesson's earlier version of this demo — negative edge, no victim behind B —
*didn't* visibly fail (the stale value got corrected in-place); the downstream node D is
what makes the wrong value observable. A stale value with nothing downstream is the bug's
invisible form; your diagnostic needs a D.

**The precondition, stated as the requirement:** Dijkstra is correct **iff all edge weights
are non-negative**. Not "should be", "iff": with negatives, the settled-forever invariant
("tentative = final") is false, and the algorithm returns confident wrong answers, not
errors. That asymmetry — wrong answer vs crash — is why the precondition is a precondition.

**Criteria check:** ☐ both outputs ☐ failure moment named ☐ iff-statement written.

## Exercise 4 — Build order (independent)

**Reference shape.** The problem *is* Kahn's algorithm: tasks = vertices, dependencies = edges
(u must precede v), the order = a topological order. A valid order exists **iff** the graph
is acyclic — and Kahn's detects the cycle *while it runs*:

- **50-task fixed-seed run:** the output is a permutation of all 50 tasks; verify it by
  checking every dependency edge against the produced order (the verification is the
  completion criterion, not the run).
- **Cyclic 5-task run:** Kahn's stalls — some vertices never reach indegree 0, so fewer than
  n vertices are emitted. **The report must name cycle members:** the vertices with
  indegree > 0 at the stall are exactly the vertices *reachable from or inside* cycles; from
  those, one cycle can be extracted by walking successor edges within the stuck set until a
  repeat (record the walk). A bare `false` tells the caller nothing to act on; naming Prog →
  Algo → DS → Prog (the lesson's own cycle) tells them which edges to inspect — that
  difference is the exercised engineering judgment.

**Criteria check:** ☐ 50-task order verified against all edges ☐ stall on cyclic input ☐
cycle report naming at least one member.

---

Next: [set-18-solutions.md](set-18-solutions.md)
