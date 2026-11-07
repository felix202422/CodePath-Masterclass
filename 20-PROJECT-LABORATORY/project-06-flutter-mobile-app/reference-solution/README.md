# Reference solution guide — Project 06

> **Stop.** Build the queue and kill the app mid-upload before reading this. The guide describes the
> recovery contract that makes retries safe; seeing a duplicate appear is what makes it memorable.

One defensible design for the sync engine, the local schema and the platform edges.

## The local database is the source of truth

Every write goes to SQLite inside a transaction that also writes the queue row:

```dart
Future<void> save(ObservationDraft draft) async {
  await db.transaction(() async {
    final id = draft.id ?? const Uuid().v4();
    await db.into(db.observations).insertOnConflictUpdate(
      draft.toRow(id: id, syncState: SyncState.pending, updatedAt: clock.now()));
    await db.into(db.syncQueue).insert(
      SyncQueueCompanion.insert(observationId: id, operation: 'upsert'));
  });
}
```

Two properties matter more than the code. The `id` is generated **on the client**, so the retry key
exists before the first attempt and survives a reinstall if the row does. And the queue row is written
in the same transaction, so there is no window where an observation exists with no way to sync it — the
failure mode that produces "I recorded it and it never uploaded" bug reports.

The UI reads from a `Stream` query on `observations`, so the badge updates without any manual refresh:
drift's `watch()` is the cheapest state management in the app.

## State machine and crash recovery

```text
pending --(worker picks)--> syncing --(201/200)--> synced
                             |--(5xx/timeout)--> failed --(backoff)--> pending
                             |--(4xx other)----> failed (needs user)
syncing  --(app killed)----> pending   [on next start]
```

Recovery is a single `UPDATE ... SET sync_state = 'pending' WHERE sync_state = 'syncing'` executed at
startup, before the worker runs. It is safe **only because** the POST is idempotent; without the
`Idempotency-Key` this rule converts a crash into a duplicate. The two requirements are one design, and
a solution that implements the reset without the key passes a casual test and fails `AC-3`.

The server side of idempotency is a unique index on `(user_id, idempotency_key)` and a stored response:

```sql
INSERT INTO requests (user_id, key, response) VALUES ($1, $2, $3)
ON CONFLICT (user_id, key) DO NOTHING RETURNING id;
-- no row -> SELECT the stored response and return it with 200
```

A `200` on replay rather than `201` is a deliberate signal: "this already exists". The client treats both
as success and stores the returned `server_id`.

## Backoff with jitter

```dart
Duration delayFor(int attempts) {
  final base = Duration(seconds: 2 * (1 << (attempts - 1)).clamp(1, 60));
  return base + Duration(milliseconds: Random().nextInt(1000));
}
```

Capped at 60 s and jittered, because twenty phones in a car park coming back into signal will otherwise
retry in lockstep. `attempts` persists in the queue row; a fresh app launch does not reset it, or the
retry storm survives the restart that was supposed to fix it.

Four `4xx` responses are not retryable: `400` malformed (a client bug — log it and mark failed for the
user), `401` (refresh, then retry once), `403` (stop), `409` (conflict path). Everything else, including
`408` and `429`, is retryable. A worker that retries a `400` forever is the most common bug in this
project, and the test for it is trivial once you look for it.

## Photos

Store the file path, not the bytes. `path_provider` gives an app-private directory; the row holds the
relative path so an iOS container move does not break every reference (the absolute path does move
between installs, which is a bug that only appears after an app update).

Downscale before enqueueing:

```dart
final resized = await compute(_resizeToMax, (bytes, 1600));  // off the UI isolate
```

`compute` sends the work to an isolate; doing this on the main thread is the classic 300 ms jank on
save. Upload photos before the observation, so the observation payload is small and a retry is cheap. If
the photo upload succeeds and the observation fails, the orphaned photo is cleaned up by a server job —
or simply re-uploaded, since the photo id is in the queue row and a repeat returns the same id.

## Conflict

The server returns `409` with its version when `If-Match` does not match. The guide's rule, stated in
`docs/sync.md`:

| Field | Rule |
|---|---|
| `count` | Client wins only if its `updated_at` is later; otherwise server wins |
| `notes` | Same rule, and the loser's text is kept in `notes_conflict` for 30 days |
| `photo` | Server wins; the client's photo is kept locally and offered as "your version" |
| `site`, `observed_at` | Server wins (immutable facts recorded in the field) |

The point is not which rule is best — several are defensible — but that a volunteer's text is never
silently destroyed, and the rule is testable as a pure function:

```dart
MergeResult merge(LocalObservation local, ServerObservation remote) { ... }
```

Unit-test the four quadrants: only local changed, only remote changed, both changed differently, both
changed to the same value. The last one is where naive implementations create a pointless conflict.

## Accessibility details that pass the audit

- The sync badge is `Semantics(label: 'Sync status: pending')`, not a coloured dot.
- The count stepper's buttons are `IconButton`s with `tooltip`, and the value is a `Text` with
  `semanticsLabel: 'Count: 3'`, so TalkBack reads the number once, not twice.
- Text scale 200% is tested by setting `MediaQuery.textScaler` in a widget test and asserting no overflow
  (`expect(tester.takeException(), isNull)` after pumping the capture screen).
- The offline banner is not a `SnackBar` — those disappear and are not announced reliably; it is a
  persistent `MaterialBanner` or an inline row with `Semantics(liveRegion: true)`.

## Testing the kill

The integration test cannot really kill the process, so simulate the state instead:

```dart
test('restart during upload does not duplicate', () async {
  final api = FakeApi(delay: const Duration(seconds: 5), failOnCancel: false);
  unawaited(syncEngine.run());
  await api.firstRequestStarted;
  await db.customStatement("UPDATE observations SET sync_state = 'syncing'");
  await syncEngine.recoverOnStart();           // what main() does
  await api.completeAll();
  await syncEngine.run();
  expect(await db.countObservations(), 1);
  expect(api.createdServerIds.toSet().length, 1);
});
```

That test is the specification of `NFR-5`, and it fails loudly if someone removes the idempotency key
or the recovery step. A manual version — `adb shell am force-stop` mid-upload — is worth doing once,
because it also exercises the real filesystem and the real network timeout.

## Platform edges

- **Android 13+** requires `POST_NOTIFICATIONS` for the sync notification; without it the foreground
  service is invisible and the OS may kill it.
- **iOS background** is opportunistic. `BGAppRefreshTask` may run once a day or not at all; the app must
  sync on resume and on pull-to-refresh, and the README must not promise more.
- **Location** permission "while using" is enough; "always" invites a store review question you do not
  need. A poor fix is normal in a reed bed — the manual site fallback is a requirement, not a nicety.
- **Backup** — `android:allowBackup="false"` or a backup rules file that excludes secure storage; the
  default can copy the token off the device.

## Trade-offs and alternatives

- **drift versus sqflite.** drift generates typed queries and streams, which is most of the UI's state
  handling; sqflite is smaller and closer to SQL. Either passes; drift shortens M1 considerably.
- **Riverpod versus Bloc.** Riverpod composes the repository stream with less ceremony; Bloc makes the
  state machine explicit, which suits a sync engine. The ADR should pick based on which part you expect
  to change.
- **Client-generated uuid versus server ids.** Client ids make idempotency trivial and offline creation
  possible; server ids are simpler to sort and shorter. The uuid wins for an offline-first app.
- **Background worker versus sync-on-resume.** A worker satisfies `FR-6` properly and is at the mercy of
  both OS schedulers; resume-only is predictable and noticeably worse for the user. Do both, and be
  honest about the iOS limits.
- **Photo in the row versus on disk.** On disk, always; a 3 MB blob in SQLite makes every list query slow
  and every backup large.

## What is deliberately missing

The widget tree and the theme. The sync contract, the recovery rule and the merge table are the graded
design; the screens are ordinary Flutter you have built in the subject's exercises.
