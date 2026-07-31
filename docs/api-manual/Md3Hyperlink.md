## WinUI 对照

| WinUI | Md3 | 说明 |
|-------|-----|------|
| HyperlinkButton | `Md3Hyperlink` | 链接外观；可选外开 URL |

## 用法

```qml
Md3Hyperlink {
    text: qsTr("Documentation")
    url: "https://example.com/docs"
}

Md3Hyperlink {
    text: qsTr("Go to account")
    openExternally: false
    onClicked: stack.push("AccountPage.qml")
}
```

悬停 / 键盘焦点时显示下划线（`underline: true`）。读屏角色为 Link。
