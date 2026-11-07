# Reference guide — how a capstone is assessed

> **This is not a solution.** There is no reference implementation of your product, and a guide that
> supplied one would turn the only project where you choose the problem into another exercise with an
> answer key. This document describes what reviewers look for and what separates a pass from a strong
> portfolio piece.

## What the reviewer does, in order

1. Opens the README and looks for a live URL. If it is there, they use it as a stranger would.
2. Signs up with a throwaway account, completes the primary job, and tries to break it with bad input.
3. Clones the repo, follows the 60-second start, and runs the tests.
4. Reads `requirements.md` and picks three requirements to trace to tests.
5. Reads the threat model and checks one control in the code.
6. Opens the dashboard and the SLO document.
7. Asks the walkthrough questions in section 12 of the brief.

Nothing in that list is a feature. Every item is evidence that the product is real, and the whole
capstone is designed so a small product can score highly on all seven steps.

## The score bands

| Total | What it means | Typical shape |
|---|---|---|
| Below 50 | Not complete | Deployed or requirements missing; tests assert little |
| 50–69 | Incomplete | Works locally, or works deployed but unverified and undocumented |
| 70–84 | Complete | Deployed, requirements met and traced, tests meaningful, docs usable |
| 85–94 | Portfolio-ready | All of the above plus measured NFRs, a real user, an incident or drill with evidence |
| 95+ | Distinction | All of the above plus a coherent scope argument and a walkthrough that names its own weakest point |

The rubric in the [laboratory overview](../../README.md#grading-rubric) supplies the weights. The bands
above are what the totals look like in practice; they are not a second rubric.

## The five things that most often cost marks

1. **Scope chosen for the demo, not the user.** Six half-features, none complete. A reviewer scores
   Requirements at 2 because half the FRs are "in progress". Cutting to four requirements that all pass
   moves the same work up two bands.
2. **Tests that cannot fail.** Snapshot tests of a page, or assert-the-status-is-200 with no body check.
   The rubric asks whether the test fails when the behaviour breaks; reviewers check by breaking it.
3. **Authorisation in the UI.** A hidden admin button with no server check is the single most common
   critical finding, and it caps Security at 0.
4. **Deployment claimed but not reproducible.** A URL that 404s, or a README whose start command fails on
   a clean clone. This is cheap to prevent and expensive to discover during review.
5. **A walkthrough that recites features.** The walkthrough is 5% of the score but it changes how the
   other 95% is read. "It uses React and Postgres" answers nothing; "I chose a session cookie because
   revocation mattered more than statelessness, and here is the cost" answers the question being asked.

## What a strong scope decision looks like

> "The job is: a small charity needs to record who borrowed which of 40 items. I am not building
> reservations, notifications or a mobile app. I am building one list, one lend action, one return
> action, and a CSV export, for two users, with an audit row per change. That is four requirements and
> it is finished."

That paragraph, in `requirements.md`, is worth more than another feature. It shows the reviewer that the
boundary was chosen rather than hit.

## Evidence that is easy to produce and disproportionately convincing

- A dated `evidence/loadtest-2026-10-14.md` with a p95 and the first bottleneck named.
- A dated `evidence/restore-2026-10-09.md` with durations and row counts compared.
- A screenshot per UI state, including the empty and error states.
- A screenshot of the dashboard with a deploy marker and the SLO line.
- One alert that fired, with the message and the time to acknowledge.
- The user trial notes, in the user's words, including the complaint you did not fix.

None of these takes more than an hour. Together they are the difference between "I built this" and "this
runs".

## The walkthrough

Fifteen minutes, four parts:

1. **The user and the job** (2 min) — who, what they did before, what changed.
2. **The architecture as deployed** (4 min) — diagram, one request's path, where auth is enforced, where
   state lives. Say what you did not build.
3. **The evidence** (4 min) — one test that fails when broken, the load test, the restore, the alert.
4. **The weakest part** (3 min) — name it before the reviewer does, say what you would do with another
   two weeks, and what you would reverse.

Prepare for three questions: "What happens if two users do this at once?", "Where is the authorisation
check and how do you know?", and "What breaks first at 10× traffic?" Each has an answer in your evidence
if the project is finished.

## If you are not going to finish

Say so early and reduce scope in writing. A capstone that delivers three requirements, deployed, tested,
documented and measured, at 75, is a better outcome than an unfinished six-feature product at 55. The
professional skill being assessed includes knowing what fits in the time, and the brief's G0 gate exists
to make that decision cheap.

## What is deliberately missing

A product idea, a stack recommendation and a feature list. Those are the capstone.
