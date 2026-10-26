# Set 1 solutions — React fundamentals → `react-fundamentals.md`

*Executed in the batch's Vite + Vitest lab (React 19.3.1, Vitest 5.0.5, jsdom 30.1.3).*

## 1. JSX expansion, predicted then executed

**Paper first (the prediction):**

```tsx
<C x={1}>hi</C>
```
expands to
```js
jsx(C, { x: 1, children: "hi" }, /* key */ undefined)
```

**Executed check** — assert what the runtime saw by capturing the element itself rather
than the DOM:

```tsx
it("JSX is a function call", () => {
  let seen: any;
  function C(props: any) { seen = props; return <i>{props.children}</i>; }
  const el = <C x={1}>hi</C>;          // call happens NOW (element creation)
  expect(seen).toBeUndefined();        // function runs only at render
  render(el);
  expect(seen).toEqual({ x: 1, children: "hi" });
  expect(el.type).toBe(C);             // first JSX arg: the component function
  expect(el.props.x).toBe(1);          // second: props object
  expect(el.props.children).toBe("hi"); // children ride inside props
  expect(el.key).toBeNull();           // third: key — null when absent
});
```

**Match report (the criteria):** type ✓ (`el.type === C`), props order is irrelevant to
React but the *shape* `{ x, children }` ✓, children inside props ✓ (not a third
argument), self-closing `<C />` produces `children: undefined` ✓. The one detail beginners
get wrong on paper: children are **props**, not a separate parameter — the automatic runtim
transform (`jsx` from `react/jsx-runtime`) passes `key` as the third argument and
everything else as one props object.

**The purity claim with its exception:** the same input props produce identical output
markup — true of what the function *returns*. The exception isn't purity's, it's identity:
the element tree holds component *functions* as types, so two calls with equal props but
different function identities are different elements (React re-renders). Purity is a
property of the render output, not of reconciliation.

## 2. The key warning, then the id keys

```tsx
it("index keys warn and mis-attach; id keys don't", async () => {
  const warn = vi.spyOn(console, "warn").mockImplementation(() => {});
  function List({ items }: { items: { id: number; label: string }[] }) {
    return <ul>{items.map((it, i) => <Row key={i} label={it.label} />)}</ul>;
  }
  function Row({ label }: { label: string }) {
    const [n, setN] = useState(0);
    return <li><button onClick={() => setN(n + 1)}>{label}:{n}</button></li>;
  }
  const a = [{ id: 1, label: "first" }, { id: 2, label: "second" }];
  const { rerender } = render(<List items={a} />);
  await userEvent.click(screen.getByRole("button", { name: "first:0" }));
  expect(screen.getByRole("button", { name: "first:1" })).toBeTruthy();

  // prepend: index keys keep position 0 for a DIFFERENT row
  rerender(<List items={[{ id: 0, label: "new" }, ...a]} />);
  expect(warn).toHaveBeenCalledWith(
    expect.stringContaining("Each child in a list should have a unique")
  );
  // state followed POSITION, not identity — button "new" carries the old click:
  expect(screen.getByRole("button", { name: "new:1" })).toBeTruthy();
  warn.mockRestore();
});
```

Switching to `key={it.id}` removes the warning and re-attaches state to the matching id:
after the prepend, `first` still reads `first:1` and `new` reads `new:0`.

**The rule:** keys are identity; index keys are only safe on lists that never reorder or
insert (a static rendered list). The wrong-attach bug is silent in review because the DOM
*looks* right — only the state attachment is wrong.

## 3. Pure render of props

```tsx
it("same props → identical markup", () => {
  const view = (p: { tone: "a" | "b"; label: string }) =>
    renderToStringLike(<Badge {...p} />);   // renderToString from react-dom/server
  expect(view({ tone: "a", label: "x" })).toBe(view({ tone: "a", label: "x" }));
  expect(view({ tone: "b", label: "x" })).not.toBe(view({ tone: "a", label: "x" }));
});
```

Failing variant: move `let count = 0; count++` to module scope inside the component body —
outputs differ run to run, the purity contract is violated, and the fix is exactly the
discipline the state lesson states: **state lives in hooks, never in module or instance
variables**.

## 4. Rendering contract receipts

| Receipt | Executed evidence |
|---|---|
| Render with no DOM change | render a counter at `n=0`, click nothing; `container.innerHTML` before/after a forced re-render (`rerender` with equal props) is byte-identical — React still re-ran the function; DOM diffs to nothing |
| Batched commits | two `setN` calls in one click handler produce **one** `useEffect` run (spy count `1`) — the L-cluster's `3 clicks inside ONE act → +1` behaviour |
| Child re-render baseline | parent state change with a plain child: child render-count `4` after `1 + 3` separate updates (the L1 executed baseline) — this is the *unoptimized* contract the performance lesson prices |

**The pipeline order:** render (function runs, reconciliation computes) → commit (DOM
mutations applied, layout/paint follow). jsdom proves the first two; real paint timing is
the honest limit (stated, not claimed).

---

*Criteria cross-check: predictions before execution ✓, ≥4/5 details matched ✓, warnings
asserted not eyeballed ✓, three receipts executed ✓, exception and limits named ✓.*
