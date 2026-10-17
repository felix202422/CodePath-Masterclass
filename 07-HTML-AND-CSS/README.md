# 07 — HTML and CSS

The two languages every web developer uses every day, and the two most often learned badly. HTML
gives a page structure and meaning; CSS gives it presentation and layout. This subject teaches
both as the design systems they really are, not as tag-and-color collection.

## What this subject covers

- HTML fundamentals: documents, elements, attributes, nesting, and validity.
- Semantic HTML: `header`, `nav`, `main`, `article`, `section`, `footer`, headings — and why
  semantics are an accessibility and SEO feature, not decoration.
- Forms and validation: form structure, input types, constraints, and the accessibility of each.
- CSS fundamentals: the cascade, specificity, selectors, custom properties.
- The box model: content, padding, border, margin, and `box-sizing`.
- Flexbox: one-dimensional layout with a mental model you can predict from.
- CSS Grid: two-dimensional layout, tracks, and placement.
- Responsive design: media queries, fluid units, breakpoints that follow content.
- Typography and design tokens: type scales, spacing scales, and reusable variables.
- Accessibility: keyboard access, contrast, ARIA (and when *not* to use it), screen-reader behavior.

## Why it matters

Frameworks come and go; these two languages remain, and framework output is HTML and CSS
underneath. Layout is the single most Googled beginner topic on the web, and the difference between
"adjusting pixels until it looks right" and *predicting* layout is this subject. Accessibility is
included here — not later — because retrofitting it is an order of magnitude harder than building
it in.

## Prerequisites

- [06-INTERNET-AND-WEB-FOUNDATIONS](../06-INTERNET-AND-WEB-FOUNDATIONS/README.md) — you need to know
  what the browser receives and does with a document.

## Lessons

- `html-fundamentals.md` · `semantic-html.md` · `forms-and-validation.md`
- `css-fundamentals.md` · `box-model.md` · `flexbox.md` · `css-grid.md`
- `responsive-design.md` · `typography-and-design-tokens.md` · `accessibility.md`

## Exercises and practice

`projects/` contains progressively harder build briefs (a semantic article page, a responsive
navigation, a form-heavy settings screen) with acceptance criteria written the way a reviewer
would check them: works at 360 px and 1440 px, keyboard-navigable, headings in order, contrast
passes. Project 02 of the laboratory is the subject's full expression.

## Expected outcomes

You can build a semantic, accessible page from a wireframe; implement any layout with Flexbox or
Grid *without* trial and error; state the cascade/specificity rules that produced a given result;
and audit an existing page for the top accessibility failures and fix each.

## Common blockers

- **Div-soup.** Using `<div>` everywhere costs you accessibility and search ranking for nothing.
  Semantics are free.
- **Pixel-pushing.** If you are nudging margins to fix a layout, you have a mental-model gap in
  Flexbox or Grid. Go back to the rule, not the value.
- **Learning frameworks first.** React emits HTML and CSS; a framework cannot rescue markup you
  do not understand.

## Next

[08-JAVASCRIPT-AND-TYPESCRIPT](../08-JAVASCRIPT-AND-TYPESCRIPT/README.md) — make the document
behave, then make your behavior type-checked.