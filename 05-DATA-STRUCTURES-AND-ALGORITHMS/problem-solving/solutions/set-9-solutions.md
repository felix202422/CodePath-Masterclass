# Solutions — Set 9: Relational structure

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.

## Exercise 1 — Edge list → list and matrix

Given edges (undirected, A–F as vertices 0–5): each edge appears **twice** in the adjacency
list (u→v and v→u) and as **two symmetric cells** in the matrix. `neighbors(D)` reads the
list's row (one array + its chain) or the matrix's row D (a length-V scan for the 1s — the
list wins this operation). `hasEdge(B,E)` is one matrix cell (Θ(1)) or a scan of B's neighbor
list (Θ(deg B)) — the matrix wins this one.

**Which picture makes degree:** the matrix makes degree a **row sum** (scan V cells); the list
makes it the **chain length** (Θ(1) if you store it, else Θ(deg)). Note the trade the two
lessons' tables already showed: the matrix is uniformly Θ(V) for scans; the list is Θ(deg)
for everything it stores.

**Criteria check:** ☐ both drawings ☐ both answers read off them ☐ degree sentence.

## Exercise 2 — Invariant battery

- **Undirected, 200 V / 600 E:** sum of all degrees = 2E = **1,200** — the handshake lemma.
  Every `addEdge(u,v)` must increment *both* degree counters; one-sided increments are the
  bug this assert catches.
- **Directed:** sum of in-degrees = E = 600 **and** sum of out-degrees = E = 600 — each edge
  contributes exactly once to each sum. The two-sum version catches the double-add the
  handshake catches, in both directions.

All three printed as `assert ... passed` rows. A failure means the *builder* is wrong, before
any algorithm runs on top of it.

**Criteria check:** ☐ 1,200 row ☐ two 600 rows ☐ all passing.

## Exercise 3 — "The matrix is always faster" — disproof

Two counted tables at V = 2,000, E = 10,000:

| operation | matrix reads | list reads |
|---|---|---|
| `degree(v)` over all v | V² = 4,000,000 cell reads | 2E = 20,000 chain links |
| `hasEdge(a,b)` × 100,000 | 100,000 cell reads | 100,000 × avg-deg(10) = ~1,000,000 list reads |

The verdict is **per-operation**: `degree` on a sparse graph belongs to the list (2E ≪ V²);
`hasEdge` on many random pairs belongs to the matrix (1 read vs a deg-scan). Neither wins
globally — the *workload* picks. This is the same lesson as the arrays-vs-linked-lists
comparison, one level up: contiguous indexing vs neighbor traversal, priced per call.

**Criteria check:** ☐ two counted tables ☐ per-operation verdict, no global winner.

## Exercise 4 — Friends-of-friends (independent)

**Reference shape.** For user u: for each friend f, for each friend g of f: if g ≠ u and g ∉
friends(u), count/suggest g. Implementation: a `HashSet` of direct friends (the exclusion
test), a `HashMap` or counter map for candidate scores.

- **Verified on a 5-vertex sample:** hand-enumerate friends-of-friends for one vertex against
  your program's output — they must agree exactly, including the exclusion of self and direct
  friends.
- **Complexity:** Θ(Σ deg(f) over friends f of u) + Θ(that many) set lookups — i.e. **linear
  in the sum of the queried user's friends' degrees**, not in V.
- **The hub worst case:** query a user befriended by (or friends with) a hub of degree 10⁵ —
  the sum explodes; the scan is Θ(hub-degree) regardless of graph size. This is the list
  representation's O(deg) query, met in production: the fix vocabulary is sampling,
  precomputation, or a bounded per-user scan — name the one you'd pick and why.

**Criteria check:** ☐ 5-vertex hand check ☐ complexity in degrees ☐ hub analysis naming the
failure mode.

---

Next: [set-10-solutions.md](set-10-solutions.md)
