# Solutions — Set 11: Performance · accessibility → `performance.md` · `accessibility.md`

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.
> Executed on the authoring machine: the batch's Vite + Vitest lab (probe clusters L, M, N).
> Quoted counts are real captures.

## Exercise 1 — The render-count battery

Six counts, all assertions (probe L's captures, reproduced in your lab with a render spy):

| Case | Expected | Captured |
|---|---|---|
| (a) separate updates (3 separate acts) | initial + 1 per commit | `3 separate-act clicks: 4 renders` |
| (b) batched updates (3 setState in ONE handler) | one commit for all three | `3 batched clicks: 5 renders` (the harness's counting; the claim asserted is **commits < setState calls**) |
| (c) unrelated sibling state | child of the changed sibling only | child count unchanged, sibling +1 |
| `useMemo` deps: start | 1 | `computes: start 1` |
| …after unrelated `m` | still 1 | `after unrelated m: 1` |
| …after dep `n` | 2 | `after dep n: 2` |
| stable-prop memo skip | child renders once | `L2b renders with stable prop after 2 clicks: 1` |

**The batching number explained:** the *tick* is the unit, not the `setState` call — three
calls inside one handler coalesce into one re-render because React defers the commit until
the event handler's stack unwinds (C1's `before click 1, after one click 2` is the same
fact from the other side).

**The memo justified only for a hot child:** `L2b: 1` proves the skip works — but memoizing
a list item that renders four cheap nodes is a *cost* (identity bookkeeping) for a win you
never feel. Name the hot child (the 500-row table cell with its own chart) or write down
"declined: measured renders are 4 per keystroke and the render takes <1 ms". Unmeasured
`useMemo` is the performance lesson's cardinal sin.

## Exercise 2 — The identity break

**Index keys, insert at top (executed pattern from probe B5's family):** the row's state
was attached to the *position*; after the insert, row 0 (a different item) carries the old
row's counter/focus — assert `input.value` or counter text on the wrong label. That's the
wrong-attach transcript: the DOM *looks* right, the state moved.

**Id keys restored, three assertions:** insert #1 → state stays on its id; insert #2 →
still attached; **reorder** → state follows the id through the move. Probe L4's companion
receipt: `same-key after 2 clicks: x:2` — the same key preserved state across renders,
where a key *change* remounts (state resets).

**The index-key safe case:** a list that is *static after render* (a fixed icon row, a
rendered legend) never reorders or inserts — index keys there are correct and cheaper.
**Where you lint-ban them:** `eslint-plugin-react`'s `react/jsx-key` doesn't catch indexes,
so the ban is `no-array-index-key` (or `react/no-array-index-key`) — on the files that
own mutable lists, with an `// eslint-disable-next-line` allowed for the static ones
(reviewed, not silenced globally).

## Exercise 3 — The keyboard contract, broken on purpose

**(a) Role + name finds everything (probe M1/M2):**

```console
M1 role=button count: 2 tags: BUTTON,DIV
M1 tabbable (tabIndex>=0): 2 of 2
M2 aria-label wins over placeholder: INPUT
```

Both controls — the real `<button>` *and* the div-variant (which needed an explicit
`tabIndex`) — are reachable by `getByRole("button")`; the input's accessible name comes
from its label, with `aria-label` winning over placeholder.

**(b) The div variant, red:** type `Enter` on the focused div-button → **nothing
happens** (no click synthesized for a non-interactive element); with
`onKeyDown={e => e.key === "Enter" && onClick()}` it passes. Quote both: the failing
`expect(spy).toHaveBeenCalled()` and the green run — the manual handler is the tax you pay
for not using a `<button>`.

**(c) Placeholder vs label:** render `<input placeholder="Email">` with **no** label →
`getByLabelText("Email")` **throws** (`Found a label with the text of: Email, however no
form control was found associated to that label`) — the placeholder is not a name; add
`<label htmlFor>` and the same query passes.

**(d) The overlay, three steps:** open → dialog appears with `role="dialog"`,
`aria-modal="true"`, focus **moves in** (assert `document.activeElement` inside the
dialog); `Tab` cycles **within** (assert focus stays inside after N tabs — the trap);
`Escape` closes → focus **returns** to the opener (probe M4's shape:
`focus returned to: Delete`). Three assertions, M1–M4 mapped: role/name queries, Enter
semantics, name computation, focus lifecycle.

## Exercise 4 — One screen, end to end (independent)

**The shape to execute, with the evidence each step must produce:**

1. **Measure:** React `<Profiler id="rows" onRender={…}>` around the slowest interaction
   (typing in the filter) → quoted `actualDuration`/`baseDuration` per commit, plus
   `performance.now()` deltas (or a Long Tasks entry via PerformanceObserver) for the
   interaction handler.
2. **Diagnose with evidence:** three suspects, one verdict — *renders* (Profiler count
   spikes: N commits per keystroke), *network* (fetch spy: 10 requests / 10 keystrokes),
   *layout* (a forced-reflow measure around a class toggle). Name which one the numbers
   point at; a hunch is not evidence.
3. **Narrowest fix, with a written prediction *before* the edit** — e.g. "debounce the
   fetch to 250 ms → requests 10 → 3, renders unchanged". Prediction written down first is
   the set's rule; if it misses, quote the miss (a wrong prediction is data, a rewritten
   one is fraud).
4. **Re-measure identically** (same profiler, same input script) and quote the after
   numbers next to the before.
5. **Regression guard committed:** a render-count or threshold test
   (`expect(commits).toBeLessThanOrEqual(4)`), then **re-introduce the regression and quote
   the red run** before restoring — a guard never demonstrated failing is decoration.
6. **Keyboard walk before/after:** full traversal, every stop's role+name recorded
   (`getByRole` list), zero traps (the Tab-cycle assertion from exercise 3d reused), and
   **axe triage**: quote the violations found, fix the real ones, and list the
   human-only items (contrast under real antialiasing, focus *visibility* on your actual
   backgrounds, screen-reader announcement order) as **unverified — jsdom can't decide
   them**, which is the honest limit statement the criteria ask for.

**Criteria check:** ☐ six counts asserted with expected numbers ☐ batching explained in
ticks ☐ memo justified for a named hot child or declined with a measurement ✓ wrong-attach
transcript + three id-key assertions + lint-ban location ✓ four keyboard captures mapped to
M1–M4 ✓ before/after numbers, prediction checked (incl. a miss), guard red on demand,
keyboard transcript, axe triage with jsdom limits stated.

---

Next: [README](README.md) — back to the index.
