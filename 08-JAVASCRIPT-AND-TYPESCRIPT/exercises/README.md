# Exercises — 08 JavaScript and TypeScript

**Lessons:** this subject's twelve lessons, in order.
**How to use these sets:** attempt first; solutions live in
[solutions/](solutions/README.md) behind a warning. The 15-minute rule from
[learning-method](../../00-START-HERE/learning-method.md) applies — record which hint you used.

Each set corresponds to the lesson named in its title and mirrors that lesson's exercise ladder
(introductory → intermediate → independent) with observable completion criteria. Completing all
twelve sets *is* this subject's half of the milestone gate in
[ROADMAP.md](../../ROADMAP.md).

Sets 1–8 are runnable in plain Node; sets 9–12 add `tsc` (`npm i -D typescript`; the lessons
were executed with tsc 7.0.2), and set 4's widget work runs in a browser console or a local
page. **Predict before you run** — every set below that says "predict" means paper first: a
prediction you did not write down is not a prediction. Every transcript quoted in the lessons
was executed on the authoring machine (Windows 11, Node 24.13.1, tsc 7.0.2, Chrome 156), so
where your versions differ, the *behaviour* is the criterion and the exact text is yours to
capture. Policy matches [VERSIONS.md](../../VERSIONS.md): your transcripts are your evidence.

---

## Set 1 — JavaScript fundamentals → `javascript-fundamentals.md`

1. Predict, then run each with `node -e`: `typeof []`, `typeof NaN`, `'5' - 1`, `'5' + 1`,
   `1 + 2 + '3'`, `null ?? 0`, `null || 0`, `0 ?? 'x'`, `[3, 1, 2].sort()`.
   **Criteria:** nine predictions written before running; every mismatch explained with the coercion rule (left-to-right `+`, loose numeric conversion, nullish-vs-falsy).
2. Write the TDZ experiment: log a `let` *before* its declaration inside `try`, repeat with `typeof` on the same TDZ variable, then `typeof` a never-declared name; capture all three.
   **Criteria:** the `ReferenceError` quoted for both TDZ reads (direct and `typeof`); the never-declared `typeof` returning `undefined`; one sentence contrasting "undeclared" with "declared but not yet".
3. Build `parseQuery("?a=1&b=&c")` → named object with destructuring, `??`, template literals: numbers where numeric, empty strings preserved; prove `?port=0` returns `0`.
   **Criteria:** `0` returned, not the default; no `if` chains; three test calls with expected output.
4. **Independent:** the `NaN`-totals fix: given `items.reduce((acc, i) => acc + i.price, 0)` over items missing `price`, write three distinct fixes (read-time `??`, filter-first, boundary validation with a throw) and say what each *hides* vs catches.
   **Criteria:** three working fixes with executed evidence; trade-off column written; the recommended boundary version includes a failing-loud case.

## Set 2 — Functions and scope → `functions-and-scope.md`

1. Predict and execute five closures over a loop variable (`var`, `let`, factory-per-iteration, `bind`, `while` + `let`); print all five result arrays.
   **Criteria:** ≥4 of 5 predictions match; the `while`-with-`let` case explained via per-iteration binding.
2. Reproduce both executed `this` failures (detached method, arrow-as-method) with exact messages, then fix each (`bind`; shorthand method).
   **Criteria:** four transcripts (2 broken, 2 fixed); fixes cite call-site `this` vs lexical `this`.
3. Implement `once(fn)` via closure (`done` flag + result slot): runs exactly once under ten calls, later calls return the first result.
   **Criteria:** counter proves one invocation; memoized value returned afterwards; one sentence on what the closure keeps alive.
4. **Independent:** the private analytics module: expose `track(event)` with a 100-event cap (evicting oldest) and `flush()` that returns and clears — closures only, no exposed array.
   **Criteria:** executed transcript past 100 events proving cap and flush; external access to the list demonstrated to fail; two-line justification of closure-vs-class-fields privacy.

## Set 3 — Arrays and objects → `arrays-and-objects.md`

1. Predict then execute the aliasing/copy probes: `const b = arr; b.push(4)` / `[...arr]` push / `arr.slice()` pop / `arr.toSorted(desc)` — what is each array afterward?
   **Criteria:** four predictions matching execution; mutator-vs-pure classification for every method used.
2. Reproduce both executed freeze crashes (`hard.n = 5`, `frozenArr.push(2)`) in `try`/`catch` in an `.mjs` file; print constructor names and messages; show the data unchanged.
   **Criteria:** two `TypeError` transcripts verbatim; `JSON.stringify` proving state survived; one sentence on why sloppy mode hides both.
3. Write `withRow(id, fn)` returning a new `db` with the matching row updated, unchanged rows reference-equal, and the no-match case returning the original reference.
   **Criteria:** original untouched (executed check); `===` identity checks shown; no-row fast path returns the same `rows`.
4. **Independent:** the immutable dashboard index: `getById`, `byCategory` (built-once index cache), `withTag` (immutable add) where callers can never mutate internals.
   **Criteria:** executed transcript showing external mutation attempts fail or change nothing; caches correct after `withTag`; freeze placement justified against shallow/strict semantics.

## Set 4 — DOM and events → `dom-and-events.md`

1. Reproduce the executed propagation trail with four listeners (capture on `document`, bubble on `body`, button, sibling); click; record the order; then move the button into the list and record again.
   **Criteria:** two trails captured; the difference explained by ancestry; the capture flag's effect shown by toggling it.
2. Demonstrate listener identity: same named function registered twice (fires once), inline arrow twice (fires twice), then `removeEventListener` the named one and show silence.
   **Criteria:** three states executed; the identity rule (type, callback, capture) stated; one sentence on recreated arrows leaking in re-rendering UIs.
3. Build the todo widget and add double-click inline editing (Enter commits via `textContent`, Escape cancels) through the **one** delegated listener.
   **Criteria:** add/edit/complete/delete work on items created before and after load; total `addEventListener` calls counted and ≤3; user input never touches `innerHTML`.
4. **Independent:** the focus-trapping modal: Tab cycles inside, Escape/backdrop close, focus restores to the opener, and 100 open/close cycles do not grow the listener count (e.g. `AbortController` teardown).
   **Criteria:** ×100 cycle executed with stable listener count; Tab-cycle and focus-restore verified with real key events; every `preventDefault`/`stopPropagation` site justified including one deliberately omitted; keyboard contract cross-referenced to 07's accessibility pass.

## Set 5 — Modules → `modules.md`

1. Recreate the executed graph (`math`/`shapes`/`main`): capture the namespace-keys line, the privacy `ReferenceError`, and the missing-export `SyntaxError` in three runs; then demote `export const internal` to plain `const` and show the keys shrink.
   **Criteria:** three transcripts; before/after key lists; one sentence on what `export` changes about the namespace object.
2. Prove side-effect-once semantics with a `log.mjs` imported through three files from one entry; then import it from a second entry in a separate `node` run.
   **Criteria:** both runs captured; once-per-process (registry) distinction stated, with why it makes singletons work.
3. Reproduce both executed cycle crashes (top-level read; function called during evaluation), then repair *each* two ways: defer reads into functions, and extract a shared third module.
   **Criteria:** two crashes with exact messages; four working variants loading cleanly; a one-line rule for when extraction beats deferral.
4. **Independent:** the task-tracker module layout (state, rendering, events, storage): no possible circular imports, storage failures caught at use rather than at load, every file ≤4 exports, and a lazy stats view with an obvious dynamic-`import()` seam.
   **Criteria:** executed skeleton loading in Node with the dependency-arrow list; export lists justified; one honest trade-off on eager vs dynamic loading with the failure-timing argument.

## Set 6 — Promises and async/await → `promises-and-async-await.md`

1. Predict, then execute an ordering sequence mixing `await Promise.resolve(1)`, a `.then`, and `setTimeout(…, 0)`; diff prediction against output.
   **Criteria:** prediction captured first; every mismatch explained by microtasks vs timers (event-loop lesson confirms).
2. Reproduce the executed unhandled-rejection crash (reject in 20 ms, no handler, slower await first); then fix three ways: immediate `.catch`, same-tick `await`, and `process.on("unhandledRejection")`.
   **Criteria:** crash transcript verbatim; three fixes; the third labelled a *monitor*, not a fix.
3. Instrument serial vs `Promise.all` vs batches-of-two over five 50 ms tasks with `performance.now()`; audit one of your own projects for wrongly serial calls.
   **Criteria:** three totals matching the expected shape (sum ≈ serial, ≈ slowest parallel, between for batches); audit list written; causality justification for anything kept serial.
4. **Independent:** the settings loader — profile (page fails), preferences (defaults fine), three flags (each defaults off), 800 ms budget, 500 ms per-endpoint ceiling, ≤20 fetches with dedupe; pick combinators per line from the executed behaviours.
   **Criteria:** fake-endpoint harness executed for all-fail/mixed/slow with totals in budget; every combinator cited to an executed transcript; a rejection-observation audit showing a handler for every promise created; one named trade-off (`race` cannot abort real work without `AbortController`).

## Set 7 — Event loop → `event-loop.md`

1. Predict-then-run five mixed snippets (sync/then/timeout/queueMicrotask; an `await` chain; nested `.then`; `setTimeout` inside a `then`; a microtask registered from a timer); write the full expected order first.
   **Criteria:** five predictions + five executions; each mismatch explained with queue name, registration order, and chain hops — no "JS is weird".
2. Reproduce the probe's interleaved trace, then modify it three ways (direct `.then` instead of `queueMicrotask`; a `then` inside a `setTimeout`; an `await` between two timer registrations) — four traces total.
   **Criteria:** four traces captured; the extra-hop rule confirmed; the "timer callbacks are macrotasks, their `.then`s follow as microtasks" rule shown.
3. Build a *bounded* starvation demonstrator: microtask chain yielding after N=1000 hops with a timer registered first; capture the timer running after the chain; scale N and tabulate the timer's delay.
   **Criteria:** timer-after-chain transcript; delay-vs-N table with 3 values; the unbounded version stated explicitly as a counterfactual, never executed without a guard.
4. **Independent:** the frozen-dashboard diagnosis: draw a one-second timeline for four recurring jobs plus clicks from the queue model, name each callback's queue, give two freeze causes distinguished by a runnable observation, and name the production metric with a threshold.
   **Criteria:** timeline with queue names per entry; ≥1 executed verification trace; both causes distinguished by runnable evidence; fixes matched to causes; production metric named with a numeric threshold justified from your own timings.

## Set 8 — Error handling → `error-handling.md`

1. Reproduce the four executed `finally` probes: order of `try/catch/finally/after`; `finally` without return; `finally` with return overriding; `finally` returning while `try` throws.
   **Criteria:** four transcripts; (d) showing no exception escapes; the complete "what `finally` can override" list in one sentence.
2. Build a two-level hierarchy (`DomainError` → `PaymentError`) with `code`s, throw from depth, dispatch at three nesting levels; then delete the `this.name = …` assignments and capture what `e.name` reports.
   **Criteria:** dispatch transcripts at each level; the inherited-name pitfall captured with its fix; one sentence per class on why it exists ("class per handling difference").
3. The wrapping audit: rethrow three errors wrapped *without* `cause` (capture `cause: undefined`), fix with `cause`, then aggregate two under `AggregateError` and iterate `.errors`.
   **Criteria:** before/after transcripts; both roots listed from the aggregate; a one-line policy for wrap-vs-rethrow.
4. **Independent:** the payments error taxonomy: expected vs unexpected classes (including timeout-unknown-outcome), per-layer actions (translate+`cause`/retry/rethrow), the terminal catch's location, log-vs-response contents, and idempotency keys for unknown outcomes.
   **Criteria:** taxonomy table with no class lacking a branch; boundary map naming every async entry's terminal handler; unknown-outcome strategy stated as retry *semantics*; four cited executed transcripts quoted correctly; one honest trade-off (return-values vs exceptions at a chosen boundary).

## Set 9 — TypeScript fundamentals → `typescript-fundamentals.md`

1. Reproduce the executed `errors.ts` pair (two `TS2322`s, exit 1), fix both with explicit conversions, then emit with `--outDir` and run the JS.
   **Criteria:** failing and passing runs with exit codes; emitted JS inspected for absence of annotations; one sentence on erasure.
2. Inference ladder: predict tsc's type for six bindings (`let a = 42`, `const b = 42`, `let c = "x"`, `const d = ["a"]`, `let e = [1, "x"]`, `const f = { mode: "dark" }`), verify with commented misuse assignments.
   **Criteria:** six predicted vs actual types; ≥4 misuse diagnostics; the `let`-vs-`const`-vs-`as const` widening rule in one line.
3. The strict bundle audit: run the same implicit-`any` file with `"strict": true` and `"strict": false` in a tsconfig; witness which errors disappear when strictness is off — and record the tsc 7.0.2 seam that a *bare* CLI run with no tsconfig already enforces `noImplicitAny`.
   **Criteria:** both outputs captured with the config each came from; `noImplicitAny` and `strictNullChecks` named as the responsible flags; a one-paragraph defense of strict mode using your two outputs.
4. **Independent:** the 2,000-line adoption plan: a committed tsconfig with per-flag rationale, entry strategy (JSDoc `checkJs` first or not), the three boundary surfaces annotated first, the CI `tsc --noEmit` gate, and an error-count ratchet with exact snapshot/diff commands.
   **Criteria:** tsconfig with rationale tied to executed evidence; phased plan with commands; boundary policy ranked; the two erasure doors (JSON/network, `any`-typed deps) named with mitigations; one honest velocity-vs-defect trade-off with team size stated.

## Set 10 — Types and interfaces → `types-and-interfaces.md`

1. Reproduce the executed four-behavior matrix in four separate runs: `Admin→User` pass, `User→Admin` fail, fresh-literal-with-extra fail (`TS2353`), pre-built-variable-with-extra pass.
   **Criteria:** four exit codes 0/1/0/1; each explained using only "members" and "freshness"; the error column numbers interpreted.
2. Model your own data three ways: `interface` hierarchy, `type` with `&`, and a `role`-tagged discriminated union; compile all three and choose with reasons.
   **Criteria:** three compiling versions; a written choice citing ≥2 rows of the lesson's table; one sentence naming the version you'd delete.
3. Extend the executed `Shape` union to three members, introduce a wrong-field use per branch (captured diagnostics), then add a `switch` with one missing case and record the `default` branch's inferred type.
   **Criteria:** three diagnostics with locations; the `default` type recorded as union-minus-matched-arms; one sentence connecting "what's left" to `never`.
4. **Independent:** the drag-and-drop editor type layer: text/image/frame nodes, a selection state where "many" must be same-type, an undo/redo history that cannot hold illegal snapshots, and an `unknown` load path whose corrupt-file errors name the offending path.
   **Criteria:** compiling `--strict` skeleton with ≥3 discriminated unions; ≥3 executed rejection cases each naming a path; a declaration-rationale table citing specific executed lines; one honest cost statement for the type layer.

## Set 11 — Generics → `generics.md`

1. Predict then check five calls (`first([1,2,3])`, `first(["a"])`, `first<number>(["a"])`, `mapValues({n:1}, x => x+1)`, `mapValues({n:1}, x => x.toUpperCase())`); execute under `--strict`.
   **Criteria:** five predictions vs actuals; the fourth error explained as *relationship* checking; expected errors documented on commented lines with codes.
2. Build `pair<T>(a: T, b: T)` vs `pairOf<A, B>(a: A, b: B)`; show where one parameter correctly forces sameness (`pair(1, "x")` errors) and where two allow it.
   **Criteria:** both error/pass transcripts; one paragraph on "same type both places" being the intent of one parameter.
3. Genericize a real utility of yours (`groupBy`, `chunk`, `uniqBy`) with minimum parameters; execute against two element types; then pass a mismatching callback and capture the diagnostic.
   **Criteria:** one implementation type-checking for both types; the mismatch diagnostic captured at the relationship break; a note on call-site annotations (expect: none).
4. **Independent:** the typed event bus: `on<E extends AppEvents>` / `emit` where wrong payloads and bogus names are compile errors, handler failures return `Result<T, E>`, config-supplied names have an erasure-aware runtime failure story, and a payload-transforming helper preserves the map's shape.
   **Criteria:** file compiles clean with all misuse lines documented and codes verified by uncommenting; runtime demo of on/emit round-trip plus a failure through `Result`; config-string door handled by an explicit runtime check; a type-parameter declaration table; one honest trade-off (mapped types vs overloads).

## Set 12 — Type narrowing → `type-narrowing.md`

1. Predict then check four lines in separate `--strict` files: `x.toUpperCase()` unnarrowed on `string | number`, the same after `typeof x === "string"`, `v.a` on `unknown`, and `v.a` inside an `in` guard.
   **Criteria:** four predictions vs actuals; `TS2339`/`TS18046` explained as "no proof yet"; guarded pair exits 0 with the narrowed types written down.
2. Reproduce all four executed failures verbatim (`bad-union`, `bad-unknown`, `bad-closure`, `bad-exhaustive`), capture each exit code, then fix each without `as any` and re-run to exit 0.
   **Criteria:** four failing transcripts with codes; four fixed versions compiling; the closure fix identified as "copy to `const` after narrowing", not "annotate".
3. Write `parseConfig(raw: string): Config | null` with three differently-typed fields; feed it eight inputs (malformed JSON, wrong types, missing fields, one valid) and capture which return `null`.
   **Criteria:** all eight outcomes captured; every rejection traced to a guard line; no `as` on untrusted data except the single documented `Record` shape claim.
4. **Independent:** the chat-event pipeline: discriminated union for `msg`/`typing`/`edit` plus unknown future types, an `unknown`-in `parseEvent` that rejects unknown types *loudly* with a logged category, an exhaustive `reduce` with `assertNever`, and a rendering switch — self-tested with malformed payloads, a missing `case` (captured `TS2345`), and a lying predicate (captured crash).
   **Criteria:** compiles clean with every misuse line documented and codes verified one at a time; runtime demo parsing → reducing → rendering five events; unknown types logged and rejected (never silently dropped); a table mapping each guard to the member it proves; one honest trade-off (per-field guards vs schema validator at 3 vs 30 fields).

---

## Answer key

Solutions: [solutions/](solutions/README.md).

**⚠ Attempt the sets first.** Reading a solution gives recognition, not skill. If you peeked, redo
the affected exercise one week later without looking — that second attempt is the one you keep.
