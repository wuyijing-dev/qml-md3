# Md3TrayHost

Binds system-tray activation to an `Md3Menu` (library menu, not QMenu). Place inside `Md3ApplicationWindow` (or any Window that owns `windowHelper`).  ```qml Md3TrayHost { hostWindow: window Md3MenuItem { text: qsTr("Show"); onClicked: window.raiseWindow() } Md3MenuItem { text: qsTr("Quit"); onClicked: Qt.quit() } } // then: window.showSystemTrayIcon(icon, tip) ```

- **Source:** `src/Md3/components/Md3TrayHost.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `hostWindow` | `var` | `null` | read/write | `Md3TrayHost` | Window that called `showSystemTrayIcon` (must expose `windowHelper`). |
| `raiseOnActivate` | `bool` | `true` | read/write | `Md3TrayHost` | Show the app on left / double-click (default true). |
| `popupOnContext` | `bool` | `true` | read/write | `Md3TrayHost` | Show `menu` on tray right-click (default true). |
| `menuData` | `alias` | `trayMenu.content` | default read/write | `Md3TrayHost` | Default property → `trayMenu.content` |
| `menu` | `alias` | `trayMenu` | read/write | `Md3TrayHost` | Alias → `trayMenu` |
| `helper` | `var` | `hostWindow && hostWindow.windowHelper` | readonly | `Md3TrayHost` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `activated(int reason)` | `Md3TrayHost` | — |
| `contextMenuAboutToShow()` | `Md3TrayHost` | — |

## Methods

_None._

## Example

```qml
import Md3

Md3TrayHost {
    hostWindow: null
    raiseOnActivate: true
    popupOnContext: true
}
```
