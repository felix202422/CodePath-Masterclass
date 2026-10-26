# Projects — 09 Frontend Engineering

Three build briefs, in order of difficulty. Each is small enough to finish in a sitting and
hard enough to force every lesson it sits after. Acceptance criteria are written the way a
reviewer checks work: observable, runnable top to bottom, no credit for "it seemed fine."

**How to use these briefs:** attempt first — no reference implementation exists for these,
by design; the criteria *are* the answer key's shape. Check yourself honestly against each
line, exactly as [20-PROJECT-LABORATORY](../../20-PROJECT-LABORATORY/README.md) instructs,
and run the lab commands from [exercises/](../exercises/README.md) (Vite + React + Vitest,
the same scaffold the lessons were executed in). The three briefs are the preparation for
**[Project 05 — Full-stack Application](../../20-PROJECT-LABORATORY/project-05-full-stack-application/README.md)**:
brief 3's dashboard is Project 05's frontend half, and the promotion gate in
[ROADMAP.md](../../ROADMAP.md) ("build an async data-fetching component with loading, empty
and error states; type a component's props so misuse is a compile error; write a component
test that fails when the behavior regresses") is the acceptance bar of briefs 1–3 combined.

**Reviewer tooling notes.** Keyboard criteria are executed with the Tab/Enter/Space keys only
(pointer unplugged or hands visibly off it). Computed-style and accessibility-pane checks are
devtools (F12). axe-core runs in-page as in the accessibility lesson. Every "assert" below
means a Vitest assertion in your lab, not a `console.log` you eyeballed.

---

## Brief 1 — Paginated data table with filtering → `state-and-hooks.md` · `api-integration.md` · `reusable-components.md` · `accessibility.md`

Build a table view over a fixture API (your own `fetch` mock or a JSON server): at least 40
rows, sortable columns, a text filter, server-shaped pagination (`page`, `pageSize`,
`total`). The table is one component family — `Table` renders, the page owns the data — and
every row interaction is keyboard-reachable.

**Requirements**

- The four-state contract from the error lesson is total: `loading` (skeleton rows, not a
  spinner-in-the-corner), `empty` (an `EmptyState` naming what to change), `error`
  (an `ErrorState` with a working Retry), `success`. Union type with an exhaustive
  `never` check — no boolean soup.
- Fetching is cancelable: a filter keystroke that supersedes an in-flight request must not
  let the stale response win (the api lesson's abort line), asserted as a race test.
- Filter input is debounced *or* per-keystroke — you choose, and you write down the
  invalidation cost you measured (the state-management lesson's per-keystroke vs per-settle
  trade-off).
- Table semantics: a real `<table>` with `<th scope>`; sort state exposed via
  `aria-sort`; the pagination region is a `<nav aria-label>` with `aria-current="page"`.

**Acceptance criteria**

1. Six tests green: loading, empty, error→retry→success, sort, filter, and the stale-race
   (slow old response arriving after the new one never renders).
2. `npm run typecheck` clean; a deliberately wrong prop (e.g. `pageSize="ten"`) captured
   as a `tsc` diagnostic with its code.
3. Keyboard: every row control and the pagination links tab-stop in visual order; Enter/
   Space activates; focus visible at each stop (screenshot both states).
4. axe-core: 0 violations on the loaded, empty, and error states — all three.
5. Render-count evidence: filtering 40 rows re-renders what you predict (state the count,
   assert it) — the performance lesson's measurement discipline, not a guess.
6. No `any` in your own code (`grep -rn "any" src/` reviewed and justified line by line).

## Brief 2 — Form-driven wizard with validation → `forms.md` · `component-composition.md` · `frontend-testing.md`

A three-step create flow (e.g. account → preferences → review) where each step gates the
next on its own validation, the review step summarizes everything, and a failed final
submit never loses typed input.

**Requirements**

- Per-step validation with the strategy you chose in the forms lesson and *stated* in a
  comment: native (`novalidate` off) or scripted `checkValidity()` (`novalidate` on) —
  either way, every error is text, associated with its field (`aria-describedby` +
  `aria-invalid`), and announced through one `aria-live` summary.
- Step state lives at the shell (composition lesson's lift rule), each step is a component
  receiving value + `onChange` — no step reaches into another's state.
- The review step's "edit" links return to the owning step with values intact; browser
  Back restores a *valid* previous step, never a half-filled broken one (state the
  persistence decision: URL, storage, or documented non-persistence).
- Focus management: on step change, focus moves to the new step's heading; on failed
  submit, focus moves to the first invalid control (the executed focus pattern).

**Acceptance criteria**

1. Tests green for: Next blocked on invalid step 1, valid step 1 → step 2, review
   summarizing exact values, edit-from-review round trip, failed final submit keeping
   values, and successful submit sending one request (spy count 1 — the double-click
   idempotency assertion).
2. Keyboard-only run of the whole flow: complete all three steps and submit without a
   pointer; focus visible at every stop; no keyboard trap (transcript with the keys used).
3. axe-core: 0 violations at every step and on the error state.
4. Contrast ≥ 4.5:1 for labels, values, hints, and error text (quote the ratios).
5. 360 px device emulation: steps stack cleanly, no horizontal scroll, errors wrap inside
   the field column.
6. One test deliberately broken and repaired, with the failure message quoted — the
   testing lesson's red-is-information drill (test-bug red vs product-bug red stated).

## Brief 3 — Token-authenticated dashboard → `frontend-authentication.md` · `state-management.md` · `error-and-loading-states.md` · `performance.md`

A small authenticated area: login screen, guarded dashboard shell (header + nav + one data
view), logout — with the session held the way the auth lesson's trade-off section made you
choose *in writing*, and the dashboard's data view exercising the full state quartet under
real latency.

**Requirements**

- Route guard round trip: protected visit → `/login` with an encoded `next` → successful
  login lands exactly on the original path → logout unmounts the protected tree (browser
  Back must not resurrect it) → an external `next=https://evil.example` is rejected
  (allow-list relative paths only — the open-redirect defense, named in a comment).
- Token storage matches your written threat model: memory + refresh, httpOnly cookie
  delegated to a backend, or localStorage with the XSS cost stated. Assert your choice
  (`Object.keys(localStorage)` empty is the memory-mode receipt).
- The dashboard data view: loading skeleton, empty state, error state with retry, success —
  plus a refresh path that keeps the last good data visible while revalidating (state
  whether the stale data is labelled).
- Context splits value from actions (the split-context mitigation) so unrelated shell
  state (e.g. a collapsible sidebar) does not re-render data consumers — render-count
  asserted.

**Acceptance criteria**

1. Five guard assertions: redirect, encoded `next` round trip, exact landing path, back-
   after-logout unmount, external-`next` rejection.
2. The 401-during-session branch runs exactly once (refresh-singleton spy count 1) and a
   failing refresh clears the session — both asserted, failure branch included.
3. Render-count evidence that shell state changes do not re-render the data view (before/
   after counts quoted).
4. Bundle evidence: the dashboard's heavy view (chart, editor, whatever is plausibly
   heavy) loads via dynamic import as its own chunk — `vite build` output line quoted —
   and Suspense shows the loading state, not a blank frame.
5. axe-core: 0 violations on login, dashboard, and error states; every interactive control
   found by role+name query (the testing lesson's ladder — no structure queries).
6. Tests fail when behavior regresses: revert one real fix (e.g. remove the abort line or
   the guard) and quote the failing test before restoring it.

---

## How the briefs feed Project 05

Project 05 — Full-stack Application is these three briefs behind a real API: the table
consumes your REST endpoints (brief 1), the wizard posts them (brief 2), and the dashboard
sits on your authenticated backend (brief 3) — with real tokens, real validation on both
sides, and the frontend test suite as one layer of the pipeline the build lesson wired.
Briefs done honestly make Project 05's frontend a wiring exercise instead of a rewrite.

## Self-check discipline

Log each brief's pass in [PROGRESS-TRACKER.md](../../PROGRESS-TRACKER.md) only when every
criterion passes as written — "works on my machine" is not criterion 2. If a criterion
fails, fix the *concept* (the lesson it sits after), not the symptom.
