# Android（experimental）

Md3 on Android uses **system window chrome** (no CSD / Snap / tray). `Md3WindowHelper` / `Md3ApplicationWindow` expose native hooks that mirror desktop APIs where possible, plus Android-specific extras.

## Capability bag

| API | Android path |
|-----|----------------|
| `setIdleInhibit` | `FLAG_KEEP_SCREEN_ON` |
| `setExcludeFromCapture` | `FLAG_SECURE` |
| `setDockBadge` | `QGuiApplication::setBadgeNumber` (OEM may ignore) |
| `setAlwaysOnTop` | `Qt::WindowStaysOnTopHint` (often ignored) |
| `raiseWindow` | Qt raise / activate |
| `shareText` | `Intent.ACTION_SEND` text/plain chooser |
| `shareFile` | `ACTION_SEND` stream（需宿主 `FileProvider`：`${applicationId}.fileprovider`） |
| `vibrate` / `hapticFeedback` | `Vibrator` / `View.performHapticFeedback` |
| `setImmersiveSystemUi` | Immersive sticky system UI flags |
| `showTrayNotification` | `NotificationManager` + channel `md3_default`（API 33+ 需 `POST_NOTIFICATIONS`） |
| `setSystemBarColors` | status / navigation bar color + light status icons |
| `setScreenOrientation` | `setRequestedOrientation`（portrait / landscape / sensor / …） |
| `showSoftInput` / `hideSoftInput` | `InputMethodManager` |
| `setSoftInputAdjustResize` | `SOFT_INPUT_ADJUST_RESIZE` / `ADJUST_PAN` |
| `nativeToast` | `android.widget.Toast` |
| `openAppSettings` | `APPLICATION_DETAILS_SETTINGS` |
| `openNotificationSettings` | `APP_NOTIFICATION_SETTINGS` |
| `requestIgnoreBatteryOptimizations` | `REQUEST_IGNORE_BATTERY_OPTIMIZATIONS` |
| `copyToClipboard` / `clipboardText` | `QClipboard` |
| `systemAccentColor` | Material You `system_accent1_600`（API 31+） |
| `openUrl` / `revealInFolder` | desktop-services / VIEW（存储权限适用） |

Unavailable on Android: Snap, tray icon UI, jump list, Mica, taskbar progress, global shortcuts, open-at-login, protocol client registration — see [native-platforms.md](native-platforms.md).

QML flags: `Md3WindowCapabilities.isAndroid` · `notifications` · `systemBarColors` · `screenOrientation` · `softInput` · `nativeToast` · `hapticFeedback` · `openAppSettings` · `shareFile`.

## Example

```qml
app.setSystemBarColors("#6750A4", "#6750A4", !Md3Theme.dark)
app.showTrayNotification(qsTr("Title"), qsTr("Body"))
app.nativeToast(qsTr("Saved"))
app.setScreenOrientation("portrait")
app.hapticFeedback(0) // click
app.openAppSettings()
```

## Build notes

Android is detected via `MD3_IS_ANDROID` in [`cmake/Md3Platform.cmake`](https://github.com/wuyijing-dev/qml-md3/blob/main/cmake/Md3Platform.cmake) and must **not** use the Linux DBus/KF6 sources.

Native sources: `src/Md3/window/platforms/android/md3androidnative.cpp` + Android branches in `md3windowhelper.cpp`.

```bash
qt-cmake -S . -B build-android -DMD3_BUILD_GALLERY=OFF -DMD3_BUILD_SHARED=ON
cmake --build build-android
```

Manifest tips for host apps:

- `POST_NOTIFICATIONS` (API 33+)
- Optional `REQUEST_IGNORE_BATTERY_OPTIMIZATIONS`
- `FileProvider` authority `${applicationId}.fileprovider` for `shareFile`

## Device smoke checklist (experimental)

Run on a physical device (or emulator with gesture nav) before claiming Android readiness:

| # | Check | How |
|---|--------|-----|
| 1 | **SafeArea / insets** | Gallery → mobile shell / Adaptive; rotate; verify top/bottom content not under status/nav bars (`safeBottomInset` / Qt 6.9+ SafeArea) |
| 2 | **System bar colors** | `setSystemBarColors` light/dark; icons readable on status bar |
| 3 | **Immersive** | `setImmersiveSystemUi(true)` then false; bars hide/restore; back exits immersive |
| 4 | **Notifications** | Grant `POST_NOTIFICATIONS` (API 33+); `showTrayNotification`; tap opens app if OEM allows |
| 5 | **Keep screen on / secure** | `setIdleInhibit` / `setExcludeFromCapture`; confirm flags stick across `onActiveChanged` |
| 6 | **IME / Toast / haptic** | Focus TextField → soft input; `nativeToast`; `hapticFeedback(0)` |
| 7 | **Share** | `shareText` / `shareFile` (FileProvider configured) |
| 8 | **Orientation** | `setScreenOrientation("portrait"\|"landscape")` |

Record failures with OEM + API level in `lastNativeStatus` / issue notes. WASM stays on the mobile stub — do not treat Android smoke as WASM coverage.

## Lifecycle

- Keep-screen-on / FLAG_SECURE / bar colors apply to the **Activity** window; re-apply in `onActiveChanged` if the OEM clears them.
- Badge / notification delivery varies by launcher and permission state; check `lastNativeStatus`.

## Related

- [native-platforms.md](native-platforms.md)
- [wasm.md](wasm.md) — WASM still uses the generic mobile stub
- Gallery → Window → **Android** tab
