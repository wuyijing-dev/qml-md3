# Md3AbstractButton

Shared pressable base for Md3Button / IconButton / FAB / Chip. Subclasses set `contentColor`, `containerColor`, `cornerRadius`, `pressTarget`, and handle `onPressFeedback` to pulse their Md3Ripple.

- **Source:** `src/Md3/primitives/Md3AbstractButton.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `text` | `string` | `""` | read/write | `Md3AbstractButton` | — |
| `icon` | `string` | `""` | read/write | `Md3AbstractButton` | — |
| `accessibleName` | `string` | `text.length ? text : (icon.length ? icon : qsTr("Button"))` | read/write | `Md3AbstractButton` | — |
| `accessibleRole` | `int` | `Accessible.Button` | read/write | `Md3AbstractButton` | — |
| `visualFocus` | `bool` | `false` | read/write | `Md3AbstractButton` | Keyboard focus ring — set true on Tab / arrow keys; cleared on mouse click. |
| `contentColor` | `color` | `Md3Theme.colorScheme.colorOnSurface` | read/write | `Md3AbstractButton` | — |
| `containerColor` | `color` | `"transparent"` | read/write | `Md3AbstractButton` | — |
| `cornerRadius` | `real` | `0` | read/write | `Md3AbstractButton` | — |
| `pressTarget` | `Item` | `root` | read/write | `Md3AbstractButton` | Coordinate space for pressFeedback (usually the painted background item). |
| `checkable` | `bool` | `false` | read/write | `Md3AbstractButton` | When true, Space/Enter/click toggle `checked` before emitting clicked. |
| `checked` | `bool` | `false` | read/write | `Md3AbstractButton` | — |
| `pressEnabled` | `bool` | `true` | read/write | `Md3AbstractButton` | When false, the built-in MouseArea ignores presses (custom hit areas). |
| `pressRightMargin` | `real` | `0` | read/write | `Md3AbstractButton` | — |
| `pressLeftMargin` | `real` | `0` | read/write | `Md3AbstractButton` | — |
| `hovered` | `bool` | `mouse.containsMouse` | readonly | `Md3AbstractButton` | — |
| `pressed` | `bool` | `mouse.pressed` | readonly | `Md3AbstractButton` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `clicked()` | `Md3AbstractButton` | — |
| `toggled(bool checked)` | `Md3AbstractButton` | — |
| `pressFeedback(real x, real y)` | `Md3AbstractButton` | Map click into `pressTarget` so subclasses can `ripple.pulse(x, y)`. |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `activate(fromKeyboard)` | `Md3AbstractButton` | — |
| `markKeyboardFocus()` | `Md3AbstractButton` | — |

## Example

```qml
import Md3

Md3AbstractButton {
    text: ""
    icon: ""
    accessibleName: text.length ? text : (icon.length ? icon : qsTr("Button"))
    accessibleRole: Accessible.Button
    visualFocus: false
}
```
