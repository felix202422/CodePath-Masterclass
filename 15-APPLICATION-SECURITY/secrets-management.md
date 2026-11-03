# Secrets Management

> Every transcript in this lesson was executed on the authoring machine (Windows 11,
> Python 3.13.5, standard library only) in the batch-17 `seclab-C` scratch lab. The keys
> in the capture (`sk_live_EXAMPLE...`, `AKIA...EXAMPLE`) are **well-known fixture values, not
> real credentials**; live secret scanners (gitleaks, trufflehog), git-history rewriting,
> and cloud secret managers were not run and are marked *labelled reference*.

## 1. Learning Objectives

After this lesson you will be able to:

- [ ] Distinguish configuration from secrets, and say why one belongs in code and the other never does
- [ ] Run a pattern-based secret scan over a repository and interpret each finding's file, line, and pattern name
- [ ] Prove that moving a value from a literal to an environment variable removes it from source while keeping it available at runtime
- [ ] Implement log masking so a key can be correlated without being read back
- [ ] State the response when a secret *was* committed: rotation first, history rewriting second — and why deleting the line is not remediation

## 2. Prerequisites

- [Secure API Design](secure-api-design.md) — the leaky error bodies that expose connection strings; this lesson is where such values should live instead
- [Password Security](password-security.md) — the same "store it so it can't be read back" thinking applied to user credentials
- [03-DEVELOPER-TOOLS](../03-DEVELOPER-TOOLS/README.md) — git workflows; committing, ignoring, and cleaning tracked files

*No code prerequisite beyond reading Python — the probe is printed in full and uses only the standard library.*

## 3. Introduction

A **secret** is a credential that grants power — an API key, a database password, a
private key — and its entire security rests on being unknown. Put one in your source
code and it becomes: copied to every clone, cached in every CI checkout, printed by
every `git log -p`, embedded in every built artifact. This lesson scans a repository the
way a scanner does — pattern by pattern, file and line — finds four secrets a beginner
would not think to look for, then shows the same key living *outside* source in an
environment variable and appearing masked in logs. The habits are small; the failure
mode they prevent is the most common credential breach there is.

## 4. The Problem It Solves

Secrets in source are not a theoretical risk; they are the default outcome of unguided
development:

- **It works immediately.** `API_KEY = "sk_live_..."` at the top of `app.py` runs on the first try — no `.env`, no config service, no setup step. The path of least resistance ends in a public GitHub repository.
- **One line, everywhere.** A clone, a CI cache, a Docker layer, a zip someone emailed — the literal travels to every copy of the repo, and each copy is a new place to leak.
- **Deleting does not delete.** Removing the line in a later commit leaves it in history; `git log -p` still shows it. Until the *credential itself* is rotated, the repository has leaked it.
- **Logs echo secrets back.** Even after the code is fixed, a `print` of the request headers re-leaks the key to log aggregation on every call — which is why phase 3 masks before formatting.

The probe's phase 1 is the intervention: a scanner that does not know your code, only
patterns — and it still finds the API key, the database password, the private key block,
and the AWS access key id.

## 5. Core Concepts

### Config vs secret

**Configuration** describes *how* to run: ports, feature flags, log levels — safe in
code, reviewable, boring. A **secret** grants access: keys, passwords, tokens, private
keys — never in code, never in the repo, injected at runtime from outside. The test to
apply: *if this value became public, could someone act as us?* If yes, it's a secret.

### Pattern scanning

The probe's four patterns are what real scanners start with:

| Pattern | Catches | Example finding |
|---|---|---|
| `-----BEGIN (RSA \|EC )?PRIVATE KEY-----` | PEM private-key blocks | `certs/server.key:1` |
| `\bAKIA[0-9A-Z]{16}\b` | AWS access key ids | `deploy.sh:2` |
| `(api[_-]?key\|secret\|token\|password) = "..."` | Assigned credential-looking literals | `app.py:3` |
| `\w+://user:pass@host` | Credentials embedded in URLs | `app.py:4` |

Scanners add **entropy scoring** (random-looking strings without a known prefix) and
**known-value databases** — and they run in pre-commit hooks and CI, so the push is
blocked rather than cleaned up later (gitleaks/trufflehog and CI wiring not run here —
*labelled reference*).

### Load from the environment, not the file

`os.environ["API_KEY"]` keeps the literal out of source entirely. Phase 2 proves it
three ways: `literal in source: False`, `scan findings: 0` for the env-based file — and
the runtime value still arrives (`LAB_API_KEY loaded, length 23`). For local work a
`.env` file sits *untracked* beside the code; production reads from the platform's
secret store (environment of the service, a cloud secret manager, or a mounted secret
file). Note that `.gitignore` protects only files never committed — and never un-commits
one.

### Masking

**Masking** means logs keep enough of a secret to *identify* it (a prefix and suffix)
without enough to *use* it. Phase 3's `sk_l...RE` tells an engineer which key a line
concerned while `key in masked_line` proves the full value is absent. Mask at the
point of formatting — the value still exists in memory; it just never reaches the log
transport.

### Rotation is the real remediation

**Rotation** means revoking and reissuing the credential at the *provider*. Once a
secret was ever committed, the repository has lost the race: history rewriting,
`git filter-repo`, force-pushing, and GitHub support tickets remove copies, but only
rotation removes the *power* the key carries. Order of operations: rotate first, then
scrub history, then add the scanner that would have caught it.

## 6. How It Works

```mermaid
flowchart LR
    R[Repository files] --> S[Pattern scan]
    S -->|match: literal credential| F[Findings: file:line pattern]
    F --> A[API key / DSN / PEM / AWS id]
    A -->|kept in source| G[Every clone and CI cache holds it]
    A -->|moved to environment| H[Source clean: 0 findings]
    H --> RT[Runtime: os.environ load]
    RT --> L[Log line]
    L -->|raw| X[Full key in logs]
    L -->|masked| Y[sk_l...RE in logs]
```

The scan is the detector, the environment is the storage, and masking is the last line
— three separate controls, because a secret can leak at each of three moments: commit,
runtime log, error response ([secure-api-design.md](secure-api-design.md)'s leaky phase).

## 7. Practical Examples

**Example 1 — the full probe: scan, load, mask**

```python
# SEC-12 secrets-management probe: find committed secrets with pattern scanning,
# prove env-var loading keeps them out of source, and mask them in logs.
# Standard library only. Run: python secrets_probe.py
import os
import re
from pathlib import Path

SAMPLE_REPO = Path("fake-repo")
PATTERNS = {
    "private key block": re.compile(r"-----BEGIN (?:RSA |EC )?PRIVATE KEY-----"),
    "AWS access key id": re.compile(r"\bAKIA[0-9A-Z]{16}\b"),
    "generic api key assignment": re.compile(
        r"(?i)\b(api[_-]?key|secret|token|password)\b\s*[:=]\s*[\"'][^\"']{8,}[\"']"),
    "database url with password": re.compile(r"\w+://[^/\s:]+:[^@\s]+@[\w.-]+"),
}

FILES = {
    "app.py": (
        'import os\n\n'
        'API_KEY = "sk_live_EXAMPLE_FIXTURE"\n'
        'DATABASE_URL = "postgres://app:DevPass99@10.0.4.11:5432/prod"\n'
    ),
    "app_env.py": (
        'import os\n\n'
        'API_KEY = os.environ["LAB_API_KEY"]   # no literal in the file\n'
    ),
    "deploy.sh": (
        '#!/bin/sh\n'
        'aws configure set aws_access_key_id AKIAIOSFODNN7EXAMPLE\n'
    ),
    "certs/server.key": (
        "-----BEGIN RSA PRIVATE KEY-----\nMIIEpAIBAAKCAQEA0dummydata...\n"
    ),
    "README.md": (
        "# demo\nSet API_KEY in the environment; never commit it.\n"
    ),
}


def scan(root):
    findings = []
    for path in sorted(root.rglob("*")):
        if not path.is_file():
            continue
        text = path.read_text(encoding="utf-8", errors="replace")
        for name, pattern in PATTERNS.items():
            for match in pattern.finditer(text):
                line = text[:match.start()].count("\n") + 1
                findings.append((str(path.relative_to(root)), line, name, match.group(0)))
    return findings


for rel, content in FILES.items():
    target = SAMPLE_REPO / rel
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_text(content, encoding="utf-8")

print("=== 1. pattern scan of a fake repo ===")
findings = scan(SAMPLE_REPO)
for file, line, name, snippet in findings:
    shown = snippet if len(snippet) <= 46 else snippet[:43] + "..."
    print(f"  {file}:{line} [{name}] {shown}")
print(f"  findings: {len(findings)}")

print()
print("=== 2. same value: committed literal vs environment ===")
os.environ["LAB_API_KEY"] = "sk_live_EXAMPLE_FIXTURE"    # provided at runtime
hard = "sk_live_EXAMPLE_FIXTURE" in (SAMPLE_REPO / "app.py").read_text(encoding="utf-8")
soft = "sk_live" in (SAMPLE_REPO / "app_env.py").read_text(encoding="utf-8")
env_findings = [f for f in scan(SAMPLE_REPO) if f[0] == "app_env.py"]
print(f"  app.py     (hardcoded): literal in source: {hard}")
print(f"  app_env.py (from env) : literal in source: {soft}")
print(f"  app_env.py scan findings: {len(env_findings)}")
print(f"  runtime value         : LAB_API_KEY loaded, length {len(os.environ['LAB_API_KEY'])}")

print()
print("=== 3. masking: what a log line should contain ===")


def mask(value):
    if len(value) < 8:
        return "***"
    return value[:4] + "..." + value[-2:]


key = os.environ["LAB_API_KEY"]
raw_line = f"login with api_key={key}"
masked_line = f"login with api_key={mask(key)}"
print(f"  raw log    : {raw_line}")
print(f"  masked log : {masked_line}")
print(f"  raw contains full key    : {key in raw_line}")
print(f"  masked contains full key : {key in masked_line}")
```

- Phase 1 is the scanner's value proposition: four findings across four file types — an assigned key, a DSN with a password, a PEM block, an AWS key id — none of which a human reading `app.py` for *logic bugs* would flag.
- Phase 2 isolates one variable: the *same value* hardcoded vs loaded. Hardcoded: literal present, scanner would find it. From environment: `literal in source: False`, `scan findings: 0` — and the runtime still gets the value (`length 23`).
- Phase 3 is the post-commit leak path: the raw log contains the whole key (`True`), the masked one does not (`False`) — while still identifying which key it was.
- **Expected output:** the capture below.
- **How to run it:** `python secrets_probe.py` (Windows 11, Python 3.13.5).
- **Assumptions:** standard library only; fixture values only; `fake-repo/` is created fresh by the probe.

**Executed capture:**

```text
=== 1. pattern scan of a fake repo ===
  app.py:3 [generic api key assignment] API_KEY = "sk_live_EXAMPLE_FIXTURE"
  app.py:4 [database url with password] postgres://app:DevPass99@10.0.4.11
  certs\server.key:1 [private key block] -----BEGIN RSA PRIVATE KEY-----
  deploy.sh:2 [AWS access key id] AKIAIOSFODNN7EXAMPLE
  findings: 4

=== 2. same value: committed literal vs environment ===
  app.py     (hardcoded): literal in source: True
  app_env.py (from env) : literal in source: False
  app_env.py scan findings: 0
  runtime value         : LAB_API_KEY loaded, length 23

=== 3. masking: what a log line should contain ===
  raw log    : login with api_key=sk_live_EXAMPLE_FIXTURE
  masked log : login with api_key=sk_l...RE
  raw contains full key    : True
  masked contains full key : False
```

**Example 2 — the runtime pattern: config module + untracked `.env` (illustration)**

```python
# config.py — imported everywhere, contains no values
import os

API_KEY = os.environ["APP_API_KEY"]            # required: fail fast if missing
DATABASE_URL = os.environ["DATABASE_URL"]

# .env  (untracked — `echo ".env" >> .gitignore`, committed .env.example instead)
# APP_API_KEY=...
# DATABASE_URL=postgres://app:REDACTED@db.internal:5432/prod

# CI/prod: the platform injects the same names (secret store, service env, mounted file)
# Rotate at the provider if a real value was ever committed — then scrub history.
```

- **Expected output:** no output — the shape phase 2 measured: values absent from source, present at runtime.
- **Assumptions:** illustration; the probe executed scan/mask directly.

## 8. Real-World Applications

- **Pre-commit hooks and CI gates** run scanners like phase 1's on every push — the industry pattern for keeping keys out of history before review even starts.
- **`.env` + `.env.example`** is the standard local convention: the example (with placeholder values) is committed; the real file never is.
- **Platform secret stores** (environment of the service, cloud secret managers, Kubernetes Secrets) are the production half of `os.environ[...]`; their access audit is itself a security control (*labelled reference* — none wired up here).
- **Log pipelines** apply masking centrally (the phase 3 function, done once at the logging layer) because individual services forget.
- Paired with: [secure-api-design.md](secure-api-design.md) for error bodies, [dependency-security.md](dependency-security.md) for the supply chain those credentials ride through, and [SECURITY.md](../SECURITY.md)'s rules for handling anything real.

## 9. Common Mistakes

| Mistake | Why it happens | How to recognize it | How to prevent it |
|---|---|---|---|
| Literal in source | "Just for now" | Phase 1's `app.py:3` finding | Environment/secret store from commit one |
| `.env` committed, then deleted | `.gitignore` added late | Secret still in `git log -p` | Rotate; then rewrite history; ignore from day one |
| DSN with password in a URL | Connection strings copied from docs | Phase 1's `app.py:4` finding | Build URLs from parts, or parse-and-mask before use |
| Private key in the repo | "Backup convenience" | `certs/server.key:1` | Kept in a secret store or mounted file, never tracked |
| Deleting the line as the fix | Removal mistaken for remediation | Key still works for anyone who saw it | Rotate *first*, scrub *second* |
| Printing headers/bodies to logs | Debugging left in | Full key in log search results | Mask at the formatting layer (phase 3) |
| Same key everywhere | One key "to keep it simple" | Revoking it breaks five systems | Per-service scoped keys with minimal privileges |
| Secret in CI variable visible to PRs | Default pipeline config | Fork PRs can exfiltrate it | Restrict secret exposure to trusted branches |

## 10. Best Practices

- **Classify every value as config or secret before committing** — the question is "if public, can someone act as us?"
- **Fail fast on missing secrets** (`os.environ["KEY"]`, not `os.environ.get("KEY", "dev")`) so a misconfigured production start is loud instead of silently using a fallback credential.
- **Scan in pre-commit and in CI** on every branch; the rule stops applying never — but entropy-only rules need tuning to avoid alert fatigue, which is why known-prefix patterns (phase 1) come first.
- **Scope and shorten lifetimes**: per-service keys, least privilege, rotation schedules — a leaked key that expires in an hour is an incident, not a breach (rotation tooling *labelled reference*).
- **Mask at the log layer, centrally**, so individual `print`s inherit it; keep secrets out of URLs entirely (they land in access logs).
- **Rehearse the response**: decide *now* who revokes a key and how fast — the difference between a rotation and a breach is minutes.

## 11. Limitations and Trade-Offs

- **Patterns catch the obvious.** A secret without a recognizable prefix, split across strings, or fetched at runtime evades phase 1's regexes; scanners compensate with entropy and allowlists, and still miss things — the scan is a net, not a proof.
- **Environment variables are not encrypted storage.** They leak via `/proc`, crash dumps, child processes, and debug endpoints — better than source, weaker than a secret manager with access audit and per-request issuance (*labelled reference*).
- **Masking is cosmetic.** It protects logs, not memory, error objects, or the value's many holders — and a bad mask (`first 6 + last 4` of a short key) gives the game away; phase 3's rule (and the `< 8 → ***` guard) shows the minimum bar.
- **History scrubbing is disruptive.** Rewriting history invalidates every clone and open pull request — which is exactly why rotation, not scrubbing, is the primary control.
- **The lab holds no real credentials.** Nothing here exercised a provider's revocation flow or a real scanner's false-positive rate — *labelled reference*.

## 12. Practical Exercises

### Introductory

1. **Exercise 12.1** — Run the probe and match each of the four findings to the pattern that produced it, quoting the pattern's role in one line each. **Completion criteria:** a four-row table: file:line, pattern name, why the value matched.
2. **Exercise 12.2** — Add a fake `stripe` key (`rk_test_` + 24 alphanumerics) to `app.py`, extend the generic pattern to catch it, and rescan. **Completion criteria:** a capture showing `findings: 5` with the new line.

### Intermediate

3. **Exercise 12.3** — Move `DATABASE_URL` to the environment as phase 2 did for the API key, and show `app.py` dropping to zero scan findings while the connection string still resolves at runtime. **Completion criteria:** captures of the new scan and a `length` print for the DSN.
4. **Exercise 12.4** — Harden `mask()` so that keys under 8 characters return `***` (already present) *and* keys of 8–12 characters keep only the prefix; test all three lengths. **Completion criteria:** a capture with three masked outputs, none containing its full input.

### Independent problem-solving

5. **Exercise 12.5** — You discover a live API key in your repository's history. Write the incident runbook. **Completion criteria:** an ordered list covering revocation/rotation at the provider first, scope assessment (where the key was used), history scrubbing with its costs, scanner introduction, and the notification decision — with a one-line justification for the ordering.

*Solutions: attempt first. They live in `solutions/` of this subject.*

## 13. Knowledge Check

1. Phase 2 shows `scan findings: 0` for `app_env.py` but `length 23` at runtime. What exactly was eliminated, and what was *not* — where does the value live now?
2. Why is deleting a committed secret insufficient remediation even if the delete is force-pushed to every remote?
3. What does masking protect against, and which of the three leak moments in this lesson (commit, log, error response) does it not address?
4. When *is* a value safe to put in source — and what question settles it?

## 14. Completion Criteria

Observable evidence that you have understood this lesson:

- [ ] You can classify any value as config or secret using the "act as us" test
- [ ] You can run a pattern scan and explain every finding line in the capture
- [ ] You can move a hardcoded credential to the environment and show the scan clean while the value still loads
- [ ] You can write a masking function that provably fails the `key in masked` test
- [ ] You can state the rotate-then-scrub ordering and the reason it is not reversed

## 15. Summary

- A secret's whole job is being unknown; source code tells everyone.
- Phase 1's four patterns find an API key, a DSN password, a PEM key, and an AWS id without understanding a line of the code.
- Environment loading removes the literal from source (`findings: 0`) while runtime still receives the value (`length 23`).
- Logs are the next leak path: raw contains the full key, masked does not.
- If a secret was ever committed, rotation at the provider is the fix — history scrubbing is cleanup.

## 16. Next Steps

- Next lesson: [Dependency Security](dependency-security.md) — the same "what's in my supply" question applied to packages instead of values
- Practice: the subject's exercise set (written with its exercise installment)
- Where it is applied: [Project 07](../20-PROJECT-LABORATORY/project-07-secure-production-application/README.md)'s
  security checklist, and the safe-use rules in [SECURITY.md](../SECURITY.md)