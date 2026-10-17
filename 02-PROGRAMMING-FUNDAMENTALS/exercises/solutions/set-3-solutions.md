# Solutions — Set 3: Flowcharts

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.

## Exercise 1 — Trace the grade chart

**Answer.**

| Score | Diamonds visited | Result |
|---|---|---|
| 90 | in-range? → ≥90? | A (second diamond decides) |
| 80 | in-range? → ≥90? → ≥80? | B (third diamond decides) |
| 60 | in-range? → ≥90? → ≥80? → ≥70? → ≥60? | D (fifth diamond decides) |
| 0 | in-range? → ≥90? → ≥80? → ≥70? → ≥60? | F (all no, falls to the final branch) |

The pattern worth noticing: each lower score visits one *more* diamond — the cost of the chain
is visible in the trace, which is exactly why the diagram beats the flat `if` list for
communication.

**Criteria check:** ☐ four scores ☐ visit order per score ☐ result correct.

## Exercise 2 — The five shapes

**Answer.** Oval = terminator (Start/End); rectangle = process (`total ← total + price`);
diamond = decision (≥2 labelled exits); parallelogram = input/output (`PRINT verdict`); arrow =
flowline (execution order). The decision drawn with two labelled exits is the discriminator
between a real chart and a costume.

**Criteria check:** ☐ five shapes ☐ decision has two exits ☐ meanings match section 5.1.

## Exercise 3 — The missing exit edge

**Answer.** Code-level symptom: **infinite loop** — the counter advances, but the condition that
should end the loop is never tested on a path that leaves, so `print` runs forever (or, in a
`for`-drawn chart, the "more numbers?" decision's "no" branch has nowhere to go). Fix: add the
decision `counter > 10?` with a "yes" arrow to the End terminator, plus the back-edge from "no"
to the process box — the loop now has *both* required edges from section 5.3.

**Criteria check:** ☐ symptom named (infinite loop / no exit path) ☐ both edges drawn in the
correction.

## Exercise 4 — Chart-first validator (independent)

**Answer.** Structure: Start → read text → numeric? (no → "invalid", → End) → in −90..60? (no →
"invalid") → < 0? (yes → freezing) → < 15? (yes → cold) → < 30? (yes → mild) → else hot — all
five outcomes merging to one End. The six test inputs (say −100, −5, 0, 14, 15, 29.9, 30, "abc")
each trace to exactly one outcome; the boundary pairs (−0 vs 0, 14 vs 15, 29.9 vs 30) are where
the chart's diamond order proves itself — if 15 prints "cold", the ≥/＜ signs are mis-ordered.

**Criteria check:** ☐ chart and code agree ☐ ≥6 inputs run ☐ boundary pair traced through its
diamond ☐ non-numeric path exercised.

**Reviewer note:** the independent design choice that earns the mark: putting the *invalid*
check first, before any classification — same guard-clause discipline as the shipping chain.
