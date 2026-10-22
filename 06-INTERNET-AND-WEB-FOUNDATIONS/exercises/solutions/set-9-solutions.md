# Solutions — Set 9: Browsers and Rendering

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.

## Exercise 1 — DOM dump vs source

**Reference transcript (authoring machine, Chrome 156 headless):**

```console
$ chrome --headless --dump-dom http://127.0.0.1:8765/render.html > dom.html
$ # source file contains:  <p id="js-out">JS not run</p>
$ grep 'js-out' dom.html
  <p id="js-out">JS ran: computed box width = 200px</p>
```

- **Three differences and their classes:**
  1. `js-out` text `JS not run` → `JS ran: computed box width = 200px` — **script mutation**
     (the inline `<script>` rewrote `textContent`)
  2. A blank line before `</body>` in the dump that the source lacks — **parser/serialization
     artifact** (the DOM's serialization after script execution, not a source line)
  3. Attribute quoting/whitespace normalization across the dump — **parser repair/normalisation**
     (the tree is re-serialized from the tokeniser's output, not copied byte-for-byte)
- **Tied to script:** difference 1 is the page's own `<script>` (visible in the dump itself);
  had the page had *no* scripts, any remaining diff would be parser normalisation — and that
  absence is itself the evidence.
- **Criteria check:** ☐ both artifacts ☐ three classified ☐ one tied (or absence stated).

## Exercise 2 — Three values, three stages

**Reference transcript (authoring machine, lab page):**

```console
# in the browser console against render.html:
getComputedStyle(document.getElementById('box')).width   // "200px"
document.getElementById('box').getBoundingClientRect().width  // 200
document.getElementById('box').style.width               // "" (empty)
```

| Value | Stage that produced it |
|---|---|
| `getComputedStyle → "200px"` | **Style resolution** (cascade applied to the stylesheet's `#box { width: 200px }`) |
| `getBoundingClientRect → 200` | **Layout** (geometry in CSS px after box tree calculation) |
| `style.width → ""` | **Source attribute** (inline style — nothing was set inline) |

- **Which two diverge after a stylesheet-only change:** computed style and the rect both
  follow the stylesheet (they move together); the **inline** `style.width` stays empty — it
  reads only what markup set, never what CSS resolution produced. That three-way split is the
  exercise's core distinction.
- **Criteria check:** ☐ three values ☐ stage labels ☐ divergence sentence.

## Exercise 3 — Script-evidence artifacts, then the move

**Reference shape** (authoring machine's three captures):

```console
$ chrome --headless --dump-dom http://127.0.0.1:8765/render.html   # after: "JS ran: ..."
$ chrome --headless --screenshot=render.png --window-size=800,400 http://127.0.0.1:8765/render.html
4449 bytes written to file ...render.png
$ # marker method: add <p id="marker">pre</p> + script setting it to "post" → dump shows "post"
```

- **Moved-above-target failure** (your capture): with the script *before* its target element:

```console
$ # source now: <script>...getElementById('js-out')...</script> appears BEFORE <p id="js-out">
TypeError: Cannot read properties of null (reading 'textContent')
```

- **Lifecycle rule quoted:** an inline script **pauses parsing**, executes immediately, then
  resumes — elements *below* it are not yet in the DOM, so `getElementById` returns `null`.
  (It "works on reload" only when a cache/keystroke changes timing — never rely on that.)
- **Fix:** move the script after its targets, or `defer` (runs after parsing), or guard with
  `DOMContentLoaded`.
- **Criteria check:** ☐ three captures ☐ exact failure message ☐ lifecycle rule + fix.

## Exercise 4 — 5,000-row dashboard diagnosis (independent)

**Reference shape** (a reviewer checks stage-specificity):

- **Measurement plan (≥3 signals):**
  1. **CDP/Performance trace** — count forced **reflow** events and their duration after the
     filter click (layout stage)
  2. **Style-recalculation time** (trace's `RecalculateStyle`) — style resolution stage
  3. **`PerformanceObserver` long tasks + frame timing / dropped frames** — main-thread
     availability; and paint/composite visibility via the trace's paint & raster tracks
  4. Layout-count trick: `getBoundingClientRect()` in a loop as an instrumented flush, before
     vs after batched writes
- **Decision table:**

| Signal | Implicated stage | Next action |
|---|---|---|
| `RecalculateStyle` dominant | Style resolution | Reduce selector complexity / class churn; check `:hover` storms |
| Reflow/layout dominant, cascading | Layout | Batch writes, avoid geometry reads in loops, virtualise rows |
| Layout small, paint/raster large | Paint | Fewer layers/shadows, `contain`, simplify visuals |
| Long tasks with no layout/paint spike | JS itself (script stage) | Profile the filter function — probably O(n²) client-side filtering |
| Trace clean but frames drop on scroll | Compositor/GPU | `content-visibility`, `transform`-based scrolling, check GPU contention |

- **Before/after artifacts:** the trace file (both runs), a DOM dump showing row count before/
  after filter (5,000 → filtered), and a screenshot at the two window sizes if resize-triggered.
- **Hypothesis per outcome:** e.g. "if style dominates, the per-row `:hover` selectors re-resolve
  for all 5,000 nodes on class change" — each a testable claim, not a guess.
- **Stated headless limitation** (lesson §11): headless runs differ in GPU compositing, fonts
  and viewport — jank reproduced there may not match headed behaviour, so treat headless traces
  as *stage evidence*, not as frame-rate truth; confirm timing on the affected hardware.
- **Criteria check:** ☐ ≥3 stage-specific signals ☐ complete decision table ☐ concrete
  artifacts ☐ one headless limitation.

---

Back to [README.md](README.md)
