# 08 — JavaScript and TypeScript

JavaScript makes a page behave; TypeScript makes that behavior accountable. This subject covers
both in order — modern JavaScript first (values, functions, the DOM, modules, asynchrony, errors),
then the type system that has become the industry's default way to write it.

## What this subject covers

- JavaScript fundamentals: values, variables, coercion, equality, functions, closures, and scope.
- Arrays and objects: the operations you will use daily, plus the immutability habits that prevent
  whole bug classes.
- The DOM and events: selecting, creating, and updating elements; event propagation; listeners.
- Modules: `import`/`export`, module resolution, and organizing code across files.
- Promises and `async`/`await`: asynchronous work, error propagation, `Promise.all` and friends.
- The event loop: tasks, microtasks, and why `setTimeout(fn, 0)` runs last.
- Error handling: `try`/`catch`, custom errors, and designing failure paths.
- TypeScript fundamentals: why types exist, type annotations, inference, and the compiler workflow.
- Types and interfaces: structural typing, unions, literals, and modeling data honestly.
- Generics and type narrowing: reusable components with strong guarantees.

## Why it matters

You cannot debug what you do not understand, and JavaScript's async model is the most misunderstood
part of the language. The DOM lessons give you the mental model React abstracts over — without it,
framework errors are unfixable. TypeScript is now the default in professional frontend work
(React 19, Vite templates, major codebases), and its type system is where design decisions get
caught *before* users do.

## Prerequisites

- [07-HTML-AND-CSS](../07-HTML-AND-CSS/README.md) — you manipulate markup you could write by hand.
- [02-PROGRAMMING-FUNDAMENTALS](../02-PROGRAMMING-FUNDAMENTALS/README.md) — functions, loops, and
  data structures are assumed.

## Lessons

- `javascript-fundamentals.md` · `functions-and-scope.md` · `arrays-and-objects.md`
- `dom-and-events.md` · `modules.md`
- `promises-and-async-await.md` · `event-loop.md` · `error-handling.md`
- `typescript-fundamentals.md` · `types-and-interfaces.md` · `generics.md` · `type-narrowing.md`

## Exercises and practice

`exercises/` covers each area with runnable snippets and browser-console work: predict the output of
scope and event-loop puzzles before running them, build small interactive widgets in plain
JavaScript, convert a JavaScript module to TypeScript and remove every `any`, and diagnose
deliberately async-broken code. Every set ends with an independent task (e.g. a small
state-driven widget with tests).

## Expected outcomes

You can read an unfamiliar async codebase and state what runs when; build a DOM-driven widget
without a framework; convert a JavaScript file to TypeScript with strict types and no suppression
comments; and explain the event loop well enough to predict the order of five mixed callbacks.

## Common blockers

- **`var` habits and implicit coercion.** Use `const`/`let` by default and strict equality; the
  language's most confusing corners stop being reachable.
- **`async` misuse.** Forgetting `await` returns a Promise, not a value — and un-awaited promises
  fail silently. This is the single most common JavaScript bug in industry code.
- **TypeScript as a linter.** The goal is a program the compiler cannot complain about, not
  suppression comments.

## Next

[09-FRONTEND-ENGINEERING](../09-FRONTEND-ENGINEERING/README.md) — React, with everything you have
learned still underneath it.