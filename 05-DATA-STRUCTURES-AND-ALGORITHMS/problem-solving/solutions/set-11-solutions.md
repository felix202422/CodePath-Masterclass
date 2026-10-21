# Solutions — Set 11: Ordered lookup

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.
> Reference numbers below were executed on the authoring machine (JDK 25.0.4.1,
> `javac --release 21`) where marked.

## Exercise 1 — Binary search, traced

Array `[2, 5, 8, 12, 16, 23, 38, 45, 67, 91]` (n = 10).

**Search 23 (hit):** lo=0 hi=9 mid=4 (16 < 23 → lo=5); mid=7 (45 > 23 → hi=6); mid=5 →
**hit on mids 4, 7, 5** — three iterations.

**Search 7 (miss):** mid=4 (16 > 7 → hi=3); mid=1 (5 < 7 → lo=2); mid=2 (8 > 7 → hi=1);
lo=2 > hi=1 → **exhausted after 4 iterations**, correct "absent" verdict.

The bound: ⌈log₂(n+1)⌉ = ⌈log₂ 11⌉ = **4** (executed) — the hit used 3, the miss all 4. Both
within the bound; the miss always spends the full depth because it never gets to test a hit
and stop early.

**Criteria check:** ☐ mid sequences 4,7,5 and the 4-step miss ☐ bound derived/quoted.

## Exercise 2 — The unsorted trap, fully mapped

`{5, 1, 9, 3, 7}` searched for each of its own five keys with plain binary search: the search
examines mids **1** (value 1) and **3** (value 3) only — the outer values 5, 9, 7 are never
tested on the paths their keys deserve, and some are reported **absent despite being present**.
Your run must print the wrong-answer count (which of the five present keys got a confident
wrong "absent").

**The guard:** an O(n) `verifySorted` assert at binary search's entry, in debug mode. It
converts a *silent wrong answer* into a *loud crash* — the debugging-fundamentals lesson's
whole hierarchy. Why not production: it doubles every call's cost to Θ(n), destroying the
point of the Θ(log n) search; the sortedness is an invariant of *construction* (you sorted,
or the data came sorted), so assert it where it's established, not where it's consumed.

**Criteria check:** ☐ wrong-answer count ☐ zero after guard ☐ debug-affordance sentence.

## Exercise 3 — lowerBound / upperBound on duplicates

Array `[3, 3, 3, 7, 7, 9]`. The definitions decide everything:

- `lowerBound(3)` = first index where key ≥ 3 = **0**; `upperBound(3)` = first index where
  key > 3 = **3**.
- `lowerBound(7)` = **3**; `upperBound(7)` = **5**.
- `count(x) = upperBound − lowerBound` → count(3) = 3 ✓, count(7) = 2 ✓.

The only code difference from plain binary search: the comparison at mid. lowerBound keeps
`hi = mid` when `a[mid] ≥ x` (walks left on equality, hunting the first); upperBound walks
left only on `a[mid] ≤ x` (hunts past the last). Both Θ(log n) — duplicates cost nothing
extra.

**Criteria check:** ☐ four predicted ☐ four printed ☐ count formula stated.

## Exercise 4 — Binary search on the answer (independent)

**Reference shape.** The smallest capacity fitting demand = the first c where predicate
`fits(c)` turns true — and `fits` is **monotone** (false…false true…true), so halving is
valid. Calibration: integer square root — smallest r with `r*r ≥ x` (or largest with `r*r ≤ x`,
your choice, stated), verified for 0..10,000,000 against `Math.sqrt` with the boundary check
`r*r ≤ x < (r+1)*(r+1)` — the sweep passes only if *no* case violates it.

**Why monotonicity is the requirement:** binary search doesn't need the *sorted array*; it
needs the *sorted predicate*. With a non-monotone fits() (e.g. "capacity c works iff c is
prime"), a true at mid tells you nothing about either half — the halving discards a region
that might contain the answer. That's the entire hidden assumption behind every "search on
the answer" problem: state it, check it, then halve.

**Criteria check:** ☐ sweep clean with boundary identity ☐ monotonicity stated as the halving's
precondition.

---

Next: [set-12-solutions.md](set-12-solutions.md)
