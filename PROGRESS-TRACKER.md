# PROGRESS TRACKER

A manual progress log. Duplicate this structure into your own copy (a fork, a private notebook, an
issue — whatever you will actually open) and keep it honest.

> **These are learning indicators, not certifications.** Nothing here is graded, accredited, or
> verifiable by anyone but you — which is exactly why honesty matters. An inflated tracker feels
> good and fails during the first real project.

---

## The six proficiency levels

| Level | Name | What it means | Evidence required |
|---|---|---|---|
| 1 | **Introduced** | You have read the lesson and followed an example | You can define the term |
| 2 | **Practiced with guidance** | You completed the guided exercises with the lesson open | Exercises pass the completion criteria |
| 3 | **Implemented independently** | You solved the intermediate/independent exercises from a blank file | Working code you wrote unaided |
| 4 | **Applied in a complete project** | It ships as part of something larger | A project feature using it, with tests |
| 5 | **Explained and reviewed critically** | You can teach it, including trade-offs and when *not* to use it | A written explanation someone else reviewed |
| 6 | **Maintained in a realistic environment** | You have debugged, changed, and operated it under real constraints | An incident, a refactor, a migration, or real users |

Use the gap between claimed level and evidence honestly: **reading never exceeds level 1.**

---

## The eight tracked dimensions

Progress is tracked *separately* per dimension, because they develop at different rates. Someone
can be level 4 at "concepts understood" and level 1 at "deployment experience" — that is normal and
useful information.

### 1. Concepts understood

| Lesson / topic | Level (1–6) | Date | Notes / gap to revisit |
|---|---|---|---|
| _example: Big-O notation_ | _1_ | _2026-10-17_ | _can define, cannot yet derive costs_ |
| | | | |

### 2. Exercises completed

| Exercise (ID or path) | Attempted | Completion criteria met? | Date | Notes |
|---|---|---|---|---|
| | ☐ | ☐ | | |

### 3. Projects implemented

| Project | Milestones done | Acceptance criteria met? | Repo link | Date |
|---|---|---|---|---|
| | | ☐ | | |

### 4. Tests written

| Project / module | Test level(s) used | Meaningful assertions? (not just coverage) | Date |
|---|---|---|---|
| | unit / integration / e2e | ☐ | |

### 5. Bugs diagnosed

| Bug | Symptom → root cause | Method used (e.g. bisect, debugger, hypothesis) | Time to fix | Date |
|---|---|---|---|---|
| | | | | |

*Rule of thumb: log the **method**, not just the outcome — that is what turns a lucky fix into a
reusable skill ([debugging-methodology.md](19-PROFESSIONAL-DEVELOPMENT/debugging-methodology.md)).*

### 6. Documentation written

| Artifact (README, ADR, API docs, post) | Audience | Could a stranger follow it? | Link | Date |
|---|---|---|---|---|
| | | ☐ | | |

### 7. Independent problem-solving

Problems solved **from a blank editor, without AI assistance and without the lesson open**:

| Problem | Source | Hints used (0–3) | Solution correct? | Date |
|---|---|---|---|---|
| | | | ☐ | |

### 8. Deployment experience

| What was deployed | Environment | Pipeline? | Monitoring? | Rollback rehearsed? | Date |
|---|---|---|---|---|---|
| | local / staging / prod | ☐ | ☐ | ☐ | |

---

## Curriculum progress by subject

Status: `—` not started · `◐` in progress (state your level) · `✓` meets the ROADMAP promotion criteria

| # | Subject | Lessons done | Level (avg) | Promotion criteria met | Date |
|---|---|---|---|---|---|
| 00 | Start Here | 0/6 | — | ☐ | |
| 01 | Computer Foundations | 0/7 | — | ☐ | |
| 02 | Programming Fundamentals | 0/12 | — | ☐ | |
| 03 | Developer Tools | 0/11 | — | ☐ | |
| 04 | Java Programming | 0/21 | — | ☐ | |
| 05 | Data Structures & Algorithms | 0/17 | — | ☐ | |
| 06 | Internet & Web Foundations | 0/10 | — | ☐ | |
| 07 | HTML & CSS | 0/10 | — | ☐ | |
| 08 | JavaScript & TypeScript | 0/13 | — | ☐ | |
| 09 | Frontend Engineering | 0/16 | — | ☐ | |
| 10 | Database Engineering | 0/17+ | — | ☐ | |
| 11 | Backend Engineering | 0/20 | — | ☐ | |
| 12 | Mobile Development | 0/18 | — | ☐ | |
| 13 | Software Engineering & Architecture | 0/17 | — | ☐ | |
| 14 | Testing & Quality | 0/11 | — | ☐ | |
| 15 | Application Security | 0/15 | — | ☐ | |
| 16 | DevOps & Infrastructure | 0/20 | — | ☐ | |
| 17 | Cloud & Production | 0/12 | — | ☐ | |
| 18 | Advanced Engineering | 0/10 | — | ☐ | |
| 19 | Professional Development | 0/9 | — | ☐ | |
| 20 | Project Laboratory | 0/8 | — | ☐ | |
| 21 | Reference Library | 0/12 | — | ☐ | |

> Counts reflect planned lesson files tracked in [ISSUE-REGISTER.md](ISSUE-REGISTER.md); “lessons
> done” means your completion criteria were met, not that files were opened.

---

## Milestone status (from [ROADMAP.md](ROADMAP.md))

| Milestone | Promotion criteria | Met? | Date |
|---|---|---|---|
| M0 Orientation | Tracker started, study sessions scheduled | ☐ | |
| M1 Foundations | Write 50–100 lines from a spec and explain every line | ☐ | |
| M2 Tools & Git | Meaningful history: branches, merge, a resolved conflict | ☐ | |
| M3 Java & OOP | Explain an unfamiliar 300-line project's class responsibilities | ☐ | |
| M4 DSA | 5 mixed problems self-tested with complexity analysis | ☐ | |
| M5 Web & Frontend | Project 02 accessible and responsive; narrate a component fully | ☐ | |
| M6 Databases & Backend | Project 04 accepted with passing tests; justify an index from a plan | ☐ | |
| M7 Mobile | Signed debug build + passing tests + narrated state flow | ☐ | |
| M8 Architecture, Testing, Security | ADR written; justified test mix; 4 verified security controls | ☐ | |
| M9 DevOps & Cloud | A restore drill and a rollback actually rehearsed | ☐ | |
| M10 Advanced & Professional | Capstone accepted; 15-minute trade-off defense | ☐ | |

---

## Monthly review (fill in monthly)

- **Highest level reached this month:** (dimension + topic + evidence)
- **Biggest gap discovered:** (which lesson/level it belongs to → schedule revision)
- **Bugs I diagnosed:** count, plus one sentence on method
- **Something I can now do that I could not do 30 days ago:** (be specific and observable)
- **Next month's single focus:** (one thing, not five)

Template copy: [templates/progress-template.md](templates/progress-template.md)