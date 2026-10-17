# Solutions — Set 10: Arrays and Strings

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.

## Exercise 1 — Four slices

**Answer.** For `xs = [2, 4, 6, 8, 10, 12]`:

| Slice | Predicted | Rule |
|---|---|---|
| `xs[2:5]` | `[6, 8, 10]` | start 2 included, stop 5 excluded |
| `xs[:3]` | `[2, 4, 6]` | omitted start → 0 |
| `xs[-2:]` | `[10, 12]` | negative start counts from the end; omitted stop → to the end |
| `xs[::2]` | `[2, 6, 10]` | step 2 from the beginning |

**Criteria check:** ☐ four predictions ☐ four real results ☐ mismatches explained by
start/stop/step.

## Exercise 2 — The reshape pipeline

**Answer.**

```python
line = "  apple,banana,cherry  "
fruits = [w.title() for w in line.strip().split(",")]
result = " / ".join(fruits)
```

`strip()` removes the outer spaces **before** the split (otherwise the first and last fruits
carry stray spaces into their titles); `split(",")` on the comma keeps empty-edge awareness in
sight; the real output is:

```text
Apple / Banana / Cherry
```

**Criteria check:** ☐ exact string ☐ produced by a real run ☐ strip-before-split noted.

**Reviewer note:** the ordering matters — strip → split → title → join. Doing `split` first on
unstripped text yields `"Apple"` but `" Cherry "` variants; the pipeline's order *is* the
solution.

## Exercise 3 — Aliasing, then isolation

**Answer.**

```python
a = [1, 2]
b = a
b.append(3)
print(a)        # [1, 2, 3]  - one object, two names

a2 = [1, 2]
b2 = a2.copy()
b2.append(3)
print(a2)       # [1, 2]     - two objects
print(b2)       # [1, 2, 3]
```

The transcripts capture both regimes: shared mutation (the lesson's section 6) and explicit
isolation. The binding diagram explains the difference in one sentence each: same arrow vs two
arrows to different boxes.

**Criteria check:** ☐ shared-mutation transcript ☐ isolated-copy transcript ☐ both explained by
the binding model.

## Exercise 4 — Word-frequency counter (independent)

**Answer.** Shape and evidence:

```python
import re                                    # not needed: the exercise forbids it - shown for contrast

text = """to be or not to be that is the question whether tis nobler
in the mind to suffer slings and arrows"""

clean = [w.strip(".,!?;:").lower() for w in text.split()]
words = [w for w in clean if len(w) >= 3]

counts = {}
for w in words:
    counts[w] = counts.get(w, 0) + 1

top = sorted(counts.items(), key=lambda kv: (-kv[1], kv[0]))[:5]
for w, c in top:
    print(f"{w:<8} {c}")
```

Hand verification: `to` appears 3 times but is dropped (length 2); `be` likewise; `the` → 2,
`not` → 1, `question` → 1. Longest word: `question` (8). Tie rule stated: **alphabetical among
equal counts** — implemented by the `(-count, word)` sort key, so the order is deterministic
across runs and machines.

**Criteria check:** ☐ hand-verified counts ☐ tie rule stated and implemented ☐ aligned output
☐ punctuation stripped ☐ short words dropped.

**Reviewer note:** `sorted` with a tuple key is the professional shape here; sorting by count
alone leaves ties in *insertion* order, which varies with input order — the criterion's
"deterministic" clause is what forces the second key.
