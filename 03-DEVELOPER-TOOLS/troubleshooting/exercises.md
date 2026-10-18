# Exercises — graded diagnosis drills

These drills are this subject's practice half (per [CURRICULUM-MAP.md](../../CURRICULUM-MAP.md),
competency practice for 03 lives here). **Rules of engagement:** attempt each drill *before*
opening its guide — the guides are the answer keys, and reading them first costs you the only
skill being trained. Everything runs on your own machine in disposable folders; nothing needs sudo,
a paid account, or your real repositories.

**Evidence standard for every drill:** your own terminal output, plus **one sentence of
prevention** — a fix you cannot repeat tomorrow is only half complete.

---

## Tier 1 — shell and environment

**Drill 1.1 — The invisible variable.** In one bash session: create `MY_DRILL=visible`, prove a
child shell cannot see it, export it, prove it can, then prove a child cannot write back.
*Guide:* [../environment-variables.md](../environment-variables.md) Example 1.
**Completion criteria:** all four states shown in your own output, and one sentence: what
`export` actually copies.

**Drill 1.2 — Break PATH, diagnose PATH, repair PATH — inside a subshell.** Start `bash`,
set `PATH=/nowhere`, demonstrate one external command failing (note its exit code) and one
built-in still working, then restore PATH from the parent's value *without exiting*.
*Guide:* [command-not-found.md](command-not-found.md).
**Completion criteria:** the 127, the working built-in, and the repaired `ls` — plus your repair
command written down.

**Drill 1.3 — The permission that lies.** On Windows: `chmod 600` a file, immediately `ls -l`,
and state what happened and why the exit code cannot be trusted. If you have WSL or a Linux box,
repeat there and capture the real `600`.
*Guide:* [permission-denied.md](permission-denied.md).
**Completion criteria:** both transcripts (or a labelled "no Linux available" note) and the
one-command verification idiom you will use from now on.

**Drill 1.4 — The phantom diff.** Create a CRLF file and an LF file in a fresh repo, stage both,
and prove with `git show :<file> | od -c` what the repository stores. Then add `.gitattributes`
and show the `attr/` column change.
*Guide:* [line-endings.md](line-endings.md); *lesson:* [../editors-and-ides.md](../editors-and-ides.md).
**Completion criteria:** `i/lf` for both files, the `od -c` proof, and the `attr/text=auto` column
afterwards.

---

## Tier 2 — Git state

**Drill 2.1 — Commit with nothing staged.** Produce Git's refusal and its exit code; then state
how a script should branch on it.
*Guide:* [../git-fundamentals.md](../git-fundamentals.md) Example 6.
**Completion criteria:** the message, the exit code, and a correct one-sentence script rule.

**Drill 2.2 — The lost commit.** Make three commits, `reset --hard HEAD~2`, then recover the
branch to its full three commits using the reflog — **without** re-doing the work.
*Guide:* [git-recovery.md](git-recovery.md) Procedure 2.
**Completion criteria:** the `reflog` entry you used, the recovery command, and `git log`
showing all three commits afterwards. Also name one class of loss the reflog **cannot** recover.

**Drill 2.3 — Detached and unafraid.** Check out an older commit, make one commit while detached,
and bring it safely onto a named branch. Then visit a commit you have *no* interest in keeping
and return with `git switch -`.
*Guide:* [git-recovery.md](git-recovery.md) Procedure 3.
**Completion criteria:** the orphaned commit reachable from a real branch (`git branch --contains`),
and your explanation of where those commits lived before you named them.

**Drill 2.4 — The upstream push.** Publish a brand-new branch with bare `git push` (capture the
fatal), then repair exactly as Git suggests; afterwards show `git branch -vv` with the bracketed
tracking entry, and explain what the two config keys are.
*Guide:* [no-upstream.md](no-upstream.md).
**Completion criteria:** fatal → fix → `branch -vv` evidence chain, plus the two key names.

---

## Tier 3 — collaboration and remote state

**Drill 3.1 — Manufacture a conflict between two clones.** With a bare origin and two clones
(from [../github-workflows.md](../github-workflows.md) Example 1's setup): edit the same line in
both, push the first, and merge in the second — producing the real markers. Read both sides' commit
messages, write a *combined* resolution, finish the merge, and show the merge commit in `--graph`.
*Guide:* [merge-conflict.md](merge-conflict.md).
**Completion criteria:** markers captured before the fix; no `<<<<<<<` remains
(`grep -n '<<<<<<<' <file>` returns nothing); the graph shows a two-parent merge; one sentence on
what each side intended.

**Drill 3.2 — Abort, then finish, the same conflict.** Repeat Drill 3.1's setup, but abort the
first merge and verify exact restoration; then redo and complete it.
*Guide:* [merge-conflict.md](merge-conflict.md) "exit ramps".
**Completion criteria:** `git status` clean after abort with the pre-merge commit still HEAD,
then a completed merge on the second attempt.

**Drill 3.3 — The empty clone.** Create a bare repo (`git init --bare -b main` vs plain
`git init --bare`), push `main` to the *plain* one, clone it, and capture the failure; repair with
`symbolic-ref` and re-clone successfully. Also repair the stuck clone *in place* with
`git remote set-head origin -a`.
*Guide:* [clone-empty.md](clone-empty.md).
**Completion criteria:** failure and success transcripts from your hands, plus the one-flag
prevention (`init --bare -b main`).

**Drill 3.4 — The behind state.** In a two-clone setup, let one clone fall behind (commit/push
from the other), then from the stale clone produce `git status -sb` with `[behind N]`, prove N with
`git rev-list --count HEAD..origin/main`, and integrate with `pull --ff-only`.
*Guide:* [review-loop.md](review-loop.md) §1.
**Completion criteria:** the marker line, the count, and the fast-forward output — plus the choice
you would make if the *local* side had diverged instead (rebase vs merge, with the rule cited).

**Drill 3.5 — The undeclared dependency.** In a scratch npm project: use a package that exists
only on *your* machine (install a real one but do **not** save it — `npm install --no-save <pkg>`
or a global install), commit the manifest, then reproduce a teammate's failure from a clean clone
path (`rm -rf node_modules && npm ci && node -e "require('<pkg>')"`).
*Guide:* [dependency-tree.md](dependency-tree.md) Fix C/D.
**Completion criteria:** the `Cannot find module` reproduced from declared-files-only state, the
manifest repair (`npm install <pkg>` so it becomes a real dependency), and the green re-run.

---

## Tier 4 — capstone (the Milestone 2 gate)

**Drill 4.1 — The required history.** In one practice repository, satisfy the
[ROADMAP](../../ROADMAP.md) Milestone 2 requirement outright:

- **≥ 20 commits** with messages that read as a story (subject line *why* + body where non-obvious);
- across **≥ 5 branches**, integrated as at least one fast-forward *and* one true merge;
- **one conflict resolved by hand** (Drill 3.1's standard: combined, not copied);
- **one mistake recovered with `restore` or `revert`** — including a *shared*-history mistake that
  must be undone with `revert`, demonstrated by a second clone pulling the corrected history;
- one abandoned experiment via `merge --abort` or a deleted failed branch.

**Completion criteria:** `git log --graph --oneline --all` narrated in two minutes — branch by
branch, conflict by conflict — with every narrated claim verifiable in the commits themselves.
This drill *is* the promotion evidence named in the ROADMAP; keep the repository.

**Drill 4.2 — The issue-to-merge trail.** The full loop from
[../pull-requests-and-code-review.md](../pull-requests-and-code-review.md) exercise 6: issue →
branch → commits → self-review (three-dot diff) → four-part description → PR (real with `gh`, or
annotated-and-labelled-unexecuted) → review comment addressed → merge per your chosen policy →
`pull --ff-only` back on `main` in the second clone.
**Completion criteria:** a stranger could reconstruct what changed, why, how it was checked, and
who decided, from the artifacts alone.

---

## Self-assessment before leaving this subject

You are done with 03 when all of these are *demonstrated*, not merely read:

1. You can produce and repair a PATH failure, a lost-commit, and a conflict **on demand** — each
   from memory, each verified by output you show.
2. Your Tier-4 repository exists, and its graph survives your two-minute narration.
3. You have stated — in writing, in your own notes — your merge policy and your line-ending policy
   for future projects, each with a one-line reason.
4. Every drill above has your output attached; any drill you could not run (no WSL, no GitHub
   account) is listed honestly as *not run*, with the reason — the same honesty standard this
   repository's transcripts follow.
