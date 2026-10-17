# 11 — Backend Engineering

This subject builds the server side of real applications in Java with Spring Boot and PostgreSQL:
an HTTP API that validates its input, persists correctly, authenticates and authorizes callers,
documents itself, logs usefully, and is proven by tests.

## What this subject covers

- Backend fundamentals: what a server does all day, and the shape of a request's life.
- HTTP and REST APIs: resources, methods, status codes, and statelessness — as design tools.
- API design: naming, versioning, pagination, filtering, idempotency, and error contracts.
- Java backend structure: the shape of a production Java service.
- Spring fundamentals: the container, beans, and configuration.
- Spring Boot: auto-configuration, starters, profiles, and the actuator.
- Dependency injection: what it is for, and how it enables testing.
- Controllers, services, repositories: the layered discipline and where logic belongs.
- Validation and error handling: bean validation, and one consistent error response shape.
- JPA and Hibernate: mapping objects to tables, fetching strategies, and avoiding the N+1 trap.
- Authentication: passwords, sessions, JWTs — and how each actually works.
- Authorization: roles, ownership checks, and enforcing access at the service layer.
- Sessions and tokens: storage, expiry, refresh, revocation, and their trade-offs.
- OAuth2 and OpenID Connect: delegating identity, and what "login with X" really does.
- File uploads: multipart handling, size limits, and safe storage.
- Caching: where caching helps, invalidation, and the correctness traps.
- Background jobs: async work, retries, and idempotent processing.
- API documentation: OpenAPI as a contract, generated from code and reviewed by humans.
- Logging: levels, correlation IDs, and what never to log.
- Backend testing: unit, slice, and full integration tests with Testcontainers.

Every example belongs to one growing application, split across lessons, so nothing is an isolated
snippet. Versions (Spring Boot 4.1.x, Java 21, PostgreSQL 18) are pinned in
[VERSIONS.md](../VERSIONS.md).

## Why it matters

Backend code is where correctness, security, and scale are actually decided. A REST API is also the
junction point of the whole curriculum: it consumes your database design, serves your React
frontend, is called by your Flutter app, and is what CI/CD deploys and monitoring watches. Learning
it as one coherent application — rather than as disconnected features — is what makes the later
architecture, testing, and DevOps subjects click.

## Prerequisites

- [04-JAVA-PROGRAMMING](../04-JAVA-PROGRAMMING/README.md) — classes, interfaces, exceptions,
  collections, and Maven.
- [06-INTERNET-AND-WEB-FOUNDATIONS](../06-INTERNET-AND-WEB-FOUNDATIONS/README.md) — HTTP, TLS, and
  the client–server model.
- [10-DATABASE-ENGINEERING](../10-DATABASE-ENGINEERING/README.md) — you will persist a designed
  schema with transactions and indexes.

## Lessons

- `backend-fundamentals.md` · `http-and-rest-apis.md` · `api-design.md`
- `java-backend-development.md` · `spring-fundamentals.md` · `spring-boot.md`
- `dependency-injection.md` · `controllers-services-repositories.md`
- `validation-and-error-handling.md` · `jpa-and-hibernate.md`
- `authentication.md` · `authorization.md` · `sessions-and-tokens.md` · `oauth2-and-openid-connect.md`
- `file-uploads.md` · `caching.md` · `background-jobs.md`
- `api-documentation.md` · `logging.md` · `backend-testing.md`

## Exercises and practice

Each lesson extends the same running API with tests required alongside the feature; `projects/`
holds the briefs for Project 04 (REST API) and Project 05 (full-stack). Exercises include writing
an integration test that proves rollback, an authorization test that would catch a privilege
escalation, and an N+1 fix verified with query counting.

## Expected outcomes

You can take a written requirement and deliver a tested endpoint end to end — validated input,
enforced authorization, correct status codes, structured errors, documented contract, and logs you
could debug from — and explain every layer of the request path from `curl` to row and back.

## Common blockers

- **Business logic in controllers.** Controllers translate HTTP; services decide; repositories
  persist. Leaking logic upward is the most common structural defect in student backends.
- **Authentication ≠ authorization.** Being logged in says who you are; authorization decides what
  you may do. Both are tested separately.
- **Trust of client input.** Every client-supplied value is hostile until validated — including
  IDs, which are an authorization boundary, not a parameter.

## Next

[12-MOBILE-DEVELOPMENT](../12-MOBILE-DEVELOPMENT/README.md) — the same API, a second client:
building and releasing a Flutter app against it.