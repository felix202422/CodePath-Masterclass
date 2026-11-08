# Git Reference

Git operations by the goal you have in mind, not by flag. Find the sentence that describes your
situation, read the command, then read the warning underneath it — every entry that loses work says
so.

> **Baseline.** Git 2.56 on the authoring machine. Commands use the modern verbs `git switch` and
> `git restore` rather than the overloaded `git checkout`; both still work, but the newer pair says
> what it does. `HEAD` is where you are now; `main` is the default branch name used here.

## Inspect before changing anything

| Goal | Command | What you learn |
|---|---|---|
| Where am I, and what state is the tree in? | `git status -sb` | Branch, upstream, and changed/untracked files on one screen. |
| What have I actually changed? | `git diff` | Unstaged changes, hunk by hunk. |
| What have I staged? | `git diff --staged` | Exactly what the next commit will contain. |
| What is the last few commits' story? | `git log --oneline --graph --decorate -20` | Shape of history, merges, branch and tag labels. |
| What changed in one file, ever? | `git log -p -- path/to/file` | Every commit that touched it, with the patch. |
| Who changed this line, and when? | `git blame -w -C path/to/file` | Line-by-line attribution; `-w` ignores whitespace, `-C` follows moved code. |
| Which branches contain this commit? | `git branch -a --contains <sha>` | Where a fix has and has not landed. |
| What is different between two branches? | `git diff main...feature` | Changes on `feature` since it diverged — the three-dot form is the review diff. |
| What commits does this branch add? | `git log --oneline main..feature` | Just the new commits, no noise. |

## Undo things locally

| Goal | Command | Consequence |
|---|---|---|
| Discard changes to one file | `git restore path/to/file` | The file's uncommitted edits are gone. The commit is untouched. |
| Unstage a file, keep the edits | `git restore --staged path/to/file` | The change returns to the working tree. |
| Change the last commit message | `git commit --amend -m "Better message"` | Rewrites the commit. Safe only if it is not pushed. |
| Add a forgotten file to the last commit | `git add forgotten.txt && git commit --amend --no-edit` | Same warning: this rewrites history. |
| Undo the last commit, keep the changes staged | `git reset --soft HEAD~1` | The commit disappears; the index still has it. |
| Undo the last commit, keep the changes unstaged | `git reset HEAD~1` | Mixed reset: files stay modified in the tree. |
| Undo the last commit and delete the changes | `git reset --hard HEAD~1` | **Destroys uncommitted work.** Confirm with `git status` and `git stash` first. |
| Undo a pushed commit safely | `git revert <sha>` | Creates a new commit that reverses it — the only correct option on shared history. |
| Recover a commit after a bad reset | `git reflog`, then `git switch -c rescue <sha>` | Reflog keeps ~90 days by default; the commits are still there. |
| Recover a lost branch tip | `git fsck --lost-found` | Lists dangling commits; rescue by branching at one. |

## Work on branches

| Goal | Command | Notes |
|---|---|---|
| Start a branch from here | `git switch -c feature/login` | Creates and switches in one step. |
| Switch to an existing branch | `git switch main` | Refuses if it would overwrite uncommitted changes. |
| Rename the current branch | `git branch -m new-name` | On a pushed branch, also push the new name and reset the upstream. |
| Delete a merged branch | `git branch -d feature/login` | `-D` forces deletion of unmerged work — check `git log main..feature` first. |
| Delete the branch on the remote | `git push origin --delete feature/login` | Only for branches nobody else is using. |
| See branches by recency | `git branch --sort=-committerdate` | The practical listing; the default alphabetical order tells you nothing. |
| Work on two branches at once | `git worktree add ../hotfix hotfix` | A second checkout in a second directory, sharing one repository. |

## Synchronise with the remote

| Goal | Command | Notes |
|---|---|---|
| Fetch without touching your branch | `git fetch --prune` | Updates remote-tracking branches and removes deleted ones. |
| Update your branch on top of the remote | `git pull --rebase` | Replays your local commits; keeps history linear. |
| Push a new branch and set upstream | `git push -u origin feature/login` | One `-u` per branch; later pushes need no arguments. |
| Push after a rebase | `git push --force-with-lease` | Refuses if someone else pushed since your fetch — the safe force. Never plain `--force` on a shared branch. |
| See what the remote has that you do not | `git log --oneline HEAD..@{u}` | `@{u}` is your upstream branch. |
| See what you have that the remote does not | `git log --oneline @{u}..HEAD` | Useful before pushing something unexpected. |

## Combine and move work

| Goal | Command | Notes |
|---|---|---|
| Merge a branch into the current one | `git merge feature/login` | Fast-forwards when possible; otherwise creates a merge commit. |
| Rebase onto the latest main | `git fetch && git rebase origin/main` | Replays each commit; conflicts are resolved commit by commit (`git rebase --continue`). |
| Abort a rebase or merge | `git rebase --abort` / `git merge --abort` | Returns to the pre-operation state, keeping uncommitted changes where possible. |
| Copy one commit onto the current branch | `git cherry-pick <sha>` | `-x` records the source commit in the message; `-n` stages without committing. |
| Squash the last three commits | `git reset --soft HEAD~3 && git commit` | Simpler and safer than an interactive rebase for the tail of a branch. |
| Reorder, edit or squash mid-branch | `git rebase -i HEAD~5` | Change `pick` to `squash`/`fixup`/`edit`/`drop` in the editor. Rewrites history. |
| Split the tip commit | `git reset HEAD~1`, then commit in pieces | The tip commit becomes working-tree changes. |

## Find the commit that broke something

```bash
git bisect start
git bisect bad                 # current HEAD is broken
git bisect good v1.4.0         # this tag was known good
# Git checks out a midpoint; test it and answer:
git bisect good                # or: git bisect bad
# ... repeat until Git prints "<sha> is the first bad commit"
git bisect reset               # return to where you started
```

- **Expected:** roughly `log2(n)` tests — about 10 for 1,000 commits. `git bisect run ./test.sh` automates the answering.
- The test must be deterministic: a flaky check bisects to a random commit.

| Goal | Command | Notes |
|---|---|---|
| Find the commit that added a string | `git log -S'functionName' --oneline` | Pickaxe: matches commits where the count of occurrences changed. |
| Find when a line changed | `git log -L 40,60:path/to/file` | Traces the history of a line range, following edits. |
| See the history of a deleted file | `git log --all --full-history -- path/to/file` | Needs `--all` once the file is gone from `HEAD`. |

## Stash work in progress

| Goal | Command | Notes |
|---|---|---|
| Park changes with a label | `git stash push -m "wip: auth"` | Untracked files need `-u`; ignored files need `-a`. |
| List and inspect stashes | `git stash list`, `git stash show -p stash@{0}` | Stashes are commits with a limited UI; they are easy to forget. |
| Restore and keep the stash | `git stash apply stash@{0}` | Use this when unsure; it leaves the stash in place. |
| Restore and remove it | `git stash pop` | Conflicts are possible if the tree moved on. |
| Drop one | `git stash drop stash@{0}` | No confirmation prompt. |

## Conflict resolution

```text
<<<<<<< HEAD
timeout: 30
=======
timeout: 60
>>>>>>> feature/retry
```

1. Read both sides: above `=======` is your current branch, below is the incoming change.
2. Choose the correct final text and delete all three markers.
3. `git add <file>` marks it resolved; `git commit` (merge) or `git rebase --continue` finishes.
4. `git diff --check` catches leftover conflict markers before you push.

`git config --global rerere.enabled true` records resolutions and replays them if the same conflict
recurs — worth enabling once, permanently.

## Tags and releases

| Goal | Command | Notes |
|---|---|---|
| Tag the current commit | `git tag -a v1.2.0 -m "Release 1.2.0"` | Annotated tags carry a message and date; lightweight tags are just labels. |
| Push tags | `git push origin v1.2.0` | `--tags` pushes all; tags are not pushed by default. |
| List tags matching a pattern | `git tag -l 'v1.*' --sort=-v:refname` | Version-aware sorting, not lexicographic. |
| Delete a tag | `git tag -d v1.2.0` and `git push origin :refs/tags/v1.2.0` | Two steps: local, then remote. |

## Configuration worth setting once

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
git config --global init.defaultBranch main
git config --global pull.rebase true
git config --global fetch.prune true
git config --global rerere.enabled true
git config --global rebase.autosquash true
```

- `pull.rebase true` avoids surprise merge commits on every pull.
- `fetch.prune true` stops stale remote branches from accumulating.
- `rebase.autosquash true` honours `fixup!`/`squash!` commit prefixes during an interactive rebase.

## Related pages

- [Command Reference](command-reference.md) — the shell around these commands
- [Common Errors](common-errors.md) — the Git failures these recover from
- [03-DEVELOPER-TOOLS/git-fundamentals.md](../03-DEVELOPER-TOOLS/git-fundamentals.md) — the model behind the commands
- [19-PROFESSIONAL-DEVELOPMENT/engineering-workflows.md](../19-PROFESSIONAL-DEVELOPMENT/engineering-workflows.md) — workflow and review practice
