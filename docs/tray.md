# 系统托盘 + Md3Menu

托盘图标仍走原生（Win `Shell_NotifyIcon` / Linux `QSystemTrayIcon`）；**右键菜单使用组件库 `Md3Menu`**，不嵌 `QMenu`。

## 用法

```qml
Md3ApplicationWindow {
    id: window

    Md3TrayHost {
        hostWindow: window
        Md3MenuItem {
            text: qsTr("显示主窗口")
            onClicked: window.raiseWindow()
        }
        Md3MenuDivider {}
        Md3MenuItem {
            text: qsTr("退出")
            onClicked: Qt.quit()
        }
    }

    Component.onCompleted: showSystemTrayIcon(Md3AppIcons.app16, title)
}
```

| API | 说明 |
|-----|------|
| `showSystemTrayIcon` / `hideSystemTrayIcon` | 窗口方法 |
| `showTrayNotification` | 气球 / 桌面通知（系统层） |
| `windowHelper.trayActivated(reason)` | 1 左键 2 双击 3 右键 … |
| `cursorScreenPos()` | 菜单弹出锚点 |
| `Md3TrayHost` | 右键 → `Md3Menu.popup`；左键抬窗 |

`Md3WindowCapabilities.systemTray`：Win/Linux 通常为 true。

图库 `Main.qml` 已挂 `Md3TrayHost`：窗口页点「显示托盘」后，左键抬窗、右键弹出 Md3 菜单。

## 与 Md3Notify

托盘气球 = **系统通知**；应用内 Toast/Snackbar = **Md3Notify**。见 [feedback.md](feedback.md)。
