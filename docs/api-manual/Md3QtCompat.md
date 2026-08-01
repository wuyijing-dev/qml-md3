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
