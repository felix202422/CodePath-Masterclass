# Solutions — Set 5: TCP and UDP

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.

## Exercise 1 — Lab transcript annotation

**Reference transcript (authoring machine):**

```console
$ python socklab.py
UDP server bound on ('127.0.0.1', 8772)
TCP server listening on ('127.0.0.1', 8771)
TCP client: connected local=('127.0.0.1', 51294) peer=('127.0.0.1', 8771)
TCP handshake complete: accepted from 127.0.0.1:51294
TCP server recv: "PING" (4 bytes)
TCP client recv: "PONG len=4"
UDP client: local=('127.0.0.1', 60860) (bound explicitly; no connect needed to send)
UDP recvfrom: "HELLO-UDP" from 127.0.0.1:60860
UDP client got: "PONG-DATAGRAM" from 127.0.0.1:8772
UDP ghost: ConnectionResetError 10054 <- ICMP port-unreachable surfaced to the socket (Windows behavior)
```

| Line | Protocol | Printed by |
|---|---|---|
| `UDP server bound…` | UDP | server (before anything arrives) |
| `TCP server listening…` | TCP | server (after `bind`+`listen`) |
| `TCP client: connected…` | TCP | **client**, once `connect()` returns |
| `TCP handshake complete…` | TCP | **server**, inside `accept()` |
| `TCP server recv / client recv` | TCP | each side's `recv()` — reliable bytes |
| `UDP client: local=…` | UDP | client (explicit bind; no handshake) |
| `UDP recvfrom …` | UDP | server (learned peer *from the datagram*) |
| `UDP ghost: ConnectionResetError…` | UDP + host ICMP | **client's OS**, surfacing its own ICMP |
| `getaddrinfo(…)` | — | OS resolver (lesson 4), both families |

- **Handshake-evidence lines:** `connected local=…` (client's `connect()` returned) and
  `handshake complete: accepted from…` (server's `accept()` returned). The blocking calls are
  **`connect()`** on the client and **`accept()`** on the server — neither returns until the
  three-way handshake finishes (lesson §5).
- **Criteria check:** ☐ every line labelled ☐ both evidence lines + blocking calls named.

## Exercise 2 — Established connections from ports

**Reference shape** (your machine; authoring machine's pattern):

```
TCP  192.168.9.42:51294  172.66.147.243:443  ESTABLISHED  ← client side (ephemeral → well-known)
TCP  0.0.0.0:8765        0.0.0.0:0           LISTENING     ← server side (well-known, waiting)
```

- **Rule:** the *server* side carries the well-known port (443, 80, 5432, 8765 here) and stays
  stable; the *client* side has a high ephemeral port (`51294` — from lesson 2's transcript) and
  changes per connection. A pair is server iff its local port < 1024 (or a port you know the
  service owns), client iff ephemeral.
- **Ephemeral identified:** the `:51294` side — OS-assigned, not a service.
- **Criteria check:** ☐ three pairs ☐ server per pair ☐ one ephemeral labelled.

## Exercise 3 — Dead-port experiment

**Reference transcript (authoring machine, Windows):**

```console
$ python ghost.py            # sends a datagram to a port with no listener
UDP ghost: ConnectionResetError 10054 <- ICMP port-unreachable surfaced to the socket (Windows behavior)
```

- **On Windows** (this capture): the host generated ICMP port-unreachable locally, the OS
  translated it to socket error `10054`, and `recv` raised. **On many Linux/macOS setups** the
  same experiment **times out silently** — both are correct, and both are the exercise's point:
  the *protocol* produced neither; the host OS decided.
- **The second datagram** (server now running) delivered normally — nothing about the first
  failure poisoned the socket; UDP is connectionless (lesson §5), so "the server came back"
  needs no reconnect.
- **Why UDP's own silence:** no ACKs, no resets — failure signalling, if any, arrives via ICMP
  *beside* the protocol, at the host's discretion, late and indirect. Contrast TCP's
  `Connection refused`, delivered in-protocol and immediate.
- **Criteria check:** ☐ your OS's real first result ☐ second delivered ☐ protocol silence explained.

## Exercise 4 — Sensor fleet transport (independent)

**Reference shape** (a reviewer checks the reasoning, not specific ports):

- **Telemetry direction (sensor → server):** UDP. Justification from the lesson's criterion:
  readings are redundant — `n+1` supersedes `n` — so a lost packet costs nothing and a late
  retransmission is *wasted* (the "stale packet is worse than missing" rule). This also keeps
  sensors behind NAT free of connection state and lets one server socket serve thousands of
  sensors (`recvfrom` learns the sender — exercise 1's line).
- **Config direction (server → sensor):** the *messages* must be reliable-but-cheap: either
  (a) TCP for a short control connection when the sensor checks in, or (b) UDP with the
  application's own repair: sequence numbers, server retries until acknowledged, and a
  monotonically increasing config version so an old packet arriving late is discarded
  (dedup + ordering, lesson §5's "everything UDP doesn't do").
- **Implementable policy:** every datagram carries `{sensor_id, seq, timestamp}`; receiver
  drops `seq ≤ last_seen` (duplicate/old), tolerates gaps in telemetry (ignore), but for config
  requires the *exact next* version or a full re-send — timeouts: telemetry none (next one
  comes in 60 s), config retry at 1 s/2 s/4 s… with jitter, give up after N and retry on next
  sensor check-in.
- **TCP's wasted cost here:** per-connection handshakes for 60-second 100-byte messages,
  retransmitted *stale* readings after any loss, ACK traffic on a lossy rural link, and
  NAT keep-alive management for thousands of idle sensors — reliability the application would
  throw away at the next reading.
- **Criteria check:** ☐ per-direction choice + justification ☐ policy as rules (seq/timeout/
  retry) ☐ paragraph citing the stale-packet criterion.

---

Next: [set-6-solutions.md](set-6-solutions.md)
