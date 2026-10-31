# Set 1 solutions — The complete development process · Software development lifecycle → `the-complete-development-process.md` · `software-development-life-cycle.md`

*Executed in the batch's `orderdesk` scratch repo (Java 25, git 2.x, Windows 11). Blocks
marked *reference* are shapes to run in your lab.*

## 1. The staged mini-repo trace

Rebuild: `mkdir orderdesk && cd orderdesk && git init`, then commit one feature in labeled
stages. The lesson's own nine-commit trace (executed on the authoring machine):

```
f790e5d stage 1-4: problem, stakeholders, feasibility, scope
bb50831 stage 5: requirements drafted with acceptance criteria
919799e stage 6: validation caught ACC arithmetic error (20.00 x 1.07 = 21.40, not 18.70)
7774e0d stage 9-12: spike result, ADR-001 accepted, interface contracts
dc30992 stage 16-18: engine + acceptance harness green (ALL PASS)
facc706 stage 14+18: test strategy executed - NFR1 measured 326us < 50000us
d7e1b96 stage 18: defect introduced - harness RED (captured: unknown-region-no-tax got 10.0 want 5.0)
43832b0 stage 19: defect fixed, regression verified green
805c17f stage 20-22: staged acceptance, v0.1.0 released
```

Before looking at the lesson's list, name your own stage labels and check each commit maps
to exactly one stage — the discipline being trained is that *every commit has a reason in
the process*, not that these nine subjects are canonical. Note the two red-then-green
pairs (stage 18 → 19) and that stage 14 sits *after* stage 16-18: real processes
interleave, and the log admits it.

## 2. The validation catch

The requirements said `ACC: … 2 lines of 10.00 in EU … THEN 18.70`. The engine computed
`21.40`, and arithmetic agreed: 20.00 × 1.07 = 21.40. Executed capture:

```
caught ACC arithmetic error (20.00 x 1.07 = 21.40, not 18.70)
```

Reproduce it: write an expected value on paper, compute it in a script, diff the two.
Capture your failing output, the one-commit fix, and the passing rerun. Why the check must
live in a script: your head did the arithmetic and got `18.70` — the machine got it right.
An expectation that is only ever re-read, never re-run, decays into decoration.

## 3. The false-green incident

Executed in the lesson: `GREEN_EXIT=0` was printed while commits claiming green were made
against a harness that was actually red (`GREEN_EXIT=1` yet the commit claiming
`acc-eu-discount10` passed — the number compared was still `19.27` where the spec said
`19.26`). `git commit` runs your hooks, not your tests. Reproduce in under a minute:

1. Break a test, run it, capture the red (`exit 1`).
2. `git commit -m "green"` — it succeeds; `git log` records it.
3. Add a pre-commit hook (`npm test && git commit`-style, or `pre-commit run --files`)
   or a CI branch gate, retry the same commit, capture the refusal.

The lesson's recovery order matters: `git reset --hard` the false commits, verify
`GREEN_EXIT=0` *first*, then commit. The hosted-CI half of this exercise (a real
GitHub Actions branch protection run) is **labelled reference** — the authoring machine
has no hosted pipeline; the local pre-commit shape above is the executed part. In your
environment, capture: the red run, the successful bad commit, the gated run refusing it.

## 4. Independent — minimum viable process for two people (reference shape)

| Stage | Artifact | Gate |
|---|---|---|
| Requirement | 3 FRs + 2 GIVEN/WHEN/THEN ACs with concrete values | ACs executable as input → expected output |
| Code | the diff | — (no gate; too cheap to gate) |
| Test | harness run | `GREEN_EXIT=0`, script not memory |
| Validation | traceability row per requirement | `uncovered: []` |
| Release | tag | the same green run, recorded |

Everything the full SDLC has and this drops (formal design review, separate QA phase,
sign-off ceremonies) is dropped because exercises 1–3 measured its cost for a team that
size: the only failure mode you actually hit was *claiming green*, and one gate kills it.
Merge the roles; never merge the gate.