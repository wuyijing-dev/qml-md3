# PageHost 深链 / URL 路由（可选）

Md3 不强制 URL 路由器；桌面应用用 **页索引 + 可选持久化** 即可。需要浏览器式深链时，在应用层加薄适配。

## 内置能力

```qml
Md3ApplicationWindow {
    id: win
    destinations: [
        { title: qsTr("Home"), source: "Home.qml" },
        { title: qsTr("Settings"), source: "Settings.qml" }
    ]
    persistSession: true   // 恢复 shell/pageIndex
}
win.navigateTo(1)
win.navigateTo(1, { transition: "fade" })  // 见 PageHost opts
```

页面可继承 `Md3Page`（或自行声明 `md3HostWindow` / `md3RouteParams` / `md3GoBack` / `md3PushRoute`），由 `Md3PageHost` 注入，避免 `while (parent)` 或 duck-type `Window.window`（见 [module-boundaries.md](module-boundaries.md)）。

Flickable 根页面不便继承 `Md3Page` 时，至少声明 `md3HostWindow`，并用 `Md3OverlayHost.resolveWindow(md3HostWindow, root)`。

`Md3AppSettings` 键 `shell/pageIndex`（窗口 `persistSession` 时）。

## 可选 URL 层（应用侧）

建议约定：`app://page/<id>` 或 `md3://dest/settings`。

```qml
function openDeepLink(url) {
    const u = String(url)
    // 例：md3://dest/settings
    const id = u.split("/").pop()
    const idx = destinations.findIndex(d => d.id === id || d.title === id)
    if (idx >= 0)
        navigateTo(idx)
}
```

| 场景 | 做法 |
|------|------|
| 重启恢复 | `persistSession` |
| 外部协议 / 单实例二次启动 | `openDeepLink` + `raiseWindow` |
| 命令面板跳转 | 与 `destinations` 同源生成（Gallery Ctrl+K） |

无需把路由器塞进 `Md3PageHost`；保持 PageHost 只关心索引与缓存。
