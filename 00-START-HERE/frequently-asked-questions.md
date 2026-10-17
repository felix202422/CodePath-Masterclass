# Frequently Asked Questions

## 1. Learning Objectives

After this lesson you will be able to:

- [ ] Answer the ten questions every beginner asks in week one — for yourself, with reasons
- [ ] Recognize the two or three that actually determine whether you finish
- [ ] Start subject 01 with no unresolved blocker

## 2. Prerequisites

- [How to use this repository](how-to-use-this-repository.md) and
  [the prerequisite map](prerequisite-map.md) — several answers point back to them.

## 3. Introduction

These are the real questions, asked in the same words by thousands of beginners, answered once so
you can stop carrying them. Each answer says what the real trade-off is — no cheerleading, no
defeatism.

---

## 4. The Questions

### "Which programming language should I learn first?"

**You already chose: this curriculum starts you with Python (subject 02), then Java (subject 04).**
The reasoning: Python's syntax is close to pseudocode, so your first weeks build *programming*
ideas instead of fighting ceremony; Java then forces you into a static type system, which is where
many of the industry's safety guarantees live. More generally: the first language is the least
important decision here. Concepts transfer completely; syntax transfers in a weekend. The expensive
thing is *not knowing any language deeply*, and the curriculum is engineered to prevent that.

### "Do I need a degree to get a job?"

**No — but you need evidence.** Degrees are one evidence format; portfolios are another, and
employers increasingly accept them, especially with a deployed project, tests, and a readable
history of real work. What does not work is claiming skills with nothing to inspect. The Project
Laboratory (subjects 20) exists precisely to produce that evidence, and
[19-PROFESSIONAL-DEVELOPMENT/career-paths.md](../19-PROFESSIONAL-DEVELOPMENT/career-paths.md)
covers the trade-offs honestly, including where a degree still helps.

### "How long until I can get hired?"

**Honest range: 12–24 months of consistent part-time work for an entry role**, depending on your
prior experience, local market, and how much of the project work you complete. Anyone promising
less is selling something; anyone saying five years is scaring you off. The variables you control
are consistency (see [study-planning.md](study-planning.md)) and evidence (projects + tests +
deployments), not speed-reading lessons.

### "Should I learn web, mobile, or backend first?"

**The map decides, not your preference.** The curriculum orders them web → database → backend →
mobile because each assumes the previous ([prerequisite-map.md](prerequisite-map.md)). If you are
impatient for mobile, note that subject 12 assumes a working API (11) — and a mobile app without a
backend is a slideshow.

### "Is AI going to make programming obsolete?"

**No — it changes what is valuable.** Tools that generate code raise the premium on the skills that
cannot be generated: deciding *what* to build, judging whether output is correct, debugging, and
understanding systems. The curriculum deliberately trains exactly those: you will predict outputs
before running them, diagnose broken code, and reason about trade-offs — all of which are how you
use AI tools well instead of being replaced by people who can verify their output. Professional
practice with these tools is covered in
[19-PROFESSIONAL-DEVELOPMENT/engineering-workflows.md](../19-PROFESSIONAL-DEVELOPMENT/engineering-workflows.md).

### "Windows, macOS, or Linux — which do I need?"

**Whatever you own.** The curriculum is written for Windows (with
[03-DEVELOPER-TOOLS/windows-development-environment.md](../03-DEVELOPER-TOOLS/windows-development-environment.md)
covering Git Bash and WSL), and Linux skills are taught properly in subjects 03 and 16 — you do not
need to have them already. Servers run Linux; your laptop does not have to.

### "How many hours a day should I study?"

**Consistency beats duration.** Three focused 60–90 minute sessions a week outrun two heroic
weekends a month. Size your plan from your worst realistic week at 70%
([study-planning.md](study-planning.md)) — for most people that means 5–10 hours weekly, not 40.

### "Can I skip the theory and just learn to build?"

**No, and here is the mechanism:** building requires debugging, and debugging requires the
foundations — memory, processes, how programs execute, data structures. Learners who skip them
build by copying, hit a problem they cannot copy their way out of, and stop. The curriculum is
already "just build" weighted from subject 07 onward; the theory in 01–05 is what makes the
building survivable.

### "Should I use AI tools while working through the exercises?"

**Not for the attempt — yes for the review.** The 15-minute rule
([learning-method.md](learning-method.md)) says you struggle first. After you have a working
attempt, AI tools are excellent for asking "what would you simplify here?" and comparing answers.
Getting a solution before the attempt is the same as reading the answer key: it feels productive
and teaches nothing durable.

### "I forgot everything from last week. Am I forgetting this?"

**Forgetting is the design, not the failure.** Spaced returns
([learning-method.md](learning-method.md)) work precisely because you forget a little first; the
return is what strengthens the memory. Your tracker's gap column is the mechanism: what you forgot
is written down, revisited, and closes over weeks. The learners who fail are not the ones who
forget — they are the ones who never test themselves, so they never notice.

### "This subject is boring me. Can I move on?"

**If you meet the completion criteria, yes — boredom usually means you have outgrown the lesson.**
Cold-test yourself: pass the knowledge check and one exercise set closed-book, mark your level, and
move. If you *cannot* pass, the boredom is a disguise for confusion — the fix is the prerequisite
one subject back, not a new shiny subject ahead.

### "I have been stuck for three days on one exercise. What now?"

Three days is past the 15-minute rule and into avoidance territory. Do this: write the problem in
your own words, produce your smallest failing case, then read the exercise's lesson section once
more, then the solution — **and then rebuild the solution from a blank editor two days later
without looking.** If you cannot, the gap is a prerequisite; find it on the map. If it persists a
week, ask for help in a GitHub issue naming the lesson and your symptom.

---

## 5. The Questions That Actually Predict Finishing

Ten of the twelve answers above are logistics. Three things genuinely decide whether you finish,
and they are all in this subject:

1. **A sized plan you execute** ([study-planning.md](study-planning.md)).
2. **A method that produces struggle, not recognition**
   ([learning-method.md](learning-method.md)).
3. **An honest tracker** ([PROGRESS-TRACKER.md](../PROGRESS-TRACKER.md)).

Everything else is negotiable.

## 6. Common Mistakes

| Mistake | Why it happens | How to prevent it |
|---|---|---|
| Asking questions instead of starting | Questions feel like progress | Every answer above ends in "start subject 01" — ask again in a month |
| Re-asking the language question every month | Confidence seeking | The decision is made; invest the saved energy in exercises |
| Comparing your month 3 to someone's year 3 | Social media distortion | Compare only to your last month's tracker entry |

## 7. Best Practices

- **Write your answers down once.** A personal FAQ — "why I chose this path" — is the document you
  re-read on the bad weeks, months from now.
- **When a new worry appears, check whether it changes what you do this week.** If it does not, it
  is not a decision; it is anxiety with extra steps.

## 8. Limitations and Trade-Offs

These answers describe the general case; your market, finances, and prior career are specific. Salary
expectations, visa constraints, and local hiring patterns vary enormously and are deliberately not
promised here —
[19-PROFESSIONAL-DEVELOPMENT/career-paths.md](../19-PROFESSIONAL-DEVELOPMENT/career-paths.md)
gives the framework for reasoning about your own case instead of borrowing someone else's.

## 9. Practical Exercises

### Introductory

1. **Answer three questions from memory** — the language question, the AI question, and the
   "stuck three days" question — without scrolling. **Completion criteria:** all three answered in
   your own words, consistent with this page.
2. **Write your honest hours.** From your actual calendar, not your hopes.
   **Completion criteria:** a number, and the 70% budget computed from it.

### Intermediate

3. **Write your personal FAQ.** Five worries you actually have, each with an action it implies this
   week. **Completion criteria:** every entry ends in a concrete action, or is explicitly marked
   "does not change this week's plan".

### Independent problem-solving

4. **Pre-commit to your failure modes.** Based on this subject, name the two ways you are most
   likely to quit (e.g. "skip exercises when excited", "restart from zero after a missed week").
   Then write the counter-measure for each. **Completion criteria:** two specific failure modes
   with mechanisms attached to your calendar or tracker, not good intentions.

## 10. Knowledge Check

1. Why is the first language choice described as "the least important decision"?
2. What replaces a degree as evidence, and what must that evidence contain to be credible?
3. Why does getting an AI-generated solution before attempting an exercise damage your learning,
   even though it feels efficient?
4. Name the three things that predict finishing.

## 11. Completion Criteria

- [ ] All twelve answers can be given from memory, in your words
- [ ] Your weekly hours and 70% budget are written down
- [ ] Your two personal failure modes have counter-measures attached somewhere real

## 12. Summary

- The logistics (language, OS, hours, AI tools) have settled answers; stop re-deciding them.
- Finishing depends on a sized plan, a retrieval-based method, and an honest tracker.
- Stuck for three days = write it down, minimal case, revisit, rebuild later, find the prerequisite.
- Boredom usually means outgrown; confusion usually means a missing prerequisite behind you.

## 13. Next Steps

**You are done with orientation.** Begin
[01-COMPUTER-FOUNDATIONS/README.md](../01-COMPUTER-FOUNDATIONS/README.md) — starting with
`computer-hardware.md`. When you finish each lesson there, the loop from
[learning-method.md](learning-method.md) applies unchanged.