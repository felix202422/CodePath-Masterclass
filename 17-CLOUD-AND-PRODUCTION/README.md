# 17 — Cloud and Production

This subject covers the platform your software runs on: compute, networking, storage, identity,
scaling, observability, incidents, and the bill — taught cloud-agnostically with provider-neutral
concepts and concrete examples.

## What this subject covers

- Cloud computing fundamentals: service models, regions, availability zones, and the shared
  responsibility line.
- Virtual machines: the compute primitive everything else abstracts.
- Cloud networking: VPCs, subnets, security groups, gateways, and the diagrams that explain outages.
- Object storage: buckets, durability, and when files belong there instead of a database.
- Managed databases: what the provider runs for you, and what you are still responsible for.
- Identity and access management: roles, policies, least privilege, and the audit trail.
- Secrets and configuration: environment injection, secret managers, and rotation.
- Load balancing: layer 4 vs layer 7, health checks, and session affinity myths.
- Scaling: vertical vs horizontal, autoscaling policies, and the stateless-service requirement.
- Observability: metrics, logs, traces, SLIs/SLOs, and dashboards that answer questions.
- Incident management: detection, triage, communication, blameless postmortems.
- Cloud cost management: the levers, the traps, and estimating before you build.

## Why it matters

Cloud is where architecture meets economics: every abstraction has a price, every region is a
latency decision, and every unbounded autoscaler is an invoice. The concepts here outlive any one
provider — but the operational reflexes (least privilege, health checks, SLOs, cost review,
rehearsed recovery) are what turn a deployment into a system you can run at 3 a.m. without fear.

## Prerequisites

- [16-DEVOPS-AND-INFRASTRUCTURE](../16-DEVOPS-AND-INFRASTRUCTURE/README.md) — containers, CI/CD,
  Linux, and networking are assumed.
- [06-INTERNET-AND-WEB-FOUNDATIONS](../06-INTERNET-AND-WEB-FOUNDATIONS/README.md) — IP, DNS, and TLS.

## Lessons

- `cloud-computing-fundamentals.md` · `virtual-machines.md` · `cloud-networking.md`
- `object-storage.md` · `managed-databases.md`
- `identity-and-access-management.md` · `secrets-and-configuration.md`
- `load-balancing.md` · `scaling.md`
- `observability.md` · `incident-management.md` · `cloud-cost-management.md`

## Exercises and practice

Design and calculation exercises that need no cloud account, plus optional hands-ons where you
have one: architect a deployment for a target load and write the cost estimate; write the IAM
policy for a service account with least privilege; define three SLIs and an SLO with an error
budget for your own project; draft a postmortem from a provided incident timeline; and a "find the
outage" exercise reading a provided architecture diagram and metrics snapshot.

## Expected outcomes

You can design a production topology (load balancer, app tier, managed database, object storage)
with its security boundaries and failure modes named; size and justify a scaling approach; define
observability that would actually detect your system's most likely failure; and estimate monthly
cost before writing infrastructure.

## Common blockers

- **"Auto-scale everything".** Autoscaling fixes capacity, not architecture; stateful designs and
  chatty databases do not scale horizontally by wish.
- **Security group as authentication.** Network boundaries and identity are different layers;
  both are required.
- **Dashboards without questions.** Every panel should answer a question you would ask during an
  incident; otherwise it is decoration.

## Next

[18-ADVANCED-ENGINEERING](../18-ADVANCED-ENGINEERING/README.md) — concurrency, messaging,
distributed-system patterns, system design, and performance profiling.