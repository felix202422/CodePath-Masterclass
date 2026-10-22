# Solutions — Set 2: Client–Server Architecture

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.

## Exercise 1 — Listening services, identified

**Reference transcript (authoring machine):**

```console
$ netstat -ano | grep LISTENING | head -10
  TCP    0.0.0.0:135            0.0.0.0:0              LISTENING       1496
  TCP    0.0.0.0:445            0.0.0.0:0              LISTENING       4
  TCP    0.0.0.0:3389           0.0.0.0:0              LISTENING       6464
  TCP    0.0.0.0:5432           0.0.0.0:0              LISTENING       15748
  TCP    0.0.0.0:5672           0.0.0.0:0              LISTENING       14084
  TCP    0.0.0.0:6379           0.0.0.0:0              LISTENING       12392
```

- Three identified: `445` = SMB file sharing, `3389` = RDP, `6379` = Redis. (Also visible:
  `5432` Postgres, `5672` AMQP — a machine you'd call a laptop runs servers exactly like
  lesson 2's ten lines of Python.)
- **Not LAN-reachable:** `6379` (Redis) and `5432` — databases with no authentication
  by default on `0.0.0.0` expose your data to every device on the network (the bind address is
  the decision made *before* any protocol logic).
- **Criteria check:** ☐ three labelled ☐ one justified exclusion.

## Exercise 2 — Server + client, second client

**Reference shape** (Example 1 of the lesson; your transcript):

```console
$ python tiny_server.py
waiting on 127.0.0.1:8780
client ('127.0.0.1', 51712) connected
got b'ping\n'
```

- The second client **blocks / hangs** until the first connection closes: `listen(1)`'s queue
  holds *pending* connections, and this server calls `accept()` only once (it exits after one).
  Two observations prove it: no second `connected` line, and the second client's `connect`
  stays pending (or completes in the kernel queue but gets no `accept()`-driven service).
- The fix isn't "raise the queue" — it's accept-in-a-loop (or threads), which set 3 does.
- **Criteria check:** ☐ first exchange captured ☐ second client explained from queue depth + one-accept code.

## Exercise 3 — Three clients in a row

**Reference shape** (from the socket lab's mechanism):

```console
$ python socklab.py
TCP server listening on ('127.0.0.1', 8771)
TCP client: connected local=('127.0.0.1', 51294) peer=('127.0.0.1', 8771)
TCP handshake complete: accepted from 127.0.0.1:51294
```

- Each `accept()` returns a **new, independent socket** carrying that client's own
  address:port — the three greetings go out on three different sockets, so nothing mixes.
- **The distinguishing value:** the `conn` returned by `accept()` (its peer port differs per
  client: `51294` vs yours). The **listening socket** could not serve them: it exists only to
  *create* per-client sockets; data never flows on it.
- **Criteria check:** ☐ three greetings ☐ per-connection socket named as the separator.

## Exercise 4 — "Word of the day" service (independent)

**Reference shape.** No single correct text; a reviewer checks:

- **Port & bind:** a high unprivileged port (e.g. `8790`), bound `127.0.0.1` if the admin
  client runs on the same machine, or the LAN interface address *as a deliberate decision*
  (the netstat lesson: `0.0.0.0` exposes it to everyone).
- **Protocol ≤5 lines**, e.g.:
  ```
  GET <newline>            → current word
  SET <word> <newline>     → replace (admin machine only sends this)
  ERR <reason> <newline>   → malformed / unknown verb
  ```
- **Two simultaneous SETs:** last-writer-wins at the server (it serializes the mutation in one
  place); state the consequence — one update is lost — and that the protocol should still reply
  `OK` to both, with the *word* echoed so the loser can observe the overwrite.
- **Honest limitation paragraph** (lesson §11): any host that can reach the port can SET —
  address:port identity ≠ user identity. Anyone on the LAN can read *and* write; the design
  works only inside a trusted network, and production would need authentication (subject 15)
  plus a narrow bind.
- **Criteria check:** ☐ get+set transcript ☐ protocol ≤5 lines ☐ no-auth limitation stated
  from §11.

---

Next: [set-3-solutions.md](set-3-solutions.md)
