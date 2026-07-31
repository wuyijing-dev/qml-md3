# Android（experimental）

Md3 on Android uses **system window chrome** (no CSD / Snap / tray). `Md3WindowHelper` exposes a few real native hooks that mirror the desktop APIs.

## Capability bag

| API | Android path |
|-----|----------------|
| `setIdleInhibit` | `WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON` |
| `setExcludeFromCapture` | `FLAG_SECURE` (blocks screenshot / screen record) |
| `setDockBadge` | `QGuiApplication::setBadgeNumber` (Qt 6.5+; OEM may ignore) |
| `setAlwaysOnTop` | `Qt::WindowStaysOnTopHint` (often ignored by OEMs) |
| `raiseWindow` | Qt `raise` + `requestActivate` (Activity focus rules apply) |
| `shareText` | `Intent.ACTION_SEND` text/plain chooser |
| `vibrate` | `Vibrator` / `VibrationEffect.createOneShot` |
| `setImmersiveSystemUi` | DecorView immersive sticky + hide nav/status |
| `openUrl` / `revealInFolder` | `QDesktopServices` / file VIEW (storage permissions apply) |

Everything else (Snap, tray, jump list, Mica, taskbar progress) stays unavailable — see [native-platforms.md](native-platforms.md).

QML: `Md3WindowCapabilities.isAndroid` / `platformId === "android"` / `displayServer === "android"`.

## Build notes

Android is detected via `MD3_IS_ANDROID` in [`cmake/Md3Platform.cmake`](../../cmake/Md3Platform.cmake) and must **not** use the Linux DBus/KF6 sources (Android also defines UNIX / often `Q_OS_LINUX`).

Native sources: `src/Md3/window/platforms/android/md3androidnative.cpp` (idle / FLAG_SECURE / badge). Capability bag: `Md3WindowPlatformAndroid.qml`.

```bash
# Example: Qt for Android kit
qt-cmake -S . -B build-android -DMD3_BUILD_GALLERY=OFF -DMD3_BUILD_SHARED=ON
cmake --build build-android
```

Ship Md3 as a shared/static dependency of your Qt Quick Android app; import `Md3` from QML as on desktop.

## Lifecycle

- Keep-screen-on / FLAG_SECURE apply to the **Activity** window; call after the UI is up.
- Leaving the Activity may clear OEM-specific state; re-apply in `onActiveChanged` if needed.
- Badge support varies by launcher; check `lastNativeStatus` on the window helper.

## Related

- [native-platforms.md](native-platforms.md) — matrix including Android
- [wasm.md](wasm.md) — WASM still uses the generic mobile stub (not Android JNI)
