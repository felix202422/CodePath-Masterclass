# 16 — DevOps and Infrastructure

Software that cannot be deployed and operated is a prototype. This subject covers the whole path
from "it runs on my machine" to "it runs reliably in production": Linux operations, shell scripting,
Docker, Compose, Nginx, TLS/DNS operations, infrastructure as code, CI/CD with GitHub Actions,
deployment strategies, monitoring, and backups.

## What this subject covers

- DevOps fundamentals: the culture, the feedback loops, and why "ops" belongs to developers now.
- Linux administration: users, permissions, services, systemd, and logs — the operating system your
  servers actually run.
- Networking for DevOps: ports, firewalls, load balancers, and diagnosing connectivity.
- Shell scripting: automation that outlives the copy-pasted command.
- Docker fundamentals: images, containers, registries, and the container mental model.
- Docker images and containers: writing Dockerfiles that produce small, reproducible, non-root images.
- Container networking: how containers find each other and the outside world.
- Volumes and persistence: what survives a container's death, and what must.
- Docker Compose: multi-service environments defined as code.
- Nginx and reverse proxies: routing, static serving, TLS termination.
- DNS and TLS operations: records, certificates, and renewal that does not expire at 3 a.m.
- Infrastructure as Code: why snowflake servers fail.
- Terraform: planning, applying, and state.
- Ansible: configuration management and idempotence.
- CI/CD fundamentals: the pipeline as a quality and delivery contract.
- GitHub Actions: workflows that build, test, and publish your project.
- Deployment strategies: rolling, blue-green, canary, and rollback.
- Monitoring and logging: metrics, logs, traces, and alerts worth acting on.
- Backups and recovery: schedules, retention, and restore drills.

## Why it matters

The gap between "works locally" and "runs in production" is where most student projects die and
where most professional effort is spent. These skills are also the highest-leverage career
multiplier in this curriculum: engineers who can deploy and operate what they build are
dramatically more valuable than those who cannot. The subject comes after backend and security so
you have something real to operate and something worth protecting.

## Prerequisites

- [03-DEVELOPER-TOOLS](../03-DEVELOPER-TOOLS/README.md) — terminal fluency and Git.
- [11-BACKEND-ENGINEERING](../11-BACKEND-ENGINEERING/README.md) — the application you will package
  and pipeline.
- [15-APPLICATION-SECURITY](../15-APPLICATION-SECURITY/README.md) — secrets handling and hardening
  before deployment.

## Lessons

Docker Engine 29.x, `ubuntu-24.04` runners, `actions/checkout@v7`, `actions/setup-java@v6`,
Terraform 1.16.x, Ansible core 2.21.x, NGINX stable 1.30.x — all pinned in
[VERSIONS.md](../VERSIONS.md).

- `devops-fundamentals.md` · `linux-administration.md` · `networking-for-devops.md`
- `shell-scripting.md`
- `docker-fundamentals.md` · `docker-images-and-containers.md` · `container-networking.md`
- `volumes-and-persistence.md` · `docker-compose.md`
- `nginx-and-reverse-proxies.md` · `dns-and-tls-operations.md`
- `infrastructure-as-code.md` · `terraform.md` · `ansible.md`
- `ci-cd-fundamentals.md` · `github-actions.md` · `deployment-strategies.md`
- `monitoring-and-logging.md` · `backups-and-recovery.md`
- `troubleshooting/` — operational failure playbooks with diagnosis procedures

## Exercises and practice

Everything here is hands-on: containerize the subject 11 API; build a Compose stack with app,
database, and reverse proxy; write a GitHub Actions workflow that runs your test suite and fails
when a test fails; write a Terraform plan for a small environment; perform a **restore drill** from
a backup you created. Common-failure exercises use `troubleshooting/`: a container that will not
start, a volume that lost data, a pipeline that passes while deploying nothing.

## Expected outcomes

You can take an application from local to containerized to pipelined to deployed, with a health
check, a rollback path, logs you can read, and a backup you have actually restored once.

## Common blockers

- **"Works on my machine".** The lesson is the fix: identical environments by construction.
- **Secrets in Git.** Environment variables and secret stores only; the checklist in
  `secrets-management.md` is how you verify.
- **Alerts nobody reads.** An alert without an owner and a runbook is noise.
- **Backups without drills.** A backup you have never restored is a hypothesis.

## Next

[17-CLOUD-AND-PRODUCTION](../17-CLOUD-AND-PRODUCTION/README.md) — the platform layer: VMs,
networking, IAM, load balancing, scaling, observability, incidents, and cost.