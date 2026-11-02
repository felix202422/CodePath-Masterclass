# Threat Modeling

> Every transcript in this lesson was executed on the authoring machine (Windows 11,
> Python 3.13.5, standard library only) in the batch-17 `seclab-A` scratch lab. The
> dynamic-scanning and hosted-security tooling we did not run is marked *labelled
> reference*.

## 1. Learning Objectives

After this lesson you will be able to:

- [ ] List a system's assets, entry points, and trust boundaries *before* drawing anything, and check the list against observed behavior rather than intent
- [ ] Classify each observed entry point under STRIDE and name the property (CIA or accountability) each threat attacks
- [ ] Build a small data-flow diagram whose arrows are entry points you have actually seen, not ones someone remembered
- [ ] Rank threats with an explicit likelihood × impact argument you could defend to a reviewer
- [ ] Close the loop — model → demonstration → fix → re-demonstration — and say which part of the loop you are still missing

## 2. Prerequisites

- [Security Fundamentals](security-fundamentals.md) — the CIA triad, threat vs
  vulnerability vs risk, and the verification habit this lesson applies at design time
- [14-TESTING-AND-QUALITY](../14-TESTING-AND-QUALITY/README.md) — proving claims
  with captures; a threat model is a set of claims
- [11-BACKEND-ENGINEERING](../11-BACKEND-ENGINEERING/README.md) — the request
  lifecycle whose entry points we enumerate

*No code prerequisite — the probe in Example 1 is printed in full and uses only the
standard library.*

## 3. Introduction

Threat modeling is the practice of being wrong *on paper*, cheaply, before an
attacker makes you wrong for real. Where [security-fundamentals.md](security-fundamentals.md)
names what security *is*, this lesson is the method for finding out *where yours is
missing*: enumerate what your system actually exposes, classify each exposure
against a fixed taxonomy, rank what matters, then — the step everyone skips —
**check the paper against the running system**. Example 1 walks a deliberately weak
local notes app the way an unauthenticated attacker would, five requests at a time,
and the walk disagrees with the app's own intent in four places.

## 4. The Problem It Solves

Reviews ask "is this secure?" and answer with opinions, because opinions are all
that a question without an inventory can produce. Three failure modes follow, and
each is answered by a step in this lesson:

- **The diagram that isn't the system.** Someone draws boxes from memory; the
  webhook route added last quarter, the `/debug` endpoint nobody documented, and
  the background worker with a queue handle are all absent. *Answer: enumerate
  entry points from the running system first* (Example 1 walks the routes itself).
- **The threat list that never meets code.** "SQL injection" appears in every
  threat model ever written, usually with no statement of whether *this* system is
  actually reachable — while the real finding (bob's rows readable by anyone) is
  absent. *Answer: STRIDE per observed entry point, with the observation as
  evidence* (Example 2).
- **The model that ships once.** A document produced for a compliance gate, never
  updated, never tied to a test. *Answer: model → demonstration → fix →
  re-demonstration, and an honest statement of where your loop stops* (section 10).

## 5. Core Concepts

### Assets, entry points, trust boundaries

- **Asset** — what is worth something: note contents, credentials, the config file,
  availability, and *reputation* (yes, it is on the list). Name assets concretely:
  "bob's salary note", not "user data".
- **Entry point** — every place where input crosses into your logic: HTTP routes,
  message consumers, file reads, cron jobs, CLI flags, admin consoles. The rule:
  **if a stranger can influence it, it is an entry point** — including routes you
  consider internal, because "internal" is a boundary, not a fact.
- **Trust boundary** — where the system starts trusting the caller: the edge of your
  network, the process boundary, the point where a JSON field enters SQL, the seam
  between your service and a third party. Threats cluster on boundaries; a model
  without drawn boundaries has nowhere to put them.

### Data-flow diagrams (DFD)

A DFD shows *processes* (circles/rounded boxes), *data stores* (cylinders),
*external entities* (people, third parties), and *data flows* (arrows), with trust
boundaries as dashed lines. The discipline that makes it useful: **every arrow must
correspond to an observed or verifiable flow**. Example 1's walk produces the arrows.

### STRIDE — the fixed taxonomy

Per entry point, ask all six questions; fixed taxonomies beat brainstorming because
the omissions are the point:

| Letter | Threat | Property attacked |
|---|---|---|
| **S** | Spoofing — acting as someone else | authentication |
| **T** | Tampering — altering data or code | integrity |
| **R** | Repudiation — "I never did that" with no proof | accountability / logging |
| **I** | Information Disclosure — unauthorized reading | confidentiality |
| **D** | Denial of Service — making it unusable | availability |
| **E** | Elevation of Privilege — becoming more powerful than allowed | authorization |

Six questions × N entry points is mechanical on purpose: brainstorming finds what
the group already worries about; a matrix finds what nobody mentioned.

### Ranking: likelihood × impact, argued explicitly

Rank by expected damage for *your* system, writing the argument down: who could do
it, how hard, what it costs when they do. DREAD and similar 1–10 scoring systems
are convenient but give false precision (nobody can defend "repudiation = 7");
use scores to *structure* a discussion, never to replace the argument. The honest
output is a short ordered list with a sentence per row.

### The verification loop

```mermaid
flowchart LR
    A["1. Model<br/>assets, flows"] --> B["2. Classify<br/>STRIDE per entry point"]
    B --> C["3. Demonstrate<br/>the threat, live"]
    C --> D["4. Fix<br/>the property, not the symptom"]
    D --> E["5. Re-demonstrate<br/>attack now fails"]
    E -.->|"new route / new threat"| A
```

A threat you have not demonstrated is a hypothesis; a demonstration you have not
fixed is a finding; a fix you have not re-demonstrated is a guess. The first three
steps run in this lesson; steps 4–5 are the subject's later lessons and are stated
as work, not claimed as done.

## 6. How It Works

The method, in order, for a system you own:

1. **Inventory from behavior.** Start the app, enumerate its routes, consumers, and
   stores — from code *and* from the running surface (they disagree; that is the
   finding). Example 1 does exactly this with five requests.
2. **Draw the flows.** For each entry point: which process handles it, which store
   it touches, which boundary it crosses. Arrows only for what you saw.
3. **Classify.** STRIDE down the matrix, one row per entry point. A cell where you
   answer "N/A" must say *why* (a threat is rarely absent — usually unasked).
4. **Rank.** Ordered list with likelihood × impact arguments.
5. **Demonstrate the top rows.** Attack them in an authorized environment; capture.
6. **Fix and re-demonstrate.** The fix lands as a test or a control check so the
   regression cannot return silently.

Steps 1–4 are design work; 5–6 convert the design into the evidence discipline of
[14's security testing lesson](../14-TESTING-AND-QUALITY/security-testing.md).

## 7. Practical Examples

**Example 1 — walk the entry points before you draw** (executed)

The target is a five-route notes service from the batch-17 `seclab-A` lab (a
standard-library `http.server` app). Its routes and what each handler demonstrated:

| Route | Handler behavior observed |
|---|---|
| `GET /notes` | returns **all** users' notes to any caller |
| `GET /notes/{id}` | returns any id, no ownership check |
| `POST /notes` | creates a note with `owner` taken from the request, not a session |
| `GET /debug/config` | dumps configuration incl. credentials |
| `GET /notes?id=…` | parameterised — the probe's injection attempt 404s |

```python
# Threat-model probe: observe the real entry points of a deliberately weak
# local app before trusting any diagram. Start notes_server.py, then hit every
# route the way an unauthenticated attacker would and record what comes back.
import json, threading, urllib.request, urllib.error, time
from notes_server import serve

PORT = 8091
srv = serve(PORT)
t = threading.Thread(target=srv.serve_forever, daemon=True)
t.start()
time.sleep(0.3)

def hit(method, path, body=None):
    req = urllib.request.Request(f"http://127.0.0.1:{PORT}{path}",
                                 data=body, method=method)
    if body:
        req.add_header("Content-Type", "application/json")
    try:
        with urllib.request.urlopen(req, timeout=3) as r:
            raw = r.read().decode()[:120]
            return r.status, raw
    except urllib.error.HTTPError as e:
        return e.code, e.read().decode()[:120]
    except Exception as e:
        return "ERR", str(e)

# every route the app exposes — walked one by one
print("GET  /notes              ->", *hit("GET", "/notes"))
print("GET  /notes/2            ->", *hit("GET", "/notes/2"))
print("POST /notes              ->", *hit("POST", "/notes", b'{"title":"pwned"}'))
print("GET  /debug/config       ->", *hit("GET", "/debug/config"))
print("GET  /notes?id=1'--      ->", *hit("GET", "/notes?id=1'--"))
srv.shutdown()
```

- **Executed output** (authoring machine, Python 3.13.5; each body truncated at 120
  characters by the probe):

```
GET  /notes              -> 200 [{"id": 1, "owner": "alice", "title": "groceries"}, {"id": 2, "owner": "bob", "title": "salary negotiation"}]
GET  /notes/2            -> 200 {"id": 2, "owner": "bob", "title": "salary negotiation"}
POST /notes              -> 201 {"id": 3, "owner": "anonymous", "title": "pwned"}
GET  /debug/config       -> 200 {"db_url": "postgres://notes_app:DevPass99@10.0.4.11:5432/notes", "jwt_secret": "dev-secret-do-not-ship", "admin_api_key
GET  /notes?id=1'--      -> 404 {"error": "not found"}
```

- **What the important lines do:** line 1 returns *another user's* row in the very
  first response — the confidentiality breach is the default behavior, not an edge
  case. Line 3 shows `owner` arriving as `anonymous` even though the client sent no
  identity, which means identity is caller-controlled (spoofing + elevation). Line 4
  hands out a database password and a signing secret over HTTP. Line 5 is the one
  *good* news: the injection payload got a `404`, so this route builds its query
  with parameters — a threat classified "observed non-vulnerable *on this route*",
  pending the deeper tests in [injection-vulnerabilities.md](injection-vulnerabilities.md).
- **How to run it:** `python threat_probe.py` (starts and stops its own server).
- **Assumptions:** Windows 11, Python 3.13.5, loopback only — no live system was
  contacted.

**Example 2 — STRIDE over the observed surface** (executed evidence, model built)

The same walk, classified. Evidence column contains only what the capture above
shows:

| Entry point | STRIDE hits | Evidence from the walk | Fix lesson |
|---|---|---|---|
| `GET /notes` | I, T | bob's row in an unauthenticated response | [access-control.md](access-control.md) |
| `GET /notes/2` | I, E | any id readable — no ownership check | [access-control.md](access-control.md) |
| `POST /notes` | S, E | `owner=anonymous` written as given | [session-security.md](session-security.md) |
| `GET /debug/config` | I, E | `jwt_secret`, `db_url` served with `200` | [secrets-management.md](secrets-management.md) |
| `GET /notes?id=…` | *(none observed)* | payload → `404` | re-test in [injection-vulnerabilities.md](injection-vulnerabilities.md) |
| any mutation | R | no request identifiers in any response | [security-testing-labs/](README.md) logging lab |

- **How to read the table:** four of five routes carry confirmed threats with
  captured evidence; one route is *observed clean on one probe* — which is weaker
  than "secure" and is written that way on purpose; the last row is an absence (no
  log/repudiation signal anywhere in the walk), which is exactly the kind of gap
  STRIDE's fixed six questions exist to surface.
- **What this does not establish:** likelihood × impact ranking, because impact
  depends on who can reach the service in production — a question for the system
  owner, and the ranking is the owner's exercise (Exercise 2.4).

**Example 3 — what a threat model cannot tell you** (labelled reference)

Everything above runs against one local process with a hand-built route table.
Real surface inventory uses tooling we did not run in this lesson: OpenAPI/spec
diffing, crawling production traffic, cloud IAM analyzers, dependency scanners
([dependency-security.md](dependency-security.md)), and full DAST
([14's security testing lesson](../14-TESTING-AND-QUALITY/security-testing.md)).
Their outputs feed the same table — the method does not change with the tool, and
no claim here rests on a tool we did not execute.

## 8. Real-World Applications

- **Design-time review (the cheap slot)** — before a line of feature code: assets,
  flows, boundaries, STRIDE, ranked list. This is where a boundary move costs an
  afternoon instead of a migration.
- **Change-triggered re-models** — a new entry point (webhook, file upload, admin
  route) re-runs steps 1–3 for that route only. The loop in section 5 makes this
  cheap: models grow per-change, not per-quarter.
- **Compliance evidence done honestly** — auditors ask for a threat model; a
  matrix whose "evidence" column contains real captures satisfies the letter *and*
  the purpose, unlike prose that satisfies only the letter.
- **Bug-bounty / pentest scoping** — the ranked entry-point list is literally the
  scope document: what the tester may touch, and which threats you already believe
  are handled.

## 9. Common Mistakes

| Mistake | Why it happens | How to recognize it | How to prevent it |
|---|---|---|---|
| Diagram from memory | the run environment wasn't opened | a route in production that appears in no diagram | inventory the *running* system first (Example 1's habit) |
| Threat list with no entry-point mapping | taxonomy used as checklist | "SQL injection" listed, no route named | STRIDE is applied *per row* of an entry-point matrix, never once globally |
| "N/A" cells without a reason | discomfort with blank space | six columns of dashes | every N/A carries a one-sentence justification, or it is a finding |
| No ranking, or fake-precision scores | decision avoided | an unordered list, or 1–10 numbers nobody can argue | write likelihood × impact as a sentence; rank the sentences |
| Model never re-verified | treat it as a document | model older than the last feature | tie re-modeling to the change: new route ⇒ new row ⇒ new demonstration |

## 10. Best Practices

- **Start from behavior, finish with intent** — the walk finds what the system
  *does*; the model records what it *should* do; the gap is your work list.
- **One row, one entry point, one evidence cell** — granularity is what makes the
  matrix auditable; a row that says "the API" is not a row.
- **Keep a "no evidence" column visible** — unproven cells are uncomfortable and
  useful; hiding them recreates the opinion-driven review you replaced.
- **Re-model on change, not on calendar** — new entry point, new dependency, new
  data class: those events are the real triggers.
- **Rank with sentences** — "an unauthenticated caller on the internet can read any
  user's note in one request; impact: every customer" beats any numeric score.
- **Hand each fix to its lesson** — the fix column is how the model becomes a
  backlog: authorization issues go to [access-control.md](access-control.md)'s
  drills, secrets to [secrets-management.md](secrets-management.md).

## 11. Limitations and Trade-Offs

- **The model is only as complete as the inventory** — anything unreachable from
  the walk (message consumers, cron, admin tooling) is invisible to this matrix.
  That is a scope statement, not a defect: state what was *not* enumerated.
- **STRIDE can generate noise** — six questions per route on a large surface
  produces hundreds of rows; without ranking (step 4) teams drown or file
  everything. The fix is ruthless prioritization, not more columns.
- **One local app, hand-built** — every capture here is from a deliberately weak
  five-route service; it demonstrates the method, not a general vulnerability rate.
- **Threat models decay** — like tests, they rot on a schedule; the trade is
  continuous light maintenance (per-change re-modeling) versus periodic expensive
  reconstruction. The former wins on every system that ships weekly.
- **No exploit depth here** — this lesson classifies; the exploitation and the fix
  for each class are carried by the subject's later lessons, which is why the fix
  column links rather than asserts.

## 12. Practical Exercises

### Introductory

1. **Exercise 2.1** — pick a service you use daily and write its asset list (five
   items max) and its entry points (from its public documentation/API spec).
   **Completion criteria:** every asset is named concretely ("the payment method on
   file", not "user data"), and every entry point is one a stranger could reach.
2. **Exercise 2.2** — take Example 1's walk output and draw the DFD by hand:
   processes, stores, external entity, trust boundaries. **Completion criteria:**
   every arrow traces to one of the five captured responses; any arrow you cannot
   trace is deleted or marked *assumed*.

### Intermediate

3. **Exercise 2.3** — complete the STRIDE matrix for three entry points of your own
   system, walking the real surface first (start it, hit it, record statuses).
   **Completion criteria:** one evidence string per confirmed cell, and an explicit
   reason for every "N/A".
4. **Exercise 2.4** — rank Example 2's four confirmed threats. **Completion
   criteria:** an ordered list where each row carries a likelihood × impact
   sentence, and the top row states who could exploit it and what it costs them.

### Independent problem-solving

5. **Exercise 2.5** — write the fix for the top-ranked threat, deploy nothing, and
   instead produce the *re-demonstration plan*: the exact request you would re-run
   after the fix and the exact response you expect. **Completion criteria:** the
   plan names the request, the expected failure code/body, and which lesson
   teaches the fix — steps 4–5 of the loop, specified without pretending they ran.

*Solutions: attempt first. They live in `solutions/` of this subject (written with
the subject's exercise installment).*

## 13. Knowledge Check

1. Why must the entry-point inventory come from the running system rather than the
   design document — and what do you do when they disagree?
2. Name the STRIDE category for each: a user clears their browser history to hide
   an action they took; a support agent edits their own salary record; a rate limit
   that is skipped by an internal route. Justify each in one sentence.
3. What is the difference between a threat classified "observed non-vulnerable on
   this route" and one classified "secure"? Why does the first wording survive
   review and the second does not?

## 14. Completion Criteria

- [ ] You can produce assets, entry points, and trust boundaries for an unseen system without opening its source
- [ ] You can fill a STRIDE cell for any entry point and justify an "N/A" in one sentence
- [ ] You can read a DFD and say which arrows were observed versus assumed
- [ ] You can rank threats with written likelihood × impact arguments, no 1–10 scores needed
- [ ] You can state which step of the verification loop you have actually completed for your own system

## 15. Summary

- Inventory from behavior first: routes you walked, not routes you remember, and
  trust boundaries where the system starts believing the caller.
- STRIDE is a fixed six-question sweep per entry point — mechanical on purpose, so
  omissions show up as empty cells instead of absent thoughts.
- Ranking is an argued sentence about likelihood and impact for *your* system;
  numeric scores are scaffolding, not decisions.
- The loop is model → demonstrate → fix → re-demonstrate, and an honest model
  marks which step it stopped at.
- Example 1's five responses produced four confirmed threats, one observed-clean
  route, and one absence (no logging) — the shape of almost every real first walk.

## 16. Next Steps

- Next lesson: [Password Security](password-security.md) — the first threat from a
  model like this, taken apart with four executed probes
- Earlier lesson: [Security Fundamentals](security-fundamentals.md) — the triad and
  the verification habit this method depends on
- Practice: the subject's exercise set (written with its exercise installment)
- Where it is applied: [Project 07](../20-PROJECT-LABORATORY/project-07-secure-production-application/README.md)
  requires a threat model before its first deploy; safe-use rules in
  [SECURITY.md](../SECURITY.md)