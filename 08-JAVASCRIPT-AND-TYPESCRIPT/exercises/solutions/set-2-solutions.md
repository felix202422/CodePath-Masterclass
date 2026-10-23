# Solutions — Set 2: Functions and Scope

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.

## Exercise 1 — Five closures over a loop variable

**Reference transcript (authoring machine, Node 24.13.1):**

```console
var: 3,3,3
let: 0,1,2
factory: 0,1,2
bind: hi B0,hi B1,hi B2
while+let: 0,1,2
```

- `var` → `3,3,3`: `var i` is *one* binding shared by the whole function scope; every closure
  reads the same slot, which held `3` by the time the array was read.
- `let` → `0,1,2`: `for (let …)` creates a **fresh binding per iteration**, and each closure
  captures the iteration it was created in.
- Factory → `0,1,2`: the per-iteration copy is done *by hand* — an IIFE parameter snapshots
  `k` at creation (`((n) => () => n)(k)`). This is the pre-`let` idiom and the reason the
  pattern appears in old codebases.
- `bind` → `hi B0,hi B1,hi B2`: `person.greet.bind({ name: "B" + m })` returns a *new function*
  with `this` fixed to a fresh object per iteration — snapshot by argument, not by scope.
- `while` + `let` → `0,1,2`: there is no per-iteration rule for `while`, so the snapshot must
  come from a `let cur = w` **inside the block** — the block scope is what the closure sees.
- **Criteria check:** ☐ ≥4 of 5 predictions match ☐ `while` case explained by block-scoped
  snapshot rather than "loops are weird".

## Exercise 2 — Both executed `this` failures, then fixed

**Reference transcript (authoring machine):**

```console
detached: TypeError: Cannot read properties of undefined (reading 'name')
arrow-as-method: hi undefined
fixed bind: hi Cy
```

- **Detached method:** `const detached = person.greet; detached()` calls the function with
  *no* receiver, so `this` is `undefined` (module code is strict) — reading `.name` throws.
  Fix: `person.greet.bind({ name: "Cy" })()` → `hi Cy`; `bind` returns a wrapper with the
  receiver pre-set, so the call site no longer decides.
- **Arrow-as-method:** the arrow captured `this` *lexically* at definition — in a module that
  is the module namespace, so `this?.name` is `undefined` and it printed `hi undefined`
  without throwing. Fix: a shorthand method (`greet() { … }`) gets *dynamic* `this` from the
  call site — call-site `this` vs lexical `this` is exactly the distinction.
- **Criteria check:** ☐ four transcripts (2 broken, 2 fixed) ☐ fixes cite call-site vs lexical
  `this`.

## Exercise 3 — `once(fn)`

**Reference transcript (authoring machine):**

```console
calls: 1 results: [0,0,0,0,0,0,0,0,0,0]
```

```js
const once = (fn) => {
  let done = false, result;
  return (...a) => {
    if (!done) { done = true; result = fn(...a); }
    return result;
  };
};
```

- Ten calls, **one** invocation, and every call returned the *same* memoized value — note the
  results array: call 9 returned call 0's result, not a re-computation.
- What the closure keeps alive: `done` and `result` live in the wrapper's scope, so they
  survive between calls — correct here because "ran exactly once" *is* module-level state the
  caller must not manage. This is the same mechanism as the executed analytics module below.
- **Criteria check:** ☐ counter proves one invocation under ten calls ☐ later calls return
  the memoized value ☐ one sentence on the captured state.

## Exercise 4 — The private analytics module (independent)

**Reference transcript (authoring machine):**

```console
size after 103: 100 oldest kept: e3
after flush: 0 | external access: undefined
```

```js
const analytics = (() => {
  const events = [];                       // private: no property exposes it
  return {
    track: (e) => { events.push(e); if (events.length > 100) events.shift(); },
    flush: () => events.splice(0),         // returns AND clears
    size: () => events.length,
  };
})();
```

- 103 tracked → **100 kept, oldest `e3`**: the cap evicts from the front (`shift`), so the
  newest 100 survive; `flush()` returned them all and left `size` at `0` — the
  return-and-clear contract in one line (`splice(0)` returns the removed elements).
- Privacy proof: `typeof analytics.events` → `undefined` — the array is a closure binding of
  the IIFE, not a property, so external code has no handle to mutate or leak it.
- Why closure rather than class fields: a `class` field would be `this.events` — reachable
  from any method *and* from any code holding the instance (`instance.events.push(…)` works).
  The closure is unreachable by construction; two-line justification as required.
- **Criteria check:** ☐ transcript past 100 events showing cap + flush ☐ external access
  demonstrated to fail ☐ closure-vs-class-fields justification.

---

Next: [set-3-solutions.md](set-3-solutions.md)
