# Set 2 solutions — Dart fundamentals → `dart-fundamentals.md`

*Executed as the batch's d1/d2 batteries (plain `dart run`, Dart 3.12). Blocks marked
*reference* are shapes to run in your lab.*

## 1. The d1 battery, predicted then executed

Prediction table (paper first):

| Expression | Predicted | Executed |
|---|---|---|
| `7 ~/ 2` | 3 (int) | `3` |
| `7 / 2` | 3.5 | `3.5` (always double) |
| `int x = 7; x / 2` | error (int ← double) | analyzer error — `/` never returns int |
| `[1, if (true) 2, for (var i = 3; i < 5; i++) i]` | `[1,2,3,4]` | `[1, 2, 3, 4]` |
| `{'a': 1, ...{'a': 2, 'b': 3}}` | last wins | `{'a': 2, 'b': 3}` (merged) |
| `('id', 7)` destructure `final (k, v)` | k='id', v=7 | `k=id v=7` |
| switch expression on `'b'` | its case body | matched arm, no fallthrough |

The line that catches people every time: `int 4.5 double` — Dart's `/` is division, and
`~/` is the truncating operator; the *type system* enforces which one you meant.

## 2. Cascade / const / mixin / extension ladder

Executed shape (d2):

```dart
final p = Person('ade')..age = 30..tags = const ['a'];   // cascade, one target
const t = TimeOfDay(7, 30);
```

Const proof from the capture: two `const TimeOfDay(7, 30)` instances printed identical
runtimeType **and** compared `identical(...)` → `0:00:30.000000` canonicalization —
const objects with the same values are *one object*, which is why const must be
constructible at compile time.

Mixin + extension, both compiled clean:

```dart
mixin Describable { String describe() => '$runtimeType'; }
class Cash implements Price { @override double get amount => 10; }
extension on Price { double withTax(double r) => amount * (1 + r); }
```

`flutter analyze` → `No issues found!`.

## 3. Records for small data, classes for identity

```dart
(String, double)? findProduct(String sku) => map[sku];   // null = absent, no class needed
```

Destructure without casts: `final (name, price) = findProduct('x')!;` — the record's
fields carry their types, so no `as` appears. **When a record loses:** it has no name for
its fields (callers remember positions), can't be extended, and no `fromJson` story —
choose a class the moment the value gains identity, optional named fields, or methods
others will override.

## 4. Independent — product model with an unknown-key policy (reference shape)

```dart
class Product {
  final String id; final String name; final List<Variant> variants;
  const Product({required this.id, required this.name, this.variants = const []});
  factory Product.fromJson(Map<String, dynamic> j) => Product(
    id: j['id'] as String, name: j['name'] as String ?? '',
    variants: [for (final v in j['variants'] ?? const []) Variant.fromJson(v as Map)]);
  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'variants': [...]};
}
```

Policy stated up front: **ignore unknown keys, default missing optional keys, throw on
missing required keys.** Round-trip test `expect(fromJson(toJson(p)), p)` green under
`flutter test`. The surprise-key exercise: send `{'id','name','__proto__':'x'}` through
`fromJson` — it parses (ignored), and `toJson` does not echo it: the *output* schema is
proven closed, which is the part that leaks data otherwise.
