# Changelog

All notable changes to this repository are documented here.
Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/); versioning follows a simple
`MAJOR.MINOR.PATCH` for curriculum releases (MAJOR = restructured curriculum, MINOR = new subject or
milestone completed, PATCH = corrections and clarity fixes).

## [Unreleased]

### Added

- **Subject 10 — Database Engineering** — seventeen lessons (fundamentals through NoSQL) with
  transcripts **executed** against PostgreSQL 18.6 / psql 18.6 on the batch's scratch cluster
  and the shipped lab: the three guard rejections verbatim (`invalid input syntax for type
  numeric`, `duplicate key … customers_pkey`, `violates foreign key … orders_customer_id_fkey`),
  NULL arithmetic (`credit | plus_one` empty, `rows_total 3 | rows_with_credit 2`), all three
  referential actions (default refusal with DETAIL, cascade child `1 → 0`, `set null`), the
  money query's three rows (`240.00 / 39.00 / 310.00`), three-valued traps (`= null` → 0 rows;
  `not (price >= 120)` → 4; `count(*) 8` vs `count(price) 7`; `WHERE`-vs`HAVING` populations
  `2/2/2` vs `3/2/3`), the join ladder (inner 8, left 8 with coalesced 0s, right/left `10 = 10`,
  cross 32, full-outer 5-row CTE reconciliation, `NOT IN` NULL trap `2 → 0`), the five-table
  `shop` schema with four design rejections (SKU, orphan customer, duplicate line, status
  CHECK), a catalog-derived ER diagram (four FKs, optionality from `attnotnull`: three
  `mandatory (1)` + one `optional (0..1)`) whose mermaid parses VALID, all three normalization
  anomalies on a flat table (`truths = 2`, not-null insert refusal, deletion cascade) with a
  lossless 3NF repair (`view = 3 rows`) and the anomaly re-runs disappearing, the constraint
  battery incl. `not-valid`→`validate` and an exclusion-constraint overlap rejection, the
  transaction ladder (rollback/commit pair, mid-block atomicity, `current transaction is
  aborted…` guard, savepoint escape), **two-session isolation** (`100 → 200` non-repeatable,
  `100 → 100` snapshot, `40001` serialization failure, application lost update `150`
  clobbering `200`), index measurement (`13.164 ms` seq scan, 99,980 rows removed, 637 buffers →
  `0.700 ms` bitmap scan, 22 buffers; `776 kB` index over `5,096 kB` table; planner decline at
  a 12% predicate), plan reading (top-N `57.862 ms` vs external-merge spill `223.199 ms`,
  estimate gaps closed by `ANALYZE`), a migration runner with a real `schema_migrations` ledger
  (skip ×3, failed file not recorded, `psql -1` atomicity), backup drills (three dumps
  `2,969,654 / 1,039,646 / 9,896 B`, `drop schema` → restore → counts back, `setval 3 2 3 4 5`),
  security probes (role flags `f f`, grants `f f → t`, `permission denied` for table/sequence/
  column, revoke re-denies, RLS reader sees 1 of 5 rows), and `jsonb` semantics (`->` 12 vs `->>`
  `'12'`, explicit-null vs missing key, `@>` matching 12,501 of 50,004 rows at 13.549 ms, 37,503
  rows filtered pre-GIN).
- **Shipped PostgreSQL lab — `10-DATABASE-ENGINEERING/postgresql/`** — one-file `shop.sql`
  schema+seed, split `01-schema.sql`/`02-seed.sql` (pg_dump 18.6), seven check queries `q1`…`q7`
  with byte-exact `expected/` captures, a README, and `verify.sh`, which rebuilds a scratch
  database and diffs every result: **7 passed, 0 failed** (Windows CRLF stripped in-script so
  the captures diff clean on any platform).
- **Exercises — Subject 10** — `exercises/README.md` with 12 sets mapped to all 17 lessons
  (introductory → intermediate → independent, every exercise with observable criteria) and
  `exercises/solutions/` — 12 separated solution files behind the attempt-first warning, quoting
  only real captures.
- **`LABS.md`** — a root guide mapping every lab environment this repository's transcripts came
  from (shipped PostgreSQL lab, Java, browser, JS/TS, React/Vitest, Python validation tooling) to
  the subjects each serves, with bootstrap commands and the reproduce-a-transcript method; linked
  from the README table of contents. Subject 10's README lesson list and coverage bullets
  extended to all seventeen lessons.

- **Subject 09 — Frontend Engineering** — sixteen lessons (React fundamentals through build and
  deployment) with transcripts **executed** in a Vite 8.3.5 + React 19.3.1 + Vitest 5.0.5 +
  jsdom 30.1.3 lab on Node 24.13.1 (probe clusters A–N: 15 test files, 82 assertions, all green
  in the batch's final run) plus tsc 7.0.2 and a real production build (probe O): JSX captured as
  an element object (`type`/`props`/`children`/`key: null`) beside the index-key warning firing
  once vs never, batching proven as one commit per tick (`two setState calls in one handler =
  one re-render, final value 2`; render battery `3 separate-act clicks: 4 renders`,
  `3 batched clicks: 5 renders`), the functional updater beating the stale closure
  (`after stale-form click: 10 | after updater-form click: 21`) and StrictMode's
  `body -> body -> effect -> cleanup -> effect` trace, `useRef` mutation proving
  `renders 1 -> 1`, the composition gotchas (`n=0` renders `"0"`, capital-vs-lowercase alias)
  and lifted state across siblings, `MemoryRouter` back/replace and `<Outlet>` nesting, the
  controlled-form round trip (`typed \"Ada\" → input.value=\"Ada\"`) with derived validity
  (`submit disabled at start: true | after blur: \"needs @\"`), context's identity costs
  (`memoized consumer renders: 1 → 2`, `unstable provider value: consumer renders 1 → 2` vs
  `unrelated component renders: 1 → 1`), the four-state fetch surface with abort
  (`error state: \"network down\" | abort-on-unmount: signal aborted = true`,
  `renders: 3 | fetches: 1`), the auth trade-offs executed rather than asserted (localStorage
  token readable by any same-origin script `true`, memory token dying on reload, **two 401s →
  refresh calls: 1**, guard redirect with `?next=`), the error-boundary pair (blank tree without
  one vs logged `componentStack` + working reset), live-region and role contracts
  (`role=button count: 2 tags: BUTTON,DIV`, `aria-label wins over placeholder`, `aria-pressed
  false → true`, focus returned to `Delete`), variant/className/polymorphic-`as` component
  receipts with `TS2322` captured for a bad tone literal, jsdom resolving theme tokens
  (`light rgb(37,99,235)`, `dark rgb(96,165,250)`, `space 8px`), the query-ladder proof
  (role query survives markup change, class query breaks) through keyboard-submit and
  module-mock contract tests, and probe O's build contract — `16 modules transformed`,
  `index-qny8FNsF.js 221.22 kB │ gzip: 69.26 kB` built in `735ms`, `VITE_API_URL` inlined,
  the unprefixed `API_TOKEN` **absent from `dist/`**, `process.env.NODE_ENV` count 0, and
  `heavy-CEsDep9u.js` split as its own chunk; sixteen Mermaid diagrams, all parse-validated
  (2 fixed during validation); `projects/` — three briefs (paginated data table with filtering,
  form-driven wizard, token-authenticated dashboard) written as the frontend preparation for
  Project 05; and `exercises/` — twelve observation-first sets mirroring each lesson's ladder
  with a separated solutions directory (thirteen files quoting the lab's probe receipts and
  labelling shape-only answers for the open-ended designs).
- **Subject 08 — JavaScript and TypeScript** — twelve lessons (JavaScript fundamentals through
  type narrowing) with every transcript **executed** on the authoring machine (Node 24.13.1,
  tsc 7.0.2 under `--strict`, headless Chrome 156): the nine-expression coercion ladder
  (`'5' + 1` → `51` vs `'5' - 1` → `4`, `0 ?? 'x'` → `0`) beside a corrected TDZ trio — the
  lesson's own myth was fixed against a re-run, since `typeof` on a TDZ binding **throws**
  `ReferenceError` and only never-declared names get the free `undefined`; closures over five
  loop forms (`var` → `3,3,3`, `let`/factory/`while`-block → `0,1,2`, `bind` → per-object
  `this`), aliasing vs copying (`toSorted` leaving the source intact) with both executed
  `Object.freeze` `TypeError`s and an unchanged-data proof, an executed DOM propagation trail
  (capture → target → bubble, ancestry adding `out-bubble`) plus the listener-identity trio
  (`hits=1` for a named function registered twice, `arrowHits=2` for two arrows) in headless
  Chrome, module namespace keys and the link-time `SyntaxError` beside once-per-process
  side-effect runs and both cycle outcomes (deferred loads, TDZ read crashes), the
  unhandled-rejection child-process crash (exit 1, `Error: no`) against measured serial /
  `Promise.all` / batch timings (299 / 60 / 181 ms for five 50 ms tasks), mixed-queue traces
  (`await` finishing before every timer) and a bounded starvation table (timer delayed 1 → 9 →
  14 ms as N grows, unbounded case stated as counterfactual only), the four `finally` probes
  including the return that swallows a throw, `cause`/`AggregateError` root preservation, the
  `instanceof` dispatch with the inherited-`name` pitfall, TypeScript's erased emit (`Hello,
  Ada!` from JS with no type syntax), the executed diagnostic ladder (`TS2588` for `const`
  reassignment — a second prose claim corrected against the run — plus `TS2322`/`TS2345`), a
  strict-vs-loose tsconfig audit recording the tsc-7 seam that a *bare* CLI run already
  enforces `noImplicitAny`, the four-behavior structural-typing matrix (exit 0/1/1/0 with
  `TS2741` and `TS2353`), generics with the pinned-argument misuse re-executed and corrected
  (`TS2322` for the fresh literal, `TS2345` only when the argument is a pre-built variable),
  and a narrowing cluster that compiles **exit 0** and runs — printing `7.0 12 OK 8080 a, b
  round` — beside four executed failure modes (`TS2339` un-narrowed union, `TS18046` on
  `unknown`, `TS18047` narrowing lost to a closure, `TS2345` exhaustiveness after a variant
  is added); twelve Mermaid diagrams, all parse-validated; and `exercises/` — twelve
  observation-first sets mirroring each lesson's ladder with a separated solutions directory:
  thirteen files quoting transcripts re-executed while writing them and shape-only answers for
  the open-ended designs (focus-trapping modal, module layout, settings loader, frozen-
  dashboard diagnosis, payments taxonomy, adoption plan with ratchet, editor type layer,
  typed event bus, chat-event pipeline).
- **Subject 07 — HTML and CSS** — ten lessons (HTML fundamentals through accessibility) with
  every browser transcript **executed** on the authoring machine (Chrome 156 headless,
  `--dump-dom`/`--screenshot`/computed-style probes, axe-core 4.10.2 in-page): the box-model
  content-box/border-box pair measured through `clientWidth`/`offsetWidth` (250 vs 200 border
  boxes, border-box content shrinking to 150) with collapsed-margin `offsetTop` stacking, the
  flexbox `space-between`/`gap`/`align-items: center` row and the stretch-at-`align-items:
  stretch` `h=60` measurement, grid track/area placement read from computed styles, the
  cascade/specificity lab (compound-selector tie resolved by document order, `:not()`
  contributing zero specificity), the responsive clamp resolved at three exact viewport widths
  with the ~504px minimum-window clamp recorded as the honest machine seam (true 360px belongs
  to devtools device emulation), a constraint-validation form probe (`checkValidity`,
  `setCustomValidity`, `reportValidity`), an executed accessibility pair — bad page **7 axe
  violations** (2 critical, 2 serious, 3 moderate) versus same-content corrected page **0**,
  WCAG contrast computed for real (2.85:1 `#999` fail, 7.00:1 `#595959` AAA pass, 3.00:1 lab
  green named honestly as an AA fail for body text), and a keyboard focus probe proving native
  focusability (`div[onclick] false`), the positive-`tabindex` queue jump, and `disabled`/`-1`
  exclusions; seven Mermaid diagrams, all parse-validated; and `projects/` — three progressively
  harder build briefs (semantic article page, responsive navigation, form-heavy settings
  screen) with reviewer-style acceptance criteria (axe 0, heading outline, 360/1440px via
  device emulation, keyboard pass, computed contrast) feeding Project 02's promotion gate.
- **Subject 06 — Internet and Web Foundations** — nine lessons (how the internet works through
  browsers and rendering) with every transcript **executed** on the authoring machine (curl
  8.22.0, OpenSSL 3.5.9, Python 3.13.5, Chrome 156 headless, `nslookup` against the live ISP
  resolver): ping TTL arithmetic beside an unchanged-TTL loopback/gateway pair, an 8-hop tracert
  whose cap is named honestly as not reaching the destination, A/AAAA/MX/CNAME/TXT record
  queries and an SOA `default TTL = 1800` reading where `nslookup -query=TTL` is exposed as
  silently falling back to A, a socket lab capturing `connect`/`accept` handshake evidence
  lines, UDP `recvfrom` sender-identity and the Windows ICMP-ghost `ConnectionResetError 10054`
  dead-port experiment, `curl -v` request/response anatomy with POST/HEAD/404 and the
  ETag → `200` → `304` → `200` conditional sequence, an `openssl` version-floor pair (1.3 and 1.2
  negotiate, 1.0/1.1 refused `no protocols available`) plus certificate chain/SAN/expiry
  inspection and the executed `expired.badssl.com` `Verify return code: 10` failure, raw
  socket bytes proving HTTP's CRLF framing, a `netstat` listening-port inventory, and headless
  Chrome `--dump-dom`/`--screenshot` captures showing a script-mutated DOM with the
  layout-computed `200px` — seven Mermaid diagrams, all parse-validated; and `exercises/` —
  nine observation-first sets (capture the output, then explain the mechanism) mirroring each
  lesson's ladder, with a separated solutions directory: ten files quoting the reference
  transcripts, hand computations verified against `ipaddress`, and shape-only answers for the
  open-ended designs (migration runbook, transport policy, certificate-failure decision tree,
  URL design test matrix, rendering-jank decision table).
- **Subject 05 — Data Structures and Algorithms** — eighteen lessons (algorithm analysis
  through graph algorithms) with every transcript **executed** on the authoring machine
  (JDK 25.0.4.1, `javac --release 21`): counted and instrumented implementations throughout —
  dynamic-array growth ladders and copy counters, hash-chain visit counts, BST shape batteries
  across ascending/descending/shuffled inserts, heap sift-op counters (Floyd heapify vs n adds),
  comparison/move counters for six sorts × five input shapes, naive-vs-memoized call counts,
  N-queens attempts/checks/solutions at n = 4 and n = 8 (92), greedy-vs-DP coin tables diverging
  at t = 6, Dijkstra distances hand-verified (`0 7 9 20 20 11`) beside an executed negative-edge
  failure (`A→D = 2` reported where the true optimum is `−7`), and Kahn topological sort with an
  executed cycle case (`emitted 3 of 6, detected=true`); one Mermaid flowchart per lesson
  (17 blocks, all parse-validated); and `problem-solving/` — eighteen mixed practice sets
  spanning adjacent lessons (trace-by-hand, implement-from-scratch, prove-or-disprove a
  complexity claim with counters, and one stated-without-steps problem each), eighteen
  separated solution files stating complexity and worst case, and a three-rung hint ladder
  per set.
- **Subject 04 — Java Programming** — twenty-one lessons (environment setup through build tools)
  with every transcript **executed** on the authoring machine (JDK 25.0.4.1 with
  `javac --release 21`, Maven 3.9.16): the compile/run cycle with `javap` major-version proof,
  verbatim compiler and runtime error transcripts (truthy refusal, `private access`, `new T()`
  erasure refusals, CME, deadlock dumps, OOM-inside-the-catch at `-Xmx32m`/`-Xmx64m`), a
  two-run lost-update race (39251 / 39633) beside executed `synchronized`/`AtomicInteger` fixes,
  a full Maven build end-to-end (cold 17.5 s vs warm 7.3 s, `BUILD SUCCESS`, jar run output),
  one original SVG diagram (`assets/java/inheritance-diagram.svg`), twenty-one exercise sets
  and twenty-one separated solution files. Gradle is absent from the writing machine and is
  labelled as such rather than simulated.
- **Subject 03 — Developer Tools** — ten lessons (terminal fundamentals, Windows environment,
  Linux fundamentals, editors and IDEs, package managers, environment variables, Git fundamentals,
  branching and merging, GitHub workflows, pull requests and code review) with transcripts
  executed on the authoring machine (Git Bash, Git 2.55.0; PowerShell, cmd, and `wsl --status`
  probes actually run; sandbox repositories using a placeholder identity); two original SVG
  diagrams (`assets/tools/`); and `troubleshooting/` — nine diagnosis guides plus the graded
  drills in `exercises.md` that carry this subject's practice per `CURRICULUM-MAP.md`. GitHub web
  UI, Actions, and real-Linux blocks are labelled illustrations where they could not be executed.
- **Subject 02 — Programming Fundamentals** — twelve lessons (computational thinking through
  modular programming) with every Python transcript **executed** on the authoring machine
  (Python 3.13.5), three original SVG diagrams (`assets/programming/`: assignment/rebinding,
  call stack, debugging cycle), twelve exercise sets and twelve separated solution files, plus a
  modular-programming capstone whose reference implementation was run and hand-verified.
- **Version baseline** — `VERSIONS.md` pinning every tool version lessons are written against,
  verified 2026-10-17 against official sources, with deliberate-choice rationales.
- **Issue register** — `ISSUE-REGISTER.md`: the full curriculum backlog with milestones, a standard
  issue template, status tracking, and an always-current unfinished-work summary.
- **Textbook homepage** — `README.md` with mission, audience table, learning path, full table of
  contents, exercise rules, and the six-level proficiency system.
- **Navigation system** — `ROADMAP.md` (11 competence-gated milestones with promotion criteria),
  `CURRICULUM-MAP.md` (competency → lesson → exercise → project), `LEARNING-GUIDE.md` (evidence-
  based study method), `PROGRESS-TRACKER.md` (eight tracked dimensions, six levels).
- **Project policies** — `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md` (Contributor Covenant 2.1),
  `SECURITY.md`, `SUPPORT.md`.
- **Templates** — lesson, exercise, project, and progress templates in `templates/`.
- **Validation tooling** — `scripts/check-links.py` (relative link and image resolution) and
  `scripts/check-curriculum.py` (structure and required-section checks).
- **Visual learning system** — `assets/` with per-topic subdirectories, an original SVG branding
  mark, and a manifest documenting source, license, and attribution rules for every asset.

### Notes

- All curriculum lesson content ships in later batches, tracked per-file in
  [ISSUE-REGISTER.md](ISSUE-REGISTER.md). Nothing in this repository is claimed as complete before
  it passes the quality gate described in [CONTRIBUTING.md](CONTRIBUTING.md).

[Unreleased]: https://github.com/felix202422/CodePath-Masterclass/compare/main...HEAD