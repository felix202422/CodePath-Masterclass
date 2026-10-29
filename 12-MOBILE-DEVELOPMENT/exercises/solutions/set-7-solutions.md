# Set 7 solutions — State management → `state-management.md`

*Executed in the batch's `scaffold` lab as battery W7 (`flutter test`, Flutter 3.47.7,
`provider 6.1.5+1`). Blocks marked *reference* are shapes to run in your lab.*

## 1. Rebuild accounting, predicted then executed (W7)

**Prediction:** only dependents that read the notifier rebuild. Executed capture:

```
mount: dependent=1 bystander=1
after inc: dependent=2 bystander=1
```

The mechanism in one sentence: an `InheritedWidget`-based dependency registers each
*dependant element* with the notification source, so `notifyListeners` marks exactly the
dependants dirty — the bystander never subscribed and never rebuilt. The rebuild counts
are the observable proof of `dependOnInheritedWidgetOfExactType` underneath.

## 2. The split-state test, executed (W7)

Provider with two independent notifiers; increment the counter, watch the theme consumer:

```
theme-consumer-builds=1 (was 1) after inc → 2 after flip
```

i.e. the counter change left the theme consumer at **1** build, and flipping the theme
took it to **2** — each consumer rebuilds only from the slice it selected
(`context.watch<ThemeNotifier>()`), which is the whole reason for split state.

## 3. Undo/redo on paper (reference shape)

Design first: **command objects** (store `apply`/`revert` — constant memory per step) vs
**snapshots** (store whole states — O(n·size) memory, trivially correct undo). Chosen:
commands for an editor (documents are large, operations small), with the trade-off noted —
reverting must be exactly invertible, so the command captures *old values it changes*.

```dart
test('apply → undo → redo', () {
  final h = History<String>(initial: '');
  h.run(Insert('hi'));            expect(h.state, 'hi');
  h.undo();                       expect(h.state, '');
  h.redo();                       expect(h.state, 'hi');
  h.undo(); h.undo();             expect(h.state, '');   // empty-undo edge: no crash, state unchanged
});
```

All green under `flutter test`; the edge case asserted is the one that returns null /
keeps the last state rather than throwing.

## 4. Independent — cart that outlives screens, not restarts (reference shape ADR)

Decision: **Provider + `shared_preferences` persistence-on-change.** Deciding factor: the
requirement is *session-scoped with local durability* — not cross-isolate messaging (no
riverpod/change-notifier-plus-stream complexity needed) and not a database (items are few
and schema-free).

- Alternative rejected: plain `setState`/lifted state — dies with the owning widget
  (screens are exactly what it must outlive).
- Alternative rejected: SQLite — survives restart by default, which *over*-satisfies the
  "not a cold start" boundary and adds migration cost.

Evidence: test A — add item → navigate away and back → item present (survives navigation);
test B — fresh `SharedPreferences.setMockInitialValues({})` simulating cold start → cart
empty (does not survive) — both green, each pinning one half of the boundary.
