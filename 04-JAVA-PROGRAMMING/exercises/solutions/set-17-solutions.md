# Solutions — Set 17: Lambdas and Streams

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.

## Exercise 1 — Five predictions, five actuals

**Reference answers for the stated pipelines** on `words = [alpha, beta, gamma, delta]`:

| Pipeline | Output |
|---|---|
| `filter(startsWith a).count()` | `1` |
| `map(toUpperCase).sorted().toList()` | `[ALPHA, BETA, DELTA, GAMMA]` |
| `distinct().toList()` on `[x, y, x]` | `[x, y]` |
| `anyMatch(isEmpty)` | `false` |
| `mapToInt(length).average()` | `4.75` |

- Typical misreads: `sorted()` applies **after** `map` (alphabetical by the *uppercased* form,
  which here matches), and `average()` returns `OptionalDouble` — print `.orElse(-1)` or chain
  `.getAsDouble()`; `4.75 = 19/4`.

**Criteria check:** ☐ five pairs ☐ mismatches explained.

## Exercise 2 — The consumed stream

```console
Exception in thread "main" java.lang.IllegalStateException: stream already operated upon or closed
```

- Fix: rebuild per terminal (`words.stream()…toList()` then a fresh `words.stream()…count()`),
  or take one `.toList()` mid-way and stream *that*. Identical outputs either way.

**Criteria check:** ☐ error captured ☐ two-pipeline fix with identical output.

## Exercise 3 — Duplicate key, then merge

```console
Exception in thread "main" java.lang.IllegalStateException: Duplicate key alpha
```
*(message names the offending key; with lengths as keys the colliding insert is the second
word of that length)*

```java
.collect(Collectors.toMap(String::length, w -> w, (a, b) -> a + "/" + b));
// → {4=beta, 5=alpha/gamma/delta}   (executed in the lesson)
```

**Criteria check:** ☐ `Duplicate key` captured ☐ merged line.

## Exercise 4 — topN (independent)

**Reference behavior on demo data** (counts first, then sorted, then cut):

```text
raw:      go:2  api:2  java:3  zed:1 …
tie:      go and api both 2 → alphabetical: api before go   (stated tie rule)
case:     "Go"+"go" → go:2                                   (folded BEFORE counting)
top-2:    java:3, api:2
minLen=4: java and (…) only — 2-letter entries gone
empty:    []
```

- **The policy point:** folding must happen **before the classifier** (`map(toLowerCase)` then
  `groupingBy`) — folding in the sort produces two separate keys with equal counts, which no
  ordering can merge.

**Criteria check:** ☐ six predicted-then-run lines ☐ policy argued from output.

---

Next: [set-18-solutions.md](set-18-solutions.md)
