# 20 — Project Laboratory

Lessons teach fragments; projects are where they become one skill. This laboratory contains seven
graded projects and a capstone. Each brief is a real specification: problem, users, testable
requirements, architecture and data model guidance, milestones, testing strategy, security
requirements, deployment plan, acceptance criteria and extension challenges.

A brief is deliberately not a tutorial. It states what must be true when you are finished and leaves
the design to you, because the design decisions are what a reviewer — and an interviewer — will ask
about.

## The projects

| # | Project | Core competencies | Draws on subjects |
|---|---|---|---|
| 01 | [Command-line application](project-01-command-line-application/README.md) | Algorithms, file I/O, errors, tests | 01–05 |
| 02 | [Responsive portfolio](project-02-responsive-portfolio/README.md) | Semantic HTML, responsive layout, accessibility, JS | 06–08 |
| 03 | [Database application](project-03-database-application/README.md) | Relational modelling, SQL, transactions | 10 |
| 04 | [REST API](project-04-rest-api/README.md) | Java, Spring Boot, PostgreSQL, validation, testing | 04, 10, 11, 14 |
| 05 | [Full-stack application](project-05-full-stack-application/README.md) | React + TypeScript, API integration, auth | 09, 11, 15 |
| 06 | [Flutter mobile application](project-06-flutter-mobile-app/README.md) | Dart, Flutter, state, offline, mobile testing | 12 |
| 07 | [Secure production application](project-07-secure-production-application/README.md) | Architecture, security, CI/CD, deployment, monitoring | 13–17 |
| — | [Capstone](capstone-project/README.md) | Everything, in one coherent product | all |

Projects 01–03 are scoped to a few evenings. Project 04 and 05 are a few weeks. Project 06 assumes a
Flutter environment. Project 07 and the capstone are open-ended and are the portfolio pieces.

## How projects are structured

Each project directory contains two things:

- `README.md` — the brief, written from [the project template](../templates/project-template.md). The
  eighteen sections are the contract: requirements are numbered and testable, acceptance criteria are
  binary, and the testing and security sections say which requirement each check proves.
- `reference-solution/README.md` — a solution guide written **after** the brief. It describes one
  defensible design, the trade-offs it makes, and where another choice would be equally correct. It
  is a review aid, not a code dump.

## Grading rubric

Every project is graded on the same seven dimensions, with weights that shift slightly for the
later projects. Score each dimension 0–4, multiply by the weight, and total out of 100.

| Dimension | Weight (01–03) | Weight (04–07, capstone) | A 4 looks like | A 1 looks like |
|---|---|---|---|---|
| Requirements | 20 | 15 | Every FR demonstrably implemented; deviations documented | Requirements reinterpreted silently |
| Correctness | 25 | 25 | Acceptance criteria pass on a clean checkout | Happy path only; edge cases crash |
| Tests | 15 | 20 | Tests fail when the behaviour is broken; coverage of risk, not of lines | Tests assert nothing or only the happy path |
| Documentation | 15 | 10 | Stranger can install, run and operate from the README | README lists technologies, not steps |
| Security | 10 | 15 | Controls verified by a test or a command | Security section restates the requirement |
| Operations | 10 | 10 | One-command run; health check; rollback path | "Works on my machine" |
| Walkthrough | 5 | 5 | Explains every decision and the weakest part | Recites features |

Two rules keep the rubric honest. A dimension scored 0 in **Correctness** or **Security** caps the
project at 40 regardless of the rest, because a project that is wrong or unsafe is not partially
correct. And the walkthrough is scored against the code as submitted: a claim the code does not
support scores zero for that claim, not partial credit.

A project is **complete** when every acceptance criterion passes and the total is at least 70. A
project is **portfolio-ready** at 85 or above with a live deployment — that is the bar the
professional-development subject's portfolio lesson assumes.

## The solutions rule (read this)

**Reference solutions exist to check your work, not to produce it.** Each opens with a warning
header, lives in its own directory, and is written only after the brief it belongs to. Reading a
solution before attempting the core requirements produces recognition — which feels like knowledge
and is not — and it is trivially visible in a walkthrough.

The intended cycle:

1. Read the brief. Write your understanding of the requirements in your own words.
2. Implement the core requirements. Fight for it.
3. Check the acceptance criteria yourself, honestly.
4. *Then* read the solution guide: note what differs, and whether your choice was defensible.
5. Attempt at least one extension challenge.

The solution guides are deliberately design-level. They show structure, schema, key algorithms and
trade-offs; they do not provide a complete file tree you can copy. Where a project has a small,
self-contained algorithm (project 01's parser, project 03's query), the guide gives the reasoning and
the shape, not the finished function.

## Prerequisites

- [02-PROGRAMMING-FUNDAMENTALS](../02-PROGRAMMING-FUNDAMENTALS/README.md) and
  [03-DEVELOPER-TOOLS](../03-DEVELOPER-TOOLS/README.md) — required by project 01 and assumed by all
  the others
- [10-DATABASE-ENGINEERING](../10-DATABASE-ENGINEERING/README.md) — required by projects 03, 04 and 05
- [11-BACKEND-ENGINEERING](../11-BACKEND-ENGINEERING/README.md) — required by projects 04 and 05
- [14-TESTING-AND-QUALITY](../14-TESTING-AND-QUALITY/README.md) — every project is graded on tests
- [19-PROFESSIONAL-DEVELOPMENT](../19-PROFESSIONAL-DEVELOPMENT/README.md) — the workflow, review and
  documentation habits the rubric assumes; do it alongside project 04 or later

Each brief lists its own lesson-level prerequisites in section 5, with the requirement each one
supports.

## Lessons

The briefs, in order:

- [Project 01 — Command-Line Application](project-01-command-line-application/README.md)
- [Project 02 — Responsive Portfolio](project-02-responsive-portfolio/README.md)
- [Project 03 — Database Application](project-03-database-application/README.md)
- [Project 04 — REST API](project-04-rest-api/README.md)
- [Project 05 — Full-Stack Application](project-05-full-stack-application/README.md)
- [Project 06 — Flutter Mobile Application](project-06-flutter-mobile-app/README.md)
- [Project 07 — Secure Production Application](project-07-secure-production-application/README.md)
- [Capstone Project](capstone-project/README.md)

## Exercises and practice

The projects *are* the practice. Each brief ends with extension challenges that add genuinely harder
requirements — cache invalidation, rate limiting, an offline conflict policy, a migration with
rollback — and state what each teaches. Extensions are optional for completion and expected for a
portfolio piece.

Suggested pacing: one project per two weeks for 01–03, three to four weeks for 04–05, and a full
six-week block for 06, 07 or the capstone. Attempt project 07 only after the security and cloud
subjects, since it is graded on controls you will otherwise invent badly.

## Expected outcomes

A portfolio of eight artefacts of increasing sophistication, each with tests, documentation and — for
the later ones — a deployed URL, a pipeline, a runbook and an architecture decision record. That is
the evidence employers ask for, and the reason this repository exists.

You should also be able to walk into an interview with any one of them and survive twenty minutes of
"why this way?" without notes. If you cannot, the project is not finished, whatever the rubric says.

## Next

[19-PROFESSIONAL-DEVELOPMENT](../19-PROFESSIONAL-DEVELOPMENT/README.md) to package the work
professionally, and [21-REFERENCE-LIBRARY](../21-REFERENCE-LIBRARY/README.md) for daily lookup. The
capstone is the last thing you build here, and the first thing you show.
