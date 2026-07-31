# Md3QtCompat / Md3HeightSync

C++ singletons and helpers that **prescribe** one layout geometry policy for Qt **6.5 / 6.8 / 6.10**, so QML does not branch on kit for Column / Flickable height semantics.

See [Qt version matrix](../topics/qt-version-matrix.md).

## Md3QtCompat (singleton)

| API | Meaning |
|-----|---------|
| `qtVersion` / `qtMinor` / `atLeast68` / `atLeast610` | Compile-time Qt version |
| `strictColumnHeight` | Always `true` |
| `flickableUsesImplicitHeight` | Always `true` — use `contentHeight: item.implicitHeight` |
| `dataTableAvoidHeightLoop` | Always `true` |
| `avoidUseDefaultSizePolicy` | Always `true` — do not depend on Layout API since 6.8 |
| `avoidSafeAreaBaseline` | Always `true` — SafeArea is 6.9+; not the 6.5 path |
| `avoidFlexboxLayout` | Always `true` — FlexboxLayout is 6.10 TP |
| `preferredHeight(item)` / `preferredWidth(item)` | `max(explicit, implicit)` |
| `syncHeightFromImplicit(item, exact=false)` | Floor or exact height sync |
| `syncSubtreeHeights(root, maxDepth=8)` | Walk children and sync (skips `expand: true`) |

Full UI diff checklist: [qt65-610-ui-diffs.md](../topics/qt65-610-ui-diffs.md).

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

Used by `Md3VStack`, `Md3HStack`, `Md3PageSection`, `Md3GridLayout`, and `Md3Card` body slot.
