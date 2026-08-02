# 集合与列表

WinUI 集合控件对照。Gallery：**扩展**页（List / Grid / Swipe / Flip）· **容器**页（AnnotatedScrollBar）。

## 选用

| 场景 | 推荐 | WinUI |
|------|------|-------|
| 大数据一维列表 | `Md3VirtualList` | ItemsRepeater |
| 分组 + 多选列表 | `Md3ListView` | ListView |
| 虚拟化网格 | `Md3GridView` | GridView |
| Stack/Grid 切换同一数据 | `Md3ItemsView` | ItemsView |
| 页指示点 | `Md3PipsPager` | PipsPager |
| 全幅翻页 | `Md3Carousel` `mode: Flip` | FlipView |
| 预览下一页 | `Md3Carousel` MultiBrowse | — |
| 左滑操作 | `Md3SwipeReveal` | SwipeControl |
| 下拉刷新 | `Md3PullToRefresh` | RefreshContainer |
| 字母索引滚动条 | `Md3ScrollBar.annotations` | AnnotatedScrollBar |
| 表格 + 就地编辑 | `Md3DataTable` `editable: true` | DataGrid |

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

Ctrl/Shift 点击多选；Ctrl+A 全选；Space 切换当前项。

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
