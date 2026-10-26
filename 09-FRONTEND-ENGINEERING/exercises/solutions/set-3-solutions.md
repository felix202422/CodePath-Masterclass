# Solutions — Set 3: State and hooks → `state-and-hooks.md`

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.
> Executed on the authoring machine: the batch's Vite + Vitest lab (React 19.3.1, Vitest 5.0.5,
> jsdom 30.1.3, probe clusters C and L). Quoted outputs are real captures.

## Exercise 1 — Updater vs assignment, then batching

**Prediction first:** with `setN(n => n + 1)` three clicks land on 3. The `n = n + 1` mistake
(`setN(n + 1)` written as *assignment to the outer variable* inside the handler) never
updates state at all — the local `n` is reassigned, React's state is untouched, the count
stays 0. Two clicks in one handler with the functional form: one commit, final 1.

**Executed (probe C1):**

```console
C1 renders: before click 1, after one click 2 | text: n=2
```

Test name: *two setState calls in one handler = one re-render, final value 2* — two calls,
**one** render, because updates in the same event handler are batched into a single commit.
The event-loop lesson's tick is the reason: `setState` queues, React commits once when the
handler's stack unwinds. The non-functional form's trap is the other half of the lesson:
`setN(n + 1)` reads `n` from *this render's* closure — fine for one call, wrong the moment
two calls share a handler, which is exactly why the functional updater exists.

Render-count receipts for the two shapes (probe L): `3 separate-act clicks: 4 renders`
(one initial + one per act) versus `3 batched clicks: 5 renders` in the lab's counting
harness — the assertion you want is **commits, not setState calls**: count
`useEffect` runs, not statements.

## Exercise 2 — The stale closure, three fixes

**The bug, executed shape:**

```tsx
useEffect(() => {
  const id = setInterval(() => setShown(count), []);   // count frozen at mount
  return () => clearInterval(id);
}, []);
```

Test after 3 ticks: `shown` is still the mount value — the interval callback closed over
the `count` that existed when the effect ran, and the effect never re-ran. That frozen
number is the transcript you must quote.

**Fix A — deps + cleanup** (the default): put `count` in the dep array and clear the
interval on every re-run; each tick now sees the current value, and unmount clears the
timer (the leak sentence: without `clearInterval`, the callback fires into an unmounted
component — React 19 no longer warns, so the leak is *silent*; the cleanup line is the fix).

**Fix B — functional updater:** `setShown(c => c + 1)` never reads the closed-over value,
so the dep array can stay `[]`. Correct when the tick *computes* from the previous value.

**Fix C — `useRef` mirror:** `countRef.current = count` during render, interval reads
`countRef.current`. Correct when the interval must read the latest without re-creating
itself (probe C5's receipt: *renders 1 → 1 (ref mutated, no re-render) | DOM text:
renders=1 ref=0* — mutating a ref never commits).

All three asserted after 3 ticks; only A changes the interval's identity, B and C keep one
interval alive for the whole mount.

## Exercise 3 — Derived state out of the effect

**Before:** `useEffect(() => { setTotal(items.reduce(sum)) }, [items])` — an extra render
per prop change (set → commit → effect → set again) and a window where `total` is stale.

**After:**

```tsx
const total = items.reduce((a, b) => a + b.price, 0);   // computed during render, no state
```

Assert identical output for the same inputs, and one fewer render — count renders with a
spy component or `useEffect` tally: before = 2 commits per prop change, after = 1. The
README's blockers list is the citation: **effects for derived data are a bug generator.**

The case where the effect *is* correct: syncing an **external system** — a network call, a
subscription, `setInterval`, localStorage write, a canvas draw. Rule of thumb from the
lesson: if the result could be `return <X>{value}</X>`, it's derivation; if it must *leave*
React (fetch, store, timer), it's an effect.

## Exercise 4 — The `useLocalStorage` hook (independent)

```tsx
export function useLocalStorage<T>(key: string, initial: T) {
  const [value, setValue] = useState<T>(() => {
    try { const raw = localStorage.getItem(key); return raw ? (JSON.parse(raw) as T) : initial; }
    catch { return initial; }                       // corrupt entry ≠ crash
  });
  useEffect(() => {                                 // external system: write on change
    localStorage.setItem(key, JSON.stringify(value));
  }, [key, value]);
  return [value, setValue] as const;                // tuple documented per index
}
```

**Four test groups (reference — run in your lab):**

1. **Mount:** empty storage → `initial`; pre-seeded storage → parsed value (the lazy
   initializer runs once — assert a `JSON.parse` call count if you want proof it isn't
   re-read every render).
2. **Update:** `setValue` → component re-renders with the new value *and* storage holds it.
3. **Unmount leak:** spy on `localStorage.setItem` (or `vi.spyOn(window, "removeItem")`);
   unmount → **no further writes** after unmount (a leak here writes to storage after the
   screen is gone).
4. **Two consumers:** two components with the *same key* each read their own `useState` —
   they do **not** share (this hook's honest limit: cross-tab/cross-instance sync needs a
   `storage` event listener or a store — state the limit rather than hiding it).

**API note (one line per slot):** `[0]` the current value (storage-backed, parsed) ·
`[1]` setter accepting value or updater, persists on every commit.

**Criteria check:** ☐ four predictions written before running ☐ batching explained as one
commit per tick ☐ frozen-value transcript quoted ☐ three fixes with assertions and the
cleanup sentence ☐ before/after render counts ☐ four hook test groups with the leak
assertion on a spy.

---

Next: [README](README.md) — back to the index.
