# Solutions — Set 7: HTTPS and TLS

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.

## Exercise 1 — Inspect two sites

**Reference transcript (authoring machine):**

```console
$ echo | openssl s_client -connect example.com:443 -servername example.com 2>/dev/null | grep -E "subject=|issuer=|Cipher is|Verify return"
subject=CN=example.com
issuer=C=US, O=SSL Corporation, CN=Cloudflare TLS Issuing ECC CA 3
New, TLSv1.3, Cipher is TLS_AES_256_GCM_SHA384
Verify return code: 0 (ok)

$ echo | openssl s_client -connect example.com:443 -servername example.com 2>/dev/null | openssl x509 -noout -dates -ext subjectAltName
notBefore=Sep 26 22:49:11 2026 GMT
notAfter=Dec 25 22:56:35 2026 GMT
X509v3 Subject Alternative Name: 
    DNS:example.com, DNS:*.example.com
```

- **Which layer checked each item:** issuer chain → **chain validation against the trust store**;
  `notAfter` → **validity check** (client clock vs dates); SAN → **hostname verification**;
  protocol/cipher → **handshake negotiation**; verify code → the *summary* of the first two.
- **Wildcard rule:** `*.example.com` covers exactly one label — `www.example.com` ✓,
  `example.com` itself ✗ (no label matched the `*`), `a.b.example.com` ✗ (two labels).
- **Second site (yours):** same five fields; also note *issuer type* — public CA (browsers
  already trust it) vs private/in-house (you must distribute the root yourself).
- **Criteria check:** ☐ two transcripts ☐ per-item layer mapping ☐ wildcard match + non-match.

## Exercise 2 — Version floor, executed

```console
$ echo | openssl s_client -connect example.com:443 -tls1_2 2>/dev/null | grep -E "Protocol|Cipher is"
New, TLSv1.2, Cipher is ECDHE-ECDSA-CHACHA20-POLY1305
Protocol: TLSv1.2

$ echo | openssl s_client -connect example.com:443 -tls1 2>&1 | head -2
E0640000:error:0A0000BF:SSL routines:tls_setup_handshake:no protocols available:...

$ echo | openssl s_client -connect example.com:443 -tls1_1 2>&1 | head -2
30660000:error:0A0000BF:SSL routines:tls_setup_handshake:no protocols available:...
```

- **Who refused:** the *local* OpenSSL build refused before any packets — TLS 1.0/1.1 are
  disabled in its configuration (the error comes from `tls_setup_handshake`, client side).
  A server-side refusal looks different: the handshake starts, then dies with
  `handshake failure` / no protocol overlap. Both ends enforcing the floor is the modern
  posture; note the honest difference between *your tool refusing* and *the server refusing*.
- **Why refusal is correct:** 1.0/1.1 have broken constructions (BEAST, POODLE-class issues)
  and no safe cipher modernity can rescue — keeping them "for compatibility" would accept
  downgrade-to-broken.
- **Criteria check:** ☐ 1.2 cipher transcript ☐ both failure messages verbatim ☐ refuser
  identified + why correct.

## Exercise 3 — Real failure, classified

**Reference transcript (authoring machine):**

```console
$ echo | openssl s_client -connect expired.badssl.com:443 -servername expired.badssl.com 2>/dev/null | grep "Verify return code"
    Verify return code: 10 (certificate has expired)
```

Python's client raises the same class client-side:

```console
$ python tls_probe_expired.py
ssl.SSLCertVerificationError: [SSL: CERTIFICATE_VERIFY_FAILED] certificate has expired
```

- **Classified:** verify code **10 = expired** — validity-window failure, *not* chain, *not*
  hostname. Repair table: renew/install a current certificate (or point the client at a host
  with one); nothing about the cipher or path is wrong.
- **The wrong fix, named and rejected:** `ssl.CERT_NONE` / `check_hostname=False` makes the
  message disappear by **not checking** — converting a *detectable* MITM into an *invisible*
  one: an attacker with any certificate (expired, self-signed, wrong host) is now accepted
  identically. The message is the security working; fix the certificate, never the check.
- **Criteria check:** ☐ both messages ☐ code 10 mapped ☐ wrong fix + MITM justification.

## Exercise 4 — Follow a chain by hand (independent)

**Reference shape:**

```console
$ echo | openssl s_client -connect example.com:443 -showcerts 2>/dev/null | sed -n '/Certificate chain/,/---/p'
Certificate chain
 0 s:CN=example.com
   i:C=US, O=SSL Corporation, CN=Cloudflare TLS Issuing ECC CA 3
   ...
```

- **Leaf** `s:CN=example.com` signed by **intermediate** `i:...Cloudflare TLS Issuing ECC CA 3`;
  the intermediate's own issuer points to a root (e.g. `Cloudflare Root ECC` / a well-known
  root CA) which you'll find in the OS/browser trust store — the chain's last link, pre-trusted.
- **Why intermediates:** roots are baked into every device and are hard/impossible to reissue;
  keeping them **offline** (they sign rarely) and letting online intermediates do daily signing
  limits a root's exposure and lets the ecosystem rotate intermediates without re-shipping
  trust stores to billions of devices.
- **Criteria check:** ☐ leaf + intermediate subjects ☐ root named ☐ offline-root argument.

---

Next: [set-8-solutions.md](set-8-solutions.md)
