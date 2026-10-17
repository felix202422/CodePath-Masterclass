# Exercise Set: Topic

<!--
AUTHORING RULES (delete when written)
- Ladder order is fixed: introductory → intermediate → independent. Never mix.
- Every exercise has observable completion criteria. "Understand X" is not a criterion; "the
  program prints Y for input Z and handles the empty case without crashing" is.
- State the prerequisites (lesson path) at the top.
- Solutions belong in a separate file/folder with a warning header — never inline here.
- Include at least one exercise that requires diagnosing a deliberately broken example.
-->

**Lesson:** [Lesson name](../lesson.md) · **Prerequisites:** [links] · **Estimated time:** honest range

## How to use this set

1. Attempt every exercise before opening the solutions. Struggle is the mechanism, not an obstacle.
2. If stuck for more than 15 minutes: restate the problem in your own words, then revisit the
   lesson section, then the solutions as a last resort — and write down which hint you used.
3. Tick each completion criterion only when it is observably true.

---

## Introductory

### Exercise 1 — Reproduce and explain

**Task:** Run the lesson's minimal example, then change one value and predict the new output before
running it again.

**Completion criteria:**

- [ ] The program runs on your machine with the version pinned in `VERSIONS.md`
- [ ] You wrote a prediction for the modified version before running it
- [ ] You can say in one sentence why the output changed the way it did

### Exercise 2 — Small modification

**Task:** Extend the example to handle X.

**Completion criteria:**

- [ ] X works for the normal case and at least one edge case (empty input, zero, negative, unicode — whichever applies)
- [ ] You did not copy-paste the lesson code; it was typed

---

## Intermediate

### Exercise 3 — Combine and harden

**Task:** Combine A and B from the lesson to do Y, handling invalid input by reporting a clear error
instead of crashing.

**Completion criteria:**

- [ ] Works for the normal case, the edge case, and the invalid case
- [ ] Error output names the problem, not the stack trace
- [ ] You can explain the time or space cost of your approach (state it in one line)

### Exercise 4 — Diagnose a broken example

**Task:** This code should do Z but fails. Find **two** independent bugs and fix them.

```lang
// deliberately broken snippet
```

**Completion criteria:**

- [ ] Both bugs identified, with an explanation of why each causes the symptom
- [ ] Fixed version passes the stated behaviour
- [ ] You can name the diagnostic step that found each bug (print, debugger, error message, hypothesis)

---

## Independent problem-solving

### Exercise 5 — Design it yourself

**Problem statement:** [A problem described in domain terms only. No steps, no function names, no
structure hints.]

**Completion criteria:**

- [ ] Solution written from a blank editor without the lesson open
- [ ] Handles the edge cases you identified yourself (list them in a comment)
- [ ] You can justify your main design choice in two sentences, including one drawback
- [ ] (Where applicable) you wrote at least one test proving a non-obvious case works

---

## Answer key

Solutions are in [solutions/topic-exercises.md](solutions/topic-exercises.md). They include the
reasoning, not just the code.

**⚠ Attempt the exercises first.** Reading a solution produces recognition, which feels like
knowledge and is not. If you peeked, redo the exercise a week later without looking — that second
attempt is what you actually keep.