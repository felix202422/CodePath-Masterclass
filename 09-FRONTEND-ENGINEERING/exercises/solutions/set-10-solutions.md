# Solutions — Set 10: Error/loading states · reusable components · design systems →
`error-and-loading-states.md` · `reusable-components.md` · `design-systems.md`

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.
> Executed on the authoring machine: the batch's Vite + Vitest lab (probe clusters J and K,
> jsdom resolving page-declared custom properties). Quoted outputs are real captures.

## Exercise 1 — The six-state matrix

```tsx
type View<T> =
  | { s: "loading" } | { s: "ready"; data: T } | { s: "empty" }
  | { s: "error"; message: string } | { s: "unauthorized" } | { s: "offline" };

function render(v: View<User[]>) {
  switch (v.s) {
    case "loading":       return <Skeleton role="status" aria-label="loading users" />;
    case "ready":         return <Rows rows={v.data} />;
    case "empty":         return <EmptyState role="status">No users yet.</EmptyState>;
    case "error":         return <ErrorState role="alert" retry={reload}>{v.message}</ErrorState>;
    case "unauthorized":  return <SignInPrompt role="alert" />;   // escalate: only auth fixes it
    case "offline":       return <OfflineState role="status" retry={reload}>Offline — retrying.</OfflineState>;
    default:              return assertNever(v);
  }
}
```

**Executed anchors:** probe J2 gives the quartet's distinct copy —
`loading: "loading…" | error: "network down" | empty: "No results yet — try a search." |
ready: "ab"` — and probe J6 the live-region contract (status = `aria-live="polite"`,
alert = `assertive`). Six assertions query each surface by **role + accessible name**, and
the union with `assertNever(v)` fails `tsc` the moment a seventh state is added without
handling (`TS2322` against `never`, the set-2 diagnostic family).

**The six one-word product rules:** loading → **guide** (skeleton with label, never a bare
spinner); ready → **serve**; empty → **invite** (say what to do next); error →
**recover** (retry that works); unauthorized → **escalate** (only sign-in resolves it —
don't offer retry); offline → **reassure** (state the dependency, auto-retry).

## Exercise 2 — The boundary pair

```tsx
// without boundary — executed J5:
//   J5 without boundary: error propagated to render — blank page (the failure the boundary exists for)
// with boundary — executed J1:
class EB extends React.Component<{onReset: () => void}, {e: Error | null}> { …
  static getDerivedStateFromError(e) { return { e } }
  componentDidCatch(e, info) { console.error("widget crashed", e, info.componentStack) }
  render() { return this.state.e
    ? <ErrorState role="alert" retry={() => this.setState({ e: null, … }, onReset)}>…</ErrorState>
    : this.props.children } }
```

Both transcripts: **without** → `container.innerHTML === ""` (the tree unmounted, the
empty container is the assertion); **with** → the error surface renders, the log carries
`info.componentStack` (spy on `console.error` — assert the component stack exists, not
just the message), and `reset()` after clearing the throwing condition re-renders the
children (**recovery**, not reload).

**Widget-level placement with sibling survival:** put the boundary *inside* the page,
around the crashing widget only:

```tsx
<section><Crasher /><Sibbling /></section>  // <EB> wraps Crasher alone
```

Assert: crash → Crasher's slot shows the error surface, **Sibbling's state persists**
(click it first; after the crash its counter still reads the clicked value). The page
didn't unmount, so page state survived.

**The placement rule, blast-radius first:** boundaries go where a failure should stay —
*a widget's* boundary keeps the page, *the route's* boundary isolates the page and keeps
the shell, and the *root* boundary is the last resort that must at least render something.
Place it one level below where losing state would hurt, never at the root by default: the
root boundary's blast radius is everything.

## Exercise 3 — Three call sites → one `Button`

**The diff (shape):** from three real buttons — identical: click handler + label markup;
variant axis: tone (primary/neutral/danger) and size; content: label vs icon+label
(children); node-needs: one needs `type="submit"`, one needs an `aria-pressed` toggle.
**Rejected candidates:** `isLoading` boolean pair (`isLoading/isNotLoading` — collapses
into `loading`), a `kind="anchor"` axis (that's a `Link`, not a button — two components).

```tsx
type Tone = "neutral" | "primary" | "danger";
type Size = "sm" | "md";
function Button({ tone = "primary", size = "md", loading, className, children, ...rest }:
  { tone?: Tone; size?: Size; loading?: boolean; className?: string } &
  Omit<ButtonHTMLAttributes<HTMLButtonElement>, "className">) {
  return (
    <button {...rest} disabled={loading ?? rest.disabled} aria-busy={loading || undefined}
      className={`btn btn--${tone} btn--${size}${className ? ` ${className}` : ""}`}>
      {loading && <Spinner aria-hidden="true" />}
      {children}
    </button>
  );
}
```

**Four assertions:** the three call sites render their merged classes (variant first,
caller last — set 4's merge position); `loading` injects a spinner with `aria-hidden="true"`
*and* sets `aria-busy="true"` (the spinner is decoration; the state is the attribute).
**Captured tsc diagnostic** (authoring machine, tsc 7.0.2 `--strict`):

```console
tsprobe/badge.tsx(4,25): error TS2322: Type '"hype"' is not assignable to type 'Tone | undefined'.
EXIT=1
```

— the same line your `tone="grellow"` produces: the closed enum is the misuse gate.

## Exercise 4 — The token-gate pair (independent)

**(a) Semantic consumption only.** `Skeleton`/`EmptyState`/`ErrorState` read
`var(--color-surface)`, `var(--color-text-muted)`, `var(--color-danger)` — never a
primitive. **Executed K6 read (jsdom resolves page-declared custom properties):**

```console
K6 light token: rgb(37,99,235)
K6 dark token: rgb(96,165,250)
K6 space token: 8px
```

Assert `getComputedStyle(el).getPropertyValue("--color-action")` equals each theme's
value with the *component source untouched between runs* — that's the zero-edit claim.

**(b) Theme switch:** `<div data-theme="light|dark|hc">` on the root; the same three
components re-render with **no prop changes and no source edits** — capture
`--color-action` per theme (three values quoted above extended to `hc`) and assert each
component's *computed* colors follow.

**(c) The guard test:**

```ts
it("components reference semantic tokens only", () => {
  const src = readFileSync("src/components/States.tsx", "utf8");
  const primitives = src.match(/--(blue|red|gray|green)-\d{3}/g) ?? [];
  expect(primitives).toEqual([]);            // fails the moment someone reaches for --blue-600
});
```

**Break it once** by adding `color: var(--blue-600)` and quote the failure
(`expected [ "--blue-600" ] to equal []`) — then remove it and quote the green run. The
role-name test (`getByRole` for each state) runs over every token you added, per the set's
last criterion.

**Criteria check:** ☐ six assertions with roles + six rule sentences + `never` check ✓
blank vs recovered transcripts, sibling-survival, placement rule ✓ three call sites +
merge position + captured `TS2322` ✓ three themes' computed tokens, zero-edit claim,
guard test red then green, role test per token.

---

Next: [README](README.md) — back to the index.
