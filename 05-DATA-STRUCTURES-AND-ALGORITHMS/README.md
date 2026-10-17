# 05 — Data Structures and Algorithms

This subject teaches you to choose how data is stored and to reason about what your code costs.
It is the difference between code that works and code that keeps working as data grows.

## What this subject covers

- Algorithm analysis: what "cost" means, and Big-O notation as a language for stating it.
- Core structures, each with an implementation you write once before using the library version:
  arrays, linked lists, stacks, queues, hash tables, trees, heaps, graphs.
- Searching and sorting: binary search, the comparison sorts, and why stability and worst cases
  matter.
- Recursion: how it works, how to trace it, and when iteration is the better tool.
- Backtracking: exhaustive search with pruning (sudoku, permutations, constraint problems).
- Greedy algorithms: when locally-optimal choices are globally-optimal, and how to prove it.
- Dynamic programming: overlapping subproblems, memoization, tabulation, and reading a recurrence.
- Graph algorithms: BFS, DFS, Dijkstra, topological sort, and their real-world uses.

## Why it matters

Every system you build later has a data-shape decision hidden in it: an index in
[10-DATABASE-ENGINEERING](../10-DATABASE-ENGINEERING/README.md), a cache lookup in
[11-BACKEND-ENGINEERING](../11-BACKEND-ENGINEERING/README.md), a rendering list in
[09-FRONTEND-ENGINEERING](../09-FRONTEND-ENGINEERING/README.md). Interviewers test this subject
because it is a cheap proxy for "can reason about consequences". Practitioners keep it because
O(n²) loops on real data are the most common performance bug in the industry.

## Prerequisites

- [04-JAVA-PROGRAMMING](../04-JAVA-PROGRAMMING/README.md) — implementations are in Java, and you
  need classes, generics, and recursion-ready methods.
- [02-PROGRAMMING-FUNDAMENTALS](../02-PROGRAMMING-FUNDAMENTALS/README.md) — loops, arrays, and
  functions are assumed.

## Lessons

- `algorithm-analysis.md` · `big-o-notation.md`
- `arrays.md` · `linked-lists.md` · `stacks.md` · `queues.md` · `hash-tables.md`
- `trees.md` · `heaps.md` · `graphs.md`
- `searching.md` · `sorting.md`
- `recursion.md` · `backtracking.md` · `greedy-algorithms.md`
- `dynamic-programming.md` · `graph-algorithms.md`

## Exercises and practice

`problem-solving/` holds mixed practice sets: implement a structure from scratch, trace an
algorithm by hand before coding it, prove or disprove a complexity claim, and solve stated-without-
steps problems (e.g. "given a dependency list, produce a safe build order"). Every solution states
its complexity and its worst case.

## Expected outcomes

Given a problem you can name two candidate structures, justify one by complexity *and* memory,
implement it correctly, and test its edge cases; read an unfamiliar algorithm and state its running
time with a one-line derivation; recognize when a problem has optimal substructure and is therefore
a DP candidate.

## Common blockers

- **Big-O as trivia.** Deriving a complexity is a two-line argument about what grows: what loops
  run, over what. If you cannot derive it, you have memorized a table.
- **Premature dynamic programming.** Always try the naive recursive solution first; DP is an
  optimization applied *after* you see the repetition.
- **Skipping hand-tracing.** Tracing on paper is slower and is the only way the machinery becomes
  visible.

## Next

[06-INTERNET-AND-WEB-FOUNDATIONS](../06-INTERNET-AND-WEB-FOUNDATIONS/README.md) — the curriculum
turns from programs that run on one machine to systems that talk to each other.