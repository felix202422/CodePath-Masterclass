# Reference solution guide — Project 02

> **Stop.** Attempt the brief and run the acceptance criteria before reading this. The value of this
> project is in the mark-up and token decisions you make; a guide read first turns them into a
> checklist you follow without understanding.

One defensible solution, described by its decisions rather than its file contents. There is no full
source here: the CSS is the exercise.

## Document structure

The page is a single document with five landmarks and a strict heading outline:

```text
<a class="skip" href="#main">Skip to content</a>
<header>  name, role, nav (3 links)  </header>
<main id="main">
  <section aria-labelledby="intro-title">   h1 pitch, contact CTA
  <section aria-labelledby="work-title">    h2 "Work", list of articles, h3 each
  <section aria-labelledby="about-title">   h2 "About"
  <section aria-labelledby="contact-title"> h2 "Contact"
</main>
<footer>  copyright, theme toggle or toggle in header </footer>
```

Two details carry most of the accessibility score. The skip link is the **first** focusable element and
becomes visible on `:focus`, not `:focus-visible` — a keyboard user needs to see it, and a mouse user
never focuses it. And each `<section>` is labelled by its own heading with `aria-labelledby`, which
gives screen-reader users a landmark list that matches the visible outline.

Project cards are `<article>` inside a `<ul>`: the list tells assistive technology how many there are,
the article gives each a name from its heading. A grid of `<div>`s fails `AC-5` on the "list not
announced" rule, which is easy to miss because it looks identical.

## Tokens and the cascade

Four layers, loaded in order: `reset.css`, `tokens.css`, `layout.css`, `components.css`.

```css
:root {
  --step-0: clamp(1rem, 0.95rem + 0.25vw, 1.125rem);
  --step-3: clamp(2rem, 1.4rem + 3vw, 3.5rem);
  --measure: 65ch;
  --space-2: 0.5rem;
  --space-4: 1rem;
  --colour-bg: #fbfaf8;
  --colour-fg: #1b1a17;
  --colour-accent: #7a3e00;
}
[data-theme="dark"] {
  --colour-bg: #16151a;
  --colour-fg: #ece9e4;
  --colour-accent: #ffb86b;
}
```

The type scale uses `clamp()` so the four-width requirement needs no font-size media queries at all —
one of the two places where the modern CSS features earn their keep. The colour pairs are chosen for
4.5:1 in both themes; the accent is darker in light mode and lighter in dark mode, which is why a
single accent variable cannot serve both.

Layout is grid with `auto-fit`:

```css
.projects { display: grid; gap: var(--space-4);
            grid-template-columns: repeat(auto-fit, minmax(min(100%, 18rem), 1fr)); }
```

`minmax(min(100%, 18rem), 1fr)` is the whole responsive story: one column when the container is
narrower than 18rem, as many as fit otherwise. No breakpoints, no overflow at 360 px, and a readable
measure from `--measure` on prose.

## Theming script

Small, defer-loaded, and correct on first paint:

```js
const root = document.documentElement;
const stored = localStorage.getItem("theme");
const system = matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light";
root.dataset.theme = stored ?? system;
```

The trap is the flash of the wrong theme. A solution that sets the theme on `DOMContentLoaded` paints
light first and then flips, which fails `NFR-4` (layout shift is zero, but the visual flash is still a
defect a reviewer sees). The fix is either a tiny inline script in `<head>` — allowed only if the CSP
permits a hash — or, better, defaulting the CSS to the system preference and using `data-theme` only
for an explicit override. The second approach keeps the CSP strict and removes the flash entirely,
which is why the guide recommends it.

The toggle must expose state: `aria-pressed` on a button, with the label changing between "Switch to
dark theme" and "Switch to light theme" — not an icon whose meaning depends on colour.

## Performance

The three wins, in order of size:

1. **No webfont.** Use a system font stack. A webfont costs a render-blocking request and 30–100 KB,
   and `NFR-1` is much harder with one.
2. **Sized images.** `width`/`height` attributes or `aspect-ratio` prevent layout shift; `loading="lazy"`
   on the portrait keeps it out of the critical path.
3. **One CSS file in production.** Four files are fine for authoring; concatenating them (a two-line
   script or a manual step) removes three requests. Since there is no build step, the guide keeps four
   files and accepts the requests — document the choice.

## Audit loop

Run the audit in this order, because each step changes the next:

1. W3C validator — fix all errors before touching CSS.
2. axe-core with JS disabled — catches semantics, labels, contrast, heading order.
3. Keyboard walkthrough — tab through, confirm focus is always visible and order matches reading order.
4. Lighthouse mobile — performance, accessibility, best practices.
5. Screenshot at 360 / 768 / 1024 / 1440 — check measure and overflow.

The order matters because contrast fixes can change the visual system, and structural fixes can change
the headings an axe run reports.

## Trade-offs and alternatives

- **Mobile-first versus desktop-first.** Mobile-first produces simpler overrides for this page; a
  desktop-first cascade needs more `max-width` corrections and tends to accumulate `!important`.
- **`auto-fit` grid versus media queries.** The grid is fewer lines and handles unexpected widths; media
  queries give more control over the 768 px two-column layout. Both pass; the grid is easier to defend.
- **System-preference only, no toggle.** Simplest and most accessible; loses the explicit control some
  visitors expect. The brief requires a toggle, so the guide shows the low-flash version.
- **CSS custom properties versus a class-based theme.** Properties are fewer moving parts; classes make
  the current theme visible in the DOM inspector. Either is fine; the guide uses properties.

## What is deliberately missing

The finished HTML and CSS. The structural outline and the token layer above are the parts that are
hard to get right the first time, and they are specified; the rest is the project. A reviewer will ask
why `auto-fit` rather than three media queries — have an answer.
