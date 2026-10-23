# Solutions — Set 5: Modules

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.

## Exercise 1 — Namespace keys, privacy, and the missing export

**Reference transcript (authoring machine, Node 24.13.1):**

```console
namespace import keys: PI, add, default, internal
internal IS exported (it uses export const): not part of the public API
module-private minus is invisible: ReferenceError
```

```console
file:///…/g-mod/bad.mjs:1
import { nonexistent } from "./math.mjs";
         ^^^^^^^^^^^
SyntaxError: The requested module './math.mjs' does not provide an export named 'nonexistent'
```

- The `Object.keys(namespace)` line is the physical answer: `export const internal` puts
  `internal` **on the module namespace object** (keys: `PI, add, default, internal`) — while
  a plain `const minus` lives only in the module's scope, so touching it from outside throws
  `ReferenceError` (its name simply does not exist in the importer's resolution).
- Demoting `internal` from `export const` to `const` shrinks the key list by exactly one —
  `export` does not *wrap* a value, it **publishes a binding** on the namespace.
- The missing-import crash is a **link-time `SyntaxError`**: Node resolves all names while
  instantiating the graph, *before any code runs* — which is why fail-at-load is the right
  behavior for a broken interface (see exercise 4 of the lesson: wrong imports should never
  half-run).
- **Criteria check:** ☐ three transcripts ☐ before/after key lists ☐ one sentence on what
  `export` changes.

## Exercise 2 — Side effects run once per process

**Reference transcript (authoring machine):**

```console
$ node run1.mjs          # run1 → entry1 → log.mjs (three-file chain)
log.mjs evaluated, count = 1
e1 imports x: shared

$ node entry2.mjs        # fresh process, second entry
log.mjs evaluated, count = 1
e2 imports x: shared
```

- The module registry is **per `node` process**: the first evaluation in a process wins, and
  every later import in that process gets the recorded namespace. The single line in run 1
  — despite `log.mjs` being reachable through three files — is the proof.
- Run 2 shows the boundary: a *new* process has a *new* registry, so it evaluated again and
  printed its own line. "Once" means **once per process**, not once forever — that is exactly
  what makes module-level singletons (`const db = connect()`) work, and exactly what makes
  them *not* survive a restart.
- **Criteria check:** ☐ both runs captured ☐ once-per-process/registry distinction stated with
  the singleton consequence.

## Exercise 3 — Both cycle crashes, repaired two ways each

**Reference transcript (authoring machine):**

```console
# healthy deferred cycle (reads inside functions):
b-mod evaluated, bValue = B (aValue NOT read at eval time)
a-mod evaluated, aValue = A
circular pair loaded without deadlock
showB(): B | showA(): A

# crashing cycle (top-level read during evaluation):
b2 evaluated early -> ReferenceError - Cannot access 'window2' before initialization
a2: calling earlyFn from b2
a2 hit: ReferenceError - Cannot access 'window2' before initialization
circ2 done
```

- The failing shape: `a2` imports `b2`, `b2` reads `window2` (declared in `a2`) **while `a2`
  has not finished evaluating** — the binding is in its TDZ, so the read throws the same
  `ReferenceError` class as set 2, now triggered by import order instead of line order.
- **Fix (a) — defer the reads:** move top-level reads *into functions* (`showB()` returns it),
  as the first transcript did: both modules evaluate, the cycle loads, and the values resolve
  on call. Correct when each side only needs the other's value *at use time*.
- **Fix (b) — extract a shared third module:** move the shared binding into `common.mjs`
  imported by both — no cycle exists at all, so evaluation order stops mattering. Clearly
  better when the cycle was accidental (both files just needed one constant): deferral leaves
  a landmine for the next top-level read, extraction removes the graph edge.
- **Criteria check:** ☐ two crashes with exact messages ☐ four working variants ☐ one-line
  rule for choosing (b).

## Exercise 4 — Script tags → modules (intermediate)

**Reference shape:**

- The implicit-dependency list comes first: with three `<script>` tags, file B *used* file A's
  globals by mere load-order — `formatDate`, a `CONFIG` object, a `state` variable. Each
  becomes an explicit `import { formatDate } from "./a.js"` — the browser now fetches a graph
  and guarantees ordering, so `defer`-placement hacks disappear.
- Run in Node (`.mjs`) **and** in the browser with `<script type="module">` (modules are
  deferred and strict by default — two behavior changes worth naming).
- Privacy proof: a function that previously lived on `window` and was reachable from any
  console is now module-scoped; calling it without importing throws
  `ReferenceError: formatDate is not defined` — the same mechanism as exercise 1's invisible
  `minus`.
- **Criteria check:** ☐ dependency list written before conversion ☐ all three files load in
  both environments ☐ un-imported access demonstrated to throw.

## Exercise 5 — Task-tracker module layout (independent)

**Reference shape:**

```
state.mjs   → (no imports)            exports: getState, subscribe, dispatch   [4]
render.mjs  → state.mjs               exports: render, renderStats             [2]
events.mjs  → state.mjs, render.mjs   exports: attach, detach                  [2]
storage.mjs → (no imports)            exports: load, save                      [2]
main.mjs    → all four                exports: start                          [1]
```

- **No cycles possible** because every arrow points "down" toward `state`, and `state` imports
  nothing; justify each direction: render *reads* state, events *writes* state then asks
  render to update, nobody imports `main`. Cycle-check by the exercise's trick: removing any
  arrow leaves a loadable graph — no arrow existed *to* complete a cycle.
- **Storage failures at use:** `load()`/`save()` are `try`-wrapped *calls* returning
  `{ok, data|error}` — contrast with the executed `SyntaxError` of exercise 1: a broken
  *import* should fail at load (the interface itself is wrong), a broken *runtime dependency*
  (quota exceeded, corrupt JSON) must fail when used, because the app can still render with
  defaults. Failure-timing argument in one line: **load-failure is right for programmer errors,
  use-failure is right for environmental ones.**
- **Dynamic seam:** `renderStats` stays out of `main`'s static imports; a button handler does
  `const { renderStats } = await import("./render.mjs")` — lazy code splits itself.
- **Trade-off:** dynamic imports cost a round-trip and complicate error handling at first
  load; in exchange they keep startup cost proportional to what the user actually opens.
- **Criteria check:** ☐ executed skeleton loading in Node with the arrow list ☐ export lists
  (all ≤4) justified ☐ eager-vs-dynamic trade-off written.

---

Next: [set-6-solutions.md](set-6-solutions.md)
