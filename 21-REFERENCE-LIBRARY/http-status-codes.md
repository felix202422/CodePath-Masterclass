# HTTP Status Codes

Every standard status code, grouped by class, with the question each one answers: *did it work, and
what may the client conclude?* Definitions follow RFC 9110 (HTTP Semantics), which is the current
normative reference.

> **Baseline.** RFC 9110 (semantics), RFC 9111 (caching), RFC 6585 (428, 429, 431, 511) and RFC 8297
> (103). Reason phrases are conventional, not semantic — a client must branch on the three-digit
> code, never on the text.

## The classes

| Class | Meaning | The client may assume |
|---|---|---|
| `1xx` | Informational — a provisional response, followed by the real one. | The request was received; keep waiting. |
| `2xx` | Success. | The request was understood and accepted. |
| `3xx` | Redirection — further action is needed to complete the request. | Follow `Location` (with the method rules below). |
| `4xx` | Client error — the request is wrong in a way the client can usually fix. | Do not retry unchanged. |
| `5xx` | Server error — the request was valid but could not be fulfilled. | Retry may work later; the cause is not yours. |

The class is a promise, not decoration. Returning `200` with `{"error": "..."}` breaks every client,
proxy and monitor that reads the status line — and they all read the status line.

## 1xx — informational

| Code | Reason | When |
|---|---|---|
| `100` | Continue | The server wants the request body; sent automatically in response to `Expect: 100-continue`. |
| `101` | Switching Protocols | Upgrading the connection, such as to WebSocket. |
| `103` | Early Hints | Send `Link: rel=preload` before the final response so the browser can start fetching. |

These are rarely written by application code; servers and reverse proxies emit them.

## 2xx — success

| Code | Reason | Use it for | Notes |
|---|---|---|---|
| `200` | OK | Any successful request returning a representation. | The default success. |
| `201` | Created | A `POST`/`PUT` that created a resource. | Must include `Location` for the new resource. |
| `202` | Accepted | The request was queued for asynchronous processing. | The body should say how to check progress. |
| `203` | Non-Authoritative Information | A proxy transformed the payload. | Rarely used deliberately. |
| `204` | No Content | Success with nothing to return — `DELETE`, or an `update` with no body. | Must not include a body. |
| `205` | Reset Content | Ask the client to reset the view (clear a form). | Rare; `204` plus client logic is clearer. |
| `206` | Partial Content | A range request (`Range: bytes=...`) succeeded. | Requires `Content-Range`; used for video seeking and resumable downloads. |

**The 200-versus-201 rule:** if the request created something addressable that did not exist before,
`201` with `Location`; otherwise `200`.

## 3xx — redirection

| Code | Reason | Method after redirect | Cacheable by default |
|---|---|---|---|
| `300` | Multiple Choices | Client chooses. | No |
| `301` | Moved Permanently | Historically may change `POST` to `GET`. | Yes |
| `302` | Found | Historically may change `POST` to `GET`. | No |
| `303` | See Other | Always `GET`. The correct response after a successful form `POST` that redirects. | No |
| `304` | Not Modified | Not applicable — no body. | N/A |
| `307` | Temporary Redirect | Method and body preserved. | No |
| `308` | Permanent Redirect | Method and body preserved. | Yes |

Use `307`/`308` when the method matters (API endpoints), and `303` for the post/redirect/get pattern in
browser forms. `301`/`302` are the legacy pair whose method rewriting is historically inconsistent —
avoid them where a `POST` is involved.

`304` is only sent in answer to a conditional request (`If-None-Match`, `If-Modified-Since`) and must
repeat the validators (`ETag`, `Cache-Control`) that would have accompanied a `200`.

## 4xx — the client's request is wrong

| Code | Reason | Use it for | Do not use it for |
|---|---|---|---|
| `400` | Bad Request | Malformed syntax, unparseable body, missing required parameter. | Validation rules on a well-formed payload — use `422`. |
| `401` | Unauthorized | No valid credentials, or expired ones. | A user who is authenticated but not allowed. |
| `403` | Forbidden | Authenticated, but the action is not permitted. | Anonymous requests — that is `401`. |
| `404` | Not Found | No such resource — including "exists but you may not see it", to avoid leaking existence. | A resource that was deleted and should be advertised as gone (`410`). |
| `405` | Method Not Allowed | The path exists but not for this verb. | Must send `Allow: GET, POST`. |
| `406` | Not Acceptable | No representation matches the `Accept` header. | Content negotiation that you simply did not implement. |
| `408` | Request Timeout | The client was too slow sending the request. | A slow upstream — that is `504`. |
| `409` | Conflict | The request conflicts with current state: duplicate unique value, version mismatch. | Simple validation failure. |
| `410` | Gone | The resource existed and was deliberately removed. | Anything you might restore. |
| `411` | Length Required | `Content-Length` is mandatory for this endpoint and missing. | — |
| `412` | Precondition Failed | `If-Match`/`If-Unmodified-Since` did not hold — the optimistic-concurrency response. | A missing validator — that is `428`. |
| `413` | Content Too Large | The body exceeds the server's limit. | — |
| `414` | URI Too Long | The target is longer than the server accepts. | Deep pagination — use cursors instead. |
| `415` | Unsupported Media Type | `Content-Type` is not one the endpoint accepts. | A malformed body of the right type — that is `400`. |
| `416` | Range Not Satisfiable | The `Range` header cannot be satisfied. | — |
| `417` | Expectation Failed | An `Expect` header cannot be met. | — |
| `421` | Misdirected Request | The connection is reused for a host the server cannot serve. | — |
| `422` | Unprocessable Content | The body parses but fails semantic validation — the usual "invalid field" response. | Malformed JSON. |
| `425` | Too Early | The request may be replayed; TLS early-data replay protection. | — |
| `426` | Upgrade Required | The client must switch protocols (usually to TLS). | — |
| `428` | Precondition Required | The server requires `If-Match` to avoid lost updates. | A failed precondition — that is `412`. |
| `429` | Too Many Requests | Rate limit exceeded. | Must send `Retry-After`. |
| `431` | Request Header Fields Too Large | The header block exceeds the server's limit. | — |
| `451` | Unavailable For Legal Reasons | Blocked for legal or policy reasons. | — |

### `401` or `403`?

- **`401`** means "I do not know who you are" — no credentials, bad credentials, expired session. It must include `WWW-Authenticate` describing the scheme.
- **`403`** means "I know who you are, and the answer is no" — a missing role, a resource owned by someone else (when you choose to reveal that it exists).

Sending `401` to a logged-in user makes clients try to re-authenticate forever; sending `403` to an
anonymous user hides the real problem.

### `400` or `422`?

`400` is about *syntax*: the request could not be parsed. `422` is about *semantics*: it parsed, but
the values are unacceptable. Many APIs use `400` for both, which is defensible only if the error body
says which field failed and why.

### `404` or `410`?

`404` says "I have no such resource"; `410` says "it existed and is permanently gone". `410` invites a
client to stop asking and purge caches, so use it only when that is true.

## 5xx — the server failed

| Code | Reason | Use it for | Notes |
|---|---|---|---|
| `500` | Internal Server Error | An unhandled exception; the default. | Log the cause with a correlation id; never leak the stack trace to the client. |
| `501` | Not Implemented | The method or feature is not supported by this server. | — |
| `502` | Bad Gateway | A proxy received an invalid response from upstream. | Usually the proxy emits it, not your app. |
| `503` | Service Unavailable | Overloaded or in maintenance. | Send `Retry-After`; this is the honest response to a shed request. |
| `504` | Gateway Timeout | The upstream did not answer in time. | Raised by the proxy; the app may still be working. |
| `505` | HTTP Version Not Supported | The request used a version the server refuses. | — |
| `511` | Network Authentication Required | A captive portal or proxy requires authentication. | — |

**`500` or `503`?** `500` means this request hit a bug. `503` means the service cannot take work right
now — overload, dependency outage, deployment — and a retry later is expected to succeed.

## Method semantics that determine the code

| Method | Safe | Idempotent | Request body | Success codes |
|---|---|---|---|---|
| `GET` | Yes | Yes | Not meaningful | `200`, `304` |
| `HEAD` | Yes | Yes | No | `200` (headers only) |
| `POST` | No | No | Yes | `201`, `202`, `200` |
| `PUT` | No | Yes | Yes | `200`, `201`, `204` |
| `PATCH` | No | Not guaranteed | Yes | `200`, `204` |
| `DELETE` | No | Yes | Optional | `204`, `202`, `200` |
| `OPTIONS` | Yes | Yes | No | `204` with `Allow` |

*Safe* means no intended change; *idempotent* means repeating it has the same effect as doing it once.
A client may retry an idempotent request after a timeout; retrying a `POST` needs an idempotency key.

## Caching, in one table

| Status | Heuristically cacheable (RFC 9110 §15) |
|---|---|
| `200`, `203`, `204`, `206` | Yes |
| `300`, `301`, `308` | Yes |
| `404`, `405`, `410`, `414`, `501` | Yes |
| `302`, `307` | No — must say so with `Cache-Control` |
| `400`, `401`, `403`, `500`, `503` | No |

Cacheability still needs a freshness signal: `Cache-Control: max-age=60`, `s-maxage` for shared
caches, `no-store` for anything private. `ETag` plus `304` saves bandwidth, not a round trip — the
client still asks, the server just answers "unchanged" with no body.

## Headers that go with the code

| Status | Required or strongly advised header |
|---|---|
| `201` | `Location: /orders/42` |
| `3xx` | `Location`; `Cache-Control` when you want a `302`/`307` cached |
| `304` | `ETag`, `Cache-Control` |
| `401` | `WWW-Authenticate: Bearer realm="api"` |
| `405` | `Allow: GET, POST` |
| `412`, `428` | `ETag` of the current representation |
| `429`, `503` | `Retry-After: 30` (seconds or an HTTP date) |
| Any | `Content-Type` on every body; a correlation id header for 5xx |

## Choosing a code quickly

| Situation | Code |
|---|---|
| Created a resource | `201` + `Location` |
| Accepted for background processing | `202` |
| Deleted, nothing to return | `204` |
| Validation failed on a parsed body | `422` |
| Body not valid JSON | `400` |
| Not logged in / token expired | `401` |
| Logged in, wrong role | `403` |
| Duplicate unique value | `409` |
| Version conflict on update | `412` (or `409` if you do not use `ETag`) |
| Rate limited | `429` + `Retry-After` |
| Dependency down, retry later | `503` + `Retry-After` |
| Unhandled bug | `500`, logged with a correlation id |

## Common mistakes

| Mistake | Why it hurts | Correct approach |
|---|---|---|
| `200` with `{"success": false}` | Proxies, caches and monitors treat it as success. | Use the 4xx/5xx code that matches. |
| `403` for anonymous users | Clients cannot tell "log in" from "you may not". | `401` with `WWW-Authenticate`. |
| `401` for insufficient role | Clients loop on re-authentication. | `403`. |
| `404` disguising a `500` | Real failures vanish from error dashboards. | Let the exception map to `500`. |
| `500` for validation | Your error budget absorbs the client's bug. | `400`/`422`. |
| `302` after a `POST` from an API client | The client may repeat the `POST` as a `GET` and lose the body. | `303` for browsers, `307` for APIs. |
| Returning a body with `204` | Some clients choke; the spec forbids it. | `204` with no body, or `200` with one. |
| No `Allow` on `405` | The client cannot discover what is supported. | Always send it. |

## Related pages

- [Common Errors](common-errors.md) — what these codes look like when they appear in a browser or log
- [Glossary](glossary.md) — idempotent, ETag, CORS and the surrounding vocabulary
- [06-INTERNET-AND-WEB-FOUNDATIONS/http-fundamentals.md](../06-INTERNET-AND-WEB-FOUNDATIONS/http-fundamentals.md) — the protocol lesson
- [11-BACKEND-ENGINEERING/http-and-rest-apis.md](../11-BACKEND-ENGINEERING/http-and-rest-apis.md) — designing endpoints that use these codes
- [RFC 9110](https://www.rfc-editor.org/rfc/rfc9110.html) — the normative source
