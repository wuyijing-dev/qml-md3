# Md3SplitButton

- **Source:** `src/Md3/components/Md3SplitButton.qml`
- **Extends:** `Md3AbstractButton`

## Import

```qml
import Md3
```

## Inheritance

[`Md3SplitButton`](Md3SplitButton.md) → [`Md3AbstractButton`](Md3AbstractButton.md)

## Enums

### `Md3SplitButton.Variant`

`Md3SplitButton.Filled`, `Md3SplitButton.FilledTonal`, `Md3SplitButton.Outlined`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `variant` | `int` | `Md3SplitButton.Filled` | read/write | `Md3SplitButton` | — |
| `menuModel` | `var` | `[]` | read/write | `Md3SplitButton` | — |
| `overlayWindow` | `var` | `null` | read/write | `Md3SplitButton` | Optional explicit Window for menu overlay. |
| `menuOpen` | `bool` | `menu.open` | readonly | `Md3SplitButton` | — |
| `h` | `real` | `40` | readonly | `Md3SplitButton` | — |
| `corner` | `real` | `h / 2` | readonly | `Md3SplitButton` | — |
| `trailingWidth` | `real` | `40` | readonly | `Md3SplitButton` | — |
| `containerColor` | `color` | `{…}` | readonly | `Md3SplitButton` | — |
| `contentColor` | `color` | `{…}` | readonly | `Md3SplitButton` | — |
| `text` | `string` | `""` | read/write | [`Md3AbstractButton`](Md3AbstractButton.md) | — |
| `icon` | `string` | `""` | read/write | [`Md3AbstractButton`](Md3AbstractButton.md) | — |
| `accessibleName` | `string` | `text.length ? text : (icon.length ? icon : qsTr("Button"))` | read/write | [`Md3AbstractButton`](Md3AbstractButton.md) | — |
| `accessibleRole` | `int` | `Accessible.Button` | read/write | [`Md3AbstractButton`](Md3AbstractButton.md) | — |
| `visualFocus` | `bool` | `false` | read/write | [`Md3AbstractButton`](Md3AbstractButton.md) | Keyboard focus ring — set true on Tab / arrow keys; cleared on mouse click. |
| `cornerRadius` | `real` | `0` | read/write | [`Md3AbstractButton`](Md3AbstractButton.md) | — |
| `pressTarget` | `Item` | `root` | read/write | [`Md3AbstractButton`](Md3AbstractButton.md) | Coordinate space for pressFeedback (usually the painted background item). |
| `checkable` | `bool` | `false` | read/write | [`Md3AbstractButton`](Md3AbstractButton.md) | When true, Space/Enter/click toggle `checked` before emitting clicked. |
| `checked` | `bool` | `false` | read/write | [`Md3AbstractButton`](Md3AbstractButton.md) | — |
| `pressEnabled` | `bool` | `true` | read/write | [`Md3AbstractButton`](Md3AbstractButton.md) | When false, the built-in MouseArea ignores presses (custom hit areas). |
| `pressRightMargin` | `real` | `0` | read/write | [`Md3AbstractButton`](Md3AbstractButton.md) | — |
| `pressLeftMargin` | `real` | `0` | read/write | [`Md3AbstractButton`](Md3AbstractButton.md) | — |
| `hovered` | `bool` | `mouse.containsMouse` | readonly | [`Md3AbstractButton`](Md3AbstractButton.md) | — |
| `pressed` | `bool` | `mouse.pressed` | readonly | [`Md3AbstractButton`](Md3AbstractButton.md) | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `menuItemClicked(int index)` | `Md3SplitButton` | — |
| `clicked()` | [`Md3AbstractButton`](Md3AbstractButton.md) | — |
| `toggled(bool checked)` | [`Md3AbstractButton`](Md3AbstractButton.md) | — |
| `pressFeedback(real x, real y)` | [`Md3AbstractButton`](Md3AbstractButton.md) | Map click into `pressTarget` so subclasses can `ripple.pulse(x, y)`. |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `openMenu()` | `Md3SplitButton` | — |
| `dismissMenu()` | `Md3SplitButton` | — |
| `activate(fromKeyboard)` | [`Md3AbstractButton`](Md3AbstractButton.md) | — |
| `markKeyboardFocus()` | [`Md3AbstractButton`](Md3AbstractButton.md) | — |

## Example

```qml
import Md3

Md3SplitButton {
    variant: Md3SplitButton.Filled
    menuModel: []
    overlayWindow: null
    text: ""
    icon: ""
}
```
