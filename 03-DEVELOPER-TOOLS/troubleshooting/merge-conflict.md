# merge conflicts — the paused state, read and finished

**Layer:** Git. **Symptoms:** `CONFLICT (content): Merge conflict in story.txt`, conflict markers
in your files, `UU` in `git status`, `Automatic merge failed`, exit code 1 — or a merge that
refuses to finish with `All conflicts fixed but you are still merging`.

## Symptoms (all real, from the author's sandbox)

```console
$ git merge hotfix/line2
Auto-merging story.txt
CONFLICT (content): Merge conflict in story.txt
Automatic merge failed; fix conflicts and then commit the result.
$ echo "merge exit code: $?"
merge exit code: 1

$ git status --short
UU story.txt
?? note.txt
```

**A conflict is a pause, not a failure** — Git stopped at the one disagreement it refuses to
guess about. `UU` = both sides updated the file; the merge header at the top of full
`git status` says `You have unmerged paths`.

## Read the file's markers (executed)

```console
$ cat story.txt
line 1
<<<<<<< HEAD
line 2 (emphasized)
=======
line two, fixed
>>>>>>> hotfix/line2
line 3
A tip about the ending.
line 4
```

| Marker | Means |
|---|---|
| `<<<<<<< HEAD` | start of **your** side (the branch you are on) |
| `=======` | the divide |
| `>>>>>>> hotfix/line2` | end of **their** side (the branch being merged) |
| everything between | the *same region* changed on both — write the combined truth here |

*(On this Windows machine those marker lines carry a trailing `\r` — invisible in a terminal,
visible in hex/editors that show control characters; on LF checkouts the markers are plain.
Same structure either way.)*

Before choosing: **read both sides' intent**, not just the text —
`git log --oneline HEAD..hotfix/line2` (their commits) and `git log --oneline hotfix/line2..HEAD`
(yours) tell you *why* each side looks like that.

## Fix — the three-step finish

```console
$ # 1. edit the file until the markers are gone and the text says what you mean:
$ printf 'line 1\nline two, fixed (emphasized)\nline 3\nline 4\n' > story.txt

$ # 2. declare the file solved (staging IS the declaration):
$ git add story.txt

$ # 3. complete the merge (default message records both parents):
$ git commit -q --no-edit

$ git log --graph --oneline --all | head -8
*   1b7d1c8 Merge branch 'hotfix/line2'
|\
| * ab54155 hotfix: rewrite line 2
* | f01aa6e main: emphasize line 2
|/
*   824638a Merge branch 'feature/add-line4'
```

Rules of the finish:

- **Markers must all be gone** — search (`grep -n '<<<<<<<' <file>`) before `add`; a committed
  marker is a special case of garbage-in-Garbage-out.
- **Write the combined meaning** (the example keeps *both* edits). Taking one side wholesale
  (`checkout --theirs .`) is sometimes correct — but it *silently deletes the other side's work*,
  so it must be a decision you can justify per file, not a reflex.
- **`git add` on a conflicted file marks it resolved**; remaining `UU` files keep the merge open.
  `git commit` (no arguments) then writes the merge commit — no editor needed with `--no-edit`.

## The exit ramps

```console
$ git merge practice-abort          # a conflict you do not want to solve right now
CONFLICT (content): Merge conflict in story.txt
$ git merge --abort                 # full retreat to the pre-merge state

$ git status --short                 # conflict gone
?? note.txt
```

- **`git merge --abort`** restores tracked files exactly; unrelated untracked files (`?? note.txt`)
  are untouched — Git only reverses what it was already tracking. Always safe; always the answer
  to "I started this in the wrong branch".
- Half-solved and want out: `git merge --quit` discards the *in-progress bookkeeping* but keeps
  your file edits (contrast with `--abort`, which reverts the files too).
- Merging is not the only conflict source: `git pull` (merge mode), `git cherry-pick`, `git
  rebase` all pause the same way — plus rebase adds `git rebase --continue` / `--abort` after each
  solved file.

## When the merge will not finish

| Message | Meaning | Action |
|---|---|---|
| `Automatic merge failed; fix conflicts and then commit` | Normal paused state | The three steps above |
| `All conflicts fixed but you are still merging` | Files resolved, commit not made | `git commit --no-edit` |
| `Committing is not possible because you have unmerged files` | You forgot `git add` on one | `git status`, stage the rest, commit |
| Rebase: `You must edit all merge conflicts… then mark them as resolved` | Same, per replayed commit | Solve, `git add`, `git rebase --continue` |

## Prevent

- **Integrate daily** — divergence *is* conflict fuel ([../branching-and-merging.md](../branching-and-merging.md),
  Section 10). Two days of parallel work beats two weeks, every time.
- **Own small files' boundaries:** split code so two people rarely edit the same ten lines;
  long functions and shared config are conflict magnets.
- **Practice one on purpose now** (exercise 3 of
  [../branching-and-merging.md](../branching-and-merging.md) / drills in
  [exercises.md](exercises.md)) — the first conflict you meet should not be your first conflict
  ever.
- Automatable style/line-ending conflicts are *policy* problems: fix with `.gitattributes` /
  `.editorconfig` ([line-endings.md](line-endings.md)) so Git never sees fake content conflicts.
