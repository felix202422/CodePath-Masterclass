# Solutions — Set 9: TypeScript Fundamentals

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.
> All transcripts re-executed on the authoring machine with tsc 7.0.2 and Node 24.13.1.

## Exercise 1 — The `errors.ts` pair, fixed, emitted, run

**Reference transcript (authoring machine):**

```console
$ tsc --strict --noEmit ts/errors.ts
ts/errors.ts(3,1): error TS2322: Type 'string' is not assignable to type 'number'.
ts/errors.ts(4,5): error TS2322: Type 'number' is not assignable to type 'string'.
EXIT=1

$ tsc --strict --target es2022 --outDir out ts/errors-fixed.ts && node out/errors-fixed.js
42 123 true
EXIT=0
```

- The fix is an **explicit conversion**, not a cast: `n = Number("42")` converts (runtime
  value changes meaningfully); `s = String(123)` / `s = \`${123}\`` converts the other way.
  `as unknown as number` would have compiled *and lied* — the distinction the whole subject
  keeps making.
- **Erasure, from the emitted file:** `out/errors-fixed.js` contains `let n = 42;` and no type
  syntax anywhere — the annotations are gone, the JS is plain `"use strict"` code, and it runs.
  Where did the types go? They never existed at runtime: they existed for the checker only.
- **Criteria check:** ☐ failing and passing runs with exit codes ☐ emitted JS inspected for
  absence of annotations ☐ one sentence on erasure.

## Exercise 2 — Inference ladder with misuse attempts

**Reference transcript (authoring machine):**

```console
$ tsc --strict --noEmit ts/ladder.ts
ts/ladder.ts(2,15): error TS2588: Cannot assign to 'b' because it is a constant.
ts/ladder.ts(3,14): error TS2322: Type 'number' is not assignable to type 'string'.
ts/ladder.ts(4,25): error TS2345: Argument of type 'number' is not assignable to parameter of type 'string'.
ts/ladder.ts(5,19): error TS2322: Type 'boolean' is not assignable to type '(string | number)[]'.
ts/ladder.ts(6,29): error TS2322: Type 'number' is not assignable to type 'string'.
EXIT=1
```

| Binding | Inferred | Misuse | Result |
|---|---|---|---|
| `let a = 42` | `number` | `a = 10` | **passes** (line 1 has no diagnostic) |
| `const b = 42` | literal `42` | `b = 43` | `TS2588` — *constant binding*, checked first |
| `let c = "x"` | `string` | `c = 42` | `TS2322` |
| `const d = ["a"]` | `string[]` | `d.push(1)` | `TS2345` (argument, not assignment) |
| `let e = [1, "x"]` | `(string \| number)[]` | `e = true` | `TS2322` |
| `const f = { mode: "dark" }` | `{ mode: string }` | `f.mode = 1` | `TS2322` |

- Note the two non-`TS2322` rows — both executed: assigning a `const` reports `TS2588`
  (the binding, not the type, is the problem; annotate `const b: 42 = 43` to see `TS2322`),
  and `d.push(1)` is `TS2345` because `push`'s *argument* is checked against `string`.
- **Widening rule in one line:** `let` widens literals to their general type, `const` keeps
  the literal, `as const` freezes nested literal members (the lesson's `mode` evidence).
- **Criteria check:** ☐ six predicted vs actual ☐ ≥4 misuse diagnostics ☐ widening rule stated.

## Exercise 3 — The strict bundle audit (with the tsc 7 CLI seam)

**Reference transcript (authoring machine):**

```console
$ tsc -p tsconfig.strict.json        # { "strict": true, "noEmit": true }
ts/inference.ts(8,17): error TS7006: Parameter 'x' implicitly has an 'any' type.
EXIT=1

$ tsc -p tsconfig.loose.json         # { "strict": false, "noEmit": true }
EXIT=0

# the seam: a bare CLI run with NO tsconfig also reported TS7006 —
# on tsc 7.0.2 the CLI's own defaults already enforce noImplicitAny
$ tsc --noEmit ts/inference.ts
ts/inference.ts(8,17): error TS7006: Parameter 'x' implicitly has an 'any' type.
EXIT=1
```

- **What disappeared when strictness went off:** `TS7006` — implicit `any` became legal.
  With `--strict --strictNullChecks false` the `TS7006` *stayed* (proving the flags are
  independent: null-checks don't buy you implicit-any checking).
- **Flags responsible, by name:** `noImplicitAny` (this diagnostic) and `strictNullChecks`
  (the one that forces `null`/`undefined` to be handled — turn it off and `possibly null`
  bugs return at runtime, silently).
- **Defense paragraph (yours to write, using these two outputs):** the loose config's exit 0
  means *the same file* passed only because untyped holes became legal — nothing about the
  file improved. Strict converts those holes into compile errors, which is the entire value
  proposition of the toolchain; and per the seam above, the CLI may enforce parts of it
  anyway, so `strict` belongs in the committed config where every environment agrees.
- **Criteria check:** ☐ both runs captured with the config each came from ☐ both flags named ☐
  one-paragraph defense.

## Exercise 4 — JSDoc conversion and the adoption plan (independent)

**Reference transcript (authoring machine) — the mechanism's "after" state:**

```console
$ tsc --allowJs --checkJs --noEmit ts/jsconfig-demo.js
EXIT=0
$ tsc --strict --target es2022 --outDir out ts2/greet.ts && node out/greet.js
Hello, Ada!
```

- **Exercise 4 shape:** run `checkJs` on your own *uncommented* utility first and record the
  error count (every `TS7006`-family hit is a missing `@param`), add JSDoc until the count is
  `0` — matching the executed demo above — then make one comment wrong (e.g. `@param {number}`
  where you pass a string at a call site) and capture the diagnostic; rename to `.ts` only
  when the file's *contracts* matter enough to deserve the compiler permanently — JSDoc is the
  correct long-term answer for libraries consumed from JS.
- **Adoption plan reference shape (2,000-line service):**
  - *tsconfig:* `strict: true` — rationale tied to executed evidence: `noImplicitAny` (the
    `TS7006` pair) and `strictNullChecks` (the `?.` discipline of the JS lessons); `noEmit`
    for type-check-only CI; `allowJs`/`checkJs` while files are still `.js`.
  - *Entry strategy:* `checkJs` on first (executed `EXIT=0` route — types enter without a
    rename), file-by-file rename afterwards; no flag day.
  - *Boundary surfaces annotated first:* (1) network/JSON doors (`unknown` + guards), (2)
    cross-module public functions (their signatures type every caller), (3) shared state
    containers. What stays temporarily untyped: leaf UI glue — with the error count *measured*
    so "temporary" is a number, not a hope.
  - *CI gate:* `tsc --noEmit` from day one of the plan; failing on **new** errors only at
    first, then on any error.
  - *Ratchet:* `tsc --noEmit 2> baseline.txt` captures the count; CI diffs current errors
    against `baseline.txt` and fails if the set grows (`diff` on the sorted output) — counts
    only go down.
  - *Erasure doors (executed fact):* JSON/network input (`JSON.parse` returns `unknown` — set
    12's door) and `any`-typed dependencies (their `.d.ts` lies propagate) — mitigations:
    parse-with-guards at ingress, `typesVersions`/local ambient declarations or wrappers for
    the worst deps.
- **Criteria check (exercise 3):** ☐ before/after counts ☐ deliberate JSDoc error captured ☐
  rename decision reasoned. **(exercise 4):** ☐ per-flag rationale tied to evidence ☐ phased
  commands + ratchet ☐ boundary policy ranked ☐ both erasure doors named ☐ velocity-vs-defect
  trade-off with team size.

---

Next: [set-10-solutions.md](set-10-solutions.md)
