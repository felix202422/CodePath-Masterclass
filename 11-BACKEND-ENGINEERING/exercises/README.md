# Exercises — 11 Backend Engineering

**Lessons:** this subject's twenty lessons, in order.
**How to use these sets:** attempt first; solutions live in
[solutions/](solutions/README.md) behind a warning. The 15-minute rule from
[learning-method](../../00-START-HERE/learning-method.md) applies — record which hint you used.

Sets 1–12 correspond to the lessons named in their titles and mirror each lesson's exercise
ladder (introductory → intermediate → independent) with observable completion criteria.
Completing all twelve sets *is* this subject's half of the milestone gate in
[ROADMAP.md](../../ROADMAP.md) Milestone 6 ("all exercise sets in 06–10 plus backend
exercises"), and they are the build-up to the two briefs in [projects/](../projects/README.md).

**The lab you need.** Every set runs against a Spring Boot app you may break and rebuild at
will, with a real PostgreSQL database behind it. The same shape the lessons were executed in:

```bash
# Spring Initializr (start.spring.io): Gradle or Maven, Java 21, Spring Boot 4.1.1,
# dependencies: Web, Validation, Data JPA, Security Crypto, Actuator, Test
createdb backend_lab
# application.properties:
#   spring.datasource.url=jdbc:postgresql://127.0.0.1:5433/backend_lab
#   spring.datasource.username=you
mvn spring-boot:run          # the app your transcripts come from
```

Add the Spring Boot 4 test module the testing lesson diagnosed — without it
`@AutoConfigureMockMvc` does not compile: `spring-boot-webmvc-test` (scope `test`, see
[backend-testing.md](../backend-testing.md) §6). The lessons were executed with
**Spring Boot 4.1.1, Java 21 (toolchain 25.0.4), PostgreSQL 18.6, Maven 3.9** — policy
matches [VERSIONS.md](../../VERSIONS.md): where your versions differ, the *behaviour* is
the criterion and the exact text is yours to capture.

**Predict before you run.** Every set below that says "predict" means paper first: write
the status code, headers, and body shape you expect *before* pressing Enter — a prediction
you did not write down is not a prediction. Where a set says "assert", it means a JUnit
assertion in `mvn test`, not a `curl` you eyeballed.

---

## Set 1 — Backend fundamentals → `backend-fundamentals.md`

1. The request's life, drawn then executed: write the path of `POST /auth/login` from
   socket to row and back (listener → filter chain → controller → service → repository →
   database → response), then add the hop you missed by capturing the actual access/error
   logs of one request with a correlation id.
   **Criteria:** the path drawn before running; the captured log lines mapped to your
   drawing's arrows (each line labelled with the hop); one hop you could not observe and
   why (and which log level or flag would show it).
2. Status-code triage: for one endpoint, produce four *different* outcomes and predict
   each code first — success, validation failure, unauthorized, not-found.
   **Criteria:** four `curl -i` captures with codes predicted beforehand; each response
   body checked for the envelope's `type` field; the 4xx-vs-5xx line written (whose fault,
   and what the client should do differently).
3. Idempotency you can feel: replay the same `DELETE` twice and the same `POST` twice,
   capture both pairs.
   **Criteria:** four captures; the second `DELETE`'s code matching your stated contract;
   one sentence on why `GET`/`PUT`/`DELETE` replay safety is a design decision, not luck.
4. **Independent:** take a written requirement ("a library lets members borrow and return
   books; staff can override anything") and decompose it into endpoints — method, path,
   success code, error codes — *before* writing any code; then implement one endpoint of
   it and execute its four outcomes.
   **Criteria:** the endpoint table written first; one implemented endpoint with four
   executed captures; every deviation from your table explained as a design fix, not
   silence.

## Set 2 — HTTP and REST APIs → `http-and-rest-apis.md`

1. Method semantics battery on your own resource: `GET`, `POST`, `PUT`, `DELETE`, `HEAD` —
   predict the status of each, including `HEAD`'s headers-without-body and a `PUT` replay.
   **Criteria:** the prediction table written first; five `curl -i` (`-I` for HEAD)
   captures; the idempotency classification (safe / idempotent / neither) for each method,
   checked against your captures.
2. `204` and the empty body: capture a successful `DELETE` with no content, then the *same*
   route with `?_method` noise to show the body really is zero bytes.
   **Criteria:** two captures; the `Content-Length: 0` / absent-body observation written;
   one sentence on why `204` and `200`-with-`{}` differ for a client.
3. Stateless proof: repeat a request with and without the session/token header and capture
   both — the server remembers nothing between them.
   **Criteria:** two captures; the server-side state named (what *is* stored, where, and
   why it is keyed by the credential, not the connection).
4. **Independent:** given a third-party API's documented behavior (pick any public JSON
   API), write five predictions about its responses (method, code, content-type, a header,
   pagination shape), then execute them with `curl` and explain every mismatch from the
   spec or your misreading.
   **Criteria:** five predictions vs five captures; each mismatch attributed; one line on
   what "REST" allowed the API to differ without breaking you.

## Set 3 — API design → `api-design.md`

1. Naming and versioning: mount `/v1/orders` and `/v2/orders` with a visible difference,
   capture both, then capture the deprecation header you advertise on v1.
   **Criteria:** three captures; the URL design rationale written (nouns, nesting depth ≤
   one, when *not* to nest); the versioning strategy chosen (URL vs header) with its
   cost stated.
2. Pagination, filtering, sorting: one list endpoint with `page`/`pageSize` (or cursor),
   one filter, one sort — predict the exact ids on page 2 before running.
   **Criteria:** the page-2 prediction written first; the executed capture matching (or
   the mismatch explained by unstable ordering); the dataset modified *between* page
   fetches to demonstrate overlap or gap, captured.
3. Idempotency keys: send a create twice with the same `Idempotency-Key` and twice with
   different keys; capture all four.
   **Criteria:** four captures; the dedup rule stated (what is stored, for how long, keyed
   by what); the failure mode of a *concurrent* duplicate named, with your mitigation.
4. **Independent:** design the API for a written domain (parking bookings: slots, vehicles,
   permits), write the endpoint table with codes *first*, implement the two most
   contested endpoints, and execute one happy path and three refusals.
   **Criteria:** the table before code; five executed captures; two design decisions you
   reversed after executing, each with the evidence that changed your mind.

## Set 4 — Java backend development → `java-backend-development.md`

1. The layered structure, executed: build the controller → service → repository skeleton
   with one feature, then prove the layers with a trace — log lines (or a breakpoint)
   showing the call descending and the response ascending.
   **Criteria:** the package tree written; one request's trace with each line attributed to
   a layer; the one thing each layer may not know about, stated for each of the three.
2. Exceptions across layers: throw a domain exception in the service and catch it at the
   edge; capture the client-visible response and the server log of the same failure.
   **Criteria:** both captures; the rule written (which layers know the HTTP status and
   which must not); a counterexample — an exception that leaked a stack trace — with the
   fix.
3. DTOs at the boundary: expose one entity, then refactor to a response DTO that hides a
   field, capturing both responses.
   **Criteria:** two captures showing the field's disappearance; one sentence on why the
   entity must not be the wire format (schema coupling, lazy loading, over-exposure).
4. **Independent:** from the brief-1 sketch in [projects/](../projects/README.md), lay out
   the packages for three resources, decide where each of five concerns lives (validation,
   auth, persistence, pagination, logging), and implement the riskiest one end to end.
   **Criteria:** the concern-placement table; the implemented endpoint with two captures;
   the weakest placement named, with the alternative you rejected and why.

## Set 5 — Spring fundamentals · Spring Boot → `spring-fundamentals.md` · `spring-boot.md`

1. The container you can see: define two beans, inject one into the other, then rename a
   bean and capture the startup failure that names your mistake.
   **Criteria:** the failure capture with the unsatisfied dependency quoted; the bean
   discovery rule written (which annotation, which package, constructor vs field
   injection — with your choice and its reason).
2. Configuration and profiles: put one value in `application.properties`, override it in a
   `dev` profile, capture both resolved values (an actuator `env` endpoint or a log line).
   **Criteria:** two captures; the precedence chain you observed written (property file →
   profile file → environment variable → command line — in the order you verified);
   one secret kept *out* of the repository, named by placeholder.
3. Fail fast: point the datasource at a closed port, capture the startup failure, then fix
   the property and capture the healthy boot.
   **Criteria:** both captures; the argument for failing at startup rather than first
   request, in your own words, with the operational consequence (load balancer sees you
   down, not erroring).
4. **Independent:** take a feature request ("toggleable recommendation endpoint") and
   implement it with `@ConditionalOnProperty`, capturing on, off, and the endpoint's
   absence (404) when off.
   **Criteria:** three captures; the toggle's configuration written; one alternative
   mechanism considered (profile, feature-flag service) and its cost stated.

## Set 6 — Dependency injection · Controllers, services, repositories → `dependency-injection.md` · `controllers-services-repositories.md`

1. Constructor injection of an interface: write a `Clock`-style seam (or a repository
   interface), inject a real implementation in the app and a fake in the test, capture both
   runs.
   **Criteria:** two transcripts (app run, test run); the rule written — *production code
   depends on abstractions the test can replace*; the field-injection version compiled and
   why it is harder to test demonstrated (one sentence, one attempt).
2. Layer discipline audit: take a controller that reaches around the service (copy one from
   the lesson), run it, then fix it — capturing behavior before and after.
   **Criteria:** the transgression located by reading (quoted); the fix; the test that now
   passes (or the test you must write) proving the service owns the rule.
3. Transaction boundary: call a service method that writes two rows, make the second throw,
   and capture `count(*)` before and after — rollback proven, not assumed.
   **Criteria:** two counts proving no partial write; the `@Transactional` boundary drawn
   on the call stack; one case where the annotation silently did nothing (self-invocation
   or checked exception — executed and explained).
4. **Independent:** for your brief-1 API, place seven concerns (auth check, validation,
   pagination, persistence, logging, caching, retry) into layers on paper, implement two of
   them, and write one test per implemented concern at its correct layer.
   **Criteria:** the placement table; two implemented concerns; two tests, each running
   without the layers it does not need (state which context each boots).

## Set 7 — Validation and error handling → `validation-and-error-handling.md`

1. The total-validation battery: one request violating three rules (blank field, out-of-range
   number, malformed shape), predict which violations appear, then capture.
   **Criteria:** the predicted violation list written first; the capture showing **all three**
   reported at once with `fieldErrors` sorted; the malformed-body case separated (it is a
   400 of a different `type` — quote both types).
2. One envelope, every error: trigger five different failures (validation, not-found,
   conflict, unauthorized, wrong content-type) and collect the bodies.
   **Criteria:** five captures; the shared shape checked field by field (`type`, `status`,
   `detail` present in all five); the one deliberate difference named (415's body vs a
   field-violation body) and defended.
3. Domain refusals as exceptions: make the service throw a conflict-style exception, catch
   it at the edge, and capture the status mapping.
   **Criteria:** the capture; the exception→status table you wrote *before* running, checked
   against reality; one mapping you got wrong on paper and the reasoning correction.
4. **Independent:** write the error contract for a fictional API (one page: envelope,
   every status you emit with its `type` URI and when it appears), then implement a
   handler that satisfies it and prove it with three executed failures.
   **Criteria:** the contract page; three captures matching it exactly; the diff between
   your contract and your implementation, resolved in writing.

## Set 8 — JPA and Hibernate → `jpa-and-hibernate.md`

1. Mapping round-trip: entity + table, persist a row, then read the DDL Hibernate
   generated and the row as PostgreSQL stores it (`\d` and `select`).
   **Criteria:** the generated DDL captured; the stored row captured; every column/type
   choice mapped to its annotation; one mismatch you changed the annotation for.
2. The N+1 battery: a list endpoint with a collection association, count queries with SQL
   logging on, then fix with join fetch or `@EntityGraph` and count again.
   **Criteria:** two numbers (e.g. 6 vs 1) from the same request; the fix's one-line trade-off
   written (join-multiplication vs extra select); the query-counting method documented so
   it is repeatable.
3. LazyInitializationException, provoked: touch an unloaded association outside a session,
   capture the exception by name, then fix it *two ways* (fetch join inside the transaction;
   DTO projection) and capture both responses.
   **Criteria:** the failure capture; two fixed captures; one sentence on why the exception
   is a design signal, not an annoyance to be silenced with `@Transactional` on the view.
4. **Independent:** map a two-entity domain of your own with one many-to-many, persist five
   rows through relationships, and prove cascade and orphan-removal behavior with a delete
   you can predict first.
   **Criteria:** the predicted effect of deleting the parent written down; the executed
   result; the catalog check (`\d` after) matching your intent; one cascade choice you
   reversed.

## Set 9 — Authentication · Sessions and tokens → `authentication.md` · `sessions-and-tokens.md`

1. The uniform-failure drill: register a user, then attempt login with (a) the right user,
   wrong password, (b) a user that does not exist — capture both bodies and compare them.
   **Criteria:** both captures; the byte-comparison shown (diff or hash); the timing
   equalization you read about executed or reasoned about with its one line of evidence.
2. Session lifecycle: register → login → authenticated request → logout → replay the old
   session id.
   **Criteria:** five requests, five status codes written in order; the server-side store
   named (where the session lives); the cookie flags (`HttpOnly`, `Secure`, `SameSite`)
   quoted from the response.
3. JWT anatomy, verified: decode a token's payload (no signature check first), then verify
   the signature properly and capture both.
   **Criteria:** the three decoded segments; the claims checklist (iss, sub, exp, iat)
   filled from your token; the one sentence on why base64 is **not** encoding-as-security;
   an expired-token request captured as 401.
4. **Independent:** choose session *or* JWT for a written scenario (a team dashboard with
   logout-everywhere), implement it, and defend the choice against the other one in five
   sentences citing revocation and scale.
   **Criteria:** the working flow captured end to end; the defense citing at least two
   trade-offs from the lessons; the revocation story stated concretely (what is deleted,
   where).

## Set 10 — Authorization · OAuth2 and OpenID Connect → `authorization.md` · `oauth2-and-openid-connect.md`

1. The IDOR drill: two users, one resource — user B requests user A's id and captures the
   response; then B requests a never-existing id; the two captures must be identical.
   **Criteria:** both bodies compared byte-wise; the rule written (existence is not
   observable); a *broken* variant where your check returns different bodies, captured and
   then fixed.
2. Role gate at the service layer: a role-restricted operation attempted by both roles,
   with the check located by reading (quote the line) and one test proving it.
   **Criteria:** two captures (allowed, refused 403); the quoted gate; the test in
   `mvn test`; one sentence on why the gate lives in the service, not the controller.
3. OAuth2 authorization-code flow, walked: run the code+PKCE flow against your local
   provider (or the lesson's lab), capture redirect → code → token exchange, and fill the
   claim checklist from the id token.
   **Criteria:** four captures (authorize redirect, callback, token response, authenticated
   request); state and PKCE verified as *used*, not present; the three attacks from the
   lesson (state swap, code replay, missing PKCE) rejected with their captures.
4. **Independent:** for your brief-2 API, write the authorization matrix (roles × actions ×
   endpoints), implement three cells of it, and write one test per cell — including one
   test that would catch a privilege escalation you deliberately introduce and revert.
   **Criteria:** the matrix; three implemented cells; four tests (three green + the red drill
   with its failure message).

## Set 11 — File uploads · Caching · Background jobs → `file-uploads.md` · `caching.md` · `background-jobs.md`

1. Upload gate battery: a valid file, a wrong extension, a wrong content-type, an oversize
   file — predict all four codes, then capture.
   **Criteria:** four predictions vs four captures; the stored file's server-generated name
   quoted from disk; the sentence on why extension *and* content-type (each catches what
   the other misses).
2. Cache provenance: hit one cached endpoint twice — first response `source=db`, second
   `source=cached` (or your equivalent marker) — then mutate the data and capture the third
   read.
   **Criteria:** three captures; the invalidation-on-write policy stated in one line; the
   correctness argument for why a concurrent read cannot persist stale data past your
   policy (or an honest admission that it can, with the mitigation).
3. Job lifecycle with receipts: submit a job (`202` + `Location`), poll it to a terminal
   state, submit a duplicate key, then force a failure and watch the retry.
   **Criteria:** four captured transitions (accepted → running/succeeded; duplicate →
   deduplicated; failure → retry → success); the retry policy written (attempts, backoff);
   one sentence on why the job must be idempotent even with dedup.
4. **Independent:** pick one slow operation from your brief-1 API, move it behind an
   endpoint that returns `202`, and prove the whole contract: acceptance, status polling,
   failure surfacing, and a client-visible error for a poisoned job.
   **Criteria:** the four captures; the error contract for failed jobs written; the
   synchronous version kept as a test control (same inputs, same outcome).

## Set 12 — API documentation · Logging · Backend testing → `api-documentation.md` · `logging.md` · `backend-testing.md`

1. Contract from code, checked against runtime: generate or write an OpenAPI document for
   three endpoints, validate it with a real validator, then diff documented vs actual
   responses for one happy path and one error.
   **Criteria:** the validator's pass output captured; the diff (documented vs actual) for
   two responses; one discrepancy you resolved and how (fix the doc or fix the code —
   stated).
2. Correlation logging: one request traced across log lines by its correlation id, with
   DEBUG, INFO, and WARN runs captured for the same flow.
   **Criteria:** three captures; the id appearing in every line of one request's path; the
   level policy written (what each level means operationally, not "debug for debugging").
3. The no-secrets scan: run a full auth flow, collect every log line it produced, and scan
   for the password and token you used.
   **Criteria:** `grep -c` output showing zero occurrences of each secret; the masking
   mechanism named (the annotation or manual mask doing the work); one log line quoted as
   it would appear to an on-call engineer at 03:00.
4. **Independent:** the red-green drill — take one rule from any earlier set, encode it as
   a `mvn test` assertion, break the code to see it fail (capture the failure), fix the code,
   and quote the final surefire summary.
   **Criteria:** the green test, the red run with its assertion message, and the final
   `BUILD SUCCESS` with the suite total; one sentence on what the failure message proved
   that a manual `curl` could not.

---

## Finishing the subject

Twelve sets green + both briefs in [projects/](../projects/README.md) reviewed line by line
is this subject's completion bar. Record each set's completion date and the hint level you
used in [PROGRESS-TRACKER.md](../../PROGRESS-TRACKER.md); the sets are graded by your own
recordings — which is exactly the habit the milestone gate in [ROADMAP.md](../../ROADMAP.md)
is checking for.
