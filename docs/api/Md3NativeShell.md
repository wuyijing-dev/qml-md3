# Md3NativeShell

Desktop shell hooks (login item, etc.).

- **Source:** `src/Md3/window/md3nativeshell.h`
- **Extends:** `QObject`
- **Kind:** C++ / QML_ELEMENT (generated from header)

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 14 | 0 | 9 | 0 |

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `singleInstancePrimary` | `bool` | `—` | readonly | `Md3NativeShell` | Notify: `singleInstanceChanged` |
| `openAtLogin` | `bool` | `—` | read/write | `Md3NativeShell` | Notify: `openAtLoginChanged` |
| `openAtLoginSupported` | `bool` | `—` | readonly | `Md3NativeShell` | Constant |
| `globalShortcutSupported` | `bool` | `—` | readonly | `Md3NativeShell` | Constant |
| `protocolClientSupported` | `bool` | `—` | readonly | `Md3NativeShell` | Constant |
| `powerMonitorSupported` | `bool` | `—` | readonly | `Md3NativeShell` | Constant |
| `onBattery` | `bool` | `—` | readonly | `Md3NativeShell` | Notify: `powerSourceChanged` |
| `lastStatus` | `string` | `—` | readonly | `Md3NativeShell` | Notify: `lastStatusChanged` |
| `userDataPath` | `string` | `—` | readonly | `Md3NativeShell` | Constant |
| `cachePath` | `string` | `—` | readonly | `Md3NativeShell` | Constant |
| `logsPath` | `string` | `—` | readonly | `Md3NativeShell` | Constant |
| `tempPath` | `string` | `—` | readonly | `Md3NativeShell` | Constant |
| `exePath` | `string` | `—` | readonly | `Md3NativeShell` | Constant |
| `homePath` | `string` | `—` | readonly | `Md3NativeShell` | Constant |

## Signals

_None._

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `releaseSingleInstanceLock()` | `void` | `Md3NativeShell` | Release Single Instance Lock. |
| `setOpenAtLoginEnabled(bool enabled, bool openAsHidden = false)` | `bool` | `Md3NativeShell` | Set Open At Login Enabled. |
| `registerGlobalShortcut(const QString &id, const QString &accelerator)` | `bool` | `Md3NativeShell` | Register Global Shortcut. |
| `unregisterGlobalShortcut(const QString &id)` | `bool` | `Md3NativeShell` | Unregister Global Shortcut. |
| `unregisterAllGlobalShortcuts()` | `void` | `Md3NativeShell` | Unregister All Global Shortcuts. |
| `removeAsDefaultProtocolClient(const QString &scheme)` | `bool` | `Md3NativeShell` | Remove As Default Protocol Client. |
| `isDefaultProtocolClient(const QString &scheme)` | `bool` | `Md3NativeShell` | Is Default Protocol Client. |
| `getPath(const QString &name)` | `string` | `Md3NativeShell` | Get Path. |
| `focusMainWindow()` | `void` | `Md3NativeShell` | Focus Main Window. |

## Example

```qml
import Md3

// C++ / host type — typically used from QML as `Md3NativeShell { }`
Md3NativeShell {
    // see properties / methods above
}
```

# Md3NativeShell

Electron-parity host helpers for desktop apps: single-instance lock, open-at-login, global shortcuts (Windows), custom URL protocol clients, power/session signals, and standard paths (`getPath`).

```qml
import Md3

Component.onCompleted: {
    if (!Md3NativeShell.requestSingleInstanceLock("com.example.App"))
        Qt.quit()
}

Connections {
    target: Md3NativeShell
    function onSecondInstance(argv) { /* raise + handle argv */ }
    function onGlobalShortcutActivated(id) { /* … */ }
}
```

Prefer this singleton (or `Md3ApplicationWindow` thin wrappers) over calling OS APIs directly.

## Properties

| Name | Type | Notes |
|------|------|--------|
| `singleInstancePrimary` | `bool` | After a successful `requestSingleInstanceLock` |
| `openAtLogin` | `bool` | Read/write; mirrors login-item state |
| `openAtLoginSupported` | `bool` | Win / Linux / macOS |
| `globalShortcutSupported` | `bool` | Win / macOS / Linux (X11 grab or Wayland portal) |
| `protocolClientSupported` | `bool` | Win / Linux / macOS |
| `powerMonitorSupported` | `bool` | Always true (at least app suspend) |
| `onBattery` | `bool` | Best-effort (Windows power status) |
| `lastStatus` | `string` | Last native operation message |
| `userDataPath` / `cachePath` / `logsPath` / `tempPath` / `exePath` / `homePath` | `string` | Convenience paths |

## Methods

| Method | Electron analogue |
|--------|-------------------|
| `requestSingleInstanceLock(id)` / `releaseSingleInstanceLock()` | `app.requestSingleInstanceLock` |
| `setOpenAtLoginEnabled(enabled, openAsHidden?)` | `app.setLoginItemSettings` |
| `registerGlobalShortcut(id, accelerator)` / `unregister*` | `globalShortcut.register` |
| `setAsDefaultProtocolClient` / `remove*` / `isDefault*` | `app.setAsDefaultProtocolClient` |
| `getPath(name)` | `app.getPath` — `home`, `appData`, `userData`, `temp`, `exe`, `desktop`, `documents`, `downloads`, `music`, `pictures`, `videos`, `logs`, `cache`, `crashDumps` |
| `focusMainWindow()` | raise first visible top-level window |

## Signals

`secondInstance(argv)`, `globalShortcutActivated(id)`, `suspend`, `resume`, `lockScreen`, `unlockScreen`, `onAc`, `onBatteryPower`.

See [native-platforms.md](../topics/native-platforms.md). Gallery: Window page →「宿主能力（对标 Electron）」.
