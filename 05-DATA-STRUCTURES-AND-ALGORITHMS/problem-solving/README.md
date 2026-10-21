# Problem-Solving Sets — 05 Data Structures and Algorithms

**Lessons:** this subject's eighteen lessons, in order.
**How to use these sets:** attempt first; hints live in [hints.md](hints.md) (use the ladder, one
rung at a time, and record which rung you used); solutions live in
[solutions/](solutions/README.md) behind a warning. The 15-minute rule from
[learning-method](../../00-START-HERE/learning-method.md) applies.

Unlike modules 01–04, each set here is **mixed**: it deliberately spans two adjacent lessons, so
every set asks you to (a) trace an algorithm on paper before coding it, (b) implement a structure
or algorithm from scratch, (c) prove or disprove a complexity claim with counters — not with
timings alone — and (d) solve at least one problem stated in domain terms only, without steps or
function names. Completing all eighteen sets *is* the subject's completion gate in
[ROADMAP.md](../../ROADMAP.md).

Every Java example compiles with `javac --release 21` per [VERSIONS.md](../../VERSIONS.md).
Complexity claims in these sets are checked two ways or not at all: a closed-form derivation,
and an instrumented run (comparison/move/step counters) at two or more sizes. Timings may
corroborate; they never prove.

---

## Set 1 — Measuring cost → `algorithm-analysis.md`, `big-o-notation.md`

1. Derive-then-verify: for `for (i…) for (j=0; j<i; j++)`, write the closed-form count for
   n = 1,000 before running an instrumented version. **Criteria:** prediction and printed count
   agree at n = 1,000 and n = 10,000; the closed form (n(n−1)/2) written out.
2. Growth-table replication: re-run a counting harness at n = 10³, 10⁴, 10⁵ and fit each pair of
   rows to a class (linear, quadratic, log-linear). **Criteria:** a three-row table with the
   ratio column and the fitted class per row.
3. Worst vs best, counted: insertion sort with a comparison counter, run on sorted and reversed
   input of the same size. **Criteria:** the two counts (≈n vs ≈n²/2) with the class stated for
   each — and one sentence on which input a real workload sees.
4. **Independent:** pick a method you wrote in an earlier subject and produce a one-page cost
   report: loops and their ranges, derived class, one instrumented measurement naming the
   counter you used, and one change that would improve the class. **Criteria:** derivation +
   counted run + the proposed change's predicted class before you implement it.

## Set 2 — Arrays and their costs → `big-o-notation.md`, `arrays.md`

1. Predict the growth ladder: before running, list the growth events and total element copies
   for 1 → 100 appends from capacity 4, doubling. **Criteria:** prediction matches the printed
   ladder and copy counter; the closed form (2·nextPow2 − 4 − …) written out.
2. Shift arithmetic: for `remove(i)` on a size-20 list, compute exact shifted-element counts for
   i = 0, i = 10, i = 19 — then verify with a counting implementation. **Criteria:** three
   predicted values, three counted values, the O(n − i) rule connected to both.
3. Implement `indexOf`, `lastIndexOf`, `insertAt(i, v)` on a backing array, with comparison and
   shift counters. **Criteria:** counters print 0 shifts for `indexOf` and the predicted shifts
   for each `insertAt` position tested (front, middle, end).
4. **Independent — stated without steps:** *append-only workloads are common; make appending
   cheap.* Write the class this problem demands, measure its copy count at n = 1,000,000, and
   justify the growth factor against a ×1.5 alternative with counted (not timed) evidence.
   **Criteria:** the class, the counted ladder, the factor comparison, one stated drawback.

## Set 3 — Pointer trade-offs → `arrays.md`, `linked-lists.md`

1. Hand-trace then run: reverse a five-node singly linked list on paper, one line per pointer
   change, before coding it. **Criteria:** paper trace matches the executed `after` list; three
   pointer assignments named per step.
2. Empty-state battery on your own list implementation: add to empty, remove the only node,
   remove from empty (policy), peek empty (policy). **Criteria:** all four cases exercised with
   the exception/policy message printed — no stack trace escapes.
3. Step-counter law: predict steps for `removeFirst(value)`, `removeLast(value)`, `get(k)` on a
   1,000-node list, then verify with a counter. **Criteria:** three predictions, three counts,
   the worst case named per operation.
4. **Independent — stated without steps:** *a structure that keeps insertion order, supports
   O(1) ends, and lets a caller splice one sequence into another without copying the elements.*
   Implement it, splice two 1,000-node lists in a counted run, and state the memory cost of the
   per-node overhead in bytes on your JVM. **Criteria:** splice counted at ≤ a constant number
   of node re-links; measured per-node overhead with the measurement method named.

## Set 4 — LIFO discipline → `linked-lists.md`, `stacks.md`

1. Predict-then-run bracket validation: for `"([{}])"` and `")(()"`, write the stack state after
   each character before running the validator. **Criteria:** both traces, both verdicts, the
   empty-stack pop guarded.
2. Drain-order battery: push 1..5 then drain; push 1,2, pop, push 3, drain; drain an empty
   stack. **Criteria:** three orders predicted, three printed, one sentence tying each to LIFO.
3. Implement `MinStack` with `min()` in O(1) worst case. **Criteria:** a 20-operation mixed run
   printing min after each op; one sentence on the auxiliary space (and why a single minimum
   variable fails).
4. **Independent — stated without steps:** *FIFO behavior where only LIFO primitives exist.*
   Implement a queue from two stacks, then prove the amortized O(1) claim with an op counter
   over n pushes followed by n pops. **Criteria:** the counted run showing ≤ 2·n stack ops total,
   and the amortization argument written as a total-cost inequality.

## Set 5 — FIFO discipline → `queues.md`, `hash-tables.md`

1. Predict five ring-buffer state lines: from empty capacity 5 — enq 1..3, deq, enq 4..6,
   deq ×2 — write `head/tail/size` before running. **Criteria:** five predicted lines matching
   five printed lines; the wrap-around line identified.
2. Boundary battery: fill to capacity, enqueue on full (policy), drain fully, dequeue on empty
   (policy), then reuse the buffer after wrap. **Criteria:** all five rows printed with the
   declared policies; no silent corruption after wrap.
3. Ring vs array-shift queue, counted: enqueue+dequeue n = 10,000 on both; count element moves.
   **Criteria:** the shift version's ≈n²/2 (≈50,000,000) moves and the ring's O(n) moves, both
   from counters, with the class stated per implementation.
4. **Independent — stated without steps:** *the last hour of log lines, at most 1,000 of them,
   newest first.* Implement the structure this demands (hint: capacity-bounded, overwrite-on-
   full), test the wrap-past-start case explicitly, and state its enqueue and read classes.
   **Criteria:** the wrap-past-start transcript; both classes derived; one sentence on why a
   plain list-of-n would waste space.

## Set 6 — Keyed access → `hash-tables.md`, `trees.md`

1. Hand-hash three string keys through `"cat".hashCode()` and a 16-slot table; predict the slot,
   chain, and load after each insert. **Criteria:** three predictions, three printed rows; the
   index formula written (`(h & 0x7fffffff) % cap`).
2. The contract test: a `Point(x, y)` with `equals` only — run it in a `HashMap`, record the
   wrong-answer row, add `hashCode`, re-run. **Criteria:** the failing row and the fixed row,
   plus one sentence predicting what breaks in a *tree* map that has no hashCode contract at all.
3. Load-factor experiment: parameterize the resize trigger (0.5 vs 0.75 vs 0.9); at n = 100,000
   report chain-length distribution and average probe count per setting. **Criteria:** a
   three-row table; the trade-off (memory vs probes) stated with your numbers.
4. **Independent — stated without steps:** *lookups keyed by id, ids are dense small ints, and
   the caller needs "all entries with keys in [a, b]".* Choose a structure, disqualify at least
   one alternative by name with a complexity argument, and implement the range query.
   **Criteria:** the choice justified by both access *and* range classes; the disqualified
   alternative named with its failing class; the range query returning a verified result set.

## Set 7 — Hierarchies → `trees.md`, `heaps.md`

1. Hand-trace BST operations: insert 50, 30, 70, 20, 40, 60, 80 then remove each of a leaf, a
   one-child node, and a two-child node (successor rule written first). **Criteria:** the
   two-children trace written before code; the executed in-order after each removal matches.
2. Shape battery: build the same 1,000 keys ascending, descending, and shuffled; report height
   and `depthOf(maxKey)` per shape. **Criteria:** three heights (the two sorted shapes near n,
   the shuffled one O(log n)-shaped — report your measured ratio height/log₂n); the O(h)-with-h
   range stated from your own numbers.
3. Disprove a claim: "a binary search tree lookup is O(log n)." Using your shape battery,
   produce the counter-evidence and state the corrected claim precisely. **Criteria:** the
   counter-run; the corrected claim naming h and the shape conditions under which h = O(log n).
4. **Independent — stated without steps:** *always-the-minimum removal, fast inserts, keys
   arriving in a stream.* Implement the structure this demands with a counted 1,000,000-op run,
   and state what it refuses to do (and which structure in this subject answers that refusal).
   **Criteria:** op counts within the predicted classes; the refusal list with a named structure
   per refusal.

## Set 8 — Priority access → `heaps.md`, `graphs.md`

1. Hand-trace Floyd heapify on `[7, 3, 9, 1, 5, 2]`, one sift per line, then drain the built
   heap. **Criteria:** the paper drain order equals the executed poll order; the sift-up start
   index (n/2 − 1) derived, not remembered.
2. Top-k three ways: the 10 smallest of 1,000,000 fixed-seed ints via (a) full sort, (b) k-heap,
   (c) bounded max-heap of size k. **Criteria:** all three agree with each other; heap-op counts
   reported for (b) and (c); the memory claim (10 slots vs 1,000,000) measured, not asserted.
3. Heapify vs n adds, counted: same 100,000 elements, both paths, sift-op counters. **Criteria:**
   the two counts, the ≈2n vs ≈n·log n/n comparison, and the class conclusion from counters.
4. **Independent — stated without steps:** *a scheduler: jobs arrive continuously, the next run
   is always the highest priority, and priorities of queued jobs occasionally drop.* Implement
   it two ways — decrease-key via `removeAt`, and lazy re-insert — count ops for both at
   n = 10,000, and recommend one with your numbers. **Criteria:** both counted transcripts; the
   recommendation citing op counts and one correctness caveat for the lazy variant.

## Set 9 — Relational structure → `graphs.md`

1. Hand-convert a six-edge edge list into both an adjacency list and an adjacency matrix
   (vertices A–F), then write `neighbors(D)` and `hasEdge(B,E)` by reading your own picture.
   **Criteria:** both drawings; the two answers read off them; one sentence on which picture
   makes degree trivial.
2. Invariant battery: build a 200-vertex/600-edge fixed-seed undirected graph; assert the
   handshake lemma (sum of degrees = 2E); rebuild as directed and assert sum of in-degrees = E
   and sum of out-degrees = E. **Criteria:** all three assertions printed as passing rows.
3. Degree-scan disproof: "the adjacency matrix is always faster." Time *and* count element
   reads for `degree(v)` over all vertices on both representations at V = 2,000, E = 10,000;
   then run `hasEdge` × 100,000 on both. **Criteria:** the two counted tables; the verdict
   written as a per-operation rule, not a global winner.
4. **Independent — stated without steps:** *friend suggestions: given a user, list friends-of-
   friends excluding direct friends and self.* Implement it on an adjacency list, run it on a
   fixed-seed 1,000-user graph, and state the complexity in terms of the degree of the queried
   vertex — plus the hub-vertex worst case. **Criteria:** the suggestion list verified by hand
   on a 5-vertex sample; the hub analysis naming the structure's failure mode.

## Set 10 — Reachability → `graphs.md`, `searching.md`

1. Predict-then-run BFS and DFS visit orders on the lesson's graph from vertex B. **Criteria:**
   both orders predicted on paper before running; both printed; one sentence on which frontier
   data structure each uses (and which lesson it comes from).
2. Components tool: count connected components in a fixed-seed 500-vertex graph with deliberate
   isolated vertices; verify the count against a union-by-size ground truth you write. **Criteria:**
   the component count agreeing across both methods; at least one isolated vertex in the input.
3. The diameter probe: BFS from every vertex of a small graph (n ≤ 200); report the eccentricity
   of each and the graph's diameter. **Criteria:** the O(V·(V+E)) derivation written first; the
   executed diameter verified against a hand-computed value on a 6-vertex sample.
4. **Independent — stated without steps:** *the six degrees problem on a real dataset: shortest
   chain between two named users.* Implement it, run it between two vertices of your fixed-seed
   graph, report the path *and* the number of vertices BFS visited, and state why the visited
   count is the number that matters at scale. **Criteria:** the path verified edge-by-edge; the
   visited-count argument in terms of the frontier's growth.

## Set 11 — Ordered lookup → `searching.md`

1. Hand-trace binary search: on `[2, 5, 8, 12, 16, 23, 38, 45, 67, 91]` search for 23 and 7,
   writing lo/hi/mid per iteration. **Criteria:** both traces with the mid sequence (23 hits on
   mids 4, 7, 5); the hit within the ⌈log₂(n+1)⌉ = 4 iteration bound, and the miss spending all
   four.
2. The unsorted trap, fully mapped: run binary search on `{5, 1, 9, 3, 7}` for all five keys;
   record which are wrongly reported absent, then add the O(n) sortedness guard and re-run.
   **Criteria:** the wrong-answer count before the guard, zero after; one sentence on why the
   guard is a debug-mode affordance, not a per-call cost worth paying in production.
3. Duplicates: implement `lowerBound`/`upperBound`, run on `[3,3,3,7,7,9]` for 3 and 7.
   **Criteria:** four results predicted from the definitions, four printed; the count of x
   derived as `upperBound − lowerBound`.
4. **Independent — stated without steps:** *the smallest capacity that still fits demand.*
   Implement binary search on the answer (integer square root first, as a calibration), verify
   against `Math.sqrt` for 0..10,000,000, and state why the predicate must be monotone.
   **Criteria:** the sweep clean (no case where `r*r ≤ x < (r+1)*(r+1)` fails); the monotonicity
   requirement stated as the thing that makes the halving valid.

## Set 12 — Ordering disciplines → `searching.md`, `sorting.md`

1. Predict the base-run counters: bubble and insertion sort on `[5,2,8,1,9,3,7,6,4]` — exact
   comparison counts before running. **Criteria:** both predictions, both counts, the ≈n²/2
   agreement noted.
2. The stability pair, both directions: sort tagged records (same key, distinguishable
   payloads) with a stable and an unstable sort from your own implementations. **Criteria:** the
   stable run preserving payload order per key group, the unstable one demonstrably not (find a
   real witness input — if none exists for your sizes, say so and scale up until one does).
3. Quicksort's worst case, then the fix: Lomuto with last pivot on sorted input at n = 10,000
   (compare counter), then random pivot on the same input. **Criteria:** the ≈n² vs ≈1.4·n·log n
   counted rows; one sentence on why sorted input is the adversary for this pivot rule.
4. **Independent — stated without steps:** *records arrive one at a time; the operator asks for
   the current top-100 at any moment; storing all records is impossible.* Implement the stream
   answer to this, verify its output equals the full-sort answer on a fixed-seed run, and state
   the per-record and per-query classes. **Criteria:** both classes derived; the equality check
   against the full-sort ground truth.

## Set 13 — Divide, and recursion's bill → `sorting.md`, `recursion.md`

1. Hand-trace then run: the naive `fib` call tree for n = 6 — every node drawn, the count read
   off the drawing. **Criteria:** the drawn count equals the instrumented count; the double-
   counting insight (fib(n) computed many times) pointed at in the tree.
2. The ratio, predicted: before running, predict fib call counts for n = 33, 34, 35 from φⁿ;
   then run and compare. **Criteria:** three predictions within a stated tolerance; the measured
   ratios (~1.618) printed.
3. Merge sort, counted and stability-checked: instrument comparisons on random, sorted, and
   reversed input; run the tagged-record stability check. **Criteria:** three counted rows;
   the stability verdict with the merge's tie rule quoted from your own code.
4. **Independent — stated without steps:** *a merge of two already-sorted sequences, used
   millions of times a day, where the common case is that one side is nearly exhausted.*
   Implement it, measure comparisons on three input-shape families, and explain the observed
   counts via the algorithm's structure. **Criteria:** the three counted families; the
   explanation naming the loop that terminates first.

## Set 14 — Exhaustive search → `recursion.md`, `backtracking.md`

1. Placement sum, derived then confirmed: permutations of n = 5 — compute total placement
   attempts from the sum formula, then run the instrumented solver. **Criteria:** derived and
   executed counts equal; the formula (Σ k!-shaped partial sums) written out.
2. N-queens against known values: run n = 1..10 (skip none), compare each count to the known
   sequence (1, 0, 1, 2, 10, 4, 40, 92, 352, 724). **Criteria:** all ten rows matching;
   n = 4's two solutions printed and verified attack-free by hand.
3. Break the un-choose: remove the swap-back line from `permute`; run; report what the output
   becomes and why. **Criteria:** the corrupted output captured; the mechanism explained as
   the path no longer mirroring the choice tree.
4. **Independent — stated without steps:** *given a multiset of coin values and a target, count
   the subsets that reach it — where {1,2} and {2,1} count once.* Implement it, verify counts
   against a brute-force enumerator you write for n ≤ 15, and state the prune you chose and
   why it cannot reject a valid subset. **Criteria:** agreement with the enumerator on 10
   random small instances; the prune's safety argued in two sentences.

## Set 15 — When greedy suffices, and when it lies → `backtracking.md`, `greedy-algorithms.md`

1. The exchange argument, written: for the canonical coin system {1, 3, 4} and target 6, run
   both the greedy and the optimal; then write the exchange argument *attempt* and locate the
   exact step where it fails. **Criteria:** greedy = 3 coins (4+1+1), optimal = 2 (3+3); the
   failing exchange step named.
2. Counterexample by hand: find the smallest target where greedy on {1, 3, 4} is suboptimal,
   by tabulating optimal values 1..10 with DP. **Criteria:** the table; the first failing
   target identified; one sentence on why canonical systems (each coin ≥ sum of all smaller +
   1) escape this.
3. Fractional vs 0-1, mapped: items (v, w) = {(40,3), (45,4), (50,5), (90,9)}, capacity 10 —
   solve both by hand with the greedy ratio rule for fractional, then by enumeration for 0-1.
   **Criteria:** fractional = 115 (with the split item and fraction named); 0-1 = 95 (with the
   item set listed); the density rule stated as the property fractional has and 0-1 lacks.
4. **Independent — stated without steps:** *select the maximum number of compatible requests
   from a day's booking list.* Solve it, prove your greedy's optimality with an exchange
   argument in writing, and then construct (by search or by hand) a variant where the goal is
   *maximum total value* instead of *maximum count* — and show your greedy now fails.
   **Criteria:** the exchange argument; the failing instance for the variant; the reason the
   argument's invariant broke.

## Set 16 — Overlap, and paying for it once → `greedy-algorithms.md`, `dynamic-programming.md`

1. Read the cost from the state definition: for fib(n), min-coins(C), LCS(m, n) — state the
   number of states and the work per state *before* coding. **Criteria:** three state counts,
   three total-cost classes, each derived from the state-space shape.
2. The overlap test, executed: instrument a naive recursive merge-split counter (or naive fib);
   report distinct states vs total calls at three sizes. **Criteria:** the ratio growing with n;
   the sentence "the recursion tree revisits states" backed by your two numbers.
3. Coins by DP, closing the greedy lesson's gap: implement min-coins DP for {1, 3, 4}, target 6
   and 8; print the table and the recovered solution. **Criteria:** both optima (2 and 2 —
   verify 8 = 4+4); the DP table shown; the greedy's answer printed beside it for contrast.
4. **Independent — stated without steps:** *two versions of a document; produce the shortest
   edit script.* Implement it, recover the actual script (not just its length) for two short
   strings you choose, and run the 2×1 rolling-row space variant against the full table for
   equality of lengths. **Criteria:** a correct script traced on paper first; both lengths
   equal; the O(min(m,n)) space claim derived from the row-dependency picture.

## Set 17 — Costs over graphs → `dynamic-programming.md`, `graph-algorithms.md`

1. Predict-then-run Dijkstra on the lesson's weighted graph from A: distances for every vertex
   before running. **Criteria:** seven predicted distances matching the executed output; the
   settle order predicted and printed.
2. Kahn by hand: compute a topological order for the lesson's course-dependency graph on paper
   (queue state per step), then run it. **Criteria:** the hand order equal to one valid executed
   order; tie-break freedom noted (a second valid order printed or constructed).
3. The negative-weight diagnostic, reproduced: on A→C(2), C→B(−10), B→D(1) run Dijkstra and
   Bellman-Ford; report Dijkstra's wrong answer and the true distance. **Criteria:** both
   outputs; the exact moment (settling B early) named as the failure's cause; the "non-negative
   edge weights" precondition stated as *the* requirement, not a suggestion.
4. **Independent — stated without steps:** *given a list of build tasks and their
   dependencies, produce a valid execution order — or prove none exists.* Implement it, run it
   on a 50-task fixed-seed instance and on a deliberately cyclic 5-task instance, and state what
   your cycle report contains that a bare `false` would not. **Criteria:** both transcripts; the
   cycle report naming at least one member of the offending cycle.

## Set 18 — Everything, composed → `graph-algorithms.md` (capstone)

1. BFS metrics and the components tool: on the lesson graph report BFS's visited count,
   edges examined, and max frontier size; then component-count a fixed-seed graph. **Criteria:**
   all three counters predicted from the picture first; the component count verified against a
   union-find ground truth.
2. Topological robustness: run Kahn's with (a) a FIFO and (b) a min-heap on the same DAG.
   **Criteria:** both orders printed; both verified acyclic-valid; a one-sentence use case for
   the deterministic (min-heap) variant — reproducible builds, lexicographically first order.
3. Shortest-path decision sheet: four workloads — unweighted social hops; weighted airfares
   with non-negative weights; a graph with a few negative edges but no negative cycle; a DAG
   with edge costs — each assigned an algorithm from this subject with the *precondition* that
   selects it named explicitly. **Criteria:** four assignments, four preconditions; the
   negative-edge row showing why swapping Dijkstra in "because it's faster" is wrong.
4. **Independent — stated without steps, capstone:** *a delivery-planning system: service stops
   connected by one-way streets with travel times; plan the shortest route visiting all stops
   from a depot, and say plainly what guarantee the plan carries.* Implement the exact-answer
   version for ≤ 15 stops, verify against brute force on n ≤ 8, and state the complexity class
   that makes larger n a different problem — naming which of this subject's algorithms answers
   the approximate version and with what trade-off. **Criteria:** the exact solver verified
   against brute force on 10 random instances; the complexity class derived; the approximate
   alternative named with its guarantee stated honestly.

---

## Answer key

Solutions are in [solutions/](solutions/README.md) — one file per set, with reasoning, derived
complexities, and worst cases stated, not just code. Stuck before that? Work the
[hint ladder](hints.md) one rung at a time and record which rung you used.

**⚠ Attempt the exercises first.** Reading a solution produces recognition, which feels like
knowledge and is not. If you peeked, redo the exercise a week later without looking — that
second attempt is what you actually keep.
