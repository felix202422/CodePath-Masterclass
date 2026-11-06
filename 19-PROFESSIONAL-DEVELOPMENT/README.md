# 19 — Professional Development

Engineering is a team activity practised under constraints. By this point in the curriculum you can
build software; this subject is about making that ability legible, reviewable, and sustainable in an
organisation. Nine lessons cover the workflows, habits and communication that turn technical skill into
work other people can trust.

Each lesson answers a failure that happens to competent engineers:

- **Engineering workflows** — a change that was correct on Monday conflicts on Friday, and nobody can
  say which of 280 trunk changes broke it.
- **Code review** — a 2,000-line pull request is approved in ten minutes, and the defect it contains
  ships.
- **Technical documentation** — the runbook is opened at 03:00 by someone who has never seen the
  service, and it says "check the dashboard".
- **Open-source contributions** — a newcomer spends a weekend on a fix nobody asked for, is closed
  without explanation, and stops contributing.
- **Debugging methodology** — an engineer changes four things at once, the symptom disappears, and the
  cause is now permanently unknown.
- **Technical interviews** — a strong engineer fails a loop because the rubric measured puzzle speed
  rather than engineering, and neither side learns anything.
- **Portfolio development** — five tutorial repositories, a dead demo link, and no project that can be
  discussed for twenty minutes.
- **Teamwork and communication** — a status update without an ask leaves two people waiting on each
  other for three days.
- **Career paths** — an excellent senior engineer takes a management role for the salary and discovers
  the work is not the work they wanted.

## What this subject covers

The nine lessons are ordered as a programme rather than a list. Workflows and review come first because
they are the daily loop; documentation and open source because they are how work becomes legible
outside the team; debugging and interviews because they are the two high-pressure performances; then
portfolio, communication and career, which are the longer arc.

| Register | Lesson | The skill it builds |
|---|---|---|
| `PROF-02` | [Engineering Workflows](engineering-workflows.md) | Slicing, integration, pipelines, gates and queues |
| `PROF-03` | [Code Review](code-review.md) | Reviewing and being reviewed without wasting attention |
| `PROF-04` | [Technical Documentation](technical-documentation.md) | READMEs, guides, references and runbooks for real readers |
| `PROF-05` | [Open-Source Contributions](open-source-contributions.md) | Finding, doing and landing work in projects you do not own |
| `PROF-06` | [Debugging Methodology](debugging-methodology.md) | Reproduce, isolate, falsify, fix, prevent |
| `PROF-07` | [Technical Interviews](technical-interviews.md) | How loops measure, and preparation that transfers |
| `PROF-08` | [Portfolio Development](portfolio-development.md) | Evidence a reviewer can verify |
| `PROF-09` | [Teamwork and Communication](teamwork-and-communication.md) | Status, decisions, asks and disagreement |
| `PROF-10` | [Career Paths](career-paths.md) | Levels, tracks, promotion evidence and compensation shape |

## How the lessons are verified

Every lesson in this subject carries one Python probe, embedded in section 7 and executed on the lab
host. The rules are the same for all nine:

- **Executed, not imagined.** The `Expected output` block is the captured stdout of the probe in the
  lesson, produced by `python <name>_probe.py` on Windows 11 with Python 3.13.5. The probe uses the
  standard library only, makes no network calls, and does not read the clock.
- **Arithmetic over declared inputs.** Nothing here is a stopwatch benchmark. Where a lesson needs a
  duration — review speed, interruption recovery, interview length — the constant is printed next to
  the result and labelled as a modelling assumption.
- **Counts where counts exist.** Commits bisected, defects caught per gate, comments per severity,
  person-days blocked. These are computed from the input in the lesson, so a reader can change a
  parameter and rerun.
- **Absent infrastructure is labelled reference.** No lesson requires a ticket tracker, a CI service, a
  code-review platform, a hiring pipeline or an employer's ladder document. Where real systems would be
  used, the lesson says so and the probe models the arithmetic instead.

The probes are small enough to read in one sitting, which is the point: a number you cannot recompute
is a number you have to trust, and this subject is about not having to.

## Prerequisites

- [18-ADVANCED-ENGINEERING](../18-ADVANCED-ENGINEERING/README.md) — system design, reliability and
  large-codebase work, which every lesson here assumes as background
- [14-TESTING-AND-QUALITY](../14-TESTING-AND-QUALITY/README.md) — tests, coverage and quality gates;
  review and debugging are unintelligible without them
- [13-SOFTWARE-ENGINEERING-AND-ARCHITECTURE](../13-SOFTWARE-ENGINEERING-AND-ARCHITECTURE/README.md) —
  process, technical debt and design vocabulary used throughout
- [03-DEVELOPER-TOOLS/git-fundamentals.md](../03-DEVELOPER-TOOLS/git-fundamentals.md) and
  [03-DEVELOPER-TOOLS/pull-requests-and-code-review.md](../03-DEVELOPER-TOOLS/pull-requests-and-code-review.md)
  — the mechanics the workflow and review lessons price
- One project of your own, at least a few weeks old. Every exercise in this subject is applied to your
  own work; without a project to apply them to, the lessons stay theoretical.

## Lessons

1. [Engineering Workflows](engineering-workflows.md) — trunk-based integration, review batching,
   pipeline wall time, gate economics and WIP limits.
2. [Code Review](code-review.md) — what review is for, how size degrades detection, comment severity,
   and review latency as a queue.
3. [Technical Documentation](technical-documentation.md) — document types by reader, completeness,
   drift, runbook actionability and freshness.
4. [Open-Source Contributions](open-source-contributions.md) — triage, the contribution funnel,
   pull-request size and maintainer response distributions.
5. [Debugging Methodology](debugging-methodology.md) — reproduction, bisection, hypothesis elimination,
   coverage-based localisation and regression proof.
6. [Technical Interviews](technical-interviews.md) — loop structure, weighted rubrics, kappa, work
   samples and the cost of a hire.
7. [Portfolio Development](portfolio-development.md) — evidence audits, tutorial tells, depth and the
   reviewer's six-minute scan.
8. [Teamwork and Communication](teamwork-and-communication.md) — status fields, interruption batching,
   sync versus async decisions, specific asks and escalation.
9. [Career Paths](career-paths.md) — ladder dimensions, level distance, readiness, span, compensation
   shape and stalls.

## Exercises and practice

Every lesson has five exercises numbered by its register entry: `PROF-0N` uses `N.1`–`N.5`, split into
two introductory, two intermediate and one independent problem. The independent exercise is always
applied to your own work, because the subject's claims are only testable against a real project.

Practice is cumulative:

- Run the probes and change one parameter each time. A model you have not perturbed is a model you have
  not understood.
- Apply the workflow and review exercises to one real change, and keep the evidence.
- Audit your own repository with the documentation and portfolio probes; the missing-items lists are
  the backlog.
- Do the debugging exercise on a real bug and keep the log.
- Land one external contribution, however small.
- Write the promotion case from the career lesson, even if you are not asking for promotion.

Exercises are designed to be attempted before solutions are consulted. Solutions live in `solutions/`
of this subject.

## Expected outcomes

You can run a complete change workflow without supervision, including deciding when a change is too
large to review. You can review code so that the author knows what to change and why. You can write a
document that a stranger completes a task with, and a runbook a tired person can execute. You can land a
change in a project you do not own. You can debug an unfamiliar system by eliminating causes instead of
guessing. You can present your work in an interview, on a portfolio page and in a promotion packet
without overclaiming. You can say what you need from a teammate in one message.

## Common blockers

- **Preparing to interview instead of preparing to engineer.** Interview performance tracks engineering
  skill more than trick memorisation; the timed sets here exist to expose gaps, not to replace projects.
- **A portfolio of tutorials.** One project you can defend deeply beats five you followed. The portfolio
  probe's missing-items list is more useful than another course certificate.
- **Avoiding review.** Being reviewed early and often is the fastest skill accelerator available, and the
  least comfortable. The review lesson's severity vocabulary makes it survivable.
- **Documentation as a one-time task.** Drift is continuous; a document without a drift check is a
  document that will be wrong. Add the check before writing more prose.
- **Treating promotion as tenure.** Evidence of scope is the currency; time in role is not.

## Next

[20-PROJECT-LABORATORY](../20-PROJECT-LABORATORY/README.md) — seven graded projects and a capstone where
the whole curriculum converges. The professional-development lessons are the rubric's non-technical half:
workflow, review, documentation, contribution, debugging log, portfolio and the final presentation.
