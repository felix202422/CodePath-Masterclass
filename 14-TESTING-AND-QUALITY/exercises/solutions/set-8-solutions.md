# Set 8 solutions — Performance testing → `performance-testing.md`

*Executed in the batch's Maven lab: `PerformanceBatteryTest` (P1 percentile budget, P2
injected tail, P3 algorithmic gate), Java 25. Staging-tier runs are *labelled reference*.*

## 1. p50 assertion + the 250th-call pause

The lessons' P1 line shape:

```
P1 p50=100ns p95=100ns max=16300ns budget=50000ns (sink=...)
```

With a 20 µs (20 000 ns) p50 budget the suite stays green — p50 sits three orders of
magnitude under it. For P2, predict before running: a pause every 250th call instead of
every 83rd puts the injected tail at a different sample index — p99 over 1000 calls is the
990th sample, so **one** pause at call 833 or later still lands in the top 10. Expect
`p99=5.65ms → tail caught` if your pause lands inside the window, and the arithmetic to
state: p99 is the value below which 99% of samples fall; with 1000 samples the 10 slowest
qualify, and one 5 ms pause is enough to appear there.

Honesty item to keep: the lessons' *first* harness put the pause **outside** the timing
window and reported `p99=0.01ms -> tail missed` — a gate that had never seen a tail passed
everything. Predict, run, and if your number is suspiciously perfect, suspect the harness.

## 2. P4: the API-layer budget

Time 100 `RANDOM_PORT` GETs, assert p95 under a budget **you** justify: measure a baseline
run first (e.g. p95 ≈ 40 ms with context already loaded), then set the budget with headroom
you can defend. Green twice in a row is the noise-margin check — a budget that only passes
once is a coin flip. State what it excludes: Spring context load, connection setup, JIT
warmup — the budget covers steady-state request handling, and the lesson's methodology gap
(`1424us` cold vs `463us` warm elsewhere in the subject) is why the exclusion must be
written down.

## 3. Break the gate two ways

Both executed shapes to reproduce:

```
(a) budget tightened below measured p95:
    [ERROR] expected p95 to be < 10ns, but was 100ns ==> p95 100ns exceeds budget 10ns
    BUILD FAILURE      → revert → green

(b) HashSet replaced by ArrayList in the lookup:
    P3 naive=944ms (budget 50ms) -> OVER | indexed=0ms -> PASS (found=10000)
    BUILD FAILURE      → revert → green
```

Two distinct reds: (a) is a *budget* failure — the code is fine, the promise is not kept;
(b) is an *algorithmic* failure — the same result, quadratic time. Quoting both failing
assertion lines is the deliverable because they diagnose different repairs; a team that
cannot tell them apart will "fix" (a) by editing the budget.

## 4. Independent — the p99-doubled-after-release test (reference plan)

Five named parts: **metric** (server-side request duration, histogram), **percentile**
(p99 — the average hides exactly this), **budget** (baseline p99 × agreed factor, from a
measured pre-release week), **where it runs** (staging with production-like data; the local
probe for the handler itself is executable — run it), **runner noise** (fixed CPU policy,
warmup discarded, rerun and report distinct results — the determinism check the lessons used:
`10000 reruns, distinct results = 1`). Anything needing staging is labelled reference with
the exact script shape you would run; the local probe is a real capture.