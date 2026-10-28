# Solutions — 11 Backend Engineering

**⚠ Attempt the sets first.** Reading a solution produces recognition, which feels like
knowledge and is not. One week after reading any solution here, rebuild that answer from a
blank page — the second attempt is the one you keep.

One solution file per set, matching the lessons of the same name. Transcripts marked as
*authoring machine* were executed during this batch against the batch's `spring-smoke`
lab (Spring Boot **4.1.1**, Java 21 toolchain, Maven) with PostgreSQL **18.6** as the
database, plus the plain-Java layered probe and the OIDC provider probes. Your versions'
exact text will differ — the **behaviour and the reasoning** are the criteria; your own
captured output is your evidence.

| Set | Lesson(s) | File |
|---|---|---|
| 1 | Backend fundamentals | [set-1-solutions.md](set-1-solutions.md) |
| 2 | HTTP and REST APIs | [set-2-solutions.md](set-2-solutions.md) |
| 3 | API design | [set-3-solutions.md](set-3-solutions.md) |
| 4 | Java backend development | [set-4-solutions.md](set-4-solutions.md) |
| 5 | Spring fundamentals · Spring Boot | [set-5-solutions.md](set-5-solutions.md) |
| 6 | Dependency injection · Controllers, services, repositories | [set-6-solutions.md](set-6-solutions.md) |
| 7 | Validation and error handling | [set-7-solutions.md](set-7-solutions.md) |
| 8 | JPA and Hibernate | [set-8-solutions.md](set-8-solutions.md) |
| 9 | Authentication · Sessions and tokens | [set-9-solutions.md](set-9-solutions.md) |
| 10 | Authorization · OAuth2 and OpenID Connect | [set-10-solutions.md](set-10-solutions.md) |
| 11 | File uploads · Caching · Background jobs | [set-11-solutions.md](set-11-solutions.md) |
| 12 | API documentation · Logging · Backend testing | [set-12-solutions.md](set-12-solutions.md) |

**About reference transcripts:** where a solution quotes output, it is the authoring
machine's real capture — the layered probe's trace, the Spring Boot profile and fail-fast
runs, the JPA query-count battery (6 selects vs 1), the executed OIDC code+PKCE flow with
three rejected attacks, the upload/cache/job batteries, the logging runs A/B/C with the
`grep -c password` result, and the final `mvn test` summary (`15 tests, 0 failures, 0
errors`). Where a solution gives a *shape* (an endpoint table, a matrix, a checklist), no
single correct text exists — the criteria in the set's [README](../README.md) define what
a reviewer looks for.

**Executed corrections worth knowing** (re-verified while writing these solutions):
Spring Boot 4 **modularized** the test stack — `@AutoConfigureMockMvc` moved to the
`spring-boot-webmvc-test` module and is *not* in `spring-boot-starter-test`, so a
`package does not exist` error means a missing dependency, not a wrong import; Spring Data
JPA 4 renamed the `@EntityGraph` element (it is `value` now) and derived query names can
trip PartTree parsing — an explicit `@Query` with `join fetch` is the honest fix, not a
guessed method name; a readiness grep for the `Started …` banner **silently hangs forever**
when your level override suppresses that logger's package (probe an HTTP endpoint or a
framework logger instead); `JsonPath.read` returns `Object`, so `assertEquals` on it is
ambiguous until you cast — the compiler is right; and on Windows a `kill` of the JVM does
not land — `taskkill //F //PID` does, or your lab port stays held and the next run dies
with *port already in use*.
