# LEARNING-GUIDE

How to study this repository so the material actually sticks — without burning out or drowning in
tabs.

This guide exists because **the most common way to fail a self-study curriculum is to read it.**
Reading produces recognition, which feels like knowledge and is not. Knowledge is what you can
produce from memory, explain in your own words, and use on a problem you have not seen before.

---

## 1. The core loop

Every lesson in this repository is built around one loop. Do it in this order, every time:

1. **Read the learning objectives and prerequisites.** If a prerequisite link is unfamiliar, go
   there first. Nothing in this repository assumes knowledge it has not taught.
2. **Predict before you run.** Before executing an example, write down what you think it prints.
   When you are wrong — and you will be — the correction is worth ten correct predictions.
3. **Run it, then break it.** Change a value, remove a line, introduce a typo. Debug what happens.
   The error message you provoke on purpose teaches more than a bug you stumbled into.
4. **Do the exercises on paper first.** Sketch the solution in pseudocode before typing.
5. **Check completion criteria, not page count.** "I read it" never qualifies. The criteria are
   deliberately written as observable actions: *write, run, explain, diagnose, compare.*
6. **Log it honestly** in [PROGRESS-TRACKER.md](PROGRESS-TRACKER.md). One line, thirty seconds.

## 2. Retrieval beats re-reading

Research on learning consistently shows that **retrieving** information strengthens memory far more
than re-reading it. Concretely:

- After finishing a lesson, close it and write five bullet points from memory. Then open it and
  check what you missed. The misses are your real to-do list.
- The **Knowledge Check** section at the end of every lesson is not decoration — answer aloud, in
  full sentences, as if explaining to a classmate.
- Once a week, pick two old lessons you have finished and re-answer their knowledge checks cold.

## 3. Spacing: forget a little, on purpose

Attempting something again *after you have started to forget it* is far more efficient than
re-reading it while it is fresh. Use this cadence as a default:

| Interval | Action |
|---|---|
| Same day | Exercises + knowledge check for the lesson you just read |
| +2 days | Redo the hardest exercise from that lesson without looking |
| +1 week | Answer its knowledge check cold; skim only the questions you missed |
| +1 month | Apply it in a project context or teach it in writing |

Your exact intervals matter less than *having* intervals. A lesson you touched four times over a
month is worth more than five lessons read back to back.

## 4. Depth first, then breadth — in prerequisite order

This repository is ordered so nothing depends on what you have not studied. Resist these two
temptations:

- **Skipping ahead to the shiny part** (React, Docker, microservices) before the foundations.
  It produces code you cannot debug, which is worse than no code. Use
  [prerequisite-map.md](00-START-HERE/prerequisite-map.md) to see exactly what each subject needs.
- **100% completionism** on low-value material. If you already know git fundamentals, test yourself
  with the knowledge check; if you pass cold, mark it and move on. The tracker's levels make this
  visible: "introduced" is an honest entry.

## 5. Session structure that works

A workable default for ~10 hours/week (adjust to your life; consistency beats intensity):

| Session | Shape | Why |
|---|---|---|
| 3 × 60–90 min study blocks | One lesson: objectives → read → run examples → break them | Deep work while fresh; the run-and-break step converts reading into skill |
| 2 × 60 min exercise blocks | Problems only, no re-reading until stuck >15 minutes | Retrieval practice; struggle before lookup is where learning happens |
| 1 × 30 min review | Knowledge checks from previous week + tracker update | Spacing |
| 1 × longer project block | Project milestones only | Integration — this is where separate lessons become one skill |

**Hard rules that prevent the classic failure modes:**

1. Never end a session *only* having read. Type something, run something, break something.
2. Stuck for 15 minutes? Write down precisely what you expected and what happened; then reread the
   relevant lesson section; then search. The order matters — flailing or immediately copying both
   destroy the lesson.
3. Stop at a natural boundary (an exercise finished, a milestone reached), not mid-concept.
4. Track honestly. Overstating progress is the fastest way to discover gaps during a project.

## 6. When you are stuck (in order)

1. **Reproduce it minimally.** Cut the problem to the smallest thing that still fails.
2. **Read the error aloud, slowly.** Errors are sentences with subjects. Which line? Which value?
   Which file?
3. **Check your prediction.** What did you expect? Which assumption is wrong? The wrong assumption
   is the bug — in the code or in your mental model.
4. **Return to the lesson section** that covers it; you have new context now, so it will read differently.
5. **Use the references:** [common-errors.md](21-REFERENCE-LIBRARY/common-errors.md), then official docs.
6. **Take a walk, then return.** Incubation is a real, documented part of problem solving.

Detailed method: [19-PROFESSIONAL-DEVELOPMENT/debugging-methodology.md](19-PROFESSIONAL-DEVELOPMENT/debugging-methodology.md).

## 7. How to know you actually learned something

You learned it when you can do **all** of these:

- **Produce** it from memory (write the loop, the query, the component) without a reference.
- **Explain** it in plain language to someone with no context, including *why* it exists and *when
  not* to use it.
- **Predict** what a given snippet or query will do before running it — including edge cases.
- **Diagnose** the typical mistakes (each lesson's *Common Mistakes* section is the test bank).
- **Transfer** it: use it in a different context than the lesson's example, e.g. reuse the validation
  idea from HTML forms in a backend DTO.

If any of the five is missing, you are between tracker levels — mark the lower one and revisit.

## 8. Do not study alone if you can help it

Explaining is the highest-yield study activity there is, and it needs an audience:

- Write the summary as if for a blog post (see [technical-documentation.md](19-PROFESSIONAL-DEVELOPMENT/technical-documentation.md)).
- Answer a beginner's question about today's lesson on a forum; being wrong publicly is survivable
  and memorable.
- Study partners catch "you skipped the prerequisite" moments you cannot catch yourself.

## 9. Measuring progress without lying to yourself

- Prefer **evidence** over feelings: a passing test, a deployed app, a commit history, a written
  explanation someone else could follow.
- Use the six levels in [PROGRESS-TRACKER.md](PROGRESS-TRACKER.md) strictly. "Read about indexes" is
  level 1. "Chose an index and justified it with a query plan" is level 4+.
- Every milestone in [ROADMAP.md](ROADMAP.md) has explicit promotion criteria — that, not a
  percentage bar, decides when you move on.

## 10. When to move on anyway

Perfectionism stalls careers. Move on when:

- You meet the completion criteria but your knowledge check had one gap → note it as a revision task.
- A lesson is above your target role for now (e.g. you are job-hunting and Terraform can wait) →
  mark it "Introduced" in the tracker and continue in order.
- You have spent 3× the estimated time on one lesson → reread the prerequisites; the gap is
  usually one or two lessons back, not in the current file.

Come back through the tracker's revision column — gaps you wrote down get closed; gaps you denied
do not.

---

**Next:** [study-planning.md](00-START-HERE/study-planning.md) to build your actual schedule,
then start [00-START-HERE/README.md](00-START-HERE/README.md).