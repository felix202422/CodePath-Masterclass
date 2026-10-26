# Solutions — Set 2: Components and props → `components-and-props.md`

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.
> Executed on the authoring machine: the batch's Vite + Vitest lab (React 19.3.1, Vitest 5.0.5,
> jsdom 30.1.3, probe cluster B) and tsc 7.0.2 under `--strict`. Blocks marked *reference* are
> shapes to run in your lab; quoted outputs are real captures.

## Exercise 1 — `Badge` with a closed tone union

```tsx
type Tone = "neutral" | "info" | "danger";

type BadgeProps = {
  tone?: Tone;
  className?: string;
  children: React.ReactNode;
} & Omit<React.SpanHTMLAttributes<HTMLSpanElement>, "className">;

export function Badge({ tone = "neutral", className, children, ...rest }: BadgeProps) {
  return (
    <span {...rest} className={`badge badge--${tone}${className ? ` ${className}` : ""}`}>
      {children}
    </span>
  );
}
```

**Executed diagnostics** (tsc 7.0.2, `--strict --noEmit`, misuse file):

```console
tsprobe/badge.tsx(4,25): error TS2322: Type '"hype"' is not assignable to type 'Tone | undefined'.
tsprobe/badge.tsx(7,23): error TS2322: Type 'string' is not assignable to type 'number'.
EXIT=1
```

`TS2322` is the closed-union guarantee: `"hype"` never reaches runtime, so the variant
class can't drift out of the stylesheet. Assertions: three tones render
`badge--neutral` / `badge--info` / `badge--danger` (three distinct `className`s), and
`<Badge data-track="cta">` lands in the DOM as an attribute — React forwards every
`data-*` and `aria-*` prop it doesn't know, and strips the ones it owns (`key`, `ref`)
plus anything you destructured out (here `tone`, `className`, `children`). That is the
rest-spread's whole contract: **destructure what the component consumes, spread the rest
verbatim** — spreading `tone` too would put an invalid `tone` attribute on the `<span>`.

## Exercise 2 — The prop-drilling trace

The drill, level by level, written *before* the rewrite:

```
App      onClick={() => setMsg(...)}      owns the handler
 └ Layout  { onClick }                    passes through, unused
    └ Page   { onClick }                  passes through, unused
       └ Button { onClick, label }        consumes it
```

```tsx
// version A — explicit at every level
const Button = ({ onClick, label }: { onClick: () => void; label: string }) =>
  <button onClick={onClick}>{label}</button>;
const Page = (p: { onClick: () => void }) => <Button onClick={p.onClick} label="Go" />;
const Layout = (p: { onClick: () => void }) => <Page onClick={p.onClick} />;

// version B — one level composed with children
const Page2 = ({ children }: { children: React.ReactNode }) => <>{children}</>;
// <Layout2><Button onClick={on} label="Go" /></Layout2>   // Page passes JSX through
```

Both versions: one click → handler spy called **once** (assert `toHaveBeenCalledTimes(1)`),
message state updated once. The children rewrite deleted two pass-through signatures, and
it is only *better* where the middle level had nothing to say about the prop — which is the
rule: **drilling is fine up to ~3 levels (the composition lesson's ceiling); past that the
pass-through signatures are the smell, and the reader stops being able to see who consumes
what.**

**Executed fact you must design around** (probe B4): a callback prop is a *new function
identity on every render* — `renders: 2 | distinct callback references: 2`. Any
`React.memo` child receiving `onClick` directly will re-render anyway; wrap the handler in
`useCallback` (probe C4's stable-identity receipt) or memoize at the level that owns it.

## Exercise 3 — Defaults: `undefined` vs omitted vs `null`

```tsx
const Tag = ({ value = "x" }: { value?: string | null }) => <i>{String(value)}</i>;
```

Three cases, three assertions:

| Input | Rendered | Why |
|---|---|---|
| `<Tag />` (omitted) | `x` | prop absent → `undefined` → destructuring default fires |
| `<Tag value={undefined} />` | `x` | default fires on `undefined`, *however* it arrived |
| `<Tag value={null} />` | `` (empty) | `null` is a value — defaults do **not** fire |

**The rule:** a destructuring default fires on `undefined` only. `null` means "the caller
deliberately set nothing" — distinguishable on purpose (that's why React uses `null` for
"no children / no error"). If your API needs to tell "not passed" from "passed empty", type
it `value?: T | null` and branch on `null` explicitly; never conflate it with `undefined`
or you lose the distinction the type system just gave you.

## Exercise 4 — Props-API-first (independent)

**Before (the signature written first, one line per prop):**

```tsx
// Sparkline — a 60×20 inline trend glyph.
// values: data points, newest last (required — a trend with no points is a bug, not an empty state)
// tone:   semantic colour axis, closed union — which series this is
// label:  one sentence for screen readers (required — a glyph with no name is invisible to AT)
// showAxis: draw the baseline — off by default; call sites that compare two sparklines turn it on
type SparklineProps = {
  values: number[]; tone: "up" | "down" | "flat"; label: string; showAxis?: boolean;
};
```

**Three call sites** (assert each renders and its `aria-label`): dashboard header
(`tone="up"`), row component (`tone="down"`, `showAxis`), empty-row placeholder
(zero-length `values` — the case that made me add the axis).

**What the first API got wrong (the count):** one prop nobody used (`height` — every call
site took the default; deleted), one missing axis (`showAxis` — added after call site 3
rendered two charts with no common baseline), and one wrong type (`values: number[]`
accepted `[]` silently — the placeholder call site forced a decision: render the empty
glyph, don't throw).

**Deliberately refused:** a `format` callback for the tooltip. It would have been the
component's third axis, every call site would pass a *different* closure (see B4 — a new
identity per render, killing any memo), and formatting belongs to the caller's locale
layer. Refusing kept the component a function of its data.

**Criteria check:** ☐ three tones asserted ☐ `TS2322` captured with code ☐ `data-*`
pass-through asserted ☐ drill written level-by-level, both versions spy-asserted ☐ three
default cases asserted ☐ signature-before-code file evidence, three call sites, revision
list, one refused axis.

---

Next: [README](README.md) — back to the index.
