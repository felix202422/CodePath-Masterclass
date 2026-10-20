# Solutions — Set 19: Concurrency

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.

## Exercise 1 — Three runs, tabulated

**Reference results (authoring machine — yours will differ; that is the criterion):**

| Run | `plain increment` | synchronized | AtomicInteger |
|---|---|---|---|
| 1 | 39251 | 40000 | 40000 |
| 2 | 39633 | 40000 | 40000 |
| 3 | *(yours)* | 40000 | 40000 |

- **Variance statement:** only the plain counter varies, always below 40000 (lost
  read-modify-write updates); the guarded lines are *identical across runs* — deterministic
  machinery vs statistical bug. If any plain run printed 40000, note it honestly: scheduling
  luck lost zero updates that time.

**Criteria check:** ☐ three transcripts ☐ variance statement ☐ honest luck-runs noted.

## Exercise 2 — The missing join

```text
run A: from thread: Thread-0      (before main's next line — luck)
run B: (thread line missing / after program output — main exited first)
```

- `start()` is asynchronous; without `join()` nothing orders `main` against the worker, and if
  `main` returns first the JVM may end before the worker prints at all. Fix pairs: `start` ↔
  `join`, pool `submit` ↔ `get`/`awaitTermination`.

**Criteria check:** ☐ instability evidence ☐ fix pasted.

## Exercise 3 — Deadlock, dumped and fixed

```text
"Thread-A" waiting to lock monitor 0x… (a java.lang.Object), which is held by "Thread-B"
"Thread-B" waiting to lock monitor 0x… (a java.lang.Object), which is held by "Thread-A"
```

- **Fix:** consistent acquisition order — both threads take lock1 then lock2 — or a single
  lock (simpler, coarser: serialization cost). The dump's *cycle* is the diagnosis; you never
  need to guess.

**Criteria check:** ☐ cycle text captured ☐ fixed run ☐ prevention rule stated.

## Exercise 4 — ParallelRunner (independent)

**Reference demo shape:** 8 tasks with staggered sleeps, 4 workers:

```text
order:      [t0, t1, …, t7]  == input order        ✓
overlap:    sleeps sum ≈ 800 ms; wall-clock ≈ 250 ms (≈3.2× overlap with 4 workers)
post-close: RejectedExecutionException("runner closed")  — your described wrapper
failure:   task 5 threw → get surfaced RuntimeException("task 5 failed: …", cause)  — cause-chain habit
```

- **Shape & honesty paragraph:** pools help **I/O-bound** tasks (they *wait* — overlap multiplies
  throughput); CPU-bound tasks compete for cores and need worker count ≈ cores — your wall-clock
  number (sum-of-sleeps ÷ elapsed) *is* the measurement-based evidence.

**Criteria check:** ☐ four proofs ☐ predicted-then-actual timings ☐ shape paragraph with
measurement.

---

Next: [set-20-solutions.md](set-20-solutions.md)
