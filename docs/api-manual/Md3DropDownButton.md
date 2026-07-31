## WinUI 对照

| WinUI | Md3 | 说明 |
|-------|-----|------|
| DropDownButton | `Md3DropDownButton` | 整钮打开菜单，无独立主操作 |
| SplitButton | `Md3SplitButton` | 主区 `clicked` + 尾段开菜单 |

## 用法

```qml
Md3DropDownButton {
    text: qsTr("Export")
    variant: Md3DropDownButton.Outlined
    menuModel: [
        { text: "PDF", icon: "picture_as_pdf" },
        { text: "CSV", icon: "table_view" },
        { text: "JSON", enabled: false }
    ]
    onMenuItemClicked: (index) => exportAs(index)
}
```

`menuModel` 项：`{ text, icon?, enabled? }`。键盘 ↓ 打开菜单。
