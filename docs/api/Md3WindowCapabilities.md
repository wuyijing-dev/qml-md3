# Md3WindowCapabilities

- **Source:** `src/Md3/window/Md3WindowCapabilities.qml`
- **Extends:** `QtObject`

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
| `isMobile` | `bool` | `os === "android" \|\| os === "ios"` | readonly | `Md3WindowCapabilities` | — |
| `isDesktop` | `bool` | `!isMobile` | readonly | `Md3WindowCapabilities` | — |
| `windows` | `Md3WindowPlatformWindows` | `Md3WindowPlatformWindows {}` | read/write | `Md3WindowCapabilities` | — |
| `macOS` | `Md3WindowPlatformMacOS` | `Md3WindowPlatformMacOS {}` | read/write | `Md3WindowCapabilities` | — |
| `linux` | `Md3WindowPlatformLinux` | `Md3WindowPlatformLinux {}` | read/write | `Md3WindowCapabilities` | — |
| `mobile` | `Md3WindowPlatformMobile` | `Md3WindowPlatformMobile {}` | read/write | `Md3WindowCapabilities` | — |
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

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3WindowCapabilities {
    windows: Md3WindowPlatformWindows {}
    macOS: Md3WindowPlatformMacOS {}
    linux: Md3WindowPlatformLinux {}
    mobile: Md3WindowPlatformMobile {}
}
```
