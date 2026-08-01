# Native window platforms (Windows / Wayland / X11 / Android)

Honest availability for `Md3WindowHelper` / `Md3WindowCapabilities`. “Yes” means the helper implements a real path; compositor / OEM policy may still ignore (especially Wayland focus and Android launchers).

## Auto detection (QML)

`Md3WindowCapabilities` probes QPA at runtime (`Md3WindowHelper.wayland` / `xcb`):

| Property | Meaning |
|----------|---------|
| `isAndroid` | `Qt.platform.os === "android"` → Android capability bag + JNI hooks |
| `isLinux` | Desktop Linux OS |
| `isWayland` / `isX11` | Linux display server (`platformName` contains wayland / xcb\|x11) |
| `displayServer` | `"wayland"` \| `"x11"` \| `"android"` \| … |
| `platformId` | Active bag id: `"wayland"` / `"x11"` / `"android"` / … (generic `"linux"` only if neither QPA matches) |
| `platform` | Selected bag (`wayland` / `x11` / `android` / …) |

C++: `Md3WindowHelper::displayServer()` mirrors the same probe; `platformId()` stays OS-level (`"linux"` / `"android"` / …) so callers that branch on OS keep working. Prefer Capabilities `platformId` / `displayServer` for UI honesty.

| Capability | Windows | Wayland | X11 | Android |
|------------|---------|---------|-----|---------|
| Custom CSD / caption buttons | Yes | Yes (CSD) | Yes (CSD) | No (system chrome) |
| System move / resize | Yes | Yes (Qt) | Yes | — |
| Win11 Snap Layouts | Yes (delayed HTMAXBUTTON ~380ms) | — | — | — |
| HTCAPTION drag region | Yes | QML drag | QML drag | — |
| Immersive / color scheme | DWM dark | Qt styleHints | Qt styleHints | — |
| System backdrop (Mica/Acrylic) | API only — unsuitable under Qt Quick | Blur hint (KF6) | Blur / atom (KF6) | — |
| Taskbar / dock progress | ITaskbarList3 | Unity LauncherEntry | LauncherEntry | — |
| Numeric dock badge | `setBadgeNumber` + overlay icon | LauncherEntry count | LauncherEntry count | `setBadgeNumber` |
| Taskbar overlay glyph | Yes | No (use badge) | No | — |
| Jump list / thumb bar / iconic | Yes | — | — | — |
| System tray | Yes | StatusNotifier / portal | Yes | — |
| Idle inhibit | `SetThreadExecutionState` | ScreenSaver / GNOME / portal | Same | `FLAG_KEEP_SCREEN_ON` |
| Raise / activate | Yes | Token / KF6; often needs gesture | forceActiveWindow | Qt raise (Activity rules) |
| Always on top | Yes | Compositor-dependent | KeepAbove (KF) | Qt flag (OEM-dependent) |
| Exclude from capture | `WDA_EXCLUDEFROMCAPTURE` | — | — | `FLAG_SECURE` |
| App id | AppUserModelID | `desktopFileName` → xdg `app_id` | Same | — |
| `openUrl` / `revealInFolder` | Shell / Explorer select | xdg-open / file manager | Same | VIEW intent (best-effort) |
| `shareText` | Clipboard fallback | Clipboard | Clipboard | `ACTION_SEND` chooser |
| `vibrate` | Beep fallback | Beep | Beep | `Vibrator` / `VibrationEffect` |
| `setImmersiveSystemUi` | — | — | — | Immersive sticky flags |
| `setVisibleInTaskbar` | `WS_EX_TOOLWINDOW` | Qt::Tool hint | Same | — |
| `centerOnScreen` / opacity / min·max·fullscreen | Qt | Qt | Qt | Qt |
| `requestAttention` | Taskbar flash | Urgent / alert | Same | `alert` |
| Single-instance lock | Yes (`Md3NativeShell`) | Yes | Yes | Best-effort |
| Open at login | Run key | XDG autostart | LaunchAgent | — |
| Global shortcut | `RegisterHotKey` | X11 `xcb_grab_key` / Wayland **GlobalShortcuts portal** | Carbon `RegisterEventHotKey` | — |
| Protocol client | HKCU Classes | `.desktop` + xdg-mime | `LSSetDefaultHandlerForURLScheme` | — |
| Power / lock signals | WM_POWER / WTS | logind PrepareForSleep / LockedHint | NSWorkspace sleep/wake | Same |
| `getPath` (userData/logs/…) | Yes | Yes | Yes | Yes |

## Electron-parity host (`Md3NativeShell`)

Singleton API mirroring common Electron `app` / `globalShortcut` / `powerMonitor` surfaces:

```qml
// Single instance (primary keeps lock; secondary should Qt.quit())
if (!Md3NativeShell.requestSingleInstanceLock("com.example.App"))
    Qt.quit()
Md3NativeShell.onSecondInstance: (argv) => raiseWindow()

// Open at login / protocol / hotkey / paths
Md3NativeShell.setOpenAtLoginEnabled(true)
Md3NativeShell.setAsDefaultProtocolClient("myapp")
Md3NativeShell.registerGlobalShortcut("focus", "Ctrl+Shift+M") // Win / macOS / Linux
const logs = Md3NativeShell.getPath("logs")
```

| Platform | Global shortcut backend |
|----------|-------------------------|
| Windows | `RegisterHotKey` |
| macOS | Carbon `RegisterEventHotKey` |
| Linux X11 | `xcb_grab_key` |
| Linux Wayland | `org.freedesktop.portal.GlobalShortcuts` (user may confirm in portal UI) |

Capability flags: `Md3WindowCapabilities.openAtLogin` / `globalShortcut` / `protocolClient` / `powerMonitor`.

## Adaptive window chrome

See [Window appearance](../guides/window-appearance.md). `Md3Adaptive` + `Md3ApplicationWindow.adaptiveChrome` pick System / CompactChrome / DesktopChrome from size class and mobile vs desktop.

## System wrappers (QML)

Prefer `Md3ApplicationWindow` helpers (they forward to `windowNative`):

```qml
app.openUrl("https://example.com")
app.revealInFolder("file:///C:/path/to/file.txt")
app.shareText("hello")
app.vibrate(40)                 // Android
app.setImmersiveSystemUi(true)  // Android
app.setVisibleInTaskbar(false)
app.centerOnScreen()
app.requestAttention()
```

Capability flags: `Md3WindowCapabilities.systemOpen` / `revealInFolder` / `shareText` / `vibrate` / `immersiveSystemUi` / `skipTaskbar`.

## Snap Layouts (Windows)

Short hover keeps QML hand cursor and click-to-maximize. After ~380ms hover on the maximize cell, native hit-test arms `HTMAXBUTTON` so Win11 shows the snap flyout. Leave the button to disarm.

## Wayland raise

Set `QGuiApplication::desktopFileName` (or `Md3::RunOptions::desktopFileName` / `setAppUserModelId` on Linux). If the process was started with `XDG_ACTIVATION_TOKEN`, `raiseWindow` consumes it. Without a token, expect `lastNativeStatus` to explain that focus was ignored.

## Android

See [android.md](android.md). CMake sets `MD3_IS_ANDROID` so the kit does not pull Linux DBus sources. `platformId()` prefers Android over Linux when both macros are defined.

## Gallery

`gallery/pages/WindowPage.qml` — Windows / Linux (Wayland·X11 auto) / macOS / Android capability notes exercise the APIs above.
