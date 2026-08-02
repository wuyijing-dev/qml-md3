# Md3Flyout

Anchored light-dismiss panel (WinUI Flyout–inspired). Reparents onto Window.contentItem via Md3OverlayHost — not ApplicationWindow.overlay.

- **Source:** `src/Md3/components/Md3Flyout.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 13 | 3 | 6 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `open` | `bool` | `false` | read/write | `Md3Flyout` | Open the overlay / dialog. |
| `modal` | `bool` | `false` | read/write | `Md3Flyout` | When true, use a light scrim; when false, transparent catcher (DateField-style). |
| `overlayWindow` | `var` | `null` | read/write | `Md3Flyout` | Overlay Window. |
| `anchor` | `var` | `null` | read/write | `Md3Flyout` | Anchor. |
| `offsetX` | `real` | `0` | read/write | `Md3Flyout` | Offset X. |
| `offsetY` | `real` | `4` | read/write | `Md3Flyout` | Offset Y. |
| `panelX` | `real` | `0` | read/write | `Md3Flyout` | Explicit panel position in overlay coords (set by popup / show). |
| `panelY` | `real` | `0` | read/write | `Md3Flyout` | Panel Y. |
| `flyoutWidth` | `real` | `0` | read/write | `Md3Flyout` | 0 → content implicit width (min 160). |
| `padding` | `real` | `12` | read/write | `Md3Flyout` | Uniform padding. |
| `elevation` | `real` | `2` | read/write | `Md3Flyout` | Elevation. |
| `accessibleName` | `string` | `qsTr("Flyout")` | read/write | `Md3Flyout` | Accessible name override. |
| `content` | `alias` | `contentHost.data` | default read/write | `Md3Flyout` | Content. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `opened()` | `Md3Flyout` | Emitted when opened. |
| `closed()` | `Md3Flyout` | Emitted when closed. |
| `dismissed()` | `Md3Flyout` | Emitted when dismissed. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `hostEnsureParent()` | `—` | `Md3Flyout` | Host Ensure Parent. |
| `popup(x, y)` | `—` | `Md3Flyout` | Popup. |
| `popupAtItem(item, x, y)` | `—` | `Md3Flyout` | Popup At Item. |
| `show(anchorItem)` | `—` | `Md3Flyout` | Open below `anchorItem` (defaults to `anchor`). Saves focus for restore on dismiss. |
| `dismiss()` | `—` | `Md3Flyout` | Dismiss. |
| `toggle(anchorItem)` | `—` | `Md3Flyout` | Toggle open / checked state. |

## Example

```qml
import Md3

Md3Flyout {
    open: false
    modal: false
    overlayWindow: null
    anchor: null
    offsetX: 0
    offsetY: 4
}
```
