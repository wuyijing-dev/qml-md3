# Md3QtCompat

Qt kit facts + layout policy helpers.

- **Source:** `src/Md3/foundation/md3qtcompat.h`
- **Extends:** `QObject`
- **Kind:** C++ / QML_ELEMENT (generated from header)

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 18 | 0 | 6 | 0 |

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `qtMajor` | `int` | `—` | readonly | `Md3QtCompat` | Constant |
| `qtMinor` | `int` | `—` | readonly | `Md3QtCompat` | Constant |
| `qtPatch` | `int` | `—` | readonly | `Md3QtCompat` | Constant |
| `qtVersion` | `string` | `—` | readonly | `Md3QtCompat` | Constant |
| `atLeast65` | `bool` | `—` | readonly | `Md3QtCompat` | Constant |
| `atLeast66` | `bool` | `—` | readonly | `Md3QtCompat` | Constant |
| `atLeast67` | `bool` | `—` | readonly | `Md3QtCompat` | Constant |
| `atLeast68` | `bool` | `—` | readonly | `Md3QtCompat` | Constant |
| `atLeast69` | `bool` | `—` | readonly | `Md3QtCompat` | Constant |
| `atLeast610` | `bool` | `—` | readonly | `Md3QtCompat` | Constant |
| `hasQuickEffects` | `bool` | `—` | readonly | `Md3QtCompat` | Constant |
| `hasQuickShapes` | `bool` | `—` | readonly | `Md3QtCompat` | Constant |
| `strictColumnHeight` | `bool` | `—` | readonly | `Md3QtCompat` | Constant |
| `flickableUsesImplicitHeight` | `bool` | `—` | readonly | `Md3QtCompat` | Constant |
| `dataTableAvoidHeightLoop` | `bool` | `—` | readonly | `Md3QtCompat` | Constant |
| `avoidUseDefaultSizePolicy` | `bool` | `—` | readonly | `Md3QtCompat` | Constant |
| `avoidSafeAreaBaseline` | `bool` | `—` | readonly | `Md3QtCompat` | Constant |
| `avoidFlexboxLayout` | `bool` | `—` | readonly | `Md3QtCompat` | Constant |

## Signals

_None._

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `atLeast(int major, int minor)` | `bool` | `Md3QtCompat` | At Least. |
| `preferredHeight(QObject *object)` | `real` | `Md3QtCompat` | Preferred Height. |
| `preferredWidth(QObject *object)` | `real` | `Md3QtCompat` | Preferred Width. |
| `syncHeightFromImplicit(QObject *object, bool exact = false)` | `bool` | `Md3QtCompat` | Sync Height From Implicit. |
| `syncWidthFromImplicit(QObject *object, bool exact = false)` | `bool` | `Md3QtCompat` | Sync Width From Implicit. |
| `syncSubtreeHeights(QObject *root, int maxDepth = 8)` | `int` | `Md3QtCompat` | Sync Subtree Heights. |

## Example

```qml
import Md3

// C++ / host type — typically used from QML as `Md3QtCompat { }`
Md3QtCompat {
    // see properties / methods above
}
```

# Md3QtCompat / Md3HeightSync

C++ singletons and helpers that **prescribe** one layout geometry policy for Qt **6.5 → 6.10+**, so QML does not branch on kit for Column / Flickable height semantics.

See [Qt version matrix](../topics/qt-version-matrix.md) and [UI diffs](../topics/qt65-610-ui-diffs.md).

Compile gates: `src/Md3/foundation/md3qtversion.h` + `md3_apply_qt_compat_definitions()` in `cmake/Md3QtCompat.cmake`.

## Md3QtCompat (singleton)

| API | Meaning |
|-----|---------|
| `qtVersion` / `qtMajor` / `qtMinor` / `qtPatch` | Compile-time Qt version |
| `atLeast65` … `atLeast610` | Minor gates (`66` / `67` / `68` / `69` / `610`) |
| `atLeast(major, minor)` | Runtime gate helper |
| `hasQuickEffects` / `hasQuickShapes` | Linked optional modules for this kit |
| `strictColumnHeight` | Always `true` |
| `flickableUsesImplicitHeight` | Always `true` — use `contentHeight: item.implicitHeight` |
| `dataTableAvoidHeightLoop` | Always `true` |
| `avoidUseDefaultSizePolicy` | Always `true` — do not depend on Layout API since 6.8 |
| `avoidSafeAreaBaseline` | Always `true` — SafeArea is 6.9+; not the 6.5 path |
| `avoidFlexboxLayout` | Always `true` — FlexboxLayout is 6.10 TP |
| `preferredHeight(item)` / `preferredWidth(item)` | `max(explicit, implicit)` |
| `syncHeightFromImplicit(item, exact=false)` | Floor or exact height sync |
| `syncSubtreeHeights(root, maxDepth=8)` | Walk children and sync (skips `expand: true`) |

## Md3HeightSync (element)

Attach to layout shells / slots:

```qml
Md3HeightSync {
    target: root
    enabled: !root.anchors.fill
    policy: Md3HeightSync.AtLeastImplicit  // or Exact
}
```

| Policy | Behavior |
|--------|----------|
| `AtLeastImplicit` | `height = max(height, implicitHeight)` — fixes collapse, keeps parent-sized height |
| `Exact` | `height = implicitHeight` — required for Column body slots |

Watches `implicit*` **and** `height`/`width` changes so polish collapse is re-raised.

Used by: `Md3VStack`, `Md3HStack`, `Md3AnimatedFlow` / `Md3FlowLayout`, `Md3PageSection`, `Md3GridLayout`, `Md3Form`, `Md3Card`, `Md3DataTable`, `Md3TreeView`, `Md3VirtualList`, `Md3ListView`, `Md3ItemsView`, `Md3EmptyState`, `Md3FileDropZone`.

## C++ macros

| Macro | When |
|-------|------|
| `MD3_QT_AT_LEAST_65` … `_610` | Kit ≥ that minor |
| `MD3_HAS_QUICK_EFFECTS` / `MD3_HAS_QUICK_SHAPES` | Optional modules linked |
