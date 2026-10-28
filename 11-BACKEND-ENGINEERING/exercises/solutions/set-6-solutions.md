# Set 6 solutions — Dependency injection · Controllers, services, repositories → `dependency-injection.md` · `controllers-services-repositories.md`

*Executed in the batch's `spring-smoke` lab and the `OrderServiceTest` unit tests
(`mvn test`: 4 tests, 0.017 s for the service class alone).*

## 1. Constructor injection of an interface

The seam: `Pricing` interface with `BigDecimal priceOf(String sku)`; production bean
`DbPricing`, test double `FixedPricing(9.99)`. App run captured real prices; test run:

```java
Pricing pricing = new FixedPricing(new BigDecimal("9.99"));   // plain new — no Spring
assertThat(service.quote("ANYTHING").cents()).isEqualTo(999);
```

The rule, written: *production code depends on abstractions the test can replace* — the
interface is the seam, constructor injection is what makes the seam passable without a
container. The field-injection attempt: `@Autowired private Pricing pricing;` compiles
fine, but the field is `null` in a `new OrderService()` and only the container fills it —
so the test needs `@SpringBootTest` (15 s) or reflection hacks, versus 0.017 s. That
measured delta (880×) is the whole argument.

## 2. Layer discipline audit

The transgression, quoted from the copied controller:

```java
@Autowired JdbcTemplate jdbc;                      // inside OrderController
var rows = jdbc.queryForList("select * from orders where id=" + id);
```

Fix: `OrderService.findById(id)` → `OrderRepository.findById(id)`; the controller now
takes `OrderService` only. The test that proves the service owns the rule (executed):

```java
assertTrue(svc.find(id, "bea", false).isEmpty(), "foreign reader gets empty");
```

This test imports neither HTTP nor JDBC — if ownership logic drifts back up into the
controller, the test still passes (it tests the right layer), and a *contract* test
(set 12's drill) catches the wire. One test per layer, each guarding its own boundary.

## 3. Transaction boundary, rollback proven

Service writes `orders` then `order_lines`, second insert throws. Captured:

```
count(*) before: 5
count(*) after:  5     -- @Transactional rolled the pair back
```

Boundary drawn on the stack: the `@Transactional` proxy wraps the *service method* —
commit at its normal return, rollback on its unchecked exception propagating out. The
"annotation silently did nothing" case, executed: a method calling **itself**
(`this.doWrite()`) bypasses the proxy entirely — capture showed 1 row present after the
"rollback" (the write committed because no transaction wrapped it). Fix: self-invocation
moved to the calling bean, or the write method moved behind its own bean; lesson named:
the proxy is the transaction, and proxies only intercept calls that arrive from outside.

## 4. Independent — concern placement (reference shape)

The table I wrote (same shape as set 4's, tightened): auth check → security filter
(AuthN) and **service** (AuthZ); validation → web; pagination → web parse / repository
execute; persistence → repository; logging → correlation filter + layer loggers; caching
→ service (decorating the repository call, so a cache hit skips the same seam the test
mocks); retry → edge of the outbound call, not around the whole service (a retry that
wraps business logic re-runs non-idempotent rules).

Two implemented: service-layer caching (a `Map` behind the `Pricing` interface) and
repository pagination. Two tests, each stating its context: `PricingCacheTest` — plain
`new`, no context, 0.01 s, asserts miss→populate→hit→invalidate; `PageRepoTest` —
`@DataJpaTest`-shaped slice needing the database. The point rehearsed: five of six
concerns should be testable without booting anything.