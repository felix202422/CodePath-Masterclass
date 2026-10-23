# Solutions — Set 12: Type Narrowing

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.
> All transcripts re-executed on the authoring machine: tsc 7.0.2 (`--strict --noEmit`) and
> Node 24.13.1.

## Exercise 1 — Four guard predictions, four separate files

**Reference transcript (authoring machine):**

```console
# (1) x.toUpperCase() on string | number, no guard
ts/bad-union.ts(3,12): error TS2339: Property 'toUpperCase' does not exist on type 'string | number'.
  Property 'toUpperCase' does not exist on type 'number'.
EXIT=1

# (2) the same line after `if (typeof x === "string")` — part of narrow.ts
EXIT=0

# (3) v.a on unknown
ts/bad-unknown.ts(3,13): error TS18046: 'v' is of type 'unknown'.
EXIT=1

# (4) v.a inside typeof-object + !== null + "a" in v — part of narrow.ts
EXIT=0
```

- Rows 1 and 3 are **"no proof yet"**: `TS2339` says *the union still contains a member
  without that member* (the nested message names `number` — the compiler is showing you the
  unproven half), and `TS18046` says *this value is `unknown`, nothing is known at all*.
  Different codes, same missing mechanism: a guard.
- Rows 2 and 4 exit 0 because each guard removed exactly the impossible members: `typeof`
  split the union in two; the three-key chain turned `unknown` into
  `object & Record<"a", unknown>` — still needing a per-field check for anything *typed*.
- **Criteria check:** ☐ four predictions vs actuals ☐ `TS2339`/`TS18046` explained as no-proof
  ☐ guarded pair exits 0 with narrowed types written down.

## Exercise 2 — Reproduce the four executed failures, then fix each

**Reference transcript (authoring machine):**

```console
ts/bad-union.ts(3,12):    error TS2339: Property 'toUpperCase' does not exist on type 'string | number'.
ts/bad-unknown.ts(3,13):  error TS18046: 'v' is of type 'unknown'.
ts/bad-closure.ts(5,25):  error TS18047: 'input' is possibly 'null'.
ts/bad-exhaustive.ts(13,33): error TS2345: Argument of type '{ kind: "triangle"; base: number; height: number; }'
                             is not assignable to parameter of type 'never'.
EXIT=1 (each file, separately)
```

- Fixes, one per mechanism (**none uses `as any`**):
  1. `bad-union` → `if (typeof x === "string") return x.toUpperCase(); return x.toFixed(1);`
     — the narrowing lesson's `label`, now covering both members.
  2. `bad-unknown` → guard before read: `if (typeof v === "object" && v !== null && "a" in v)`
     then a second guard on the field's own type.
  3. `bad-closure` → **copy to `const` after narrowing**: `if (input !== null) { const v =
     input; const shout = () => v.toUpperCase(); … }` — the captured binding is now immutable,
     so flow analysis trusts the check across the closure. (Not "add an annotation": the
     compiler's objection is that the `let` could change before the callback runs; only a
     binding that *cannot* change makes the proof sound.)
  4. `bad-exhaustive` → handle the variant (`case "tri": …`) — then `default`'s leftover is
     `never` again and `assertNever(s)` compiles; each file re-run exits 0.
- **Criteria check:** ☐ four failing transcripts with codes ☐ four fixed versions compiling
  ☐ closure fix identified as the `const` copy.

## Exercise 3 — `parseConfig` over eight inputs

**Reference transcript (authoring machine):**

```console
{"host":"a","port":1,"debug":true} => {"host":"a","port":1,"debug":true}
not json => null
{"host":1,"port":1,"debug":true} => null
{"host":"a","port":"1","debug":true} => null
{"host":"a","port":1,"debug":"yes"} => null
{"host":"a","port":1} => null
null => null
"just a string" => null
```

- Eight inputs, **one accept, seven rejects** — and every rejection maps to a guard line:
  `not json` → the `try/catch` around `JSON.parse`; `null` → the `typeof … object` +
  `!== null` pair (the seam where `typeof null === "object"` would otherwise let it through);
  `host:1` → `typeof host !== "string"`; `port:"1"` → `typeof port !== "number"` (note:
  *no coercion* — `"1"` is not port 1 at a boundary); `debug:"yes"` → the boolean guard;
  missing `port` → `typeof undefined !== "number"`; `"just a string"` → the object guard.
- The single documented `as`: none was needed here (destructuring from `v` after the object
  guard is fine with `noImplicitAny` off… under `--strict` you may write
  `const o = v as Record<string, unknown>` **to index it**, exactly as the lesson's `parseUser`
  does — that shape-claim is immediately re-checked field by field, which is what makes it
  sound rather than a bypass.
- **Criteria check:** ☐ all eight outcomes captured ☐ each rejection traced to a guard line
  ☐ `as` policy honored.

## Exercise 4 — The chat-event pipeline (independent)

**Reference shape** (with the executed building blocks it must use):

```ts
type AppEvent =
  | { type: "msg"; text: string; ts: number }
  | { type: "typing"; userId: string }
  | { type: "edit"; id: string; text: string };
// future/unknown types arrive from other clients → parseEvent rejects them LOUDLY:
//   console.warn("app_event.unknown", { type: (v as {type?: unknown}).type });
//   return null;
```

- **Boundary:** `parseEvent(raw: string): AppEvent | null` — `JSON.parse` → `unknown` →
  object guard → `type` literal switch → per-variant field guards (the executed
  `parseConfig`/`parseUser` pattern, one branch per variant). Unknown `type` gets the logged
  category and `null` — never a silent drop, because a silently dropped `typing` event looks
  exactly like a bug elsewhere.
- **State:** `reduce(state, event)` with a `switch (event.type)` ending in
  `assertNever(event)` — deleting a `case` produces the executed **`TS2345`**
  (`{ kind: "triangle" … }` family — the variant is not assignable to `never`), which is the
  compile-time gate on shipping a half-handled event.
- **Render:** a second exhaustive switch, or `event.type`-keyed handlers in a record — both
  are legal; the switch keeps `assertNever`'s guarantee.
- **Self-test evidence required:**
  | Case | Expected |
  |---|---|
  | valid `msg` / `typing` / `edit` | parsed, reduced, rendered (runtime demo, 5 events) |
  | malformed JSON | `null` + no throw |
  | unknown `type` | `null` + logged `app_event.unknown` |
  | missing `case` in reduce (uncommented) | **`TS2345`**, exit 1 |
  | predicate claiming `typeof v === "number"` is `v is string` | compiles, then **crashes at runtime** — the trust wall executed |
- **Guard→member table:** `typeof v === "object" && v !== null` proves *object*; `"type" in v`
  proves the *tag key*; `v.type === "msg"` proves *that variant*; each field guard
  (`typeof text === "string"`, `typeof ts === "number"`) proves the *payload* — four rungs,
  each naming exactly one member-level fact.
- **Honest trade-off:** hand-rolled per-field guards are transparent and dependency-free but
  become boilerplate at 30 fields; a schema validator (zod-style) collapses them into one
  declaration and adds parsing errors for free — at the cost of a dependency and another
  abstraction to learn. At 3 fields, guards; at 30, the schema earns its keep.
- **Criteria check:** ☐ compiles clean, misuse documented with codes verified one at a time
  ☐ five-event runtime demo executed ☐ unknown types logged + rejected ☐ guard table ☐ one
  trade-off.

---

Next: [README](README.md) — back to the index.
