# 09 — Frontend Engineering

This subject teaches professional frontend development with React — built directly on the HTML,
CSS, JavaScript, and TypeScript you already have. React does not replace any of them; it
structures how your *behavior* updates what the browser renders.

## What this subject covers

- React fundamentals: the rendering model, JSX as a function call, components as pure functions of
  props.
- Components and props: data down, events up, and composition over configuration.
- State and hooks: `useState`, `useEffect`, `useMemo`, `useCallback`, `useRef` — what each is for
  and when each is unnecessary.
- Component composition: children, slots, and the "lift state up" discipline.
- Routing: client-side routing, nested routes, data loaders, and the back-button contract.
- Forms: controlled inputs, validation strategy, and submission handling.
- State management: local state → context → external stores, each with its honest cost.
- API integration: fetching, caching, retries, and cancellation.
- Frontend authentication: token storage trade-offs, refresh flows, route guards.
- Error and loading states: skeletons, empty states, error boundaries, and retries.
- Reusable components and design systems: APIs of components, variants, tokens.
- Performance: measurement first, then memoization, bundle size, and rendering cost.
- Accessibility: the frontend-specific layer on top of subject 07.
- Testing: Vitest + React Testing Library, testing behavior not implementation.
- Build and deployment: Vite production builds, environments, and shipping.

## Why it matters

Frontend is where architectural discipline meets user perception: a component that re-renders 200
times per second, an error state that shows nothing, or an inaccessible form is a product failure
no backend can fix. The React ecosystem is also the industry's largest frontend job market — but
the durable skill being taught here is component design, state modeling, and measurement-driven
optimization, which transfer to any framework.

## Prerequisites

- [08-JAVASCRIPT-AND-TYPESCRIPT](../08-JAVASCRIPT-AND-TYPESCRIPT/README.md) — you must be fluent in
  modern JS and comfortable with types before the framework's abstractions make sense.
- [07-HTML-AND-CSS](../07-HTML-AND-CSS/README.md) — semantics, layout, and accessibility.

## Lessons

Examples use React 19 with the Vite `react-ts` template and Vitest; versions pinned in
[VERSIONS.md](../VERSIONS.md).

- `react-fundamentals.md` · `components-and-props.md` · `state-and-hooks.md`
- `component-composition.md` · `routing.md` · `forms.md` · `state-management.md`
- `api-integration.md` · `frontend-authentication.md` · `error-and-loading-states.md`
- `reusable-components.md` · `design-systems.md` · `performance.md` · `accessibility.md`
- `frontend-testing.md` · `build-and-deployment.md`

## Exercises and practice

Each lesson ships a small runnable exercise; `projects/` holds the briefs that combine them (a
paginated data table with filtering, a form-driven wizard with validation, a token-authenticated
dashboard with loading/error/empty states). Acceptance criteria include keyboard operation, test
passing, and no `any` in your own code.

## Expected outcomes

You can model a screen as a component tree with unidirectional state; implement every state a real
data view has (loading, empty, error, success, retry); integrate an API with cancellation and
caching; store credentials with a justified trade-off written down; measure and fix one real
performance problem; and write component tests that fail when behavior regresses.

## Common blockers

- **Effects for derived data.** If a value can be computed during render, computing it in an effect
  is a bug generator. The lesson on hooks makes the rule mechanical.
- **Context as a global variable.** Context distributes values; it is not a state manager. Reach
  for it when the cost is acceptable, and know when it isn't.
- **Testing implementation.** A test that breaks when a component is refactored correctly is
  testing the wrong thing.

## Next

[10-DATABASE-ENGINEERING](../10-DATABASE-ENGINEERING/README.md) — the other half of every
application: where the data actually lives and how to model it correctly.