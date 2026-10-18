# clone succeeded but the tree is empty — remote HEAD pointing nowhere

**Layer:** Git / remote. **Symptoms:** `warning: remote HEAD refers to nonexistent ref, unable to
checkout`; after cloning, `git status` reports an unborn branch and the folder has no files, even
though the remote visibly has commits.

## Symptoms (executed — the author's own local remote produced exactly this)

```console
$ git clone origin.git second
warning: remote HEAD refers to nonexistent ref, unable to checkout
fatal: your current branch 'master' does not have any commits yet

$ cd second && ls
(empty)

$ git log --oneline
fatal: your current branch 'master' does not have any commits yet
```

Nothing is corrupt. The clone downloaded the *objects* faithfully — Git simply could not decide
which branch to put in your working tree, because the **remote's HEAD** (its idea of "the default
branch") points at a ref that does not exist there.

## Diagnosis — whose pointer is wrong?

**1. Ask the remote what it thinks its default branch is:**

```console
$ git ls-remote --symref origin HEAD
ref: refs/heads/master	HEAD
0000000000000000000000000000000000000000	HEAD
```

An empty hash for `HEAD`, or a `ref: refs/heads/master` line while the remote only *has* `main`
(see the branch list on the next line of any `git ls-remote origin`), is the diagnosis complete:
**the remote's HEAD names a branch that was never created there.**

**2. List what the remote actually has:**

```console
$ git ls-remote origin
e956cd7a1128ec933e1d2a6aa38270af12142d8c	refs/heads/main
ae7dbad…	refs/heads/feature/greeting
```

`main` exists, `master` does not → mismatch confirmed. (On a plain local bare repo you can also
read `cat origin.git/HEAD` directly — `ref: refs/heads/master` printed there is the smoking gun.)

## Why it happens

- **A bare repository created before anyone pushed** keeps `git init --bare`'s default HEAD
  (`master`) forever; the first push goes to `main` and nobody updates the pointer. *This is
  exactly what happened in this subject's sandbox* — a fresh `git init --bare` plus
  `git push -u origin main`, and the next clone failed as above.
- A platform (GitHub, GitLab) manages its default branch for you, which is why this failure
  surprises people the first time they use a **self-hosted or local** remote.
- A default branch was **renamed or deleted** on the platform and the HEAD pointer followed
  incompletely.

## Fix

```console
# point the remote's HEAD at the branch that really is the default (run where you can see origin.git):
$ git -C origin.git symbolic-ref HEAD refs/heads/main

# verify, then re-clone:
$ git ls-remote --symref origin HEAD
ref: refs/heads/main	HEAD
e956cd7a1128ec933e1d2a6aa38270af12142d8c	HEAD
```

- **Already cloned and stuck?** The local clone's `origin/HEAD` is a *stored copy* of the remote's
  answer — refresh it with `git remote set-head origin -a` (reads the remote), then
  `git switch main` or `git checkout main`. No re-clone needed.
- **On a hosting platform:** set the repository's *default branch* in settings (GitHub:
  Settings → Branches) — that is the platform writing the same pointer, and it also controls what
  PRs target.
- The broken clone's commits are not lost even before the fix: `git branch -a` /
  `git fetch origin main:main` can materialize them; the failure was only about *checking out*.

## Prevent

- **Set HEAD at remote creation when you host your own:**
  `git init --bare -b main repo.git` — one flag, failure impossible.
- **Push with `-u` and check the first clone** of any new remote before teammates do —
  `git clone <url> && git log --oneline | head -3` is a 30-second smoke test
  ([../github-workflows.md](../github-workflows.md), Example 2).
- When renaming a default branch on a platform, verify with `git ls-remote --symref origin HEAD`
  afterwards — the rename is not finished until that line reads the new name.
