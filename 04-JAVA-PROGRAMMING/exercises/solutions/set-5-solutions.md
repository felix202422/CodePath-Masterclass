# Solutions — Set 5: Methods

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.

## Exercise 1 — max and isEven from memory

**Reference shape:**

```java
static int max(int a, int b) { return a > b ? a : b; }
static boolean isEven(int n) { return n % 2 == 0; }
```

- Methods **compute and return**; `main` prints. Sample results: `max(3, 7) = 7`,
  `max(-1, -5) = -1`, `isEven(4) = true`.

**Criteria check:** ☐ three call results ☐ compute/print split respected.

## Exercise 2 — Overloads

**Reference shape:** `area(int side)` vs `area(int w, int h)` (or a `join(String)` /
`join(String, String)` pair) — both called; distinct outputs prove which one ran.

- **What picks the overload:** the **declared** argument types at the call site (compile-time
  resolution) — contrast the runtime-type rule of overriding in [polymorphism.md](../../polymorphism.md).

**Criteria check:** ☐ distinct behavior ☐ declared-type rule stated.

## Exercise 3 — Stack overflow, caught

```console
StackOverflowError after <N> frames
```

- `static void deep(int n) { deepest = n; deep(n + 1); }` inside `try/catch (StackOverflowError)`
  — the JVM lesson counted **20538** frames on the authoring machine; your N differs (stack
  size is configuration-dependent). Catching it to *log* is a demo technique; production policy
  is to fix the unbounded recursion.

**Criteria check:** ☐ error caught ☐ frame count recorded.

## Exercise 4 — Pure Stats module (independent)

**Reference shape:** `static double mean(int[] xs)` (empty → documented behavior, e.g. throws
`IllegalArgumentException("empty")`), `static int range(int[] xs)`, `static int countAbove(int[]
xs, int limit)` — **no printing inside any method**; `main` prints hand-checked values for two
data sets (e.g. `{2, 4, 9}` → mean 5.0, range 7, countAbove(3) = 2).

- **Reviewer note:** the empty-input behavior must be *defined* — throwing a described exception
  or returning a documented sentinel; "it crashed with a trace" is not a definition.

**Criteria check:** ☐ hand-checked values ☐ empty input defined ☐ no printing inside.

---

Next: [set-6-solutions.md](set-6-solutions.md)
