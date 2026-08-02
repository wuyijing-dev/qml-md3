# Md3Button

- **Source:** `src/Md3/components/Md3Button.qml`
- **Extends:** `Md3AbstractButton`

## Import

```qml
import Md3
```

## Inheritance

[`Md3Button`](Md3Button.md) → [`Md3AbstractButton`](Md3AbstractButton.md)

## Enums

### `Md3Button.Variant`

`Md3Button.Filled`, `Md3Button.FilledTonal`, `Md3Button.Elevated`, `Md3Button.Outlined`, `Md3Button.Text`

### `Md3Button.Size`

`Md3Button.ExtraSmall`, `Md3Button.Small`, `Md3Button.Medium`, `Md3Button.Large`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `variant` | `int` | `Md3Button.Filled` | read/write | `Md3Button` | — |
| `size` | `int` | `Md3Button.Small` | read/write | `Md3Button` | — |
| `busy` | `bool` | `false` | read/write | `Md3Button` | Show spinner and block clicks while keeping the laid-out width. |
| `effectivelyEnabled` | `bool` | `enabled` | readonly | `Md3Button` | Visual enabled (colors). Busy keeps brand colors and shows a spinner instead. |
| `h` | `real` | `{…}` | readonly | `Md3Button` | — |
| `padH` | `real` | `size === Md3Button.ExtraSmall ? 12 : (size === Md3Button.Large ? 24 : 16)` | readonly | `Md3Button` | — |
| `elev` | `real` | `variant === Md3Button.Elevated ? (hovered \|\| pressed ? 2 : 1) : 0` | readonly | `Md3Button` | — |
| `text` | `string` | `""` | read/write | [`Md3AbstractButton`](Md3AbstractButton.md) | — |
| `icon` | `string` | `""` | read/write | [`Md3AbstractButton`](Md3AbstractButton.md) | — |
| `accessibleName` | `string` | `text.length ? text : (icon.length ? icon : qsTr("Button"))` | read/write | [`Md3AbstractButton`](Md3AbstractButton.md) | — |
| `accessibleRole` | `int` | `Accessible.Button` | read/write | [`Md3AbstractButton`](Md3AbstractButton.md) | — |
| `visualFocus` | `bool` | `false` | read/write | [`Md3AbstractButton`](Md3AbstractButton.md) | Keyboard focus ring — set true on Tab / arrow keys; cleared on mouse click. |
| `contentColor` | `color` | `Md3Theme.colorScheme.colorOnSurface` | read/write | [`Md3AbstractButton`](Md3AbstractButton.md) | — |
| `containerColor` | `color` | `"transparent"` | read/write | [`Md3AbstractButton`](Md3AbstractButton.md) | — |
| `cornerRadius` | `real` | `0` | read/write | [`Md3AbstractButton`](Md3AbstractButton.md) | — |
| `pressTarget` | `Item` | `root` | read/write | [`Md3AbstractButton`](Md3AbstractButton.md) | Coordinate space for pressFeedback (usually the painted background item). |
| `checkable` | `bool` | `false` | read/write | [`Md3AbstractButton`](Md3AbstractButton.md) | When true, Space/Enter/click toggle `checked` before emitting clicked. |
| `checked` | `bool` | `false` | read/write | [`Md3AbstractButton`](Md3AbstractButton.md) | — |
| `pressEnabled` | `bool` | `true` | read/write | [`Md3AbstractButton`](Md3AbstractButton.md) | When false, the built-in MouseArea ignores presses (custom hit areas). |
| `interactive` | `bool` | `true` | read/write | [`Md3AbstractButton`](Md3AbstractButton.md) | Gate clicks / keyboard activate without forcing `enabled: false` (e.g. busy spinner). |
| `pressRightMargin` | `real` | `0` | read/write | [`Md3AbstractButton`](Md3AbstractButton.md) | — |
| `pressLeftMargin` | `real` | `0` | read/write | [`Md3AbstractButton`](Md3AbstractButton.md) | — |
| `hovered` | `bool` | `mouse.containsMouse` | readonly | [`Md3AbstractButton`](Md3AbstractButton.md) | — |
| `pressed` | `bool` | `mouse.pressed` | readonly | [`Md3AbstractButton`](Md3AbstractButton.md) | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `clicked()` | [`Md3AbstractButton`](Md3AbstractButton.md) | — |
| `toggled(bool checked)` | [`Md3AbstractButton`](Md3AbstractButton.md) | — |
| `pressFeedback(real x, real y)` | [`Md3AbstractButton`](Md3AbstractButton.md) | Map click into `pressTarget` so subclasses can `ripple.pulse(x, y)`. |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `activate(fromKeyboard)` | [`Md3AbstractButton`](Md3AbstractButton.md) | — |
| `markKeyboardFocus()` | [`Md3AbstractButton`](Md3AbstractButton.md) | — |

## Example

```qml
import Md3

Md3Button {
    variant: Md3Button.Filled
    size: Md3Button.Small
    busy: false
    text: ""
    icon: ""
}
```
