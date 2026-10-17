# Arrays and Strings

## 1. Learning Objectives

After this lesson you will be able to:

- [ ] Create, index, slice, and grow a Python list, predicting each operation's result — including
      negative indexes and the stop-excluded slice rule
- [ ] Use the core string methods (`split`, `join`, `strip`, `replace`, `in`) to reshape text
      deliberately
- [ ] Explain why lists are mutable and strings are immutable, and predict which operations
      modify and which return new values
- [ ] Apply the standard transformations — filter, map, reverse, count — with list comprehensions
      and `join`

## 2. Prerequisites

- [functions-and-methods.md](functions-and-methods.md) — transformations are functions over
  sequences; the binding model from that lesson explains the aliasing in section 6.
- [variables-and-data-types.md](variables-and-data-types.md) — `str` and the core types; this
  lesson treats sequences of them.
- [loops.md](loops.md) — comprehensions are loops in expression form.

## 3. Introduction

Almost every program's data is a **sequence**: a list of prices, a line of text, rows from a
file. Python's two workhorse sequences are the **list** — an ordered, changeable collection —
and the **string** — an ordered, *unchangeable* sequence of characters. The asymmetry between
them (one mutates, one does not) is not an accident of syntax; it is the design decision that
shapes both APIs, and this lesson makes it explicit before it surprises you.

## 4. The Problem It Solves

Scalar values (one number, one flag) cannot hold a shopping basket. Before sequence types,
programs managed groups by inventing a variable per element — `item1`, `item2`, `item3` — which
collapses the moment the count is unknown. A list stores any number of values under one name,
with a *position* (index) addressing each. Strings face the opposite problem: text is naturally
sequential, and programs constantly reshape it — splitting input into words, joining words into
lines, trimming spaces. The methods in section 5.2 are that reshaping toolbox; before it
existed, every program hand-rolled character-by-character loops.

## 5. Core Concepts

### 5.1 Lists: ordered, addressable, growable

`xs = [88, 72, 95, 61]` creates a list; `xs[0]` addresses the first element (**0-based**, from
the machine's address arithmetic in
[01](../01-COMPUTER-FOUNDATIONS/binary-and-number-systems.md)), `xs[-1]` the last,
`xs[1:3]` a **slice** — elements 1 and 2, the stop index *excluded*, exactly like `range`. Key
operations:

| Operation | Result | Notes |
|---|---|---|
| `xs.append(x)` | adds to the end | **mutates** the list |
| `xs[i] = v` | replaces element `i` | mutates |
| `xs[1:3]` | new list of the middle | does **not** mutate |
| `len(xs)` | element count | any sequence |
| `x in xs` | membership test | works for strings too |

### 5.2 Strings: immutable, method-rich

Strings never change in place. `s.upper()` **returns a new string**; `s` itself is untouched.
Every "modification" follows that rule. The reshaping core:

| Method | Does | Example |
|---|---|---|
| `s.split()` | text → list of words (whitespace) | `"a  b".split()` → `['a', 'b']` |
| `"sep".join(xs)` | list → text with separators | `"-".join(['a','b'])` → `"a-b"` |
| `s.strip()` | removes leading/trailing whitespace | `" hi ".strip()` → `"hi"` |
| `s.replace(a, b)` | all occurrences → new string | `"hi ho".replace("h","H")` → `"Hi Ho"` |
| `x in s` | substring test | `'eema' in "Neema"` → `True` |

`split` and `join` are the inverse pair — the one-two punch of text processing: split on input,
transform the list, join on output.

### 5.3 Comprehensions: the transformation idiom

`[expr for x in xs if cond]` builds a new list in one line: filter with `if`, map with `expr`, or
both. It is the loops lesson's iteration in expression form, and it is how Python spells
"transform this sequence". `{...}` and `{k: v for ...}` forms build sets and dicts — met in
[04](../04-JAVA-PROGRAMMING/README.md)'s collections lesson and later subjects.

## 6. How It Works — mutability and the shared object

The binding model from lesson 4 explains the sequence asymmetry:

```text
list a = [1, 2]     a ──────┐
                            ▼
                        [1, 2]        a mutable object
                            ▲
list b = a           b ──────┘        b points at the SAME object

b.append(3)  →  both a and b now show [1, 2, 3]

string s = "hi"      s ──────┐
                            ▼
                        "hi"         immutable: cannot be changed
t = s.upper()        t ────── "HI"   a NEW object; s still points at "hi"
```

Because a list *can* change, two names on one list share every change. Because a string *cannot*
change, "modifying" it always produces a new value and rebinds — nothing shared ever changes
under you. That is why APIs pass strings freely and pass lists with care; the same care returns
in every language you will meet.

## 7. Practical Examples

All transcripts were **executed on the authoring machine** (Python 3.13.5, Windows 11, Git Bash).

**Example 1 — the list toolbox**

```python
scores = [88, 72, 95, 61]
scores.append(77)
print(f"after append: {scores}")
print(f"first: {scores[0]}, last: {scores[-1]}")
print(f"slice [1:3]: {scores[1:3]}")

scores[2] = 96
print(f"after update: {scores}")
print(f"count >= 75: {sum(1 for s in scores if s >= 75)}")
```

- `append` grows the list in place; the slice `[1:3]` returns `[72, 95]` — index 3 (`61`)
  excluded, the stop rule again. The last line filters and counts in one expression — a
  comprehension inside `sum`, the transformation idiom at work.
- **Expected output** (real):

  ```text
  after append: [88, 72, 95, 61, 77]
  first: 88, last: 77
  slice [1:3]: [72, 95]
  after update: [88, 72, 96, 61, 77]
  count >= 75: 3
  ```

- **How to run it:** save as `lists.py`, run `python lists.py`.
- **Assumptions:** Python 3.13.5 on the authoring machine; runs unchanged on Python 3.10+.

**Example 2 — string reshaping, and the immutability wall**

```python
full = "Neema  Said"
print(f"length: {len(full)}")
print(f"split: {full.split()}")
print(f"upper: {full.upper()}")
print(f"join: {' | '.join(['a', 'b', 'c'])}")
print(f"replace: {full.replace('Neema', 'Asha')}")
print(f"contains 'eema': {'eema' in full}")

greeting = "hello"
greeting[0] = "H"
```

- Note `split()` collapsed the *double* space — it splits on any run of whitespace, which is why
  it is the default tokenizer for free-form input.
- The last two lines hit the immutability wall **on purpose**, to capture the real error:
  assigning into a string is refused by the type itself.
- **Expected output** (real — the first six lines ran; the seventh is Python's refusal):

  ```text
  length: 11
  split: ['Neema', 'Said']
  upper: NEEMA  SAID
  join: a | b | c
  replace: Asha  Said
  contains 'eema': True
  Traceback (most recent call last):
    File "arr_strings.py", line 10, in <module>
      greeting[0] = "H"
      ~~~~~~~~~~~~^^^
  TypeError: 'str' object does not support item assignment
  ```

- **How to run it:** save as `strings.py`, run `python strings.py`; the traceback's final line
  is the interpreter stating the immutability rule in its own words.
- **Assumptions:** as Example 1. (The program exits non-zero after the `TypeError` — expected,
  since the last statement is deliberately invalid.)

**Example 3 — the transformation suite**

```python
words = ["code", "path", "masterclass"]
reversed_words = [w[::-1] for w in words]
print(f"reversed: {reversed_words}")

lengths = [len(w) for w in words]
print(f"lengths: {lengths}")

long = [w for w in words if len(w) > 4]
print(f"long only: {long}")

joined = "-".join(w.upper() for w in words)
print(f"joined: {joined}")
```

- `[w[::-1] for w in words]` reverses each word (the `-1` step walks backwards); the `if`
  version filters; the final line maps-then-joins — the split/transform/join pipeline from
  section 5.2 with no split needed.
- **Expected output** (real):

  ```text
  reversed: ['edoc', 'htap', 'ssalcretsam']
  lengths: [4, 4, 11]
  long only: ['masterclass']
  joined: CODE-PATH-MASTERCLASS
  ```

- **How to run it:** save as `transform.py`, run `python transform.py`.
- **Assumptions:** as Example 1.

## 8. Real-World Applications

Text pipelines are everywhere: log processing (`split()` lines, filter severities, `join()`
reports), CSV parsing (split on commas — though real CSV needs the `csv` module for quotes),
name normalisation (strip, title-case), slug generation (lower, replace spaces with `-`). Lists
carry everything else: query results, task queues, sensor readings, arguments. The
split-transform-join pattern is so fundamental that it reappears unchanged in Java streams
([04](../04-JAVA-PROGRAMMING/README.md)), JavaScript array methods
([08](../08-JAVASCRIPT-AND-TYPESCRIPT/README.md)), and SQL's whole model
([10](../10-DATABASE-ENGINEERING/README.md)).

## 9. Common Mistakes

| Mistake | Why it happens | How to recognize it | How to prevent it |
|---|---|---|---|
| `IndexError` at the end | Using `<=` with `len()` in an index | Off-by-one at the last element | `range(len(xs))` or iterate values |
| Confusing slice stop | Expecting `xs[1:3]` to include 3 | Always one element "missing" | Stop is excluded, exactly like `range` |
| `greeting[0] = "H"` | Treating strings like lists | `TypeError: 'str' object does not support item assignment` | Strings are immutable: `s = "H" + s[1:]` builds a new one |
| Mutation after aliasing | `b = a` then modifying `b` | `a` "changed too" — same object | Copy explicitly: `b = a.copy()` or `a[:]` |
| `+=` on strings in a loop | Looks like appending | Works, but quadratic cost | Collect parts, `join()` once — the idiom from 5.2 |

## 10. Best Practices

- **Iterate values** (`for s in scores`), not indexes, unless positions matter — no off-by-one
  possible.
- **Split on input, join on output**; avoid character-by-character loops when a method exists.
- **Treat slices as copies.** `xs[:]` or `xs.copy()` before passing a list you must not share.
- **Build strings with `join`,** never `+=` in a loop — same reasoning as the loop lesson's
  accumulation, with a real performance cliff.
- **Strip early.** User text gets `.strip()` at the boundary — trailing newlines from files are
  the classic hidden bug.

## 11. Limitations and Trade-Offs

Python lists are *arrays of references*: fast appends, but indexing is O(1) while inserting at
the front is O(n) — the performance model that [05](../05-DATA-STRUCTURES-AND-ALGORITHMS/README.md)
develops, where purpose-built structures (linked lists, deques) take over. Lists accept mixed
types, which is flexible and a typo-hiding hazard until the static types of Java and TypeScript
constrain it. Strings' immutability costs memory when transforming large text (every step makes
a copy), which is why real text processing at scale uses buffers or streams rather than a chain
of method calls. And comprehensions trade readability for concision past about two clauses — the
moment a comprehension needs a comment, it wants to be a loop.

## 12. Practical Exercises

### Introductory

1. **Predict the slice.** For `xs = [2, 4, 6, 8, 10, 12]`, predict `xs[2:5]`, `xs[:3]`, `xs[-2:]`,
   `xs[::2]`; then run. **Completion criteria:** four predictions, four real results,
   mismatches explained by start/stop/step.
2. **Split, transform, join.** Take `line = "  apple,banana,cherry  "`: strip it, split on `,`,
   title-case each fruit, and join with `" / "`. **Completion criteria:** the exact final string
   produced by a real run.

### Intermediate

3. **The aliasing test.** Reproduce section 6's list-aliasing (two names, one object, one
   `append`) from memory; then fix it with `.copy()` and show the names no longer share.
   **Completion criteria:** both transcripts — shared mutation and isolated copy.
4. **Immutability workaround.** Write `replace_first(s, old, new)` that returns `s` with the
   first occurrence replaced, without `.replace()` (string concatenation or slicing only).
   **Completion criteria:** correct on `"aXaX"`, `"nothing"`, and an empty string; original
   variable unchanged in each case.

### Independent problem-solving

5. **Build a word-frequency counter.** *Read a paragraph (a multi-line string literal), convert
   to lowercase, strip punctuation (`.strip(".,!?;:")` per word), drop words shorter than 3
   characters, then print the 5 most common words with counts, and the longest word.* Use
   `split`, comprehensions, and `join`; no imports. **Completion criteria:** counts verified by
   hand for at least three words; ties broken deterministically (state your rule); output lines
   aligned.

*Solutions: attempt first. They live in `solutions/` of this subject.*

## 13. Knowledge Check

1. `xs = [1,2,3]; ys = xs; ys.append(4)` — what is `xs` afterwards, and why? What would have
   happened if they were strings?
2. Why does `"hi".upper()` need an assignment (`s = s.upper()`) to "stick"?
3. State the stop-excluded rule once, and give the slice that yields exactly the last three
   elements of any list.
4. When is `"".join(parts)` the right shape instead of `result += piece` in a loop? What is the
   cost argument?
5. Give one situation where mixed-type lists *help*, and one where they *hurt*.

## 14. Completion Criteria

- [ ] You can predict any index, slice, or `range`-combination on a list before running it
- [ ] You can reshape arbitrary text with split/strip/join without trial and error
- [ ] You can explain mutability asymmetry using the binding diagram, and demonstrate both
      behaviours in code
- [ ] You can write a filter-map-join pipeline from a blank editor

## 15. Summary

- Lists are ordered, mutable, 0-addressed sequences: `append`/index-assign mutate, slices copy.
- Strings are immutable: every "change" returns a new value; `TypeError` enforces it.
- `split`/`join` are the inverse pair that anchors all text processing.
- Comprehensions are the transformation idiom: filter with `if`, map with `expr`.
- Aliasing explains shared-list surprises; copy explicitly when sharing is not wanted.

## 16. Next Steps

- Next lesson: [debugging-fundamentals.md](debugging-fundamentals.md) — when these programs
  misbehave: reading errors, forming hypotheses, and finding the bug on purpose.
- Practice: [exercise set](exercises/README.md) for this subject's lessons.
- Where it is applied: collections in [04](../04-JAVA-PROGRAMMING/README.md) and
  [08](../08-JAVASCRIPT-AND-TYPESCRIPT/README.md); array methods in
  [08](../08-JAVASCRIPT-AND-TYPESCRIPT/README.md); SQL row sets in
  [10](../10-DATABASE-ENGINEERING/README.md).
