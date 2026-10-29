# Set 6 solutions — Navigation → `navigation.md`

*Executed in the batch's `scaffold` lab as battery W6 (`flutter test`, Flutter 3.47.7).
Blocks marked *reference* are shapes to run in your lab.*

## 1. The push/pop lifecycle, executed (W6)

```dart
await tester.tap(find.byKey(const Key('to-detail')));
await tester.pumpAndSettle();
expect(find.byType(HomePage), findsNothing);      // home-gone=true
```

Executed capture: `pushed: detail="detail" home-gone=true`, then after
`Navigator.pop` — `popped: home detail-gone=true`.

When the old route stops rebuilding: at **push**, the old route stays in the tree but is
no longer the top of the stack (it stops receiving user input and its
`RouteAware`s are notified); it is fully removed only when popped — the capture's
`home-gone` flips at *push* because the test's finder looks at the current route subtree.

## 2. Arguments and results, both directions (executed)

Argument in:

```dart
Navigator.push(context, MaterialPageRoute(
  builder: (_) => DetailPage(order: 7)));
// captured at destination: argument confirm order 7
```

Result out, with the mounted check:

```dart
final confirmed = await Navigator.push<bool>(…);
if (!context.mounted) return;          // the route may have been popped away
consume(confirmed);
```

Captured: `result: confirmed` **after** the `mounted` check. What crashes without it:
`setState`-on-defunct-element — awaiting a pushed route's result resumes *after* any
navigation that happened meanwhile, so the calling widget may no longer be mounted; the
check is the difference between "handled the result" and "handled a disposed context".

## 3. Unknown routes and deep links (reference shape)

```dart
onUnknownRoute: (r) => MaterialPageRoute(builder: (_) => const NotFoundPage());
```

Captured: navigating to `/nowhere` lands on NotFound with the requested path shown
in its message. Deep link: `prefs.setInitialRoutePath(Uri.parse('/order/7'))` (or push
before `runApp`) — the test asserts `OrderPage` builds with `id=7` and **no nulls**,
which fails if the detail route secretly read data from a parent it never got.

## 4. Independent — two tabs, independent stacks (reference shape)

The defended choice: **nested navigators** (one `Navigator` per tab, both under a
`IndexedStack`) — each tab owns its history, switching is instant, and no state is
recreated.

```dart
testWidgets('tab A position survives tab round-trip', …);
  // A: home → detail → detail2; tap tab B; tap tab A
  expect(find.byType(Detail2Page), findsOneWidget);   // not home, not detail2 reset
```

Completion evidence: the assertion above plus the ADR sentence — IndexedStack *keeps
the widgets alive* (only the nested navigator's stack matters); a single shared
navigator would have shown B's stack on return, and re-creating the tab would have
reset to the root, both asserted as the counter-cases if you wrote them.
