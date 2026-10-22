# Exercises — 06 Internet and Web Foundations

**Lessons:** this subject's nine lessons, in order.
**How to use these sets:** attempt first; solutions live in
[solutions/](solutions/README.md) behind a warning. The 15-minute rule from
[learning-method](../../00-START-HERE/learning-method.md) applies — record which hint you used.

Each set corresponds to the lesson named in its title and mirrors that lesson's exercise ladder
(introductory → intermediate → independent) with observable completion criteria. Completing all
nine sets *is* the subject's completion gate in [ROADMAP.md](../../ROADMAP.md).

This subject's sets are **observation exercises as much as coding ones**: the evidence is
captured output from your own machine — `ping`, `tracert`, `nslookup`, `curl`, `openssl`,
`netstat`, a headless browser — plus a small amount of socket and client code in Python. Every
transcript quoted in the lessons was executed on the authoring machine (Windows 11, Git Bash:
curl 8.22.0, OpenSSL 3.5.9, Python 3.13.5, Chrome 156, `nslookup`; `dig`/`nc` absent), so where
your platform differs, the *behaviour* is the criterion and the exact text is yours to capture.
Policy matches [VERSIONS.md](../../VERSIONS.md): your transcripts are your evidence.

---

## Set 1 — How the internet works → `how-the-internet-works.md`

1. Run `ping` against two hosts (a public one and your default gateway). Compute the hop
   estimate from each arriving TTL, stating the initial value assumed.
   **Criteria:** two TTL computations with stated assumptions; the closer host's estimate smaller (or explained).
2. Run `tracert -d`/`traceroute` and label: home router, first ISP hop, whether the trace
   reached the destination.
   **Criteria:** three hops labelled from your output; any `*` row explained in one sentence.
3. Ping five times normally, then during a download; compare average latency and loss.
   **Criteria:** both number sets captured; two sentences naming which metric moved and why.
4. **Independent:** design a measurement procedure separating "path is far" from "server is
   slow" from "path is lossy" using only terminal tools — commands, metrics, and a decision
   branch per result.
   **Criteria:** ≥3 commands with the metric each produces; every branch maps an observable to
   one conclusion; one stated limitation.

## Set 2 — Client–server architecture → `client-server-architecture.md`

1. Capture your machine's listening services (`netstat -ano | grep LISTENING` /
   `ss -tlnp`); identify three by port and bind address.
   **Criteria:** three entries labelled; one sentence on which you would not want LAN-reachable, and why.
2. Write and run the lesson's ten-line server and client; then start a second client while the
   first is connected.
   **Criteria:** the first exchange's output captured; the second client's behaviour explained from `listen()` queue depth.
3. Extend the server to accept three clients in a row; run three concurrently.
   **Criteria:** three greetings captured; the per-connection socket named as the distinguishing value.
4. **Independent:** design and implement the LAN "word of the day" service (get/set over plain
   text, standard library only): port and bind address decided, protocol in ≤5 lines, two
   simultaneous sets handled, security limitation stated.
   **Criteria:** captured get and set transcript; documented protocol; honest paragraph on no-authentication (lesson section 11).

## Set 3 — IP addressing and subnets → `ip-addressing.md`

1. Capture your IPv4 address, gateway, and prefix; compute your subnet's usable range.
   **Criteria:** three real values; hand computation + `ipaddress.ip_network` verification; one sentence on why the address is private.
2. Expand `2606:4700:10::6814:179a` and `fe80::1` to full form; classify each (global vs
   link-local) citing the prefix.
   **Criteria:** both expansions; both classifications with prefix named.
3. For `10.20.4.0/22`: usable count, first/last usable, broadcast — by hand, then verified.
   **Criteria:** step-by-step computation; Python verification transcript; any discrepancy explained.
4. **Independent:** allocate non-overlapping RFC 1918 space for 120 + 40 + 40 + 25 + 500 devices
   across office/branch/server/cloud to link over VPN; justify each prefix length.
   **Criteria:** every site fits with headroom; no overlap (verified); the overlap failure mode explained from routing/NAT.

## Set 4 — DNS → `dns.md`

1. Capture your configured resolver and a full `nslookup` answer; identify the recursive
   resolver and the answer's authority label.
   **Criteria:** resolver address captured; label quoted; one sentence on what the resolver did that your machine did not.
2. Query `A`, `AAAA`, `MX`, `CNAME`, `TXT` for five names; write the question each record type
   answers.
   **Criteria:** five transcripts; five mappings; the TXT record's purpose verified against the domain's documentation.
3. Compare TTL evidence from two resolvers (yours and `1.1.1.1`) at two times each.
   **Criteria:** four captured values; two sentences on why they may differ while both are correct.
4. **Independent:** design the zero-downtime migration runbook: TTL set when and to what,
   change order, external verification per step, rollback trigger/action, residual risk.
   **Criteria:** runbook with timings derived from real TTLs; a verification command per step; rollback stated; honest paragraph on caches you don't control.

## Set 5 — TCP and UDP → `tcp-and-udp.md`

1. Run the socket lab; annotate every line: which protocol, which party printed it.
   **Criteria:** all lines labelled; the two handshake-evidence lines identified with the blocking call named.
2. Find three established TCP connections with `netstat`/`ss`; identify server vs client side
   from ports alone.
   **Criteria:** three port pairs; server identified by well-known port in each; one ephemeral port identified.
3. Reproduce the UDP dead-port experiment standalone (send to an unbound port, then to a
   freshly started server).
   **Criteria:** your OS's actual first-result captured (error *or* timeout — both correct); second delivered; the protocol's own silence explained.
4. **Independent:** transport design for lossy-link soil sensors (60s readings, next supersedes
   previous; config updates must arrive exactly once): per-direction transport, duplicate/
   ordering/timeout policy, TCP's wasted cost named.
   **Criteria:** direction-by-direction choice + justification; implementable policy rules; paragraph citing the stale-packet criterion.

## Set 6 — HTTP fundamentals → `http-fundamentals.md`

1. Capture `curl -v` against a reachable server; label start lines, blank-line boundary, three
   request headers, response status line, and the body's required byte count.
   **Criteria:** five labels from your transcript; `Content-Length` cross-checked with actual bytes.
2. Send `POST`, `PUT`, `DELETE`, `GET` to one path; record statuses; repeat the `PUT` and
   justify the repeat.
   **Criteria:** four statuses captured; the idempotency row cited; one sentence on retry-safety for your POST.
3. Drive the conditional flow: harvest `ETag`, re-request with `If-None-Match`, then change the
   served content and re-request.
   **Criteria:** `200` → `304` → `200` captured in sequence; two sentences on who decided each and why no body on the second.
4. **Independent:** five-operation HTTP contract (create/list/update/delete/export) for a
   notes service: method + status + one key header per row, every cell justified; retry policy
   as a mechanical rule; one self-identified edge case.
   **Criteria:** complete contract table with justifications from section 5; implementable retry rule; edge case handled.

## Set 7 — HTTPS and TLS → `https-and-tls.md`

1. Inspect two sites with `openssl s_client` + `x509`: issuer, `notAfter` (days remaining), SAN,
   protocol/cipher, verify code.
   **Criteria:** two full transcripts; each recorded item mapped to the layer that checked it; wildcard coverage rule with a match and a non-match.
2. Force `-tls1_2`, then attempt `-tls1`/`-tls1_1`; capture both.
   **Criteria:** 1.2 transcript with cipher; old-version failure captured verbatim; who refused and why refusal is correct.
3. Capture a real failure on `expired.badssl.com` with `openssl` *and* Python
   `ssl.create_default_context()`; classify it.
   **Criteria:** both messages; verify code 10 identified and mapped to its repair; the wrong fix named and rejected with a one-sentence MITM justification.
4. **Independent:** diagnose intermittent partner `certificate verify failed` reports (one
   partner runs an intercepting proxy): decision tree from captured symptoms to causes
   (missing intermediate / wrong hostname / untrusted root / clock skew), what to request from
   each partner, what the client must never do.
   **Criteria:** tree mapping each symptom to exactly one cause; explicit prohibition + justification; intercepting-proxy policy stated.

## Set 8 — URLs and ports → `urls-and-ports.md`

1. Decompose three daily URLs with the lesson's script; mark which components a server
   receives.
   **Criteria:** three script-produced tables; "would receive" column excludes the fragment in every row with the rule cited.
2. Capture five listening ports; match each to a service and say whether its client uses a URL
   scheme (`postgresql://`, `redis://`, `https://`) or its own protocol.
   **Criteria:** five entries; ≥1 non-HTTP entry explained with the port-implied-nothing rule; bind scope noted each.
3. Produce the four-rung failure ladder against one host: DNS failure, refused connection,
   404, success — each with `curl -v`.
   **Criteria:** four real outputs; each mapped to its component row; one sentence on why "refused" proves DNS worked.
4. **Independent:** extend the partner report URL to carry user-supplied names (spaces, `&`,
   `#`, non-ASCII) plus a client-only annotation that must never reach the server: complete new
   URL with per-component justification, encoding rules, test matrix.
   **Criteria:** full URL + justifications; fragment placement argued from never-sent; ≥6-row encoding test matrix; one stated risk of your choice.

## Set 9 — Browsers and rendering → `browsers-and-rendering.md`

1. Capture `--dump-dom` for a page whose source you can view; diff and classify three
   differences as script mutation or parser repair.
   **Criteria:** both artifacts saved; three classified differences; one tied to a specific script (or the absence stated).
2. In a console, capture for one element: `getComputedStyle(el).width`,
   `getBoundingClientRect().width`, and inline `el.style.width`.
   **Criteria:** three values; each labelled with its pipeline stage; one sentence on which two diverge after a stylesheet-only change.
3. Produce DOM dump + script evidence (before/after marker) + screenshot for one URL; then move
   the script above its target and capture the failure.
   **Criteria:** three captures; the failure's exact message; the lifecycle rule quoted plus the `defer`/placement fix.
4. **Independent:** diagnose a 5,000-row dashboard that janks on filter: stage-specific
   measurement plan (CDP trace, `PerformanceObserver`, layout counts), a decision table
   (signal → stage → action), artifacts to attach, one hypothesis per outcome, and a stated
   limitation of headless evidence.
   **Criteria:** ≥3 stage-specific signals; complete decision table; concrete artifact definitions; headless limitation cited.

---

## Answer key

Solutions: [solutions/](solutions/README.md).

**⚠ Attempt the sets first.** Reading a solution gives recognition, not skill. If you peeked, redo
the affected exercise one week later without looking — that second attempt is the one you keep.
