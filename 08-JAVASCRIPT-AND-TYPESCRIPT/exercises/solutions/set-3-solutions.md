# Solutions — Set 3: Arrays and Objects

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.

## Exercise 1 — Aliasing vs copying, predicted then executed

**Reference transcript (authoring machine, Node 24.13.1):**

```console
b: [1,2,3,4] | arr: [1,2,3,4]
c: [1,2,3,4,5] | arr: [1,2,3,4]
d: [1,2,3] | arr: [1,2,3,4]
e: [4,3,2,1] | arr: [1,2,3,4] | same ref: false
```

- `const b = arr; b.push(4)` — **alias**: one array, two names. `b` and `arr` are the same
  reference, so `arr` became `[1,2,3,4]`. (The `const` only froze the *binding*.)
- `[...arr]` and `arr.slice()` — **shallow copies**: `c` and `d` are new arrays; pushing to
  `c` or popping from `d` left `arr` at `[1,2,3,4]`. Both are mutators *on the copy*; the
  source is untouched.
- `arr.toSorted(…)` — **pure**: returns a sorted copy (`e` is `[4,3,2,1]`), source unchanged
  and `e === arr` is `false`. Contrast with in-place `arr.sort()`, which mutates the receiver.
- Mutator/pure classification for everything used: `push`/`pop`/`sort` = mutator (they changed
  the receiver or its copy); `[...x]`, `slice`, `toSorted`, `map`, `filter` = pure (new array
  out, input untouched).
- **Criteria check:** ☐ four predictions matching execution ☐ classification written out.

## Exercise 2 — Both freeze crashes

**Reference transcript (authoring machine):**

```console
obj: TypeError: Cannot assign to read only property 'n' of object '#<Object>'
obj unchanged: {"n":1}
arr: TypeError: Cannot add property 2, object is not extensible
arr unchanged: [1,2]
```

- Two different messages, one rule: `Object.freeze` makes data properties **non-writable** and
  the object **non-extensible**. Assigning an existing key hits the first message; `push` on a
  frozen array tries to create index `2` (extensibility) and hits the second.
- Both throws were inside `try`/`catch`, and the `JSON.stringify` lines prove the data
  survived: `{"n":1}` and `[1,2]` — the exception is thrown *instead of* the write, so state
  is intact. In sloppy mode these assignments would **silently fail** (pre-ES5 behavior; ES5+
  throws in strict mode — and all modules and class bodies are strict, so you get the tripwire).
- Note the `catch` only fires in strict-mode code: a `<script>` without `"use strict"` would
  print nothing and change nothing — the crash *is* the feature.
- **Criteria check:** ☐ two `TypeError` transcripts verbatim ☐ `JSON.stringify` proving state
  survived ☐ sloppy-mode sentence.

## Exercise 3 — `withRow(id, fn)` immutable update

**Reference transcript (authoring machine):**

```console
original: {"rows":[{"id":1,"v":"a"},{"id":2,"v":"b"}]}
updated row2: {"id":2,"v":"B"} | row1 same ref: true | row2 same ref: false
no-match same rows ref: true | returns same db: true
```

```js
const withRow = (id, fn) => {
  const i = db.rows.findIndex((r) => r.id === id);
  if (i === -1) return db;                       // identity fast-path
  const rows = db.rows.slice();                  // new array, same row objects
  rows[i] = { ...rows[i], ...fn(rows[i]) };      // only the matched row is new
  return { ...db, rows };
};
```

- The original is byte-identical after the update; `row1` is reference-equal (`===` → `true`,
  untouched rows are shared — cheap for selectors/memoization) while `row2` is a new object
  (`false`) because it changed.
- The no-match case returned **the same `db` reference** (`miss === db`): without that
  fast-path every lookup would allocate a new root and defeat change-detection.
- **Criteria check:** ☐ original untouched ☐ identity checks shown for changed/unchanged/no-row
  ☐ same-reference fast path executed.

## Exercise 4 — Sorting with ties, non-mutating (intermediate) and the immutable index (independent)

**Reference transcript (authoring machine):**

```console
sorted: bo:9 di:9 ann:8 cy:8 | source intact: ["ann","bo","cy","di"]
source untouched: [] | new: ["new"] | other row same ref: true
external push succeeded (no freeze): ["evil"]
map lookup after update (cache note): 1 -> 1
```

- **Ties:** the executed call is `[...scores].sort((a, b) => b.score - a.score ||
  a.name.localeCompare(b.name))` —
  clause 1 descending (`b - a` ⇒ higher score first), and only on `0` (a tie) does clause 2
  run — ascending by name. Deterministic across runs because the comparator is total.
  The spread made a copy; `source intact: ["ann","bo","cy","di"]` proves the original order.
- **Immutable index:** `withTag(1, "new")` left the source `tags: []`, produced `["new"]` in
  the new array, and returned row 2 by reference (`true`) — the map/filter pattern from
  exercise 3, applied to a list of records.
- **The honest seam the criteria ask you to hunt:** the external `items[0].tags.push("evil")`
  **succeeded** — this API returns copies but does not freeze anything, so a caller holding
  the *original* array can still mutate it. That is why the lesson places `Object.freeze`
  as a **tripwire on the API's own outputs** (the returned rows/arrays), not on shared input:
  freezing shallow, in strict mode, turns accidental writes into the executed `TypeError`s of
  exercise 2 instead of silent divergence.
- **Stale-cache rule:** `byId`/`byCat` are built once from the *original* items — after
  `withTag`, lookups return the old record (`map lookup … 1 -> 1` while the new list shows
  `["new"]`). Rebuild (or derive) caches after any update, or key them by a revision — the
  executed mismatch is the bug's signature.
- **Criteria check:** ☐ deterministic tie order ☐ source identity/contents unchanged ☐ sign
  logic explained clause by clause ☐ external-mutation transcript + cache-correctness note +
  freeze placement justified.

---

Next: [set-4-solutions.md](set-4-solutions.md)
