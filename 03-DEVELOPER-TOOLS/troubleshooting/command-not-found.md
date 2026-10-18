# command not found — PATH and shell lookup failures

**Layer:** shell. **Symptoms:** the tool works somewhere and not here; `command not found`;
`'X' is not recognized as an internal or external command`; exit code **127**.

## Symptoms

- Git Bash / Linux: `bash: node: command not found` (exit 127).
- PowerShell: `The term 'node' is not recognized as the name of a cmdlet…`.
- cmd: `'node' is not recognized as an internal or external command…`.
- The same command *works* in another window, another shell, or after a reboot.

## Diagnosis — the four checks, in order

**1. Reproduce and capture the exact text.** The wording itself picks the layer: "not found" is
lookup (this guide); "Permission denied" is [permission-denied.md](permission-denied.md).

**2. Ask the shell where it would look — and what it would find.**

```console
$ echo "$PATH" | tr ':' '\n' | head -4
/mingw64/bin
/usr/bin
/c/Users/PC/bin
/c/Program Files/Common Files/Oracle/Java/javapath

$ which node
/c/Program Files/nodejs/node
```

`which` answering means the *current* shell's PATH is fine — then the failure is inside the tool
(a different error will be on stderr), not lookup. `which` returning nothing moves you to check 3.

**3. Break it deliberately to see the failure's true face** (executed transcript):

```console
$ PATH=/nowhere ls
/usr/bin/bash: line 7: ls: command not found
exit code: 127

$ PATH=/nowhere pwd
/tmp/tools01/envtest
```

Two facts, both worth internalizing: the shell's own answer for a missing program is **exit 127**,
and **built-ins survive** a broken PATH because they never consult it. So if *everything* fails,
PATH is the prime suspect; if only *some* commands fail, look at which PATH entry should hold them.

**4. Compare shells and "ages" of windows.** From PowerShell, the same lookup with full path:

```powershell
PS> (Get-Command git).Source
C:\Program Files\Git\mingw64\bin\git.exe
```

If one window resolves `git` and a freshly opened one does not (or vice versa), you are looking at
the **stale-environment effect**: PATH edits reach *new* processes only. An installer that just
added a directory, plus a terminal opened before the install, produces exactly this signature —
old windows keep the old PATH forever.

## Fix

| Situation | Repair |
|---|---|
| Fresh install, current window broken | **Open a new terminal.** That is the whole fix more often than not |
| Directory genuinely missing from PATH | Add it *persistently*: Windows → System Properties → Environment Variables → user `PATH`; in bash, add an `export PATH="$PATH:/new/dir"` line to `~/.bashrc` (Git Bash) so it survives new sessions |
| Command exists but `which`/`Get-Command` cannot see it | Confirm the binary's real path (`where.exe node`, file manager), then decide: add its folder to PATH, or invoke by full path once to unblock |
| Typed wrong (typo, wrong shell dialect) | `ls` does not exist as a *cmdlet*; PowerShell's is `Get-ChildItem`. Dialect confusion is covered in [../windows-development-environment.md](../windows-development-environment.md) |
| Exit 127 from a *script* but not interactively | The script's environment differs — check for `PATH=` assignments inside it, or run with `bash -x script.sh` to watch its lookup |

**Persistent-but-scoped edits:** in bash, a PATH export in `~/.bashrc` applies to *bash children*;
Windows GUI apps do not read bash files — system/user PATH is what they inherit. Both may be
needed; neither replaces the other.

## Prevent

- **Verify after every tool install:** `which <tool>` / `Get-Command <tool>.Source` in a *new*
  window, before you need the tool.
- **Declare dev tools per project where possible** (see
  [../package-managers.md](../package-managers.md)) — `npx`-style local installs sidestep global
  PATH entirely and are reproducible via the lockfile.
- **Never hand-edit PATH inside an open shell and call it done** — `export` is per-session
  (see [../environment-variables.md](../environment-variables.md)); the persistent place is the
  OS setting or the shell profile.
- Team rule worth copying: *global installs only via documented installers; project tools stay in
  the manifest.*
