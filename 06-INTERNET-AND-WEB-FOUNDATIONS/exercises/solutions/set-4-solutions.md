# Solutions — Set 4: DNS

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.

## Exercise 1 — Resolver and authority label

**Reference transcript (authoring machine):**

```console
$ ipconfig | grep -A2 "DNS Servers"
   DNS Servers . . . . . . . . . . . . : 102.208.185.3

$ nslookup example.com
Non-authoritative answer:
Server:  ns.ditnet.ac.tz
Address:  102.208.185.3
```

- The resolver is the configured recursive one — here the ISP's (`ns.ditnet.ac.tz`,
  `102.208.185.3`), answering from *its* cache or its own walk of root→TLD→authoritative.
- **"Non-authoritative"** = this answer did not come from `example.com`'s authoritative
  servers; it's a copy held by the recursive resolver. It's the normal state of nearly every
  answer you will ever see.
- **What the resolver did that your machine didn't:** the whole hierarchy walk (referrals to
  root, `.com`, the zone's NS) plus caching; your stub asked one question and accepted one reply.
- **Criteria check:** ☐ resolver captured ☐ label quoted ☐ division of labour sentence.

## Exercise 2 — Five record types

**Reference transcripts (authoring machine):**

```console
$ nslookup -query=MX gmail.com
gmail.com	MX preference = 5, mail exchanger = gmail-smtp-in.l.google.com
gmail.com	MX preference = 10, mail exchanger = alt1.gmail-smtp-in.l.google.com
... (20, 30, 40 for alt2–alt4)

$ nslookup -query=CNAME docs.python.org
docs.python.org	canonical name = dualstack.python.map.fastly.net

$ nslookup -query=TXT google.com
google.com	text =
	"apple-domain-verification=30afIBcvSuDV2PLX"
```

| Type | Question answered |
|---|---|
| `A` | Which IPv4 address? |
| `AAAA` | Which IPv6 address? |
| `MX` | Which mail servers, in preference order? |
| `CNAME` | Which other name is this an alias of? |
| `TXT` | What arbitrary text does the domain publish? |

- **TXT verification:** `apple-domain-verification=…` is exactly Apple's documented process —
  the app vendor asks you to publish a token in DNS to prove domain control (the same pattern
  as Google/Bing site verification, and SPF/DMARC policy records).
- **Criteria check:** ☐ five transcripts ☐ five mappings ☐ TXT purpose verified.

## Exercise 3 — TTL comparison across resolvers

**Reference shape** (values differ per run):

```console
$ nslookup -query=SOA example.com
	...
	default TTL = 1800 (30 mins)
$ nslookup example.com 1.1.1.1        # a second, independent resolver
```

- What to record: zone `default TTL` (the inherited value) and, where your tools expose
  per-answer TTLs, the live countdown from each resolver at two times.
- **Why both can be correct while differing:** each resolver caches independently, so one may
  hold a fresh answer (large remaining TTL) and another an older copy (smaller remaining TTL)
  — same record, different cache age. Neither is wrong until the TTL expires; then both must
  re-fetch.
- **Criteria check:** ☐ four values ☐ both-correct explanation.

## Exercise 4 — Zero-downtime migration runbook (independent)

**Reference shape** — a reviewer checks for this structure:

1. **Before:** lower the record's TTL (e.g. 300s) *first*; **wait one full old-TTL period** so
   every cache that holds the old high value expires. (Miss this and your change propagates at
   the *old* TTL — the step everyone forgets.)
2. **Verify:** query the **authoritative** server directly (`nslookup <name> <auth-ns-ip>`) —
   confirms the new TTL is live, bypassing caches.
3. **Cutover:** change the address record to the new host; verify from authoritative, then
   from a public resolver (e.g. `1.1.1.1`), then from your machine — three vantage points show
   which caches have caught up.
4. **Validate traffic:** confirm hits arriving at the new host (its logs) before considering
   the old one drained.
5. **Rollback trigger/action:** if new-host health checks fail within the TTL window → restore
   the original record value immediately; caches still holding *that* value serve it without a
   fresh lookup (the runbook's rollback depends on caches never having seen a *third* value).
6. **Residual-risk paragraph:** caches you don't control (OS stubs, corporate resolvers) may
   answer with the pre-migration value until their TTL runs out; **negative caching** means a
   name that briefly failed to resolve may stay refused briefly after; some resolvers clamp
   TTLs they consider too long or too short. Timings derive from your real TTL numbers.
- **Criteria check:** ☐ timings from real TTLs ☐ per-step verification command ☐ rollback
  trigger + action ☐ residual-risk paragraph.

---

Next: [set-5-solutions.md](set-5-solutions.md)
