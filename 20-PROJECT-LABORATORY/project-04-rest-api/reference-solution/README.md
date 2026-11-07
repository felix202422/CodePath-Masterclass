# Reference solution guide — Project 04

> **Stop.** Write the transition table and the two-thread test before reading this. Those two pieces are
> where the project is won; the rest is wiring you have done before.

The decisions that decide the grade, with the alternatives that also pass.

## The state machine as a value, not a service

The domain class knows the graph and nothing else:

```java
public enum Status { RECEIVED, DIAGNOSED, AWAITING_PARTS, IN_PROGRESS, READY, COLLECTED, CANCELLED }

public final class StatusMachine {
    private static final Map<Status, Set<Status>> ALLOWED = Map.of(
        RECEIVED,       Set.of(DIAGNOSED, CANCELLED),
        DIAGNOSED,      Set.of(AWAITING_PARTS, IN_PROGRESS, CANCELLED),
        AWAITING_PARTS, Set.of(IN_PROGRESS, CANCELLED),
        IN_PROGRESS,    Set.of(READY, AWAITING_PARTS, CANCELLED),
        READY,          Set.of(COLLECTED, IN_PROGRESS),
        COLLECTED,      Set.of(),
        CANCELLED,      Set.of());

    public static boolean canTransition(Status from, Status to) {
        return ALLOWED.getOrDefault(from, Set.of()).contains(to);
    }
}
```

`Map.of` refuses duplicate keys at construction, which is a cheap guard against a copy-paste error in a
seven-line table. The unit test is a nested loop over `Status.values()` asserting the table's verdict,
plus explicit assertions for the two terminal states — a test that reads the same map twice would pass
for any map, so the terminal-state assertions are the ones with independent value.

Two design notes worth defending in the walkthrough. The machine is static and pure, so a transition
check needs no database and no Spring context — the whole `FR-5` suite runs in milliseconds. And
"same status" is not a legal transition: `READY -> READY` returns `409`, not `200`, because a repeated
write is a client bug worth surfacing, and `FR-8` already covers the legitimate retry case.

## Optimistic concurrency, end to end

Three pieces must line up or `AC-6` and `AC-7` fail in ways that look unrelated:

1. **The column.** `@Version private long version;` on the entity. JPA increments it on flush and
   throws `OptimisticLockingFailureException` when the `UPDATE ... WHERE version = ?` matches no row.
2. **The header.** `ETag: "7"` on read (quoted, per HTTP); parse `If-Match` by stripping the quotes.
   A missing header is `428 Precondition Required` — not `400`, and not "proceed anyway".
3. **The mapping.** `OptimisticLockingFailureException` → `412` with the current version in the body, so
   the client can re-read and retry. A `409` here is defensible but loses the distinction between "your
   copy is stale" and "the transition is illegal".

The trap is checking the version in the controller and then writing in the service: the gap between the
check and the write is exactly the race the requirement is about. Let the database's conditional update
be the check.

```java
@PatchMapping(path = "/{id}/status", consumes = MediaType.APPLICATION_JSON_VALUE)
public ResponseEntity<JobResponse> changeStatus(
        @PathVariable long id,
        @RequestHeader("If-Match") String ifMatch,
        @RequestBody StatusChange body) {
    long expected = parseEtag(ifMatch);          // 400 if malformed
    JobResponse updated = service.changeStatus(id, expected, body.status(), currentActor());
    return ResponseEntity.ok().eTag("\"" + updated.version() + "\"").body(updated);
}
```

`@RequestHeader("If-Match")` missing produces a `400` by default; add an exception handler that maps
`MissingRequestHeaderException` to `428` for this header only.

## Idempotency without a second job

The table is the contract: key, a hash of the request body, and the stored response.

```text
BEGIN;
INSERT INTO idempotency_keys (key, request_hash, response_status, response_body)
VALUES ($1, $2, NULL, NULL) ON CONFLICT (key) DO NOTHING;
-- 0 rows inserted => key seen before
SELECT request_hash, response_status, response_body FROM idempotency_keys WHERE key = $1;
--   hash differs      => 422 "key reused with a different body"
--   status is NULL    => a concurrent request holds the key => 409, retry
--   otherwise         => replay the stored response
-- create the job, then UPDATE the row with status and body
COMMIT;
```

Two failure modes to handle deliberately. A crash between inserting the key and storing the response
leaves a `NULL` status forever; the fix is an expiry sweep on `created_at` and treating a `NULL` older
than a minute as retryable. And storing the whole response body is fine at this size but grows without
bound; store a body hash plus the `Location` and let the client re-read, if you prefer.

The `ON CONFLICT DO NOTHING` insert is what makes the check atomic. `SELECT` then `INSERT` has the same
race as project 03's loan check, and the same fix.

## Avoiding N+1

`GET /jobs` returns 50 jobs and each needs its customer's name and its assignee's name. The naive JPA
mapping fires 1 + 100 queries. Three fixes:

- **`@EntityGraph` on the repository method** — one join per collection, and a `distinct` to collapse the
  rows. Correct, and the least code.
- **A projection query** — `SELECT new JobSummary(j.id, j.device, c.name, t.name) FROM Job j JOIN ...`.
  Fewer columns, no entity overhead; the guide's choice for the list path, because a list does not need
  events.
- **Batch fetching** (`hibernate.default_batch_fetch_size`) — helps when you cannot change the query, but
  it hides the problem rather than fixing it.

Turning on `hibernate.generate_statistics=true` in the test profile and asserting
`getPrepareStatementCount() <= 4` is the only way `NFR-2` stays true after the next feature. A page-size
loop in the test (10, 50, 100) catches the regression where someone adds a lazy association.

## Token validation

```java
@Bean
SecurityFilterChain api(HttpSecurity http, JwtDecoder decoder) throws Exception {
    http.csrf(csrf -> csrf.disable())               // bearer-only API, no cookies
        .sessionManagement(s -> s.sessionCreationPolicy(STATELESS))
        .authorizeHttpRequests(a -> a
            .requestMatchers("/actuator/health/**", "/openapi.json").permitAll()
            .anyRequest().authenticated())
        .oauth2ResourceServer(o -> o.jwt(j -> j.decoder(decoder)
            .jwtAuthenticationConverter(rolesConverter())))
        .exceptionHandling(e -> e
            .authenticationEntryPoint(problemEntryPoint())   // 401 + WWW-Authenticate
            .accessDeniedHandler(problemAccessDenied()));    // 403 problem+json
    return http.build();
}
```

`JwtDecoders.fromIssuerLocation` pins the algorithm set from the issuer metadata, which closes the
`alg: none` and HS/RS confusion holes that a hand-rolled decoder usually has. The default Spring error
bodies are empty; both handlers must produce the same problem shape as the rest of the API, or the
front-end has two error parsers.

Authorisation belongs in the service, because it needs the job's assignee:

```java
if (actor.role() == Role.TECHNICIAN && job.getAssigneeId() != actor.id()) {
    throw new ForbiddenException("job belongs to another technician");
}
```

A `@PreAuthorize("hasRole('COORDINATOR')")` on the assign endpoint is not enough for this rule, and a
test with a technician token on someone else's job is the only proof.

## OpenAPI drift

Commit `openapi.json` and regenerate it in CI:

```bash
./gradlew test --tests '*OpenApiDocumentTest'   # writes build/openapi.json
git diff --exit-code -- openapi.json           # fails the build on drift
```

Generate the document from a running context (`SpringDoc` against `MockMvc`), not from annotations alone,
so a missing `@Operation` or an undocumented `4xx` shows up as a diff. The `NFR-4` requirement is about
stability, not completeness — a diff is acceptable when it is intentional and reviewed.

## Trade-offs and alternatives

- **JPA versus JDBC.** JPA gives `@Version` and entity graphs for free; JDBC gives explicit SQL and no
  surprise queries. For a domain this size JPA is faster to correct; a team that dislikes ORMs can do
  all of this with `JdbcClient` and one extra `WHERE version = ?`.
- **`PATCH /status` versus `PUT /jobs/{id}`.** A sub-resource action is easier to validate and to
  authorise; a full replace needs `If-Match` on every field and invites lost updates. The sub-resource
  wins here.
- **Database-backed idempotency versus Redis.** The table is transactional with the job creation, which
  is the property you actually need; Redis is faster and can lose the key on eviction.
- **Offset pagination versus keyset.** Offset is what the requirement names and is fine at 50,000 rows
  with an index; keyset is stable under inserts and is the right answer at a million.
- **Rate limiting in the app versus at the gateway.** The app can see the token identity; the gateway
  sees the IP and survives an app restart. Production usually has both; the brief asks for the app one
  so it is testable.

## What is deliberately missing

The controllers' DTO records, the Flyway scripts and the k6 script. They are mechanical once the
decisions above are made, and copying them would skip the part where you decide how `detail` reads for
an illegal transition — which is the difference between an API a UI can use and one it cannot.
