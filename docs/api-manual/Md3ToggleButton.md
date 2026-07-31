## WinUI 对照

| WinUI | Md3 | 说明 |
|-------|-----|------|
| ToggleButton | `Md3ToggleButton` | 文本 + 可选图标；`Filled` / `Outlined` |
| （图标 Toggle） | `Md3ToggleIconButton` | 圆形图标切换，见该类型 |

## 用法

```qml
Md3ToggleButton {
    text: qsTr("Bold")
    icon: "format_bold"
    checked: true
    onToggled: (on) => console.log("bold", on)
}

Md3ToggleButton {
    text: qsTr("Italic")
    variant: Md3ToggleButton.Outlined
}
```

`size` 复用 `Md3Button` 尺寸枚举（`ExtraSmall` / `Small` / `Medium` / `Large`）。
