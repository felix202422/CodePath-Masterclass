# Solutions — Set 11: Debugging Fundamentals

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.

## Exercise 1 — Traceback anatomy

**Answer.** From the real run of the lesson's Example 1:

```text
Traceback (most recent call last):
  File "dbg_traceback.py", line 4, in <module>
    total += p
    ^^^^^^^^^^
TypeError: unsupported operand type(s) for +=: 'int' and 'str'
```

Four parts: **error type** (`TypeError`) — the class of failure; **message** (`+=` got `int`
and `str`) — what the operation received; **location** (line 4, `total += p`) — where it was
detected; **frames** (here one, `<module>`) — the call chain, innermost last. The fix: the *data*
holds `"thirty"` where a number belongs — change it to `30`; the loop is innocent.

**Criteria check:** ☐ four parts labelled on real output ☐ fix names the data, not the line.

## Exercise 2 — Classify five bugs

**Answer.**

| Bug | Class | Tool |
|---|---|---|
| Missing colon after `if` | **syntax** | the message + the line; nothing runs |
| Division by zero | **runtime** | traceback; add a guard after reading it |
| Wrong formula (discount added) | **logic** | hypothesis + instrumentation; nothing crashes |
| `totl` used immediately | **runtime** (`NameError`) | the traceback names the misspelling |
| Off-by-one total | **logic** | boundary reasoning; silent wrong answer |

**Criteria check:** ☐ five classifications ☐ tool named per class.

## Exercise 3 — Bisect the low average

**Answer.** Process: expectation first — average of `[10, 20, 30]` over 15 should be `25.0`.
Probe at the midpoint of the data path (`print(total, count)` after the loop): suppose it shows
`60 3` — total is right, so the cause is *after* the accumulation: `total / count`… that is
correct too. Re-probe inside the loop (`print(p, total)`): `30 30` — on the third pass `total`
*replaced* rather than accumulated. Root cause: `total = p` instead of `total += p`. Fix, rerun:
`25.0`; verify on `[5, 25]` → `25.0`. ✓ (Two bisection rounds: the probe halved the path from
input → accumulate → report.)

**Criteria check:** ☐ probe shown ☐ inference stated per round ☐ root cause confirmed ☐ second
list verified.

## Exercise 4 — The delivered bug, full cycle (independent)

**Answer.** Written as performed (all figures below verified by running the program):

1. **Reproduce:** run the given program → prints `15.0`, not the required `25.0`. Same every
   run. (Expected, from the requirement: values over 15 are 20 and 30; their average is 25.)
2. **Classify:** no error, exit 0, wrong answer → **logic**. Tool: evidence, not tracebacks.
3. **Hypothesise (one):** "`total = p` assigns instead of accumulates" — a single, falsifiable
   claim.
4. **Test (smallest):** `print(total, p)` inside the loop. Output `0 10`, `20 20`, `30 30` —
   total tracks the *last passing* value (10 never assigns: it fails `p > 15`). Hypothesis
   confirmed; nothing else needed changing.
5. **Verify and clean up:** fix to `total += p`; original list → `25.0`; second list `[5, 25]` →
   `25.0`; delete the debug print.

**Statement:** class = logic bug; cause = assignment where accumulation was intended, at the
loop's `total = p` line — invisible to the interpreter because every step was individually legal.

**Criteria check:** ☐ five cycle steps as performed ☐ both lists correct after fix ☐ class and
cause stated.
