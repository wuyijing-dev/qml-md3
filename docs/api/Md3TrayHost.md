# Md3TrayHost

Binds system-tray activation to an `Md3Menu` (not `QMenu`).

- **Source:** `src/Md3/components/Md3TrayHost.qml`
- **See:** [tray.md](../tray.md)

## Properties

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `hostWindow` | var | `null` | Window with `windowHelper` / `showSystemTrayIcon` |
| `raiseOnActivate` | bool | `true` | Raise on left / double-click |
| `popupOnContext` | bool | `true` | Popup menu on right-click |
| `menu` | alias | — | Inner `Md3Menu` |

## Signals

| Signal | Description |
|--------|-------------|
| `activated(int reason)` | Forwarded tray reason |
| `contextMenuAboutToShow()` | Before menu popup |

## Example

```qml
Md3TrayHost {
    hostWindow: window
    Md3MenuItem { text: qsTr("Quit"); onClicked: Qt.quit() }
}
```
