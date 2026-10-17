# Solutions — Set 3: Files and Processes

> ⚠ Attempt first; rebuild cold in a week.

## Exercise 1 — Five files, four properties

**Reference format:**

```text
Tool: ls -l (Linux/macOS)   [or File → Properties / Details on Windows]
/home/felix/report.md   4.1 KB   2026-10-17 09:12   -rw-r--r--
  → owner felix: read/write; group/other: read only; nobody else may write
```

Repeat for five files. **Criteria check:** ☐ five entries ☐ path, size, modified, permissions each.

**Common miss:** recording only size and date — the *permission* column is the point (who can
modify each file, answered explicitly).

## Exercise 2 — Three launch directories

Program reads `config.json` (current-directory-relative):

| Started in | Resolves to | Outcome |
|---|---|---|
| The directory containing `config.json` | `./config.json` | ✅ success |
| Its subdirectory | `subdir/config.json` | ❌ not found (unless the file happens to be there) |
| Anywhere else | a path without the file | ❌ not found |

**Criteria check:** ☐ three outcomes ☐ working-directory reasoning.

## Exercise 3 — Kill a process

**Reference transcript (Linux):**

```bash
sleep 300 &
ps -o pid,comm -p $!        # → PID 5123, COMMAND sleep
kill 5123
ps -p 5123                  # → error/empty: gone
```

**Criteria check:** ☐ PID recorded ☐ method (`kill` / Task Manager → End task) ☐ confirmed absent.

**Safety note:** terminate only processes you started; killing unknown system processes is how
people break their own machines.

## Exercise 4 — The portability bug (independent)

**Fix 1 — build the path from a known base:** resolve `templates/page.html` relative to the
application's own location (language helper: `Path(__file__).parent / "templates" / "page.html"`
style), not the working directory.

**Fix 2 — change how it is launched:** always start the program from a fixed directory (a wrapper
script/shortcut/`WorkingDirectory=` in a service definition).

**Preference: Fix 1.** It is robust to *who* launches it and *from where* — Fix 2 only works where
you control the launcher (you do not on a teammate's machine or a cron job).

**Test:** run from an unrelated directory (e.g. `/tmp` or `C:\`) and confirm the file is found;
then run again from the project directory (regression check).

**Criteria check:** ☐ two distinct fixes ☐ justified preference ☐ test from unrelated directory.

**Reviewer note:** the deeper point — Fix 1 removes a *hidden input* (the environment) from the
program's behavior. Hidden inputs are where production bugs live.

---

Next: [set-4-solutions.md](set-4-solutions.md)
