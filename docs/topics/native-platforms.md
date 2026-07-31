# Native window platforms (Windows / Wayland / X11)

Honest availability for `Md3WindowHelper` / `Md3WindowCapabilities`. “Yes” means the helper implements a real path; compositor policy may still ignore (especially Wayland focus).

| Capability | Windows | Wayland | X11 |
|------------|---------|---------|-----|
| Custom CSD / caption buttons | Yes | Yes (CSD) | Yes (CSD) |
| System move / resize | Yes | Yes (Qt) | Yes |
| Win11 Snap Layouts | Yes (delayed HTMAXBUTTON ~380ms) | — | — |
| HTCAPTION drag region | Yes | QML drag | QML drag |
| Immersive / color scheme | DWM dark | Qt styleHints | Qt styleHints |
| System backdrop (Mica/Acrylic) | API only — unsuitable under Qt Quick | Blur hint (KF6) | Blur / atom (KF6) |
| Taskbar / dock progress | ITaskbarList3 | Unity LauncherEntry | LauncherEntry |
| Numeric dock badge | `setBadgeNumber` + overlay icon | LauncherEntry count | LauncherEntry count |
| Taskbar overlay glyph | Yes | No (use badge) | No |
| Jump list / thumb bar / iconic | Yes | — | — |
| System tray | Yes | StatusNotifier / portal | Yes |
| Idle inhibit | `SetThreadExecutionState` | ScreenSaver / GNOME / portal | Same |
| Raise / activate | Yes | Token / KF6; often needs gesture | forceActiveWindow |
| Always on top | Yes | Compositor-dependent | KeepAbove (KF) |
| Exclude from capture | `WDA_EXCLUDEFROMCAPTURE` | — | — |
| App id | AppUserModelID | `desktopFileName` → xdg `app_id` | Same |

## Snap Layouts (Windows)

Short hover keeps QML hand cursor and click-to-maximize. After ~380ms hover on the maximize cell, native hit-test arms `HTMAXBUTTON` so Win11 shows the snap flyout. Leave the button to disarm.

## Wayland raise

Set `QGuiApplication::desktopFileName` (or `Md3::RunOptions::desktopFileName` / `setAppUserModelId` on Linux). If the process was started with `XDG_ACTIVATION_TOKEN`, `raiseWindow` consumes it. Without a token, expect `lastNativeStatus` to explain that focus was ignored.

## Gallery

`gallery/pages/WindowPage.qml` — Windows / Linux / macOS tabs exercise the APIs above.
