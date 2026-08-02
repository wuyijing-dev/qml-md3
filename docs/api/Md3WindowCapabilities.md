# Md3WindowCapabilities

- **Source:** `src/Md3/window/Md3WindowCapabilities.qml`
- **Extends:** `QtObject`
- **Singleton:** `true` (`pragma Singleton`)

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `os` | `string` | `Qt.platform.os` | readonly | `Md3WindowCapabilities` | — |
| `isWindows` | `bool` | `os === "windows"` | readonly | `Md3WindowCapabilities` | — |
| `isMacOS` | `bool` | `os === "osx" \|\| os === "macos"` | readonly | `Md3WindowCapabilities` | — |
| `isLinux` | `bool` | `os === "linux"` | readonly | `Md3WindowCapabilities` | — |
| `isAndroid` | `bool` | `os === "android"` | readonly | `Md3WindowCapabilities` | — |
| `isWasm` | `bool` | `os === "wasm" \|\| os === "emscripten"` | readonly | `Md3WindowCapabilities` | — |
| `isMobile` | `bool` | `os === "android" \|\| os === "ios"` | readonly | `Md3WindowCapabilities` | — |
| `isDesktop` | `bool` | `!isMobile && !isWasm` | readonly | `Md3WindowCapabilities` | Browser / WASM uses the mobile capability bag (system chrome, no CSD/tray). |
| `isWayland` | `bool` | `isLinux && _native.wayland` | readonly | `Md3WindowCapabilities` | Auto-detected on Linux via QGuiApplication::platformName(). |
| `isX11` | `bool` | `isLinux && _native.xcb` | readonly | `Md3WindowCapabilities` | — |
| `displayServer` | `string` | `{…}` | readonly | `Md3WindowCapabilities` | "wayland" \| "x11" \| "android" \| "windows" \| "macos" \| "wasm" \| "ios" \| "linux" \| "unknown" |
| `windows` | `Md3WindowPlatformWindows` | `{…}` | read/write | `Md3WindowCapabilities` | — |
| `macOS` | `Md3WindowPlatformMacOS` | `{…}` | read/write | `Md3WindowCapabilities` | — |
| `linux` | `Md3WindowPlatformLinux` | `{…}` | read/write | `Md3WindowCapabilities` | — |
| `wayland` | `Md3WindowPlatformWayland` | `{…}` | read/write | `Md3WindowCapabilities` | — |
| `x11` | `Md3WindowPlatformX11` | `{…}` | read/write | `Md3WindowCapabilities` | — |
| `android` | `Md3WindowPlatformAndroid` | `{…}` | read/write | `Md3WindowCapabilities` | — |
| `mobile` | `Md3WindowPlatformMobile` | `{…}` | read/write | `Md3WindowCapabilities` | — |
| `platform` | `var` | `{…}` | readonly | `Md3WindowCapabilities` | — |
| `platformId` | `string` | `platform.id` | readonly | `Md3WindowCapabilities` | — |
| `customChrome` | `bool` | `platform.customChrome` | readonly | `Md3WindowCapabilities` | — |
| `captionButtons` | `bool` | `platform.captionButtons` | readonly | `Md3WindowCapabilities` | — |
| `trafficLightsInset` | `real` | `platform.trafficLightsInset` | readonly | `Md3WindowCapabilities` | — |
| `systemMove` | `bool` | `platform.systemMove` | readonly | `Md3WindowCapabilities` | — |
| `systemResize` | `bool` | `platform.systemResize` | readonly | `Md3WindowCapabilities` | — |
| `doubleClickMaximize` | `bool` | `platform.doubleClickMaximize` | readonly | `Md3WindowCapabilities` | — |
| `windowCornerRadius` | `real` | `platform.windowCornerRadius` | readonly | `Md3WindowCapabilities` | — |
| `roundedCorners` | `bool` | `platform.roundedCorners` | readonly | `Md3WindowCapabilities` | — |
| `systemCorners` | `bool` | `platform.systemCorners` | readonly | `Md3WindowCapabilities` | OS clips window silhouette — skip Qt MultiEffect chrome mask (Win/macOS). |
| `snapLayouts` | `bool` | `platform.snapLayouts` | readonly | `Md3WindowCapabilities` | — |
| `systemBackdrop` | `bool` | `platform.systemBackdrop` | readonly | `Md3WindowCapabilities` | — |
| `systemMenu` | `bool` | `platform.systemMenu` | readonly | `Md3WindowCapabilities` | — |
| `immersiveDarkMode` | `bool` | `platform.immersiveDarkMode` | readonly | `Md3WindowCapabilities` | — |
| `captionHitTest` | `bool` | `platform.captionHitTest` | readonly | `Md3WindowCapabilities` | — |
| `taskbarProgress` | `bool` | `platform.taskbarProgress` | readonly | `Md3WindowCapabilities` | — |
| `taskbarOverlay` | `bool` | `platform.taskbarOverlay` | readonly | `Md3WindowCapabilities` | — |
| `peekControl` | `bool` | `platform.peekControl` | readonly | `Md3WindowCapabilities` | — |
| `excludeFromCapture` | `bool` | `platform.excludeFromCapture` | readonly | `Md3WindowCapabilities` | — |
| `jumpList` | `bool` | `platform.jumpList` | readonly | `Md3WindowCapabilities` | — |
| `thumbBar` | `bool` | `platform.thumbBar` | readonly | `Md3WindowCapabilities` | — |
| `iconicThumbnail` | `bool` | `platform.iconicThumbnail` | readonly | `Md3WindowCapabilities` | — |
| `systemTray` | `bool` | `platform.systemTray` | readonly | `Md3WindowCapabilities` | — |
| `perMonitorDpiV2` | `bool` | `platform.perMonitorDpiV2` | readonly | `Md3WindowCapabilities` | — |
| `alwaysOnTop` | `bool` | `platform.alwaysOnTop` | readonly | `Md3WindowCapabilities` | — |
| `thumbnailClip` | `bool` | `platform.thumbnailClip` | readonly | `Md3WindowCapabilities` | — |
| `applicationRestart` | `bool` | `platform.applicationRestart` | readonly | `Md3WindowCapabilities` | — |
| `preferredAppMode` | `bool` | `platform.preferredAppMode` | readonly | `Md3WindowCapabilities` | — |
| `windowCloak` | `bool` | `platform.windowCloak` | readonly | `Md3WindowCapabilities` | — |
| `systemAccent` | `bool` | `platform.systemAccent` | readonly | `Md3WindowCapabilities` | — |
| `idleInhibit` | `bool` | `platform.idleInhibit` | readonly | `Md3WindowCapabilities` | — |
| `systemOpen` | `bool` | `platform.systemOpen` | readonly | `Md3WindowCapabilities` | — |
| `revealInFolder` | `bool` | `platform.revealInFolder` | readonly | `Md3WindowCapabilities` | — |
| `shareText` | `bool` | `platform.shareText` | readonly | `Md3WindowCapabilities` | — |
| `vibrate` | `bool` | `platform.vibrate` | readonly | `Md3WindowCapabilities` | — |
| `immersiveSystemUi` | `bool` | `platform.immersiveSystemUi` | readonly | `Md3WindowCapabilities` | — |
| `skipTaskbar` | `bool` | `platform.skipTaskbar` | readonly | `Md3WindowCapabilities` | — |
| `singleInstance` | `bool` | `true` | readonly | `Md3WindowCapabilities` | Electron-parity host APIs (Md3NativeShell). |
| `openAtLogin` | `bool` | `platform.openAtLogin` | readonly | `Md3WindowCapabilities` | — |
| `globalShortcut` | `bool` | `platform.globalShortcut` | readonly | `Md3WindowCapabilities` | — |
| `protocolClient` | `bool` | `platform.protocolClient` | readonly | `Md3WindowCapabilities` | — |
| `powerMonitor` | `bool` | `platform.powerMonitor` | readonly | `Md3WindowCapabilities` | — |
| `notifications` | `bool` | `platform.notifications` | readonly | `Md3WindowCapabilities` | — |
| `systemBarColors` | `bool` | `platform.systemBarColors` | readonly | `Md3WindowCapabilities` | — |
| `screenOrientation` | `bool` | `platform.screenOrientation` | readonly | `Md3WindowCapabilities` | — |
| `softInput` | `bool` | `platform.softInput` | readonly | `Md3WindowCapabilities` | — |
| `nativeToast` | `bool` | `platform.nativeToast` | readonly | `Md3WindowCapabilities` | — |
| `hapticFeedback` | `bool` | `platform.hapticFeedback` | readonly | `Md3WindowCapabilities` | — |
| `openAppSettings` | `bool` | `platform.openAppSettings` | readonly | `Md3WindowCapabilities` | — |
| `shareFile` | `bool` | `platform.shareFile` | readonly | `Md3WindowCapabilities` | — |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

// Singleton — use as `Md3WindowCapabilities.…`
console.log(Md3WindowCapabilities)
```

# Md3WindowCapabilities — display server (hand appendix)

Auto-selects platform bags on Linux / Android. See [native-platforms.md](../topics/native-platforms.md).

```qml
import Md3

console.log(Md3WindowCapabilities.displayServer) // wayland | x11 | android | …
console.log(Md3WindowCapabilities.isWayland, Md3WindowCapabilities.isX11)
console.log(Md3WindowCapabilities.platformId)    // bag id (wayland/x11/android/…)
```

Native APIs remain on `Md3WindowHelper` / `Md3ApplicationWindow.windowNative`.

## System wrappers

Also see [native-platforms.md](../topics/native-platforms.md) for `openUrl`, `revealInFolder`, `shareText`, `vibrate`, `setImmersiveSystemUi`, `setVisibleInTaskbar`, etc.
