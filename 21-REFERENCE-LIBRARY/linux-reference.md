# Linux Reference

Filesystem, permissions, processes, services, networking and text processing for a Debian/Ubuntu
shell — the environment used throughout the DevOps subject, in WSL or a container.

> **Baseline.** Debian/Ubuntu userland, bash 5, systemd, GNU coreutils. Command syntax follows the
> man pages. **Not executed on the authoring machine**, which runs Windows: systemd and package
> commands are documented from their manuals, not captured here. Shell, file and text commands are the
> same in Git Bash and WSL, and those were exercised in
> [Command Reference](command-reference.md).

## Filesystem layout

| Path | Holds |
|---|---|
| `/` | Root of everything; nothing lives "outside" it. |
| `/etc` | System-wide configuration, one file per service. |
| `/var` | Variable data: logs (`/var/log`), databases, caches, spool. |
| `/usr` | Installed programs and their data (`/usr/bin`, `/usr/lib`, `/usr/share`). |
| `/home/<user>` | User files, dotfiles, shell configuration. |
| `/root` | Home directory of the root user. |
| `/tmp` | Scratch space, world-writable, cleared on reboot often. |
| `/opt` | Self-contained third-party applications. |
| `/proc`, `/sys` | Kernel-generated views of processes and devices. |
| `/dev` | Device files (`/dev/null`, `/dev/sda`, `/dev/stdin`). |
| `/srv` | Data served by the machine (web roots, FTP), convention only. |

WSL note: Windows drives appear under `/mnt/c`; Linux paths are the fast ones. Editing files on
`/mnt/c` from WSL is slow and can introduce permission and line-ending differences.

## Permissions

```
-rwxr-xr--  1 alice devs  12345 Jan  5 10:00 deploy.sh
│└┬┘└┬┘└┬┘
│ │  │  └── other: r--
│ │  └───── group: r-x
│ └──────── owner: rwx
└────────── type: - file, d directory, l symlink
```

| Octal | Symbolic | Meaning |
|---|---|---|
| `7` | `rwx` | Read, write, execute. |
| `6` | `rw-` | Read, write. |
| `5` | `r-x` | Read, execute (or traverse a directory). |
| `4` | `r--` | Read only. |
| `0` | `---` | No access. |

| Command | Effect |
|---|---|
| `chmod 644 file` | Owner writes, everyone reads. |
| `chmod 755 dir` | Owner writes, everyone lists and traverses. |
| `chmod 600 .env key.pem` | Private to the owner — required for secrets. |
| `chmod +x script.sh` | Adds execute without touching other bits. |
| `chmod -R g+w shared/` | Recursive group write. |
| `chown app:app /srv/app` | Owner and group change; needs root. |
| `umask 022` | New files 644, new directories 755. |
| `getfacl` / `setfacl` | Per-user ACLs beyond the three classes. |

Special bits worth recognising: **setuid** (`4xxx`) runs as the file's owner, **setgid** (`2xxx`) on a
directory makes new files inherit the group, **sticky** (`1xxx` on `/tmp`) lets only the owner delete
their files. `ls -l` shows them as `s`/`t` in place of `x`.

## Users and groups

| Task | Command |
|---|---|
| Who am I, and which groups? | `id`, `groups` |
| Add a user with a home directory | `useradd -m -s /bin/bash alice` |
| Set a password | `passwd alice` |
| Add to a supplementary group | `usermod -aG sudo alice` (re-login to take effect) |
| Create a group | `groupadd devs` |
| Switch user | `su - alice` (login shell), `sudo -u app <cmd>` |
| Run as root | `sudo <cmd>` — never `sudo su` for routine work |
| List logged-in users | `who`, `w` |

`/etc/passwd` holds accounts (world-readable), `/etc/shadow` holds password hashes (root-only),
`/etc/group` holds groups. A service account for an application should have no login shell
(`/usr/sbin/nologin`) and no `sudo`.

## Processes and signals

| Command | Meaning |
|---|---|
| `ps aux` | Every process with user, CPU, memory, command. |
| `ps -ef --forest` | Parent/child tree. |
| `top` / `htop` | Live view; `M` by memory, `P` by CPU, `q` quit. |
| `pgrep -af name` | Match by full command line, print PID and command. |
| `pstree -p` | Tree with PIDs. |
| `lsof -p PID` | Open files and sockets of a process. |
| `strace -p PID` | System calls a process makes (needs privilege). |

| Signal | Number | Meaning |
|---|---|---|
| `SIGTERM` | 15 | "Please stop" — the default `kill`. Handlers run. |
| `SIGINT` | 2 | `Ctrl+C` — interactive interrupt. |
| `SIGHUP` | 1 | Often "reload configuration". |
| `SIGKILL` | 9 | Cannot be caught or ignored. Data loss possible. |
| `SIGSTOP` / `SIGCONT` | 19 / 18 | Pause and resume. |

Escalate: `SIGTERM`, wait, then `SIGKILL` only if the process is stuck. Killing by name pattern
(`pkill -f java`) can hit unrelated processes, including your own shell.

## Services with systemd

```ini
# /etc/systemd/system/notes.service
[Unit]
Description=Notes API
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=notes
WorkingDirectory=/srv/notes
ExecStart=/usr/bin/java -jar /srv/notes/app.jar
Restart=on-failure
RestartSec=5
EnvironmentFile=/etc/notes.env

[Install]
WantedBy=multi-user.target
```

| Task | Command |
|---|---|
| Reload unit files after editing | `sudo systemctl daemon-reload` |
| Start / stop / restart | `sudo systemctl start notes`, `stop`, `restart` |
| Enable at boot | `sudo systemctl enable --now notes` |
| Status and recent logs | `systemctl status notes` |
| Follow logs | `journalctl -u notes -f` |
| Logs since boot / since a time | `journalctl -b`, `journalctl --since "10 min ago"` |
| Failed units | `systemctl --failed` |
| List timers | `systemctl list-timers` |

`Restart=on-failure` with a `RestartSec` delay is the minimum for a long-running service; without it, a
crash leaves the service down until someone notices.

## Scheduled work

| Need | Tool |
|---|---|
| Run every N minutes as a user | `crontab -e`, then `*/5 * * * * /srv/app/backup.sh` |
| List / remove | `crontab -l`, `crontab -r` (careful: removes everything) |
| System-wide schedule | `/etc/cron.d/<name>` (with a user column) |
| Precise, logged scheduling | A systemd timer (`OnCalendar=*-*-* 03:00:00`) |
| One-off at a time | `at now + 1 hour` |

Cron has a minimal environment: set `PATH` explicitly or use absolute paths, and redirect output to a
file or `journalctl` will not show you why it failed.

## Networking

| Task | Command |
|---|---|
| Addresses and interfaces | `ip addr`, `ip -br a` |
| Routes | `ip route` |
| Listening sockets | `ss -ltnp` |
| All connections | `ss -tunap` |
| Resolve a name | `dig +short example.com`, `getent hosts example.com` |
| Reachability | `ping -c 3 host` |
| HTTP probe | `curl -sS -o /dev/null -w '%{http_code}\n' url` |
| DNS servers in use | `resolvectl status` or `cat /etc/resolv.conf` |
| Firewall (Ubuntu) | `sudo ufw status`, `sudo ufw allow 443/tcp` |
| Firewall (nftables) | `sudo nft list ruleset` |

Ports below 1024 need privilege (or `CAP_NET_BIND_SERVICE`); containers usually publish `8080:80`
rather than binding 80 inside.

## Packages

| Task | Command |
|---|---|
| Refresh the index | `sudo apt update` |
| Upgrade installed packages | `sudo apt upgrade` |
| Install / remove | `sudo apt install nginx`, `sudo apt remove nginx` |
| Search / show | `apt search nginx`, `apt show nginx` |
| Which package owns a file | `dpkg -S /usr/bin/curl` |
| Which files a package installs | `dpkg -L curl` |
| Held packages | `apt-mark showhold` |

Do not mix `apt` and `snap`/PPA versions of the same service, and never run `apt upgrade` on a
production host without a way back.

## Disks and mounts

| Task | Command |
|---|---|
| Free space | `df -h` |
| Directory sizes | `du -sh /var/* \| sort -h` |
| Block devices | `lsblk`, `lsblk -f` (with filesystems) |
| Mounts in effect | `mount \| column -t`, `findmnt` |
| Mount a device | `sudo mount /dev/sdb1 /mnt/data` |
| Persist a mount | `/etc/fstab` — test with `sudo mount -a` before rebooting |
| Inodes exhausted | `df -i` — "no space" with free bytes is usually inodes |

## Logs

| Path | Content |
|---|---|
| `journalctl` | Everything systemd captured (preferred on modern systems). |
| `/var/log/syslog` | General system log (Debian/Ubuntu). |
| `/var/log/auth.log` | Authentication attempts, sudo. |
| `/var/log/nginx/access.log`, `error.log` | Reverse proxy traffic and errors. |
| `/var/log/dpkg.log` | Package operations. |

`journalctl -u app -o json-pretty` for structured entries, `journalctl -p err -b` for errors since
boot, `journalctl --disk-usage` to see how much space logs take.

## SSH

| Task | Command |
|---|---|
| Generate a key | `ssh-keygen -t ed25519 -C "you@example.com"` |
| Copy the public key to a host | `ssh-copy-id user@host` |
| Connect | `ssh user@host` |
| Run one command | `ssh user@host 'systemctl status app'` |
| Copy files | `scp file user@host:/path`, or `rsync -av dir/ user@host:/path/` |
| Local port forward | `ssh -L 5432:localhost:5432 user@host` |
| Debug a connection | `ssh -vvv user@host` |

`~/.ssh/config` entries (`Host`, `HostName`, `User`, `IdentityFile`) remove most typing. Permissions
matter: `chmod 600 ~/.ssh/id_ed25519`, `chmod 700 ~/.ssh`, or ssh refuses the key.

## Shell startup and environment

| File | When it runs |
|---|---|
| `/etc/profile` | Login shells, system-wide. |
| `~/.bashrc` | Interactive non-login shells (most terminals). |
| `~/.profile` | Login shells, per user. |
| `/etc/environment` | System-wide variables, no shell syntax. |
| `~/.bash_profile` | Login shells if present; usually sources `~/.bashrc`. |

Put `PATH` additions and aliases in `~/.bashrc`; put service configuration in `/etc/<service>/`
rather than the environment of an interactive shell. Secrets belong in a root-readable
`EnvironmentFile` (`chmod 600`), never in a world-readable profile.

## Things that bite on Windows/WSL

| Symptom | Cause | Fix |
|---|---|---|
| `bad interpreter: /bin/bash^M` | CRLF line endings in a script. | `dos2unix script.sh`, or configure the editor to write LF for `.sh`. |
| Permissions look wrong on `/mnt/c` | The Windows filesystem does not store POSIX modes. | Keep the repository inside the Linux filesystem (`~/code`). |
| `Permission denied` on a key copied from Windows | The file inherited Windows ACLs as `777`. | `chmod 600` the key after copying. |
| Slow builds | The project is on `/mnt/c`. | Move it under `~`. |

## Related pages

- [Command Reference](command-reference.md) — the commands in daily use, with expected output
- [Docker Reference](docker-reference.md) — containers run this same userland
- [Common Errors](common-errors.md) — permission, port and shebang failures
- [16-DEVOPS-AND-INFRASTRUCTURE/linux-administration.md](../16-DEVOPS-AND-INFRASTRUCTURE/linux-administration.md) — the lesson
