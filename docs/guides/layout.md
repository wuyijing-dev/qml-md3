# Md3 Layout Guide

用布局 API 少写胶水代码。优先组合这些组件，而不是手写 `anchors` / `Column` / `RowLayout`。

## Quick picks

| Need | Use |
|------|-----|
| Vertical form / page block | `Md3VStack` or `Md3PageSection` |
| Toolbar / actions row | `Md3HStack` + `Md3Spacer { expand: true }` |
| Chips / buttons wrap | `Md3FlowLayout` or `Md3AnimatedFlow` |
| Card / tile matrix | `Md3GridLayout` |
| Fixed gap | `Md3Spacer { size: 16 }` |
| Push content apart | `Md3Spacer { expand: true }` |
| Card with header | `Md3Card { title: "..."; subtitle: "..." }` |
| Fit vs scroll body | `layoutMode: Md3ContainerBody.Fit` / `.Scroll` on Card/Form/Sheet |
| Window size / chrome | `Md3Adaptive` + `Md3ApplicationWindow.adaptiveChrome` — see [window-appearance.md](window-appearance.md) |

### Qt6 height policy (6.5 / 6.8 / 6.10)

Prescribed in **C++** (`Md3QtCompat` + `Md3HeightSync`), not per-kit QML:

- Layout shells raise `height` to at least `implicitHeight` (`Md3HeightSync.AtLeastImplicit`): VStack, HStack, Flow, Form, PageSection, GridLayout, lists/tree, Card, DataTable, EmptyState, FileDropZone.
- Card body slots use `Exact` so `Column` sees a real `height`.
- Measure children with `Md3QtCompat.preferredHeight` / `preferredWidth`.
- Version gates for optional APIs: `Md3QtCompat.atLeast66`…`atLeast610` / C++ `MD3_QT_AT_LEAST_*` — never `if (Qt.version…)` in public layout QML.

`Column` / `Flickable.contentHeight` consume **`height`**. Prefer `contentHeight: column.implicitHeight` in Flickables. Do not bind `bodyHeight` to `height` on `Md3DataTable`.

## Before / after

### Card header

```qml
// Before
Md3Card {
    Column {
        width: parent.width
        spacing: 8
        Md3Text { text: "Title"; role: Md3Text.TitleMedium }
        Md3Text { text: "Hint"; tone: Md3Text.OnSurfaceVariant }
        /* content */
    }
}

// After
Md3Card {
    title: "Title"
    subtitle: "Hint"
    /* content */
}
```

### Flow of fixed-size cards

`Md3AnimatedFlow` measures `max(width, implicitWidth)` / `max(height, implicitHeight)`, so you do **not** need:

```qml
implicitWidth: width
implicitHeight: height
```

### Expanding spacer

```qml
Md3HStack {
    Md3Button { text: "Cancel"; variant: Md3Button.Outlined }
    Md3Spacer { expand: true }
    Md3Button { text: "Save" }
}
```

### Page section

```qml
Md3PageSection {
    title: qsTr("Appearance")
    subtitle: qsTr("Theme and density")
    Md3Switch { /* ... */ }
}
```

## Container `layoutMode`

These containers expose Fit/Scroll without wrapping `Md3AdaptiveContainer`:

- `Md3Card`, `Md3Form`, `Md3Scaffold`
- `Md3SideSheet`, `Md3BottomSheet`, `Md3FullscreenDialog`
- `Md3Surface`, `Md3ExpansionTile`, `Md3LiquidGlass`, `Md3Menu`
- `Md3ApplicationWindow`, `Md3DialogWindow`

```qml
Md3Card {
    Layout.fillHeight: true
    layoutMode: Md3ContainerBody.Scroll
    /* long content scrolls inside the card */
}
```

## Related API

- [Md3VStack](api/Md3VStack.md)
- [Md3HStack](api/Md3HStack.md)
- [Md3FlowLayout](api/Md3FlowLayout.md)
- [Md3AnimatedFlow](api/Md3AnimatedFlow.md)
- [Md3GridLayout](api/Md3GridLayout.md)
- [Md3Spacer](api/Md3Spacer.md)
- [Md3PageSection](api/Md3PageSection.md)
- [Md3Card](api/Md3Card.md)
- [Md3Text](api/Md3Text.md)
- [Md3ContainerBody](api/Md3ContainerBody.md)
- [Md3AdaptiveContainer](api/Md3AdaptiveContainer.md)

Also see [glue-less-api.md](glue-less-api.md) for Switch/Slider/ListTile/Sheet shortcuts.
