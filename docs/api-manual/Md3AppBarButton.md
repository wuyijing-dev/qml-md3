## WinUI 对照

| WinUI | Md3 | 说明 |
|-------|-----|------|
| AppBarButton | `Md3AppBarButton` | 图标 + 可选标签 |
| AppBarToggleButton | `Md3AppBarToggleButton` 或本类型 `checkable: true` | 按下保持 |

## 用法

```qml
Md3AppBarButton {
    icon: "save"
    label: qsTr("Save")
    onClicked: save()
}

Md3AppBarButton {
    icon: "search"
    layout: Md3AppBarButton.IconOnly
    accessibleName: qsTr("Search")
}
```

优先放在 [`Md3CommandBar`](Md3CommandBar.md) 内；也可用在 `Md3AppToolBar`。
