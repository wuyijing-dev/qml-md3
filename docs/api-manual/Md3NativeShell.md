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
