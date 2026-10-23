# Solutions — Set 4: DOM and Events

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.
> Transcripts below were captured on the authoring machine with **headless Chrome 156**
> (`--headless=new --dump-dom` on a local file), the same harness subject 07 used.

## Exercise 1 — The four-listener propagation trail

**Reference transcript (authoring machine):**

```console
document-capture:go
button
out-bubble:go
body-bubble:go
document-bubble:go
```

- Order, phase by phase: capture runs **outer → inner** (`document` capture first, before the
  target), the **target** listener fires (`button`), then bubble runs **inner → outer**
  (`out` → `body` → `document`).
- The second half of the exercise (move the button *inside* the `out` div) is visible in this
  very trail: `out-bubble` now appears because ancestry changed — a listener only sees events
  that pass through its node, and bubbling walks the actual `parentNode` chain at click time.
- Toggling the capture flag (`addEventListener("click", fn, true)` vs `false`) moves that
  listener between the two halves of the trail — that *is* the flag's effect: same node, same
  callback, different phase position.
- **Criteria check:** ☐ two trails captured ☐ difference explained by ancestry ☐ capture flag
  toggled.

## Exercise 2 — Listener identity

**Reference transcript (authoring machine):**

```console
same named fn twice, hits=1
after removeEventListener, hits=1
arrow registered twice, arrowHits=2
```

- The same **named function** registered twice fired **once**: `addEventListener` keys entries
  on *(type, callback, capture)* — the second call found an identical key and was ignored.
  `removeEventListener("click", named)` then removed that one entry — the next click added
  nothing to `hits`.
- Two *different* arrow objects (one stored, one inline) are two distinct callbacks → both
  fired (`arrowHits=2`). And removing an inline arrow you did not keep a reference to is
  impossible — which is precisely why a re-rendering UI that recreates arrows on every pass
  leaks handlers: each render registers a new key that can never be matched again.
- Identity rule to state verbatim: removing works only when you pass **the same function
  object** with the **same type and capture flag** you registered.
- **Criteria check:** ☐ three states executed ☐ identity rule stated ☐ re-render leak sentence.

## Exercise 3 — Delegated todo with inline editing

**Reference shape** (behaviour is the criterion; the lesson's Example 2 widget is the base):

- **One** delegated `click` listener on the list container decides by `event.target.dataset`
  (`toggle` / `delete`), and one delegated `dblclick` swaps the `<span>` for an `<input>`; the
  input listens for `keydown`: **Enter** writes `input.value` back via `textContent`, **Escape**
  discards and restores the span. No listener is ever attached to an item — items created
  before *and* after load behave identically, because the handler resolves ancestry at event
  time.
- Count check: `grep -c addEventListener` on the file should read **2–3** (list click, list
  dblclick, keydown — the last possibly re-attached only while editing).
- Safety: user content goes through `textContent` (or `input.value`), never `innerHTML` —
  otherwise a todo titled `<img src=x onerror=…>` executes. The lesson's executed note about
  `textContent` vs `innerHTML` is the whole justification.
- **Criteria check:** ☐ all four operations work on pre- and post-load items ☐ listener count
  ≤3 ☐ no `innerHTML` for user input.

## Exercise 4 — The focus-trapping modal (independent)

**Reference shape:**

- **Listeners:** `keydown` on the modal container (Tab/Shift+Tab wrap focus among its
  focusable elements — `preventDefault` on Tab *here* is the trap and is correct); `keydown`
  Escape on `document`; `click` on the backdrop; a `focusin` guard on the document that
  pulls focus back if it escapes. All registered **on open**, all released **on close** via
  `AbortController` (`addEventListener(..., { signal })`) — one `controller.abort()` per open
  cycle is teardown that cannot be forgotten.
- **Executed-shape evidence you must produce:** loop 100 open/close cycles instrumenting
  `addEventListener` (wrap it and count); the count must plateau at the per-cycle value and
  return to baseline after close — a steadily climbing count is the leak signature.
  Tab-cycle and focus-restore are verified by dispatching real `KeyboardEvent`s
  (`document.activeElement.id` before open, after Tab ×N, after close).
- **Where NOT to use the primitives:** do **not** `stopPropagation` on the backdrop's click —
  the backdrop *is* the target; and do not `preventDefault` on Escape or on clicks outside a
  document where the default is nothing you own. One deliberate non-use the criteria ask for:
  letting Tab events *outside* a non-modal dialog bubble normally — only a true modal should
  swallow them, because swallowing Tab in a non-modal panel is a keyboard trap (subject 07's
  keyboard pass: focus containment is the goal, not hostage-taking).
- **Accessibility contract:** focus-visible ring preserved, focus returns to the opener,
  `aria-modal="true"` + labelled title, Escape closes — cross-reference 07's checklist; the
  trap contains the *keyboard* pointer, never the screen-reader virtual cursor.
- **Criteria check:** ☐ ×100 cycles with stable listener count ☐ Tab-cycle + restore verified
  ☐ every `preventDefault`/`stopPropagation` justified with ≥1 deliberate omission ☐ a11y
  checklist cross-referenced.

---

Next: [set-5-solutions.md](set-5-solutions.md)
