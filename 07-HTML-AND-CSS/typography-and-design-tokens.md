# Typography and Design Tokens

## 1. Learning Objectives

After this lesson you can:

- [ ] Build a modular type scale from a base size and ratio, and verify each step's computed value (`base × ratio^n`)
- [ ] Choose line-height and measure (line length) values from readable defaults and justify each with its computed evidence
- [ ] Use `rem` correctly for type (and say why `px` for font size is an accessibility cost), including what `em`-based letter-spacing resolves against
- [ ] Organize design values as token layers — type scale, spacing scale, radii, color — in custom properties, with the rules for naming and where tokens live
- [ ] Read a computed-style probe of a type system and detect scale drift (a size not on the scale, a stray line-height)

## 2. Prerequisites

- [CSS Fundamentals](css-fundamentals.md) — custom properties and inheritance (tokens *are* that mechanism)
- [Responsive Design](responsive-design.md) — `clamp()` and `rem` behavior across widths

## 3. Introduction

Typography is 90% of most interfaces — and the difference between "the text is on a page" and
"the page reads well" is arithmetic: a scale for sizes, a rhythm for line-height, a cap for
line length, and a single source for each number. This lesson treats those numbers as a
*system* (design tokens) and proves the arithmetic against a browser: every value in the
executed transcript below is `base × ratio^n` or a derived unit, checked to the pixel.

## 4. The Problem It Solves

Two failure modes make interfaces feel amateur:

**Arbitrary values.** Sizes chosen by eye — 13px here, 17px there, `line-height: 1.4` in one
component and 16px in another — produce pages that look *almost* right and never cohere.
Between two arbitrary sizes there is no relationship a reader (or a maintainer) can feel;
relationships are what make hierarchy legible and changes safe. The fix is a **modular scale**:
one base, one ratio, every size a step. Then "make the heading bigger" moves the *ratio*, not
one heading — and the whole page stays coherent.

**Duplication without a source.** The same value re-declared across files (a brand color in
twelve rules, `16px` everywhere, a spacing magic number per component) means every design
change is a search-and-replace gamble. The fix is **tokens**: named values in one place,
consumed by reference — which the previous lesson executed as custom properties (`--brand`
inherited and overridden per subtree). Design systems (subject 09) scale this to hundreds of
tokens; this lesson teaches the *shape*: what to tokenize, what naming keeps them navigable,
and how type and spacing scales interact with responsive design.

## 5. Core Concepts

### The modular scale

A scale = **base size** × **ratio**, stepped for each level:

| Ratio name | Value | Character |
|---|---|---|
| Minor second | 1.067 | very fine steps (dense UI) |
| Major second | 1.125 | subtle |
| Minor third | 1.2 | common for UI |
| **Major third** | **1.25** | **the lab's — clear hierarchy without drama** |
| Perfect fourth | 1.333 | editorial, assertive |
| Golden ratio | 1.618 | display/h1 emphasis (large jumps) |

Sizes: `step(n) = base × ratio^n` (n can be negative for smaller-than-base). The lab page
used `--base: 16px`, `--step: 1.25` with `calc()` — executed verification in section 6:
h2 = `16 × 1.25² = 25px`, h1 = `16 × 1.25³ = 31.25px`, exactly. The scale's property: *every
size is expressible*, so CSS can compute them (no hand-typed list) and reviews can check
membership ("25px is step 2; where did 26px come from?").

**Semantic layers above the raw scale:** a design system maps raw steps to roles
(`--text-sm`, `--text-body`, `--text-h3`, `--text-h1`) so components ask for *roles*, not
numbers — the scale can then change (a re-based system) without touching a single component
rule. Tokens-with-roles is the entire idea behind "design token" tooling.

### Line-height: unitless and stepped

- **Unitless values are per-element ratios of that element's font size** (`line-height: 1.5`
  on 16px → 24px; on 31.25px → 47.6px if inherited as the *number* — but note: a unitless
  value *computes* per element, a length computes once and inherits as a length). This is why
  unitless wins: headings keep tight leading (`1.2`), body keeps generous (`1.5`–`1.7`), and
  **the child does the math** instead of inheriting a fixed 24px box around 40px text.
- Ladder by role: display/h1 ≈ 1.1–1.2, h2 ≈ 1.25, body 1.5–1.7, small text (needs *more*
  leading) 1.5+. The executed transcript shows the lab's ladder computing exactly: 24px body
  (1.5 × 16), 37.5px h1 (1.2 × 31.25), 31.25px h2 (1.25 × 25).
- Spacing *between blocks* (paragraph gaps) belongs to margins/`gap`, not line-height —
  leading is within-block rhythm (and doesn't collapse across blocks — lesson 5's margin
  collapse is the between-block mechanism).

### Measure: the line-length cap

Readability research converges on ~45–75 characters per line; the lab used **66ch** as
`max-width`. The `ch` unit = width of the `0` glyph in the *element's current font* — so the
cap *scales with font and family* (a measure set in px would not). Executed: `.measure`
computed `648.141px` for `66ch` in Georgia at 16px (⇒ `ch ≈ 9.82px`). A wider container
without a cap produces 120-character lines where the eye loses the row return — which is why
the `.measure` cap appears in every lesson's page shell (responsive lesson's Example 2
included it in *every* state).

### rem, em, px — by role

- **`rem` for font sizes** (`html { font-size: 100% }` default): user browser settings scale
  the whole system — someone who set "minimum font size 18px" or uses a custom default gets
  *all* type scaled, because every rem resolves against the root. **`px` font-size opts out of
  user preferences** (it's a fixed box) — WCAG 1.4.4 (resize text) and 1.4.12 (text spacing)
  make this a real compliance question: rem type is the accessible default, and it's why the
  lab's `.lede` was written `1.25rem`.
- **`em` for within-element spacing tied to text** — letter-spacing in the transcript is
  `0.01em` and *computed against the element's own size* (20px → `0.2px` — see section 6's
  line: the em resolved against `.lede`, not the root). Padding in em makes a component's
  breathing room scale with its text; up the tree it *compounds*, which is the em footgun.
- **px for borders, hairlines, shadows, and fixed UI geometry** — sub-pixel precision where
  user-scaling either doesn't apply or is handled by zoom (which scales everything anyway).

### Token layers (what gets a name)

| Layer | Examples | Where |
|---|---|---|
| Primitive | `--gray-700: #595959`, `--space-4: 16px`, `--radius-md: 6px` | raw values, one vocabulary |
| Semantic/role | `--text-body`, `--text-h1`, `--space-section`, `--color-text-muted` | *what it's for* |
| Component | `--card-padding`, `--btn-bg` | scoped to one widget (`:root`-adjacent or the component's block) |

Rules that keep tokens sane: **consume by role, define by primitive** (components never
reference `--gray-700` directly for text — they use `--color-text`, which *maps* to a
primitive; theming then swaps the map, exactly as the executed `--brand` override did);
**spaces and type steps align to the scale** (every spacing = `--space-n` where n steps the
spacing ratio — 4px/8px base grids are scale thinking); **two values that always change
together are one token** — the drift detector in section 7 enforces membership.

## 6. How It Works

### The scale, executed and verified

Lab page (headless Chrome 156, authoring machine):

```css
:root { --base: 16px; --step: 1.25; }
body  { font-size: var(--base); line-height: 1.5; }
h1    { font-size: calc(var(--base) * var(--step) * var(--step) * var(--step)); line-height: 1.2; }
h2    { font-size: calc(var(--base) * var(--step) * var(--step));               line-height: 1.25; }
p.lede { font-size: 1.25rem; letter-spacing: 0.01em; }
.measure { max-width: 66ch; }
```

Full executed output (each line carries its own arithmetic check):

```console
body font-size = 16px (line-height 24px)
h1 font-size = 31.25px (16 * 1.25^3 = 31.25px) lineHeight = 37.5px
h2 font-size = 25px (16 * 1.25^2 = 25px) lineHeight = 31.25px
.lede font-size = 20px (1.25rem = 20px at this root)
letter-spacing = 0.2px
.measure computed width = 648.141px (66ch cap at this font)
```

Line by line:

1. **Body: `16px` / `24px`** — `--base` resolved (token → computed), line-height `1.5`
   computed as a length *for this element*: `1.5 × 16 = 24` ✓. 24px is the rhythm every
   in-block spacing decision is measured against.
2. **h1: `31.25px`, predicted `31.25`** — `calc(16 × 1.25³) = 31.25` ✓ *exact*: the browser's
   calc and the hand math agree to the decimal (and would round at paint — computed values
   keep fractions). Line-height `1.2 × 31.25 = 37.5` ✓ — tighter than body, per the ladder.
3. **h2: `25px` = `16 × 1.25²`** ✓, leading `1.25 × 25 = 31.25` ✓ — step 2 sits *between*
   body and h1, which is what a scale *is*: no value without a rank.
4. **`.lede: 20px`** — `1.25rem` at root 16 = `20px` ✓; rem resolved against `:root`, not the
   paragraph's context (the root-resolution rule, visible).
5. **`letter-spacing: 0.2px`** — `0.01em` resolved against **`.lede`'s own 20px** (em =
   element's font size): `0.01 × 20 = 0.2` ✓ — the contrast with rem in the previous line is
   the em-vs-rem distinction *executed on the same element*.
6. **`.measure: 648.141px` for `66ch`** — `648.141 / 66 = 9.8203…` px per `ch` (Georgia's `0`
   at 16px). The cap is font-relative: switch `font-family` and the cap moves with the glyph —
   by design (measure is about *characters*, not pixels).

The whole system: **six computed values, six derivations, zero unexplained numbers.** That is
the standard your own pages should meet — a type system you can't verify by arithmetic is a
type system you can't review.

### Tokens in practice: the block that earns its name

```css
:root {
  /* primitives — the only place raw values appear */
  --gray-900: #1a1a1a;  --gray-700: #595959;  --gray-200: #e6e6e6;
  --green-600: #2a6;
  --space-1: 4px;  --space-2: 8px;  --space-3: 16px;  --space-4: 24px;  --space-5: 32px;
  --radius-sm: 4px; --radius-md: 6px;

  /* semantic roles — what components consume */
  --font-body: 1rem;
  --text-sm: 0.875rem;      /* step −1 */
  --text-body: 1rem;        /* step 0  */
  --text-h2: 1.5625rem;     /* step 2  (25px at root 16 — the executed value) */
  --text-h1: 1.9531rem;     /* step 3  (31.25px — executed) */
  --leading-body: 1.5;
  --color-text: var(--gray-900);
  --color-text-muted: var(--gray-700);   /* #595959 = the 7.00:1 grey (section 8) */
  --space-section: var(--space-5);
}

h1 { font-size: var(--text-h1); line-height: 1.2; }
p  { font-size: var(--text-body); line-height: var(--leading-body); }
.muted { color: var(--color-text-muted); }
```

- The **executed px values appear as rem steps**: `25px = 1.5625rem`, `31.25px = 1.9531rem`
  (÷16) — a rem-native scale preserves the arithmetic while inheriting user zoom (section 5).
- Components reference *roles*; a dark theme or a re-based scale edits the map
  (the `data-theme` block of lesson 4), not the components — the executed `--brand` pair is
  this pattern at n=1.
- `--gray-700: #595959` is the exact grey the accessibility lesson's good page executed at
  **7.00:1** contrast — token choice *is* an accessibility decision, made once here rather
  than per component.

## 7. Practical Examples

**Example 1 — the type-system probe (scale drift detector)**

```javascript
const typeProbe = sel => {
  const gs = el => getComputedStyle(el);
  const root = parseFloat(gs(document.documentElement).fontSize);
  return [...document.querySelectorAll(sel)].map(el => {
    const cs = gs(el);
    const px = parseFloat(cs.fontSize);
    const step = Math.log(px / root) / Math.log(1.25);   // which step of a 1.25 scale?
    return `${el.tagName.toLowerCase()}.${el.className || '-'}: ` +
           `${px}px = ${px / root}rem  -> step ${step.toFixed(2)} ` +
           `(on-scale: ${Math.abs(step - Math.round(step)) < 0.02})` +
           ` | lh ${cs.lineHeight} (${(parseFloat(cs.lineHeight) / px).toFixed(2)}x)`;
  }).join('\n');
};
typeProbe('h1, h2, h3, p, .lede');
```

- **Expected output:** each line reports the element's step index on a 1.25 scale; the
  executed values come back `step 3.00 (on-scale: true)`, `step 2.00 (on-scale: true)` —
  and any hand-picked `26px` shows `step 2.24 (on-scale: false)`: **drift, named**.
- **How to run it:** devtools console on any page (or headless probe as in section 6).
  **Assumptions:** your system's ratio — change `1.25` to your scale's; elements off any
  rational step are flagged honestly (some roles *should* be off — that's a decision to
  record, not a failure).

**Example 2 — verify readability numbers on a real page**

```console
$ chrome --headless --dump-dom --virtual-time-budget=2000 file:///your.html > dom.html
# then, in the probe: measure computed font-size/line-height of body, h1, h2;
# measure .measure-style containers' computed width (expect 60-75ch ≈ 560-750px at 16px)
```

- **Expected output:** body `lh` ratio in 1.5–1.7, headings ≤1.25, capped measure ≤ ~750px at
  default size — the three numbers section 5 claims are readable, each measured not guessed.
- **How to run it:** the same probe as section 6; `px/ch = width ÷ (container font's ch)`.
- **Assumptions:** Chrome 156 (authoring machine) or any browser's devtools.

## 8. Real-World Applications

- **Design systems (subject 09) are token graphs**: Figma variables ↔ `:root` custom
  properties ↔ component styles; the role layer's *naming* (`text-body`, `space-section`) is
  the cross-team contract, and multi-theme products (dark mode, high-contrast, white-label)
  ship as alternative token maps over untouched components — the executed override, at
  production scale.
- **Responsive type** is clamp over the scale (lesson 8's `clamp(16px, 5vw, 32px)` is
  base→step-3 fluid); systems add `--text-h1: clamp(...)` roles so the *scale* responds, not
  each heading.
- **A11y compliance lives in these numbers**: `#595959` at 7.00:1 (executed) earns AAA;
  `#999999` at 2.85:1 fails AA — a *token-level* decision (`--color-text-muted`) that fixes or
  breaks every muted text instance at once (lesson 11 runs the axe counterpart). rem sizing
  (section 5) covers WCAG 1.4.4/1.4.12.
- **Content-driven products** (docs, news) depend on measure + leading + scale for long-read
  ergonomics; the `66ch` cap and the leading ladder are the read-this-for-20-minutes numbers —
  measurable, testable, and inherited by every template rendered from the system.

## 9. Common Mistakes

| Mistake | Why it happens | How to recognize it | How to prevent it |
|---|---|---|---|
| Font sizes in `px` | Precision habit, copy-pasted resets | User font settings/zoom don't scale type (WCAG 1.4.4 risk) | `rem` for all type; px only for borders/hairlines |
| Line-height as fixed length (`24px`) everywhere | "Consistent rhythm" intuition | Big headings get cramped (24px box on 40px text) — or huge gaps on small text | Unitless ratios per role; compute per element (executed: 24/37.5/31.25 from one rule each) |
| `em` compounding up the tree | Role confusion with rem | Padding sizes multiply inside nested components | `rem` up-tree (root-relative), `em` only within a component's own text relationship |
| Tokens that mirror primitives 1:1 (`--text-26px`) | Over-tokenizing values | Renaming a scale breaks every token; roles are meaningless | Name by *role/step* (`--text-h2`, `--step-2`); primitives hold raw values, roles hold meaning |
| Un-capped line length on wide screens | Container is fluid, text follows | 100+ `ch` lines in prose sections at 1440 | `max-width: 66ch`-style cap in *every* responsive state (executed `.measure` pattern) |

## 10. Best Practices

- **Write the scale as algebra, verify with the probe.** One base + one ratio + `calc()` —
  then Example 1's step-index output proves membership; any `on-scale: false` is either a bug
  or a recorded exception.
- **Lead with unitless line-heights and a role ladder** (1.2 heading / 1.5 body / 1.5+ small):
  the executed three-line ladder is the whole policy, and it survives font changes because
  the math re-runs per element.
- **Tokenize the shared numbers first**: colors (with contrast pre-checked — `--gray-700`
  at 7.00:1), space steps, radii, type roles — anything appearing ≥2× or destined to change
  per theme; leave one-offs untokenized (a token with one consumer and no theme variance is
  noise).
- **Keep `:root` ordered as a datasheet** (primitives → semantics → components) with the
  scale's algebra in a comment — the next maintainer reads the block like a spec, not a junk
  drawer.
- **Check measure and contrast on real content**, not lorem: long words, translations and real
  gray-on-white surfaces are where 66ch and 7.00:1 get tested.

## 11. Limitations and Trade-Offs

- **Ratios are taste with a methodology.** The scale makes choices *consistent*, not *right*;
  a ratio that fits editorial density may feel flat in dense UI — and jumping ratios mid-system
  (this screen 1.25, that screen 1.333) reintroduces the arbitrariness tokens exist to stop.
  One ratio (or a documented two-scale system) per product.
- **`ch` measure varies by font, weight and language.** The executed `648.141px` is Georgia
  at 16px — a wider font overshoots the px equivalent while the *character* cap holds (that's
  the point) — but CJK, which lacks `ch`-meaningful glyphs, needs a different cap entirely
  (line-height and em-based max-widths carry those layouts).
- **rem type defers to user settings — intentionally.** Users with a large default root size
  can push layouts past their designed widths: *that's the accessibility contract* (content
  reflows — lessons 8/11's reflow requirement), so shells must tolerate it; fixed-px designs
  hide the problem instead of solving it.
- **Token systems have real overhead.** Naming, mapping, and discipline cost more than they
  return on a one-page site; the inflection is when values repeat, themes arrive, or a second
  person contributes — start with the four layers of section 5, not a token pipeline.

## 12. Practical Exercises

### Introductory

1. **Exercise 7.1** — Recreate the executed scale page; reproduce all six computed lines.
   Then extend it: add an h3 at step 1 and a `--text-sm` at step −1, computing both *first*
   (predict `20px`/`12.8px` for base 16, ratio 1.25) and verifying with the probe.
   **Completion criteria:** six reproduced lines; two predictions + two verifications; the
   formula written once.
2. **Exercise 7.2** — Measure three real pages (any articles): computed body font-size,
   line-height ratio, and line length (chars per line from a paragraph's width ÷ average char
   width, or the `ch` trick). Judge each against section 5's ranges.
   **Completion criteria:** three triples captured; each judged (in-range / out) with the
   section number; one sentence on which number you'd change first on the worst page.

### Intermediate

3. **Exercise 7.3** — Run Example 1's drift detector on a stylesheet you wrote (or any CSS you
   find): report every element's step index and `on-scale` verdict; pick the two worst drifts
   and re-scale them to the nearest steps, capturing computed sizes before/after.
   **Failure to diagnose:** detector output listing steps; two re-scaled elements with
   before/after computed sizes; a screenshot pair or stated-delta note for visual impact; one
   exception you deliberately left off-scale, with a reason.
4. **Exercise 7.4** — Build the token block from section 6 (primitives → roles → components)
   and switch `data-theme="dark"` with a *role-map-only* override; capture computed
   `color`/`background-color` of two components before/after — rules unchanged, tokens swapped.
   **Failure to diagnose:** four captured values; the list of rules you did *not* edit
   (evidence); one sentence on why `--color-text-muted` had its contrast decided once
   (tie to the executed 7.00:1).

### Independent problem-solving

5. **Exercise 7.5** — *Problem:* a product has 11 hand-picked font sizes, three line-heights
   written as px, headings in px, and the same gray in nine rules — one of which (muted text
   on cards) fails contrast. Deliver: the migration — a base/ratio choice *justified from the
   product's content* (short UI labels vs long-read?), the full step table with rem values,
   the role-token structure (names for every semantic use you find), the contrast-fix as a
   token change with the ratio computed (show the math), a verification probe (which lines of
   output must show `on-scale: true` and `lh` ratios in range), and the rollout risk (what
   breaks when 11 sizes become 6 steps) with a mitigation.
   **Completion criteria:** ratio + base with content-based rationale; step table computed;
   token layers with names; contrast ratio arithmetic (≥4.5 for body, note AAA vs AA choice);
   probe output expectations stated; one named migration risk + mitigation from section 11.

*Solutions: attempt first. This subject's applied work is in [projects/](projects/README.md).*

## 13. Knowledge Check

1. In the executed transcript, why did `letter-spacing: 0.01em` compute to `0.2px` while
   `.lede`'s `1.25rem` computed to `20px` — same element, two units, what does each resolve
   against?
2. A maintainer changes `line-height: 24px` to `1.5` on body. Predict the effect on an h1
   (31.25px) that inherits — then say which design intent each choice encodes.
3. Your scale's h2 is `25px`, but CSS has `font-size: 26px` in one rule. Name the two checks
   that find this class of drift and what each output looks like.

## 14. Completion Criteria

Observable evidence that you have understood this lesson:

- [ ] You reproduced the six-line type transcript and extended the scale with verified steps (exercise 7.1)
- [ ] You measured three real pages' font/leading/measure against the readability ranges (exercise 7.2)
- [ ] You ran the drift detector and re-scaled two elements (exercise 7.3)
- [ ] You shipped a role-token theme swap with unchanged rules (exercise 7.4)
- [ ] You can diagnose all five mistakes in section 9

## 15. Summary

- A modular scale (base × ratioⁿ) makes every size rankable; the executed values (25px = step 2, 31.25px = step 3) verified the algebra to the decimal.
- Unitless line-height computes per element (executed ladder: 24 / 37.5 / 31.25); `rem` type honors user settings; `em` resolves against the element (0.01em of 20px = 0.2px — both executed).
- Cap measure in `ch` (66ch → 648.141px in Georgia) so line length follows characters, not pixels.
- Tokens: primitives define raw values once, roles carry meaning, components consume roles — themes and re-scales swap maps, not rules.
- Contrast and zoom compliance are decided at token level: `#595959` = 7.00:1 (executed) earns the muted-text role; px type sizes forfeit user scaling.

## 16. Next Steps

- Next lesson: [Accessibility](accessibility.md) — the consumers these numbers were chosen for, executed with a real audit
- Applied work: [projects/](projects/README.md) brief 1 and Project 02
- Where it is applied: [09-FRONTEND-ENGINEERING](../09-FRONTEND-ENGINEERING/README.md) (design systems and component APIs)
