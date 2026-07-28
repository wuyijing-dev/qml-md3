# Md3DialogWindow

Separate OS-level dialog window (QWidget-like multi-window), not an overlay.

- **Source:** `src/Md3/window/Md3DialogWindow.qml`
- **Extends:** `Window`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `customChrome` | `bool` | `Md3WindowCapabilities.customChrome` | read/write | `Md3DialogWindow` | — |
| `showTitleBar` | `bool` | `true` | read/write | `Md3DialogWindow` | — |
| `roundedCorners` | `bool` | `Md3WindowCapabilities.roundedCorners` | read/write | `Md3DialogWindow` | — |
| `cornerRadius` | `real` | `Md3WindowCapabilities.windowCornerRadius` | read/write | `Md3DialogWindow` | — |
| `showWindowBorder` | `bool` | `true` | read/write | `Md3DialogWindow` | — |
| `titleBarItem` | `alias` | `titleBarLoader.item` | read/write | `Md3DialogWindow` | Alias → `titleBarLoader.item` |
| `overlay` | `alias` | `overlayHost.data` | read/write | `Md3DialogWindow` | Alias → `overlayHost.data` |
| `titleBar` | `Component` | `null` | read/write | `Md3DialogWindow` | — |
| `windowIcon` | `url` | `""` | read/write | `Md3DialogWindow` | — |
| `syncImmersiveDarkMode` | `bool` | `true` | read/write | `Md3DialogWindow` | — |
| `systemBackdrop` | `int` | `0` | read/write | `Md3DialogWindow` | — |
| `nativeBorderColor` | `string` | `""` | read/write | `Md3DialogWindow` | — |
| `usesSystemBackdrop` | `bool` | `systemBackdrop > 0` | readonly | `Md3DialogWindow` | — |
| `backdropTint` | `real` | `0.08` | read/write | `Md3DialogWindow` | — |
| `backdropContentTint` | `real` | `0.18` | read/write | `Md3DialogWindow` | — |
| `backdropTitleTint` | `real` | `0.06` | read/write | `Md3DialogWindow` | — |
| `owner` | `var` | `null` | read/write | `Md3DialogWindow` | Owner window for transient parenting (centers / groups with parent) |
| `dialogModality` | `int` | `Qt.ApplicationModal` | read/write | `Md3DialogWindow` | ApplicationModal \| WindowModal \| NonModal |
| `resizable` | `bool` | `true` | read/write | `Md3DialogWindow` | — |
| `closable` | `bool` | `true` | read/write | `Md3DialogWindow` | — |
| `showPinButton` | `bool` | `true` | read/write | `Md3DialogWindow` | Title-bar pin (always-on-top) — on by default for dialog windows |
| `pinned` | `bool` | `false` | read/write | `Md3DialogWindow` | — |
| `showMinimizeButton` | `bool` | `false` | read/write | `Md3DialogWindow` | — |
| `showMaximizeButton` | `bool` | `false` | read/write | `Md3DialogWindow` | — |
| `showThemeToggle` | `bool` | `false` | read/write | `Md3DialogWindow` | — |
| `showStandardButtons` | `bool` | `true` | read/write | `Md3DialogWindow` | — |
| `confirmText` | `string` | `qsTr("OK")` | read/write | `Md3DialogWindow` | — |
| `dismissText` | `string` | `qsTr("Cancel")` | read/write | `Md3DialogWindow` | — |
| `showDismiss` | `bool` | `true` | read/write | `Md3DialogWindow` | — |
| `dialogText` | `string` | `""` | read/write | `Md3DialogWindow` | — |
| `content` | `alias` | `customContent.data` | default read/write | `Md3DialogWindow` | Default property → `customContent.data` |
| `footer` | `alias` | `footerSlot.data` | read/write | `Md3DialogWindow` | Alias → `footerSlot.data` |
| `isMaximizedLike` | `bool` | `visibility === Window.Maximized` | readonly | `Md3DialogWindow` | — |
| `effectiveRadius` | `real` | `{…}` | readonly | `Md3DialogWindow` | — |
| `windowNative` | `alias` | `windowHelper` | read/write | `Md3DialogWindow` | Alias → `windowHelper` |
| `edge` | `real` | `6` | readonly | `Md3DialogWindow` | — |
| `canResize` | `bool` | `resizable && customChrome && Md3WindowCapabilities.systemResize` | readonly | `Md3DialogWindow` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `confirmed()` | `Md3DialogWindow` | — |
| `dismissed()` | `Md3DialogWindow` | — |
| `opened()` | `Md3DialogWindow` | — |
| `closed()` | `Md3DialogWindow` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `openDialog(ownerWindow)` | `Md3DialogWindow` | — |
| `closeDialog()` | `Md3DialogWindow` | — |
| `accept()` | `Md3DialogWindow` | — |
| `reject()` | `Md3DialogWindow` | — |
| `setPinned(onTop)` | `Md3DialogWindow` | — |
| `togglePinned()` | `Md3DialogWindow` | — |

## Example

```qml
import Md3

Md3DialogWindow {
    customChrome: Md3WindowCapabilities.customChrome
    showTitleBar: true
    roundedCorners: Md3WindowCapabilities.roundedCorners
    cornerRadius: Md3WindowCapabilities.windowCornerRadius
    showWindowBorder: true
}
```
