# Solutions — Set 15: Generics

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.

## Exercise 1 — The erasure refusals

```console
error: unexpected type
    static <T> T make() { return new T(); }
                                     ^
  required: class
  found:    type parameter T
```

```console
error: generic array creation
    static <T> void toArray(List<T> list) { T[] a = new T[list.size()]; }
                                                    ^
```

- **Two-sentence explanation:** after compilation the type argument is erased to its bound, so
  the compiler has no class to instantiate and no reified element type for an array; arrays are
  special because they *remember* their component type at runtime and generics (deliberately)
  do not.

**Criteria check:** ☐ both errors ☐ explanation.

## Exercise 2 — Bounded max, and the unbounded break

**Reference:** `<T extends Comparable<T>> T max(List<T> xs)` with `xs.get(0)` seed and
`compareTo(best) > 0` — runs print `pear` (strings) and `30` (integers).

```console
error: cannot find symbol: method compareTo(…)
    if (x.compareTo(best) > 0) …
        ^
  symbol: method compareTo(T)
```

- Without the bound `T` has only `Object`'s members; the fix is *declaring* the requirement
  (`<T extends Comparable<T>>`), not casting.

**Criteria check:** ☐ both outputs ☐ unbounded error captured.

## Exercise 3 — PECS 2×2

| Direction | Read (get) | Write (add) |
|---|---|---|
| `? extends Number` | ✅ as `Number` | ❌ `cannot be applied` (only `null`) |
| `? super Integer` | ✅ as `Object` only | ✅ any `Integer` |

- Rule from the table, not from memory: **producer extends** (you read the bound), **consumer
  super** (you write the bound).

**Criteria check:** ☐ four compilations ☐ table from real errors.

## Exercise 4 — Result<T> (independent)

**Reference signatures** (written before the code):

```java
static <T> Result<T> ok(T value);
static <T> Result<T> error(String message);
boolean isOk();
T get();                                       // throws DescribedException on error path
static <T, U> Result<U> map(Result<T> r, Function<T, U> f);
```

- Six lines: ok value; mapped value; error passthrough (map skipped); `isOk` true; `isOk` false;
  `get()`-on-error caught with your description. **Raw-type loss line:** without `<T>`, `get()`
  returns `Object` and *every* call site casts — the wrong cast becomes a runtime bet instead of
  a compile-time refusal.

**Criteria check:** ☐ signatures first ☐ six predicted-then-run lines ☐ loss named precisely.

---

Next: [set-16-solutions.md](set-16-solutions.md)
