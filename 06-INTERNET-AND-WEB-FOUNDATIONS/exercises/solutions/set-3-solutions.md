# Solutions — Set 3: IP Addressing and Subnets

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.

## Exercise 1 — Your own subnet

**Reference transcript (authoring machine):**

```console
$ ipconfig | grep -A4 "Default Gateway"
   Default Gateway . . . . . . . . . . : 192.168.9.1
```

(Your `ipconfig /all` or `ip a` supplies the address and prefix — commonly
`192.168.9.x/24` on home gear.)

- Hand computation for `192.168.9.0/24`: 8 host bits → 256 addresses → **254 usable**,
  range `.1`–`.254`, `.0` network, `.255` broadcast.
- Verify:

```console
$ python -c "import ipaddress; n=ipaddress.ip_network('192.168.9.0/24'); print(n, n.broadcast_address, n.num_addresses-2)"
192.168.9.0/24 192.168.9.255 254
```

- **Why private:** `192.168.0.0/16` is RFC 1918 — never routed publicly, so your address
  cannot be globally unique; it is rewritten at NAT (lesson §5) before any packet leaves.
- **Criteria check:** ☐ three captured values ☐ hand + verified range ☐ RFC 1918 sentence.

## Exercise 2 — IPv6 expansion and classification

1. `2606:4700:10::6814:179a` → `2606:4700:0010:0000:0000:0000:6814:179a`
   (the `::` replaced four zero groups; 8 groups × 16 bits = 128). **Global** — it is *not*
   in `fe80::/10`, so it is a globally routable unicast (here, anycast/CDN space).
2. `fe80::1` → `fe80:0000:0000:0000:0000:0000:0000:0001`. **Link-local** — the `fe80::/10`
   prefix means valid only on one segment, auto-configured, never forwarded by routers.
- **Criteria check:** ☐ both expansions ☐ both classifications citing prefixes.

## Exercise 3 — `10.20.4.0/22`

**By hand:**

1. Host bits = 32 − 22 = 10 → 2¹⁰ = **1024 addresses** → 1024 − 2 = **1022 usable**
2. Block spans four class-C-sized chunks in the third octet: 4, 5, 6, 7 →
   network `10.20.4.0`, broadcast **`10.20.7.255`**
3. First usable **`10.20.4.1`**, last usable **`10.20.7.254`**

**Verified:**

```console
$ python -c "import ipaddress; n=ipaddress.ip_network('10.20.4.0/22'); print(n, n.broadcast_address, list(n.hosts())[0], list(n.hosts())[-1], len(n.hosts()))"
10.20.4.0/22 10.20.7.255 10.20.4.1 10.20.7.254 1022
```

- **Criteria check:** ☐ steps shown ☐ verification ☐ no discrepancy (any discrepancy = a host
  count off-by-two; re-check the subtraction of network+broadcast).

## Exercise 4 — Address plan (independent)

**Reference shape** (one valid plan; all RFC 1918, non-overlapping):

| Site | Devices | Prefix | Usable | Headroom |
|---|---|---|---|---|
| Head office | 120 | `10.10.1.0/25` | 126 | 6 |
| Branch A | 40 | `10.10.2.0/26` | 62 | 22 |
| Branch B | 40 | `10.10.3.0/26` | 62 | 22 |
| Server room | 25 | `10.10.4.0/27` | 30 | 5 |
| Cloud VPC | 500 | `10.10.8.0/23` | 510 | 10 |

- **Justification rule:** smallest prefix that fits devices + growth (`/25`=126 ≥120,
  `/26`=62 ≥40, `/27`=30 ≥25, `/23`=510 ≥500) — the arithmetic of exercise 3 applied per row.
- **Overlap failure:** if two linked sites both use `10.0.0.0/16`, the router's longest-prefix
  table cannot distinguish them: traffic for one is delivered to the other (or a tie is
  broken arbitrarily), and the failure appears *only after linking*, half-working — the classic
  VPN join disaster (lesson §9's row). Verify with `ipaddress` pairwise across all rows before
  linking.
- **Criteria check:** ☐ every row fits with headroom ☐ no overlap (verified) ☐ failure mode
  explained from routing/NAT.

---

Next: [set-4-solutions.md](set-4-solutions.md)
