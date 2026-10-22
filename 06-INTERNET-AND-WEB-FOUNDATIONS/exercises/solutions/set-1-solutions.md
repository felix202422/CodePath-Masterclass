# Solutions — Set 1: How the Internet Works

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.

## Exercise 1 — TTL hop estimates

**Reference transcript (authoring machine):**

```console
$ ping -n 3 example.com
Reply from 172.66.147.243: bytes=32 time=5ms TTL=54
Reply from 172.66.147.243: bytes=32 time=8ms TTL=54
Reply from 172.66.147.243: bytes=32 time=9ms TTL=54

$ ping -n 1 192.168.9.1
Reply from 192.168.9.1: bytes=32 time=8ms TTL=64
```

- **Reading A (example.com, arrives 54):** the replying stack is almost certainly Linux-style
  (initial 64): 64 − 54 = **10 router decrements**. State the assumption: if the origin had
  started at 128, the answer would be 74 — which is why "TTL 54 = 10 hops" is only valid
  *with* the initial value named. Evidence for 64: the same route's tracert shows ~8+ hops
  within a 5-ms round trip (74 hops would be absurd at that latency), and public servers
  overwhelmingly use 64.
- **Reading B (gateway, arrives 64):** unchanged TTL → **zero routers decremented it** — it is
  the directly connected device (contrast loopback in the lesson: `TTL=128`, also unchanged).
- **Criteria check:** ☐ two computations ☐ initial values stated ☐ closer host smaller (yes:
  0 vs 10).

## Exercise 2 — Tracert labels

```console
$ tracert -d -h 8 example.com
  1     2 ms     4 ms     2 ms  192.168.9.1 
  2     4 ms     2 ms     3 ms  102.208.185.1 
  3    10 ms    11 ms     6 ms  102.208.186.121 
  ...
  8    10 ms     6 ms     6 ms  105.16.11.237 
Trace complete.
```

- **Hop 1 = home router** (RFC 1918 `192.168.9.1`); **hop 2 = first ISP router**
  (`102.208.185.1`, your provider's address space); **destination not reached** — the last
  shown address is `105.16.11.237`, not `172.66.147.243`, because `-h 8` capped the trace.
  "Trace complete" = the command stopped.
- **A `*` row** means that router didn't answer the probe (ICMP filtered or rate-limited) —
  route still works; only visibility is missing. Report *N/A for that hop*, not "dead hop".
- **Criteria check:** ☐ three labels ☐ `*` sentence.

## Exercise 3 — Latency under load

**Reference shape** (your numbers; authoring machine's unloaded baseline):

```console
$ ping -n 5 example.com
    Minimum = 5ms, Maximum = 9ms, Average = 7ms
```

- During a large download: expect **average latency and/or loss to rise**, jitter to widen.
  Why: the last-mile link is shared — the download consumes its capacity, so your ICMP queues
  behind it (bufferbloat shows as latency, congestion shows as loss).
- The explanation must name the metric that moved: bandwidth saturation manifests as *queueing
  delay*, not as "the server got slower". Server-side slowness would show on an *idle* link too.
- **Criteria check:** ☐ both number sets ☐ two sentences naming metric + cause.

## Exercise 4 — Measurement procedure (independent)

**Reference shape.** Three hypotheses, three discriminating measurements:

| Command | Metric | Points to… |
|---|---|---|
| `ping`/`tracert` to the server | RTT per hop, loss % | **far/lossy path** if RTT already high at hop 1+ or loss en route |
| `curl -w '%{time_namelookup} %{time_connect} %{time_starttransfer} %{time_total}'` | phase breakdown | **server slow** if `time_connect` fine but `time_starttransfer` (server's answer) high |
| Same `curl` repeated (or `mtr` where installed) | variance/loss | **lossy path** if times swing and ICMP/ TCP retransmits appear |
| `curl` from a second network (phone hotspot) | all of the above | distinguishes **your access network** from the destination side |

- **Decision branches:** high connect time → path/TCP (network); normal connect, slow
  TTFB → server processing (server); normal TTFB, slow total → throughput (bandwidth/loss);
  errors only from one network → local path.
- **Stated limitation:** you see only your side; without server-side logs you cannot separate
  "server queued" from "server computed" — ask for the server's own timing next.
- **Criteria check:** ☐ ≥3 commands with metrics ☐ every branch observable→conclusion ☐ one limitation.

---

Next: [set-2-solutions.md](set-2-solutions.md)
