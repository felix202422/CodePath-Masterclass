# Exercises — 02 Programming Fundamentals

**Lessons:** this subject's twelve lessons, in order.
**How to use these sets:** attempt first; solutions live in
[solutions/](solutions/README.md) behind a warning. The 15-minute rule from
[learning-method](../../00-START-HERE/learning-method.md) applies — record which hint you used.

Each set corresponds to the lesson named in its title and mirrors that lesson's exercise ladder
(introductory → intermediate → independent) with observable completion criteria. Sets 1–11 end at
independent design problems; Set 12 is the subject capstone that combines every lesson. Completing
all twelve sets *is* the subject's completion gate in [ROADMAP.md](../../ROADMAP.md).

Every Python example in these sets is meant to be **run** — the subject's policy, matching
[VERSIONS.md](../../VERSIONS.md): transcripts you produce on your machine are your evidence.

---

## Set 1 — Computational thinking → `computational-thinking.md`

1. Decompose "find the longest word in a sentence" into 4–6 parts with stated inputs/outputs.
   **Criteria:** every part one sentence; last part observable.
2. Classify three tasks (discount each purchase / find largest / count over 100) by shared
   pattern or not, with reasons. **Criteria:** one-sentence reason per task.
3. Name one detail that would make "email receipts" and "email reminders" a bad shared
   abstraction. **Criteria:** shared + differing detail, each justified.
4. **Independent:** plan (no code) the text-report generator — decomposition, patterns,
   abstractions, algorithm covering normal/empty/invalid input. **Criteria:** every input case
   has defined behaviour and output.

## Set 2 — Algorithms and pseudocode → `algorithms-and-pseudocode.md`

1. Hand-trace linear search for `target = 9` in `[7, 2, 9, 4, 9]`; confirm by running.
   **Criteria:** table matches the real program's printed trace.
2. State binary search's worst-case comparisons for 1,000,000 items with halving arithmetic.
   **Criteria:** ~20 with the reasoning shown; linear contrast given.
3. Add empty-list and all-larger-than-target cases to a search pseudocode. **Criteria:** each
   case returns a defined value with a trace row.
4. **Independent:** pseudocode + hand-trace + Python implementation of the text-report
   generator; real output must match the trace line for line. **Criteria:** trace and program
   agree; both edge cases behave as written.

## Set 3 — Flowcharts → `flowcharts.md`

1. Trace the grade flowchart for scores 90, 80, 60, 0 — diamonds in visit order.
   **Criteria:** each score mapped to its letter via the exact decision path.
2. Sketch the five standard shapes and label each. **Criteria:** all five correct; decision
   drawn with two exits.
3. Fix the "print evens 1..10" chart missing its exit edge: name the code-level symptom, add
   the edge. **Criteria:** symptom = infinite loop; corrected chart has both edges.
4. **Independent:** chart-first validator for temperature readings (invalid / freezing / cold /
   mild / hot), then implement and test six inputs. **Criteria:** chart and code agree on every
   branch; edge cases traced through their diamond.

## Set 4 — Variables and data types → `variables-and-data-types.md`

1. Trace `x = 10; x = x * 2; x = "ten"` — value and type after each line; verify with `type()`.
   **Criteria:** three states predicted correctly.
2. Determine and record the type of six values (`10`, `10.0`, `"10"`, `True`, `None`, `10+0.0`).
   **Criteria:** six types; why `10 + 0.0` yields float, explained.
3. Reproduce a `TypeError` and a `ValueError` yourself; capture both messages, labelled
   wrong-kind / wrong-content. **Criteria:** two real messages, correct labels.
4. **Independent:** receipt summariser from string inputs — convert, compute, format; extend to
   three lines with a total; non-numeric input handled clearly. **Criteria:** deliberate
   conversions; two-decimal exactness; aligned lines.

## Set 5 — Operators → `operators.md`

1. Predict six results (`20 / 6`, `20 // 6`, `20 % 6`, `6 % 20`, `-20 // 6`, `-20 % 6`); verify.
   **Criteria:** six predictions, six real results, mismatches explained by sign/rounding rules.
2. From `n = 4827`: last digit, second digit, odd/even — using only `%` and `//`.
   **Criteria:** three correct answers with expressions shown.
3. Rewrite two range checks as chained comparisons; evaluate for sample values.
   **Criteria:** chained forms written; results confirmed by run.
4. **Independent:** counterexample + parenthesised fix for `total > 100 and urgent or repeat`
   versus the stated intent. **Criteria:** truth-table row proving the bug; corrected expression;
   precedence rule named.
5. **Independent (clock):** hour-after-N-hours calculator with `%` only, no conditionals —
   24-hour and 12-hour outputs. **Criteria:** wrap-around and negative cases correct; five test
   pairs shown; zero `if` statements.

## Set 6 — Input and output → `input-and-output.md`

1. Predict `input()` + `* 2` for typed `21`; fix with conversion. **Criteria:** prediction
   matches run; fixed version prints `42`.
2. Format four values with the fitting spec each (`.2f`, `,`, `.1%`, left-align).
   **Criteria:** all four specs applied; real output captured.
3. Age-input retry loop with distinct messages for non-numeric and out-of-range. **Criteria:**
   `abc` → `200` → `30` produces the designed sequence; ends on valid.
4. **Independent:** mini calculator — two numbers + operator, retry loops, division-by-zero and
   bad-operator handling, named-result output. **Criteria:** survives all three attack inputs;
   five combinations shown correct.

## Set 7 — Conditional statements → `conditional-statements.md`

1. Predict `shipping()` results for `-1`, `9.999`, `10.0`, `49.999`, `100`; run and compare.
   **Criteria:** five predictions, five actuals, boundary explanations.
2. Predict truthiness of `"False"`, `{}`, `[0]`, `0j`, `""`, `" "`; verify with `bool()`.
   **Criteria:** six predictions; the surprising one explained.
3. Fix the shadowed chain (`>= 60` before `>= 90`); make all outcomes reachable.
   **Criteria:** diagnosis names first-true-wins; 95 yields honours in a real run.
4. **Independent:** ticket pricer — time-based tiers, age discounts, group discount, with
   validated inputs. **Criteria:** six rule-traceable combinations; boundary ages 11/12, 64/65;
   combined rules verified.

## Set 8 — Loops → `loops.md`

1. Predict three `range` lists; verify. **Criteria:** three predictions, three results,
   start/stop/step explanations.
2. Loop over `"programming"` printing index and character. **Criteria:** 10 lines, positions
   0–9.
3. Reproduce the off-by-one; fix twice (corrected `range`, then value iteration).
   **Criteria:** both fixes print 14; one sentence on why value iteration cannot off-by-one.
4. **Independent:** statistics reporter — sentinel input, count/min/max/mean, `*` histogram,
   empty-input message. **Criteria:** empty case handled; stats hand-checked; histogram verified;
   no libraries beyond `len/min/max/sum`.

## Set 9 — Functions and methods → `functions-and-methods.md`

1. Write `celsius_to_f(c)` from blank editor; print 0, 37, 100 results.
   **Criteria:** 32.0 / 98.6 / 212.0; function computes, call site prints.
2. Classify five snippets as return / print / wrong, with reasons.
   **Criteria:** each justified by the compute-vs-report rule.
3. Reproduce the mutable-default bug; fix with `None`; extend to accept a starter list.
   **Criteria:** fresh lists per call; supplied list extended.
4. **Independent:** `mean` / `median` / `mode_of` module — empty-input behaviour defined,
   composition visible, no printing inside functions. **Criteria:** hand-checked values;
   tie-breaking for mode demonstrated.

## Set 10 — Arrays and strings → `arrays-and-strings.md`

1. Predict four slices of `[2,4,6,8,10,12]` including step; verify.
   **Criteria:** four predictions, four results, mismatch explanations.
2. Strip, split, title-case, and join the `"  apple,banana,cherry  "` line.
   **Criteria:** exact final string from a real run.
3. Reproduce list aliasing; fix with `.copy()`; show isolation.
   **Criteria:** both transcripts — shared mutation and isolated copy.
4. **Independent:** word-frequency counter — lowercase, strip punctuation, drop short words,
   top-5 with counts, longest word, deterministic tie rule. **Criteria:** hand-verified counts;
   stated tie rule; aligned output.

## Set 11 — Debugging fundamentals → `debugging-fundamentals.md`

1. Run the crashing sum; label the traceback's four parts. **Criteria:** all four identified on
   real output; fix named.
2. Classify five bugs into syntax / runtime / logic with the matching tool each.
   **Criteria:** five correct classifications.
3. Bisect a low-average bug with a midpoint probe; find the exact line.
   **Criteria:** probe shown, inference stated, root cause confirmed, fix verified on a second
   list.
4. **Independent:** debug the delivered `total = p` bug with the full five-step cycle.
   **Criteria:** cycle steps written as performed; original and `[5, 25]` both correct; class +
   cause stated.

## Set 12 — Modular programming → `modular-programming.md` · **capstone**

1. Split a working single-file program into `helpers.py` + entry point.
   **Criteria:** runs unchanged; library file silent on import.
2. Predict `__name__`'s value for run vs import; verify with the guard experiment.
   **Criteria:** two predictions, real run, both values stated.
3. Reproduce `ModuleNotFoundError` two ways (typo; wrong working directory); capture both.
   **Criteria:** two tracebacks, causes named, first-check rule stated.
4. **Independent — subject capstone:** *expense tracker* in three files: `expenses.py` (add,
   total, average, by-category functions; silent on import), `report.py` (formatted text report
   importing from `expenses`), `main.py` (guard-wrapped entry point using a small in-file data
   list). **Criteria:** `python -c "import expenses"` prints nothing; importing `report` prints
   nothing; running `main.py` prints the full report; all statistics hand-verified on the data;
   import arrows strictly one-directional (draw the module diagram).

---

## Answer key

Solutions: [solutions/](solutions/README.md).

**⚠ Attempt the sets first.** Reading a solution gives recognition, not skill. If you peeked, redo
the affected exercise one week later without looking — that second attempt is the one you keep.
