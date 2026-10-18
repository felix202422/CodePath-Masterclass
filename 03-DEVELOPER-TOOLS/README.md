# 03 — Developer Tools

Professional developers live in the terminal and keep everything under version control. This
subject makes you one of them: command-line fluency on Windows and Linux, editors and IDEs,
package managers, environment variables, and the full Git/GitHub workflow including branching,
pull requests, and code review.

## What this subject covers

- Terminal fundamentals: navigation, file operations, redirection, pipes, and the man pages that
  make you independent of tutorials.
- Windows development environment: PowerShell versus Git Bash, WSL, and what differs from Linux.
- Linux fundamentals: the filesystem hierarchy, permissions, processes, and services.
- Editors and IDEs: from a plain text editor to a full IDE, and what each is actually for.
- Package managers: how dependencies are obtained and why lockfiles exist.
- Environment variables: configuration, secrets, and the `.env` discipline.
- Git fundamentals: the three areas of a repository, commits, history, and undoing things safely.
- Branching and merging: parallel work, fast-forwards, and resolving conflicts by hand.
- GitHub workflows: remotes, pushing, issues, and the collaborative loop.
- Pull requests and code review: proposing, reviewing, and merging changes like a professional.
- `troubleshooting/`: the recurring environment problems, each with a diagnosis procedure.

## Why it matters

Tooling is not a detour from programming — it is the medium. Version control is what makes risk
acceptable (you can always go back), review is what catches what tests miss, and the terminal is
where every later subject — Java builds, databases, Docker, deployment — will actually happen.
Employers consistently report that tooling gaps, not language gaps, are what make beginners look
junior.

## Prerequisites

- [02-PROGRAMMING-FUNDAMENTALS](../02-PROGRAMMING-FUNDAMENTALS/README.md) — you need small programs
  worth versioning; Git on empty files teaches nothing.

## Lessons

- [terminal-fundamentals.md](terminal-fundamentals.md) · [windows-development-environment.md](windows-development-environment.md) · [linux-fundamentals.md](linux-fundamentals.md)
- [editors-and-ides.md](editors-and-ides.md) · [package-managers.md](package-managers.md) · [environment-variables.md](environment-variables.md)
- [git-fundamentals.md](git-fundamentals.md) · [branching-and-merging.md](branching-and-merging.md) · [github-workflows.md](github-workflows.md)
- [pull-requests-and-code-review.md](pull-requests-and-code-review.md)
- [troubleshooting/](troubleshooting/README.md) — nine diagnosis guides plus the graded drills

All ten lessons are written. Every transcript claimed as actual output in them was executed on the
authoring machine (Windows 11, Git Bash, Git 2.55.0 — see [VERSIONS.md](../VERSIONS.md) for the
author environment); sandbox Git repositories use the placeholder identity `Learner Example`, so no
personal configuration or real account enters a lesson. Transcripts that could not be executed here
(PowerShell/cmd snippets beyond the ones captured, live GitHub web UI sessions, real Linux
packagers) are explicitly labelled **illustration** in place — the honesty rule is stated per
transcript, not assumed.

## Exercises and practice

Practice for this subject lives in [troubleshooting/exercises.md](troubleshooting/exercises.md):
drills that put your own environment into a real broken state (broken PATH, lost commit, engineered
merge conflict, empty clone) and require diagnosis, repair, and a stated prevention. The guides in
[troubleshooting/](troubleshooting/README.md) are their answer keys — attempt first, read second.
Beyond the drills: every command in these lessons is meant to be executed on your own machine, including the wrong
versions on purpose (`cd` to the wrong place, delete a file and recover it, create and resolve a
merge conflict). The Git exercises demand a real history: at least 20 commits across 5 branches,
one conflict resolved by hand, and one mistake recovered with `git restore`/`git revert`.

## Expected outcomes

You can navigate and automate entirely from the terminal; explain what the three Git areas are and
pick the right undo command; create a branch, resolve a conflict, and open a pull request with a
description a reviewer can act on; and diagnose a broken environment with a procedure instead of
random commands.

## Common blockers

- **All work on `main`.** The point of branching is safe experimentation; use it from the first week.
- **The `rm` reflex.** Deleting is not undoing. Learn the recovery path *before* you need it.
- **Fear of the terminal.** Every command here is safe to run on a practice folder. Speed comes
  from repetition, not talent.

## Next

[04-JAVA-PROGRAMMING](../04-JAVA-PROGRAMMING/README.md) — your first typed,
object-oriented language, built with Maven and committed with Git from day one.