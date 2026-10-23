# Solutions — Set 1: JavaScript Fundamentals

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.

## Exercise 1 — Nine expressions, predicted then executed

**Reference transcript (authoring machine, Node 24.13.1):**

```console
typeof [] => object
typeof NaN => number
'5' - 1 => 4
'5' + 1 => 51
1 + 2 + '3' => 33
null ?? 0 => 0
null || 0 => 0
0 ?? 'x' => 0
[3, 1, 2].sort() => [ 1, 2, 3 ]
```

- `typeof []` → `object`: arrays have no primitive type — `Array` is an object with a `[[Class]]`
  of `Array`; the lesson's table row covers it (`typeof null === 'object'` is the same family).
- `typeof NaN` → `number`: `NaN` is IEEE-754's "not a number" *value* of the `number` type —
  the name is a category label, not a type.
- `'5' - 1` → `4` vs `'5' + 1` → `51`: `-` is *numeric* coercion (both operands to numbers);
  `+` is overloaded — with **any** string operand it concatenates, left-to-right.
- `1 + 2 + '3'` → `"33"`: strictly left-to-right — `(1+2)=3`, then `3 + '3'` hits the string
  case. Reverse the order (`'3' + 1 + 2` → `"312"`) and you see why mixed-concatenation bugs
  are pure evaluation-order bugs.
- `null ?? 0` → `0` (nullish coalescing: only `null`/`undefined` trigger the default);
  `null || 0` → `0` (falsy trigger — here the same answer for a *different* reason);
  `0 ?? 'x'` → `0` — the discriminator: `0` is not nullish, so `??` keeps it while `||`
  would have thrown it away. Page numbers, counts, and prices are exactly the values `??`
  protects and `||` silently corrupts.
- `[3, 1, 2].sort()` → `[1, 2, 3]`: *incidentally* correct — the default comparator
  stringifies, so `["10", "9"]` sorts as `["10", "9"]`. Numeric sort needs the explicit
  comparator (set 3, exercise 4).
- **Criteria check:** ☐ nine predicted before running ☐ every mismatch explained by these
  four rules (typeof-quirk, numeric-vs-concat, left-to-right, nullish-vs-falsy).

## Exercise 2 — The TDZ experiment

**Reference transcript (authoring machine):**

```console
TDZ log: ReferenceError: Cannot access 'x' before initialization
typeof TDZ: ReferenceError: Cannot access 'y' before initialization
typeof undeclared: undefined
```

- The first two lines are the same failure: the binding exists from block entry but is
  **temporally dead** until its declaration line runs — and, correcting a widespread myth,
  `typeof` is *not* exempt. The lesson's executed probe shows `typeof` on the TDZ binding
  throwing the identical `ReferenceError`, in a block **and** inside a function.
- The third line is the only `typeof` free pass: a name that was **never declared** has no
  binding at all, so `typeof` answers `"undefined"` instead of throwing. Rule to keep:
  *undeclared → safe `undefined`; declared-but-not-yet → TDZ throw.*
- **Criteria check:** ☐ `ReferenceError` quoted for the direct read ☐ the same error for
  `typeof` on the TDZ binding ☐ never-declared `typeof` → `undefined` ☐ one sentence
  contrasting the two cases.

## Exercise 3 — `parseQuery` with destructuring, `??`, template literals

**Reference transcript (authoring machine):**

```console
{"a":1,"b":0,"c":""}
{"port":0,"name":"ada","x":0}
{"flag":"","deep":2,"b":0}
```

```js
const parseQuery = (search) => Object.fromEntries(
  search.replace(/^\?/, "").split("&").map((pair) => {
    const parts = pair.split("=");
    const [k] = parts;
    const v = decodeURIComponent(parts[1] ?? "");      // ?? supplies "" for a key with no '='
    const out = parts.length === 1 ? "" : (Number.isFinite(Number(v)) ? Number(v) : v);
    return [k, out];
  })
);
```

- The three cases the criteria name: `?port=0` → **`0`** (the `??` habit — `||` would have
  replaced a legitimate zero with a default); `b=` → `0` because `Number("")` is `0` and the
  pair *has* a value slot; bare `c`/`flag` → **`""`** because the key has no `=` at all —
  "empty value" and "no value" are different data, which is why the `parts.length` branch
  exists.
- `Number.isFinite` (not `isNaN`) rejects `""`-turned-0 only where you want it to and keeps
  `Infinity` out; no `if` chain — one expression per pair, destructuring-driven as required.
- Template-literal use: building the pair keys and any error labels (``${k}=${out}``) round-trips.
- **Criteria check:** ☐ `?port=0` returns `0` ☐ no `if` chains over keys ☐ three test calls
  with expected output captured.

## Exercise 4 — The `NaN` totals, three fixes (independent)

**Reference transcript (authoring machine):**

```console
reduce NaN: NaN
fix1 ?? : 4
fix2 filter: 4
fix3 boundary: TypeError: item no price has no numeric price
```

```js
// fix 1 — default at read
items.reduce((acc, i) => acc + (i.price ?? 0), 0);
// fix 2 — filter first
items.filter((i) => typeof i.price === "number").reduce((a, i) => a + i.price, 0);
// fix 3 — validate at the boundary, loudly
items.reduce((acc, i) => {
  if (typeof i.price !== "number") throw new TypeError(`item ${i.name ?? "?"} has no numeric price`);
  return acc + i.price;
}, 0);
```

- **What each hides vs catches:** `??` *hides* — a missing price silently becomes `0` and the
  dashboard looks plausible (it just under-reports). Filter *hides differently* — bad rows
  vanish from the total, so the number is "correct for the rows that were valid" while nobody
  learns rows were invalid. The boundary throw *catches* — the run stops at the first bad row
  with its identity in the message; that is the fix the criteria recommend, because the
  `NaN` came from *data quality*, and only this version reports data quality.
- Honest note: `??` is still right for *legitimately absent optionals* (a discount field);
  the difference is whether absence is a valid state of the domain or a defect in the payload.
- **Criteria check:** ☐ three working fixes with executed evidence ☐ trade-off column written
  honestly ☐ recommended version includes the failing-loud case (third line of transcript).

---

Next: [set-2-solutions.md](set-2-solutions.md)
