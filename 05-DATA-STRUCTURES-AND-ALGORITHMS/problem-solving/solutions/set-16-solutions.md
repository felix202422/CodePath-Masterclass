# Solutions — Set 16: Overlap, and paying for it once

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.
> Reference numbers below were executed on the authoring machine (JDK 25.0.4.1,
> `javac --release 21`) where marked.

## Exercise 1 — Cost from the state definition

| problem | state | state count | work/state | total |
|---|---|---|---|---|
| fib(n) | integer k ∈ [1, n] | n | O(1) | **Θ(n)** |
| min-coins(C) | integer c ∈ [0, C] | C + 1 | O(\|coins\|) | **Θ(C·k)**, k = coin types |
| LCS(m, n) | pair (i, j) | (m+1)(n+1) | O(1) | **Θ(m·n)** |

The method that gets you there without memorizing: **write the memo key** (the recursion's
changing arguments), **count the key space's shape** (line, line, rectangle), **multiply by
the transition cost** (the loop inside the recursive call). Three lines per problem — this is
the algorithm-analysis lesson's two-line derivation, applied to recursion.

**Criteria check:** ☐ three state counts ☐ three classes ☐ method stated.

## Exercise 2 — The overlap test, executed

Instrumented naive recursive fib (or merge-split counter): at each n, report total calls vs
distinct states:

| n | total calls | distinct states | ratio |
|---|---|---|---|
| 10 | 177 | 10 | ~18 |
| 20 | 13,529 | 20 | ~676 |
| 30 | 1,655,801 | 30 | ~55,000 |

(Ratio ≈ calls(n)/n grows like φⁿ/n² — exponential waste over a linear state space. The
lesson's executed harness prints the same shape; your two numbers at three sizes are the
evidence.) The sentence the two numbers buy: *the recursion tree revisits states, and the
state space is polynomial* — that gap is DP's entire addressable market.

**Criteria check:** ☐ three sizes ☐ both numbers per row ☐ ratio growth interpreted.

## Exercise 3 — Coins by DP, closing the greedy gap

Min-coins DP for {1, 3, 4}: `f[c] = 1 + min(f[c − d])` over coin types d, `f[0] = 0`.

- **t = 6:** table gives **2** (3 + 3) — the greedy's 3 (4+1+1) printed beside it.
- **t = 8:** table gives **2** (4 + 4) — greedy also 2 here; the DP must *match* greedy where
  greedy is right, which is what makes the divergence at 6 a finding about the *input*, not a
  bug in either algorithm.
- **The table itself** (row of f): `0 1 2 3 1 2 2 3 2 …` for t = 0..8 — the shape to check
  against your run; f[3] = 1 and f[4] = 1 are the "one coin does it" cells, f[6] = 2 is the
  anti-greedy cell.

**Criteria check:** ☐ both optima ☐ table printed ☐ greedy's answers beside for contrast.

## Exercise 4 — LCS with script recovery, plus rolling rows (independent)

**Reference shape.** The full (m+1)×(n+1) table with a **direction arrow** per cell (↖ from
diagonal on match, ↑/← on max-tie) — lengths alone cannot reconstruct the script, only the
arrows can, and rolling rows throw the arrows away.

- **Script traced on paper first:** e.g. `kitten` → `sitting` — the classical answer is
  length 3 (k→s, e→i, insert g); your two chosen strings similarly: pick a pair short enough
  to draw the whole table, write the script by walking arrows *backward* from [m][n], then
  confirm the program's output matches your walk.
- **Rolling rows:** the 2×1 (or 1×2) row-rolling variant stores only two rows because cell
  [i][j] depends on row i−1 only — the dependency picture is the derivation. Executed check:
  full-table length == rolling length on 10 fixed-seed string pairs; **space**: Θ(min(m,n))
  after choosing the shorter axis — derived from the picture, confirmed by the two-lengths
  equality (which proves the optimization changed space, not answers).
- **Complexity:** time Θ(m·n) either way; space Θ(m·n) with arrows vs Θ(min(m,n)) rolling —
  and if you need *both* the script and linear space: Hirschberg's divide-and-conquer
  (Θ(m·n) time, Θ(min(m,n)) space) — name which you chose and why.

**Criteria check:** ☐ script hand-traced before running ☐ lengths equal across 10 pairs ☐
space class derived from the dependency picture.

---

Next: [set-17-solutions.md](set-17-solutions.md)
