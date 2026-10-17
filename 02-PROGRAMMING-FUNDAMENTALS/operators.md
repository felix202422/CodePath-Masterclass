# Operators

## 1. Learning Objectives

After this lesson you will be able to:

- [ ] Use Python's arithmetic operators, predicting `/` vs `//` vs `%` without running them
- [ ] Apply comparison and logical operators, and state Python's precedence and associativity rules
- [ ] Predict the results of chained expressions (`2 ** 3 ** 2`, `10 - 3 - 2`) with the rules, not
      by guessing
- [ ] Exploit `%` and `//` for the classic tasks: parity, last digit, digit extraction, clock
      arithmetic

## 2. Prerequisites

- [variables-and-data-types.md](variables-and-data-types.md) — values and types; operators are
  what you do *with* values.
- [../01-COMPUTER-FOUNDATIONS/logic-and-boolean-algebra.md](../01-COMPUTER-FOUNDATIONS/logic-and-boolean-algebra.md)
  — AND/OR/NOT and precedence, which Python spells `and`, `or`, `not`.

## 3. An **operator** is a symbol that computes a value from other values: `+`, `-`, `*`, `==`,
`and`. This lesson covers Python's full set of everyday operators and, more usefully, the *rules*
that decide what a compound expression evaluates to — because the difference between reading
expressions and guessing them is the difference between programs you trust and programs you
babysit.

## 4. The Problem It Solves

Human arithmetic notation carries assumptions programs cannot make: `17 / 5` is "3.4" to you but
needs a defined answer in a machine; `10 - 3 - 2` must specify whether it means `(10-3)-2` or
`10-(3-2)`; and `2 + 3 * 4` needs an agreed order or every programmer would ship a different
program. Operator rules exist so that every reader predicts the same result — and `%` (remainder)
exists because many real questions ("is this ID odd?", "does this row start a new page?") are
remainder questions wearing arithmetic clothes.

## 5. Core Concepts

### 5.1 Arithmetic operators

| Operator | Name | Example | Result | Watch out |
|---|---|---|---|---|
| `+` | addition | `17 + 5` | `22` | Also joins strings (from lesson 4) |
| `-` | subtraction | `17 - 5` | `12` | Unary `-` makes negatives |
| `*` | multiplication | `17 * 5` | `85` | Also repeats strings: `"ha" * 3` |
| `/` | true division | `17 / 5` | `3.4` | **Always** returns `float` |
| `//` | floor division | `17 // 5` | `3` | Rounds toward **minus infinity**, not zero |
| `%` | remainder (modulo) | `17 % 5` | `2` | Sign follows the **divisor** |
| `**` | exponentiation | `17 ** 5` | `1419857` | Binds tighter than unary minus |

`//` and `%` always come as a pair: `a == (a // b) * b + a % b`, for any `b ≠ 0`. That identity
is how digit extraction works, and it holds even for negatives — where `//` rounds down, not
toward zero: `-3 // 4` is `-1`, and `-3 % 4` is `1` (the remainder always takes the divisor's
sign, staying non-negative for a positive divisor).

### 5.2 Comparison operators

`==` (equal), `!=` (not equal), `<`, `>`, `<=`, `>=` produce `bool`. Three rules that settle most
confusions:

1. **Comparisons chain** in Python: `0 <= x < 100` means `0 <= x and x < 100` — the idiomatic
   range test, no repeated variable.
2. **`==` compares value, `is` compares identity** (same object). Use `==` for numbers and text;
   reserve `is` for `None` checks.
3. **Cross-type equality is `False`, not an error**: `"7" == 7` is `False`. Python draws the type
   line quietly here and loudly in arithmetic (lesson 4's `TypeError`).

### 5.3 Logical operators and precedence

`and`, `or`, `not` from the Boolean lesson, with Python's official precedence, tightest first:

```text
**           exponentiation
+x, -x       unary sign
* // % + -   multiplication family, then addition family (left to right)
< <= > >= == !=   comparisons (chainable, non-associative)
not          logical not
and          logical and
or           logical or
```

Two precedence results worth memorising because they surprise: `2 ** 3 ** 2` is `512`, not `64`
(`**` is right-associative: `2 ** (3 ** 2)`), and `not` binds looser than comparisons, so
`not x == y` equals `not (x == y)`. When precedence is not doing visible work, parentheses are
free — use them for readers, including future-you.

## 6. How It Works — evaluating an expression by the rules

Expression: `not 2 + 3 * 4 == 14 or 10 % 3 == 1`

```text
Step 1:  3 * 4        = 12        multiplication family first
Step 2:  2 + 12       = 14        addition
Step 3:  14 == 14     = True      comparisons before 'not'
Step 4:  not True     = False     logical not
Step 5:  10 % 3       = 1         remainder
Step 6:  1 == 1      = True      comparison
Step 7:  False or True = True     'or' is loosest
```

Every step cites a rule from section 5.3; that citation habit is what makes expression-reading a
skill rather than a gamble.

## 7. Practical Examples

All transcripts were **executed on the authoring machine** (Python 3.13.5, Windows 11, Git Bash).

**Example 1 — the seven arithmetic operators**

```python
a, b = 17, 5
print(f"{a} + {b} = {a + b}")
print(f"{a} - {b} = {a - b}")
print(f"{a} * {b} = {a * b}")
print(f"{a} / {b} = {a / b}")
print(f"{a} // {b} = {a // b}")
print(f"{a} % {b} = {a % b}")
print(f"{a} ** {b} = {a ** b}")
```

- `/` gives `3.4` (float) where `//` gives `3` (int) — same operands, two different contracts.
- `17 % 5 = 2` confirms the identity: `3 * 5 + 2 = 17`.
- **Expected output:**

  ```text
  17 + 5 = 22
  17 - 5 = 12
  17 * 5 = 85
  17 / 5 = 3.4
  17 // 5 = 3
  17 % 5 = 2
  17 ** 5 = 1419857
  ```

- **How to run it:** save as `arithmetic.py`, run `python arithmetic.py`.
- **Assumptions:** Python 3.13.5 on the authoring machine; runs unchanged on Python 3.10+.

**Example 2 — precedence: predict first, then run**

```python
print(f"2 + 3 * 4 = {2 + 3 * 4}")
print(f"(2 + 3) * 4 = {(2 + 3) * 4}")
print(f"10 - 3 - 2 = {10 - 3 - 2}")
print(f"2 ** 3 ** 2 = {2 ** 3 ** 2}")

print(f"-3 % 4 = {-3 % 4}")
```

- `10 - 3 - 2 = 5`: subtraction is left-associative, `(10 - 3) - 2`. An operator whose
  right-associative reading gives `9` would be a different language, not a different opinion.
- `-3 % 4 = 1`, not `-3`: the remainder takes the divisor's sign — the rule from 5.1, visible.
- **Expected output:**

  ```text
  2 + 3 * 4 = 14
  (2 + 3) * 4 = 20
  10 - 3 - 2 = 5
  2 ** 3 ** 2 = 512
  -3 % 4 = 1
  ```

- **How to run it:** save as `precedence.py`, run `python precedence.py`.
- **Assumptions:** as Example 1.

**Example 3 — comparison and logic**

```python
x = 7
print(f"x == 7: {x == 7}")
print(f"x != 5: {x != 5}")
print(f"x > 3 and x < 10: {x > 3 and x < 10}")
print(f"x >= 7 or x == 100: {x >= 7 or x == 100}")
print(f"not (x == 7): {not (x == 7)}")

print(f"1 == 1.0: {1 == 1.0}")
print(f'"7" == 7: ', end="")
print("7" == 7)
```

- `1 == 1.0` is `True`: same value, different types — comparison cares about value.
- `"7" == 7` is `False`: quiet type boundary (rule 3 of 5.2), unlike arithmetic's loud
  `TypeError`.
- **Expected output:**

  ```text
  x == 7: True
  x != 5: True
  x > 3 and x < 10: True
  x >= 7 or x == 100: True
  not (x == 7): False
  1 == 1.0: True
  "7" == 7: False
  ```

- **How to run it:** save as `compare.py`, run `python compare.py`.
- **Assumptions:** as Example 1. (The chained form `3 < x < 10` works identically; try it.)

## 8. Real-World Applications

Remainder arithmetic powers real features: pagination (`row % page_size == 0` starts a new
page), alternating row colours (`i % 2 == 0`), ID validation digits, schedule cycling ("which
day is 100 days from now?"), and bucketing readings into fixed-width bins with `//`. Comparisons
drive every validation rule (`0 <= score <= 100`), and the logical operators implement the
allow/deny policies of [15](../15-APPLICATION-SECURITY/README.md). Precedence errors are a
standard source of the logic bugs that
[14](../14-TESTING-AND-QUALITY/README.md) exists to catch.

## 9. Common Mistakes

| Mistake | Why it happens | How to recognize it | How to prevent it |
|---|---|---|---|
| `10 / 5 * 2` expected as `1` | Reading `/` as "divide the rest" | Result `4.0`, not `1` | `/ *` are the same precedence, left-to-right; parenthesise intent |
| `==` vs `=` in conditions | One equals everywhere else | `SyntaxError: invalid 'comparison with empty'`-style message; in C-family, silent | Python refuses `if x = 5` at parse time; never fight the message |
| Wrong sign from `%` on negatives | Assuming remainder keeps the dividend's sign | `-3 % 4` is `1`, not `-3` | Remember: sign follows the divisor; test negatives once |
| `2 ** 3 ** 2 = 64` | Assuming left-associative power | Actual result `512` | `**` is right-associative: `2 ** (3 ** 2)`; write the parentheses |
| Chaining `==` between lists | Translating math notation literally | `[1,2] == [1,2]` is True, but `0 < len(x) < 3` is the chain that works | Chain comparisons, never chain `==`; test each equality separately |

## 10. Best Practices

- **Parenthesise mixed precedence** whenever a reader could hesitate — `a and (b or c)` costs
  nothing.
- **Use Python's comparison chaining** for ranges: `0 <= score <= 100` reads like the
  requirement and cannot drift from it.
- **Reach for `%` and `//` instead of converting to strings** for digit work — arithmetic is
  faster and exact.
- **Test operator edge cases once, deliberately**: negatives, zero, and one. Most operator bugs
  live there.
- **Let `is` mean `None`.** `if value is None` is idiomatic; `if value is 5` is not (and modern
  Python warns about it).

## 11. Limitations and Trade-Offs

Python's operators are readable but hide cost: `**` on huge integers is *exact* but slow, and
float arithmetic is fast but approximate (01's binary lesson). Operator overloading — the same
symbols meaning different things for different types (`+` on numbers vs strings vs lists) — is
powerful once types multiply, and becomes a source of confusion that the static type system of
[04](../04-JAVA-PROGRAMMING/README.md) helps contain. Precedence rules themselves are a trade-off:
fewer parentheses, more memorisation; when a rule is genuinely ambiguous to human readers, no
amount of official precedence makes the code *clear*.

## 12. Practical Exercises

### Introductory

1. **Predict the family.** Without running: results of `20 / 6`, `20 // 6`, `20 % 6`, `6 % 20`,
   `-20 // 6`, `-20 % 6`. Then verify all six. **Completion criteria:** your six predictions and
   the interpreter's six results, with mismatches explained by the sign or rounding rule.
2. **Parity and digits.** Using `%` and `//` on `n = 4827`: extract the last digit, the second
   digit, and state whether `n` is odd. **Completion criteria:** three correct values, each with
   the expression that produced it.

### Intermediate

3. **Rewrite with chains.** Convert `x >= 0 and x <= 100` and `y < 1 and y > -1` to Python's
   chained form; evaluate both for `x = 50`, `y = -0.5`. **Completion criteria:** chained
   expressions written, results confirmed by a run.
4. **Diagnose the precedence bug.** Intent: "total is over 100 *and* either urgent or a repeat
   customer". Written: `total > 100 and urgent or repeat`. Build a case where the code says True
   but the intent says False (a small truth table will find one), then parenthesise correctly.
   **Completion criteria:** counterexample row, corrected expression, and the De Morgan/precedence
   rule that explains the bug.

### Independent problem-solving

5. **Clock arithmetic.** Requirement: *given the current hour (0–23) and a duration in hours
   (positive or negative), print the hour on a 24-hour clock, and the same on a 12-hour clock
   ("3 o'clock").* Use `%` — no `if` statements allowed. **Completion criteria:** correct for
   positive, negative, and wrap-around cases (`(23 + 5) % 24` is 4); no conditionals anywhere;
   five test pairs shown with results.

*Solutions: attempt first. They live in `solutions/` of this subject.*

## 13. Knowledge Check

1. `17 / 5` and `17 // 5` differ in type *and* value — name both differences.
2. Why does `-3 % 4` equal `1`? State the rule, not the arithmetic.
3. What is `2 ** 3 ** 2`, and why is it not `64`?
4. Give the chained-comparison form of `age > 17 and age < 65`, and say why it beats the two-part
   version.
5. `x == y` and `x is y` — which for numbers, which for `None`, and what goes wrong with the
   wrong choice?

## 14. Completion Criteria

- [ ] You can predict all seven arithmetic operators' results including negative operands
- [ ] You can evaluate a compound expression step by step, citing the precedence rule each time
- [ ] You can use `%` and `//` for parity, digit extraction, and clock arithmetic without
      conditionals
- [ ] You can state the three comparison rules (chaining, `==` vs `is`, cross-type equality)

## 15. Summary

- `/` always yields float; `//` floors toward minus infinity; `%` takes the divisor's sign.
- `**` is right-associative and binds tighter than unary minus; comparisons chain; `not` < `and`
  < `or` in looseness.
- `==` compares values (cross-type gives `False`), `is` compares identity — `None` checks only.
- `%` and `//` are the digit-and-schedule toolbox: parity, extraction, wrap-around.
- Parentheses are free clarity; test edge operands (negatives, zero, one) deliberately.

## 16. Next Steps

- Next lesson: [input-and-output.md](input-and-output.md) — getting values in from a person and
  showing results back, formatted.
- Practice: [exercise set](exercises/README.md) for this subject's lessons.
- Where it is applied: modulo arithmetic powers pagination and scheduling in
  [11](../11-BACKEND-ENGINEERING/README.md); operator precedence bugs are caught by tests in
  [14](../14-TESTING-AND-QUALITY/README.md).
