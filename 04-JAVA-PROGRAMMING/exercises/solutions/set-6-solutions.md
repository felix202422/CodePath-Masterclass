# Solutions — Set 6: Arrays and Strings

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.

## Exercise 1 — Reads vs mutation

**Reference shape.**

```java
int[] xs = {10, 20, 30};
int sum = 0;
for (int x : xs) sum += x;      // reads elements: sum = 60
for (int x : xs) x = 0;         // legal but useless — x is a COPY each iteration
xs[0] = 99;                     // indexed write: real mutation
System.out.println(sum + " " + Arrays.toString(xs));   // 60 [99, 20, 30]
```

- **Enhanced-for gives you the value (a copy for primitives)** — mutation inside it can't reach
  the array; the indexed write can. That asymmetry is the criterion's whole point.

**Criteria check:** ☐ reads-see-elements sentence ☐ mutation visible in output.

## Exercise 2 — The two failures

```console
Exception in thread "main" java.lang.ArrayIndexOutOfBoundsException: Index 5 out of bounds for length 3
```

```java
Object[] a = new String[1];
a[0] = 5;    // compiles (Object slot) — throws ArrayStoreException at RUNTIME
```

- Index bounds are checked **every** access (the trace above); element-type storage is *also*
  checked at runtime for arrays — covariance's hole is plugged by `ArrayStoreException`, not by
  the compiler. Java's **generics** chose the opposite trade (compile-time only, erased) —
  connect to [generics.md](../../generics.md) Exercise 1.

**Criteria check:** ☐ runtime OOB captured ☐ ArrayStoreException demonstrated or explained from
the lesson.

## Exercise 3 — Vowels and reversal, by hand

**Reference shape:** `for (int i = 0; i < s.length(); i++) { char c = s.charAt(i); … }` with a
`"aeiouAEIOU".indexOf(c) >= 0` test; reversal via `new StringBuilder(s).reverse().toString()` or
an explicit index swap loop.

- Sample: input `"CodePath"` → vowels `3`, reversed `"htaPedoC"`. No `split`, no streams — the
  criterion forces the `charAt` mechanics you'll need when algorithms arrive.

**Criteria check:** ☐ two outputs ☐ one chosen input ☐ no split/streams.

## Exercise 4 — uniqueSorted (independent)

**Reference shape and the three input sets:**

```text
in1: {"Pear", "apple", "APPLE", "  ", "fig", "apple"}
out1: [apple, fig, pear]          // case-folded, blanks dropped, stable duplicates
in2: {}
out2: []                          // defined: empty in → empty out
in3: {"solo"}
out3: [solo]
```

- Case-insensitivity belongs in the **comparison** (`String.CASE_INSENSITIVE_ORDER`) so the
  kept spelling is the first-seen one; blanks dropped *before* dedup so `"  "` can't survive.

**Criteria check:** ☐ three outputs hand-verified ☐ empty-array behavior defined.

---

Next: [set-7-solutions.md](set-7-solutions.md)
