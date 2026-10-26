# Exercises — 09 Frontend Engineering

**Lessons:** this subject's sixteen lessons, in order.
**How to use these sets:** attempt first; solutions live in
[solutions/](solutions/README.md) behind a warning. The 15-minute rule from
[learning-method](../../00-START-HERE/learning-method.md) applies — record which hint you used.

Sets 1–12 correspond to the lessons named in their titles and mirror each lesson's exercise
ladder (introductory → intermediate → independent) with observable completion criteria.
Completing all twelve sets *is* this subject's half of the milestone gate in
[ROADMAP.md](../../ROADMAP.md) ("all exercise sets in 06–09 plus accessibility and testing
exercises").

**The lab you need.** Every set runs inside a small Vite + React + Vitest project, the same
shape the lessons were executed in:

```bash
npm create vite@latest lab -- --template react-ts
cd lab && npm i
npm i -D vitest @testing-library/react @testing-library/user-event \
           @testing-library/jest-dom jsdom
```

Add `"test": "vitest run"` and `"typecheck": "tsc --noEmit"` to `package.json`, and a
`test: { environment: "jsdom", setupFiles: "./src/setup.ts" }` block (or `vitest.config.ts`)
with `import "@testing-library/jest-dom"` in the setup file. The lessons were executed with
**Node 24.13.1, React 19.3.1, Vite 8.3.5, Vitest 5.0.5, jsdom 30.1.3, TypeScript 7.0.2, tsc
7.0.2** — policy matches [VERSIONS.md](../../VERSIONS.md): where your versions differ, the
*behaviour* is the criterion and the exact text is yours to capture.

**Predict before you run.** Every set below that says "predict" means paper first: a
prediction you did not write down is not a prediction. Assert in tests where the set says
"assert" — a `console.log` proves it ran, an assertion proves it holds.

---

## Set 1 — React fundamentals → `react-fundamentals.md`

1. Predict, then execute with a test file: what does `render(<Counter start={5} />)` output
   after clicking `+` twice? Write the JSX-to-`js`-call expansion of `<C x={1}>hi</C>` by
   hand first (element type, props object, children), then compare against
   `react-dom/server`'s rendered string for the same tree.
   **Criteria:** expansion written before running; ≥4 of 5 details matched (type, props key
   order, children placement, self-closing form); every mismatch explained with the
   transform rule, not "React is magic".
2. Reproduce the executed key warning: render a list with `i` keys over a list whose middle
   item is prepended, capture the console warning (or assert via `vi.spyOn(console, "warn")`),
   then switch to `item.id` keys and show the warning gone and state following the row.
   **Criteria:** two transcripts (index-key warning present, id-key silent); the
   wrong-attach evidence (state moved to the wrong row under index keys) captured in the
   same run.
3. Prove components are functions of props: one component, three different prop inputs,
   rendered through `renderFragment`-style pure output (no state), and a test that the same
   props produce identical markup twice (pure-render assertion).
   **Criteria:** three outputs captured; the purity claim stated with its one exception
   (component identity in the element tree); a failing variant where a module-level mutable
   breaks it.
4. **Independent:** the rendering contract note: a one-page explainer of *renders →
   commits → DOM* with three executed receipts — a render that produced no DOM change
   (same output), a state update that batched two calls into one commit (cite the batching
   behaviour), and a child re-rendered by a parent with unchanged props (the baseline the
   performance lesson optimizes).
   **Criteria:** three receipts executed in your lab; the pipeline diagram correct in
   order; one honest sentence on what jsdom can't show (real paint).

## Set 2 — Components and props → `components-and-props.md`

1. Build `Badge` with a closed `tone` union, `children`, and rest props; assert (a) three
   tones render distinct classes, (b) an invalid tone is a **type error** (capture the
   `tsc` diagnostic), (c) `data-*` props pass through to the DOM untouched.
   **Criteria:** two passing assertions + one captured diagnostic with its code; the
   rest-spread line justified (which props React strips vs forwards).
2. Prop drilling trace: a 4-level tree (App → Layout → Page → Button) where Button's
   handler comes from App; write the drill as explicit props, then rewrite one level with
   children composition; assert both versions call the same handler once per click.
   **Criteria:** both versions asserted; the drill listed level-by-level before the
   rewrite; one sentence on when drilling is fine (≤3 levels — cite the composition
   lesson).
3. Default-props experiment: `value = "x"` default overridden by `undefined` vs omitted vs
   `null`; capture all three results in assertions.
   **Criteria:** three cases asserted; the default-mechanism rule stated (destructuring
   default fires on `undefined` only); one sentence on why `null` as a value must not be
   confused with "not passed".
4. **Independent:** the props-API-first component (the reusable-components lesson's method
   applied early): write the typed signature and a one-line doc for every prop *before*
   implementing, implement it, then instantiate at three real call sites; count what the
   API got wrong (a prop nobody uses, a missing axis) and revise — keeping the before/after
   signatures.
   **Criteria:** signature-before-code evidence (file order); three call sites asserted;
   the revision list with line counts; one axis you deliberately refused to add and why.

## Set 3 — State and hooks → `state-and-hooks.md`

1. Predict the counter's value after three clicks when the updater is written as `c => c+1`
   vs `c = c + 1`-style mistake, then execute both in tests; also capture two clicks in one
   handler (batching).
   **Criteria:** four assertions (correct: 3 and 2; batched: +1 per tick); the updater-vs-
   direct-assignment rule; the batching result explained with the event-loop lesson's tick.
2. Reproduce the stale-closure bug: an interval reading a state variable inside `useEffect`
   with `[]` deps (captures the frozen value), fix it three ways (deps + cleanup, functional
   updater, `useRef` mirror); assert all three after 3 ticks.
   **Criteria:** failing transcript (frozen value quoted), three fixed variants with
   assertions, cleanup-vs-leak sentence (the `setInterval` cleared on unmount).
3. The derived-state audit: given a component computing `total` in `useEffect` + `useState`
   after every prop change, refactor to render-time derivation; assert identical output and
   one fewer render (render count via a spy).
   **Criteria:** before/after render counts; the "effects for derived data" rule cited from
   the README's blockers list; the case where an effect *is* correct named (syncing an
   external system).
4. **Independent:** the useFetch-shaped hook: `useCounter` or `useLocalStorage` written to
   the lessons' contract — input parity (same inputs → same behaviour), every effect with
   deps + cleanup, returns a tuple/array documented per index; tests covering mount,
   update, unmount-leak (spy on the external call), and two consumers not sharing state.
   **Criteria:** four test groups passing; the hook's API note (one line per returned
   slot); the leak test proving cleanup ran (assertion on the spy, not a log).

## Set 4 — Component composition → `component-composition.md`

1. Build the same screen three ways: (a) config-props (`Card title body footer`), (b)
   children slots, (c) a render-prop for the footer; assert identical rendered output for
   the default case, then add a fifth content region — count API changes per approach.
   **Criteria:** three versions asserted equal; the change table (props touched per
   approach); your pick with the reason tied to the count.
2. Lift state up: a two-sibling selection UI (list + detail) where selection lives in the
   nearest common parent; then move it to a shared parent two levels up; assert both
   layouts give identical interaction results (click → detail changes).
   **Criteria:** both structures tested; the lift rule stated (state goes to the lowest
   common ancestor of the readers); one sentence on when lifting crosses into
   state-management territory.
3. Composition vs inheritance escape hatch: a `Box` accepting `as` + className merge, used
   to build three visually identical wrappers; assert each renders the right element and
   merged classes.
   **Criteria:** three assertions; the K3-style pricing written (what type-safety you gave
   up — cite the reusable-components lesson); the alternative (three components) rejected
   or accepted explicitly.
4. **Independent:** the layout shell: `PageShell` composed from `Header`/`Sidebar`/
   `Content` slots where a consumer can replace *any* region without touching the shell,
   including the degenerate case (no sidebar); assert all four configurations render and
   the shell's landmark structure (`header`/`nav`/`main`) is unchanged across them.
   **Criteria:** four configurations asserted; landmark roles asserted by query (not
   markup); the slot-contract note (what the shell guarantees each region must provide).

## Set 5 — Routing → `routing.md`

1. With `MemoryRouter`, execute the back-button contract: navigate A → B, call `back()`,
   assert the rendered view is A and the URL is A's path; then push a *replace* navigation
   and prove history did not grow.
   **Criteria:** four assertions (view, path, view-after-back, path-after-back) plus the
   replace case; the push-vs-replace rule (replace for redirects).
2. Parameter boundary test: a route `items/:id` with ids `1`, `999`, `../../etc`, and an
   empty id; assert the valid renders, the unknown shows the not-found branch, and the
   traversal-shaped input stays *encoded and inert* (no fetch of a foreign path).
   **Criteria:** four cases asserted; the decode-once rule (where `decodeURIComponent`
   belongs) written; a sentence on why `to={userInput}` needs the same treatment.
3. Nested routes: layout route with two children and an `<Outlet/>`; assert the layout
   renders around both children and the active child link carries `aria-current="page"`.
   **Criteria:** layout-presence assertions for both children; the active-link assertion;
   one sentence on why the layout must not remount between children.
4. **Independent:** the guarded-route round trip: unauthenticated visit to `/app` redirects
   to `/login?next=%2Fapp`, successful login lands **exactly** on `/app` (assert path and
   the view), browser back from `/app` does *not* return to the now-useless login, and
   `next` with an external URL (`https://evil.example`) is rejected (stays on the app
   route or falls back home).
   **Criteria:** five assertions incl. the encoded `next` round trip; the open-redirect
   defense named (allow-list relative paths only); the back-button behaviour explained
   with the history model.

## Set 6 — Forms → `forms.md`

1. Controlled input round trip: type `ada`, assert the input's value, the state mirror, and
   the change-event payload; then set state externally (programmatic clear) and assert the
   DOM value follows.
   **Criteria:** four assertions; the one-directional data flow written (state → DOM, DOM →
   handler → state); a failing variant where the value is set without `onChange`.
2. Validation strategy comparison: one field with (a) native `required` + `type=email` and
   (b) scripted `checkValidity()` with your own messages; submit empty in both, assert the
   error surface of each (browser bubble vs your region) and record which you'd ship for a
   mobile-first form — with the reason.
   **Criteria:** two failing-submit transcripts; the chosen strategy with a reason citing
   a real constraint (styling control, message localization, or consistency); `novalidate`
   decision stated either way.
3. Submit lifecycle: async submit with three states (idle, saving, saved) plus failure;
   assert double-click during saving sends **one** request (spy count), the button is
   disabled + `aria-busy` while saving, and failure keeps the typed values (no clear-on-
   error).
   **Criteria:** four assertions incl. the spy count of 1; the idempotency sentence (why
   one request matters — backend lesson's view); error state keeping values demonstrated.
4. **Independent:** the form-driven wizard: three steps with per-step validation gating
   Next, review step summarizing (editing a field from review returns to that step),
   browser back restoring the *step* (not a broken partial), and state surviving a
   refresh *or* a documented choice not to persist; whole flow keyboard-only.
   **Criteria:** step-gating assertions (Next blocked on invalid), review-edit round trip,
   back-button transcript, persistence decision written; the keyboard transcript (no
   pointer, focus visible at each step — M3's floor from the accessibility lesson).

## Set 7 — State management → `state-management.md`

1. Map the honest cost: for four scenarios (sibling sharing, 4-levels deep, cross-route
   persist, frequently-changing), write which mechanism you'd pick from the lesson's
   ladder (local → lift → context → external) and *why*, then implement the first two and
   assert identical behaviour.
   **Criteria:** the four-choice table with reasons; two implementations asserted
   equivalent; one choice you'd defend differently in a team vs solo codebase.
2. Context done right vs done wrong: (a) a value-only context with stable identity
   (render-count assertion: consumers don't re-render when an unrelated sibling state
   changes), and (b) the same data in context state (consumers *do* re-render); capture
   both render counts.
   **Criteria:** two render counts with the delta; the "context distributes, it doesn't
   manage" rule; the split-context mitigation (value + actions separated) applied to (b)
   and re-measured.
3. External-store seam: implement a 20-line store with `getSnapshot` + `subscribe` and read
   it in a component via `useSyncExternalStore`; assert one component's update re-renders
   only its readers, and that returning a *new* snapshot object each call triggers the
   infinite-loop guard (capture the error).
   **Criteria:** reader-only re-render assertion; the loop-guard transcript (the
   identity-contract violation caught); the shim-less note (React 19 has the hook built in
   — no shim needed).
4. **Independent:** the derived-store refactor: a screen whose data lives in context but
   whose filtered view is recomputed on every provider render — refactor to memoized
   selectors; measure renders before/after on a 100-item list under filter typing; state
   the recompute cost you measured and the invalidation rule you chose (per keystroke vs
   per settle).
   **Criteria:** before/after render counts under simulated typing (10 events); the
   measurement behind the invalidation choice; one honest trade-off (stale-on-typing vs
   recompute cost).

## Set 8 — API integration → `api-integration.md`

1. The four-state hook: `useUsers` supporting loading → ready / empty / error with abort;
   script all four with fake timers/promises, assert each state's *rendered* surface (the
   error lesson's quartet), and assert a second call aborts the first (an aborted first
   must not overwrite the second — spy on setState ordering via rendered output).
   **Criteria:** four state assertions + the race assertion; the abort-cleanup line
   justified; no `any` in the hook's types.
2. Retry with backoff: implement `withRetry(fn, {retries: 2, base: 10})` over a fake that
   fails twice then succeeds; assert three calls, the delays (fake timers), and the
   final success — then make it fail permanently and assert it rejects with the *last*
   error (not the first).
   **Criteria:** call-count, delay, and error-identity assertions; the "last error"
   choice reasoned (the api lesson's cause-chaining); jitter optional but justified if
   present.
3. Cache/dedupe: two components mount the same resource simultaneously; assert **one**
   network call (spy) and both render the data; then mutate via a fake POST and assert the
   cache invalidates (refetch or update) rather than showing stale data.
   **Criteria:** the single-call assertion; the invalidation behaviour asserted; the
   staleness policy written (when may cached data be shown and how it's labelled).
4. **Independent:** the settings-page loader from the promises lesson, client-shaped:
   five endpoints, per-line failure policy (profile required, preferences optional, flags
   default off), 800 ms budget / 500 ms ceiling, ≤20 fetches under repeated re-entry
   (dedupe in flight); the race **executed** (slow response arrives after fast — stale
   never wins), and cancellation on unmount; every rejection observed.
   **Criteria:** harness executed for all-fail/mixed/slow/race with timings inside budget;
   the stale-never-wins transcript; unmount mid-flight showing no state write (or no-op
   guard) afterward; a rejection-observation audit (every promise creation has its
   handler); one named trade-off (what you cannot abort client-side).

## Set 9 — Frontend authentication → `frontend-authentication.md`

1. The storage trade-off, written: compare localStorage vs memory-only vs httpOnly cookie
   for *this* subject's assumptions; implement the memory + refresh flow (silent renewal on
   focus) and assert (a) no token under `localStorage`/`sessionStorage` after login (assert
   `Object.keys(localStorage)`), (b) refresh renews before expiry, (c) a 401 mid-session
   triggers the refresh-or-logout branch exactly once.
   **Criteria:** three assertion groups; the written trade-off naming your threat model
   (XSS vs CSRF, who wins); the key-count assertion as evidence.
2. Route guard round trip: protected route → login → return-to → logout; assert each hop's
   rendered view and URL, and assert that after logout the protected view is gone even via
   browser back (component unmounted, not just hidden).
   **Criteria:** five assertions incl. the back-after-logout case; the guard's placement
   (where it lives in the tree and why); one sentence on client guards being UX, not
   security (the server must enforce).
3. Token-refresh race: trigger three parallel requests through a 401 while refresh is in
   flight; assert exactly **one** refresh call (spy) and all three requests retry once
   after it resolves; then a *failing* refresh: all three reject and the session clears.
   **Criteria:** the one-refresh assertion (the refresh-singleton pattern); the failure
   branch asserting session state; the sequencing written (queue vs in-flight flag).
4. **Independent:** the auth boundary audit for a real app of yours: list every client
   surface that receives the session (store, context, fetch wrapper, router, logout) with
   its leak class (storage, log, URL, error message, tab), the control you'd apply to
   each, and the two you cannot solve client-side (name the server-side counterpart);
   implement one control — prefer the refresh-race fix or the URL-token scrub — with
   tests.
   **Criteria:** the audit table (≥8 surfaces, each with control); one implemented control
   with before/after assertions; the two client-impossible items named with their server
   counterparts (echoing the lesson's "tokens belong server-side" limit).

## Set 10 — Error/loading states · reusable components · design systems →
`error-and-loading-states.md` · `reusable-components.md` · `design-systems.md`

1. The six-state matrix: extend the four-state union with `unauthorized` and `offline`;
   render all six distinctly (assertions per state, live-region roles per the J6/M6
   classes) and write the one-word product rule for each (guidance / recovery /
   escalation).
   **Criteria:** six assertions with roles; the union + exhaustive `never` check compiling;
   six rule sentences.
2. Boundary pair: execute crash-without-boundary (tree unmounts — assert the empty
   container) and crash-with-boundary (caught, logged with component stack, `reset`
   recovers after the throw condition clears); then place the boundary at widget level and
   assert a sibling kept its state through the crash.
   **Criteria:** both transcripts (blank vs recovered); the sibling-survival assertion;
   your placement rule written with the blast-radius rationale.
3. The three-call-site extraction: three real buttons from your code, the diff (identical /
   variant axis / content / node-needs buckets), `Button` extracted with closed tone+size
   enums, `loading` (injects `aria-hidden` spinner, sets `aria-busy`) and className merge;
   assert all three call sites render with merged classes and the tsc misuse line errors.
   **Criteria:** the diff table with rejected candidates named; four assertions (3 call
   sites + merge position); the captured `tsc` diagnostic for a bad enum value.
4. **Independent:** the token-gate component pair: (a) `Skeleton`/`EmptyState`/`ErrorState`
   built from the error lesson's contract with *semantic* token consumption only (assert
   computed custom properties resolve in jsdom — the K6 read), (b) a light/dark/high-
   contrast switch where the same components re-theme with **zero component edits**
   (capture each theme's resolved `--color-action`), and (c) a guard test that fails when
   component CSS references a primitive (`--blue-600`) directly — break it once, capture
   the failure.
   **Criteria:** computed-token reads for three themes; zero-edit claim demonstrated
   (component source unchanged between runs); the guard test passing and failing on
   demand; the role-name test applied to every token you added.

## Set 11 — Performance · accessibility → `performance.md` · `accessibility.md`

1. The render-count battery: baseline renders under (a) separate updates, (b) batched
   updates in one handler (the automatic-batching count), (c) unrelated sibling state;
   then the `useMemo` dep receipts (1 → 1 → 2) and the stable-prop memo skip — all as
   assertions, not logs.
   **Criteria:** six counts asserted with expected numbers; the batching number explained
   (ticks vs setState calls); the memo skip justified only for a *hot* child (name your
   hot child or decline the memo).
2. The identity break: a keyed stateful list switched to index keys, insert at the top,
   capture state/focus landing on the wrong row; then restore id keys and prove correct
   attachment through two inserts and a reorder.
   **Criteria:** the wrong-attach transcript (index keys); three correct-attachment
   assertions (id keys); the index-key safe-case sentence (static lists) and where you
   lint-ban them.
3. The keyboard contract, broken on purpose: take an interactive component of yours and
   capture (a) role+name queries finding every control, (b) a `div`+onClick variant failing
   Enter without the manual handler, (c) the labelled-vs-placeholder name computation, and
   (d) an overlay executing move-in / trap / return — each with the failing or passing
   transcript.
   **Criteria:** four captures: role queries green, div-variant red on Enter, placeholder
   name absent (query fails), overlay three-step asserted; each mapped to M1–M4.
4. **Independent:** one screen, measured end to end: Profiler counts + long-task timing for
   its slowest interaction, the diagnosed bottleneck (renders vs network vs layout — with
   evidence), the narrowest fix applied with a written prediction, re-measured identically,
   and the regression guard (render-count or threshold test) committed and demonstrated
   failing when the regression is re-introduced; plus the keyboard-only walk of the same
   screen before/after with axe triage.
   **Criteria:** before/after numbers on a throttled profile; the prediction checked
   (including a miss, if any — reported); the guard failing on demand; keyboard walk
   transcript with zero traps and every control named (role+name); axe findings triaged
   with the human-pass items listed as unverified (jsdom limits stated).

## Set 12 — Frontend testing · build and deployment →
`frontend-testing.md` · `build-and-deployment.md`

1. The deliberate-break drill: the N-cluster suite (query resilience, userEvent typing,
   findBy wait, module-mock contract, error→retry flow, keyboard submit) reproduced in
   your lab, then three breaks — delete the retry update, rename a queried class, hang the
   loader — each with the failing test quoted.
   **Criteria:** six green baselines; three breaks with exact failure messages; one
   paragraph separating test-bug red from product-bug red.
2. The query-ladder conversion: five coupled tests of yours (class/structure queries)
   rewritten on the ladder, executed against a deliberately changed DOM — old red, new
   green; plus your written `data-testid` legitimacy rule.
   **Criteria:** five conversions with before/after transcripts; the rule citing N1's
   result; no remaining structure queries in the five (grep evidence).
3. The build contract, executed: `vite build` on a mini app with `VITE_API_URL` +
   unprefixed token; assert the four facts (inlined var present, token absent from dist,
   `process.env.NODE_ENV` count 0, split chunk emitted), then break the prefix
   (rename `VITE_` away) and capture the inlining change.
   **Criteria:** four executed checks (greps/asserts against `dist/`); the broken-prefix
   transcript; the one-line policy for what may carry the `VITE_` prefix.
4. **Independent:** the pipeline: a gate script (types → tests → build → secret scan →
   gzip budget) with five *demonstrated* failure modes (break each gate, quote its message
   and exit code), the artifact deployed to real static hosting with `curl -I` evidence
   for both TTLs (immutable assets, revalidated HTML), a deployed-body secret scan, and a
   rollback drill with timing.
   **Criteria:** five gate failures captured; hosting URL with header evidence for both
   TTLs; deployed secret scan empty; rollback transcript with elapsed time; two "what
   still slips through" classes named (the honest limits paragraph).

---

## Answer key

Solutions: [solutions/](solutions/README.md).

**⚠ Attempt the sets first.** Reading a solution gives recognition, not skill. If you peeked,
redo the affected exercise one week later without looking — that second attempt is the one
you keep.
