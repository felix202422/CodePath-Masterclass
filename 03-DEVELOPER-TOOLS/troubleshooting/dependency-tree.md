# broken install / "works on my machine" — dependency-tree diagnosis

**Layer:** tooling (package manager). **Symptoms:** `npm ci` refuses to run, module-not-found at
runtime, install errors (`E404`, `EUSAGE`, `EACCES`), or a project that runs for you and for
nobody else.

## The decision table (read your error, pick a row)

| Error text (real npm forms below) | Meaning | Go to |
|---|---|---|
| `` `npm ci` can only install packages when … in sync `` | Manifest and lockfile disagree | Fix A |
| `404 Not Found - GET …/ghost-dep` | The named package/version does not exist (typo, unpublished, wrong registry) | Fix B |
| `Cannot find module 'x'` at **runtime** | Install tree missing/incomplete, or the import name is wrong | Fix C |
| `EACCES` / `EPERM` (permission during install) | Install is writing somewhere your user cannot | [permission-denied.md](permission-denied.md) |
| Works locally, fails in CI / teammate's clone | Undeclared dependency or lockfile not committed | Fix D |

## Diagnosis — executed transcripts

**The lockfile refusal (real, produced by deliberately deleting an entry from the lock):**

```console
$ npm ci
npm error code EUSAGE
npm error
npm error `npm ci` can only install packages when your package.json and package-lock.json or npm-shrinkwrap.json are in sync. Please update your lock file with `npm install` before continuing.
npm error
npm error Missing: tiny-utils@1.0.0 from lock file
```

The remedy, executed immediately after:

```console
$ npm install
up to date, audited 3 packages in 4s

found 0 vulnerabilities
$ npm ci
added 1 package, and audited 3 packages in 3s

found 0 vulnerabilities
```

Read the sequence: `npm install` **repairs the lock** within manifest ranges; `npm ci` goes green
again because it can now reproduce exactly what the lock says. (If your *intent* was to change
versions, `npm install <pkg>` did that first — the point is knowing which command owns which
file: **install may write the lock; ci never does** — see [../package-managers.md](../package-managers.md).)

**A package that does not exist (real — a dependency name invented for this test):**

```console
$ npm ci   # with ghost-dep added to package.json
npm error code E404
npm error 404 Not Found - GET https://registry.npmjs.org/ghost-dep - Not found
npm error 404  The requested resource 'ghost-dep@^9.9.9' could not be found or you do not have permission to access it.
npm error 404 Note that you can also install from a
npm error 404 tarball, folder, http url, or git url.
```

Four-line checklist for `E404`: spelling of the name; does it exist **on this registry** (check
`npm config get registry` — corporate mirrors lag); does this **version** exist
(`npm view <pkg> versions`); is it a **scoped** name you forgot the scope on (`@types/…`).

**Is the installed tree even real?** — three commands that answer "works on my machine" objectively:

```console
$ npm ls
npmtest@1.0.0 C:\Users\PC\AppData\Local\Temp\tools01\npmtest
`-- tiny-utils@1.0.0 -> .\vendor\tiny-utils

$ npm --version
11.8.0
$ node --version
v24.13.1
```

- `npm ls` exits non-zero and prints `UNMET DEPENDENCY` / `extraneous` lines when the tree does
  not match the manifest — run it *before* blaming code.
- Version lines matter: the classic "works on my machine" is you on node 24 / npm 11 and a
  teammate on an older pair (or CI on a third) — compare with `npm ls` output in the bug report,
  and pin the pair in your project's docs/`engines` field.

## Fix

| Situation | Repair |
|---|---|
| **A.** Lock out of sync | `npm install` (updates the lock, then commit it) — or, if the lock edit was accidental and the lock is committed: `git checkout -- package-lock.json` |
| **B.** `E404` | Fix the name/version/registry per the four-line checklist above; if the package was unpublished, choose a maintained alternative (and tell the team — this is a supply-chain event, see [../package-managers.md](../package-managers.md) §10) |
| **C.** `Cannot find module` | `rm -rf node_modules && npm ci` — the lockfile is the recovery image ([../package-managers.md](../package-managers.md) Example 4). If it *still* fails, the package was never declared: add it to the manifest, not just your import |
| **D.** Only *their* machine fails | Verify what is committed: `git ls-files package.json package-lock.json` must list **both**; then `git check-ignore node_modules` (must be ignored) — the manifest+lock pair is the whole contract, everything else is cache |

Illustration (not executed on this machine — Windows install here never produced it): a Unix
`EACCES` install error means npm is writing into a global prefix owned by root; the fixes are
switching npm's cache/prefix to your home (`npm config set prefix ~/.npm-global` style) or, for a
one-off, the elevated install your platform documents — never `sudo npm install` as a standing
habit (see [permission-denied.md](permission-denied.md)).

## Prevent

- **Manifest + lockfile committed; `node_modules` ignored — verify, don't assume:**
  `git ls-files` and `git check-ignore` as above, in every repository you start.
- **CI runs `npm ci`** — it is the machine that proves the lock on every push
  ([../github-workflows.md](../github-workflows.md) Example 6).
- **Same toolchain, stated:** document node/npm versions (`engines`, `.nvmrc`) so "my machine"
  has a defined shape others can reproduce.
- **One install command per purpose:** `npm install` when you *mean* to change dependencies;
  `npm ci` every other time — teams that mix them casually are the teams whose locks drift.
