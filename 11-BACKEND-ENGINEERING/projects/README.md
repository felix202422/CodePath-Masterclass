# Projects — 11 Backend Engineering

Two build briefs that stand alone and double as preparation for the Project Laboratory's
**[Project 04 — REST API](../../20-PROJECT-LABORATORY/README.md)** and
**[Project 05 — Full-stack Application](../../20-PROJECT-LABORATORY/README.md)**.
Acceptance criteria are written the way a reviewer checks work: observable, runnable top to
bottom, no credit for "it seemed fine."

**How to use these briefs:** attempt first — no reference implementation exists for these,
by design; the criteria *are* the answer key's shape. Check yourself honestly against each
line, exactly as [20-PROJECT-LABORATORY](../../20-PROJECT-LABORATORY/README.md) instructs.
Your lab is the `spring-smoke`-shaped Spring Boot app from
[exercises/](../exercises/README.md) (Spring Boot 4.1.1, Java 21+, PostgreSQL 18) — every
rule below has an executed precedent in a lesson, so you are composing proven pieces, not
inventing behavior.

**Reviewer tooling notes.** Every "captured" below means a `curl -i` (or MockMvc test)
transcript in your lab, not a screenshot of a browser tab. Every "assert" means a JUnit
assertion that runs in `mvn test`. Status codes, headers, and bodies are checked as bytes —
where the brief says *identical*, compare the raw responses, not your paraphrase of them.

---

## Brief 1 — An order API that behaves under review → `api-design.md` · `validation-and-error-handling.md` · `controllers-services-repositories.md` · `jpa-and-hibernate.md` · `backend-testing.md`

A resource-oriented API over one schema you designed (build on your subject-10 schema or
the lab's `order`/`product` pair): CRUD for at least three resources, a list endpoint with
pagination, and a write path that validates, persists, and fails correctly.

**Requirements**

- Routes are nouns with correct methods: `GET` safe and cacheable-ish, `POST` create with
  `201` + `Location`, `PUT`/`PATCH` with their distinct semantics stated, `DELETE` idempotent
  on repeat. A `GET` never mutates — proved, not asserted in prose.
- The list endpoint paginates with `page`/`pageSize` *or* cursor — you choose, and you
  write down which and why (the api-design lesson's trade-off), with a stable ordering that
  makes pages non-overlapping under insertion.
- Validation is total: every constraint from the schema and the requirement is enforced at
  the edge, and one malformed request reports **all** violations, `fieldErrors` sorted by
  field name.
- One error envelope for the whole API — `type`, `status`, `detail`, `fieldErrors` — and
  every status code you emit appears in your OpenAPI doc (brief 2 owns the spec itself).
- The layered discipline holds: controllers translate HTTP, services decide, repositories
  persist. `grep` your controllers for `@Repository`/`JdbcTemplate`/`EntityManager` and find
  nothing.
- Persistence is honest: foreign keys exist in the database, not only in Java; an N+1
  candidate in any list path is fixed with join fetch or `@EntityGraph` and **proved by
  query counting** (the JPA lesson's 6-selects-vs-1 battery).

**Acceptance criteria**

1. `mvn test` green with, at minimum: a validation test (all fields, sorted), a
   rollback-integration test (service throws mid-transaction → `count(*)` unchanged), an
   authorization-adjacent ownership test, and an N+1 test using query counting.
2. Captured: `POST` → `201` + `Location`; repeat of the same `DELETE` → `404` the second
   time (or `204` twice — your stated contract, executed both times).
3. Captured: one request violating two rules returns **both** violations sorted; a second
   request violating one rule returns exactly one.
4. Captured: an unknown route and an unauthorized read of a *existing* resource return
   responses you can defend as distinguishable-or-not — state the policy, then show it.
5. Pagination: three pages fetched with your chosen scheme, their ids written out, and the
   no-overlap/no-gap claim checked against a dataset you insert *between* page fetches.
6. Query-count evidence for one list endpoint before and after the fix (two numbers, one
   sentence on what the second number costs you).

## Brief 2 — The API a client can trust: identity, files, jobs, docs, logs → `authentication.md` · `authorization.md` · `sessions-and-tokens.md` · `file-uploads.md` · `caching.md` · `background-jobs.md` · `api-documentation.md` · `logging.md`

Take brief 1's API and give it everything a real client needs: an identity system, a file
path, asynchronous work, a contract document, and logs an operator can debug from. This is
the backend half of Project 05 — a second client (a React or Flutter app) will be built
against exactly this behavior.

**Requirements**

- **Authentication** with the mechanism you chose and can explain: sessions *or* JWT, with
  expiry, and a login flow whose failures are uniform — unknown user and wrong password
  answer with byte-identical `401` bodies.
- **Authorization** in the service layer: ownership checks on every read and write of
  user-scoped rows, roles enforced where the brief needs them, and IDs treated as an
  authorization boundary — a foreign id reads exactly like a missing one.
- **Uploads**: extension *and* content-type checks, a size limit that returns `413` on
  violation, stored under generated names, never under the client's.
- **Background jobs**: at least one endpoint enqueues work (`202` + `Location`), the job
  retries a failed attempt, and a duplicate submission is deduplicated by key.
- **Docs**: an OpenAPI document served from the app that validates against the spec's
  schema, with a recorded contract-vs-runtime diff (status codes and error shapes).
- **Logs**: every request carries a correlation id into the log line; three levels
  demonstrated; and a scan of all three log files finds **zero** occurrences of the
  password or token you used in testing.

**Acceptance criteria**

1. Captured: login failures byte-identical (raw bodies compared), foreign-read `404`
   identical to missing-read `404`, and one test in `mvn test` that enforces each.
2. Captured: registration → login → authenticated request → logout (or token expiry)
   end-to-end, with the four status codes in order.
3. Captured: `.exe` upload rejected with the envelope; oversize upload `413`; a stored
   file whose on-disk name is server-generated.
4. Captured: job accepted (`202` + `Location`), processed, retried after a simulated
   failure, and a duplicate key reported as duplicate — four lines of evidence.
5. Captured: spec validation 4/4-green equivalent (or your validator's pass output) and
   one documented diff you chose to resolve and how.
6. Captured: three log runs with a shared correlation id across the request's lines, and
   `grep -c password` → `0` over the collected logs.
7. The whole suite — brief 1 and 2 tests together — green in one `mvn test`, with the
   surefire summary quoted.

**Extension challenges** (each states what it teaches)

- Add a rate limiter to login (`429` with `Retry-After`) — teaches idempotent counting
  under concurrent attempts and why the counter cannot live in one instance's memory.
- Move the background worker to a Postgres-backed queue with `SELECT … FOR UPDATE SKIP
  LOCKED` — teaches competing consumers without a broker.
- Put the cache in front of the list endpoint with an invalidation-on-write policy, and
  prove correctness with a test that reads-through, writes, then re-reads — teaches cache
  invalidation, the one problem that never fully goes away.

---

## What "done" looks like

Both briefs green means you can hand the repository to a reviewer who runs `mvn test`,
reads one surefire summary, and then plays `curl` detective against your captured
transcripts — and every claim in your README survives contact with their terminal. That is
the exact standard Project 04 and Project 05 are graded against in
[20-PROJECT-LABORATORY](../../20-PROJECT-LABORATORY/README.md).

Next: [exercises/](../exercises/README.md) for the twelve sets that build toward these
briefs, one lesson-group at a time.
