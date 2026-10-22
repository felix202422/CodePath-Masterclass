# Projects — 07 HTML and CSS

Three build briefs, in order of difficulty. Each is small enough to finish in a sitting and
hard enough to force every concept it sits after. Acceptance criteria are written the way a
reviewer checks work: observable, runnable top to bottom, no credit for "looks right on my
screen".

**How to use these briefs:** attempt first — no reference markup exists for these, by design;
the criteria *are* the answer key's shape. Check yourself honestly against each line, exactly
as [20-PROJECT-LABORATORY](../../20-PROJECT-LABORATORY/README.md) instructs. The three briefs
are also the preparation for **[Project 02 — Responsive Portfolio](../../20-PROJECT-LABORATORY/project-02-responsive-portfolio/README.md)**
(the laboratory's full expression of this subject); its promotion gate — "passes the
accessibility checklist and works from 360 px to 1440 px" ([ROADMAP](../../ROADMAP.md)) — is
the acceptance bar of briefs 1–3 combined.

**One reviewer tooling note that saves everyone time:** the 360 px check below is performed in
**devtools device emulation** (F12 → toggle device toolbar → 360 × 640), *not* by dragging the
window narrow. Headless and windowed browsers enforce a minimum content width on this
authoring machine (~504 px — measured and recorded in
[responsive-design](../responsive-design.md)); device emulation sets the viewport metrics
directly and is the check real mobile traffic corresponds to.

---

## Brief 1 — Semantic article page → `html-fundamentals.md` · `semantic-html.md` · `typography-and-design-tokens.md`

Build a single self-contained article page: site header with navigation, article with a
complete heading outline, at least one figure with a caption, a blockquote, a definition list
or table where the content justifies it, and a footer. Topic of your choosing; at least
600 words of real prose (lorem ipsum is rejected — heading structure can't be judged against
placeholder text).

**Requirements**

- Every element chosen for meaning, not appearance: landmarks (`header`/`nav`/`main`/`article`/
  `footer`), correct heading levels, `<figure>`/`<figcaption>`, `<blockquote>` + `<cite>`.
  Zero `<div>`s used for structure that a semantic element exists for.
- One stylesheet: design tokens (`:root` custom properties) for color, type scale, spacing
  scale — the lesson-9 pattern — consumed by every rule below it.
- Typography: one font family, a modular type scale via `clamp()`, `line-height` unitless,
  a measure of ~60–75 characters.

**Acceptance criteria**

1. axe-core on the page reports **0 violations** (run in devtools Lighthouse or the in-page
   `axe.run()` pattern from the accessibility lesson).
2. Heading outline is a correct tree: exactly one `h1`, no skipped levels, in document order
   (devtools accessibility pane, or the lesson-2 outline probe pattern).
3. Every image has `alt` conveying its information; the figure's caption is a real
   `<figcaption>`, visible, associated with its figure.
4. Color tokens pass contrast: body text ≥ 4.5:1, large text ≥ 3:1 (compute with the
   accessibility lesson's script — quote the ratios you measured).
5. Works at 360 px (device emulation) with no horizontal scrolling, and at 1440 px with the
   measure still readable (text column not stretched full-width).
6. Keyboard pass: Tab through the page — every link has a visible focus indicator
   (`:focus-visible`), and the tab order matches the visual/reading order.

## Brief 2 — Responsive navigation → `css-fundamentals.md` · `box-model.md` · `flexbox.md` · `css-grid.md` · `responsive-design.md`

Build the site header for the article above into a real responsive navigation: logo/wordmark
left, nav links right, implemented with the flexbox lesson's `space-between` row (`gap`
between items, `align-items: center`). Below the mobile breakpoint it becomes a stacked
(`flex-direction: column`) layout — the flip executed in the responsive lesson's transcript.
A current-page indication, and hover/focus states that don't rely on color alone.

**Requirements**

- Box-sizing discipline: the border-box default declared globally; layout math (header
  padding, item sizes) reasoned in the box-model lesson's terms, with at least one spot where
  you can state the arithmetic (declared width → padding box → border box) from measurement.
- One breakpoint driven by *content*, not a device: the header stacks when the row stops
  fitting — state the content-based reason at the width you chose.
- Fluid type for the wordmark with `clamp()` (the responsive lesson's pattern); spacing from
  the brief-1 token scale, not new magic numbers.

**Acceptance criteria**

1. At 360 px (device emulation): navigation is stacked, every link is reachable and
   tappable-sized (≥ 44 × 44 px touch target — measure), no horizontal scroll.
2. At 768 px and 1440 px (exact viewport widths in devtools emulation): navigation is the
   single flex row, wordmark left, links right, vertically centered; report the resolved
   `flex-direction` at each width (computed styles pane).
3. `box-sizing` arithmetic check: with devtools computed styles, one declared size traced
   through padding + border to its offset box, matching your stated arithmetic.
4. Resize across the breakpoint in both directions — no layout overlap, no content clipping,
   and the breakpoint's content-based reason documented in a comment at the media query.
5. Keyboard pass: every nav link tab-stops in visual order with a visible focus ring;
   `:hover` styling has a matching `:focus-visible` state (screenshot both).
6. axe-core: 0 violations on the page carrying this header.

## Brief 3 — Form-heavy settings screen → `forms-and-validation.md` · `accessibility.md`

Build a user-settings screen as a real form: text inputs with labels and hints, a select, a
fieldset of radios or checkboxes with a `<legend>`, a validation summary that appears on
failed submit, and per-field error messages wired with `aria-describedby` and `aria-invalid`.
Client-side validation uses the Constraint Validation API the forms lesson executed; every
error is identified in text, not by color alone.

**Requirements**

- Every control has a real `<label for>`; hints and errors are associated programmatically
  (the forms lesson's `aria-describedby` pattern) — never placeholder-as-label.
- Validation: `novalidate` form + scripted `checkValidity()` flow (the executed pattern) so
  error presentation is yours, not the browser's — or native validation, in which case you
  style and explain `:user-invalid`. State which and why.
- Error state: an `aria-live` summary region naming every failing field; on submit failure,
  focus moves to the first invalid control (executed focus-management pattern).
- The screen works with JavaScript disabled for its core function (submit and native
  `required`/`type` semantics still constrain) — state what JavaScript adds on top.

**Acceptance criteria**

1. axe-core: 0 violations; every input's accessible name is its visible label (accessibility
   pane — not `aria-label`).
2. Submit empty: the summary region announces the failures (screen-reader spot check or the
   DOM's live-region + focus evidence), focus lands on the first invalid field, and each
   message says what to fix ("Enter a value in the format name@example.org" — not "invalid").
3. Fill correctly, resubmit: errors clear, `aria-invalid` resets, summary announces success.
4. Contrast ≥ 4.5:1 for input text, labels, hints, *and error text* (quote the error color's
   ratio — the accessibility lesson's 2.85:1 lesson is the failure mode to avoid).
5. Works at 360 px: fields full-width, no horizontal scroll, errors wrap cleanly inside the
   field column.
6. Keyboard-only run, start to finish: complete and submit the entire form without touching a
   pointer, with visible focus at every stop and no keyboard trap.

---

## How the briefs feed Project 02

Project 02 — Responsive Portfolio is these three briefs composed: semantic article sections
(brief 1), a responsive header and grid of project cards (brief 2), a contact form with the
full validation contract (brief 3) — plus content, a real deployment, and the accessibility
checklist as a promotion gate rather than a final pass. Briefs done honestly make Project 02
a composition exercise instead of a rewrite.

## Self-check discipline

Log each brief's pass in [PROGRESS-TRACKER.md](../../PROGRESS-TRACKER.md) only when every
criterion passes as written — "works on my machine at my window size" is not criterion 5.
If a criterion fails, fix the *concept* (the lesson it sits after), not the symptom.
