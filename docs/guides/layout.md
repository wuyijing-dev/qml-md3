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

## Antipatterns (overlap / black voids)

| Don't | Do |
|-------|-----|
| `anchors.fill` on a **direct** `Md3SplitView` child | Nested `Item { anchors.fill }` inside the pane |
| `Md3ScrollView { expand: true }` as the only flex child fighting a sticky footer | Header + Scroll (anchors between) + footer |
| Expect `contentHeight ≥ viewport` empty room under short content | Default ScrollView no longer pads to viewport; use `minContentHeightToViewport: true` only if you need the old behavior |
| Labels clipped under the vertical overlay scrollbar | `verticalScrollbarGutter: scrollBarThickness` (or `4`) / bind child `width` to `contentAvailableWidth` |
| `Md3VStack { expand }` as a **direct** SplitView pane child for Tab + pageHost | Nested `Item` + pure `anchors` for the page host (VStack expand can measure height **0** in Split panes) |
| Multiple competing children under ApplicationWindow Fit | One content host `Item`; switch views with `visible` / Loader — avoid multi-child Fit fighting |
| `Md3TabBar` with pages but no height budget | `fillHeight: true` **or** strip-only + external page host |
| Alias wrapper `default property` to `hstack.data` | Alias to `hstack.content` |
| Giant `Repeater` in `Md3SideSheet` | `Md3ListView` / `Md3VirtualList` |

Dialog open binding: [dialogs-and-open.md](dialogs-and-open.md).

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

### Stack default property (`content`, not `data`)

`Md3HStack` / `Md3VStack` lay out children on an internal host. The default property is **`content`**. Wrappers must alias that — never `stack.data` — or children disappear from layout.

### Page header (title + actions + overflow)

```qml
Md3PageHeader {
    width: parent.width
    title: qsTr("Search")
    subtitle: qsTr("Local index")
    Md3Button { text: qsTr("Scan") }
    Md3Button { text: qsTr("Stop"); variant: Md3Button.Outlined }
}
```

### Page section

```qml
Md3PageSection {
    title: qsTr("Appearance")
    subtitle: qsTr("Theme and density")
    trailing: Md3IconButton { icon: "add" }
    Md3Switch { /* ... */ }
}
```

### Page scaffold / scroll page

```qml
Md3PageScaffold {
    header: Md3PageHeader { title: qsTr("Changes") }
    stickyFooter: Md3StatusLine { text: qsTr("Ready") }
    Md3VStack {
        width: parent.width
        /* body scrolls between header and footer */
    }
}

Md3ScrollPage {
    pagePadding: 16
    Md3Text { text: qsTr("Reliable page scroller in Tab/Fit hosts") }
}
```

### Inspector (list | detail)

```qml
Md3InspectorLayout {
    splitRatio: 0.38
    Item { /* list pane — nest anchors.fill inside */ }
    Item { /* detail pane */ }
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

- [Md3VStack](../api/Md3VStack.md)
- [Md3HStack](../api/Md3HStack.md)
- [Md3FlowLayout](../api/Md3FlowLayout.md)
- [Md3AnimatedFlow](../api/Md3AnimatedFlow.md)
- [Md3GridLayout](../api/Md3GridLayout.md)
- [Md3Spacer](../api/Md3Spacer.md)
- [Md3PageSection](../api/Md3PageSection.md)
- [Md3Card](../api/Md3Card.md)
- [Md3Text](../api/Md3Text.md)
- [Md3ContainerBody](../api/Md3ContainerBody.md)
- [Md3AdaptiveContainer](../api/Md3AdaptiveContainer.md)

Also see [glue-less-api.md](glue-less-api.md) for Switch/Slider/ListTile/Sheet shortcuts.
