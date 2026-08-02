# Md3WindowCapabilities

- **Source:** `src/Md3/window/Md3WindowCapabilities.qml`
- **Extends:** `QtObject`
- **Singleton:** `true` (`pragma Singleton`)

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 69 | 0 | 0 | 0 |

_Also inherits Qt Quick `QtObject` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `os` | `string` | `Qt.platform.os` | readonly | `Md3WindowCapabilities` | Os. |
| `isWindows` | `bool` | `os === "windows"` | readonly | `Md3WindowCapabilities` | Is Windows. |
| `isMacOS` | `bool` | `os === "osx" \|\| os === "macos"` | readonly | `Md3WindowCapabilities` | Is Mac OS. |
| `isLinux` | `bool` | `os === "linux"` | readonly | `Md3WindowCapabilities` | Is Linux. |
| `isAndroid` | `bool` | `os === "android"` | readonly | `Md3WindowCapabilities` | Is Android. |
| `isWasm` | `bool` | `os === "wasm" \|\| os === "emscripten"` | readonly | `Md3WindowCapabilities` | Is Wasm. |
| `isMobile` | `bool` | `os === "android" \|\| os === "ios"` | readonly | `Md3WindowCapabilities` | Is Mobile. |
| `isDesktop` | `bool` | `!isMobile && !isWasm` | readonly | `Md3WindowCapabilities` | Browser / WASM uses the mobile capability bag (system chrome, no CSD/tray). |
| `isWayland` | `bool` | `isLinux && _native.wayland` | readonly | `Md3WindowCapabilities` | Auto-detected on Linux via QGuiApplication::platformName(). |
| `isX11` | `bool` | `isLinux && _native.xcb` | readonly | `Md3WindowCapabilities` | Is X11. |
| `displayServer` | `string` | `{…}` | readonly | `Md3WindowCapabilities` | "wayland" \| "x11" \| "android" \| "windows" \| "macos" \| "wasm" \| "ios" \| "linux" \| "unknown" |
| `windows` | `Md3WindowPlatformWindows` | `{…}` | read/write | `Md3WindowCapabilities` | Windows. |
| `macOS` | `Md3WindowPlatformMacOS` | `{…}` | read/write | `Md3WindowCapabilities` | Mac OS. |
| `linux` | `Md3WindowPlatformLinux` | `{…}` | read/write | `Md3WindowCapabilities` | Linux. |
| `wayland` | `Md3WindowPlatformWayland` | `{…}` | read/write | `Md3WindowCapabilities` | Wayland. |
| `x11` | `Md3WindowPlatformX11` | `{…}` | read/write | `Md3WindowCapabilities` | X11. |
| `android` | `Md3WindowPlatformAndroid` | `{…}` | read/write | `Md3WindowCapabilities` | Android. |
| `mobile` | `Md3WindowPlatformMobile` | `{…}` | read/write | `Md3WindowCapabilities` | Mobile. |
| `platform` | `var` | `{…}` | readonly | `Md3WindowCapabilities` | Platform. |
| `platformId` | `string` | `platform.id` | readonly | `Md3WindowCapabilities` | Platform Id. |
| `customChrome` | `bool` | `platform.customChrome` | readonly | `Md3WindowCapabilities` | Custom Chrome. |
| `captionButtons` | `bool` | `platform.captionButtons` | readonly | `Md3WindowCapabilities` | Caption Buttons. |
| `trafficLightsInset` | `real` | `platform.trafficLightsInset` | readonly | `Md3WindowCapabilities` | Traffic Lights Inset. |
| `systemMove` | `bool` | `platform.systemMove` | readonly | `Md3WindowCapabilities` | System Move. |
| `systemResize` | `bool` | `platform.systemResize` | readonly | `Md3WindowCapabilities` | System Resize. |
| `doubleClickMaximize` | `bool` | `platform.doubleClickMaximize` | readonly | `Md3WindowCapabilities` | Double Click Maximize. |
| `windowCornerRadius` | `real` | `platform.windowCornerRadius` | readonly | `Md3WindowCapabilities` | Window Corner Radius. |
| `roundedCorners` | `bool` | `platform.roundedCorners` | readonly | `Md3WindowCapabilities` | Rounded Corners. |
| `systemCorners` | `bool` | `platform.systemCorners` | readonly | `Md3WindowCapabilities` | OS clips window silhouette — skip Qt MultiEffect chrome mask (Win/macOS). |
| `snapLayouts` | `bool` | `platform.snapLayouts` | readonly | `Md3WindowCapabilities` | Snap Layouts. |
| `systemBackdrop` | `bool` | `platform.systemBackdrop` | readonly | `Md3WindowCapabilities` | System Backdrop. |
| `systemMenu` | `bool` | `platform.systemMenu` | readonly | `Md3WindowCapabilities` | System Menu. |
| `immersiveDarkMode` | `bool` | `platform.immersiveDarkMode` | readonly | `Md3WindowCapabilities` | Immersive Dark Mode. |
| `captionHitTest` | `bool` | `platform.captionHitTest` | readonly | `Md3WindowCapabilities` | Caption Hit Test. |
| `taskbarProgress` | `bool` | `platform.taskbarProgress` | readonly | `Md3WindowCapabilities` | Taskbar Progress. |
| `taskbarOverlay` | `bool` | `platform.taskbarOverlay` | readonly | `Md3WindowCapabilities` | Taskbar Overlay. |
| `peekControl` | `bool` | `platform.peekControl` | readonly | `Md3WindowCapabilities` | Peek Control. |
| `excludeFromCapture` | `bool` | `platform.excludeFromCapture` | readonly | `Md3WindowCapabilities` | Exclude From Capture. |
| `jumpList` | `bool` | `platform.jumpList` | readonly | `Md3WindowCapabilities` | Jump List. |
| `thumbBar` | `bool` | `platform.thumbBar` | readonly | `Md3WindowCapabilities` | Thumb Bar. |
| `iconicThumbnail` | `bool` | `platform.iconicThumbnail` | readonly | `Md3WindowCapabilities` | Iconic Thumbnail. |
| `systemTray` | `bool` | `platform.systemTray` | readonly | `Md3WindowCapabilities` | System Tray. |
| `perMonitorDpiV2` | `bool` | `platform.perMonitorDpiV2` | readonly | `Md3WindowCapabilities` | Per Monitor Dpi V2. |
| `alwaysOnTop` | `bool` | `platform.alwaysOnTop` | readonly | `Md3WindowCapabilities` | Always On Top. |
| `thumbnailClip` | `bool` | `platform.thumbnailClip` | readonly | `Md3WindowCapabilities` | Thumbnail Clip. |
| `applicationRestart` | `bool` | `platform.applicationRestart` | readonly | `Md3WindowCapabilities` | Application Restart. |
| `preferredAppMode` | `bool` | `platform.preferredAppMode` | readonly | `Md3WindowCapabilities` | Preferred App Mode. |
| `windowCloak` | `bool` | `platform.windowCloak` | readonly | `Md3WindowCapabilities` | Window Cloak. |
| `systemAccent` | `bool` | `platform.systemAccent` | readonly | `Md3WindowCapabilities` | System Accent. |
| `idleInhibit` | `bool` | `platform.idleInhibit` | readonly | `Md3WindowCapabilities` | Idle Inhibit. |
| `systemOpen` | `bool` | `platform.systemOpen` | readonly | `Md3WindowCapabilities` | System Open. |
| `revealInFolder` | `bool` | `platform.revealInFolder` | readonly | `Md3WindowCapabilities` | Reveal In Folder. |
| `shareText` | `bool` | `platform.shareText` | readonly | `Md3WindowCapabilities` | Share Text. |
| `vibrate` | `bool` | `platform.vibrate` | readonly | `Md3WindowCapabilities` | Vibrate. |
| `immersiveSystemUi` | `bool` | `platform.immersiveSystemUi` | readonly | `Md3WindowCapabilities` | Immersive System Ui. |
| `skipTaskbar` | `bool` | `platform.skipTaskbar` | readonly | `Md3WindowCapabilities` | Skip Taskbar. |
| `singleInstance` | `bool` | `true` | readonly | `Md3WindowCapabilities` | Electron-parity host APIs (Md3NativeShell). |
| `openAtLogin` | `bool` | `platform.openAtLogin` | readonly | `Md3WindowCapabilities` | Open At Login. |
| `globalShortcut` | `bool` | `platform.globalShortcut` | readonly | `Md3WindowCapabilities` | Global Shortcut. |
| `protocolClient` | `bool` | `platform.protocolClient` | readonly | `Md3WindowCapabilities` | Protocol Client. |
| `powerMonitor` | `bool` | `platform.powerMonitor` | readonly | `Md3WindowCapabilities` | Power Monitor. |
| `notifications` | `bool` | `platform.notifications` | readonly | `Md3WindowCapabilities` | Notifications. |
| `systemBarColors` | `bool` | `platform.systemBarColors` | readonly | `Md3WindowCapabilities` | System Bar Colors. |
| `screenOrientation` | `bool` | `platform.screenOrientation` | readonly | `Md3WindowCapabilities` | Screen Orientation. |
| `softInput` | `bool` | `platform.softInput` | readonly | `Md3WindowCapabilities` | Soft Input. |
| `nativeToast` | `bool` | `platform.nativeToast` | readonly | `Md3WindowCapabilities` | Native Toast. |
| `hapticFeedback` | `bool` | `platform.hapticFeedback` | readonly | `Md3WindowCapabilities` | Haptic Feedback. |
| `openAppSettings` | `bool` | `platform.openAppSettings` | readonly | `Md3WindowCapabilities` | Open App Settings. |
| `shareFile` | `bool` | `platform.shareFile` | readonly | `Md3WindowCapabilities` | Share File. |

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
