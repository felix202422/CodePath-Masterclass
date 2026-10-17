# 14 — Testing and Quality

Tests are how a team keeps making changes without fear. This subject teaches the test pyramid,
test doubles, TDD, and the quality gates that put testing into a pipeline — with real examples in
Java, React, and Flutter, and an honest treatment of what coverage does *not* tell you.

## What this subject covers

- Testing fundamentals: what a test is, arrange–act–assert, and the properties of a good test.
- Testable code: seams, dependency direction, and refactoring for testability.
- Unit testing: fast, isolated tests; test behavior, not implementation.
- Integration testing: databases, APIs, and Testcontainers for realistic environments.
- End-to-end testing: browser-level tests, their power and their fragility.
- Mocking and test doubles: stubs, spies, fakes, mocks — and when mocking proves nothing.
- Test-driven development: red–green–refactor as a design tool, honestly assessed.
- Regression testing: the safety net's actual purpose.
- API testing: contract assertions, status codes, and authz checks as tests.
- Frontend testing: Vitest + React Testing Library, user-centric queries.
- Mobile testing: unit, widget, and integration levels in Flutter.
- Performance testing: latency and throughput budgets, and where they belong.
- Security testing: automated checks that catch the vulnerability classes of subject 15.
- Test coverage: interpreting the number, and the false confidence it invites.
- Quality gates: what a CI pipeline should enforce and what it should not.

## Why it matters

Without tests, every change is a gamble and every refactor is a rewrite. With badly designed tests,
you have a slow, brittle suite that still misses the failures that matter — which is worse,
because it manufactures confidence. This subject is placed after architecture (you need structure
to test) and before security (security is verified by tests and labs), and it feeds directly into
CI/CD in subject 16.

## Prerequisites

- [04-JAVA-PROGRAMMING](../04-JAVA-PROGRAMMING/README.md) — Java examples use JUnit 5.
- [09-FRONTEND-ENGINEERING](../09-FRONTEND-ENGINEERING/README.md) — React examples use Vitest and
  React Testing Library.
- [11-BACKEND-ENGINEERING](../11-BACKEND-ENGINEERING/README.md) — integration tests exercise a real
  Spring Boot application.

## Lessons

- `testing-fundamentals.md` · `unit-testing.md` · `integration-testing.md`
- `end-to-end-testing.md` · `mocking-and-test-doubles.md` · `test-driven-development.md`
- `api-testing.md` · `performance-testing.md` · `security-testing.md`
- `test-coverage.md` · `quality-gates.md`

## Exercises and practice

You write tests at all three levels against the subject 11 application and the subject 09 frontend:
a unit suite for a pure function; an integration test that proves transaction rollback; an API test
covering success, validation failure, and authorization denial; a React component test that fails
when behavior regresses; a deliberately flaky E2E test you must stabilize. Each exercise states the
failure class it can and cannot detect.

## Expected outcomes

You can design a test strategy naming which level tests which requirement; write tests that fail
for the right reasons; choose between a fake and a mock and justify it; interpret a coverage report
skeptically; and configure a CI quality gate that blocks regressions without blocking progress.

## Common blockers

- **Testing implementation details.** Tests coupled to internals break on correct refactors. Query
  by role and label instead.
- **Coverage as a target.** Coverage measures what executed, never what was asserted. A 95% suite
  can miss every security bug you have.
- **TDD as ritual.** TDD is a design feedback loop. When the test is hard to write, the design is
  telling you something — listen, or skip the ritual and keep the lesson.

## Next

[15-APPLICATION-SECURITY](../15-APPLICATION-SECURITY/README.md) — the failures your tests have not
been looking for, and how to design them out from the start.