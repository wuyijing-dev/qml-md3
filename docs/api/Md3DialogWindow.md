# Md3DialogWindow

Separate OS-level dialog window (QWidget-like multi-window), not an overlay.

- **Source:** `src/Md3/window/Md3DialogWindow.qml`
- **Extends:** `Window`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 40 | 4 | 6 | 0 |

_Also inherits Qt Quick `Window` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `customChrome` | `bool` | `Md3WindowCapabilities.customChrome` | read/write | `Md3DialogWindow` | Custom Chrome. |
| `showTitleBar` | `bool` | `true` | read/write | `Md3DialogWindow` | Show Title Bar. |
| `roundedCorners` | `bool` | `Md3WindowCapabilities.roundedCorners` | read/write | `Md3DialogWindow` | Rounded Corners. |
| `cornerRadius` | `real` | `Md3WindowCapabilities.windowCornerRadius` | read/write | `Md3DialogWindow` | Corner radius. |
| `showWindowBorder` | `bool` | `true` | read/write | `Md3DialogWindow` | Show Window Border. |
| `titleBarItem` | `alias` | `titleBarLoader.item` | read/write | `Md3DialogWindow` | Title Bar Item. |
| `overlay` | `alias` | `overlayHost.data` | read/write | `Md3DialogWindow` | Overlay. |
| `titleBar` | `Component` | `null` | read/write | `Md3DialogWindow` | Title Bar. |
| `windowIcon` | `url` | `Md3AppIcons.window` | read/write | `Md3DialogWindow` | Window Icon. |
| `syncImmersiveDarkMode` | `bool` | `true` | read/write | `Md3DialogWindow` | Sync Immersive Dark Mode. |
| `systemBackdrop` | `int` | `0` | read/write | `Md3DialogWindow` | System Backdrop. |
| `nativeBorderColor` | `string` | `""` | read/write | `Md3DialogWindow` | Native Border Color. |
| `usesSystemBackdrop` | `bool` | `systemBackdrop > 0` | readonly | `Md3DialogWindow` | Uses System Backdrop. |
| `backdropTint` | `real` | `0.08` | read/write | `Md3DialogWindow` | Backdrop Tint. |
| `backdropContentTint` | `real` | `0.18` | read/write | `Md3DialogWindow` | Backdrop Content Tint. |
| `backdropTitleTint` | `real` | `0.06` | read/write | `Md3DialogWindow` | Backdrop Title Tint. |
| `owner` | `var` | `null` | read/write | `Md3DialogWindow` | Owner window for transient parenting (centers / groups with parent) |
| `dialogModality` | `int` | `Qt.ApplicationModal` | read/write | `Md3DialogWindow` | ApplicationModal \| WindowModal \| NonModal |
| `resizable` | `bool` | `true` | read/write | `Md3DialogWindow` | Resizable. |
| `closable` | `bool` | `true` | read/write | `Md3DialogWindow` | Closable. |
| `showPinButton` | `bool` | `true` | read/write | `Md3DialogWindow` | Title-bar pin (always-on-top) — on by default for dialog windows |
| `pinned` | `bool` | `false` | read/write | `Md3DialogWindow` | Pinned. |
| `showMinimizeButton` | `bool` | `false` | read/write | `Md3DialogWindow` | Show Minimize Button. |
| `showMaximizeButton` | `bool` | `false` | read/write | `Md3DialogWindow` | Show Maximize Button. |
| `showThemeToggle` | `bool` | `false` | read/write | `Md3DialogWindow` | Show Theme Toggle. |
| `showStandardButtons` | `bool` | `true` | read/write | `Md3DialogWindow` | Show Standard Buttons. |
| `confirmText` | `string` | `qsTr("OK")` | read/write | `Md3DialogWindow` | Confirm Text. |
| `dismissText` | `string` | `qsTr("Cancel")` | read/write | `Md3DialogWindow` | Dismiss Text. |
| `showDismiss` | `bool` | `true` | read/write | `Md3DialogWindow` | Show Dismiss. |
| `dialogText` | `string` | `""` | read/write | `Md3DialogWindow` | Dialog Text. |
| `layoutMode` | `int` | `Md3ContainerBody.Fit` | read/write | `Md3DialogWindow` | Layout Mode. |
| `content` | `alias` | `customContent.content` | default read/write | `Md3DialogWindow` | Content. |
| `footer` | `alias` | `footerSlot.data` | read/write | `Md3DialogWindow` | Footer. |
| `isMaximizedLike` | `bool` | `visibility === Window.Maximized` | readonly | `Md3DialogWindow` | Is Maximized Like. |
| `effectiveRadius` | `real` | `{…}` | readonly | `Md3DialogWindow` | Effective Radius. |
| `usesSystemCorners` | `bool` | `windowHelper.systemCornersSupported` | readonly | `Md3DialogWindow` | Uses System Corners. |
| `chromeMaskActive` | `bool` | `effectiveRadius > 0` | readonly | `Md3DialogWindow` | Chrome Mask Active. |
| `windowNative` | `alias` | `windowHelper` | read/write | `Md3DialogWindow` | Window Native. |
| `edge` | `real` | `6` | readonly | `Md3DialogWindow` | Edge. |
| `canResize` | `bool` | `resizable && customChrome && Md3WindowCapabilities.systemResize` | readonly | `Md3DialogWindow` | Can Resize. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `confirmed()` | `Md3DialogWindow` | Emitted when confirmed. |
| `dismissed()` | `Md3DialogWindow` | Emitted when dismissed. |
| `opened()` | `Md3DialogWindow` | Emitted when opened. |
| `closed()` | `Md3DialogWindow` | Emitted when closed. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `openDialog(ownerWindow)` | `—` | `Md3DialogWindow` | Open Dialog. |
| `closeDialog()` | `—` | `Md3DialogWindow` | Close Dialog. |
| `accept()` | `—` | `Md3DialogWindow` | Accept. |
| `reject()` | `—` | `Md3DialogWindow` | Reject. |
| `setPinned(onTop)` | `—` | `Md3DialogWindow` | Set Pinned. |
| `togglePinned()` | `—` | `Md3DialogWindow` | Toggle Pinned. |

## Example

```qml
import Md3

Md3DialogWindow {
    customChrome: Md3WindowCapabilities.customChrome
    showTitleBar: true
    roundedCorners: Md3WindowCapabilities.roundedCorners
    cornerRadius: Md3WindowCapabilities.windowCornerRadius
    showWindowBorder: true
    titleBar: null
}
```
