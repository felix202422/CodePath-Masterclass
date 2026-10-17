# Security Policy

## Reporting a vulnerability

If you find a **real security vulnerability** — for example, a live credential committed to this
repository's history, a private key, personal data, or an example that would compromise a learner's
production system if copied as-is — please report it privately:

- **Contact:** felixyhaule@gmail.com (subject line: `[SECURITY] CodePath-Masterclass`)
- Please include: the file path, what you found, how you verified it, and the impact.

**Do not open a public issue for security-sensitive findings.**

### What to expect

- Acknowledgement when the report is received, normally within a few working days.
- An honest assessment of severity and whether a fix is warranted.
- Credit in the changelog if you want it — no credit is claimed by default by anyone else.

This is a one-maintainer educational project run in spare time; response times are best-effort,
not a service-level agreement.

## What is in scope

| In scope | Out of scope |
|---|---|
| Real credentials or private keys anywhere in the repository or its Git history | Vulnerabilities in third-party tools, frameworks, or cloud providers (report to them) |
| Personal data committed accidentally | Theoretical security discussions that are clearly labelled as educational |
| Examples that teach an unsafe pattern without warning the learner | Content opinions and stylistic preferences |
| Instructions that, if followed, would produce an insecure default configuration | Issues requiring physical access or already-exploited production systems |

## Educational context — read this before reporting

This repository **deliberately** contains:

- Vulnerable code examples (SQL injection, XSS, CSRF, SSRF and others) inside
  [15-APPLICATION-SECURITY](15-APPLICATION-SECURITY/README.md), including a local testing lab.
- Passwords, tokens, and API keys that look real but are placeholders (e.g. `changeme-`,
  `your-token-here`, `password123!` used in a local-only Docker Compose file).

These are intentional, are confined to clearly marked sections, and exist so learners can practise
finding and fixing problems in **their own local environment**. They are not vulnerabilities unless
they are (a) real, (b) reusable, and (c) unintended. Before reporting, check whether the material is
inside a labelled lab.

## Safe-use rules for learners

The security lessons are for systems you own or are explicitly authorized to test:

1. Run all labs **locally** (your own machine, containers, local networks).
2. Never point the techniques in these lessons at third-party systems, including public websites —
   unauthorised testing is illegal in most jurisdictions regardless of intent.
3. Never paste real credentials into exercises; use placeholders and local `.env` files that are
   git-ignored (see [.gitignore](.gitignore)).

## Supported versions

This repository documents current tool versions only — see [VERSIONS.md](VERSIONS.md). Material
for older major versions of a tool is not maintained; check the [CHANGELOG](CHANGELOG.md) before
relying on any lesson that is more than a few months old.