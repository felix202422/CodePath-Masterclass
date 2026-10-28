# Set 7 solutions — Validation and error handling → `validation-and-error-handling.md`

*Executed in the batch's `spring-smoke` lab; the three-violation battery and the five-
failure envelope sweep are this batch's `ApiContractTest` and its curl predecessors.*

## 1. Total validation, predicted first

Prediction (paper): one body — `{"sku":"","qty":0,"note":"…x"}` where `qty` is below 1
and `sku` is blank — **two** field violations reported together, sorted `qty` before `sku`
(alphabetical). Executed (the contract test):

```
HTTP 400
{"type":"https://errors.example.invalid/validation","status":400,
 "detail":"request body failed validation",
 "fieldErrors":[{"field":"qty",…},{"field":"sku",…}]}
```

`fieldErrors.length() == 2`, index 0 = `qty`, index 1 = `sku` — the sort asserted as a
test, not a claim. The malformed-body case is a different species, captured separately:
body `{"sku":` (truncated JSON) → 400 with `type: …/malformed-body` and **no**
`fieldErrors` — nothing to enumerate, because the envelope never parsed. Two types, two
client branches: fix-the-fields vs fix-the-request.

## 2. One envelope, five failures

Five captures collected:

| Failure | Status | `type` |
|---|---|---|
| Blank field | 400 | `…/validation` |
| Unknown order id | 404 | `…/not-found` (body: **empty** — the IDOR rule) |
| Stock conflict | 409 | `…/stock-conflict` |
| No credentials | 401 | `…/credentials` |
| `Content-Type: text/csv` | 415 | `…/unsupported-media-type` |

Shared shape checked field by field: `type`, `status`, `detail` present in every
*enveloped* body. The deliberate difference, defended: the 404 carries an empty body —
that is not an envelope violation, it is a *stronger* rule (lesson 11): a foreign read
must be indistinguishable from a missing row, and any `detail` text would be an
existence signal. The contract page says so in advance; the handler implements it with
`ResponseEntity.notFound()`, not with a missing `@ExceptionHandler`.

## 3. Domain refusals as exceptions

Table written before running:

| Exception (service) | Predicted status |
|---|---|
| `StockConflict` | 409 |
| `OrderNotFound` | 404 |
| `IllegalArgumentException` (qty 0) | 400 |
| anything else | 500, no details |

Executed: 409 capture with `…/stock-conflict` and the numbers in `detail`
(`has 3 in stock, requested 5` — the unit test asserts that exact message); 400 for the
rejected parameter. The mapping I got wrong on paper: I predicted 400 for
`StockConflict` on the reasoning "the client sent an impossible qty" — executing the
diff against a *taken-but-valid* resource showed 409 is the correct family: the request
is well-formed and conflicts with current state. Correction: 4xx is not one thing;
`400` = malformed intent, `409` = valid intent, contested state.

## 4. Independent — error contract page (reference shape)

The one-page contract (shape): envelope = `{type, status, detail, fieldErrors?}`;
statuses: 400 `validation` | 400 `invalid-parameter` | 401 `credentials` |
403 `forbidden` | 404 *(empty body, by design)* | 409 `conflict` | 413 `too-large` |
415 `unsupported-media-type` | 429 `rate-limited` | 500 `internal` (detail = `contact
support with rid`). Implemented, three executed failures proving it: 400 (two sorted
violations), 409 (conflict with `detail` carrying both numbers), 415 (content-type
refusal). Diff found: my contract promised `fieldErrors` on 400s but I had implemented
one 400 family (`invalid-parameter`) without fields — contract fixed *and* the handler's
empty-list omission corrected, because a client written to my contract would index
`fieldErrors` unguarded.