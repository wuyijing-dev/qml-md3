# Md3ExtendedFab

- **Source:** `src/Md3/components/Md3ExtendedFab.qml`
- **Extends:** `Md3AbstractButton`

## Import

```qml
import Md3
```

## Inheritance

[`Md3ExtendedFab`](Md3ExtendedFab.md) → [`Md3AbstractButton`](Md3AbstractButton.md)

## Enums

### `Md3ExtendedFab.ColorRole`

`Md3ExtendedFab.Primary`, `Md3ExtendedFab.Secondary`, `Md3ExtendedFab.Tertiary`, `Md3ExtendedFab.Surface`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `colorRole` | `int` | `Md3ExtendedFab.Primary` | read/write | `Md3ExtendedFab` | — |
| `extended` | `bool` | `true` | read/write | `Md3ExtendedFab` | — |
| `fabHeight` | `real` | `56` | readonly | `Md3ExtendedFab` | — |
| `iconSize` | `real` | `24` | readonly | `Md3ExtendedFab` | — |
| `padStart` | `real` | `icon.length > 0 ? 16 : 20` | readonly | `Md3ExtendedFab` | — |
| `padEnd` | `real` | `20` | readonly | `Md3ExtendedFab` | — |
| `elev` | `real` | `enabled ? (hovered && !pressed ? 8 : 6) : 0` | readonly | `Md3ExtendedFab` | — |
| `shadowPad` | `real` | `28` | readonly | `Md3ExtendedFab` | — |
| `collapsedWidth` | `real` | `fabHeight` | readonly | `Md3ExtendedFab` | — |
| `expandedWidth` | `real` | `padStart + (icon.length > 0 ? iconSize + 8 : 0)` | readonly | `Md3ExtendedFab` | — |
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

Md3ExtendedFab {
    colorRole: Md3ExtendedFab.Primary
    extended: true
    text: ""
    icon: ""
    accessibleName: text.length ? text : (icon.length ? icon : qsTr("Button"))
}
```
