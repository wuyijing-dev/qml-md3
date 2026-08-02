# Md3AbstractButton

Shared pressable base for Md3Button / IconButton / FAB / Chip. Subclasses set `contentColor`, `containerColor`, `cornerRadius`, `pressTarget`, and handle `onPressFeedback` to pulse their Md3Ripple.

- **Source:** `src/Md3/primitives/Md3AbstractButton.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 17 | 3 | 2 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `text` | `string` | `""` | read/write | `Md3AbstractButton` | Primary label text. |
| `icon` | `string` | `""` | read/write | `Md3AbstractButton` | Material icon name or empty. |
| `accessibleName` | `string` | `text.length ? text : (icon.length ? icon : qsTr("Button"))` | read/write | `Md3AbstractButton` | Accessible name override. |
| `accessibleRole` | `int` | `Accessible.Button` | read/write | `Md3AbstractButton` | Accessible Role. |
| `visualFocus` | `bool` | `false` | read/write | `Md3AbstractButton` | Keyboard focus ring — set true on Tab / arrow keys; cleared on mouse click. |
| `contentColor` | `color` | `Md3Theme.colorScheme.colorOnSurface` | read/write | `Md3AbstractButton` | Content Color. |
| `containerColor` | `color` | `"transparent"` | read/write | `Md3AbstractButton` | Container Color. |
| `cornerRadius` | `real` | `0` | read/write | `Md3AbstractButton` | Corner radius. |
| `pressTarget` | `Item` | `root` | read/write | `Md3AbstractButton` | Coordinate space for pressFeedback (usually the painted background item). |
| `checkable` | `bool` | `false` | read/write | `Md3AbstractButton` | When true, Space/Enter/click toggle `checked` before emitting clicked. |
| `checked` | `bool` | `false` | read/write | `Md3AbstractButton` | Checked / on state. |
| `pressEnabled` | `bool` | `true` | read/write | `Md3AbstractButton` | When false, the built-in MouseArea ignores presses (custom hit areas). |
| `interactive` | `bool` | `true` | read/write | `Md3AbstractButton` | Gate clicks / keyboard activate without forcing `enabled: false` (e.g. busy spinner). |
| `pressRightMargin` | `real` | `0` | read/write | `Md3AbstractButton` | Press Right Margin. |
| `pressLeftMargin` | `real` | `0` | read/write | `Md3AbstractButton` | Press Left Margin. |
| `hovered` | `bool` | `mouse.containsMouse` | readonly | `Md3AbstractButton` | Hovered. |
| `pressed` | `bool` | `mouse.pressed` | readonly | `Md3AbstractButton` | Pressed. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `clicked()` | `Md3AbstractButton` | Emitted when clicked. |
| `toggled(bool checked)` | `Md3AbstractButton` | Emitted when toggled. |
| `pressFeedback(real x, real y)` | `Md3AbstractButton` | Map click into `pressTarget` so subclasses can `ripple.pulse(x, y)`. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `activate(fromKeyboard)` | `—` | `Md3AbstractButton` | Activate. |
| `markKeyboardFocus()` | `—` | `Md3AbstractButton` | Mark Keyboard Focus. |

## Example

```qml
import Md3

Md3AbstractButton {
    text: ""
    icon: ""
    accessibleName: text.length ? text : (icon.length ? icon : qsTr("Button"))
    accessibleRole: Accessible.Button
    visualFocus: false
    contentColor: Md3Theme.colorScheme.colorOnSurface
}
```
