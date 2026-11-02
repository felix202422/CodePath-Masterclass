# Solutions — 14 Testing and Quality

**⚠ Attempt the sets first.** Reading a solution produces recognition, which feels like
knowledge and is not. One week after reading any solution here, rebuild that answer from a
blank page — the second attempt is the one you keep.

One solution file per set, matching the lessons of the same name. Transcripts marked as
*authoring machine* were executed during this batch against the batch-16 Maven lab —
`PrintTrapTest`, the 16-test unit battery, the `@SpringBootTest` wiring/round-trip/rollback
trio, the packaged jar on :8085, `MockingBatteryTest` runs 1–3, `TddCycleTest` red/green,
the six-cell `RANDOM_PORT` API battery, `PerformanceBatteryTest`, `SecurityBatteryTest`,
JaCoCo's two-round gap drill, and the three-run `gate.sh` drill — with **Java 25**,
`spring-boot-starter-parent` 4.1.1, and JaCoCo 0.8.13 on Windows. Set 12's frontend and
mobile captures were executed in subjects 09 and 12's own labs (Vitest + React Testing
Library; Flutter `flutter test`). Your versions' exact text will differ — the
**behaviour and the reasoning** are the criteria; your own captured output is your evidence.

| Set | Lesson(s) | File |
|---|---|---|
| 1 | Testing fundamentals | [set-1-solutions.md](set-1-solutions.md) |
| 2 | Unit testing | [set-2-solutions.md](set-2-solutions.md) |
| 3 | Integration testing | [set-3-solutions.md](set-3-solutions.md) |
| 4 | End-to-end testing | [set-4-solutions.md](set-4-solutions.md) |
| 5 | Mocking and test doubles | [set-5-solutions.md](set-5-solutions.md) |
| 6 | Test-driven development | [set-6-solutions.md](set-6-solutions.md) |
| 7 | API testing | [set-7-solutions.md](set-7-solutions.md) |
| 8 | Performance testing | [set-8-solutions.md](set-8-solutions.md) |
| 9 | Security testing | [set-9-solutions.md](set-9-solutions.md) |
| 10 | Test coverage | [set-10-solutions.md](set-10-solutions.md) |
| 11 | Quality gates | [set-11-solutions.md](set-11-solutions.md) |
| 12 | Regression · frontend and mobile testing (subject README promise) | [set-12-solutions.md](set-12-solutions.md) |

**About reference transcripts:** where a solution quotes output, it is the authoring
machine's real capture — `PRINT-TRAP: expected=19.9 actual=19.8 MISMATCH` inside
`Tests run: 22 … BUILD SUCCESS`, the isolation pair (`value=seeded-by-first-test` green
together → `was: <null>` red alone), the pyramid pricing (`16 tests 0.216s` vs
`3 tests 12.60s`), the rename kill (`NoSuchFieldException: rate`, 15/16 green),
`CTX-LOAD: beans wired`, `PERSIST: id=2 rows 0 -> 1`, `ROLLBACK: before=0 after=0 →
exception propagated AND the row is gone`, `201 + Location=/api/orders/1` and the pinned
400/401 bodies, the divergence pair (`quote(-5.00,1) = -5.35` green vs real
`IllegalArgumentException`, then `verify(never())` green), `expected: <95.0> but was:
<100.0>` → `BUILD SUCCESS`, `p50=100ns p95=100ns … budget=50000ns`, `p99=5.65ms -> tail
caught`, `naive=944ms (budget 50ms) -> OVER | indexed=0ms -> PASS`, `p95 100ns exceeds
budget 10ns` → red → revert, `401 must include a WWW-Authenticate challenge` and
`nosniff … was: <<absent>>` → fixes → `Tests run: 5, Failures: 0`, `93.2% (358/384)` →
`98.7% (379/384)` with branch `79.4 → 100%`, and the gate triple
(`0.987 PASS` → `0.749 exit 1 with 54 green tests` → `0.9901 PASS with 58`).
Where a solution gives a *shape* (a policy page, a test plan, a requirement→level table, a
claim/gap page), no single correct text exists — the criteria in each set's
[README](../README.md) define what a reviewer looks for.

**What could not be executed, and how it is labelled:** the authoring machine is Windows
without a browser grid, a hosted CI, a staging environment, or a production service, so
four kinds of work appear as *labelled reference* rather than transcripts — Playwright/Cypress
cross-browser runs (the browser journey itself *was* executed, one browser), a hosted
pipeline enforcing the gate (the local script is executed), staging-tier performance runs
for set 8's independent exercise, and the file-upload traversal test for set 9's independent
exercise against a real storage backend. Their sections say exactly what to capture in your
own environment; they never pretend a transcript exists.

**Executed corrections worth knowing** (re-verified while writing these solutions): a test
that prints the wrong value can pass — assert or ship the bug (set 1's print-trap ran green
throughout); a green run can include classes whose sources no longer exist, so `clean` is
part of the test run (set 10's stale-class incident); a mock green proves nothing about the
real collaborator until the divergence pair runs both (set 5); a coverage number without a
`clean` build compares two different test *sets* (set 10); a performance gate that ran once
missed the tail it was built to catch until the harness was fixed (set 8's `p99=0.01ms`);
and 54 green tests could not pass a gate that checked whether new code ran — the assertion
is never the thing to weaken (set 9 and set 11 both end with the fix landing in production
code).