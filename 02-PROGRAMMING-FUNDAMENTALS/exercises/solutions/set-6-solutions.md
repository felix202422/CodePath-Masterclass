# Solutions — Set 6: Input and Output

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.

## Exercise 1 — Predict the crash, fix it

**Answer.** `text = input("n: ")` then `print(text * 2)` for input `21` prints `2121` — string
repetition, not multiplication: `"21" * 2` joins the text with itself. It does **not** raise;
it silently answers the wrong question, which is worse. Fix: `n = int(text)` then `print(n * 2)`
→ `42`.

**Criteria check:** ☐ prediction (`2121`, not an error) ☐ matches the real run ☐ fixed version
prints 42.

**Reviewer note:** this is the "quiet wrong answer" cousin of the `TypeError` — types can
silently *succeed* at the wrong thing (`*` on strings) as loudly as they fail.

## Exercise 2 — Four specs

**Answer.** With `pi = 3.14159`, `n = 1234567`, `rate = 0.0725`, `label = "TSH"`:

```python
print(f"{pi:.2f}")      # 3.14
print(f"{n:,}")         # 1,234,567
print(f"{rate:.1%}")    # 7.3%        (0.0725 * 100 = 7.25 -> one decimal: 7.3)
print(f"{label:<8}|")   # TSH     |
```

**Criteria check:** ☐ four specs ☐ real output captured ☐ rounding of 7.25 → 7.3 explained
(0.5 rounds to even in f-strings — try `{0.125:.2f}` to see it).

## Exercise 3 — The retry loop

**Answer.** Shape (the lesson's Example 2 pattern, with distinct messages):

```python
while True:
    raw = input("age (0-120): ")
    try:
        age = int(raw)
    except ValueError:
        print(f"  '{raw}' is not a whole number")
        continue
    if 0 <= age <= 120:
        break
    print(f"  {age} is outside 0-120")
print(f"accepted: {age}")
```

Run with `abc`, `200`, `30`: message 1 (content — quotes the typed text), message 2 (range —
quotes the converted number), then `accepted: 30`.

**Criteria check:** ☐ distinct messages per failure kind ☐ ends on valid ☐ transcript captured.

## Exercise 4 — Mini calculator (independent)

**Answer.** Key decisions and their evidence:

- Two retry loops, one per number (reuse the shape above); one for the operator, validating
  membership in `"+-*/"` — three attack inputs (`abc` for a number, `q` for the operator,
  division by zero) each produce a message and a fresh prompt.
- Division by zero is checked **after** conversion, before computing: `if op == "/" and b == 0:
  print("  cannot divide by zero"); continue`.
- Output names the operator: `print(f"{a} {op} {b} = {result:.2f}")` — with `.2f` so `17 / 5`
  shows `3.40`, not `3.4`, in a column of results.

Five demonstration pairs: `17 + 5 = 22.00`, `17 - 5 = 12.00`, `17 * 5 = 85.00`, `17 / 5 =
3.40`, and `10 / 0` → your message and re-ask.

**Criteria check:** ☐ survives non-numeric ☐ survives bad operator ☐ survives `/0` ☐ five
combinations correct ☐ named-operator output format.
