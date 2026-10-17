# Solutions — Set 7: How Programs Execute

> ⚠ Attempt first; rebuild cold in a week.

## Exercise 1 — Redrawn cycle

**Answer.** Four stages — **FETCH** (program counter names the address; instruction read from
memory), **DECODE** (control unit interprets the bits), **EXECUTE** (ALU/data movement/device
access), **UPDATE** (result stored; program counter advanced or jumped) — then back to fetch. The
PC's path: incremented by default, overwritten on a taken jump.

**Criteria check:** ☐ four stages ☐ PC path drawn (including the jump overwrite).

## Exercise 2 — Five classifications

| Failure | Kind | Reported by |
|---|---|---|
| Missing bracket | Syntax | Translator (compiler/parser) — never runs |
| Null pointer during save | Runtime | Execution-time check — runs, then fails |
| Invoice total 10× too high | Logic | Nobody — tests/review catch it |
| File not found on load | Runtime | Execution (system call result) — runs, then fails |
| Typo in variable name | Syntax (static) | Compiler: the name is not declared — never runs |

**Criteria check:** ☐ five kinds correct ☐ reporting stage named.

**Reviewer note:** learners most often misfile the missing file as "syntax" — it is runtime: the
*program text* is valid; the *environment* answered with a failure.

## Exercise 3 — Jump-taken trace

With `CMP` comparing A (=10) against 10, the flag says equal:

```text
PC=100  LOAD  7    → A=7
PC=101  ADD   5    → A=10
PC=102  CMP   10   → flag=true (equal)
PC=103  JEQ   106  → TAKEN: program counter := 106
PC=106  (whatever instruction lives there; 104 and 105 are SKIPPED)
```

**Final state:** A = 10; **memory[9] is never written** (STORE at 104 was skipped); the program
continues at 106.

**Criteria check:** ☐ complete PC-by-PC trace ☐ jump fired ☐ location 9 unwritten (the key
insight: one changed flag changed the outcome).

## Exercise 4 — The diagnosis protocol (independent)

**Answer.**

**(a) Classification:** this is a **logic failure**, established *before* investigating:
- It is not syntax — the build passed (translation succeeded).
- It is not runtime — the program runs and completes ("produces totals", does not fail).
- Therefore the wrong *idea* or wrong *data* is being executed successfully.

**(b) First three actions:**
1. Reproduce minimally: capture one input that yields a wrong total and one that does not (the
   "some inputs but not others" split is the strongest clue — find what distinguishes them).
2. Verify expectations with a test: write down the correct total by hand for that input, then
   assert it — converting "wrong" from opinion to a failing test (the regression harness for every
   later step).
3. Bisect the suspects: inspect the computation path for that input class — boundary/rounding/
   conditional branches — and compare against the input class that works.

**(c) What the passing build proves:** the text is grammatically valid and type-checks; it proves
*nothing* about intent. Explicitly: build success rules out syntax failures and rules out nothing
about logic — a fact beginners reliably over-trust.

**Criteria check:** ☐ classification with reasoning ☐ three ordered actions ☐ explicit statement of
what the build result rules in/out.

**Reviewer note:** the strongest answers start from the "some inputs" split — a differential clue
is worth more than any amount of staring at code.

---

Back to the sets: [../README.md](../README.md)
