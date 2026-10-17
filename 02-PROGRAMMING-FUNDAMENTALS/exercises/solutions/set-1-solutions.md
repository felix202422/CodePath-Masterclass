# Solutions — Set 1: Computational Thinking

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.

## Exercise 1 — Decompose "find the longest word"

**Answer.** One valid decomposition (names vary, structure should not):

1. **Input:** `READ sentence` — obtain the sentence (one string).
2. **Split:** `words ← sentence.split()` — text → list of words.
3. **Empty check:** if `words` is empty, print "no words" and stop (edge case handled at plan
   time, not discovered later).
4. **Compare loop:** walk the words, keeping the longest seen so far (one comparison per word).
5. **Output:** print the longest word — the observable result.

**Criteria check:** ☐ every part one sentence ☐ inputs/outputs stated per part ☐ last part
observable.

**Reviewer note:** a common miss is folding step 3 into step 4 ("find the longest, and also
handle empty") — the edge case deserves its own line in the plan because it has its own behaviour.

## Exercise 2 — Spot the pattern

**Answer.**

| Task | Pattern? | Reason |
|---|---|---|
| Apply 10% discount to each purchase | Yes, with "find the largest" | Both are "do one thing per element" — a for-each shape |
| Find the largest of several numbers | Yes, with the discount task | Same iteration; different work per element, same structure |
| Count purchases over 100 | **No** (with the others) | It also iterates, but its work is a conditional count — a filter-then-count, not a transform |

The sharper reading: all three share *iteration*; the first two are *unconditional per-element
action*, the third is *conditional aggregation*. Recognising the shared skeleton while refusing
to merge the different rules is the whole skill.

**Criteria check:** ☐ three classifications ☐ one-sentence reason each.

## Exercise 3 — The accidental abstraction

**Answer.** Shared detail: both send an email through the same provider. Differing detail that
kills the shared abstraction: a customer receipt is triggered by a *transaction and must contain
its line items and totals*, while a staff reminder is triggered by *schedule logic and must
contain task data*. One `send_email(subject, body, recipient)` primitive is shared; the
*construction* of subject/body/data cannot be, because their requirements change on different
triggers for different audiences — merging them produces a function with an ever-growing flag
parameter, the signature of a wrong abstraction.

**Criteria check:** ☐ shared detail named ☐ differing detail named ☐ one-line justification each.

## Exercise 4 — Plan the text-report generator (independent)

**Answer.** Skeleton (fuller version lives in set 2, exercise 4, where pseudocode is required):

- **Decompose:** read lines → parse numbers → (empty? invalid?) → compute stats → format report.
- **Patterns:** one per-line action (parse); five stats are five reductions over the same list —
  one pass each, or one combined pass.
- **Abstractions:** `parse_lines(lines) → (values, problems)`, `stats(values) → {count, total,
  average, min, max}`, `format_report(stats, problems) → str`.
- **Algorithm ends in defined outputs:** the report's exact lines for the normal case, and the
  two message lines for empty input and non-numeric input (which stops at the first bad line,
  naming it).

**Criteria check:** ☐ normal case defined ☐ empty case defined ☐ invalid case defined — each
with its *output*, not just behaviour.

**Reviewer note:** the plan most often missing a beat: what if the file has *only* invalid
lines, or whitespace? Decide: whitespace lines skipped; first non-numeric non-blank line is the
error case.
