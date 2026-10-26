# Solutions — Set 8: API integration → `api-integration.md`

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.
> Executed on the authoring machine: the batch's Vite + Vitest lab (probe cluster H,
> fake timers + mocked `fetch`). Quoted outputs are real captures.

## Exercise 1 — The four-state hook

```tsx
type View<T> =
  | { status: "loading" } | { status: "ready"; data: T }
  | { status: "empty" }   | { status: "error"; message: string };

function useUsers() {
  const [view, setView] = useState<View<User[]>>({ status: "loading" });
  useEffect(() => {
    const ac = new AbortController();
    setView({ status: "loading" });
    fetch("/api/users", { signal: ac.signal })
      .then(r => { if (!r.ok) throw new Error(`HTTP ${r.status}`); return r.json(); })
      .then(d => setView(d.length ? { status: "ready", data: d } : { status: "empty" }))
      .catch(e => { if (e.name !== "AbortError") setView({ status: "error", message: String(e.message ?? e) }); });
    return () => ac.abort();                       // the abort line you must justify
  }, []);
  return view;
}
```

**Executed facts:** probe H1 — *the three states: loading → ready, driven by the fetch*;
probe H2 —

```console
H2 error state: "network down" | abort-on-unmount: signal aborted = true
```

— a rejection that arrives via `AbortError` must **not** paint the error state (the
component is gone; writing state then is a no-op at best). And probe H6:
`renders: 3 | fetches: 1 ([] deps = one fetch)` — deps discipline is part of the contract.

**Four rendered-state assertions** (query the *surface*, not the state variable):
loading → a `role="status"` skeleton; ready → the row list; **empty → `No results yet`**
with `status` too — empty is *not* an error (probe J2: `empty: "No results yet — try a
search."` distinct from `error: "network down"`); error → alert region + Retry.

**The race assertion:** call the hook, then re-trigger before the first response resolves;
resolve the first *after* the second → the rendered list shows the **second** dataset.
How: `AbortController` in the effect cleanup kills the first request (assert the signal);
if you dedupe instead, gate the setState behind a per-request token. **No `any`:** the
union above is the type; `catch (e)` gets `unknown`, so narrow (`instanceof Error`) before
reading `message` — that's the typecheck evidence.

**Justifying the abort line:** without it, a fast unmount/remount (route change, search
refocus) leaves two requests racing to write state — the loser's response *stale-wins*.
The cleanup aborts what this mount started; it is the effect contract applied to network
effects.

## Exercise 2 — `withRetry`

```ts
export async function withRetry<T>(fn: () => Promise<T>,
  { retries = 2, base = 10 }: { retries?: number; base?: number } = {}): Promise<T> {
  let last: unknown;
  for (let i = 0; i <= retries; i++) {
    try { return await fn(); }
    catch (e) { last = e; if (i < retries) await sleep(base * 2 ** i); }
  }
  throw last;                                      // the LAST error, with its own cause chain
}
```

**Assertions with fake timers:** a fake failing twice then succeeding → `fn` called
**3 times**, `sleep` awaited at `10ms` then `20ms` (advance timers, assert ordering), and
the resolved value is the fake's success. A permanently-failing fake → rejects after 3
calls with **the last error object** (`expect(p).rejects.toBe(thirdError)` — identity, not
message text).

**Why the last error:** each attempt may fail differently (timeout, then 503, then
ECONNRESET); the caller's retry decision and the log both need the failure that actually
ended the sequence — the *first* error is the least representative sample. Cause-chaining
(`error.cause`) is where the earlier attempts belong if you need the history.

**Jitter (optional, justified if present):** add `Math.random() * base` when many clients
retry together — synchronized retries are the thundering-herd pattern the backend lessons
warn about; in a single-client lab, deterministic delays are easier to assert, so jitter
is a production flag, not a default.

## Exercise 3 — Cache and dedupe

```ts
const inflight = new Map<string, Promise<unknown>>();
const cache = new Map<string, unknown>();
function load(key: string) {
  if (cache.has(key)) return Promise.resolve(cache.get(key));
  if (!inflight.has(key)) inflight.set(key,
    fetch(`/api/${key}`).then(r => r.json()).then(d => { cache.set(key, d); inflight.delete(key); return d; })
      .catch(e => { inflight.delete(key); throw e; }));
  return inflight.get(key)!;
}
```

**Assertions:** two components mount the same key in the same tick → fetch spy called
**once**, both render the data (the promise is shared, so both resolve with the same
object). Then mutate: `POST` succeeds → `cache.delete(key)` (or optimistically update) and
the next read refetches — assert the fetch count goes to 2 and the UI shows the new value,
not the stale one.

**The staleness policy, written:** cached data may be shown **while revalidating**, and
must be *labelled* as such (a `role="status"` "updating…" hint or a visually de-emphasized
row) — the moment data can be older than the server's, the user is entitled to know.
Never serve cached data *instead of* a failed refresh without saying the refresh failed:
stale-and-silent is how dashboards lie.

## Exercise 4 — The settings-page loader (independent)

**Shape to execute (five endpoints, per-line policy):**

```ts
const LINES = [
  { key: "profile",   required: true  },   // fail → whole view errors
  { key: "prefs",     required: false },   // fail → section shows its own ErrorState
  { key: "flags",     required: false, fallback: {} },  // fail → defaults off, silently logged
  { key: "billing",   required: false },
  { key: "usage",     required: false },
];
// budget: Promise.allSettled — overall 800ms target, 500ms per-line ceiling (abort on breach)
// re-entry: inflight dedupe (the exercise-3 map) → ≤20 fetches across 10 re-entries
```

**The four harness runs:** all-fail → required line errors the view, optional lines show
per-section errors, flags at defaults; mixed → the view renders with the required data and
section-scoped failures; slow → each line's ceiling aborts (spy: `signal.aborted === true`)
and the line shows timeout, not hang; **race** → two entries re-enter, the slow first
response resolves after the fast second one — *stale never wins* (token or abort), and the
fetch count stays inside budget.

**Cancellation on unmount:** unmount mid-flight → all five signals aborted; after
resolution attempts, **no state write** (assert your guard: either the aborted name check
or a `mounted` ref — probe H2's `signal aborted = true` is the receipt).

**Rejection-observation audit:** every `fetch`/promise creation in the file has exactly one
handler on some path — `allSettled` (never `all`, which rejects early and orphans the
other four), the per-line `catch`, the inflight `.catch` that deletes the entry. `grep -n
"\.then(" src/loader.ts` and account for each line: unhandled rejections are silent in
browsers and fatal in tests.

**The named trade-off:** a client **cannot abort a request the server has already begun
processing** — aborting saves you the *response handling*, not the server work; the real
cancellation boundary (and any idempotency guarantee) lives server-side, which is the
honest limit to write down.

**Criteria check:** ☐ four state surfaces + race assertion, no `any` ☐ 3 calls, 10/20ms
delays, last-error identity ☐ single-call + invalidation assertions, staleness policy ✓
four harness runs with timings, unmount no-write, rejection audit, one named limit.

---

Next: [README](README.md) — back to the index.
