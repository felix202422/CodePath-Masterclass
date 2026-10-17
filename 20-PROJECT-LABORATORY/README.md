# 20 — Project Laboratory

Lessons teach fragments; projects are where they become one skill. This laboratory contains seven
graded projects plus a capstone, each with a problem statement, requirements, architecture and data
model guidance, milestones, testing strategy, security requirements, deployment plan, acceptance
criteria, and extension challenges.

## The projects

| # | Project | Core competencies | Assesses subjects |
|---|---|---|---|
| 01 | Command-line application | Algorithms, functions, data structures, debugging | 01–05 |
| 02 | Responsive portfolio | Semantic HTML, responsive layout, accessibility, JS | 06–08 |
| 03 | Database application | Relational modeling, SQL, persistence | 10 |
| 04 | REST API | Java, Spring Boot, PostgreSQL, validation, testing | 04, 10, 11, 14 |
| 05 | Full-stack application | React + TypeScript, API integration, authentication | 09, 11 |
| 06 | Flutter mobile application | Dart, Flutter, state, offline, mobile testing | 12 |
| 07 | Secure production application | Architecture, security, CI/CD, deployment, monitoring | 13–17 |
| — | **Capstone** | Everything, in one coherent product | all |

## How projects are structured

Each project directory contains:

- `README.md` — the full brief (from [templates/project-template.md](../templates/project-template.md)):
  problem, users, functional and non-functional requirements, architecture, data model, API
  contract, milestones, testing strategy, security requirements, deployment plan, and acceptance
  criteria.
- `reference-solution/` — a complete reference implementation with its own README explaining the
  approach and its trade-offs.

## The solutions rule (read this)

**Reference solutions exist to check your work, not to produce it.** They open with a warning
header, and they are deliberately separated from the brief. Reading a solution before attempting
the core requirements produces recognition — which feels like knowledge and is not — and it is
trivially visible in review: the questions in a walkthrough expose it immediately.

The intended cycle:

1. Read the brief. Write your understanding of the requirements in your own words.
2. Implement the core requirements. Fight for it.
3. Check the acceptance criteria yourself, honestly.
4. *Then* compare with the reference solution: note what differs, and why your choice was
   defensible or not.
5. Attempt at least one extension challenge.

## Grading yourself

Each project's acceptance criteria are binary and observable — a reviewer can run them top to
bottom. Use them as a real gate: mark a project done only when every criterion passes, and log it
in your [PROGRESS-TRACKER.md](../PROGRESS-TRACKER.md).

Deeper evidence comes from the walkthrough: for any finished project, you should be able to
explain every architectural decision, point out the weakest part of your design, and name what you
would change with three more weeks. That ability — not the code alone — is what employers test.

## Prerequisites

Each project page states its own; the sequence 01 → 07 assumes the corresponding subjects in
order. Project 01 requires [02](../02-PROGRAMMING-FUNDAMENTALS/README.md) and
[03](../03-DEVELOPER-TOOLS/README.md); Project 07 requires subjects
[13](../13-SOFTWARE-ENGINEERING-AND-ARCHITECTURE/README.md)–[17](../17-CLOUD-AND-PRODUCTION/README.md).

## Lessons

Project briefs are written as full specifications rather than lessons:

- `project-01-command-line-application/README.md`
- `project-02-responsive-portfolio/README.md`
- `project-03-database-application/README.md`
- `project-04-rest-api/README.md`
- `project-05-full-stack-application/README.md`
- `project-06-flutter-mobile-app/README.md`
- `project-07-secure-production-application/README.md`
- `capstone-project/README.md`

## Exercises and practice

The projects *are* the practice. Each brief ends with extension challenges that add genuinely harder
requirements (a cache invalidation problem, a rate limiter, an offline sync conflict policy) and
state what each teaches.

## Expected outcomes

A portfolio of eight artifacts of increasing sophistication, each with tests, documentation, and —
for the later ones — a deployed URL, a pipeline, and an architecture decision record. That is the
evidence employers ask for, and the reason this repository exists.

## Next

[capstone-project/](capstone-project/README.md) — or, alongside projects, keep going with
[19-PROFESSIONAL-DEVELOPMENT](../19-PROFESSIONAL-DEVELOPMENT/README.md) to package them
professionally, and [21-REFERENCE-LIBRARY](../21-REFERENCE-LIBRARY/README.md) for daily lookup.