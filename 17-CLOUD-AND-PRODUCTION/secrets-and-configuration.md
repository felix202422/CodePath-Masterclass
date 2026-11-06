# Secrets and Configuration

> **Lab host:** Windows 11, Python 3.13.5. The transcript in section 7 was executed on that host
> from the probe source embedded there; the probe implements configuration layering, redaction, a
> credential scanner, HMAC token rotation with a real verification step, and entropy arithmetic.
> Creating a secret in a provider vault, configuring automatic rotation and reading an audit log of
> secret access are **labelled reference**: no cloud account exists on this host.

## 1. Learning Objectives

After this lesson you will be able to:

- [ ] Resolve a configuration value through layers and predict which layer wins
- [ ] Redact a configuration dump so that no value leaks into logs
- [ ] Measure a secret scanner's precision and recall against a labelled corpus
- [ ] Rotate a signing key with an overlap window and prove no live token is rejected
- [ ] Distinguish high-entropy secrets from low-entropy ones, and choose a generation method

## 2. Prerequisites

- [identity-and-access-management.md](identity-and-access-management.md) — who may read a secret in the first place
- [15-APPLICATION-SECURITY/secrets-management.md](../15-APPLICATION-SECURITY/secrets-management.md)
  — the application-security view of credential handling
- [11-BACKEND-ENGINEERING/sessions-and-tokens.md](../11-BACKEND-ENGINEERING/sessions-and-tokens.md)
  — tokens and signatures, which rotation has to preserve
- [15-APPLICATION-SECURITY/password-security.md](../15-APPLICATION-SECURITY/password-security.md)
  — hashing and guessing rates

## 3. Introduction

A secret is a value whose disclosure grants access: a database password, an API key, a session
signing key, a TLS private key. Everything else in this subject is about limiting *who* can do
*what*; this lesson is about the values that make the limit irrelevant once they leak.

Secrets fail in four distinct ways, and each needs a different control:

1. **They are stored in the wrong place** — committed to git, baked into an image, pasted into a
   ticket. The control is a secret store plus scanning at write time.
2. **They are exposed at runtime** — dumped in an error page, logged in a request header, printed
   by a debug endpoint. The control is redaction, applied centrally.
3. **They are too weak** — `hunter2`, a six-digit SMS code, a token signed with `secret`. The
   control is generation from a cryptographic source with a stated entropy budget.
4. **They cannot be changed** — the same key for three years, so a leak is permanent. The control
   is rotation with overlap, which is a *design* property, not an operational one.

This lesson covers all four with executable mechanisms, because "use a vault" is advice, not a
procedure.

## 4. The Problem It Solves

Configuration and secrets look alike — both are key-value strings provided at deploy time — and
treating them alike is how secrets end up in `docker-compose.yml` in a public repository.

The separation that works:

- **Configuration is not secret.** `PORT`, `LOG_LEVEL`, `APP_ENV` belong in a config file, an
  environment variable, or a feature-flag service, and should be readable by anyone on the team.
- **Secrets are values with an audience.** A database password is readable by one service; a
  payment provider key by one service and one rotation job.

A secret manager solves the distribution problem (how does the value reach the process without
being in the artifact?), the rotation problem (how do I change it without an outage?) and the audit
problem (who read it, when?). It does not solve the code problem: `print(os.environ)` still prints
everything.

## 5. Core Concepts

### Layering and precedence

Configuration arrives from several layers: defaults in code, a `.env` file, real environment
variables, and possibly a remote config service. A deterministic precedence order is what makes the
result predictable. The probe uses `defaults < .env < environment`, merges six keys, and shows
`APP_ENV` resolving to `production` because the environment layer wins over `.env`'s `staging`.

Precedence without validation is still unsafe: a missing required key must fail at startup, not at
the first request that needs it. The probe reports exactly one validation error,
`DATABASE_URL is required but has no value in any layer`, which is the shape of a good startup
failure.

### Redaction is a property of the dump, not of discipline

Every application eventually logs its configuration — on startup, in a diagnostics endpoint, in an
error report. Redaction must therefore be applied where the dump is produced, by key name, with an
allow-list where possible.

The probe compares a naive dump (137 characters, three secret values exposed) with a redacted one
where `DB_PASSWORD`, `STRIPE_API_KEY` and `SESSION_SECRET` appear as `***`. The check is
mechanical: `DB_PASSWORD present in naive dump: True; in redacted: False`.

### Scanning: precision and recall, measured

A secret scanner is a classifier with the usual two failure modes: false positives (a hash that
looks like a key) and false negatives (a real key with an unusual shape). Both are measurable
against a labelled corpus.

The probe scans ten lines of which five contain a secret: five true positives, zero false
positives, zero false negatives — precision and recall both 100%. It also notes that a SHA-256
checksum line is not flagged, because a digest is not a credential. That distinction is the
hardest part of writing the rules.

### Rotation needs an overlap window

If a signing key is replaced instantly, every token signed with the old key becomes invalid at the
same moment: the probe rejects 400 of 400 live tokens. With a 24-hour overlap, where both keys
verify but only the new one signs, zero of 400 live tokens are rejected.

The mechanism is a key set rather than a key: verification tries every active key, signing uses the
newest. That is exactly how JWT `kid` headers and TLS certificate chains work, and it is why
rotation is a design property — an application that stores one HMAC secret in a constant cannot
rotate without downtime.

### Entropy, and where guessing rates come from

`secrets.token_urlsafe(32)` produces 43 characters and 256 bits of entropy, drawn from 64 symbols.
At an offline guess rate of 10^10 per second, exhaustion takes about 3.7 × 10^59 years. A
six-digit SMS code is a million values; at 10,000 guesses per minute it is exhausted in two
minutes, which is why it needs a rate limit and an attempt counter, not more digits.

`hunter2` is 21 bits if you pretend it is random; as a dictionary word it is far less — one lookup.
Entropy only describes the generator, never the string.

## 6. How It Works

```mermaid
flowchart LR
    D[Defaults in code] --> M[Merge by precedence]
    E[.env file] --> M
    V[Environment] --> M
    S[Secret manager] --> M
    M --> VAL{Validation}
    VAL -->|missing required| FAIL[Fail fast at startup]
    VAL -->|ok| APP[Application config]
    APP -->|redacted| LOG[Logs and diagnostics]
```

The secret manager is one layer among several, not a replacement for the others: it supplies the
values that must not live in the repository, while defaults and environment still supply the rest.
Validation runs after the merge, so a missing secret is caught before the process accepts traffic.

At runtime, rotation happens underneath the application: the manager issues a new version, the
application reloads the key set, and old tokens remain verifiable until the overlap expires.

## 7. Practical Examples

**Example 1 — layering, redaction, scanning, rotation and entropy**

The probe merges three configuration layers and validates them, compares a naive dump with a
redacted one, scores a scanner against a labelled corpus, rotates an HMAC key with and without
overlap while verifying real tokens, and computes entropy for three generation methods.

```python
"""CLD-08 probe: config layering, secret scanning, rotation overlap and token strength.

Windows 11, Python 3.13.5. Everything here executes locally: layered configuration with
precedence and redaction, a scanner run over a labelled corpus of log lines so precision and
recall are measured rather than asserted, HMAC token rotation with a real overlap window, and
entropy arithmetic for generated tokens. There is no secret manager on this host; the
provider steps in the lesson are labelled reference.
"""

from __future__ import annotations

import hashlib
import hmac
import re
import secrets
import string
from dataclasses import dataclass

SECRET_NAME = re.compile(r"(SECRET|TOKEN|PASSWORD|PRIVATE_KEY|API_KEY)$", re.IGNORECASE)

DEFAULTS = {"APP_ENV": "development", "PORT": "8080", "LOG_LEVEL": "info"}
DOTENV = """
APP_ENV=staging
PORT=not-a-number
DB_PASSWORD=hunter2
STRIPE_API_KEY=sk_live_51H8xQ2example
""".strip()
ENVIRON = {"APP_ENV": "production", "PORT": "9090", "SESSION_SECRET": "s3cr3t-from-env"}


def load_config(defaults: dict[str, str], dotenv: str, environ: dict[str, str]) -> dict[str, str]:
    merged = dict(defaults)
    for line in dotenv.splitlines():
        if line and not line.startswith("#") and "=" in line:
            key, value = line.split("=", 1)
            merged[key.strip()] = value.strip()
    merged.update(environ)
    return merged


def validate(config: dict[str, str], required: list[str]) -> list[str]:
    errors = []
    for key in required:
        if key not in config:
            errors.append(f"{key} is required but has no value in any layer")
            continue
        if SECRET_NAME.search(key) and config[key] in ("", "changeme", "hunter2"):
            errors.append(f"{key} holds a placeholder value")
    if "PORT" in config:
        try:
            int(config["PORT"])
        except ValueError:
            errors.append(f"PORT={config['PORT']!r} is not an integer")
    return errors


def redact(config: dict[str, str]) -> dict[str, str]:
    return {k: ("***" if SECRET_NAME.search(k) else v) for k, v in config.items()}


SCANNER = [
    ("aws-access-key", re.compile(r"\b(AKIA|ASIA)[0-9A-Z]{16}\b")),
    ("private-key", re.compile(r"-----BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY-----")),
    ("jwt", re.compile(r"\beyJ[A-Za-z0-9_-]{8,}\.[A-Za-z0-9_-]{8,}\.[A-Za-z0-9_-]{8,}\b")),
    ("stripe-live", re.compile(r"\bsk_live_[0-9A-Za-z]{10,}\b")),
    ("slack-token", re.compile(r"\bxox[baprs]-[0-9A-Za-z-]{10,}\b")),
]


def scan(line: str) -> list[str]:
    return [name for name, pattern in SCANNER if pattern.search(line)]


CORPUS = [
    ("2026-03-01T10:00:00Z INFO startup complete in 412ms", False),
    ("2026-03-01T10:00:01Z DEBUG auth header Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxIn0.abc123def456", True),
    ("2026-03-01T10:00:02Z ERROR db connect failed: password authentication failed", False),
    ("2026-03-01T10:00:03Z DEBUG aws key AKIAIOSFODNN7EXAMPLE loaded from env", True),
    ("2026-03-01T10:00:04Z INFO upload checksum sha256=9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08", False),
    ("2026-03-01T10:00:05Z DEBUG stripe sk_live_51H8xQ2lab0 sent", True),
    ("2026-03-01T10:00:06Z INFO user 8842 logged in from 203.0.113.9", False),
    ("2026-03-01T10:00:07Z TRACE -----BEGIN OPENSSH PRIVATE KEY----- b3BlbnNzaC1rZXk", True),
    ("2026-03-01T10:00:08Z WARN cache miss for key session:8842 ttl=300", False),
    ("2026-03-01T10:00:09Z DEBUG slack xoxb-2451-8821-AbCdEfGhIjKl webhook delivered", True),
]


def issue(secret: bytes, user: str, issued_at: int, ttl: int = 3600) -> str:
    payload = f"{user}.{issued_at + ttl}"
    mac = hmac.new(secret, payload.encode(), hashlib.sha256).hexdigest()[:32]
    return f"{payload}.{mac}"


def verify(token: str, keys: list[bytes], now: int) -> str:
    try:
        user, expiry, mac = token.rsplit(".", 2)
    except ValueError:
        return "malformed"
    if int(expiry) < now:
        return "expired"
    for position, key in enumerate(keys):
        expected = hmac.new(key, f"{user}.{expiry}".encode(), hashlib.sha256).hexdigest()[:32]
        if hmac.compare_digest(mac, expected):
            return "valid" if position == 0 else "valid-on-old-key"
    return "bad-signature"


def main() -> None:
    print("=== layered configuration, precedence and validation ===")
    config = load_config(DEFAULTS, DOTENV, ENVIRON)
    errors = validate(config, ["APP_ENV", "PORT", "DATABASE_URL", "SESSION_SECRET"])
    print(f"  layers merged: defaults < .env < environment, {len(config)} keys")
    print(f"  APP_ENV resolved to {config['APP_ENV']!r} (environment wins over .env staging)")
    print(f"  PORT resolved to {config['PORT']!r}")
    print(f"  validation errors: {len(errors)}")
    for error in errors:
        print(f"    - {error}")

    print("\n=== config dump redaction ===")
    naive = ", ".join(f"{k}={v}" for k, v in config.items())
    safe = ", ".join(f"{k}={v}" for k, v in redact(config).items())
    leaked = sum(1 for k in config if SECRET_NAME.search(k) and k in naive)
    print(f"  naive dump length {len(naive)}, values exposed: {leaked}")
    print(f"  redacted dump: {safe}")
    print(f"  DB_PASSWORD present in naive dump: {'hunter2' in naive}; in redacted: "
          f"{'hunter2' in safe}")

    print("\n=== scanner measured against a labelled corpus ===")
    true_pos = false_pos = false_neg = 0
    for line, is_secret in CORPUS:
        hits = scan(line)
        if hits and is_secret:
            true_pos += 1
        elif hits and not is_secret:
            false_pos += 1
        elif not hits and is_secret:
            false_neg += 1
    precision = true_pos / max(1, true_pos + false_pos)
    recall = true_pos / max(1, true_pos + false_neg)
    print(f"  {len(CORPUS)} lines, {sum(1 for _, s in CORPUS if s)} contain a secret")
    print(f"  true positives {true_pos}, false positives {false_pos}, false negatives {false_neg}")
    print(f"  precision {precision:.0%}, recall {recall:.0%}")
    print(f"  the sha256 checksum line is not flagged: digests are not credentials")

    print("\n=== rotation with an overlap window (real HMAC verification) ===")
    old_key, new_key = secrets.token_bytes(32), secrets.token_bytes(32)
    rotate_at = 24 * 3600
    tokens = [(issue(old_key, f"user{i}", issued_at), issued_at) for i in range(200)
              for issued_at in (rotate_at - 1800, rotate_at + 1800)]
    now = rotate_at + 60
    for overlap_h, label in ((0, "no overlap"), (24, "24 h overlap")):
        keys = [new_key, old_key] if overlap_h else [new_key]
        rejected = sum(1 for token, _ in tokens
                       if verify(token, keys, now) not in ("valid", "valid-on-old-key"))
        print(f"  {label:<12}: {rejected} of {len(tokens)} live tokens rejected")
    sample = tokens[0][0]
    print(f"  token shape: {len(sample.split('.'))} segments, mac "
          f"{len(sample.rsplit('.', 1)[1])} hex chars")
    print(f"  timing-safe compare via hmac.compare_digest, not ==")

    print("\n=== generated secret strength ===")
    token = secrets.token_urlsafe(32)
    alphabet = string.ascii_letters + string.digits + "-_"
    bits = 32 * 8
    print(f"  token_urlsafe(32): {len(token)} chars, {bits} bits of entropy, "
          f"drawn from {len(alphabet)} symbols")
    print(f"  offline guess rate 1e10/s -> {2 ** bits / 1e10 / 3.15e7:.1e} years to exhaust")
    digits = 6
    print(f"  compared with a {digits}-digit SMS code: {10 ** digits} values, "
          f"{10 ** digits / 1e4 / 60:.0f} min to exhaust at 10k guesses/min -> rate limit it")
    print(f"  entropy of the .env value 'hunter2': "
          f"{len('hunter2') * 3:.0f} bits if truly random, far less as a dictionary word")


if __name__ == "__main__":
    main()
```

- `merge` applies layers in order, so precedence is data rather than convention.
- `redact` walks keys and replaces matches, which is why the check can assert absence.
- The scanner returns `(tp, fp, fn)` counts from a fixed corpus, so precision and recall are
  arithmetic rather than opinion.
- Rotation signs tokens with the new key and verifies against the full set; `hmac.compare_digest`
  is used so the comparison does not leak timing.

**Expected output** (executed on Windows 11, Python 3.13.5, exit code 0):

```text
=== layered configuration, precedence and validation ===
  layers merged: defaults < .env < environment, 6 keys
  APP_ENV resolved to 'production' (environment wins over .env staging)
  PORT resolved to '9090'
  validation errors: 1
    - DATABASE_URL is required but has no value in any layer

=== config dump redaction ===
  naive dump length 137, values exposed: 3
  redacted dump: APP_ENV=production, PORT=9090, LOG_LEVEL=info, DB_PASSWORD=***, STRIPE_API_KEY=***, SESSION_SECRET=***
  DB_PASSWORD present in naive dump: True; in redacted: False

=== scanner measured against a labelled corpus ===
  10 lines, 5 contain a secret
  true positives 5, false positives 0, false negatives 0
  precision 100%, recall 100%
  the sha256 checksum line is not flagged: digests are not credentials
```

Rotation and entropy:

```text
=== rotation with an overlap window (real HMAC verification) ===
  no overlap  : 400 of 400 live tokens rejected
  24 h overlap: 0 of 400 live tokens rejected
  token shape: 3 segments, mac 32 hex chars
  timing-safe compare via hmac.compare_digest, not ==

=== generated secret strength ===
  token_urlsafe(32): 43 chars, 256 bits of entropy, drawn from 64 symbols
  offline guess rate 1e10/s -> 3.7e+59 years to exhaust
  compared with a 6-digit SMS code: 1000000 values, 2 min to exhaust at 10k guesses/min -> rate limit it
  entropy of the .env value 'hunter2': 21 bits if truly random, far less as a dictionary word
```

- **How to run it:** save the block as `secrets_probe.py` and run `python secrets_probe.py`.
  Standard library only; `hmac` and `secrets` do the cryptographic work.
- **What to read in the output:** `400 of 400` versus `0 of 400`. Rotation without overlap is an
  outage; the overlap window is the entire design.
- `DB_PASSWORD present in naive dump: True; in redacted: False` is the assertion form of a
  redaction control. If it cannot be asserted, it will regress.
- The scanner's 100%/100% is only meaningful because the corpus has both positives and negatives;
  a scanner that flags everything scores 100% recall and terrible precision.

**Example 2 — the startup check that fails loudly**

Plain code, **labelled reference** (illustrative, not part of the probe):

```python
REQUIRED = ("DATABASE_URL", "SESSION_SECRET", "STRIPE_API_KEY")
missing = [k for k in REQUIRED if not config.get(k)]
if missing:
    raise SystemExit(f"missing required configuration: {', '.join(missing)}")
```

Failing at startup with the names of the missing keys is better than a `None` that reaches a query
builder. Note it prints key names, never values.

## 8. Real-World Applications

- **Container platforms** inject secrets as ephemeral files or environment variables from a store,
  never baking them into the image layer.
- **CI systems** hold a deploy key with the narrowest role that can push, and rotate it on a
  schedule; a CI secret is the highest-value credential most teams own.
- **Payment and messaging providers** issue per-environment keys with restricted scopes, so a
  leaked test key is not a production incident.
- **Session signing keys** live in a key set with a `kid`, which is what makes zero-downtime
  rotation possible.

The pairing that matters is with [docker images](../16-DEVOPS-AND-INFRASTRUCTURE/docker-images-and-containers.md):
a secret in a layer is in every registry copy forever, because layers are content-addressed and
pushed.

## 9. Common Mistakes

| Mistake | Why it happens | How to recognize it | How to prevent it |
|---|---|---|---|
| Secret committed to git | Fastest way to share it | `git log -S` finds the value | Pre-commit scanning; rotate on discovery, do not just delete |
| `print(os.environ)` on startup | Debugging convenience | A 137-character dump with three values | Central redaction with an allow-list |
| Scanner that flags every hash | Regex too broad | Constant false positives, team ignores it | Labelled corpus and measured precision |
| Rotation with no overlap | Simpler to implement | Every session invalidated at deploy | Key set with verify-all, sign-newest |
| Six-digit codes without rate limits | It is "two-factor" | 10,000 guesses/min exhausts it | Attempt limits, lockout, longer codes |
| Same key in all environments | One config file | Test key works in production | Per-environment secrets from the start |

## 10. Best Practices

- **Separate configuration from secrets by audience**, not by file. If it is in `docker-compose.yml`,
  it is configuration.
- **Fail fast on missing required values**, naming the keys and never the values.
- **Redact centrally and assert the redaction** in a test.
- **Rotate with overlap**, and rehearse the rotation before you need it in a hurry.
- **Generate with `secrets`, not `random`**, and state an entropy budget for anything a human
  types.
- **Scan at commit time and at build time**, and treat a hit as an incident with a rotation step.

## 11. Limitations and Trade-Offs

A secret manager adds a runtime dependency: if it is unreachable, the process cannot start. Caching
with a short TTL is the usual compromise, and it slightly widens the window in which a revoked
secret still works.

Rotation is cheap for stateless tokens and expensive for anything with a stored credential on the
other side — a third-party API key often cannot have two valid values at once, so rotation there
is a coordinated change window, not a rolling one.

Scanning has an irreducible error rate. A scanner tuned to zero false negatives will flag test
fixtures; a scanner tuned to zero false positives will miss unusual key formats. Pick the trade-off
deliberately and measure it.

Entropy does not survive bad handling: a 256-bit key pasted into a chat window is a 256-bit key
that has leaked. Length is the cheapest control, not the only one.

## 12. Practical Exercises

### Introductory

1. **Exercise 8.1** — Given the layers in the probe, what does `LOG_LEVEL` resolve to if `.env` sets
   `debug` and the environment sets `info`? State the rule you applied.
   **Completion criteria:** `info`, because the environment layer is applied last and wins.

2. **Exercise 8.2** — Write the four-line redaction check for a new key `SMTP_PASSWORD` and say
   what it would catch that a code review might not.
   **Completion criteria:** an assertion that the key is absent from the redacted dump, catching a
   future dump path that forgets the allow-list.

### Intermediate

3. **Exercise 8.3** — A scanner reports 40 true positives, 10 false positives and 5 false negatives.
   Compute precision and recall, and say which error is worse for a pre-commit hook.
   **Completion criteria:** precision 80%, recall 89%; false negatives are worse, because a missed
   key ships.

4. **Exercise 8.4** — A session key signs 50,000 tokens per day with a 7-day lifetime. You rotate
   with a 24-hour overlap. How many tokens stop verifying, and what overlap would be needed for
   zero logouts?
   **Completion criteria:** at the moment of rotation, zero of the 400 live tokens are rejected
   (the probe's result); but once the old key leaves the set after 24 hours, every token still
   inside its 7-day lifetime that was signed with it stops verifying — roughly 300,000 tokens if
   issuance is uniform. A zero-logout rotation therefore needs an overlap of at least the token
   lifetime, 7 days, or a forced re-authentication that is acceptable to the product.

### Independent problem-solving

5. **Exercise 8.5** — Design the secret lifecycle for a service with a database password, a
   third-party API key and a session signing key. For each: where it is stored, who can read it,
   how it is rotated, what breaks during rotation and how you would detect a leak.
   **Completion criteria:** three rows with storage location, audience, rotation mechanism and
   blast radius. The session key uses a key set with overlap; the third-party key names a
   coordinated window; the database password names a dual-credential or pooler-assisted approach.
   A detection step exists for each, such as a scanner hit, an anomalous access log entry, or a
   provider notification.

*Solutions: attempt first. They live in `solutions/` of this subject.*

## 13. Knowledge Check

1. Why must validation run after every configuration layer is merged?
2. What does a 24-hour overlap window protect, and what does it not?
3. Why is `hunter2` described as 21 bits but weaker in practice?
4. What makes a hash line a false positive for a secret scanner, and how do you avoid it?
5. Why is a secret baked into a container image unrecoverable once pushed?

## 14. Completion Criteria

- [ ] You can resolve layered configuration and predict the winning value
- [ ] You can produce a redacted dump and assert that secrets are absent
- [ ] You can compute precision and recall for a scanner
- [ ] You can rotate a signing key without invalidating live tokens
- [ ] You can state the entropy of a generated secret and of a human-chosen one

## 15. Summary

- Configuration and secrets differ by audience, not by file format.
- Precedence must be explicit, and validation must run after the merge and fail fast.
- Redaction belongs at the dump site and must be asserted by a test.
- Scanners are classifiers: measure precision and recall on a labelled corpus.
- Rotation needs an overlap window; a single stored HMAC constant cannot rotate.
- Entropy describes a generator; a dictionary word has none in practice.

## 16. Next Steps

- Next lesson: [Load Balancing](load-balancing.md) — distributing traffic across the instances that
  hold these secrets, and why the algorithm changes the tail latency.
- Practice: add a redaction assertion to a service you own and run it.
- Where it is applied: [secrets management](../15-APPLICATION-SECURITY/secrets-management.md) covers
  the threat model, and [sessions and tokens](../11-BACKEND-ENGINEERING/sessions-and-tokens.md)
  covers the token design rotation must preserve.
