# Solutions — Set 1: Measuring cost

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.
> Reference numbers below were executed on the authoring machine (JDK 25.0.4.1,
> `javac --release 21`) unless labelled a derivation.

## Exercise 1 — Nested loop, derived then verified

**Derivation.** The outer `i` runs 0…n−1; the inner loop runs `i` times. Total =
Σᵢ₌₀ⁿ⁻¹ i = n(n−1)/2 — triangular numbers, Θ(n²).

**Executed:** n = 1,000 → `499500`; n = 10,000 → `49995000`. Both equal n(n−1)/2 exactly.

**Criteria check:** ☐ prediction = count at both n ☐ closed form written.

## Exercise 2 — Growth-table replication

The three-row table you should hold (counters, not ms):

| n | count | ratio to linear fit | class |
|---|---|---|---|
| 10³ | ~500,000 | — | quadratic |
| 10⁴ | ~50,000,000 | ×100 for ×10 n | quadratic |
| 10⁵ | ~5,000,000,000 | ×100 again | quadratic |

The diagnostic is the **ratio column**: ×10 in n producing ×100 in work is the quadratic
signature; ×10 producing ×10 is linear; ×10 producing ~×3.3 (log₂ 10) is logarithmic. Fit
ratios, not absolutes — a single row can lie.

**Criteria check:** ☐ three rows ☐ ratio column ☐ class per row.

## Exercise 3 — Worst vs best, counted

Insertion sort comparisons: **best (sorted input) = n − 1** (every inner while-test fails on
the first comparison), **worst (reversed) = n(n−1)/2**. Both are the *same code* — the input
chooses the path. The honest one-line answer to "which does real workloads see?" is: neither
guaranteed — but nearly-sorted real data sits far closer to the best case, which is why
adaptive sorts (insertion, Timsort's run-detection) win on real data despite the Θ(n²) label.

**Criteria check:** ☐ two counts with classes ☐ one sentence on input dependence.

## Exercise 4 — Cost report (independent)

**Reference shape** (your method, your numbers):

1. **Loops and ranges** — name each loop, its variable, and its bounds *as code reads them*.
2. **Derived class** — sum the bounds: a loop bounded by the outer loop variable composes to
   Θ(n²); a loop halving its variable composes to Θ(n log n) (n outer × log n inner); a loop
   with a constant bound stays Θ(n).
3. **Instrumented measurement** — one counter, two sizes (n and 10n), one ratio row. If the
   ratio is ~10, linear; ~100, quadratic; ~23 (10·log ratio), log-linear.
4. **The improvement** — a class-changing change is structural (hoist a re-computed value out
   of a loop; replace a repeated linear scan with a hash lookup; move the O(n) work out of the
   O(n) loop to make it O(1) amortized per call). State the *predicted* class of the fix
   before implementing, then re-run the counter to confirm.

**Common failure:** reporting `O(n²)` because "there are two loops". The two loops must be
*coupled* (inner bound depends on outer) to compose multiplicatively; two independent n-loops
are Θ(n) + Θ(n) = Θ(n).

**Criteria check:** ☐ derivation ☐ counted run at two sizes ☐ predicted-then-verified fix class.

---

Next: [set-2-solutions.md](set-2-solutions.md)
