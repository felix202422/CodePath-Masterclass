# 06 — Internet and Web Foundations

Everything you build from here on is a participant in a network. This subject makes the network
visible: what happens between typing an address and seeing a page, and what guarantees you are
actually being given.

## What this subject covers

- How the internet works: packets, routers, ISPs, and the layered model that keeps it manageable.
- Client–server architecture: the pattern behind every app you will build.
- IP addressing and subnets: what an address is, what a mask does, IPv4 versus IPv6.
- DNS: the distributed phone book, record types, caching, and propagation.
- TCP and UDP: reliable versus fast, and why each exists.
- HTTP fundamentals: requests, responses, methods, status codes, headers, and content negotiation.
- HTTPS and TLS: certificates, the handshake, and what "secure" does and does not promise.
- URLs and ports: how a resource and a service are addressed.
- Browsers and rendering: parsing, the DOM, layout, painting, and where JavaScript runs.

## Why it matters

Frontend, backend, database integration, security, and deployment are all *elaborations* of this
subject. A learner who cannot trace a request cannot debug a 404, design a REST API, secure a
session, or configure a reverse proxy — they can only follow recipes. One afternoon here saves
months of treating the network as a magic cable.

## Prerequisites

- [02-PROGRAMMING-FUNDAMENTALS](../02-PROGRAMMING-FUNDAMENTALS/README.md) — you need to be able to
  write small programs to experiment with sockets and HTTP clients later.
- [01-COMPUTER-FOUNDATIONS](../01-COMPUTER-FOUNDATIONS/README.md) — binary and memory are assumed.

## Lessons

- `how-the-internet-works.md` · `client-server-architecture.md` · `ip-addressing.md` · `dns.md`
- `tcp-and-udp.md` · `http-fundamentals.md` · `https-and-tls.md`
- `urls-and-ports.md` · `browsers-and-rendering.md`

## Exercises and practice

`exercises/` are observation exercises as much as coding ones: resolve DNS names by hand, inspect
real HTTP headers with `curl`, read a TLS certificate, watch a page render with browser dev tools,
and write a tiny client that fetches and parses a response. Every exercise states exactly which
command to run and what to look for.

## Expected outcomes

You can trace a page load end to end (DNS → TCP → TLS → HTTP → render) naming each step's job;
explain the difference between TCP and UDP with a concrete use case each; read any HTTP message and
state what its status code promises; and describe what TLS protects and what it leaves exposed.

## Common blockers

- **Treating HTTP status codes as trivia.** They are contracts: `401` means "authenticate",
  `403` means "you are known but not allowed". Later subjects build on the exact meanings.
- **"Security is encryption"** — TLS protects the channel, not your application logic. Authorization
  is still your job ([15-APPLICATION-SECURITY](../15-APPLICATION-SECURITY/README.md)).

## Next

[07-HTML-AND-CSS](../07-HTML-AND-CSS/README.md) — build the document and its presentation that
travel over everything you just learned.