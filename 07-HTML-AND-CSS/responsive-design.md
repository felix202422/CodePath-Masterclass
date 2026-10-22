# Responsive Design

## 1. Learning Objectives

After this lesson you can:

- [ ] Explain what the viewport meta tag does and why mobile browsers fake a desktop viewport without it
- [ ] Choose fluid units (`%`, `vw`/`vh`, `rem`) and `clamp()` correctly for a stated sizing job, and compute the result at a given width
- [ ] Place breakpoints where **content breaks**, not at device widths — and defend each breakpoint with a content observation
- [ ] Read an executed `matchMedia`/computed-value transcript at several widths and predict the layout at a new width
- [ ] Build a mobile-first cascade (base styles + `min-width` additions) and name its maintenance advantages

## 2. Prerequisites

- [Flexbox](flexbox.md) and [CSS Grid](css-grid.md) — what actually reflows between widths
- [The Box Model](box-model.md) — which widths are content vs border (percentages depend on it)
- [06-INTERNET-AND-WEB-FOUNDATIONS/browsers-and-rendering.md](../06-INTERNET-AND-WEB-FOUNDATIONS/browsers-and-rendering.md) — viewport and layout as pipeline concepts

## 3. Introduction

One document must serve a 360px phone, a 768px tablet, and a 1440px desktop — not by three
versions, but by one set of rules that *respond* to space. Responsive design is the discipline
of making that response predictable: fluid values where proportion matters, breakpoints where
content demands them, and a cascade ordered so mobile is the baseline rather than the
exception. This lesson's evidence is the same page executed at three exact viewport widths —
media queries flipping, `clamp()` resolving differently, and one honest platform seam where
the tool couldn't reach the smallest width claimed.

## 4. The Problem It Solves

Before responsive design, the answers were bad: a separate mobile site (`m.example.com` — two
codebases, redirect dances, sync bugs) or horizontal scrolling (pinch-zoom as the layout
strategy). Both failed on the same fact: **there is no "the screen size"** — it varies per
user, per orientation, per window, per zoom level (and WCAG treats 320–2560px widths *and*
400% zoom as in-scope — responsiveness is an accessibility requirement, not a nicety).

Ethan Marcotte's 2010 formulation combined three existing pieces into a method: a **fluid
grid** (proportional units), **flexible media** (nothing wider than its container), and
**media queries** (step changes when the fluid continuum hits a *content* problem). The
insight that made it stick: let proportion do most of the work, and intervene with breakpoints
only where the content genuinely fails (a text line too long to read, a nav row too wide to
click, a card grid down to one lonely column). Devices get *mentioned* only as measurements of
content, never as targets.

## 5. Core Concepts

### The viewport, and the meta tag that governs it

On mobile, browsers historically layout a ~980px virtual viewport and shrink-to-fit — so a
"mobile-optimized" page without the meta tag gets tiny text and microscopic targets. The tag:

```html
<meta name="viewport" content="width=device-width, initial-scale=1">
```

says: lay out at the *device's* CSS width (`device-width`), starting zoom 1. Everything in
this lesson presumes it — lesson 1's skeleton includes it, and without it `@media (max-width: …)`
queries measure the fake 980px viewport, not the phone. (Other directives — `maximum-scale`
to block zoom — are **prohibited** for accessibility: blocking pinch-zoom fails WCAG 1.4.4.)

### Fluid units, by job

| Unit | Resolves against | Use for | Watch out |
|---|---|---|---|
| `%` | parent's matching dimension | layout widths, gaps in grids | margins % resolve against *width* even vertically |
| `rem` | root `<html>` font size | type scale, spacing scale (zoom/user-font friendly) | don't set html font-size in px carelessly — it scales everything |
| `em` | *this* element's font size | component-internal (padding that tracks text) | compounds if misused up the tree |
| `vw`/`vh` | viewport width/height | full-bleed sections, fluid type | `vw` includes scrollbar math differences; mobile browser chrome differs from `vh` (`dvh`/`svh`/`lvh` fix this) |
| `min()`/`max()`/`clamp()` | mixed | **bounded fluidity** — the modern answer | clamp's three args: min, preferred, max |

**`clamp(min, preferred, max)`** replaces breakpoint math for single values: the value
follows the preferred (often `vw`-based) expression but never leaves `[min, max]` — fluid
*within bounds*, no media query. The executed section 6 shows the same `clamp()` computing
three different finals at three widths.

### Breakpoints follow content

The method for placing a breakpoint:

1. Push the viewport narrower (devtools drag, or this lesson's `--window-size` harness)
2. Stop when something **actually breaks**: nav items wrap into an unclickable two-line
   mush; the measure exceeds ~75 characters; a card grid drops to a single skinny column with
   dead space; touch targets shrink under 44px
3. Put the query at *that* width (rounded to a sane number), with the fix for *that* symptom

Not: "phones are 376, so 376." Device widths are *inputs to observation*, not answers —
they change yearly; content doesn't. Aim for **few** breakpoints (often 2–3): every query is
a cascade branch someone must test (mobile-first ordering, below, keeps the branch count
honest).

### Mobile-first cascade

Write the base (narrow, simplest) styles unconditioned; add `min-width` queries for more room:

```css
.nav-links { display: none; }            /* base: compact menu (JS toggles it) */
/* ... */
@media (min-width: 768px) {
  .nav-links { display: flex; gap: 16px; }   /* room arrived: switch presentation */
}
```

`min-width` (not `max-width`) ordering means stylesheets layer upward: later queries *add*,
never re-revoke — fewer overrides, and the no-query case is already the mobile-correct one
(what you get when queries don't run at all: older browsers, reader modes, print).

### The reflow toolkit (what each breakpoint actually changes)

Layout across widths is flex/grid re-parameterization (both lessons): column counts
(`grid-template-columns` redeclared), direction flips (`flex-direction: column → row`),
sidebar absorption (grid areas redeclared or `flex-basis` change), and type/container scaling
(`clamp`). Media queries change *declarations*; the previous lessons' mechanics do the work.

## 6. How It Works

### One page, three executed viewports

The lab page: a flex nav (stacked under 768, row above), fluid type
`font-size: clamp(16px, 5vw, 32px)`, a fluid-width card
`width: clamp(240px, 40vw, 600px)`, and `@media` blocks at 767/768/1200. Executed on the
authoring machine (headless Chrome 156, `--window-size` sweeps) — full transcripts:

```console
# viewport request 378px (see the seam below)
innerWidth = 504
matchMedia (max-width: 767px) = true
matchMedia (min-width: 768px) = false
matchMedia (min-width: 1200px) = false
nav flex-direction = column
fluid font-size = 25.2px  (5vw = 25.200000000000003px)
card width = 240px

# viewport 768px exact
innerWidth = 768
matchMedia (max-width: 767px) = false
matchMedia (min-width: 768px) = true
matchMedia (min-width: 1200px) = false
nav flex-direction = row
fluid font-size = 32px  (5vw = 38.400000000000006px)
card width = 307.188px

# viewport 1440px exact
innerWidth = 1440
matchMedia (max-width: 767px) = false
matchMedia (min-width: 768px) = true
matchMedia (min-width: 1200px) = true
nav flex-direction = row
fluid font-size = 32px  (5vw = 72px)
card width = 576px
```

Read each viewport as a state machine:

**504px (mobile state):**
- `max-767: true` → the `@media (max-width: 767px)` block is **active** → `nav flex-direction:
  column` (the nav *stacked* — the executed flex lesson's `column` axis, chosen by query).
- `5vw = 504 × 0.05 = 25.2px` — between `clamp(16px, …, 32px)`'s bounds → **preferred wins**:
  `25.2px` computed ✓ (the `000000000000003` tail is float representation of 25.2 — reading
  `getComputedStyle` decimals literally is another property-vs-geometry trap).
- `card width = 240px` — `40vw = 201.6px` is *below* the 240px floor → **clamp's min wins**:
  the card holds its minimum instead of collapsing.

**768px (the breakpoint itself):**
- Queries are exact-boundary: `(max-width: 767px)` false, `(min-width: 768px)` true — the
  seam is gapless by construction (767/768 adjacency — write queries as adjacent pairs or the
  boundary has a dead zone).
- `nav flex-direction: row` — one declaration line ago it was `column`: the entire nav
  presentation flipped on `innerWidth` crossing one integer.
- `5vw = 38.4` → above clamp max `32px` → **max wins**: `32px` (interesting: at 768 the
  preferred is already past its ceiling — clamp hit its cap early *by design*, so type stops
  growing at 640px viewport: `32 ÷ 0.05 = 640`).
- `card 307.188` = `40vw = 307.2` ✓ between bounds → preferred wins (the `.188`? measured via
  computed width — subpixel layout: `40%`-style resolution against fractional content box;
  `40vw` of 768 = 307.2 exactly — the computed value shows layout rounding).

**1440px (desktop state):**
- `min-1200: true` → third block active (`nav::before` content label would read DESKTOP-ROW,
  the executed a11y-free probe's nav shows `row` still).
- `5vw = 72` → clamped to `32` ✓ (capped since 640px viewport — the two upper viewports show
  *the same* `32px`: proof the clamp ceiling holds).
- `card = 576 = 40vw` ✓ (below the 600 max: `600 ÷ 0.4 = 1500` — the card keeps growing until
  1500px, then stops).

**The state table** (what you'd hand a reviewer):

| width | active queries | nav | fluid type | card |
|---|---|---|---|---|
| 504 | `max-767` | column | 25.2px (preferred) | 240px (clamp min) |
| 768 | `min-768` | row | 32px (clamp max) | 307.2px (preferred) |
| 1440 | `min-768` + `min-1200` | row | 32px (max) | 576px (preferred) |

**The honest tool seam:** requesting `378px` produced `innerWidth = 504`. Headless Chrome on
this machine enforces a **minimum window content width of ~504px** (requests below clamp
silently) — so the true-360px leg of the README's acceptance criteria *cannot* be executed by
window-size alone here. Two honest responses, both taken: (a) the transcript reports
`innerWidth = 504` and claims only what ran — mobile *state* (the `max-767` branch) was still
exercised and verified; (b) real 360px verification belongs to **devtools device emulation**
(or CDP emulation, which sets viewport metrics regardless of window minimums) — the
acceptance criteria in [projects/](projects/README.md) name devtools for the 360px check
exactly because of this seam.

### The clamp, computed at three widths

The fluid-type rule and its resolved values (executed above):

```
clamp(16px, 5vw, 32px)     at 504 → preferred 25.2  → in range → 25.2px
                           at 768 → preferred 38.4  → over max → 32px
                           at 1440→ preferred 72    → over max → 32px
clamp(240px, 40vw, 600px)  at 504 → preferred 201.6 → under min → 240px
                           at 768 → preferred 307.2 → in range → 307.188px
                           at 1440→ preferred 576   → in range → 576px
```

Three regions of one function — below range (min wins), in range (preferred wins), above
(max wins) — and *no media query participated*. For proportion-sensitive values, clamp
usually replaces a breakpoint entirely; the queries in this page exist only where the
**structure** (nav direction, card border color, label) changes, not the size.

## 7. Practical Examples

**Example 1 — the viewport sweep harness (this lesson's verification tool)**

```console
CH="…/chrome"
for w in 378 768 1458; do   # target innerWidth 504 (clamped), 768, 1440
  "$CH" --headless --dump-dom --window-size=$w,900 --virtual-time-budget=3000 \
    http://127.0.0.1:8790/responsive.html > "resp-$w.html"
done
```

with the page's probe writing `innerWidth`, three `matchMedia(...)` booleans, computed
`flex-direction`, computed `font-size` and card width (the transcript's exact lines — build it
from section 6's list).

- **Read the sweep as a state machine:** booleans tell which blocks ran; computed values are
  their effects. A *wrong* boolean at a target width means the breakpoint, not the property.
- **Note the width targets:** subtract ~18px for the vertical scrollbar where needed
  (`768 → request 786`? no — request 768 *gave* 768 minus nothing when height fits; the
  authoring run used exact requests after probing: `--window-size` reported `innerWidth` one
  line lower only when a scrollbar consumed space — always read the probe's `innerWidth`,
  never assume the flag) — that's why `innerWidth` is probe line 1.
- **How to run it:** any Chrome; page must implement the probe. **Assumptions:** Chrome 156,
  Windows (the 504 minimum is platform-specific — on Linux CI, 360 often works; report what
  *your* machine reports).

**Example 2 — a mobile-first two-breakpoint shell**

```css
/* base = phone. No queries needed to be correct here. */
.shell { display: grid; gap: 16px; padding: 16px;
         grid-template-columns: 1fr; }
.nav-links { display: none; }              /* compact trigger visible (JS/checkbox) */
.measure { max-width: 66ch; }             /* reading cap in every state */

@media (min-width: 768px) {                /* content signal: nav row fits, 2-col cards */
  .shell { grid-template-columns: 200px 1fr; grid-template-areas: "nav main"; }
  .nav-links { display: flex; gap: 12px; }
}

@media (min-width: 1200px) {               /* content signal: rail fits without crowding */
  .shell { grid-template-columns: 240px minmax(0, 1fr) 200px;
           grid-template-areas: "nav main rail"; }
}
```

- **What the important lines do:** one-column base (correct *without* queries); queries only
  *add* columns/structure as room arrives — the lesson 7 executed `minmax(0, 1fr)` floor
  included because main content holds text; `.measure` caps readability independent of width
  (the 75ch concern from section 5).
- **Expected result:** at 504/768/1440 the probe reports 1/2/3 grid tracks — sweep it with
  Example 1's harness and capture `gridTemplateColumns` (lesson 7's probe line 1).
- **How to run it:** page + harness; verify at three widths.
- **Assumptions:** grid support universal; `nav-links` toggling is subject 08's JS (or a
  checkbox-hack here — behavior, not CSS, is out of this lesson's scope).

## 8. Real-World Applications

- **The acceptance criteria of every frontend brief** are responsive statements: "works at
  360 and 1440" ([projects/](projects/README.md), ROADMAP's Project 02 promotion criteria) —
  the executed sweep is how a reviewer proves it *plus* devtools emulation at true 360 (the
  section 6 seam).
- **Fluid type scales** via `clamp()` are the design-system default now (lesson 9 builds the
  scale): heading `clamp(1.75rem, 4vw, 2.75rem)` — proportion on small screens, a designed
  ceiling on large, zero queries.
- **Responsive images** are the same method one layer up: `srcset`/`sizes` let the *browser*
  pick candidates per rendered width — the media-heavy counterpart to this lesson's CSS
  (subject 09 pairs them with lazy loading for the performance budget).
- **WCAG 1.4.10 (reflow)** requires usable content at 320 CSS px (≈ 1280 at 400% zoom) with no
  2-D scrolling — responsive layout *is* the compliance mechanism; teams test it with
  emulation, not devices.

## 9. Common Mistakes

| Mistake | Why it happens | How to recognize it | How to prevent it |
|---|---|---|---|
| Breakpoints picked from device tables | Tutorial lists | Nothing actually looks broken *at* them; queries accumulate | Drive devtools narrower until content fails (section 5's 4 steps); one query per observed symptom |
| `max-width`-first (desktop-down) cascade | Feels natural | Base styles bloated for desktop; small screens depend on overrides; no-query case broken | Mobile-first: base = narrow; `min-width` queries add (section 5) |
| Assuming `--window-size`/window equals viewport | Tool defaults | Probe's `innerWidth` ≠ requested (the executed `378 → 504` clamp; −18px scrollbars) | Probe line 1 reads `innerWidth`; trust it over flags; emulate for true device widths |
| Fixed px everywhere then "fixing" at breakpoints | No fluid units | Type/spacing identical 360→1440 with awkward dead space | Fluid for proportion (`vw`/`clamp`/`%`), breakpoints for *structure* only |
| Blocking zoom or viewport scaling | Thinking it "prevents bugs" | `maximum-scale=1`/`user-scalable=no` — WCAG 1.4.4 failure | Never disable zoom; fix layout at zoomed widths (which is just another width — the method already handles it) |

## 10. Best Practices

- **Sweep after every layout change.** Three widths through Example 1's harness takes under a
  minute and catches 90% of responsive regressions (query boolean + 3 computed values per
  width — state-table diffing, not eyeballing).
- **Let clamp own scalar values, queries own structure.** If a media query only changes a
  `width`/`font-size`, it's usually a clamp in disguise; if it changes `grid-template-areas`,
  `display`, or direction — it's a real breakpoint.
- **Adjacent query pairs, gapless boundaries.** `(max-width: 767px)` + `(min-width: 768px)`
  (as executed) or single-direction mobile-first — never two `max-width`es with a 1px dead
  zone where neither applies.
- **Test the boundary, not just the middles.** Off-by-one at 767/768 and the *next* query's
  edge (1200 here) are where branches conflict — the executed 768 transcript exists because
  boundary runs catch cascade fights mid-transition.
- **Keep one axis of truth for spacing:** container padding/gaps in `rem` or fixed, so
  breakpoint *structure* changes don't also silently rescale rhythm (lesson 9's spacing scale).

## 11. Limitations and Trade-Offs

- **Breakpoints are still steps.** Between queries, only fluid values change; structural
  awkwardness (a card row at 1.5 columns) persists until the next step — `auto-fill` grids
  (lesson 7's Example 2) reduce steps for galleries but structure remains discrete.
- **More widths than you test.** 320–2560 continuous (WCAG), landscape phones, split-screen
  panes, 125%/200% OS scaling, browser zoom — a three-width sweep is a *sample*; devtools
  emulation + zoom testing cover the tails (and real devices still catch platform font/scrollbar
  differences).
- **`vw`/`vh` have platform personalities.** Scrollbar inclusion differs (desktop reserves
  ~15–17px; overlay scrollbars don't), mobile browser chrome makes `vh` stale (`dvh`
  required) — computed values *will* differ across platforms by small amounts; test the
  behavior class, not pixel equality.
- **The harness's honesty limit (executed).** Window-size sweeps can't reach sub-504px on this
  machine — claiming otherwise would be fiction; emulation (CDP/devtools) is a *different tool*
  with its own caveats (fonts and DPR not identical to real devices). State which tool produced
  which claim, always — the transcripts above label theirs.

## 12. Practical Exercises

### Introductory

1. **Exercise 7.1** — Build section 6's probe page and run the three-width sweep. Verify every
   cell of the state table (queries, nav, type, card) and compute the clamp regions by hand
   first for one width of your choice.
   **Completion criteria:** three transcripts; hand-computed predictions vs measured for one
   width; the state table reproduced with your numbers.
2. **Exercise 7.2** — Compute, *without running*: at which viewport widths do the two clamps
   reach their min and max (`16/5vw/32`, `240/40vw/600`)? Then measure at those exact widths
   (±1) to confirm the boundaries.
   **Completion criteria:** algebra shown (`32 ÷ 0.05 = 640`, `240 ÷ 0.4 = 600`, etc.); two
   boundary transcripts; the adjacent-pair query rule quoted from section 6.

### Intermediate

3. **Exercise 7.3** — Take a page you wrote for desktop and convert it mobile-first: base
   styles for 360, `min-width` additions at the two breakpoints its *content* justifies.
   Capture: desktop-down vs mobile-first computed styles at three widths (must match) **and**
   the state with queries disabled (`--disable-javascript`? no — media emulation via devtools
   "Emulate CSS media feature" off, or temporarily comment queries) proving base correctness.
   **Failure to diagnose:** six computed captures (two implementations × three widths) showing
   equality; the queries-disabled artifact showing the mobile-correct base; one sentence on
   the failure the old approach had in that state.
4. **Exercise 7.4** — Reproduce the tool seam: sweep `--window-size=378`, `400`, `600` and
   record `innerWidth` (expect the 504 clamp), then use devtools device emulation at 360 and
   record the same probe lines.
   **Failure to diagnose:** four probe transcripts labeled by *tool*; the clamp documented for
   your machine; the 360-emulated values for nav/type/card; one sentence stating which
   artifact you'd attach to a "works at 360px" acceptance claim (and why the window-size one
   can't be it).

### Independent problem-solving

5. **Exercise 7.5** — *Problem:* a content-heavy product page must pass: 360px (no horizontal
   scroll, nav usable), 768px (two-column where it helps), 1440px (three-column with rail),
   400% zoom ≡ 320px effective, and fluid type with a readable cap at every width. Design the
   responsive system: every scalar as `clamp()`/fluid with computed boundaries shown; the
   breakpoints *justified by observed content failures* (state what breaks at each without
   them); mobile-first query blocks (sketch declarations); the sweep you'd run (widths,
   tools, probe lines) including how you satisfy the 320px/zoom leg given window-size limits;
   and the two risks most likely to fail review (name them — e.g. a fixed-width table, a
   nav-target) with mitigations.
   **Completion criteria:** clamps with boundary algebra; 2–3 breakpoints each tied to a
   described content failure; query sketch mobile-first; sweep plan with tool labels per width
   (window-size vs emulation) and probe lines; two named risks + fixes from this lesson's
   tables.

*Solutions: attempt first. This subject's applied work is in [projects/](projects/README.md).*

## 13. Knowledge Check

1. Your fluid font rule shows `32px` at both 768 and 1440. Is the clamp broken? Show the
   arithmetic that proves it's the max bound (and where the growth stops entirely).
2. Why does `innerWidth = 504` when `--window-size=378` was requested — what would you trust
   in a responsiveness report, the flag or the probe? What can't this tool chain claim?
3. A teammate adds `@media (max-width: 760px)` to a page that already has `(max-width: 767px)`.
   Name the two problems this creates and the ordering convention that prevents both.

## 14. Completion Criteria

Observable evidence that you have understood this lesson:

- [ ] You ran the three-width sweep and reproduced the state table (exercise 7.1)
- [ ] You computed clamp boundaries algebraically and verified at the edges (exercise 7.2)
- [ ] You converted a real page to mobile-first with equal three-width computed styles (exercise 7.3)
- [ ] You documented your machine's viewport clamp and produced an emulated 360 transcript (exercise 7.4)
- [ ] You can diagnose all five mistakes in section 9

## 15. Summary

- Responsive design = fluid proportions + content-driven breakpoints + a structure/size split; the viewport meta tag is the precondition.
- `clamp()` resolves in three regions (min / preferred / max) — the executed 504/768/1440 runs showed all three outcomes with zero size-related queries.
- Breakpoints are placed where content fails (nav wrap, measure, column count) — never from device tables; mobile-first `min-width` queries add rather than revoke.
- The sweep harness proves states at exact widths, but tools have seams: this machine clamps windows at ~504px — claims must name the tool (window-size vs devtools emulation).
- Structure changes deserve queries; scalar values deserve clamp — the split keeps the branch count small.

## 16. Next Steps

- Next lesson: [Typography and Design Tokens](typography-and-design-tokens.md) — the scales that make fluid values coherent
- Applied work: [projects/](projects/README.md) brief 2 (responsive navigation) and Project 02
- Where it is applied: [09-FRONTEND-ENGINEERING](../09-FRONTEND-ENGINEERING/README.md) (fluid design systems) and [15-APPLICATION-SECURITY](../15-APPLICATION-SECURITY/README.md) (reflow/zoom accessibility requirements)
