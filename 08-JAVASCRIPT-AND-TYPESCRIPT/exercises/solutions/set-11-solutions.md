# Solutions — Set 11: Generics

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.
> All transcripts re-executed on the authoring machine with tsc 7.0.2 under `--strict`.

## Exercise 1 — Five calls, predicted then checked

**Reference transcript (authoring machine):**

```console
# gen11b.ts — all misuse commented out
EXIT=0

# gen11.ts — the pinned-argument misuse live: first<number>(["a"])
ts/gen11.ts(5,28): error TS2322: Type 'string' is not assignable to type 'number'.
EXIT=1

# gen11c.ts — same misuse, but the argument is a pre-built variable
ts/gen11c.ts(3,27): error TS2345: Argument of type 'string[]' is not assignable to parameter of type 'number[]'.
  Type 'string' is not assignable to type 'number'.
EXIT=1
```

| Call | Predicted | Actual |
|---|---|---|
| `first([1,2,3])` | `number \| undefined` | passes (inference: `T = number`) |
| `first(["a"])` | `string \| undefined` | passes (`T = string`) |
| `first<number>(["a"])` | error | `TS2322` — fresh literal's *element* checked against `number` |
| `mapValues({n:1}, x => x+1)` | `Record<string, number>` | passes |
| `mapValues({n:1}, x => x.toUpperCase())` | error | `TS2345`/`TS2322` family — callback says `string`, `T = number` |

- The fourth row's explanation the criteria want: this is **relationship** checking, not
  inspection — the signature declared "callback accepts `T`", `T` was inferred as `number`
  from the object, and `(x) => x.toUpperCase()` demands `string`. Nothing looked inside the
  values; two *declared types* disagreed at the call site.
- The third row's executed nuance (the lesson's documented correction): a **fresh literal**
  reports `TS2322` (checked at the element), while a **variable** argument reports `TS2345`
  (checked at the argument) — same contract, different level. Both runs above are real.
- **Criteria check:** ☐ five predictions vs actuals ☐ fourth explained as relationship
  checking ☐ expected errors documented with verified codes.

## Exercise 2 — `pair<T>` vs `pairOf<A, B>`

**Reference transcript (authoring machine):**

```console
ts/pair11.ts(4,26): error TS2345: Argument of type 'string' is not assignable to parameter of type 'number'.
EXIT=1
# pairOf(1, "x") in the same file: no diagnostic — the file's only error is pair's
```

- `pair<T>(a: T, b: T)` — **one parameter means the same type in both positions**: `T` was
  inferred `number` from `1`, so `"x"` must also be `number` → error at the second argument.
- `pairOf<A, B>(a: A, b: B)` — two independent slots, mixed types are the *design*, passes.
- Which one is `Pair<A, B>` from the lesson? **`pairOf`** — the type-level twin of the
  two-parameter function. `pair<T>` is what you want for "these two belong together" (a key
  and its value of the same flavour); the over-constraint is the feature, not a limitation.
- **Criteria check:** ☐ error/pass transcripts ☐ one paragraph on sameness-as-intent.

## Exercise 3 — Genericize a real utility

**Reference shape** (your utility; the criteria's structure):

```ts
function groupBy<T, K extends string | number>(items: T[], key: (item: T) K): Record<K, T[]> {
  const out = {} as Record<K, T[]>;
  for (const item of items) (out[key(item)] ??= []).push(item);
  return out;
}
const byCat = groupBy(products, (p) => p.category);   // no call-site annotation
groupBy(products, (p) => p.id.toUpperCase());         // ✗ when id is number — captured diagnostic
```

- The pattern to hit: **one implementation, two element types** — run it over
  `{ id: number }[]` and `{ id: string }[]` (or your own two) with zero call-site
  annotations, because signatures annotate and call sites infer (lesson rule).
- The mismatch capture: a callback whose parameter type contradicts `T` fails **at the call**,
  with the column pointing at the callback — the relationship break, same family as exercise 1.
- A note on what you should *not* have written: any `as` inside, or `Record<string, T[]>`
  hardcoded when `K` was needed — the point of `<K extends string | number>` is that the
  return type *remembers* the key type you chose.
- **Criteria check:** ☐ both types through one implementation ☐ mismatch diagnostic captured
  at the relationship break ☐ call-site annotation note (expected: none).

## Exercise 4 — The typed event bus (independent)

**Reference shape:**

```ts
interface AppEvents {
  msg: { text: string; ts: number };
  typing: { userId: string };
  edit: { id: string; text: string };
}
type Result<T, E = Error> = { ok: true; value: T } | { ok: false; error: E };

function on<E extends keyof AppEvents>(name: E, handler: (payload: AppEvents[E]) => void) { … }
function emit<E extends keyof AppEvents>(name: E, payload: AppEvents[E]) { … }

// misuse, documented and commented — verify each by uncommenting one at a time:
// emit("msg", { text: 1 });        // ✗ payload type mismatch
// emit("nope", {});                // ✗ 'nope' not in keyof AppEvents
// on("typing", (p) => p.text);     // ✗ handler sees { userId } only
```

- **Runtime demo:** `on("msg", …)` + `emit("msg", { text: "hi", ts: 1 })` round-trip logged;
  a handler that throws is caught and returned as `{ ok: false, error }` — the error-handling
  lesson's boundary policy carrying types (previous lesson's `Result<T, E>`).
- **The config-string door (erasure-aware):** a name arriving from config is `string` at
  runtime — `keyof AppEvents` does not exist after compilation, so the check must be a
  **value check**: `if (name in handlers)` (or a `const` allowlist array + `includes`),
  rejecting unknown names with a logged category. Without it, `emit` from config is a
  `TypeError` waiting in production — name that as the runtime guard and where it lives
  (the ingress function, not every call site).
- **`mapValues`-style helper:** `mapPayloads<M extends Record<string, unknown>>(m: M, f: <K
  extends keyof M>(k: K, v: M[K]) => …)` — preserve the map's shape so transforming payloads
  never widens them to `any`.
- **Declaration table:** `E extends keyof AppEvents` (constrained — must be a real event name;
  `payload: AppEvents[E]` is the *indexed access* that couples name to payload); `Result<T,
  E = Error>` (defaulted — call sites stay light); the helper's two params (name-keyed
  relationship, same reason).
- **Honest trade-off:** a mapped event map types everything with zero duplication but forces
  every new event into one interface; explicit overloads read more linearly for 2–3 events
  and drift apart at 10 — pick the map once the set is non-trivial.
- **Criteria check:** ☐ compiles clean, misuse lines documented with codes verified one at a
  time ☐ runtime round-trip + `Result` failure executed ☐ config door checked explicitly with
  erasure cited ☐ parameter table ☐ one trade-off.

---

Next: [set-12-solutions.md](set-12-solutions.md)
