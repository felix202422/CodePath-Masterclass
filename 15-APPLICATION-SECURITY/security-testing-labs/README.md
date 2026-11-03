# Security Testing Labs

> One authorized, local-only lab per vulnerability class in this subject: you run the
> exploit against a deliberately weak target that lives on your own machine, watch the
> failing behavior printed as evidence, apply the fix the lesson teaches, and prove it
> with a test that would have caught the bug. Every probe and capture in these labs was
> executed on the authoring machine (Windows 11, Python 3.13.5, standard library only —
> plus the `openssl` CLI for the TLS lab). Scanners and commercial tooling (sqlmap,
> Burp/DAST, SAST, antivirus, ACME) are named as *labelled reference* where they belong
> and are never required to complete a lab.

## Ground rules — authorized scope only

- **Target only what you own or have written permission to test.** Every target here is a loopback-bound process or file *you* start on *your* machine; nothing in these labs points at a third-party host.
- **Fixture data only.** Names, passwords, tokens, and certificates are invented lab values (`alice`, `summer2026!`, `sk_l...RE`, `CN=Lab Root CA`). Never paste a real secret into a probe, a transcript, or a commit.
- **Stay inside the probe's blast radius.** Each lab writes only to its own scratch directory (`uploads-lab/`, `fake-repo/`, `ca.crt` …) and listens only on its documented loopback port.
- **The attack knowledge carries over; the permission does not.** The patterns you exercise here are exactly what you will meet in real code reviews — running them against systems you are not authorized for is out of scope for this course and for your career. See [SECURITY.md](../../SECURITY.md) for the course's safe-use rules.

## The loop

Every lab follows the same four beats — the workflow you will reuse professionally:

1. **Exploit** — run the probe against the vulnerable target and capture the failure (the `=== N. … ===` phases).
2. **Failing test** — keep that capture as a regression test: it must fail while the bug exists.
3. **Fix** — apply the lesson's control (parameterised query, Origin check, generated filename, protocol floor …).
4. **Proof** — re-run; the exploit line becomes `rejected: …`, `-> 403`, `-> 0 row(s)`, or the fixed verdict the lesson quotes, and the old success line is gone.

## Lab index

| Lab | Lesson | Probe (in `.scratch/`) | You exploit / observe | You prove |
|---|---|---|---|---|
| SEC-01 | [Subject index](../README.md) | — | the prereq chain and scope | `check-links` passes |
| SEC-02 | [Security Fundamentals](../security-fundamentals.md) | `seclab-A/encoding_probe.py`, `depth_probe.py` | “encoding is protection”; a single-connection defense bypass | Base64 recovered in one line; `WRITE BLOCKED` with `rows still readable` → all layers on |
| SEC-03 | [Threat Modeling](../threat-modeling.md) | `seclab-A/threat_probe.py` + `notes_server.py` | a 5-route service leaking rows, owner spoofing, debug config | every finding mapped to a STRIDE cell and a control |
| SEC-04 | [Password Security](../password-security.md) | `seclab-A/salt_probe.py`, `crack_probe.py`, `workfactor_probe.py`, `policy_probe.py` | identical unsalted hashes; `summer2026!` cracked in microseconds; policy ≠ strength | salt + KDF cost + policy-vs-strength verdicts quoted in the lesson |
| SEC-05 | [Session Security](../session-security.md) | `seclab-B/session_probe.py` | fixation, cookie flags, expiry, no rotation/revocation | `replay old sid -> 401`, `expired`/`revoked` 401s, strict cookie flags |
| SEC-06 | [Access Control](../access-control.md) | `seclab-B/authz_probe.py` | IDOR, forced browsing, mass assignment | `-> 403` everywhere the checks were off, own resources still `200` |
| SEC-07 | [Injection](../injection-vulnerabilities.md) | `seclab-B/inject_probe.py` | SQLi tautology/UNION, shell argument injection | parameterised `0 row(s)` and inert `& echo …` argv |
| SEC-08 | [Cross-Site Scripting](../cross-site-scripting.md) | `seclab-B/xss_probe.py` | reflected + stored script injection, `javascript:` URL | escaped `[]`, scheme allowlist `-> #blocked` |
| SEC-09 | [CSRF](../csrf.md) | `seclab-C/csrf_probe.py` | forged cross-site POST changing the victim's email | Origin check and session-bound token both `blocked` |
| SEC-10 | [SSRF](../ssrf.md) | `seclab-C/ssrf_probe.py` | attacker-chosen server-side fetch: metadata, redirect, file scheme | scheme/host allowlist `blocked` on hops 1–3, legitimate fetch still `200` |
| SEC-11 | [Secure API Design](../secure-api-design.md) | `seclab-C/api_probe.py` | no rate limit; verbose errors leaking a DSN | `429` ladder with `Retry-After`, errors reduced to opaque `req_lab_*` ids |
| SEC-12 | [Secrets Management](../secrets-management.md) | `seclab-C/secrets_probe.py` | secrets committed in code, config, and a private key | scanner findings replaced by env loading (`LAB_API_KEY loaded, length 23`) |
| SEC-13 | [Dependency Security](../dependency-security.md) | `seclab-C/deps_probe.py` | unpinned deps, a vulnerable pin, an unverifiable hash | `UNPINNED` fixed by pins+hashes; `GHSA-LAB-0001 < 2.32.0` caught pre-install |
| SEC-14 | [TLS and Certificates](../tls-and-certificates.md) | `seclab-C/tls_probe.py` | trust failure against an unknown CA; version-floor mismatch | same server passes at `TLSv1.3 / TLS_AES_256_GCM_SHA384` with the lab CA trusted |
| SEC-15 | [Secure File Uploads](../secure-file-uploads.md) | `seclab-C/upload_probe.py` | traversal out of the dir, PHP behind `avatar.png`, null byte, oversize | all four refusals: generated stored name, sniff mismatch, extension reject, size reject |

## Running a lab

1. Create a scratch directory *outside* the repo (the authoring runs used
   `.scratch/seclab-A|B|C/`, which is gitignored) and `cd` into it.
2. Copy the probe's ```python block verbatim from the lesson — each lesson's first
   code block *is* the executed file, byte for byte.
3. `python <name>_probe.py` — stdlib only; the TLS lab additionally needs the
   `openssl` CLI (`openssl version` prints 3.5.9 here; Python's `ssl` reports 3.0.16).
4. Compare your output to the lesson's **Executed capture** — it should match line for
   line (dates in certificate validity windows and hash-derived filenames are
   run-dependent).

**Ports used by the networked labs** (all bound to `127.0.0.1` only): CSRF `8095`;
SSRF `8096` / `8097` / `8100`; API `8101`; TLS `8443` / `8444`. The remaining probes are
process-local — they open no listening socket.

## What counts as done

- Every phase in a lesson's capture reproduced on your machine, and the fixed verdict
  matching the lesson's quoted output.
- The four beats recorded for at least one lab in your notes: exploit evidence, the
  failing assertion, the fix, the passing assertion.
- You can say, for each of the nine rows of mistakes in each lesson's *Common Mistakes*
  table, which phase of which probe demonstrates it.

## Next

- Apply the whole set end to end in [Project 07](../../20-PROJECT-LABORATORY/project-07-secure-production-application/README.md).
- Back to the [subject index](../README.md).