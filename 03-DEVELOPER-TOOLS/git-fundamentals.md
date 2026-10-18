# Git Fundamentals

## 1. Learning Objectives

After this lesson you will be able to:

- [ ] Explain the three areas — working tree, index (staging), repository — and say what each
      `git add` / `git commit` moves between them.
- [ ] Initialize a repository, stage selectively, and commit with a message that says *why*.
- [ ] Read `git status` and `git diff` in all their forms (``, `--cached`, `HEAD`) and predict
      which one shows what.
- [ ] Choose the correct undo tool — `restore`, `restore --staged`, `stash`, `reset`, `revert`,
      `amend` — for a given mistake, and name what each one destroys.
- [ ] Recover a seemingly lost state using the reflog.
- [ ] Interpret a commit graph and describe what `HEAD` points at at any moment.

## 2. Prerequisites

- [terminal-fundamentals.md](terminal-fundamentals.md) — exit codes, paths, and reading terminal
  output are assumed throughout.
- [02-PROGRAMMING-FUNDAMENTALS/modular-programming.md](../02-PROGRAMMING-FUNDAMENTALS/modular-programming.md)
  — you need multi-file programs worth versioning; Git on an empty folder teaches nothing.

**Environment used in this lesson:** every transcript executed on the author's machine — Git
2.55.0.windows.3 on Windows 11 (Git Bash). The sandbox repositories use the identity
`Learner Example <learner@example.com>`, set with local `git config`; nothing here touched a
global configuration or a real remote. Commit hashes in your runs will differ — that is the
nature of content-addressed storage, not an error.

## 3. Introduction

Git has a reputation for being hard, and the reputation is mostly about *vocabulary* catching
people off guard: "index", "staging", "HEAD", "detached". Strip the vocabulary and Git is one idea
repeated: **snapshots of your project, addressable by hash, with pointers choosing which snapshot
is "now"**. Everything else — branches, merging, stashing — is bookkeeping on top of that idea.
This lesson builds the bookkeeping in the order you will actually need it: make a snapshot, see a
snapshot, *undo* a snapshot.

## 4. The Problem It Solves

Without version control, every change is a one-way door: you keep `.bak` files, you fear the
experiment, and collaboration means zip files named `final-v2-FIXED.zip`. Git makes change
reversible by construction — every committed state is addressable forever — which is what makes
risk affordable: try the rewrite, because `git restore` is three keystrokes away. That reversibility
is also the foundation everything else in this subject stands on: branching (next lesson), GitHub
(workflows after), and review all work because commits are permanent and cheap.

## 5. Core Concepts

### The three areas

| Area | What it holds | Whose bookkeeping |
|---|---|---|
| **Working tree** | The files you see and edit | Yours, until you stage |
| **Index (staging area)** | The *exact* snapshot your next commit will contain | Yours, via `git add` |
| **Repository** (`.git`) | Every committed snapshot, plus refs pointing at them | Git's, via `git commit` |

`git add` copies working-tree state **into the index**; `git commit` freezes the **index** into a
permanent snapshot and moves the branch pointer to it. Staging is what lets you craft a commit
out of *part* of your changes — the feature, without the debug print you left in another file.

### HEAD, and what a commit is

A commit records: a tree (all files), its parent(s), author/time, and a message. `HEAD` is a
symbolic pointer at *the commit your next commit builds on* — normally the tip of your current
branch. When `HEAD` stops pointing at a branch you are in **detached HEAD**, and commits made
there belong to no branch (recovered via reflog — Section 7, Example 5).

### The short status language

`git status --short` gives two columns: **staged** change (left) and **working-tree** change
(right). `A ` = staged addition, ` M` = modified but not staged, `??` = untracked, `UU` =
both-modified conflict (you will meet that one next lesson). Learning to read those two letters is
learning to read Git's mind.

### Undo is not one command

Each tool undoes a *different thing*: `git restore <file>` discards working-tree edits (using the
index's version); `git restore --staged <file>` unstages but *keeps* your edits; `git stash`
shelves uncommitted work across branch switches; `git commit --amend` rewrites the *last commit*;
`git reset` moves a branch pointer (hard mode also touches the working tree); `git revert` adds an
*inverse* commit — the safe undo on shared history. The rule: **know what a command destroys
before you run it.**

## 6. How It Works

![Three areas of Git: git add moves edits from the working tree into the index, git commit freezes the index into the repository, and below them HEAD points at the branch pointer, which holds the latest commit and its parents; dashed red arrows show which area each restore command reads from](../assets/tools/git-three-areas.svg)

An original diagram for this repository (the dashed red arrows are the two restore directions —
each reads its "old" version from a **different** area, which is why they are named by area, not
by intent).

Read the arrows as questions: *is my change in the index? is the index committed?* Every
`git status` you will ever run is answering exactly those two. The two "restore" arrows go in
opposite directions for a reason — one **throws away** working-tree edits, the other **keeps**
them — which is why the restore family is named by *area*, not by intent.

## 7. Practical Examples

**Example 1 — from nothing to history**

```console
$ git init -b main
$ git config user.name "Learner Example"
$ git config user.email "learner@example.com"

$ git status --short --branch
## No commits yet on main

$ git add app.py greet.py
$ git status --short
A  app.py
A  greet.py

$ git commit -m "Add greet() and a tiny app"
$ git log --oneline
19c50b0 Add greet() and a tiny app
```

- `git init -b main` names the first branch explicitly — modern Git suggests it precisely because
  the old default (`master`) was ambiguous. On a machine without that flag, Git prints a hint
  about `init.defaultBranch`; setting it once configures the default for good.
- `A ` in the left column: **s**taged, **a**dded, nothing yet in the working-tree column — the
  index holds the entire future commit.
- `git config` here is *repository-local* (no `--global`): this sandbox has its own identity and
  your real machine's identity stays untouched. One line of local config is enough to keep
  sandboxes honest.
- **Assumptions:** Git 2.55, Git Bash on Windows. The same commands work verbatim in any terminal.

**Example 2 — the three diffs, watched from one editing session**

```console
$ printf 'print("v2")\n' >> app.py      # edit, not staged
$ git diff                                # working tree vs index
diff --git a/app.py b/app.py
index c471b2f..1aa08bd 100644
--- a/app.py
+++ b/app.py
@@ -1 +1,2 @@
 print("v1")
+print("v2")

$ git add app.py
$ printf 'print("v3")\n' >> app.py      # a second edit while v2 is staged
$ git diff HEAD                           # working tree vs last commit
@@ -1 +1,3 @@
 print("v1")
+print("v2")
+print("v3")

$ git commit -m "Print v2 in app"
$ git status --short
 M app.py                                 # v3 still uncommitted
```

- `git diff` = *unstaged* only; `git diff --cached` = *staged* only; `git diff HEAD` = everything
  against the last commit. Same verb, three lenses — this is the single most useful diff trio in
  Git, and most "why does my diff look wrong" confusion is picking the wrong lens.
- The `index c471b2f..1aa08bd 100644` line names the blob hashes before and after — Git really is
  diffing content-addressed snapshots.
- Notice the commit captured **only v2** while v3 stayed in the working tree: staging is
  selective, and that is a feature.

**Example 3 — unstage and undo without losing work**

```console
$ git restore app.py                      # discard v3: back to the index's version
$ git status --short                       # (clean)

$ printf '# scratch line\n' >> greet.py
$ git add greet.py
$ git restore --staged greet.py            # unstage — the edit REMAINS
$ git status --short
 M greet.py
$ git diff greet.py | head -6
+# scratch line
```

- The two commands look alike and do opposite things: `restore <file>` destroys working-tree
  edits; `restore --staged <file>` destroys only the *staging decision*.
- **Predict-then-run habit:** before any restore, run `git diff` and say out loud what will
  disappear. Two seconds that prevent the worst Git feelings.

**Example 4 — shelve, amend, and the reflog**

```console
$ git stash
Saved working directory and index state WIP on main: e018eaa Print v2 in app
$ git stash list
stash@{0}: WIP on main: e018eaa Print v2 in app
$ git stash pop
Dropped refs/stash@{0} (6f1fdc211db966e95ffd2dc943db059dc31d6be1)

$ git commit --amend -m "Print v2 in app (amended message)"
[main c316a70] Print v2 in app (amended message)
 1 file changed, 1 insertion(+)

$ git reflog | head -5
c316a70 HEAD@{0}: commit (amend): Print v2 in app (amended message)
e018eaa HEAD@{1}: reset: moving to HEAD
e018eaa HEAD@{2}: commit: Print v2 in app
19c50b0 HEAD@{3}: commit (initial): Add greet() and a tiny app
```

- `stash` is "put my unfinished work aside" — the correct move when you must switch context,
  *not* a commit you were too lazy to write. `pop` puts it back and drops the shelve.
- `--amend` **replaces** the last commit with a new one (`e018eaa` → `c316a70`) — safe for a
  commit nobody has pulled, reckless after push. Section 9 returns to this.
- The **reflog** ("reference log") records *every movement of HEAD*, including amend and reset —
  entries nobody else sees, because they are local to you. This is the seatbelt: even "destroyed"
  commits stay reachable here for weeks.

**Example 5 — detach, panic, return; then a real `reset --hard` and its inverse**

```console
$ git checkout HEAD~1 2>&1 | head -6
Note: switching to 'HEAD~1'.

You are in 'detached HEAD' state. You can look around, make experimental
changes and commit them, and you can discard any commits you make in this
state without impacting any branches by switching back to a branch.

$ git status --short --branch
## HEAD (no branch)

$ git reflog | head -3
3034a48 HEAD@{0}: checkout: moving from main to HEAD~1
75c7eb4 HEAD@{1}: commit: three
3034a48 HEAD@{2}: commit: two

$ git switch main
$ git status --short --branch
## main
```

```console
$ git reset --hard v0.1
HEAD is now at 19c50b0 Add greet() and a tiny app
$ git log --oneline
19c50b0 Add greet() and a tiny app          # the branch REALLY moved back

$ git reset --hard HEAD@{1}
HEAD is now at c316a70 Print v2 in app (amended message)
$ git log --oneline
c316a70 Print v2 in app (amended message)
19c50b0 Add greet() and a tiny app           # and forward again, from the reflog
```

- Detached HEAD is *not* an error — it is "looking at an older snapshot". Git's own advice text
  tells you the two exits: `git switch -` (go back) or `git switch -c new-branch` (keep the
  experiment). Committing without either of those is how commits get "lost" — they are in the
  reflog, as Example 4 explained.
- `reset --hard` is the scary one because it moves the branch **and** overwrites the working
  tree. Run twice here on purpose: once forward to real damage, once back to full recovery via
  `HEAD@{1}` — the reflog reference that makes hard resets survivable *on your own machine*.
  On history you have pushed, the safe undo is `git revert` (Section 9).

**Example 6 — empty commits refuse themselves**

```console
$ git commit -m "nothing here"
On branch main
nothing to commit, working tree clean
exit code: 1
```

- Git refuses to create an empty commit and says so in plain words; exit code 1 is the shell-level
  confirmation (see [terminal-fundamentals.md](terminal-fundamentals.md) §Example 3). Scripts
  branch on exactly this.

## 8. Real-World Applications

- **Every codebase you will ever touch** is a Git repository; reading `git log`, `git show`, and
  `git blame` is how professionals answer "why is this line like this?".
- **Bisecting bugs:** `git bisect` walks commits by binary search — available only because every
  change is a snapshot with a parent.
- **Auditable work:** commit messages are the running rationale of a project; the habits formed in
  this lesson (small commits, `why` messages) are what make later review and release notes
  possible.

## 9. Common Mistakes

| Mistake | Why it happens | How to recognize it | How to prevent it |
|---|---|---|---|
| Committing everything blindly (`git add .` by reflex) | Fastest habit to form | Debug prints and `.env` inside a commit | Read `git diff --cached` before every commit; stage by path |
| Commit messages that restate the diff | Thinking the diff is the message | `Update app.py` ×50 in history | Write *why* this change exists; the diff already says what |
| `git restore <file>` when you meant `restore --staged` | Identical-looking commands | Your edits vanish, `git status` clean | Say the target area out loud: restore = working tree, --staged = index |
| Amending or resetting **pushed** history | Local fix feels natural | Teammates' pulls explode with conflicts | After push: `git revert`. Amend only private commits |
| Committing with no identity configured | New machine, no config | `Please tell me who you are` | Set local repo config (Example 1) or global once per machine |
| "My commit is gone!" after `reset --hard` | Hard reset moved the pointer | `git log` shows older history only | `git reflog` → `reset --hard HEAD@{n}`; then breathe |
| Assuming `git status` silence means safe | Untracked files are not in the index | Files disappear after a hard reset anyway | Untracked ≠ saved; `git add` or stash them first |

## 10. Best Practices

- **Small, single-purpose commits.** One logical change each — reviewable, revertable, bisectable.
  If your commit message needs "and", consider two commits.
- **Message discipline:** subject line ≤ 50–72 chars stating the *intent*; body (wrapped at 72)
  for context the diff cannot show. `git log --oneline` is your future self's index.
- **Stage deliberately.** `git add -p` (patch mode) lets you stage *part* of a file — the step up
  from all-or-nothing.
- **Learn the status letters and the three diffs before anything else** — they turn Git from
  magic into a two-column table.
- **Safety order for undo:** restore (files) → restore --staged (index) → stash (shelve) →
  revert (pushed history) → reset/reflog (private history, last resort).
- **Never `push --force` to a shared branch** as a fix — that is history rewriting other people
  already built on (next lesson and review cover the exceptions, like `--force-with-lease`).

## 11. Limitations and Trade--Offs

- Git tracks *text* well; binary files (images, PDFs) bloat history irreversibly — large-artifact
  projects need Git LFS or object storage (subject 17).
- The three-area model does not survive *partial* operations well: `git add -p` heuristics can
  misread tangled changes — keep changes small enough that staging stays obvious.
- Reflog recovery has a horizon (default ~90 days) and exists **only locally** — "the reflog will
  save me" applies to your machine, not to a colleague's clone or a wiped `.git`.
- Git is content-not-file aware: it will happily commit half-written files and secrets if you tell
  it to — pre-commit hooks and `.gitignore` (subjects 14–15) are the guardrails this lesson does
  not yet install.

## 12. Practical Exercises

All exercises run in a throwaway repository you create (`mkdir lab && cd lab && git init -b main`).

### Introductory

1. **Replay Example 1 and 2 with your own files.** **Completion criteria:** you produce a staged
   add, a partial commit (second edit left uncommitted), and can explain each column of
   `git status --short` at every step.
2. **The three diffs.** With one file having one staged and one unstaged change, run all three
   diffs and predict each output before running it. **Completion criteria:** three predictions
   matching three runs, and one sentence stating which *areas* each compares.

### Intermediate

3. **Walk the undo ladder.** Manufacture four mistakes and fix each with the *narrowest* tool:
   unwanted working-tree edit; unwanted staged file; unwanted last commit (unpushed); a file you
   need to set aside mid-task. **Completion criteria:** four mistakes, four tools
   (`restore`, `restore --staged`, `--amend` or `reset --soft`, `stash`), each demonstrated with
   output proving the work still exists afterwards.
4. **Detach and recover.** Check out an older commit, make a commit in detached state, then bring
   it back to a named branch using the reflog. **Completion criteria:** the "orphan" commit is on
   a real branch, and you can list the exact reflog entries you used.

### Independent problem-solving

5. **Reconstruct a stranger's project.** Given any repository you can clone (this one works),
   answer: what changed in the last week, which commit introduced function X (pick one), what did
   commit `<hash>` actually modify, and which commit is `HEAD~3`? Use only `log`, `show`, `diff`,
   `blame`. **Completion criteria:** four correct answers, each with the command that produced it.
6. **The 20-commit warm-up (course requirement).** In a practice repository, produce a history of
   at least five meaningful commits to real files — written *as messages to a reviewer*, each with
   a body explaining why — including one commit you fix with `--amend` and one change you undo
   with `restore`. **Completion criteria:** `git log` reads like a coherent story of a small
   project, and you can narrate each commit's purpose in one sentence. (The full ROADMAP
   requirement — 20 commits across 5 branches with a resolved conflict — is completed after
   [branching-and-merging.md](branching-and-merging.md).)

*Solutions: attempt first; recovery procedures are written out in
[troubleshooting/git-recovery.md](troubleshooting/git-recovery.md) with drills in
[troubleshooting/exercises.md](troubleshooting/exercises.md).*

## 13. Knowledge Check

1. You ran `git add`, then changed the file again. Which diff shows which version, and what will
   the next commit contain?
2. `git restore x.py` and `git restore --staged x.py` — one keeps your edits and one destroys
   them. Which is which, and what area does each command read its "old" version from?
3. After `git reset --hard HEAD~1` you realize the commit mattered. What is your first command,
   and why does it work?
4. Your teammate says "just amend it" about a commit you pushed yesterday. What is wrong with
   that advice, and what should you do instead?
5. What exactly does `HEAD` point to — a file, a commit, a branch? What happens to your commits
   if it points *away* from a branch (detached)?

## 14. Completion Criteria

Observable evidence that you have understood this lesson:

- [ ] You can draw the three areas and label the arrows `add`, `commit`, `restore`,
      `restore --staged` — from memory
- [ ] You have executed every example transcript above in your own lab repository
- [ ] You have recovered one "lost" commit using the reflog yourself
- [ ] You can name five undo tools and, for each, what it destroys
- [ ] You can read `git diff`, `--cached`, and `HEAD` and predict each output before running it
- [ ] Your practice history contains messages that explain *why*, not *what*

## 15. Summary

- Git is **snapshots + pointers**: working tree → **index** (`add`) → **repository** (`commit`),
  with `HEAD` naming "now".
- **Three diffs, three lenses:** `git diff` (unstaged), `--cached` (staged), `HEAD` (everything).
- **Undo is a family:** restore / restore --staged / stash / amend / reset / revert — each
  destroys something different; name it before you run it.
- The **reflog remembers every HEAD movement**, turning most "catastrophes" into one command —
  locally, for a limited time.
- **Commits are cheap and permanent** — small ones with *why* messages are the units every later
  lesson builds on.

## 16. Next Steps

- Next lesson: [branching-and-merging.md](branching-and-merging.md) — pointers multiply: parallel
  work, merges, conflicts, and the rebase question.
- Practice: [troubleshooting/git-recovery.md](troubleshooting/git-recovery.md) — the recovery
  procedures this lesson references, as runnable drills.
- Where it is applied: every project in [20-PROJECT-LABORATORY](../20-PROJECT-LABORATORY/README.md)
  starts with `git init`; the ROADMAP's Milestone 2 gate requires this lesson's habits plus the
  branching drills that follow.
