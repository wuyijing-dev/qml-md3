# 集合与列表

WinUI 集合控件对照。Gallery：**扩展**页（List / Grid / Swipe / Flip）· **容器**页（AnnotatedScrollBar）。

## 选用

| 场景 | 推荐 | WinUI |
|------|------|-------|
| 大数据一维列表 | `Md3VirtualList` | ItemsRepeater |
| 分组 + 多选列表 | `Md3ListView` | ListView |
| C++ `QAbstractListModel` / `ListModel` | `Md3ListView`（`model` 直传；delegate 用 `modelData` 或 AIM `model` roles） | ListView |
| 点选填表 / 轻量推荐行 | `Md3ListTile` 或 `Md3ListView`（不要上 DataTable） | ListView |
| 多列 + 筛选 + 分页 | `Md3DataTable`（只绑当前页 rows） | DataGrid |
| 虚拟化网格 | `Md3GridView` | GridView |
| Stack/Grid 切换同一数据 | `Md3ItemsView` | ItemsView |
| 页指示点 | `Md3PipsPager` | PipsPager |
| 全幅翻页 | `Md3Carousel` `mode: Flip` | FlipView |
| 预览下一页 | `Md3Carousel` MultiBrowse | — |
| 左滑操作 | `Md3SwipeReveal` | SwipeControl |
| 下拉刷新 | `Md3PullToRefresh` | RefreshContainer |
| 字母索引滚动条 | `Md3ScrollBar.annotations` | AnnotatedScrollBar |
| 表格 + 就地编辑 | `Md3DataTable` `editable: true` | DataGrid |
| 页头标题 + 尾部操作 / 溢出 | `Md3PageHeader` | — |
| 多选后操作条 | `Md3SelectionToolbar` | — |

SemanticZoom：**不做**。

## ListView

```qml
Md3ListView {
    sectionRole: "group"
    selectionMode: Md3ListView.Multiple
    model: [
        { title: "Ada", group: "A" },
        { title: "Barbara", group: "B" }
    ]
    onSelectionChanged: console.log(selectedIndices)
}
```

`model` 也可为 `ListModel` 或 `QAbstractListModel`。数组模型用 `modelData`；AIM 在自定义 delegate 里读 role（或 Loader 同步的 `model` 对象）。

Ctrl/Shift 点击多选；Ctrl+A 全选；Space 切换当前项。

高度：`preferredMaxHeight` / `preferredHeightFraction` / `fillAvailableHeight`（`Md3VirtualList`、`Md3TreeView` 同理）。

## ListTile trailing actions

```qml
Md3ListTile {
    title: qsTr("main")
    trailingActions: [
        { icon: "merge", text: qsTr("Merge") },
        { icon: "delete", text: qsTr("Delete") },
        { icon: "content_copy", text: qsTr("Copy") }
    ]
    maxVisibleTrailingActions: 2
    onTrailingActionClicked: (i) => { }
}
```

## Diff hunks

```qml
Md3DiffBlock {
    code: hunkText
    previewLineCount: 12
    hunkActions: [
        { text: qsTr("Stage"), icon: "add" },
        { text: qsTr("Discard"), icon: "undo" }
    ]
    onHunkActionClicked: (i) => { }
}
```

## Command palette sections

```qml
Md3CommandPalette {
    groupBySection: true
    model: [
        { section: qsTr("Repo"), title: qsTr("Fetch"), icon: "download" },
        { section: qsTr("View"), title: qsTr("Toggle detail"), icon: "dock_to_left",
          visibleWhen: true }
    ]
}
```

动态 `qsTr` 模型在语言切换后依赖 `Md3I18n.revision`（或 `Md3I18n.bump()`）重建。

## GridView / ItemsView

```qml
Md3ItemsView {
    layout: Md3ItemsView.Grid   // or Stack
    cellWidth: 120; cellHeight: 110
    model: [{ title: "Photos", icon: "photo" }, ...]
}
```

## Carousel Flip + Pips

```qml
Md3Carousel {
    mode: Md3Carousel.Flip
    showIndicators: true
    model: [{ title: "Page 1" }, { title: "Page 2" }]
}

Md3PipsPager {
    count: 3
    currentIndex: carousel.currentIndex
    style: Md3PipsPager.Dot
    onIndexRequested: (i) => carousel.goTo(i)
}
```

## Swipe / Pull

```qml
Md3SwipeReveal {
    trailingActions: [
        { icon: "archive", label: qsTr("Archive") },
        { icon: "delete", label: qsTr("Delete"), destructive: true }
    ]
    onActionTriggered: (i) => { /* … */ }
    Md3ListTile { title: qsTr("Message"); anchors.fill: parent }
}

Md3PullToRefresh {
    flickable: listFlick
    onRefreshRequested: {
        loadMore()
        endRefresh()
    }
}
```

## Annotated scroll bar

```qml
Md3ScrollBar {
    flickable: listFlick
    autoHide: false
    annotations: ["A", "E", "I", "M", "Q", "U", "Y"]
}
```

## DataTable 就地编辑

列设 `editable: true`；双击行或 **F2** 进入首个可编辑列；Enter 提交，Esc 取消。

```qml
Md3DataTable {
    columns: [
        { title: "Name", role: "name", width: 140 },
        { title: "Notes", role: "notes", width: 160, editable: true }
    ]
    onCellEdited: (src, role, value) => console.log(src, role, value)
}
```

## API

见 [api/README.md](../api/README.md)；手写附录在 [api-manual/](../api-manual/README.md)。
