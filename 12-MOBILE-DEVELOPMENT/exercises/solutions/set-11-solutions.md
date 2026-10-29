# Set 11 solutions — Permissions and notifications · Offline functionality → `permissions-and-notifications.md` · `offline-functionality.md`

*Executed in the batch's `scaffold` lab as batteries W13 and W14 (`flutter test`,
`provider`, `shared_preferences`). Device dialogs are **labelled reference** — the
permission *state machine* and all routing/offline logic executed here; the system sheets
need your device.*

## 1. The permission walk (executed W13 state machine)

```
unknown → denied → permanentlyDenied (settings hint) → granted → camera unlocked
```

What differs at `permanentlyDenied`, stated from the capture: the OS will never show the
dialog again — so the app's path stops asking and **presents the settings intent** (the
`openAppSettings` hint in the capture); at plain `denied` a direct re-request is still
allowed. The test drives the state machine with a fake method channel (the states are the
app's logic); the *sheet* appearing is the device-side step your on-device run captures.

## 2. Notification routing, executed (reference shape against W13's router)

```
payload order    → /confirm?id=7      (typed route + args)
payload message  → /messages/c-9
payload mystery  → /                  (default entry, by design)
```

Why the default exists: every notification opens the app *somewhere* — an unroutable
payload must land on a defined screen (home) rather than a silent no-op (app opens,
nothing happens: reads as a crash) or a throw (reads as a crash). The test asserts the
garbage payload navigates home with no exception — the default is a requirement, not a
fallback of last resort.

## 3. Offline reads and writes (executed W14)

Reads:

```
source=network stale=false      → network unreachable →
source=cache(stale) stale=true  → no cache → SocketException rethrown
```

Writes (queue receipts):

```
sent=[PUT 1, PUT 2] dedup-skipped=1 kept-pending=1
```

— the queue dedups an identical pending op (idempotency key per mutation) and keeps
failures pending for retry rather than dropping them.

Conflict versions, all three executed:

| Local v / Remote v | Policy | Result |
|---|---|---|
| 1 / 2 | remote wins | local overwritten |
| 3 / 2 | local wins | update sent, remote replaced |
| 2 / 2 | no-op | nothing sent |

Each row's capture is the policy *demonstrated*, not asserted in prose — which is how you
notice the policy has to be per-entity (a note body may merge; a balance may not).

## 4. Independent — field-notes sync contract (reference shape)

| Operation | Offline behavior | On reconnect | Conflict rule |
|---|---|---|---|
| Create note | write local, id from device | push queued ops | server adopts device id |
| Edit note | queue mutation with base version | push, server checks base | **surface**: show both versions, user picks |
| Delete note | tombstone locally | push tombstone | delete beats stale edit |
| Attach photo | store file, mark pending | upload then link | retry whole unit (never half-linked) |

Implemented rows: create + edit + conflict-surfacing tested against the W14 queue harness
(one test per row). The design sentence: conflicts are **surfaced, not silently resolved** —
the two-version picker is the visible half of the contract, and the queue receipts are its
invisible half.
