# Solutions — Set 6: Promises and async/await

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.

## Exercise 1 — Ordering: predict, then execute

**Reference transcript (authoring machine, Node 24.13.1):**

```console
sync start
then 1
after await 2
sync end
timeout 0
```

- Why: `sync start` and everything to the right of it run synchronously until the first
  `await`. `await Promise.resolve(2)` suspends the async function and queues its continuation
  as a **microtask** — so `then 1` (already-queued microtask) runs first, then the awaited
  continuation (`after await 2`, `sync end`). The `setTimeout(…, 0)` callback sits in the
  **timer queue**, which is drained only after every microtask is exhausted — hence last.
- The rule for every mismatch: microtasks (promise reactions) drain to empty before the next
  macrotask (timer) is taken; `await` of an already-resolved promise is one microtask hop.
- **Criteria check:** ☐ prediction captured before running ☐ mismatches explained by
  microtask-vs-timer vocabulary only.

## Exercise 2 — The unhandled-rejection crash, then three fixes

**Reference transcript (authoring machine):**

```console
$ node orphan.mjs
file:///…/orphan.mjs:3
  const dying = new Promise((_, rej) => setTimeout(() => rej(new Error("no")), 20));
                                                             ^

Error: no
    at Timeout._onTimeout (file:///…/orphan.mjs:3:62)
    …

Node.js v24.13.1
$ echo $?
1
```

- The rejected promise had **no handler at the moment of rejection**, so the platform's
  default policy fired: Node terminated the process (exit code `1`) with the rejection's own
  `Error: no`. Note the awaited 300 ms sleep never completed — "unreachable" printed nothing.
- **Fix 1 — attach `.catch` immediately:** `dying.catch(…)` at creation time; the rejection
  now has an observer even though you await something else.
- **Fix 2 — await it in the same tick:** `await Promise.all([slow, dying])` (or try/catch
  around it) — observation happens before rejection is reachable.
- **Fix 3 — `process.on("unhandledRejection", …)`: a *monitor*, not a fix.** Executed below in
  set 8: the process survives and the handler logs — but nothing recovered from the failure,
  no caller learned, and application state may already be broken. Use it for telemetry/crash
  reporting, never as the error-handling strategy.
- **Criteria check:** ☐ crash transcript verbatim with exit code ☐ three fixes ☐
  monitor-vs-fix distinction stated.

## Exercise 3 — Serial vs parallel vs batches (measured)

**Reference transcript (authoring machine):**

```console
serial: 299ms
Promise.all: 60ms
batches of 2: 181ms
```

- Five 50 ms tasks: serial ≈ sum (≈250 ms of work + timer slack on Windows' ~15 ms scheduler
  → 299 ms); `Promise.all` ≈ slowest (60 ms); three batches of two (2+2+1) ≈ 3 × one task
  (181 ms). The *shape* — sum / slowest / in-between — is the criterion; exact digits are
  yours to capture.
- **Audit your own code:** anything that awaits inside `for … of` over independent
  `fetch`/DB calls is this serial line — parallelize with `Promise.all(map(…))` unless there
  is causality (task N needs task N−1's id) or a rate limit you are honoring deliberately.
- **Criteria check:** ☐ three totals with the expected shape ☐ audit list written ☐ causality
  justification for kept-serial calls.

## Exercise 4 — The settings loader (independent)

**Reference transcript (authoring machine) — the combinator harness's `withTimeout` core:**

```console
fast -> ok
slow -> slow: timeout
rej -> boom
unhandled counter at exit: 0
```

- **Combinator choices, each cited to an executed behaviour:**
  - Profile (**page fails**): `Promise.all([profile, …])` — its reject-on-first semantics are
    exactly the product requirement; rejection propagates to the page-level `try`.
  - Preferences (**defaults fine**): `Promise.allSettled([...])`, then read
    `status === "fulfilled" ? value : default` — the executed status array is the fallback
    logic itself.
  - Each flag (**default off**): `allSettled` over flags, mapping every non-fulfilled entry to
    `false` — per-item isolation, no whole-batch failure.
  - Budget: race the whole loader against a 800 ms timeout; per-endpoint ceilings come from
    `withTimeout(p, 500, label)` — the transcript shows fast/slow/rejecting all settling
    cleanly.
- **No unobserved rejections:** every promise is either awaited, inside an `all`/`allSettled`
  you await, or has `.catch` attached at creation — the audit table should have a handler
  column with no blanks; the executed crash above is what a blank cell costs.
- **Dedup:** an in-flight `Map<url, Promise>` caps the page at 20 `fetch`es by construction —
  concurrent callers share one promise (the `once` pattern from set 2, now keyed by URL).
- **Honest trade-off:** `race + clearTimeout` stops *waiting* but cannot stop the real
  request; `AbortController` (pass its signal into `fetch`) is the actual cancel — name it and
  wire it for the 500 ms ceilings.
- **Criteria check:** ☐ harness executed for all-fail/mixed/slow with totals in budget ☐ every
  combinator cited to an executed line ☐ rejection-observation audit complete ☐ `AbortController`
  trade-off named.

---

Next: [set-7-solutions.md](set-7-solutions.md)
