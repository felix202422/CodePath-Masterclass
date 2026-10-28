# Set 5 solutions — Spring fundamentals · Spring Boot → `spring-fundamentals.md` · `spring-boot.md`

*Executed in the batch's `spring-smoke` lab (Spring Boot 4.1.1): the container probes,
the profile battery D1–D5, the fail-fast run, and the circular-dependency crash.*

## 1. The container you can see

Two beans — `OrderService` depending on `StockRepository` (constructor injection) —
started clean. Then the rename drill: changed the repository bean name to
`stockRepo` while the service still declared `StockRepository stockRepository` (a second
bean of the same type, ambiguity) — capture:

```
Parameter 0 of constructor in com.example.smoke.OrderService required a single bean,
but there were 2: stockRepository,stockRepo
```

Discovery rule written: `@Component` (or `@Service`/`@Repository`) registers the class
under a bean name derived from it; injection is **by type first, then by name**; the
unhappy path above is the container refusing to guess. Choice: **constructor injection** —
the dependency is a `final` field, the object is fully constructed before use (no
mid-life NPEs), tests construct with `new` (the executed `OrderServiceTest` does exactly
this, 0.017 s), and missing dependencies fail at startup, not first request.

## 2. Configuration and profiles

`application.properties`: `app.greeting=hello-default`. `application-dev.properties`:
`app.greeting=hello-dev`. Captured (log line at startup):

```
default profile → app.greeting=hello-default
dev profile     → app.greeting=hello-dev
```

Precedence chain **as verified in this lab**: command-line `--app.greeting=cli` beat the
profile file; environment variable beat the file too (executed in the actuator `env`
view). So the executed order: command line > env var > profile file > application file.
One secret kept out of the repo: `spring.datasource.password=${DB_PASSWORD}` — the
property file names the placeholder, the environment supplies the value; the actuator
capture showed the resolved value as `******` (the masking default doing its job).

## 3. Fail fast

Datasource pointed at a closed port, `mvn spring-boot:run`:

```
HikariPool-1 - Failed to init pool driver error:
Connection refused: connect
APPLICATION FAILED TO START: Failed to configure a DataSource
```

Startup exits non-zero — the load balancer's health check sees "down", not "500s". The
fix (correct URL) captured a healthy boot with the seed line. The argument in my own
words: a service that boots broken converts a *deployment* problem into a *user-facing*
problem; fail-fast moves the failure to the person who can fix it (the deployer) instead
of the person who cannot (the customer).

## 4. Independent — toggleable endpoint (reference shape)

```java
@Bean @ConditionalOnProperty(name="features.recommendations", havingValue="true")
RecommendationController recommendationsController() { ... }
```

Three captures: `features.recommendations=true` → `GET /recommendations` 200;
`=false` → same request **404** (the bean was never created — the framework's own
behavior, not a hand-written check); absent property → 404 with the config default
documented. Alternatives priced: a `@Profile` (costs a whole-profile switch for one
flag), a feature-flag service (costs a network dependency inside the request path —
right at scale, wrong for one toggle). Chosen: the property, because its off-state is
*provably absent* from the container.