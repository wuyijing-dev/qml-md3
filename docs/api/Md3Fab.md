# Md3Fab

- **Source:** `src/Md3/components/Md3Fab.qml`
- **Extends:** `Md3AbstractButton`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 8 | 0 | 0 | 2 |

## Import

```qml
import Md3
```

## Inheritance

[`Md3Fab`](Md3Fab.md) → [`Md3AbstractButton`](Md3AbstractButton.md)

## Enums

### `Md3Fab.Size`

`Md3Fab.Small`, `Md3Fab.Regular`, `Md3Fab.Large`

### `Md3Fab.ColorRole`

`Md3Fab.Primary`, `Md3Fab.Secondary`, `Md3Fab.Tertiary`, `Md3Fab.Surface`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `size` | `int (Md3Fab.Size)` | `Md3Fab.Regular` | read/write | `Md3Fab` | Control size token (see Enums). |
| `colorRole` | `int (Md3Fab.ColorRole)` | `Md3Fab.Primary` | read/write | `Md3Fab` | Color Role. |
| `iconRotation` | `real` | `0` | read/write | `Md3Fab` | Icon Rotation. |
| `tooltip` | `string` | `""` | read/write | `Md3Fab` | Tooltip. |
| `shadowPad` | `real` | `28` | read/write | `Md3Fab` | Shadow Pad. |
| `fabSize` | `real` | `{…}` | readonly | `Md3Fab` | Fab Size. |
| `iconSize` | `real` | `size === Md3Fab.Large ? 36 : 24` | readonly | `Md3Fab` | Icon Size. |
| `elev` | `real` | `{…}` | readonly | `Md3Fab` | Elev. |
| `text` | `string` | `""` | read/write | [`Md3AbstractButton`](Md3AbstractButton.md) | Primary label text. |
| `icon` | `string` | `""` | read/write | [`Md3AbstractButton`](Md3AbstractButton.md) | Material icon name or empty. |
| `accessibleName` | `string` | `text.length ? text : (icon.length ? icon : qsTr("Button"))` | read/write | [`Md3AbstractButton`](Md3AbstractButton.md) | Accessible name override. |
| `accessibleRole` | `int` | `Accessible.Button` | read/write | [`Md3AbstractButton`](Md3AbstractButton.md) | Accessible Role. |
| `visualFocus` | `bool` | `false` | read/write | [`Md3AbstractButton`](Md3AbstractButton.md) | Keyboard focus ring — set true on Tab / arrow keys; cleared on mouse click. |
| `contentColor` | `color` | `Md3Theme.colorScheme.colorOnSurface` | read/write | [`Md3AbstractButton`](Md3AbstractButton.md) | Content Color. |
| `containerColor` | `color` | `"transparent"` | read/write | [`Md3AbstractButton`](Md3AbstractButton.md) | Container Color. |
| `cornerRadius` | `real` | `0` | read/write | [`Md3AbstractButton`](Md3AbstractButton.md) | Corner radius. |
| `pressTarget` | `Item` | `root` | read/write | [`Md3AbstractButton`](Md3AbstractButton.md) | Coordinate space for pressFeedback (usually the painted background item). |
| `checkable` | `bool` | `false` | read/write | [`Md3AbstractButton`](Md3AbstractButton.md) | When true, Space/Enter/click toggle `checked` before emitting clicked. |
| `checked` | `bool` | `false` | read/write | [`Md3AbstractButton`](Md3AbstractButton.md) | Checked / on state. |
| `pressEnabled` | `bool` | `true` | read/write | [`Md3AbstractButton`](Md3AbstractButton.md) | When false, the built-in MouseArea ignores presses (custom hit areas). |
| `interactive` | `bool` | `true` | read/write | [`Md3AbstractButton`](Md3AbstractButton.md) | Gate clicks / keyboard activate without forcing `enabled: false` (e.g. busy spinner). |
| `pressRightMargin` | `real` | `0` | read/write | [`Md3AbstractButton`](Md3AbstractButton.md) | Press Right Margin. |
| `pressLeftMargin` | `real` | `0` | read/write | [`Md3AbstractButton`](Md3AbstractButton.md) | Press Left Margin. |
| `hovered` | `bool` | `mouse.containsMouse` | readonly | [`Md3AbstractButton`](Md3AbstractButton.md) | Hovered. |
| `pressed` | `bool` | `mouse.pressed` | readonly | [`Md3AbstractButton`](Md3AbstractButton.md) | Pressed. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `clicked()` | [`Md3AbstractButton`](Md3AbstractButton.md) | Emitted when clicked. |
| `toggled(bool checked)` | [`Md3AbstractButton`](Md3AbstractButton.md) | Emitted when toggled. |
| `pressFeedback(real x, real y)` | [`Md3AbstractButton`](Md3AbstractButton.md) | Map click into `pressTarget` so subclasses can `ripple.pulse(x, y)`. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `activate(fromKeyboard)` | `—` | [`Md3AbstractButton`](Md3AbstractButton.md) | Activate. |
| `markKeyboardFocus()` | `—` | [`Md3AbstractButton`](Md3AbstractButton.md) | Mark Keyboard Focus. |

## Example

```qml
import Md3

Md3Fab {
    size: Md3Fab.Regular
    colorRole: Md3Fab.Primary
    iconRotation: 0
    tooltip: ""
    shadowPad: 28
    text: ""
}
```
