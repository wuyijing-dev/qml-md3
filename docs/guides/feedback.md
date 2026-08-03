# Feedback surfaces

Choose the lightest surface that fits the message lifetime and actions.

| | **Toast** | **Snackbar** | **InfoBar** | **Banner** | **Dialog** |
|---|-----------|--------------|-------------|------------|------------|
| API | `Md3Notify.toast` / `Md3ToastHost` | `Md3Notify.snackbar` / `Md3SnackbarHost` | `Md3InfoBar` | `Md3Banner` | `Md3Dialog` / Sheet / `Md3DialogWindow` |
| Lifetime | Short (~2s), auto | Timed / queued | Until dismissed | Until dismissed | Modal until action |
| Place | Top/bottom corners | Bottom stack | Inline | Inline strip | Overlay / OS window |
| Action | No | Optional | Optional | Primary/secondary | Confirm / dismiss |
| Queue | Multi-stack | Priority queue | N/A | N/A | Focus trap |

## 层级与焦点（一页说清）

从低到高（后画的盖住先画的）：

1. 页面内容  
2. `Md3Banner` / `Md3InfoBar`（页内）  
3. `Md3SnackbarHost` / `Md3ToastHost`（窗口级，不抢焦点）  
4. `Md3Dialog` / BottomSheet / SideSheet（遮罩 + 焦点陷阱，Esc 关闭）  
5. `Md3Menu` / `Md3CommandPalette`（更高 z，Esc 级联关闭）  
6. `Md3DialogWindow`（独立 OS 窗，自己的焦点）  

规则：

- Toast/Snackbar **不** `forceActiveFocus`；读屏用 `Md3Accessibility.announce*`。  
- Dialog 打开：焦点落到确认或首个字段；关闭：还回触发者。  
- 不要用 Dialog 报「已复制」——用 Toast。  
- 破坏性操作：Dialog 确认，而不是 Snackbar 带 Undo 就完事（Undo 可作补充）。
- 长清单确认：`bodyMaxHeight` + 默认可滚动内容；永久删除用 `confirmTone: Md3Dialog.Error`。
- 可取消长任务：用 `Md3TaskProgress`，不要硬套 InfoBar。
- 非告警持久状态：`Md3StatusLine`；批量多选操作：`Md3SelectionToolbar`。

## Toast

```qml
Md3Notify.toast(qsTr("Copied"))
Md3Notify.toast(qsTr("Upload failed"), { severity: Md3Toast.Error, durationMs: 3000 })
Md3Notify.toast(qsTr("Saved"), { position: Md3ToastHost.TopRight, severity: Md3Toast.Success })
Md3Notify.toast(qsTr("Still syncing…"), { id: "sync", severity: Md3Toast.Warning }) // id dedupe + refresh
```

Hover pauses the dismiss timer (`pauseOnHover`, default on).

## Snackbar

```qml
Md3Notify.snackbar(qsTr("Draft saved"), { actionText: qsTr("Undo"), priority: 0 })
// With actionText, dwell is extended (~6.5s). Action click dismisses immediately.
```

## Copy helper

```qml
Md3Notify.copy(qsTr("Hello"), { feedback: qsTr("Copied") }) // clipboard + success toast
```

From Python: `app.native.copy_to_clipboard("Hello")` then optionally `app.invoke` / QML toast.

## Shell InfoBar vs page InfoBar

| | **Shell** (`showShellInfoBar`) | **Page** (`Md3InfoBar`) |
|--|--------------------------------|-------------------------|
| Place | Under app toolbar (window chrome) | Inline in page content |
| Use | Syncing / offline / global status | Section-local notice |

```qml
Window.window.showShellInfoBar(qsTr("You’re offline"), {
    title: qsTr("Connection"),
    severity: Md3InfoBar.Warning,
    actionText: qsTr("Dismiss")
})
```

## InfoBar / Banner

页内持久提示；Critical InfoBar 用于离线等状态。 Shell 条见上。

```qml
Md3InfoBar {
    severity: Md3InfoBar.Warning
    title: qsTr("Rebase in progress")
    message: qsTr("Resolve conflicts, then continue or abort.")
    actionText: qsTr("Continue")
    secondaryActionText: qsTr("Abort")
    onActionClicked: /* … */
    onSecondaryActionClicked: /* … */
}
```

`Md3Banner` 用 `primaryAction` / `secondaryAction`（命名不同，语义相同）。

## Md3Notify vs 系统通知

| | **Md3Notify**（Toast/Snackbar） | **系统托盘通知** |
|--|----------------------------------|------------------|
| API | `Md3Notify.toast` / `snackbar` | `showTrayNotification` / OS |
| 可见性 | 仅应用窗口内 | 任务栏/通知中心，窗口可最小化 |
| 焦点 | 不抢 | 系统策略 |
| 用途 | 操作结果、轻量 Undo | 后台完成、需离开应用仍可见 |

托盘菜单用组件库：`Md3TrayHost` + `Md3Menu`（[tray.md](../topics/tray.md)）。

`Md3ApplicationWindow` 自动注册 snackbar + toast hosts。
