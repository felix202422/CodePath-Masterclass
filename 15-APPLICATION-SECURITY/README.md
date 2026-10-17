# 15 — Application Security

Security is a property of design, not a phase. This subject teaches you to think like an attacker
in order to build like a defender: model threats, secure passwords and sessions, enforce access
control, prevent the vulnerability classes that dominate real breaches, and *verify* each control
with a test — in local labs only.

## What this subject covers

- Security fundamentals: CIA triad, defense in depth, and the vocabulary the rest assumes.
- Threat modeling: STRIDE-style analysis of your own design before code exists.
- Password security: hashing (Argon2/bcrypt), salting, and password policy that helps rather than
  hurts.
- Session security: cookie flags, session fixation, expiry, and revocation.
- Access control: authorization models, IDOR, and enforcing checks server-side.
- Injection vulnerabilities: SQL injection and query parameterization.
- Cross-site scripting: the three flavors, and escaping at the right layer.
- CSRF: tokens, same-site cookies, and why the header checks work.
- SSRF: validating outbound requests, and why "the user can't see the response" is not a defense.
- Secure API design: rate limiting, mass assignment, and consistent error responses.
- Secrets management: handling keys without ever committing them.
- Dependency security: vulnerability scanning and supply-chain hygiene.
- TLS and certificates: configuration that is actually secure.
- Secure file uploads: type validation, storage isolation, and serving rules.
- `security-testing-labs/`: local, authorized labs where you exploit each class against a deliberately vulnerable app, then fix it and prove the fix with a test.

## Why it matters

A single unparameterized query defeats everything else you build. The vulnerability classes here
are not exotic — they are the top entries in the OWASP landscape year after year, found constantly
in production systems. Equally important, this subject teaches the *verification* habit: a control
you have not tested is a control you merely hope for.

**Authorization is explicit:** every technique in this subject is practised against applications
you run locally, on your own machine. Pointing these techniques at systems you do not own is
illegal regardless of intent; see the safe-use rules in [SECURITY.md](../SECURITY.md).

## Prerequisites

- [06-INTERNET-AND-WEB-FOUNDATIONS](../06-INTERNET-AND-WEB-FOUNDATIONS/README.md) — HTTP, TLS, and
  the browser's security model.
- [11-BACKEND-ENGINEERING](../11-BACKEND-ENGINEERING/README.md) — the API you will harden.
- [14-TESTING-AND-QUALITY](../14-TESTING-AND-QUALITY/README.md) — proving controls with tests.

## Lessons

- `security-fundamentals.md` · `threat-modeling.md` · `password-security.md`
- `session-security.md` · `access-control.md`
- `injection-vulnerabilities.md` · `cross-site-scripting.md` · `csrf.md` · `ssrf.md`
- `secure-api-design.md` · `secrets-management.md` · `dependency-security.md`
- `tls-and-certificates.md` · `secure-file-uploads.md`
- `security-testing-labs/` — authorized local practice environments

## Exercises and practice

Each vulnerability lesson follows the same drill in the labs: exploit the vulnerable version
locally, write the failing test, fix the code, watch the test pass, and record the control in your
project's security checklist. Design exercises include writing a threat model for your own Project
04/05 and a secrets audit of a repository using the checklist from `secrets-management.md`.

## Expected outcomes

You can produce a threat model for a new feature; implement and test password, session, and access
control correctly; demonstrate each major vulnerability class locally and then demonstrate its fix;
and review a codebase for the common failures with a repeatable checklist.

## Common blockers

- **"We'll do security later."** Retrofitting authorization and validation is the most expensive
  version of both.
- **Client-side trust.** Anything enforced only in the browser is not enforced.
- **Security as magic words.** Every lesson here is a concrete mechanism with a concrete test; if
  you cannot test it, you do not yet understand it.

## Next

[16-DEVOPS-AND-INFRASTRUCTURE](../16-DEVOPS-AND-INFRASTRUCTURE/README.md) — ship it: containers,
pipelines, and the operations side of software.