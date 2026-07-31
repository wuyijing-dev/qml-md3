## WinUI 对照

| WinUI | Md3 | 说明 |
|-------|-----|------|
| AppBarToggleButton | `Md3AppBarToggleButton` | 默认 `checkable: true` |

## 用法

```qml
Md3AppBarToggleButton {
    icon: "grid_view"
    label: qsTr("Grid")
    checked: viewMode === "grid"
    onToggled: (on) => { if (on) viewMode = "grid" }
}

Md3AppBarToggleButton {
    icon: "view_list"
    label: qsTr("List")
    checked: viewMode === "list"
    onToggled: (on) => { if (on) viewMode = "list" }
}
```

互斥视图模式：在 `onToggled` 里改共享状态，或外层用 ButtonGroup 语义自行协调。
