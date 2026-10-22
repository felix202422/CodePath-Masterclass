# Changelog

All notable changes to this repository are documented here.
Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/); versioning follows a simple
`MAJOR.MINOR.PATCH` for curriculum releases (MAJOR = restructured curriculum, MINOR = new subject or
milestone completed, PATCH = corrections and clarity fixes).

## [Unreleased]

### Added

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