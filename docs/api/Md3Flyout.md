# Md3Flyout

Anchored light-dismiss panel (WinUI Flyout–inspired). Reparents onto Window.contentItem via Md3OverlayHost — not ApplicationWindow.overlay.

- **Source:** `src/Md3/components/Md3Flyout.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `open` | `bool` | `false` | read/write | `Md3Flyout` | — |
| `modal` | `bool` | `false` | read/write | `Md3Flyout` | When true, use a light scrim; when false, transparent catcher (DateField-style). |
| `overlayWindow` | `var` | `null` | read/write | `Md3Flyout` | — |
| `anchor` | `var` | `null` | read/write | `Md3Flyout` | — |
| `offsetX` | `real` | `0` | read/write | `Md3Flyout` | — |
| `offsetY` | `real` | `4` | read/write | `Md3Flyout` | — |
| `panelX` | `real` | `0` | read/write | `Md3Flyout` | Explicit panel position in overlay coords (set by popup / show). |
| `panelY` | `real` | `0` | read/write | `Md3Flyout` | — |
| `flyoutWidth` | `real` | `0` | read/write | `Md3Flyout` | 0 → content implicit width (min 160). |
| `padding` | `real` | `12` | read/write | `Md3Flyout` | — |
| `elevation` | `real` | `2` | read/write | `Md3Flyout` | — |
| `accessibleName` | `string` | `qsTr("Flyout")` | read/write | `Md3Flyout` | — |
| `content` | `alias` | `contentHost.data` | default read/write | `Md3Flyout` | Default property → `contentHost.data` |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `opened()` | `Md3Flyout` | — |
| `closed()` | `Md3Flyout` | — |
| `dismissed()` | `Md3Flyout` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `hostEnsureParent()` | `Md3Flyout` | — |
| `popup(x, y)` | `Md3Flyout` | — |
| `popupAtItem(item, x, y)` | `Md3Flyout` | — |
| `show(anchorItem)` | `Md3Flyout` | Open below `anchorItem` (defaults to `anchor`). Saves focus for restore on dismiss. |
| `dismiss()` | `Md3Flyout` | — |
| `toggle(anchorItem)` | `Md3Flyout` | — |

## Example

```qml
import Md3

Md3Flyout {
    open: false
    modal: false
    overlayWindow: null
    anchor: null
    offsetX: 0
}
```
