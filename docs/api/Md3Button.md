# Md3Button

- **Source:** `src/Md3/components/Md3Button.qml`
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

[`Md3Button`](Md3Button.md) → [`Md3AbstractButton`](Md3AbstractButton.md)

## Enums

### `Md3Button.Variant`

`Md3Button.Filled`, `Md3Button.FilledTonal`, `Md3Button.Elevated`, `Md3Button.Outlined`, `Md3Button.Text`

### `Md3Button.Size`

`Md3Button.ExtraSmall`, `Md3Button.Small`, `Md3Button.Medium`, `Md3Button.Large`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `variant` | `int (Md3Button.Variant)` | `Md3Button.Filled` | read/write | `Md3Button` | Visual / role variant (see Enums). |
| `size` | `int (Md3Button.Size)` | `Md3Button.Small` | read/write | `Md3Button` | Control size token (see Enums). |
| `busy` | `bool` | `false` | read/write | `Md3Button` | Show spinner and block clicks while keeping the laid-out width. |
| `danger` | `bool` | `false` | read/write | `Md3Button` | Destructive / error emphasis (Filled uses error container). |
| `effectivelyEnabled` | `bool` | `enabled` | readonly | `Md3Button` | Visual enabled (colors). Busy keeps brand colors and shows a spinner instead. |
| `h` | `real` | `{…}` | readonly | `Md3Button` | H. |
| `padH` | `real` | `size === Md3Button.ExtraSmall ? 12 : (size === Md3Button.Large ? 24 : 16)` | readonly | `Md3Button` | Pad H. |
| `elev` | `real` | `variant === Md3Button.Elevated ? (hovered \|\| pressed ? 2 : 1) : 0` | readonly | `Md3Button` | Elev. |
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
| `writeCheckedOnToggle` | `bool` | `true` | read/write | [`Md3AbstractButton`](Md3AbstractButton.md) | When true (default), activate writes ``checked``. Set false if ``checked`` is bound externally (same contract as overlay ``writeOpenOnClose``). |
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

Md3Button {
    variant: Md3Button.Filled
    size: Md3Button.Small
    busy: false
    danger: false
    text: ""
    icon: ""
}
```
