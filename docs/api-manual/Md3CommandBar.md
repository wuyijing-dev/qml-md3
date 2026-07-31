## WinUI 对照

| WinUI | Md3 | 说明 |
|-------|-----|------|
| CommandBar | `Md3CommandBar` | Primary = 子项；Secondary = `overflowModel` |
| AppBarButton | `Md3AppBarButton` | 工具栏项 |
| （简单自定义条） | `Md3AppToolBar` | 无溢出菜单时的轻量替代 |

## 用法

```qml
Md3CommandBar {
    width: parent.width
    overflowModel: [
        { text: qsTr("Share"), icon: "share" },
        { text: qsTr("Print"), icon: "print" }
    ]
    onOverflowItemClicked: (i) => runOverflow(i)

    Md3AppBarButton { icon: "save"; label: qsTr("Save") }
    Md3AppBarButton { icon: "undo"; label: qsTr("Undo") }
    Md3AppBarToggleButton { icon: "grid_view"; label: qsTr("Grid"); checked: true }
}
```

适合 `Md3ApplicationWindow.toolBar`。详见 [buttons-commands.md](../buttons-commands.md)。
