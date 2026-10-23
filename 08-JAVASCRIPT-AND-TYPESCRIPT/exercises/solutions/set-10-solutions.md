# Solutions — Set 10: Types and Interfaces

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.
> All transcripts re-executed on the authoring machine with tsc 7.0.2 under `--strict`.

## Exercise 1 — The four-behavior matrix, four separate runs

**Reference transcript (authoring machine):**

```console
# m1: Admin → User
EXIT=0

# m2: User → Admin
ts/m2.ts(4,7): error TS2741: Property 'role' is missing in type 'User' but required in type 'Admin'.
EXIT=1

# m3: fresh literal with an extra property
ts/m3.ts(2,39): error TS2353: Object literal may only specify known properties, and 'extra' does not exist in type 'User'.
EXIT=1

# m4: pre-built variable with the same extra property
EXIT=0
```

- **0 / 1 / 1 / 0**, explained only in "members" and "freshness" vocabulary:
  1. `Admin` *has every member* `User` declares — plus more; structurally it **is** a `User`.
  2. `User` lacks `role` — the member `Admin` requires; no amount of structure fixes a
     *missing* member. Column 7 is where `u` sits in the `Admin` slot — the error points at
     the **assignment**, not a call.
  3. Members are right, but the literal is **fresh** (written inline at the annotation site),
     so its extra member `extra` is checked — freshness exists to catch typo'd field names
     where structural typing would otherwise shrug. Column 39 is `'extra'` itself.
  4. Same shape, but `built` is an *older* value — freshness expired at assignment to
     `built`, so the later widening is allowed. The lesson's rule: **excess checks apply to
     fresh literals only** — which is exactly why API boundaries prefer parsing into typed
     values (set 12) over inline mega-literals.
- The lesson's own executed diagnostic (verified again in this batch): `structural.ts(12,32):
  error TS2353: … 'extra' does not exist in type 'Box'.`
- **Criteria check:** ☐ exit codes 0/1/1/0 across four runs ☐ one-line explanations in the two
  allowed vocabularies ☐ column numbers interpreted.

## Exercise 2 — The same data three ways

**Reference shape:**

```ts
interface Employee extends User { department: string }   // (a) hierarchy: nominal-feeling, extensible
type Employee = User & { department: string }            // (b) intersection: composable, unions-friendly
type Employee = { id: number; name: string; kind: "employee"; department: string }
type Worker = Employee | Contractor                       // (c) discriminated union: closed set
```

- Choose with reasons from the section-5 table: `interface` when you need **declaration
  merging** (augmenting a lib type) or `implements` in classes; `type` when you need
  **unions/intersections/mapped types** — the tooling the other lessons rely on; the tagged
  union when the value can *be one of a closed set* (it is the shape set 12 narrows).
- The version you would delete: whichever duplicates another's role — usually the plain
  intersection (b) if (a) already exists and nothing needs union composition, since two names
  for one type is how refactor confusion starts.
- **Criteria check:** ☐ three compiling versions ☐ choice citing ≥2 table rows ☐ deletion
  sentence.

## Exercise 3 — Three members, wrong fields, and the missing `case`

**Reference transcript (authoring machine):**

```console
$ tsc --strict --noEmit ts/shape11b.ts
ts/shape11b.ts(4,40): error TS2339: Property 'radiuss' does not exist on type '{ kind: "rect"; w: number; h: number; }'.
ts/shape11b.ts(5,12): error TS2339: Property 'b' does not exist on type '{ kind: "rect"; w: number; h: number; } | { kind: "tri"; b: number; }'.
  Property 'b' does not exist on type '{ kind: "rect"; w: number; h: number; }'.
EXIT=1

$ tsc --strict --noEmit ts/shape11c.ts     # default reads a field of the OTHER member
ts/shape11c.ts(6,23): error TS2339: Property 'w' does not exist on type '{ kind: "tri"; b: number; }'.
EXIT=1
```

- Each wrong-field use fails with `TS2339` *inside the branch that narrowed it* — and read
  the second message's nested type: `s` at that point was `rect | tri` because the `if`
  above didn't return. Narrowing is about the flow you actually wrote, not the flow you meant.
- **The missing case's answer, executed:** a `switch` over `kind` covering only `circle` and
  `rect` with `default: return s.b` **compiles clean** (no error on that line in the run
  above) — the compiler does *not* require every case. What `s` becomes in `default` is the
  **union minus the matched arms**: `shape11c`'s error message prints it exactly —
  `{ kind: "tri"; b: number; }` — and *that* is why reading another member's field there
  fails, and why the leftover type is the doorway to the `never` exhaustiveness idea the
  narrowing lesson executes (`assertNever(s)` accepts the leftover only when it is empty).
- **Criteria check:** ☐ three wrong-field diagnostics with locations ☐ `default`'s inferred
  type recorded from the message ☐ one sentence connecting leftover → `never`.

## Exercise 4 — The runtime-door drill and the editor type layer (independent)

**Reference shape — `parseUser(raw: unknown): User | null`, five inputs:**

| Input | Guard result | Notes |
|---|---|---|
| `"Ada"` (string) | `null` | `typeof v !== "object"` |
| `null` | `null` | the `typeof null === "object"` seam — explicit `v !== null` |
| `{ id: "x", name: "Bo" }` | `null` | `typeof o.id !== "number"` |
| `{ id: 1, name: "Bo", admin: true }` | **accepts** | extra fields are *not* rejected — freshness expired; only literals get the excess check |
| `{ id: 1 }` (no `name`) | `null` | the case the `as User` version **misses** |

- **The `as`-version demonstration:** replace the guards with `return raw as User` and all
  five inputs return "a User" — the test *still passes* if your assertions only checked
  `!== null`, because **assertions do not run**; input 5 then flows into typed code and
  crashes wherever `user.name` is read. Unsound `as` converts a compile-time proof into a
  runtime surprise — sound only *after* guards (or from a trusted source you can name).
- **Editor layer (independent) reference shape:** ≥3 discriminated unions —
  `Node = TextNode | ImageNode | FrameNode` (shared `id`/`parentId`, per-variant fields),
  `Selection = { kind: "none" } | { kind: "one"; id: string } | { kind: "many"; ids: string[];
  type: Node["kind"] }` (the `type` field is what lets the command layer *refuse* mixed
  selections — structural typing alone cannot express "same-type"), and
  `History = { past: Snapshot[]; current: Snapshot; future: Snapshot[] }` where `Snapshot` is
  a `readonly` deep-ish structure so a mutated-in-place "snapshot" is at least visible to
  `Object.freeze` tripwires. Load path: `unknown` → per-field guards → `Result`, with the
  error carrying the failing path (`node[2].src: expected string, got number`).
- **Declaration rationale table (cite executed lines):** `interface` for node shapes you'll
  implement in classes (`implements`), `type` for the unions (freshness `TS2353` shows the
  closed-set payoff), `readonly` on history entries (shallow — the executed fundamentals
  caveat), and the structural-looseness trade-off chosen as *nothing* (no unit branding) with
  the defense: node identity is enforced by `id` validation at the load door, not by the type
  layer.
- **Criteria check:** ☐ five executed cases with the table ☐ `as`-version showing the unchecked
  door ☐ sound-vs-unsound paragraph citing erasure ☐ compiling `--strict` skeleton with ≥3
  unions ☐ ≥3 rejection cases naming paths ☐ rationale table + one honest cost statement.

---

Next: [set-11-solutions.md](set-11-solutions.md)
