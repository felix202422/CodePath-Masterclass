# Hint Ladders — 05 Data Structures and Algorithms

Each set in [README.md](README.md) has a three-rung ladder below. The rules from
[learning-method](../../00-START-HERE/learning-method.md):

1. **Stuck 15 minutes?** Take rung 1. Still stuck — rung 2, then rung 3.
2. **Record which rung you used** next to the exercise. The record is the point: it tells you
   which *kind* of gap you have (concept, shape, or translation), which is worth more than the
   answer the ladder hands you.
3. Rung 3 is deliberately close to the solution. If you take it, treat the exercise as "rebuild
   from the hint a week later", not as "done".

A rung never contains code. It contains the question you should have asked yourself.

---

## Set 1 — Measuring cost

1. Rung 1: Which loop variable bounds the count? Write the innermost loop's trip count as a
   function of the outer variable before summing.
2. Rung 2: The sum 0+1+2+…+(n−1) has a name. If you have a counter, run it at n = 4 by hand first
   and match the formula to the tiny case.
3. Rung 3: For the cost report, the structure is: what loops exist → what ranges do they run →
   what does that sum to → what counter proves it. Fill the slots; the class falls out.

## Set 2 — Arrays and their costs

1. Rung 1: Copies happen only when capacity is exceeded. List *when*, then how many elements
   exist at each event.
2. Rung 2: The ladder is 4, 8, 16, …; the copies per event are the old capacity. Sum a geometric
   series whose largest term is just under n.
3. Rung 3: "Append-only made cheap" is asking for growth. The only question left is the factor —
   and the counter that settles the ×1.5-vs-×2 argument counts *copies*, not milliseconds.

## Set 3 — Pointer trade-offs

1. Rung 1: Reversal needs three pointers, not two. Name what `prev`, `curr`, `next` hold before
   the first iteration and after each assignment.
2. Rung 2: Every "empty structure" bug is a missing policy decision. Write the policy line first:
   what *should* remove-on-empty do — and then make the code do exactly that.
3. Rung 3: Splicing relinks pointers, it doesn't move elements. Count the re-links for splicing
   k nodes into an n-node list: it is independent of n.

## Set 4 — LIFO discipline

1. Rung 1: Draw the stack after every character, not every pair. A closing bracket consults the
   top; an opening one pushes.
2. Rung 2: For the two-stack queue: where does the *oldest* element sit, and which stack's pop
   gives it to you in O(1)?
3. Rung 3: Amortization counts totals, not per-op peaks. After n pushes and n pops, how many
   elements were moved, ever? Compare that total to 2n.

## Set 5 — FIFO discipline

1. Rung 1: The ring's state is `(head, size)` or `(head, tail)` — pick one and write what each
   invariant means before tracing. Wrap-around happens when an index crosses capacity, not when
   the buffer is full.
2. Rung 2: Shift-based dequeue moves every remaining element. Count those moves over a
   fill-drain cycle of depth d, then over n cycles.
3. Rung 3: Overwrite-on-full is "keep the newest d entries". Which end do you write, which end
   do you read, and what does `size` saturate at?

## Set 6 — Keyed access

1. Rung 1: The contract is symmetric — equal keys must hash equal. Look at your `Point.equals`
   and ask what `hashCode` returns for two equal points under the default implementation.
2. Rung 2: Chain length *is* the lookup cost inside a bucket. To see the load-factor trade-off,
   instrument visits, not time.
3. Rung 3: For the dense-int-id choice: what does a direct-address array cost in *memory* at the
   key range's size, and does the range query even need a tree, or just a scan of one array?

## Set 7 — Hierarchies

1. Rung 1: The two-children removal is "replace with the smallest value in the right subtree",
   then remove *that* node — which is now a leaf or one-child case. Trace it in two phases.
2. Rung 2: Ascending inserts build a path, not a tree. If every insert goes right, what is the
   height as a function of n?
3. Rung 3: "Always the minimum, fast inserts" is asking for a heap's invariant — write the
   parent-child order relation the structure must maintain, and which end of it `poll` reads.

## Set 8 — Priority access

1. Rung 1: Floyd heapify starts at the last *parent*, which is index n/2 − 1 — derive it from
   the array's level structure, don't trust the constant.
2. Rung 2: Top-k with a bounded max-heap keeps the k smallest *seen so far* as the heap's
   contents. Ask: when the new element is larger than the root, what do you do?
3. Rung 3: Decrease-key via `removeAt` needs the element's index. Lazy re-insert needs a
   "is this entry stale?" check at poll time. Both costs live in different counters — name them
   before measuring.

## Set 9 — Relational structure

1. Rung 1: The handshake lemma counts each undirected edge twice — once per endpoint. Write
   degree sums over your own six-edge drawing and see the 2E appear.
2. Rung 2: Matrix `hasEdge` is one array read; list `hasEdge` is a scan of one neighbor list.
   The verdict depends on which operation dominates *your* workload — say which, then pick.
3. Rung 3: Friends-of-friends are "neighbors of neighbors, minus my neighbors, minus me". The
   hub worst case is one vertex whose neighbor list dwarfs all others — count its scans.

## Set 10 — Reachability

1. Rung 1: BFS's frontier is FIFO (a queue); DFS's is LIFO (a stack — or the call stack itself).
   Write the frontier contents after each step and the visit order reads off.
2. Rung 2: A component is "everything reachable from an unvisited vertex". The sweep is: loop
   vertices, skip visited, BFS, count one more.
3. Rung 3: The all-pairs diameter is BFS from every vertex — write its total class as
   V × (V + E) before running, and predict which vertex of your sample is the center.

## Set 11 — Ordered lookup

1. Rung 1: Binary search's loop writes `mid` differently for hit and miss paths — trace lo/hi
   movement per iteration, and note which way each bound moves.
2. Rung 2: The unsorted trap fails *silently* — the search returns a confident wrong answer.
   The count of wrongly-absent keys is the number the guard must save you from.
3. Rung 3: `lowerBound` answers "first position where x could start"; `upperBound` answers "first
   position where x could *not* be". Both walk the same halving — only the comparison at `mid`
   differs, so write that comparison first.

## Set 12 — Ordering disciplines

1. Rung 1: Bubble sort compares adjacent pairs — count comparisons for the fixed 9-element
   input before running; insertion sort's count depends on inversions, so count those too.
2. Rung 2: A stability witness needs two records with equal keys whose payload order flips. If
   your sizes show none, your sort may be stable — scale up, or instrument the comparisons to
   prove the equal-key case never reorders.
3. Rung 3: The "stream, top-100, cannot store all" shape is a bounded heap of size k. Per-record
   cost is the sift depth of a k-heap, not of an n-heap.

## Set 13 — Divide, and recursion's bill

1. Rung 1: Draw fib(6)'s tree with *values*, then count leaves and internal nodes separately.
   The count is a closed form in n — write it, then confirm with the counter.
2. Rung 2: The φⁿ prediction needs the base: count(1) = count(2) = 1 (or 2 — check your code's
   base case) and multiply the ratio per level. Predicted-vs-actual disagreement is a *finding*,
   not a failure — report which one moved.
3. Rung 3: Merge's comparison structure is "advance whichever side has the smaller head". The
   nearly-exhausted case is one side with one element left against a long run — count the
   comparisons that loop actually makes.

## Set 14 — Exhaustive search

1. Rung 1: Placement attempts at depth d count the *choices remaining* at that depth, not the
   solutions below it. Sum the per-level counts; the formula is the trace.
2. Rung 2: N-queens' known sequence is checkable — n=4 must print both boards. If your count
   differs, the safety test is under-checking (diagonals!) or over-checking (column twice).
3. Rung 3: The missing swap-back corrupts the *caller's* array, not the current path — ask what
   state the next iteration inherits, and why the first solution still prints correctly.

## Set 15 — When greedy suffices, and when it lies

1. Rung 1: The exchange argument step that fails is where you'd swap a greedy coin for smaller
   ones and claim the count doesn't rise. For {1, 3, 4} and 6, the greedy first pick is 4 —
   what does "replace 4 with smaller coins" have to do to stay ≤ 2 coins?
2. Rung 2: The canonical condition (each coin ≥ sum of all smaller + 1) makes greedy's local
   choice forced. Check {1, 3, 4}: 4 ≥ 1+3+1? Write the inequality and see it fail.
3. Rung 3: Fractional knapsack's density rule survives splitting; 0-1 knapsack's does not
   because a partially-taken item is illegal. Name the invariant fractional has (prefix of the
   density order) and 0-1 lacks (downward-closed subsets).

## Set 16 — Overlap, and paying for it once

1. Rung 1: Count states, not calls: write the argument tuple for each problem's state, then
   count how many distinct tuples exist as a function of the inputs.
2. Rung 2: The overlap ratio (total calls ÷ distinct states) grows because the *tree* grows
   while the *state space* grows polynomially. Print both numbers at three sizes — that's the
   whole experiment.
3. Rung 3: Recovering the LCS script means storing choices, not just lengths — a direction
   arrow per cell. Rolling rows keep lengths; the script needs the full table (or Hirschberg —
   name which one you chose and why).

## Set 17 — Costs over graphs

1. Rung 1: Dijkstra's settle order is not BFS order — write the tentative distances after each
   settle step, and the next-settle choice is always the smallest tentative.
2. Rung 2: Kahn's queue state per step is "which indegree-zero vertices exist now". A tie (two
   at zero) means your order is one of several valid ones — say so rather than memorizing one.
3. Rung 3: The negative-edge failure needs an edge that *improves* an already-settled vertex.
   Draw A→C, C→B(−10): B settles with the wrong value only if something else settles before the
   improvement arrives.

## Set 18 — Everything, composed

1. Rung 1: BFS counters are three numbers you can read off the picture *before* running: visited
   = reachable set size, edges examined = sum of reachable degrees, max frontier = widest level.
2. Rung 2: The decision sheet keys on preconditions: negative edges? DAG? unweighted? Write the
   precondition column first and each algorithm's name falls into its row.
3. Rung 3: "Visit all stops" over one-way streets is a *directed* Hamiltonian path problem —
   the exact answer is exponential in stops, so n ≤ 15 means bitmask DP or Held-Karp. Say what
   the 2ⁿ states represent before writing a single line.

---

Stuck at rung 3 on several sets from the same family (e.g. several "stated without steps"
problems)? That's not a hint problem — that's a signal to revisit the lesson section named in
the set header before attempting the next set.

**Next:** the reasoning-grade answers live in [solutions/](solutions/README.md) — attempt first.
