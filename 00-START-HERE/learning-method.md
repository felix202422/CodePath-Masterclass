# The Learning Method

## 1. Learning Objectives

After this lesson you will be able to:

- [ ] Run a study session using the predict/run/break/do/log loop
- [ ] Explain why retrieval practice beats re-reading, and design a self-test for any lesson
- [ ] Apply the 15-minute stuck rule without improvising
- [ ] Set spaced review intervals you will actually keep

## 2. Prerequisites

- [How to use this repository](how-to-use-this-repository.md) — the mechanics this lesson puts to
  work.
- [How programming works](how-programming-works.md) — the material you will practice learning.

*Context:* the overall system is summarized in [LEARNING-GUIDE.md](../LEARNING-GUIDE.md). This
lesson is where you **practice** it: every idea here comes with a drill. Read that file once for
the overview; come here to train.

## 3. Introduction

The material in this repository is free and infinitely patient — but it is also inert. Nothing here
enters your head by being read. Skills form through **retrieval** (pulling knowledge out of your
own memory), **spacing** (returning after a little forgetting), and **struggle** (the productive
kind, before looking anything up).

This lesson teaches the four drills that produce those three conditions, and nothing else. It is
short on purpose: the method is simple, and the difficulty is in doing it when it is uncomfortable.

## 4. The Problem It Solves

Most people study by re-reading and re-watching. It feels effective — the material looks familiar,
so familiarity must be learning. But familiarity is recognition, and recognition is exactly what
you have *without* skill. The proof is a two-second experiment: read a page, close it, and write
its five main points. The gap between what you recognized and what you produced is your actual
knowledge.

Courses that skip retrieval produce learners who can explain a concept while looking at it and go
blank in an exam, an interview, or a bug at 2 a.m. — because those situations all require
production without the page open. This method trains production from day one.

## 5. Core Concepts

### 5.1 Drill 1 — Predict, run, break

For every code example in this repository:

1. **Predict.** Read the code and write down what you think it prints, *before* running it.
2. **Run.** Execute it. Compare with your prediction.
3. **Break.** Change one thing (a value, a condition, delete a line) and predict the new output.
   Run again.

Why it works: prediction forces retrieval and commitment; the surprise when you are wrong is a
memory hook; breaking the example teaches you what each line *contributes*, which reading cannot.

### 5.2 Drill 2 — Retrieval self-test

After finishing a lesson, close it and write from memory:

- The five key points, in your own words.
- One "when *not* to use this" statement.
- One common mistake and its fix.

Then reopen and check. **Your misses are the revision list** — write them into your tracker's
"Gap to revisit" column. This replaces re-reading entirely: you never study a lesson passively
again, you study its misses.

### 5.3 Drill 3 — The 15-minute rule

When stuck: **15 minutes of structured attempt**, then structured help. The structured attempt is
not flailing — it is:

1. Reproduce the problem in the smallest possible case.
2. Write what you expected, and what happened instead.
3. Read the error message completely, aloud if needed.
4. Form one hypothesis about the cause and test it.

After 15 minutes: revisit the specific lesson section, then
[common-errors.md](../21-REFERENCE-LIBRARY/common-errors.md), then the exercise solution — and
**record which hint you used.** Immediate solution-reading trains dependency; blind flailing
trains despair. The rule keeps you in the productive middle.

### 5.4 Drill 4 — Spaced return

Memory decays, and re-encountering material after some decay is what makes it stick. Default
intervals, per lesson:

| When | What |
|---|---|
| Same day | Exercises + self-test |
| +2 days | Redo the hardest exercise from memory |
| +1 week | Cold self-test; review only the misses |
| +1 month | Apply it in a project or explain it in writing |

The exact intervals matter less than having any. Mark them in your calendar as one-line tasks.

### 5.5 Effort is the signal

All four drills share one property: they are effortful, and the effort *is* the mechanism. If
studying feels easy and smooth, you are re-reading. If you are squinting at a blank page trying to
remember, you are learning. This is worth knowing explicitly, because every instinct will tell you
to go back to the comfortable method.

## 6. How It Works — one session, timed

A 75-minute session using all four drills:

```text
0:00–0:05  Read the lesson's objectives and prerequisites.
0:05–0:30  Read a section; for each example: predict → run → break (Drill 1).
0:30–0:55  Introductory + one intermediate exercise, lesson closed (Drill 2 begins).
0:55–1:10  Self-test: five points from memory; note the misses (Drill 2 completes).
1:10–1:15  Log one tracker line: level, evidence, gaps. Schedule the +2-day return (Drill 4).
```

That is 75 minutes producing exercised skill, versus three hours of re-reading producing
familiarity. Consistency beats duration: three of these a week, every week, outruns weekend
marathons that stop after month one.

## 7. Real-World Applications

This is not study-hack trivia; it is how the profession operates. Code review is retrieval practice
under social pressure. Postmortems are spaced returns to incidents. Whiteboard debugging in
interviews is Drill 1 with an audience. Engineers who learned to produce under these conditions
find the daily texture of the job familiar rather than frightening.

## 8. Common Mistakes

| Mistake | Why it happens | How to prevent it |
|---|---|---|
| Highlighting instead of testing | Highlighting feels productive | Highlights are allowed only after a self-test attempt |
| Watching tutorials as study | Passive, comfortable | Videos count as reading (level 1); the exercise is the study |
| Skipping the prediction step | It slows reading down | It is the highest-yield step; slow down here, not elsewhere |
| Stuck 30 seconds, straight to the solution | Discomfort avoidance | Set a timer. 15 minutes, structured |
| Never scheduling the return | "I'll remember" | You will not; put the +2-day task in the calendar during the session |

## 9. Best Practices

- **Study at the same time daily** if possible; routine removes decision fatigue.
- **Keep a single revision list** (the tracker's gap column); multiple note systems never get read.
- **Explain out loud.** Speaking exposes gaps writing lets you glide past.
- **Sleep is part of the method.** Consolidation happens overnight; an all-nighter spends tomorrow's
  learning to feel productive tonight.

## 10. Limitations and Trade-Offs

Retrieval practice is slower per session than re-reading, so you will cover less ground each week —
and retain far more of it. That trade is the entire point, but it means you should *not* judge
progress by pages covered; judge it by the tracker's evidence column. Also: this method cannot
substitute for feedback from humans on your designs and code — pair it with the review and open
source practices in
[19-PROFESSIONAL-DEVELOPMENT](../19-PROFESSIONAL-DEVELOPMENT/README.md).

## 11. Practical Exercises

### Introductory

1. **Run Drill 1 on three examples** from any lesson you have read. Write predictions first.
   **Completion criteria:** three written predictions, at least one deliberately broken example,
   and one surprise noted.
2. **Run Drill 2 on this lesson itself.** Close it and write its four drills from memory.
   **Completion criteria:** written attempt before reopening, plus a written miss list.

### Intermediate

3. **Run a 75-minute session exactly as timed above** on your next lesson. **Completion criteria:**
   one completed exercise, one self-test, one tracker entry, one scheduled return.
4. **Audit your last week.** For each study activity, label it retrieval or recognition.
   **Completion criteria:** an honest tally, plus one recognition activity replaced with a
   retrieval one this week.

### Independent problem-solving

5. **Design your own drill.** For a non-code skill in this curriculum (reading a query plan,
   picking a data structure, reviewing a pull request), design a self-test that forces production
   without notes. **Completion criteria:** your test has a scored outcome (correct/incorrect), can
   be done in under 10 minutes, and does not involve re-reading anything first.

## 12. Knowledge Check

1. Why does re-reading produce familiarity without skill? Name the experiment that proves it.
2. A friend is stuck on an exercise and opened the solution after two minutes. Which drill have
   they skipped, and what should they do now?
3. Why is "predict before running" more valuable for learning than "run and observe"?
4. Your calendar is full. What is the minimum viable version of Drill 4 that still works?

## 13. Completion Criteria

- [ ] You have performed all four drills at least once, deliberately
- [ ] You can state the evidence for why retrieval beats re-reading
- [ ] Your tracker contains a real gap list produced by Drill 2
- [ ] You have at least one spaced return scheduled

## 14. Summary

- Learning is production, not recognition: test yourself, do not re-read.
- Predict/run/break turns every example into an experiment.
- The 15-minute structured rule beats both flailing and immediate solution-reading.
- Space your returns (same day, +2 days, +1 week, +1 month) and schedule them in the session.
- Effort is the mechanism; ease is the warning sign.

## 15. Next Steps

- [study-planning.md](study-planning.md) — turn the method into a weekly plan you can keep.
- Then [prerequisite-map.md](prerequisite-map.md) and
  [01-COMPUTER-FOUNDATIONS](../01-COMPUTER-FOUNDATIONS/README.md).