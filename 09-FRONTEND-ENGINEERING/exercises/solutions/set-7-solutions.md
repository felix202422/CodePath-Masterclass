# Solutions — Set 7: State management → `state-management.md`

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.
> Executed on the authoring machine: the batch's Vite + Vitest lab (probe cluster G).
> Quoted render counts are real captures.

## Exercise 1 — The four-choice map

| Scenario | Mechanism | Why (the honest reason) |
|---|---|---|
| Two siblings share a value | **Lift state** to their common parent | cheapest; no provider, no library; the readers are already in one subtree |
| Value needed 4 levels deep | **Context** (value + actions split) | drilling 4 signatures is the smell the composition lesson names; provider sits at the last common ancestor |
| Value must survive route change | **Context at the router root** (or a store) | route elements unmount — anything living *inside* a route dies with it |
| Frequently-changing (per keystroke) | **External store / `useSyncExternalStore`** | context re-renders *every* consumer per change; a store lets readers subscribe to the slice they use |

**Implement the first two and assert equivalence:** the sibling case (lifted `useState`)
and the deep case (same value delivered by context) must produce identical interaction
results — same click → same rendered text — asserted with the same matcher for both. The
*mechanism* differs; the *observable behaviour* must not, which is what makes the ladder a
choice of cost, not of capability.

**Defended differently in a team:** context for the deep case — in a solo repo I'd inline
the lift, but in a team the drill's pass-through props are a merge-conflict magnet (every
new intermediate component edits every drilled signature), so the provider's ceremony buys
conflict-free boundaries.

## Exercise 2 — Context right vs wrong

**Executed contrast (probe cluster G):**

```console
G3 memoized consumer renders: 1 → 2   (context bypasses React.memo)
G6 unstable provider value: consumer renders 1 → 2
G4 store value after inc: 1 | unrelated component renders: 1 → 1
```

- **(a) value-only context:** `const themeCtx = createContext("light")` — the value is a
  primitive/constant; a sibling's `useState` change re-renders the *provider's* component,
  but `contextValue` is the same, so consumers keep their last render (assert count
  unchanged).
- **(b) data-in-context:** `const [items, setItems] = useState([])` with
  `value={{ items, add }}` — a **new object literal every provider render** → every
  consumer re-renders: `1 → 2` (G6's receipt, exactly).

**The rule:** *context distributes, it doesn't manage.* It solves the **prop problem**
(who carries the value), never the **update problem** (who re-renders when it changes).

**Split-context mitigation applied to (b), re-measured:** move the state *and* the actions
into one stable provider, and hand consumers two contexts — `DataCtx` (changes only when
data changes) and `ActionsCtx` (stable identity via `useCallback`). Re-run the sibling
change: `DataCtx` consumers' count holds, `ActionsCtx` consumers never move. And note the
hard limit (G3): `React.memo` does **not** shield a consumer from the context it reads —
memo governs *props*, context has its own path.

## Exercise 3 — The external-store seam

```tsx
const store = { n: 0, subs: new Set<() => void>(),
  get: () => store.n,
  set: (v: number) => { store.n = v; store.subs.forEach(f => f()); },
  sub: (f: () => void) => { store.subs.add(f); return () => store.subs.delete(f); } };

function useN() { return useSyncExternalStore(store.sub, store.get, store.get); }
```

**Assertions:** (1) component A `set(1)` → A re-renders; an unrelated component B that
*doesn't* call `useN` holds its render count (**reader-only re-render** — G4's
`unrelated component renders: 1 → 1` is the same claim on a different store); (2) two
components both reading `useN` both update.

**The loop guard, executed shape:** make `getSnapshot` return `{ n: store.n }` (a fresh
object each call) → React compares snapshots by **Object.is**, sees a "change" on every
read, re-reads, re-renders, forever — the throw you capture is *getSnapshot should be
cached* / `Maximum update depth exceeded`. The fix is identity: return the stored
primitive or a cached immutable object.

**The shim-less note:** React 19 has `useSyncExternalStore` built in — the `use-sync-external-store`
shim exists only for legacy React; don't add it.

## Exercise 4 — Derived-store refactor (independent)

**Before:** context holds `items`, the screen calls
`items.filter(i => i.q.includes(text)).sort(byDate)` **inside the provider's render** on
every keystroke — 100 items recomputed per event, and every context consumer re-renders
because the filtered array is a new reference placed in context.

**After (memoized selector):**

```tsx
const selectVisible = (items: Item[], q: string) =>
  q ? items.filter(i => i.title.includes(q)) : items;
// in the component:
const visible = useMemo(() => selectVisible(items, q), [items, q]);
```

**Measurement (shape to execute):** 10 simulated keystrokes on a 100-item list —
**before**: provider re-renders + full recompute + all consumers per keystroke
(10 provider renders, 1000 item-checks × 10 = the count you record); **after**: the
memoized component re-renders 10 times, the *recompute* runs only when `(items, q)`
identity changes (still 10 with per-keystroke input — so the real win is the second half):
slice the invalidation to **per-settle** (250 ms debounce on `q`, or `useDeferredValue`)
and recompute drops to 1–2 for the same 10 keystrokes. Quote your own numbers.

**The invalidation rule chosen:** per-settle for the *derived* array, per-keystroke for
the input echo — the input must feel instant (it's just state), the sort/filter may lag a
quarter second (nobody sees the list reorder mid-typing).

**The honest trade-off:** per-settle shows *stale* filtered results for up to the debounce
window — the cost is consistency, not correctness; label it (keep typing, the list follows)
and the trade is cheap. Per-keystroke costs CPU instead and re-renders every consumer.

**Criteria check:** ☐ four-choice table with reasons ☐ two implementations asserted
equivalent ☐ one defended-differently choice ☐ two render counts with the delta + split
re-measure ☐ reader-only assertion + loop-guard transcript + shim-less note ☐ before/after
counts under 10 keystrokes, invalidation measurement, one named trade-off.

---

Next: [README](README.md) — back to the index.
