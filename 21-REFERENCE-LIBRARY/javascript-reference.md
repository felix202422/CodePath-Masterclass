# JavaScript & TypeScript Reference

Lookups for the JavaScript and TypeScript material: values, arrays, objects, modules, async, and the
type-level features the lessons use. JavaScript snippets were run on Node 24; TypeScript snippets were
compiled with `tsc --strict`.

> **Baseline.** Node 24.13.1 (ECMAScript modules), TypeScript 5.9.3 with `--strict`. Verified
> 2026-11-08. Output quoted is captured stdout. Browser-only APIs (`document`, `localStorage`) are
> covered in the frontend lessons, not here.

## Values and types

| `typeof` result | Meaning | Gotcha |
|---|---|---|
| `"undefined"` | Not declared or not assigned. | `let x; typeof x` is `"undefined"`, no error. |
| `"object"` | Objects, arrays, `null`, dates. | `typeof null === "object"` — a historical bug kept for compatibility. |
| `"function"` | Functions and classes. | Classes are functions with a prototype. |
| `"string"`, `"number"`, `"boolean"`, `"bigint"`, `"symbol"` | Primitives. | `NaN` is a `"number"`. |
| `"object"` for arrays | Check with `Array.isArray(x)`. | `typeof [] === "object"`. |

| Need | Code |
|---|---|
| Check for a real number | `Number.isFinite(x)` (rejects `NaN`, `Infinity`, strings) |
| Check for `NaN` | `Number.isNaN(x)` — global `isNaN("abc")` coerces first and lies |
| Integer check | `Number.isInteger(x)` |
| Parse | `Number("42")`, `parseInt("42px", 10)`, `parseFloat("1.5")` |
| Format money | `new Intl.NumberFormat("de-DE", { style: "currency", currency: "EUR" }).format(1234.5)` |
| Round | `Math.round(x)`, `Math.floor`, `Math.ceil`, `x.toFixed(2)` (returns a string) |
| Safe integer | `Number.MAX_SAFE_INTEGER`; above it use `BigInt` (`10n`) |

**Falsy values:** `false`, `0`, `-0`, `0n`, `""`, `null`, `undefined`, `NaN`. Everything else is
truthy — including `[]` and `{}`, which surprises almost everyone once.

## Equality and coercion

```js
1 == "1";            // true  — == coerces
1 === "1";           // false — === compares type and value
null == undefined;   // true  — the one useful == case
null === undefined;  // false
NaN === NaN;         // false — use Number.isNaN
Object.is(NaN, NaN); // true  — SameValue equality
```

Prefer `===` everywhere except the deliberate `x == null` idiom, which checks for both `null` and
`undefined` in one comparison. `Object.is` differs from `===` only for `NaN` and `-0`.

## Variables and scope

| Declaration | Reassignable | Scope | Hoisting |
|---|---|---|---|
| `const` | No (the binding) | Block | Temporal dead zone until the declaration |
| `let` | Yes | Block | Temporal dead zone until the declaration |
| `var` | Yes | Function | Initialised to `undefined` at the top of the function |

`const` freezes the binding, not the value: `const user = {}; user.name = "Ada";` is legal. Use
`Object.freeze` when you need the object itself immutable (shallowly).

## Destructuring and spread

```js
const { length, ...rest } = { length: 3, width: 4, height: 5 };
// length: 3, rest: { width: 4, height: 5 }

const [first, second = "none"] = ["a"];
// first: "a", second: "none"

const merged = { ...defaults, ...overrides };   // later wins, shallow
const copy = [...items];                        // shallow copy
```

- Rest (`...`) collects the remainder; spread expands into a new object or array.
- Both are shallow: nested objects are shared, so spread is not a deep clone.
- Rename while destructuring: `const { name: userName } = user;`

## Optional chaining and nullish coalescing

```js
config.server?.host;              // undefined instead of throwing
config.missing?.deep?.value;      // short-circuits at the first undefined
value ?? "fallback";              // fallback only for null or undefined
value || "fallback";              // fallback for 0, "", false too — usually wrong
obj.method?.();                   // call only if the method exists
list?.[0];                        // element access
```

`??` and `||` are not interchangeable: `0 ?? 10` is `0`, while `0 || 10` is `10`. Use `??` for
defaults, `||` only when any falsy value should trigger the fallback.

## Arrays

| Need | Method | Mutates? |
|---|---|---|
| Add/remove at the end | `push(x)`, `pop()` | Yes |
| Add/remove at the front | `unshift(x)`, `shift()` | Yes |
| Remove/insert in the middle | `splice(start, deleteCount, ...items)` | Yes |
| Reverse / sort in place | `reverse()`, `sort(cmp)` | Yes |
| Copy before mutating | `toReversed()`, `toSorted(cmp)`, `toSpliced(...)`, `with(i, v)` | No |
| Transform | `map(fn)` | No |
| Filter | `filter(fn)` | No |
| Fold | `reduce((acc, x) => acc + x, 0)` | No |
| Flatten one level / all | `flat()`, `flatMap(fn)` | No |
| Find / find index | `find(fn)`, `findIndex(fn)`, `findLast(fn)` | No |
| Test | `some(fn)`, `every(fn)`, `includes(x)` | No |
| Slice / join | `slice(start, end)`, `join(", ")` | No |
| Element from the end | `at(-1)` | No |
| Iterate | `for (const x of arr)`, `entries()`, `keys()`, `values()` | No |

```js
const words = ["delta", "alpha", "charlie", "bravo"];
words.toSorted();                       // ["alpha","bravo","charlie","delta"]
words;                                  // unchanged
words.map((w) => w.length);             // [5, 5, 7, 5]
words.reduce((sum, w) => sum + w.length, 0); // 22
words.at(-1);                           // "bravo"
[1, 2].flatMap((n) => [n, n * 10]);     // [1,10,2,20]
```

**Verified output:** `sorted: [ 'alpha', 'bravo', 'charlie', 'delta' ]`,
`lengths: [ 5, 5, 7, 5 ]`, `total: 22`, `at(-1): bravo`, `flatMap: [ 1, 10, 2, 20 ]`

`sort()` without a comparator sorts by UTF-16 code units, so `[10, 9, 1].sort()` gives
`[1, 10, 9]`. Always pass `(a, b) => a - b` for numbers. `toSorted` returns a new array and leaves
the original alone.

## Objects

```js
const byLength = Object.groupBy(["delta", "alpha", "charlie", "bravo"], (w) => w.length);
// { "5": ["delta","alpha","bravo"], "7": ["charlie"] }

Object.keys(obj);            // own enumerable string keys
Object.values(obj);          // values
Object.entries(obj);         // [[key, value], ...]
Object.fromEntries(entries); // back to an object
Object.hasOwn(obj, "k");     // own property, not inherited
Object.freeze(obj);          // shallow immutability
```

**Verified output:** `groupBy: {"5":["delta","alpha","bravo"],"7":["charlie"]}`,
`destructured: 3 {"width":4,"height":5}`, `optional: undefined fallback`

| Need | Code |
|---|---|
| Shallow merge | `{ ...a, ...b }` |
| Deep clone | `structuredClone(value)` — keeps `Date`, `Map`, `Set`, cycles |
| JSON clone | `JSON.parse(JSON.stringify(x))` — loses `Date`, `Map`, `undefined`, turns `NaN` into `null` |
| Compare deeply | no built-in; `JSON.stringify` order-dependent, use a small deep-equal or `Object.is` per field |
| Property shorthand | `{ id, name }` instead of `{ id: id, name: name }` |
| Computed key | `{ [key]: value }` |

**Verified:** `structuredClone` preserved a `Date` and a `Set`; the JSON round-trip turned the date
into a string and the `Set` into `{}`.

## Map and Set

```js
const counts = new Map();
counts.set("a", 1);
counts.get("a");          // 1
counts.get("missing");    // undefined
counts.has("a");          // true
[...counts.entries()];    // [["a", 1]]

const unique = [...new Set(["a", "b", "a"])];   // ["a", "b"]
```

**Verified output:** `map: [ [ 5, 3 ], [ 7, 1 ] ]`, `set: [ 'a', 'b' ]`

`Map` keys may be any value, including objects; object keys in a plain object are always coerced to
strings. `Map` preserves insertion order and has a `size` property; plain objects do not.

## Functions and closures

```js
function add(a, b = 0) { return a + b; }        // hoisted, own `this`
const add2 = (a, b = 0) => a + b;               // no own `this`, no `arguments`

function counter() {
  let count = 0;
  return () => ++count;                          // closes over `count`
}
counter()();                                     // 1
```

| Difference | `function` | Arrow |
|---|---|---|
| Hoisting | Hoisted | `const` TDZ until assigned |
| `this` | Dynamic, set by the call | Lexical, from the enclosing scope |
| `arguments` | Available | Not available — use rest parameters |
| Constructor | `new` works | `new` throws |
| Use for | Methods, constructors, callbacks needing `this` | Callbacks, short transforms |

## Modules

```js
// math.mjs
export const PI = 3.14159;
export function area(r) { return PI * r * r; }
export default function describe() { return "math"; }

// app.mjs
import describe, { PI, area } from "./math.mjs";
```

- ES modules (`import`/`export`) are the standard; `.mjs` is always a module, `.js` follows `"type"` in the nearest `package.json`.
- Imports are live bindings and are hoisted; `require` (CommonJS) is synchronous and copies values.
- A file's imports are resolved once and cached — module state is shared by every importer.

## Async and the event loop

```js
const order = [];
setTimeout(() => order.push("timeout"), 0);
Promise.resolve().then(() => order.push("microtask"));
order.push("sync");
// after the current task: sync, microtask, timeout
```

**Verified output:** `order before tick: sync`, `after tick: sync,microtask,timeout`

| Need | Code |
|---|---|
| Wait for one promise | `const v = await promise;` inside `async` |
| Wait for all | `await Promise.all([p1, p2])` — rejects on the first failure |
| Wait for all, collect outcomes | `await Promise.allSettled([p1, p2])` — never rejects |
| First to settle | `await Promise.race([p1, p2])` |
| First fulfilled | `await Promise.any([p1, p2])` |
| Run after settled | `promise.finally(fn)` |
| Wrap a callback API | `await new Promise((resolve, reject) => fn((e, v) => e ? reject(e) : resolve(v)))` |
| Timeout a promise | `Promise.race([work, new Promise((_, r) => setTimeout(() => r(new Error("timeout")), ms))])` |

Ordering rule: the call stack runs to completion, then all microtasks (promise callbacks, `await`
continuations), then one macrotask (`setTimeout`, IO), repeat.

## Errors

```js
try {
  JSON.parse("{not json}");
} catch (error) {
  if (error instanceof SyntaxError) {
    console.error("bad JSON:", error.message);
  } else {
    throw error;                    // never swallow what you cannot handle
  }
}
```

**Verified output:** `caught: true SyntaxError`

| Need | Code |
|---|---|
| Custom error | `class NotFoundError extends Error { constructor(m) { super(m); this.name = "NotFoundError"; } }` |
| Preserve a cause | `throw new Error("loading config", { cause: err })` |
| Convert a promise rejection | `.catch`, or `try/catch` around `await` |
| Global safety nets | `process.on("unhandledRejection", handler)` — a diagnostic, not a strategy |

An `async` function that throws rejects its promise; if nothing awaits it, the failure disappears into
`unhandledRejection`. Always `await` or attach a handler.

## TypeScript

```ts
type Result<T> =
  | { status: "ok"; value: T }
  | { status: "error"; message: string };

function unwrap<T>(result: Result<T>): T {
  switch (result.status) {
    case "ok": return result.value;
    case "error": throw new Error(result.message);
    default: {
      const exhaustive: never = result;     // compile error if a case is missed
      throw new Error(`unhandled: ${JSON.stringify(exhaustive)}`);
    }
  }
}
```

**Verified (tsc 5.9.3, `--strict`):** `unwrap: 42`

| Need | Syntax |
|---|---|
| Object shape | `interface User { id: number; email: string }` or `type User = { ... }` |
| Optional property | `host?: string` — `string \| undefined` |
| Readonly | `readonly port: number`, `ReadonlyArray<T>` |
| Union | `string \| number` |
| Literal type | `type Method = "GET" \| "POST"` |
| Intersection | `A & B` |
| Generic | `function first<T>(xs: T[]): T \| undefined` |
| Constraint | `<K extends keyof T>` |
| Type guard | `function isUser(v: unknown): v is User` |
| Narrowing | `typeof x === "string"`, `x instanceof Date`, `"id" in obj`, discriminant switch |
| Assertion function | `function assert(x: unknown): asserts x is User` |
| Mapped type | `{ [K in keyof T]?: T[K] }` |
| Conditional type | `T extends string ? "text" : "other"` |
| Utility types | `Partial<T>`, `Required<T>`, `Pick<T, K>`, `Omit<T, K>`, `Record<K, V>`, `ReturnType<F>` |
| Compile-time check without widening | `const routes = { home: "/" } satisfies Record<string, \`/${string}\`>` |
| `any` vs `unknown` | `any` disables checking; `unknown` requires narrowing before use |

**Verified snippet (strict):**

```ts
function pluck<T, K extends keyof T>(items: T[], key: K): T[K][] {
  return items.map((item) => item[key]);
}
pluck(users, "email");        // string[]
```

```ts
function describe(value: unknown): string {
  if (typeof value === "string") return `string(${value.length})`;
  if (Array.isArray(value)) return `array(${value.length})`;
  if (value === null) return "null";
  return typeof value;
}
```

**Verified output:** `describe: string(3) array(2) null number`, `pluck: [ 'ada@example.com', 'grace@example.com' ]`

`strict` enables `strictNullChecks`, `noImplicitAny`, `strictFunctionTypes` and friends. Most real
type errors are `undefined` reaching a place that assumed a value — narrowing early is the fix, and
`as any` is not.

## Node built-ins

| Need | Module |
|---|---|
| Read/write a file | `import { readFile, writeFile } from "node:fs/promises";` |
| Read lines | `(await readFile(p, "utf8")).split("\n")` |
| Paths | `import path from "node:path"; path.join("a", "b")`, `path.resolve(...)` |
| Directory of the current file | `import.meta.dirname` (Node 20.11+) |
| Arguments | `process.argv.slice(2)` |
| Environment | `process.env.NODE_ENV` |
| Exit code | `process.exitCode = 1` (preferred over `process.exit`) |
| URL parsing | `new URL("https://x/y?z=1")`, `url.searchParams.get("z")` |
| HTTP request | global `fetch` |

Use the `node:` prefix for built-ins: it makes the import unambiguous and works in both ESM and CJS.

## Related pages

- [Common Errors](common-errors.md) — the runtime and type errors these patterns prevent
- [Glossary](glossary.md) — closures, TDZ, microtasks and the rest of the vocabulary
- [08-JAVASCRIPT-AND-TYPESCRIPT/promises-and-async-await.md](../08-JAVASCRIPT-AND-TYPESCRIPT/promises-and-async-await.md) — the async lesson
- [08-JAVASCRIPT-AND-TYPESCRIPT/typescript-fundamentals.md](../08-JAVASCRIPT-AND-TYPESCRIPT/typescript-fundamentals.md) — the type-system lesson
- [09-FRONTEND-ENGINEERING/react-fundamentals.md](../09-FRONTEND-ENGINEERING/react-fundamentals.md) — where these patterns meet React
