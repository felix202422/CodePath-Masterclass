# Solutions — Set 12: Modular Programming (Capstone)

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.
> This set is the subject capstone: it uses every lesson — planning, sequences, functions,
> validation-shaped design, debugging discipline, and module boundaries.

## Exercise 1 — Split a single-file program

**Answer.** The split: move every function into `helpers.py` (definitions only, zero top-level
output); keep the entry point's demo calls in the original file (or a new `main.py`) under the
guard. The import line at the top — `from helpers import ...` — is the visible dependency.
Criterion evidence: the program's output is unchanged *and* `python -c "import helpers"` prints
nothing.

**Criteria check:** ☐ runs unchanged ☐ library silent on import.

## Exercise 2 — Predict the guard

**Answer.**

| Scenario | `__name__` during import | Prints |
|---|---|---|
| Top-level `print` in `report.py` | `"report"` | the demo output — a surprise for every importer |
| Print under the guard | `"report"` | nothing; the guard compares against `"__main__"` |
| Running `python report.py` | `"__main__"` | the demo output — the guard's one legitimate firing |

The values to state: run → `"__main__"`; import → the module's own filename without `.py`.

**Criteria check:** ☐ two predictions ☐ real run ☐ both `__name__` values stated.

## Exercise 3 — Two ways to break an import

**Answer.**

Variant A (typo) — real traceback, read bottom-up:

```text
    import calculationz
ModuleNotFoundError: No module named 'calculationz'
```

Cause: the searched name does not exist — the module is `calculations`. Check order: **1) the
name spelled in the import, 2) the file's location relative to where Python was started, 3) the
working directory you ran from** (variant B breaks exactly here: correct spelling, file exists,
but `python /path/main.py` from another directory means the file's directory is on the search
path while *your* current directory is not — the message is identical because Python reports the
name it could not find, never the reason).

**Criteria check:** ☐ two tracebacks ☐ causes named ☐ first-check rule stated (name → location →
working directory).

## Exercise 4 — Capstone: expense tracker (independent)

**Answer.** One reference implementation, executed on the authoring machine (Python 3.13.5).
`expenses.py` — definitions only; `report.py` — `from expenses import ...`; `main.py` — demo
data and the guard. Evidence for each criterion:

**Silent imports** (`python -c "import expenses"` and `import report` — each prints only our
confirmation line):

```text
silent import OK
silent import OK
```

**The report** (`python main.py`, real):

```text
=== Expense report ===
entries: 4
total:   14500.00 TZS
average: 3625.00 TZS
by category:
  food        10000.00
  supplies     3000.00
  transport    1500.00
```

**Hand verification** (the criterion demands it — computed by hand before trusting the program;
the program's values match):

```text
total = 14500      (hand: 7500 + 1500 + 3000 + 2500 = 14500)
average = 3625.0   (hand: 14500 / 4)
by category: food = 7500 + 2500 = 10000; transport = 1500; supplies = 3000
```

**Module diagram** (one-directional, no cycles):

```text
main.py ──imports──▶ report.py ──imports──▶ expenses.py
   (entry point)        (formats)             (computes)
```

Empty-input behaviour defined in the design: `average([])` returns `None` and the report prints
`average: n/a` — the empty case is a *designed* output, not a crash (loops lesson's rule,
functions lesson's contract, applied at module scale).

**Criteria check:** ☐ `import expenses` silent ☐ `import report` silent ☐ `main.py` prints the
report ☐ statistics hand-verified ☐ diagram drawn, arrows one-directional.

**Why this earns the capstone mark:** the module boundaries match responsibilities (computes /
formats / wires), the library files impose zero surprise on importers (the guard and
definitions-only top level both doing their job), and every number was checked against
arithmetic done *before* the program ran — planning (sets 1–2), the discipline of verification
(set 11), and modular structure (this set) working as one practice.
