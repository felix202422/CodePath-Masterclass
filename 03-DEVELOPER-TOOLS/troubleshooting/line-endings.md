# phantom diffs and CRLF warnings — line-ending incidents

**Layer:** shell / Git / editor. **Symptoms:** every line of a file shows as changed though you
edited one; `warning: … LF will be replaced by CRLF` floods your terminal; a merge conflicts in
files neither side "touched".

## Symptoms

```console
warning: in the working copy of 'hello.py', LF will be replaced by CRLF the next time Git touches it
```

- `git diff` on a teammate's "one-line change" shows the whole file `+` and `-`.
- `git status` lists files you never edited (they were *touched* by a checkout with a different
  policy).
- Reviewers reject your PR for "line-ending churn"; or *you* see theirs.

## Diagnosis — prove it byte-wise before touching anything

**1. Ask Git what the index and working tree hold** (executed on the author's machine):

```console
$ printf 'line one\r\nline two\r\n' > dos.txt
$ printf 'line one\nline two\n' > unix.txt
$ git add .

$ git ls-files --eol
i/lf    w/crlf  attr/                	dos.txt
i/lf    w/lf    attr/                	unix.txt
```

Read the three columns: **i/** = what the *index* (repository) stores, **w/** = what your
*working tree* has on disk, **attr/** = what `.gitattributes` mandates (empty here — nothing
declared yet). `i/lf w/crlf` is not a bug; it is the normal shape when a Windows working copy keeps
CRLF while the repo normalizes to LF.

**2. Look at the stored bytes directly — the ground truth:**

```console
$ git show :dos.txt | od -c | head -2
0000000   l   i   n   e       o   n   e  \n   l   i   n   e       t   w
0000020   o  \n
```

Both files' blobs contain plain `\n` — despite `dos.txt` living as CRLF on disk. Conversion
happened *on the way in* (`core.autocrlf` on this machine is `true`, the Windows installer
default: `git config --get core.autocrlf`).

**3. Find whose policy is fighting whom:**

```console
$ git config --get core.autocrlf        # this machine
true
$ git ls-files --eol                    # after adding .gitattributes:
i/lf    w/lf    attr/text=auto       	unix.txt
i/lf    w/crlf  attr/text=auto       	dos.txt
```

The `attr/text=auto` column means the *repository* now has an opinion that overrides personal
config — the state you want. Symptoms to map: **whole-file diff** = two sides disagree about
stored bytes; **warning flood** = `autocrlf` promising a conversion on next checkout; **phantom
merge conflict** = a file committed under one policy and edited under another, so Git believes
both sides changed every line.

## Fix

| Situation | Fix |
|---|---|
| One file's whole-file diff, cause known | `git add --renormalize <file>` then commit *the normalization alone*; never mix it with logic changes |
| Whole repository never normalized | One dedicated commit: add `.gitattributes` (`* text=auto`), `git add --renormalize .`, `git commit -m "Normalize line endings"` — expect a large diff and **say so** in the message so reviewers do not misread it |
| Warning flood you do not want | Add `.gitattributes` — attributes outrank `core.autocrlf`, and the ambiguity disappears |
| Editor keeps reintroducing CRLF | Set `end_of_line` in `.editorconfig` (see [../editors-and-ides.md](../editors-and-ides.md)); restart the editor so it re-reads the file |
| Merge conflict that is "only" line endings | Treat it as a real conflict: resolve markers (per [merge-conflict.md](merge-conflict.md)), then verify with `git diff --stat` that the post-merge file has *one* consistent ending |

**Do not** "fix" this by flipping `core.autocrlf` back and forth on your machine — that only
moves the disagreement to the next person's checkout. The durable answer is repository policy.

## Prevent

- **Commit `.gitattributes` in every repository's first commit** — `* text=auto` at minimum,
  `*.md text eol=lf` for files that must stay LF (this curriculum's repo does exactly this).
- **`.editorconfig` with `end_of_line`** so editors stop re-deciding per person
  ([../editors-and-ides.md](../editors-and-ides.md), Examples 2–3).
- **One normalization commit per repository, early** — before the team is large enough for the
  churn to become a story in code review.
- When reviewing: a diff where *every line* changes is first checked for endings
  (`git diff --stat` + `ls-files --eol`), not for content — you will save a reviewer's hour.
