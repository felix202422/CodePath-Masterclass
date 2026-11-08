# Command Reference

The commands worth knowing without a search: files, text, processes, network, package managers and
build tools. Each entry is the command, the one flag that matters most, and what you should expect to
see.

> **Shell baseline.** GNU coreutils on a Debian/Ubuntu shell (WSL, a container, or a Linux host),
> with GNU `sed`/`grep`/`find`. Git Bash on Windows behaves the same for everything on this page
> except the paths. Placeholders are written `<like-this>`; `$VAR` is a shell variable.

## Navigation and inspection

| Command | What it does | Worth knowing |
|---|---|---|
| `pwd` | Prints the working directory. | `pwd -P` resolves symlinks to the real path. |
| `ls -la` | Lists all entries, including dotfiles, with permissions, owner, size and time. | `ls -lh` makes sizes human-readable; `ls -lt` sorts newest first. |
| `cd <dir>` | Changes directory. | `cd -` returns to the previous directory; `cd` alone goes home. |
| `stat <file>` | Full metadata: size, inode, access/modify/change times. | The three timestamps differ; `mtime` is what `ls -l` shows. |
| `file <path>` | Guesses the type from the content — not the extension. | Useful on a file with no extension, or a `.md` that is really cp1252. |
| `du -sh <dir>` | Total disk usage of a directory, human-readable. | `du -h --max-depth=1 . \| sort -h` finds the heavy subdirectory. |
| `df -h` | Free space per mounted filesystem. | A full `/` explains many "no space left on device" failures. |
| `free -h` | Memory and swap in use. | `available` matters more than `free` — cached memory is reusable. |

## Files and directories

| Command | What it does | Worth knowing |
|---|---|---|
| `mkdir -p a/b/c` | Creates a directory path, ignoring existing levels. | Without `-p`, a missing parent is an error. |
| `cp -r src dst` | Copies a tree. | `cp -a` preserves permissions, timestamps and symlinks. |
| `mv src dst` | Moves or renames. | Same filesystem is instant; across filesystems it copies and deletes. |
| `rm -r <dir>` | Removes a directory tree. | There is no trash. Run `ls` on the exact path first; never `rm -rf $VAR/` with an unset variable. |
| `ln -s target link` | Creates a symbolic link. | The target is resolved at access time, so a relative target is relative to the link's directory. |
| `touch file` | Creates an empty file, or updates its timestamps. | Its main use is making a file exist for a later step. |
| `find . -name '*.log'` | Recursively locates files by name. | `-mtime -7` = changed in the last seven days; `-delete` acts on matches; quote the pattern so the shell does not expand it. |
| `find . -type f -size +10M` | Finds files by type and size. | Combine predicates freely; `find` is the only tool here that does not care about depth. |

## Reading and searching text

| Command | What it does | Worth knowing |
|---|---|---|
| `less file` | Pages through a file. | `/pattern` searches, `n` next match, `G` end, `q` quit. |
| `head -n 20 file` | First 20 lines. | The default is 10; `head -c 200` reads bytes. |
| `tail -f app.log` | Follows a file as it grows. | The first thing to run when a service misbehaves; `Ctrl+C` stops following. |
| `grep -rn 'pattern' src/` | Recursive search with line numbers. | `-i` ignores case, `-w` whole words, `-C 2` shows context, `-l` lists file names only. |
| `grep -c pattern file` | Counts matching lines. | `grep -v` inverts; `grep -o` prints only the match. |
| `wc -l file` | Counts lines. | `wc -w` words, `wc -c` bytes. |
| `sort file` | Sorts lines lexically. | `-n` numeric, `-h` human sizes, `-k2` by field 2, `-t,` comma separator, `-u` unique. |
| `uniq -c` | Collapses adjacent duplicates with a count. | Only works on sorted input — `sort file \| uniq -c \| sort -rn` is the idiom. |
| `cut -d, -f1,3 file` | Selects fields from each line. | `cut -c1-10` selects characters; it cannot handle quoted delimiters — use `awk` or `csvkit`. |
| `sed 's/old/new/' file` | Substitutes the first match per line. | `s/old/new/g` replaces all; `-i` edits in place (`-i.bak` keeps a backup). |
| `awk '{print $1, $3}' file` | Prints fields by number. | `awk -F,` sets the separator; `awk '$3 > 100'` filters rows. |
| `diff -u a b` | Unified difference between two files. | `diff -r dirA dirB` compares trees; `-q` reports only which files differ. |
| `jq '.items[].id' file.json` | Extracts from JSON on the command line. | `jq -r` drops quotes; `jq '.[] \| select(.ok)'` filters. |

## Pipes, redirection and exit codes

| Form | Meaning |
|---|---|
| `cmd > file` | Send stdout to `file`, truncating it. |
| `cmd >> file` | Append stdout to `file`. |
| `cmd 2> err.txt` | Send stderr to a file. |
| `cmd > out.txt 2>&1` | Send both streams to the same file; order matters — `2>&1 > out.txt` does something else. |
| `cmd1 \| cmd2` | Feed stdout of `cmd1` to stdin of `cmd2`. |
| `cmd \| tee log.txt` | Write to the file *and* keep stdout visible. |
| `cmd &` | Run in the background of the current shell. |
| `$?` | Exit status of the last command: `0` success, non-zero failure. Check it before parsing output. |
| `cmd1 && cmd2` | Run `cmd2` only if `cmd1` succeeded. |
| `cmd1 \|\| cmd2` | Run `cmd2` only if `cmd1` failed. |

**Pipelines hide failures.** `set -o pipefail` (bash) makes a pipeline fail if any stage fails, not
just the last — the difference between a real check and a green light.

## Permissions and ownership

`ls -l` prints ten characters: type (`-` file, `d` directory, `l` link), then owner, group and other
permissions as `rwx` triples.

| Command | Meaning |
|---|---|
| `chmod 644 file` | Owner read/write, group read, others read — the normal mode for a data file. |
| `chmod 755 dir` | Owner rwx, everyone else r-x — the normal mode for a directory or executable. |
| `chmod 600 key.pem` | Owner read/write only — required for private keys and `.env` files. |
| `chmod +x script.sh` | Adds execute permission for all, preserving the rest. |
| `chmod -R g+w shared/` | Recursively adds group write. |
| `chown user:group file` | Changes owner and group; needs privilege. |
| `umask` | Mask subtracted from the default mode of new files (typically `022`). |

The numeric digits are octal: read = 4, write = 2, execute = 1, summed per class. `7` is `rwx`, `6`
is `rw-`, `5` is `r-x`, `4` is `r--`. Never use `777` to make a problem go away: it grants write
access to every user on the machine.

## Processes

| Command | What it does | Worth knowing |
|---|---|---|
| `ps aux` | Every process with user, CPU, memory and command. | `ps -ef --forest` shows parent/child structure. |
| `pgrep -af java` | Finds processes by name with arguments. | `pgrep -f 'spring-boot:run'` matches the full command line. |
| `top` / `htop` | Live process and resource view. | `M` sorts by memory, `P` by CPU, `q` quits. |
| `kill <pid>` | Sends `SIGTERM`, asking politely. | The process may run cleanup handlers. |
| `kill -9 <pid>` | Sends `SIGKILL`; the process cannot react. | Last resort — it can leave locks and partial writes. |
| `kill -HUP <pid>` | Often triggers a configuration reload. | Only if the program documents it. |
| `jobs`, `fg`, `bg` | Manage background jobs of the current shell. | `Ctrl+Z` suspends, then `bg` resumes in background. |
| `nohup cmd > out.log 2>&1 &` | Keeps a command running after the shell exits. | For anything long-lived, use a service manager instead. |
| `lsof -p <pid>` | Files and sockets a process holds. | `lsof -i :8080` finds whoever owns a port. |

## Networking

| Command | What it does | Worth knowing |
|---|---|---|
| `curl -i https://api/x` | Request showing status line and headers. | `-sS` quiet but still show errors; `-L` follow redirects. |
| `curl -X POST -H 'Content-Type: application/json' -d '{"a":1}' url` | POST a JSON body. | `-d @file.json` reads the body from a file. |
| `curl -o out.bin url` | Save the response body. | `-O` uses the remote file name. |
| `curl -w '%{http_code} %{time_total}\n' -o /dev/null -s url` | Print status and duration only. | The quickest health probe in a script. |
| `curl --resolve host:443:127.0.0.1 https://host/` | Test a hostname against a specific address. | Useful before DNS is updated. |
| `ss -ltnp` | Listening TCP sockets with owning process. | `ss -tunap` shows all connections; replaces `netstat`. |
| `dig +short example.com` | Resolve a name to addresses. | `dig MX example.com` for mail records; `@8.8.8.8` queries a specific resolver. |
| `ping -c 3 host` | Reachability and round-trip time. | ICMP may be blocked even when HTTP works — a negative ping is not proof of failure. |
| `openssl s_client -connect host:443 -servername host` | Inspect the TLS certificate chain. | Shows expiry and the issuing authority. |

## Environment and shells

| Command | Meaning |
|---|---|
| `export NAME=value` | Sets a variable for this shell and its children. |
| `NAME=value cmd` | Sets a variable for one command only. |
| `env` / `printenv NAME` | Lists the environment / one variable. |
| `source script.sh` | Runs a script in the current shell, so its `export`s persist. |
| `which cmd` / `type -a cmd` | Locates the executable; `type` also reveals aliases and builtins. |
| `echo $PATH \| tr ':' '\n'` | One directory per line — the fastest way to see why a command is "not found". |
| `history \| grep mvn` | Recalls previous commands. `Ctrl+R` searches interactively. |
| `alias ll='ls -la'` | Defines a shortcut for this shell session. |
| `set -euo pipefail` | Fail fast in scripts: exit on error, on unset variable, and on a failing pipeline stage. |

## Package and build tools

| Task | Command | Notes |
|---|---|---|
| Install a Debian package | `sudo apt update && sudo apt install <pkg>` | `apt search` / `apt show` to inspect first. |
| Install Node dependencies | `npm install` | `npm ci` installs exactly the lockfile — use it in CI. |
| Add a Node dependency | `npm install <pkg>` | `-D` for dev-only; `npm uninstall` to remove. |
| Run a package script | `npm run <script>` | Scripts live in `package.json`; `npm run` alone lists them. |
| Add a Java dependency | edit `pom.xml`, then `mvn dependency:tree` | Never pin a transitive version a BOM manages. |
| Build a Java project | `mvn clean verify` | `-DskipTests` skips tests — never in CI. |
| Run a Spring Boot app | `mvn spring-boot:run` | `-Dspring-boot.run.profiles=dev` selects a profile. |
| Install Python packages | `python -m venv .venv && . .venv/bin/activate && pip install -r requirements.txt` | Venv first, so the system interpreter stays clean. |
| Add a Flutter package | edit `pubspec.yaml`, then `flutter pub get` | `flutter pub outdated` shows upgrade candidates. |
| Run a Flutter app | `flutter run` | `flutter run -d chrome` targets the web device. |

## Compile and run directly

```bash
# Java 21: compile to a directory, then run by class name
javac --release 21 -d out src/main/java/com/example/App.java
java -cp out com.example.App
```

- `--release 21` compiles against the Java 21 API even on a newer JDK, so the bytecode stays runnable on 21.
- `-d out` keeps `.class` files out of the source tree; `java -cp out` puts that directory on the classpath.
- **Expected:** no output on success; `javac` prints `error:` lines with `symbol:` and `location:` on failure.

```bash
# Node 24: run an ES module file directly, no build step
node --version        # v24.13.1 on the authoring machine
node app.mjs
```

- `.mjs` is always an ES module; `.js` follows `"type"` in the nearest `package.json`.
- **Expected:** `node --version` prints the version; a syntax error prints the file, line and a caret.

```bash
# Quick HTTP probe without leaving the shell
curl -sS -o /dev/null -w '%{http_code}\n' http://localhost:8080/actuator/health
```

- **Expected:** `200` when the service is up. `000` means the connection failed — check the port and the process, not the application code.

## Related pages

- [Git Reference](git-reference.md) — version control by goal
- [Linux Reference](linux-reference.md) — filesystem, services and permissions in depth
- [Docker Reference](docker-reference.md) — containers and Compose
- [Common Errors](common-errors.md) — what these commands look like when they fail
