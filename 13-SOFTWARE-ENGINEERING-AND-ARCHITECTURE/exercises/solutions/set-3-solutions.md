# Set 3 solutions — Functional and non-functional requirements → `functional-and-nonfunctional-requirements.md`

*Executed in the batch's `BudgetProbe` / OrderDesk NFR lab (Java 25, Windows 11). Blocks
marked *reference* are shapes to run in your lab.*

## 1. Three-way routing, then the adjective becomes a budget

Route these three lines:

```
functional:            "The engine SHALL total a 2-line EU cart."          → behavior
quality-as-adjective:  "The export must be fast."                          → not yet an NFR
numeric:                "The total for 1000 lines SHALL compute in < 50 ms" → NFR (already measurable)
```

The lesson's rewritten form of the middle line — workload, metric, budget, method, in
one sentence:

> **NFR1:** *measure:* 1000-line total, *metric:* wall-clock average, *budget:* 50000 µs,
> *method:* warm JVM, 100 iterations, report the mean.

```
measure: 1000-line total avg 480us, budget 50000us, result 10700.0
```

The routing test: does the line let you write a `GIVEN/WHEN/THEN`? "Fast" admits no
`THEN`; "budget 50000 µs" admits only one.

## 2. The same code against two budgets

Executed — identical workload, two declared budgets:

```
measure: 1000-line total avg 480us, budget 50000us, result 10700.0
NFR1 PASS: 480us within budget 50000us          (exit 0)
measure: 1000-line total avg 463us, budget 100us, result 10700.0
NFR1 FAIL: 463us exceeds budget 100us           (exit 1)
```

Note the honest detail: the *faster* run (463 µs) is the one that **fails**, because
its budget was 100 µs. A passing NFR proves nothing without the budget printed next to
it — `PASS: 480us` is a fact about the pair (measurement, budget), not about the code.
One sentence for the exercise: without a stated budget, "PASS" is unfalsifiable, and an
unfalsifiable claim is an opinion with an exit code attached.

## 3. The methodology gap

Executed — the same 1000-line workload cold vs warm:

```
1000-line total: 1424us (NFR1 budget 50000us)   ← no warmup, first run
1000-line total: 463us                          ← warmed
```

Ratio ≈ 3× on the authoring machine; your ratio will differ, capture your own two
numbers. Which one does the budget apply to? The lesson's policy: NFR1's budget applies
to the **warm** figure, because the cold number measures JIT + class-loading one-time
cost — but the policy must be written down, because the cold number is also real user
latency for a fresh process. For CI: warm up in a fixture (run the workload once,
discard), assert on the warm mean, and *report* the cold number separately so a
first-request regression is still visible.

## 4. Independent — "the dashboard must feel instant" (reference shape)

The full NFR packet:

```
metric:     server response time, p95, GET /api/dashboard
budget:     300 ms
workload:   50 concurrent users, 100-request warmup, 1000 measured requests
method:     from the load generator's clock, not the app's logs
falsifier:  any run whose p95 > 300 ms is a failure, no matter the average
```

Determinism check — rerun the same measurement and count distinct results; the lessons'
probe did `10000 reruns, distinct results = 1`. One distinct result means the harness is
deterministic enough that a future FAIL is a change in the system, not noise. If your
reruns give many distinct results, widen the sample or the percentile before anyone
writes a budget on top of them.