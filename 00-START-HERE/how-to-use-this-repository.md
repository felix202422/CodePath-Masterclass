# How to Use This Repository

## 1. Learning Objectives

After this lesson you will be able to:

- [ ] Navigate from any point in the curriculum to the lesson you need
- [ ] Use exercises the way they are designed to be used (attempt → criteria → then solutions)
- [ ] Track your progress honestly with the six proficiency levels
- [ ] Recognize when a lesson is finished — and when you only *read* it

## 2. Prerequisites

None. This is the entry point of the curriculum. If you have not read the
[subject overview](README.md) yet, skim it first — it takes two minutes.

## 3. Introduction

This repository is a complete software engineering curriculum: 22 subjects, hundreds of lessons,
exercise sets, eight projects, and a reference library. That size is a strength and a risk. The
strength is that nothing you need is missing. The risk is that a beginner drowns in it.

This lesson teaches the four mechanics that prevent the drowning: how the material is organized,
how exercises work, how progress is tracked, and how you know when you are actually done.

## 4. The Problem It Solves

Self-study material usually fails in one of two ways. Either it is a **link farm** — a roadmap of
external resources where you spend more time evaluating sources than learning — or it is a
**content dump** — thousands of files with no order, no exercises, and no way to tell what matters.

This repository is organized to avoid both: every lesson names its prerequisites and links to them,
every subject has a fixed reading order, every exercise has completion criteria, and unfinished work
is tracked publicly in [ISSUE-REGISTER.md](../ISSUE-REGISTER.md) instead of being hidden.

## 5. Core Concepts

### 5.1 The anatomy of the repository

| Thing | What it is | Where |
|---|---|---|
| **Subject** | A numbered directory (00–21), one per discipline | e.g. `04-JAVA-PROGRAMMING/` |
| **Lesson** | One Markdown file teaching one topic | e.g. `04-JAVA-PROGRAMMING/methods.md` |
| **Exercise set** | Problems that turn reading into skill | `exercises/` inside each subject |
| **Solutions** | Answer keys, deliberately separated | `exercises/solutions/` |
| **Project** | A multi-week build combining subjects | `20-PROJECT-LABORATORY/` |
| **Reference** | Quick-lookup pages: glossary, errors, commands | `21-REFERENCE-LIBRARY/` |

Numbering matters: **study in order**. The numbers are not cosmetic — subject 04 assumes subject 02,
subject 11 assumes subjects 04, 06, and 10. Skipping ahead is the single most common reason people
get stuck, and the fix is always to go back one or two subjects.

### 5.2 The anatomy of a lesson

Every substantive lesson follows the same shape, so you always know where you are:

1. **Learning Objectives** — what you will be able to do, not what you will have read.
2. **Prerequisites** — links to what you must know first. If a prerequisite link is unfamiliar,
   go there. That is not optional.
3. **Introduction / Problem it solves** — why this concept exists at all.
4. **Core Concepts / How it works** — the teaching itself, in small steps.
5. **Practical Examples** — runnable code with expected output and how to run it.
6. **Common Mistakes** — the errors beginners actually make, and how to recognize them.
7. **Practical Exercises** — from guided to independent.
8. **Knowledge Check / Completion Criteria** — how to tell whether it worked.
9. **Summary / Next Steps** — the compressed version, and where to go.

### 5.3 The exercise ladder (and the solutions rule)

Every exercise set climbs the same ladder:

| Level | What it asks | Why it exists |
|---|---|---|
| **Introductory** | Reproduce and slightly modify the lesson's example | Proves you can run and adjust, not just read |
| **Intermediate** | Combine ideas, handle edge cases, fix broken code | Proves you understand the mechanism |
| **Independent** | A problem stated without steps; you design the solution | Proves you can work unaided |

**Solutions live in separate folders for a reason.** Recognition feels like knowledge and is not.
A solution you read before attempting produces the pleasant sensation of understanding and none of
the skill. The rules that make this work:

- Attempt first. Genuinely attempt — write something, run it, fail.
- Only when stuck for more than 15 minutes: revisit the lesson section, then the solution.
- Write down which hint you used. That note is your real revision list.

### 5.4 The six proficiency levels

Progress is tracked in [PROGRESS-TRACKER.md](../PROGRESS-TRACKER.md) on a six-level scale:
**1 Introduced → 2 Practiced with guidance → 3 Implemented independently → 4 Applied in a project →
5 Explained and reviewed critically → 6 Maintained in a realistic environment.**

The scale exists because "I read about indexes" and "I chose an index and justified it with a query
plan" are not the same achievement, and pretending they are corrupts your own planning. Reading
moves you to level 1. Nothing else moves you up.

## 6. How It Works — a study session, end to end

1. Open the next lesson. Read the objectives and prerequisites (2 minutes).
2. Read a section. For each code example: **predict its output before running it**, then run it,
   then break it on purpose (change a value, delete a line) and predict again.
3. Do the introductory exercises with the lesson closed. Check your work against completion
   criteria, not against the prose.
4. Log it in the tracker — one line, thirty seconds.
5. Stop at a natural boundary, not mid-concept.

That loop — read, predict, run, break, do, log — is the entire method. Everything else in this
repository supports it.

## 7. Real-World Applications

This is how professionals learn a new codebase, too: read the docs' overview, run the example,
change it, break it, then write the change they actually need. Learning the loop now means you
already know how to onboard onto unfamiliar technology for the rest of your career.

## 8. Common Mistakes

| Mistake | Why it happens | How to prevent it |
|---|---|---|
| Reading five lessons, doing zero exercises | Reading is comfortable; struggle feels like failure | Never end a session with only reading — run one example at minimum |
| Jumping to React/Docker because it looks employable | Shiny-object bias | The prerequisite map is a promise: skipping produces code you cannot debug |
| Opening solutions early | Impatience with discomfort | 15-minute rule; write down the hint you used |
| Marking a lesson done because the page was opened | Progress feels good | Only completion criteria count; the tracker demands evidence |
| Studying 6 hours on Saturday, nothing until next Friday | Biodiversity of motivation | Three 60-minute sessions beat one marathon; put them in your calendar |

## 9. Best Practices

- **Keep one tracker, not five notes.** The provided template is enough; the best system is the one
  you actually open.
- **Use the reference library while working**, not as study material — it is a lookup shelf.
- **Report errors in the material.** If a lesson is wrong or unclear, open a GitHub issue naming the
  file and what you understood instead. That is a real contribution
  ([CONTRIBUTING.md](../CONTRIBUTING.md)).
- **Check `VERSIONS.md` when something does not work.** Most "the tutorial is broken" moments are
  version mismatches between the lesson and your machine.

## 10. Limitations and Trade-Offs

This repository cannot give you the two things that finish an engineer: **feedback from another
human** and **consequences from real users**. Exercises and projects simulate the first; open source
and real deployments provide the second
([19-PROFESSIONAL-DEVELOPMENT](../19-PROFESSIONAL-DEVELOPMENT/README.md)). Budget for both from
the start rather than discovering their absence at the end.

## 11. Practical Exercises

### Introductory

1. **Map your starting point.** Open [prerequisite-map.md](prerequisite-map.md), find the subject
   you believe you should start at, and write one sentence justifying it.
   **Completion criteria:** a written start point plus its justification, in your tracker.
2. **Locate one solution folder** without opening any solution file. **Completion criteria:** you
   can name the path where exercise answers for subject 02 will live.

### Intermediate

3. **Run a full study session** on any short lesson using the read/predict/run/break/do/log loop.
   **Completion criteria:** one completed introductory exercise and one tracker entry with evidence.

### Independent problem-solving

4. **Design your own navigation convention.** Without looking back at this lesson, write the five
   things a newcomer needs to know about this repository, from memory, in under 100 words.
   **Completion criteria:** your five points cover organization, order, exercises, solutions, and
   progress — anything missing is your revision list.

## 12. Knowledge Check

1. A friend asks "where do I find the exercises for subject 07, and where are the answers?" Answer
   in two sentences, including why the answers are separated.
2. You opened a lesson and read it comfortably, with no struggle. What proficiency level have you
   reached, and what would move you to level 3?
3. Why does the repository tell you to check `VERSIONS.md` before reporting a broken example?

## 13. Completion Criteria

- [ ] You can navigate to any subject and find its lessons, exercises, and solutions
- [ ] You can state the 15-minute rule and why it exists
- [ ] You have written your first tracker entry
- [ ] You can explain the difference between reading a lesson and completing it

## 14. Summary

- Study subjects in numbered order; every lesson links its prerequisites.
- Exercises climb from introductory to independent; solutions are separated because reading them
  first produces recognition, not skill.
- The six proficiency levels keep your progress honest; reading is level 1.
- One study loop (read, predict, run, break, do, log) is the whole method.

## 15. Next Steps

1. [how-programming-works.md](how-programming-works.md) — what a program actually is, before any
   syntax.
2. Then [learning-method.md](learning-method.md) and [study-planning.md](study-planning.md), and
   you are ready for [01-COMPUTER-FOUNDATIONS](../01-COMPUTER-FOUNDATIONS/README.md).