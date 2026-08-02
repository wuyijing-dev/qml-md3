# Md3FilterChip

Filter chip — selection is usually owned by the host (`selected:` binding). Does not auto-toggle; emit `clicked` and let the parent update `selected`.

- **Source:** `src/Md3/components/Md3FilterChip.qml`
- **Extends:** `Md3AbstractButton`

## Import

```qml
import Md3
```

## Inheritance

[`Md3FilterChip`](Md3FilterChip.md) → [`Md3AbstractButton`](Md3AbstractButton.md)

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `elevated` | `bool` | `false` | read/write | `Md3FilterChip` | — |
| `selected` | `bool` | `false` | read/write | `Md3FilterChip` | — |
| `chipHeight` | `real` | `Md3Theme.chipHeight` | read/write | `Md3FilterChip` | — |
| `iconSize` | `real` | `18` | read/write | `Md3FilterChip` | — |
| `fontSize` | `real` | `Md3Theme.scaled(Md3Theme.typography.labelLarge.size)` | read/write | `Md3FilterChip` | — |
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

Md3FilterChip {
    elevated: false
    selected: false
    chipHeight: Md3Theme.chipHeight
    iconSize: 18
    fontSize: Md3Theme.scaled(Md3Theme.typography.labelLarge.size)
}
```
