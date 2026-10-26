# Solutions — Set 4: Component composition → `component-composition.md`

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.
> Executed on the authoring machine: the batch's Vite + Vitest lab (probe clusters D and K).
> Quoted outputs are real captures; API-change counts are shapes — your diff is your evidence.

## Exercise 1 — One screen, three APIs

```tsx
// (a) config props
<Panel title="T" body="B" footer={<F />} />
// (b) children slots
<Panel header={<h2>T</h2>}><B /><F /></Panel>
// (c) render prop for the footer
<Panel title="T" body="B" renderFooter={() => <F />} />
```

Assert default-case equality: three `renderToString`-style renders produce the **same
markup string** (normalize whitespace; the assertion is structural equality, not visual).
Probe D5 shows the composed shape the three must converge on:

```console
D5 composed:   <div><h2>T</h2><div>B</div><footer>F</footer></div>
```

**The change table — add a fifth region (`aside`):**

| Approach | Props touched | Call sites touched |
|---|---|---|
| (a) config | +1 prop, +1 JSX in every call site | all of them |
| (b) children | +0 props (a slot is just another child) — callers add the element where it belongs | only callers with the region |
| (c) render prop | +1 render-callback prop | all of them |

**The pick:** (b), because the count grows with *use*, not with *API surface* — and it's the
one that doesn't need a type change to gain a region. Take (c) only when the parent must
control *when/how often* the region renders (a virtualized list, a deferred value); take (a)
for leaf widgets with 2–3 fixed regions, where a slot is ceremony.

**Gotcha you'll meet on the way** (probe D3): `n=0 renders "0" &&` and `n="" renders ""` —
guard with `n > 0 && …`, never bare `n && …`, or your "empty" slot renders a literal `0`.

## Exercise 2 — Lift state up, then lift it further

**Version A (list + detail, state in their shared parent):**

```tsx
function Page() {
  const [sel, setSel] = useState(items[0].id);     // lowest common ancestor of both readers
  return <><List items={items} sel={sel} onPick={setSel} /><Detail sel={sel} /></>;
}
```

**Version B (state two levels up**, in a `Shell` that owns nav + content): same click
assertion — `click(row 2)` → detail heading becomes row 2's title, both layouts, identical
result.

**The rule:** state goes to the **lowest common ancestor of every component that reads
it** — no higher (higher re-renders strangers), no lower (siblings can't see it). When the
lift crosses three or four levels, or the readers stop sharing a subtree (routes, modals,
a header reading page state), you have left composition territory and entered
[state management](../state-management.md)'s ladder — the lift itself doesn't change, only
who owns the provider.

## Exercise 3 — `Box` with `as` + className merge

```tsx
const Box = ({ as: Tag = "div", className, style, ...rest }: {
  as?: "div" | "section" | "aside"; className?: string; style?: React.CSSProperties;
}) => <Tag {...rest} className={`box ${className ?? ""}`} style={{ padding: 16, ...style }} />;
```

Three call sites asserted: `<Box as="section" className="card" />` → `tagName SECTION`,
className `box card` (**variant first, caller second** — the merge position matters when a
utility class must win), `style={{padding:16, ...caller}}` likewise lets the caller override.
Probe K3's receipt: *polymorphic `as` renders the requested element*.

**The K3-style pricing:** `as` collapses three components into one, but the type gives up
element-specific props — `<Box as="a" href>` types `href` on a `div`-shaped prop set unless
you pay for a discriminated union (`{as:"a"; href:string} | {as:"div"; href?:never}`), and
even then `style`/`className` merging is now *your* runtime contract instead of the DOM's.
**Accepted here** (three visually identical wrappers, one className rule), **rejected** as
soon as the variants diverge in behaviour — at that point three small components are the
cheaper lie.

## Exercise 4 — The `PageShell` (independent)

```tsx
function PageShell({ header, sidebar, children: content }: Slots) {
  return (
    <>
      <header className="shell__h">{header}</header>
      <div className="shell__b">
        {sidebar ? <aside className="shell__s">{sidebar}</aside> : null}
        <main className="shell__c">{content}</main>
      </div>
    </>
  );
}
```

**Four configurations asserted** (reference — run in your lab): full · no sidebar
(`sidebar={null}` → `queryByRole("complementary")` is null, `main` still present) ·
header-only · content-only. The landmark assertion is by **query, not markup**:
`getByRole("banner")`, `getByRole("navigation")` (when the header carries the nav),
`getByRole("main")` — asserted equal across all four, because the *roles* are the contract
and the wrapper `<div>`s are free to change.

**Slot-contract note (what the shell guarantees each region must provide):** `header` →
banner-role content, exactly one; `sidebar` → optional, complementary-role, may be omitted
but never half-rendered; `content` → exactly one `main` with the page's `h1`. The shell
guarantees placement and landmarks; it does **not** guarantee styling, sizing, or scroll
behaviour — those belong to the region owners (that boundary is what keeps the degenerate
case from becoming a special case).

**Criteria check:** ☐ three versions asserted equal ☐ change table with per-approach
counts ☐ both lift structures tested with identical click results ☐ `as` three assertions
+ merge position + written pricing ☐ four shell configurations with role-by-query
landmarks ☐ slot-contract note.

---

Next: [README](README.md) — back to the index.
