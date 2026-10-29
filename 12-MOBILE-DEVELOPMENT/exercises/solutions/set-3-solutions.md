# Set 3 solutions — Null safety → `null-safety.md`

*Executed as the batch's d3/d4 probes (analyzer + `dart run`, Dart 3.12). Blocks marked
*reference* are shapes to run in your lab.*

## 1. Make the compiler refuse (executed)

```dart
String s = null;
String? maybe = pick();
int n = int.parse(maybe);
```

Executed capture — `dart analyze d3_assign_null.dart`:

```
error - d3_assign_null.dart:5:14 - A value of type 'Null' can't be assigned to a
        variable of type 'String'. … invalid_assignment
error - d3_assign_null.dart:10:21 - The argument type 'String?' can't be assigned to
        the parameter type 'String'. … argument_type_not_assignable
2 issues found.
```

`dart run` refuses the same file with the identical two errors — analyzer and compiler
agree; this is not a lint. Rewrites that keep intent: `String? s = null;` (truly absent)
and `int.parse(maybe ?? '')` or an early `if (maybe == null) return;` (handle before use).

## 2. Three ways to be wrong at runtime (executed)

1. `print('${name!}')` with `name == null`:

```
before: null
Unhandled exception: Null check operator used on a null value
#0      main (…d4a_bang.dart:6:23)
```

   Safe rewrite: `name ?? 'guest'` (or `?.` when absence should propagate).

2. `late String user` read before assignment:

```
LateInitializationError: Field 'user' has not been initialized.
```

   Safe rewrite: a nullable field with an initializer, or make construction *require* the
   value (`Session(this.user)`) so the state can't exist un-set.

3. Flow narrowing (the success case): `Object? o = 7; if (o is int) print(o + 1);` →
   `narrowed: 8` with **no analyzer complaint** — promotion gives you non-null `int`
   inside the branch. This is the tool the other two bypass.

## 3. Design a nullable API — three call sites, no `!`

```dart
final user = findUser(id);
final name = findUser(id) ?? 'guest';        // default: caller renders something
if (findUser(id) case final u?) { … }        // propagate: keep null in the chain
```

Choosing without `!`: default at the **presentation** edge (show 'guest'), propagate
through **middle** layers (don't invent data), early-return at **IO** boundaries (absence
is a real outcome). `!` appears only where absence is a bug you'd rather crash on — and
you can defend that choice per site.

## 4. Independent — the audit table (reference shape)

| Site | Risk | Verdict |
|---|---|---|
| `user!.name` after `if (user == null) return` | provably safe | keep — promotion makes `!` dead weight; simplify to `user.name` |
| `json['id']!` on untrusted JSON | real | replace: parse into a required-field constructor that *throws a named error* |
| `late final config` set in `init()` | ordering-dependent | replace: constructor parameter — the failure moves to a place with a message |
| `as String` on a dynamic map value | runtime-cast risk | replace: `j['id'] as String? ?? ''` with the policy from set 2 |

Evidence: after the rewrites, `dart analyze` → `0 issues` on the snippet, and the
intentional-failure run still produces the *named* error you chose (a designed throw),
not an incidental one.
