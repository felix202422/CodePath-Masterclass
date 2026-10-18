# "has no upstream branch" — bare `git push` refusing to run

**Layer:** Git / remote. **Symptoms:** `fatal: The current branch X has no upstream branch`;
or, confusingly, `Everything up-to-date` when you were certain you had new commits; or
`error: src refspec X does not match any`.

## Symptoms (executed — verbatim from the author's sandbox)

```console
$ git push
fatal: The current branch needs-upstream has no upstream branch.
To push the current branch and set the remote as upstream, use

    git push --set-upstream origin needs-upstream

To have this happen automatically for branches without a tracking
upstream, see 'push.autoSetupRemote' in 'git help config'.
exit code: 128
```

Exit **128** — Git-level failure (contrast with `merge` conflicts' exit 1 and lookup failures'
127; see [../terminal-fundamentals.md](../terminal-fundamentals.md) on reading exit codes).

## Diagnosis — three symptoms, three different causes

**1. The fatal above** — the branch has never been published, so bare `git push` has *nothing
recorded* to push to. A branch's tracking configuration is two config entries, written either by
`push -u` / `push --set-upstream` or by `push.autoSetupRemote=true`:

```console
$ git config --get branch.needs-upstream.merge
(no output — unset, hence the fatal)
```

After the fix, that same query answers `refs/heads/needs-upstream` — the proof the relationship
exists, not a Git's-opinion-but-my-memory situation.

**2. `Everything up-to-date`** — a *different* problem wearing the same coat: the branch *is*
tracked, but what you pushed either was already there or never got committed/staged. Read state
before blaming the remote:

```console
$ git status -sb
## main...origin/main [behind 2]
$ git rev-list --count HEAD..origin/main
2
```

`[behind 2]` says the divergence is in the *other* direction — you have commits to **pull**, not
to push (`git log origin/main..HEAD` would show your unpushed commits; empty output = you have
none). The same `[ahead N]` marker is what you want to see before pushing.

**3. `error: src refspec X does not match any`** — Git looked for a local ref named `X` and found
nothing: the branch does not exist *locally* (typo, or you committed while detached — see
[git-recovery.md](git-recovery.md)). Confirm with `git branch -v`: the branch must be listed
before anything can push it.

## Fix

| Symptom | Fix |
|---|---|
| `has no upstream` | Run Git's own suggested command verbatim: `git push --set-upstream origin <branch>` (the `-u` short form is identical) |
| Want it permanent for *every* new branch | `git config --global push.autoSetupRemote true` — then first pushes are argument-free by default (Git 2.37+) |
| `Everything up-to-date` with work in hand | `git status -sb`: if `[ahead N]`, `git push origin <branch>` (or set upstream as above); if `[behind N]`, integrate first — `git pull --ff-only` |
| `src refspec does not match any` | `git branch -v` to find/fix the name; if the work sits on a detached HEAD, name it first: `git branch rescue <hash>` (see [git-recovery.md](git-recovery.md)) |
| Tracking the **wrong** remote branch by accident | `git branch -vv` shows every branch's bracketed upstream; fix with `git branch --set-upstream-to=origin/<right-branch> <branch>` |

The executed remedy, with its after-state:

```console
$ git push -u origin needs-upstream
branch 'needs-upstream' set up to track 'origin/needs-upstream'.

$ git branch -vv
  main           75c7eb4 three
* needs-upstream bf22079 [origin/needs-upstream] scratch commit
```

`[origin/needs-upstream]` in `branch -vv` is the healthy state: every branch you care about shows
its upstream (or intentionally shows none).

## Prevent

- **Push new branches with `-u` as a reflex** — one keystroke that permanently ends this error
  class for that branch. This subject's lessons model it in every first push
  ([../github-workflows.md](../github-workflows.md), Example 1).
- **Set `push.autoSetupRemote true` once per machine** if you prefer the reflex to be optional;
  document it in your team's setup notes so behavior matches between laptops.
- **Read `git status -sb` before every push** — the `[ahead N] [behind M]` markers tell you
  whether you are publishing, pulling, or genuinely done; that single line resolves all three
  symptoms above in seconds.
