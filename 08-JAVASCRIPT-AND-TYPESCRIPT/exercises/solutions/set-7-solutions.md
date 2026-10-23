# Solutions — Set 7: Event Loop

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.

## Exercise 1 — Five mixed snippets, predicted then executed

**Reference transcript (authoring machine, Node 24.13.1):**

```console
# 1: sync/then/timeout/queueMicrotask
A
B
C: then
E: microtask
D: timeout

# 2: await chain
1
4
6

# 3: nested then
after reg
t1
t2

# 4: setTimeout inside a then + # 5 registration tail
-- done --
D: timeout
timer start
micro after timer
```

- **Snippet 1:** synchronous `A B` first (registration only: `then`, `queueMicrotask`,
  timeout are *queued*, not run); microtasks in **registration order** (`C` then `E`); the
  timer last — macrotask after the microtask queue empties.
- **Snippet 2:** each `await` is one microtask hop of continuation, so `1 → 4 → 6` — the
  numbers print in source order because each resume happens after the previous one is queued.
- **Snippet 3:** `after reg` is synchronous (still the same turn), then `t1`; `t2` was
  registered *inside* `t1`, so it is appended to the microtask queue and runs next —
  **the extra hop**: a promise chained in a later microtask still runs before any timer.
- **Snippets 4/5 (the teaching trace):** awaiting *already-resolved* promises only drains
  microtasks, so `-- done --` printed **before** any timer — then `D: timeout` (registered
  first), `timer start`, and `micro after timer` (the `.then` queued from inside the timer
  callback, drained immediately after it). Exactly the two rules: timer callbacks are
  macrotasks; their promise reactions are microtasks that follow.
- **Criteria check:** ☐ five predictions + five executions ☐ mismatches explained by queue
  name, registration order, and chain hops only.

## Exercise 2 — The probe plus three modifications

**Reference transcript (authoring machine) — variant (c), an `await` between two timer
registrations:**

```console
register T1
awaited (microtask hop done)
sync end
T1 fired
T2 fired
```

- **(a) direct `.then` instead of `queueMicrotask`:** yes, `micro-3` still jumps ahead of the
  timer — both are microtasks; the queue does not distinguish source, only arrival order. The
  "extra hop" only changes *position within* the microtask queue (snippet 3 above).
- **(b) `.then` inside `setTimeout`:** the callback itself is a **macrotask**; the `.then` it
  registers is a **microtask**, drained right after that callback, before the *next* timer.
  Executed as `timer start → micro after timer`.
- **(c) `await` between two timer registrations:** the async function still finishes synchronously
  *through* the microtask hop — both timers were registered before any of them fired
  (`T1 fired → T2 fired` in registration order). The `await` did not let timers interleave:
  timers cannot interrupt running JS; they wait for the turn to end.
- **Criteria check:** ☐ four traces captured ☐ extra-hop rule confirmed ☐ macrotask/microtask
  split shown by variant (b).

## Exercise 3 — Bounded starvation demonstrator

**Reference transcript (authoring machine):**

```console
chain done N=1000
timer delay N=1000: 1ms
chain done N=5000
timer delay N=5000: 9ms
chain done N=20000
timer delay N=20000: 14ms
```

- A `setTimeout(…, 0)` registered **first** still fired **after** the whole microtask chain:
  the event loop drains the microtask queue completely before taking the next macrotask,
  registration order across queues is irrelevant.
- Delay-vs-N grows with N (1 → 9 → 14 ms here) because the chain's work all happens inside
  one drain; your numbers will differ with machine load — the *growth*, not the digits, is
  the evidence.
- **Counterfactual stated as a counterfactual:** an *unbounded* microtask chain (no final
  resolve, or a `.then` that schedules another) would keep the loop in the microtask drain
  forever and the timer would **never** fire — this was reasoned from the model, **not
  executed**, because the guarded version is the only honest way to demonstrate it.
- **Criteria check:** ☐ timer-after-chain transcript ☐ 3-value delay table ☐ unbounded case
  labelled as unexecuted counterfactual.

## Exercise 4 — Frozen dashboard diagnosis (independent)

**Reference shape:**

- **(a) One-second timeline, queues named:** heartbeat at t=0/1000 → `setInterval` macrotasks;
  refresh at t=0 → one long macrotask; search debounce → `setTimeout(250)` macrotask firing
  250 ms after the last keystroke; animation → `requestAnimationFrame` callbacks (render
  step, before paint — *not* the timer queue); clicks → event-loop macrotasks (task source:
  UI). Order within a turn: run one task → drain **all** microtasks (promise reactions from
  that task) → render/rAF step → next task. Promise-heavy code from the refresh job lands in
  the microtask column and is why "fast-looking" work can still starve rAF.
- **(b) Verification probes (adapted from this lesson's traces):** wrap each job with
  `performance.now()` logging at enqueue and at run (the serial-vs-parallel harness of set 6,
  re-pointed at the four jobs); snippet-1's registration/execution split to prove where each
  callback's work actually lands.
- **(c) Two freeze causes, distinguished by evidence:** (1) **long sync task** — timers and
  rAF are delayed *but eventually run*; measured long-task entries (>50 ms) appear in the
  Performance timeline. (2) **microtask pump** — a promise loop keeps the drain non-empty, so
  timers **never** run during it; the distinguishing observation is a `setTimeout` sentinel
  that prints nothing while the pump lives (the starvation demonstrator's structure, with the
  guard). Delayed-but-eventual vs never: that is the runnable distinction.
- **(d) Fixes:** long sync → chunk the work (`scheduler.postTask`/`setTimeout(0)` slicing,
  Web Worker for the heavy part); microtask pump → yield to the macrotask queue
  (`await new Promise(r => setTimeout(r, 0))` every N iterations, or move the loop to a
  Worker) — draining microtasks infinitely is never fixed by adding more microtasks.
- **(e) Production metric:** `PerformanceObserver` for `longtask` entries with a threshold of
  **50 ms** (the RAIL frame budget's unit — anything ≥50 ms drops ≥3 frames at 60 fps);
  justify the number against your own trace timings (the executed starvation table shows
  multi-ms drift from *small* chains; real pumps are worse).
- **Criteria check:** ☐ timeline with queue names ☐ ≥1 executed verification trace ☐ two
  causes distinguished by runnable observations ☐ fixes matched to causes ☐ metric + numeric
  threshold justified.

---

Next: [set-8-solutions.md](set-8-solutions.md)
