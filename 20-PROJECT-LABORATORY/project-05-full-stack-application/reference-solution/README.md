# Reference solution guide — Project 05

> **Stop.** Build the claim flow and watch an optimistic update roll back before reading this. The
> rollback is the part everyone gets wrong the first time, and the guide only makes sense after you
> have seen your own version flicker.

One defensible design. The seams between browser, server and database are the subject.

## Sessions, not tokens in storage

The cookie carries an opaque 256-bit token; the database stores only its hash:

```text
POST /auth/signin
  verify Argon2id hash
  DELETE FROM sessions WHERE user_id = $1 AND expires_at < now()   -- hygiene
  INSERT INTO sessions (token_hash, user_id, expires_at) VALUES (sha256(token), $1, now() + 30 min)
  Set-Cookie: sid=<token>; HttpOnly; Secure; SameSite=Lax; Path=/; Max-Age=1800
```

Why opaque rather than a JWT: revocation is a `DELETE`, and `NFR-4`'s idle timeout needs a server-side
`last_seen_at` anyway. A JWT would need a denylist to match this, which is the same table with more
steps. The cost is a database read per request, which is a single indexed lookup and irrelevant at this
scale. Say this in the ADR, because "JWT is stateless" is the answer an interviewer expects and the
reasoning is the point.

`SameSite=Lax` blocks cross-site `POST`s from a form; it does not stop a same-site subdomain, so the
CSRF token stays. Double-submit:

```text
sign-in response:  Set-Cookie: csrf=<random>; Secure; SameSite=Lax; Path=/   (not HttpOnly)
client reads it:   document.cookie -> sends X-CSRF-Token: <random>
server:            constant-time compare header with the cookie; 403 on mismatch
```

The CSRF cookie is deliberately readable by JavaScript — that is the mechanism, not a bug. The session
cookie is not. A common failure is marking both `HttpOnly` and then wondering why every mutation 403s.

## The claim transaction

The capacity check and the insert must be one transaction with the shift row locked:

```sql
BEGIN;
SELECT id, capacity FROM shifts WHERE id = $1 FOR UPDATE;
SELECT count(*) FROM claims WHERE shift_id = $1 AND released_at IS NULL;
-- count >= capacity -> ROLLBACK, return 409 "shift is full"
INSERT INTO claims (shift_id, user_id) VALUES ($1, $2)
  ON CONFLICT (shift_id, user_id) WHERE released_at IS NULL DO NOTHING
  RETURNING id;
-- no row -> already claimed, 409 "you already hold this shift"
INSERT INTO outbox (kind, payload) VALUES ('claim_confirmation', $3);
COMMIT;
```

`FOR UPDATE` serialises two claims on the same shift, so the count cannot be stale. The partial unique
index is the second line of defence and gives idempotency for a double-click. Without the lock, the
test passes until two requests arrive in the same millisecond — which is exactly what the Playwright
test with two browser contexts does.

Do not put the email send inside the transaction. `FR-11` says queued, and a slow SMTP server inside a
row lock turns a claim into a timeout.

## Optimistic claim with a correct rollback

The state that must be right is not "is this slot mine" but "what did it look like before I tried". A
React Query mutation with an explicit snapshot:

```ts
const claim = useMutation({
  mutationFn: (shiftId: string) => api.post(`/shifts/${shiftId}/claims`),
  onMutate: async (shiftId) => {
    await queryClient.cancelQueries({ queryKey: ["week", week] });
    const previous = queryClient.getQueryData<Week>(["week", week]);
    queryClient.setQueryData<Week>(["week", week], (w) => markMine(w, shiftId));
    return { previous };
  },
  onError: (err, _id, ctx) => {
    if (ctx?.previous) queryClient.setQueryData(["week", week], ctx.previous);
    setConflict(messageFor(err));          // 409 -> "Sam claimed this a moment ago"
  },
  onSettled: () => queryClient.invalidateQueries({ queryKey: ["week", week] }),
});
```

Four details make the difference between a demo and `AC-7`. `cancelQueries` first, or an in-flight
refetch overwrites the optimistic state. Snapshot the whole week, not the one slot, or a rollback loses
a concurrent change to another slot. `onSettled` invalidates even on success, because the server's
version (capacity left, who else claimed) is the truth. And the error message must survive the rollback
— a toast keyed to the mutation, not to the slot, so it does not vanish when the slot re-renders.

The `409` body should name the holder only if the caller is allowed to see it. "Someone claimed this a
moment ago" is always safe; naming a volunteer is a small privacy leak the coordinator view can afford
and the volunteer view cannot.

## Week data and cache keys

One endpoint returns the whole week; the UI derives everything from it. Cache key `["week", isoWeek]`,
and `["me", "shifts"]` for the personal list, invalidated by every successful claim or release. Keys
that include the filter (`["week", isoWeek, {role, freeOnly}]`) cause a refetch per filter change for no
benefit at this size — filter in memory, one key.

ISO week handling is a real bug source: `new Date("2026-01-01")` is in week 53 of 2025 in ISO terms.
Use a library (`date-fns`'s `getISOWeek`) or write the algorithm and test the three edge cases: 1
January, 31 December, and a leap year. `FR-2` says "current week", so the boundary is reachable every
year.

## Shared validation

The rules live once, in a module both sides import, expressed as data:

```ts
export const shiftSchema = {
  role:      { required: true, oneOf: ["COOK", "SERVER"] },
  startTime: { required: true, pattern: /^([01]\d|2[0-3]):[0-5]\d$/ },
  capacity:  { required: true, integer: true, min: 1, max: 6 },
};
```

The browser renders messages beside fields from this object; the server serialises the same object and
rejects with `errors: [{field, message}]`. The server remains the authority — the client module is a
copy for speed, and the integration test asserts the server rejects what the client rejects. Sharing the
*schema* rather than the *validation library* keeps the API dependency-free and works if the backend is
not Node.

## Server-side authorisation

Three rules, all in the service layer with a test each:

1. `POST/PATCH/DELETE /shifts` require `role = COORDINATOR`.
2. `DELETE /shifts/{id}/claims/me` requires the claim's `user_id` to equal the session user.
3. `DELETE /shifts/{id}/claims/{userId}` requires `COORDINATOR`.

The third is where the IDOR lives: a volunteer sends another volunteer's id and the endpoint trusts it.
The test is a volunteer token against that route expecting `403` **and** a database assertion that the
claim is still active. Checking only the status code can pass while the service deleted the row before
throwing.

In React, route guards prevent a blank screen and nothing else. The admin route being hidden from a
volunteer is UX; the 403 from the API is the control.

## Testing the seams

Playwright, two contexts, one test:

```ts
const [a, b] = await Promise.all([browser.newContext(), browser.newContext()]);
await signIn(a, "ada@example.org");
await signIn(b, "sam@example.org");
await Promise.all([claim(a, "Friday cook"), claim(b, "Friday cook")]);
expect(await status(a, "Friday cook")).toMatch(/Yours|Full/);
expect(await status(b, "Friday cook")).toBe("Full");
```

Running the two claims concurrently is the point; sequential claims test the happy path twice. Add a
second test for the rollback: intercept the claim request with `route.fulfill({status: 409})` and assert
the card reverts and the message is visible. That is `AC-7` without needing a real race.

For `NFR-1` and `NFR-7`, a Lighthouse CI budget on the built app, not the dev server. The dev server's
unminified bundle fails a size budget that production passes, and running it against `npm run dev` is a
common way to get a misleading number.

## Trade-offs and alternatives

- **Cookie session versus JWT.** Revocation and idle timeout are trivial with a session row; scale-out
  without shared storage is trivial with a JWT. Two servers and one Postgres is not a scale problem, so
  the session wins. The ADR should say what would change the answer.
- **React Query versus hand-rolled hooks.** The library gives cancellation, retries and invalidation for
  free, which is most of `NFR-6`. A hand-rolled `useEffect` version is a legitimate choice and more code.
- **Server-rendered HTML versus SPA.** An SPA is what the prerequisites teach and what the print view can
  live without. A server-rendered version would beat `NFR-1` and lose the optimistic interaction that
  `NFR-2` asks for; say so rather than pretending the SPA is strictly better.
- **One origin versus two.** One origin keeps the cookie first-party and removes CORS entirely. Two
  origins need `SameSite=None`, credentials in CORS and a preflight on every mutation — more moving
  parts for no benefit here.
- **Outbox versus direct send.** Direct send is five lines and fails the first time SMTP is slow. The
  outbox is a table and a worker; the guide uses it because `FR-11` says queued.

## What is deliberately missing

The component tree and the CSS. The structural decisions above — one week query, shared schema, snapshot
rollback — are what the project grades; the visual design is yours, and copying someone else's slot card
would remove the accessibility work that `NFR-3` measures.
