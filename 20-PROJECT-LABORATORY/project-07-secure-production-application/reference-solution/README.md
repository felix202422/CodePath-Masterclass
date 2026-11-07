# Reference solution guide — Project 07

> **Stop.** Deploy the app and break it once before reading this. A rollback you have performed teaches
> more than a page of advice about rollbacks.

One defensible production shape, with the evidence that makes each claim checkable.

## Platform choice

Three viable shapes, and the guide's order of preference for a solo engineer:

| Shape | Operates | Fails at | Best when |
|---|---|---|---|
| PaaS (Fly, Render, App Runner) | Almost nothing | Custom networking, long-lived connections | You want to learn observability, not servers |
| Managed containers (ECS, Cloud Run) with managed Postgres | Images, IAM, networking | IAM and VPC debugging | You want cloud literacy with a safety net |
| Single VM with compose | Everything | Patching, disk, failover, your weekend | The learning goal is operations itself |

The guide uses **managed containers plus managed Postgres**. The database is the part where self-hosting
buys nothing and costs the most sleep; the application container is where the interesting work is. Write
the ADR with the constraint that would change your mind — a compliance rule, a latency budget, or a
provider bill.

## Deployment with a real rollback

The sequence, which is the whole of `FR-3`:

```text
1. build image, push by digest (not tag)
2. run migrations (expand step only, compatible with the running version)
3. start new revision with 0% traffic
4. poll /health/ready three times, 5 s apart
5. shift 10% traffic, watch error rate for 2 minutes
6. shift 100%, keep the previous revision warm for 15 minutes
7. any failure at 4-6: shift traffic back, mark deployment failed, page the channel
```

Step 2 is where zero-downtime usually dies. Adding a `NOT NULL` column in one migration breaks the old
revision still serving traffic. Expand/contract splits it: add the nullable column and backfill in release
N, enforce it in release N+1. That discipline is why `NFR-2` and `NFR-7` are in the same project.

The pipeline stores the image digest in the `deployments` row, so "what is running" is answered by a
query rather than by memory. `/version` exposes the same digest, which makes the external probe able to
detect a deploy that silently did not happen.

## Health endpoints that do not cause outages

```python
@app.get("/health/live")
def live():
    return {"status": "ok"}                       # no I/O at all

@app.get("/health/ready")
def ready(db, migrate):
    if not db.ping(timeout=1):                     # short timeout, no retry storm
        return JSONResponse({"status": "db"}, status_code=503)
    if migrate.current() != migrate.head():
        return JSONResponse({"status": "migrations"}, status_code=503)
    return {"status": "ok"}
```

Liveness must not touch the database. If it does, a 30-second database failover restarts every app
instance, and the restart storm makes the failover a full outage. This is the single most common
production mistake in this project and it is worth a test: stop the database, assert `/health/live` is
still 200 and `/health/ready` is 503.

Readiness checks migrations because a deploy that skipped them serves a schema it does not understand.

## Threat model that is actually used

STRIDE over the deployed diagram, one row per threat, with the control named:

| Threat | Example | Control | Where |
|---|---|---|---|
| Spoofing | Stolen session cookie | HttpOnly, Secure, rotation, 30-min idle | `auth/session.py` |
| Tampering | Client sets `role` in signup JSON | DTO allowlist, server assigns role | `api/users.py` |
| Repudiation | Admin deletes a record | `audit_events` append-only | migration 0007 |
| Information disclosure | Stack trace in 500 | `include-stacktrace=never`, problem+json | `error_handlers.py` |
| Denial of service | 10k sign-in attempts | Edge rate limit + per-account lockout | `waf.tf`, `auth/limiter.py` |
| Elevation of privilege | Volunteer calls admin route | Role check in service + test | `shifts/service.py` |

The value is the "Where" column. A threat model with no file references is a document nobody updates;
one that points at a control can be checked in review, and when the control moves, the diff is visible.

Residual risks get named too — for example "the WAF does not stop a distributed credential-stuffing
attack with residential proxies; mitigated by lockout and breached-password checks, accepted for now."
An unstated residual risk is the one that becomes an incident report.

## SLO, alerts and the budget policy

```text
SLI:   proportion of /api requests that are not 5xx AND complete in < 500 ms
SLO:   99.5% over a rolling 28 days
Budget: 0.5% of ~2.6M requests = ~13,000 failed or slow requests per 28 days
Alert:  burn rate > 14.4x over 1 h (2% of budget in an hour) -> page
        burn rate > 6x over 6 h                        -> ticket
```

Two windows, one page condition. The fast burn catches an outage; the slow burn catches a regression
that a single hour would hide. Alerting on CPU instead of on the SLI is the mistake this design avoids:
CPU at 90% with a healthy service is not an incident, and a 40% error rate at 20% CPU is.

The budget policy is a sentence with consequences: "when 50% of the budget is spent, feature work pauses
until reliability work restores it; when 100% is spent, only reliability changes ship." Write it, put it
in `slo.md`, and apply it once in a simulated review. `AC-9` is about the policy existing, not about the
maths being perfect.

## The restore drill

The script is twenty lines and the drill is the deliverable:

```bash
#!/usr/bin/env bash
set -euo pipefail
STAMP=$(date -u +%Y%m%dT%H%M%SZ)
pg_dump --format=custom --no-owner "$DATABASE_URL" > "/tmp/app-$STAMP.dump"
aws s3 cp "/tmp/app-$STAMP.dump" "s3://$BUCKET/db/$STAMP.dump" --sse aws:kms
# weekly, and before every risky migration:
#   createdb restore_test && pg_restore --no-owner -d restore_test "$DUMP"
#   psql restore_test -c "select count(*) from users"   # expect the known number
```

Record the drill in `docs/restore-<date>.md`: dump size, restore duration, row counts compared,
discrepancies, who ran it. An RTO of 1 hour is a claim until the drill measures 34 minutes.

Backups live in a different account or region from the database, with their own retention. A backup in
the same account as the database is deleted by the same mistake.

## Load test that finds the bottleneck

k6 with a scenario that matches the real mix — mostly reads, a few writes:

```js
export const options = {
  scenarios: {
    steady: { executor: "constant-arrival-rate", rate: 150, timeUnit: "1s",
              duration: "10m", preAllocatedVUs: 100 },
  },
  thresholds: { http_req_duration: ["p(95)<300", "p(99)<800"], http_req_failed: ["rate<0.005"] },
};
```

150 rps is 3× a plausible peak for a small app. The report must name the first bottleneck: connection
pool exhaustion (`waiting for a connection` in logs), a missing index (`EXPLAIN` shows a seq scan at
50k rows), or a single-threaded worker. "It handled it" without a p99 curve and a saturation graph does
not satisfy `AC-11`.

Do not run this against production without a way to stop it, and do not run it from the same network as
the health probe unless you want the probe to page you.

## Incident exercise

Pick one and actually do it, in staging:

1. **Database unavailable for 60 seconds.** Expected: readiness fails, the platform does not restart the
   app, the error page is calm, the page fires once, recovery is automatic.
2. **Bad deploy.** Expected: rollback in under five minutes, `deployments` row marked failed, no data
   lost.
3. **Secret rotation.** Expected: new credential deployed, old one revoked, no downtime.

Write the post-incident review in blameless form: timeline, impact in user terms, what went well, what
did not, action items with owners and dates. The review of a simulated incident is the rehearsal for a
real one, and reviewers weight it heavily because it shows how you think under failure.

## Cost

A small app on managed containers plus managed Postgres is roughly: compute $15–40, database $15–30,
egress $1–10, observability $0–20 depending on retention, backups $1–5. The dominant line is usually the
database, and the first lever is not instance size but retention and connection pooling. The README
states the estimate, the actual bill after a week, and the one change you would make at 10× traffic
(usually a read replica, sometimes a queue).

## Trade-offs and alternatives

- **PaaS versus Kubernetes.** Kubernetes teaches a lot and costs a lot; at this size it is a second
  project. PaaS passes every criterion here and leaves attention for observability and security.
- **Blue-green versus canary.** Blue-green is simpler and binary; canary catches partial failures and
  needs traffic splitting and analysis. The guide uses canary at 10% because `FR-3` is about detection,
  not just switching.
- **Self-hosted observability versus hosted.** Self-hosted is cheaper at volume and is another service to
  run; hosted has a free tier that covers this project. Choose hosted; spend the saved time on the
  runbook.
- **Single region versus multi-region.** Single region with tested backups meets `NFR-4`; multi-region
  adds consistency questions the app is not designed for.
- **Feature flags versus redeploys.** Flags decouple deploy from release and add state to reason about.
  One flag for the risky path is enough here; a flag for everything is a second product.

## What is deliberately missing

Terraform modules, pipeline YAML and dashboard JSON. They are provider-specific and mechanical once the
gates and the SLO are decided. The decisions above — what to manage, how to roll back, what to alert on,
what evidence to keep — are what a reviewer interrogates.
