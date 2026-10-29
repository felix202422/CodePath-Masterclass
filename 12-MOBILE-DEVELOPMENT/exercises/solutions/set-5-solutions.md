# Set 5 solutions — Flutter fundamentals · Widgets and layouts → `flutter-fundamentals.md` · `widgets-and-layouts.md`

*Executed in the batch's `scaffold` lab as widget batteries W1–W5 (`flutter test`,
`flutter analyze`, Flutter 3.47.7). Blocks marked *reference* are shapes to run in your lab.*

## 1. Rebuild counts, predicted then executed (W1)

**Prediction:** page builds twice after `setState`, const child once. Executed capture:

```
pageBuilds=1 constChildBuilds=1      (mount)
pageBuilds=2 constChildBuilds=1      (after tap)
```

The rule, from the capture: `const` lets the framework *reuse the identical child
element* — the widget instance is canonical, so the parent's rebuild finds the same
object and skips the subtree. It skips a rebuild only when the child is genuinely
`const` (same canonical instance); a non-const child is a new object each build, so the
element re-evaluates it even if the values happen to be equal.

## 2. Read the real tree (W2, executed)

The dump captured 77 lines; the annotated slice:

```
Scaffold(dependencies: [<_Inherited...>]     ← widget: configuration
 └─ _BodyBuilder                              ← element: the live instance
     └─ RenderConstrainedBox                  ← render object: layout state
         … RenderParagraph size=114x20        ← where the Text's box is measured
```

Three levels, three jobs: the **widget** is immutable configuration, the **element** is the
mounted identity that decides rebuilds, the **render object** holds size/position. The
`dependencies:` line on `Scaffold` is exactly the mechanism set 7 builds on.

## 3. Overflow, breakpoint, stack (executed W3–W5)

Overflow, caught *in the test*:

```
FlutterError: A RenderFlex overflowed by 740 pixels on the right.
```

— retrieved via `tester.takeException()` so the test *documents* the overflow instead of
crashing; asserting the pixel count pins the diagnosis.

Responsive branch, asserted on two viewport sizes:

```
layout: narrow w=390
layout: wide w=1280
```

— `tester.view.physicalSize` (or `setSurfaceSize`) swapped, each branch asserted by text.

Stack geometry:

```
badge topLeft=(50.0, 40.0) size=(60.0, 30.0)
```

— via `getTopLeft` / `getSize` on the finder: asserting *numbers*, not screenshots, so the
test survives any pixel pipeline.

## 4. Independent — a screen that survives 320 px, 2× scale, landscape (reference shape)

Three tests, one axis each:

```dart
testWidgets('no overflow at 320px', …setSurfaceSize(Size(320, 640))…
  expect(tester.takeException(), isNull);
testWidgets('2x text scale', …textScaleFactor: 2…);
testWidgets('landscape', …Size(1280, 390)…);
```

Completion evidence: all three green *and* each asserting geometry (`getMaxWidth`,
`overflow-free = takeException() == null`), with the structural choices that made it work
named — `SingleChildScrollView` for the page, `Wrap` instead of `Row` for the toolbar, and
`LayoutBuilder` wherever the breakpoint lives.
