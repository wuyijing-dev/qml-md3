# Md3SplitButton

- **Source:** `src/Md3/components/Md3SplitButton.qml`
- **Extends:** `Md3AbstractButton`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 9 | 1 | 2 | 1 |

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
| `variant` | `int (Md3SplitButton.Variant)` | `Md3SplitButton.Filled` | read/write | `Md3SplitButton` | Visual / role variant (see Enums). |
| `menuModel` | `var` | `[]` | read/write | `Md3SplitButton` | Menu Model. |
| `overlayWindow` | `var` | `null` | read/write | `Md3SplitButton` | Optional explicit Window for menu overlay. |
| `menuOpen` | `bool` | `menu.open` | readonly | `Md3SplitButton` | Menu Open. |
| `h` | `real` | `40` | readonly | `Md3SplitButton` | H. |
| `corner` | `real` | `h / 2` | readonly | `Md3SplitButton` | Corner. |
| `trailingWidth` | `real` | `40` | readonly | `Md3SplitButton` | Trailing Width. |
| `containerColor` | `color` | `{…}` | readonly | `Md3SplitButton` | Container Color. |
| `contentColor` | `color` | `{…}` | readonly | `Md3SplitButton` | Content Color. |
| `text` | `string` | `""` | read/write | [`Md3AbstractButton`](Md3AbstractButton.md) | Primary label text. |
| `icon` | `string` | `""` | read/write | [`Md3AbstractButton`](Md3AbstractButton.md) | Material icon name or empty. |
| `accessibleName` | `string` | `text.length ? text : (icon.length ? icon : qsTr("Button"))` | read/write | [`Md3AbstractButton`](Md3AbstractButton.md) | Accessible name override. |
| `accessibleRole` | `int` | `Accessible.Button` | read/write | [`Md3AbstractButton`](Md3AbstractButton.md) | Accessible Role. |
| `visualFocus` | `bool` | `false` | read/write | [`Md3AbstractButton`](Md3AbstractButton.md) | Keyboard focus ring — set true on Tab / arrow keys; cleared on mouse click. |
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
| `menuItemClicked(int index)` | `Md3SplitButton` | Emitted when menu Item Clicked. |
| `clicked()` | [`Md3AbstractButton`](Md3AbstractButton.md) | Emitted when clicked. |
| `toggled(bool checked)` | [`Md3AbstractButton`](Md3AbstractButton.md) | Emitted when toggled. |
| `pressFeedback(real x, real y)` | [`Md3AbstractButton`](Md3AbstractButton.md) | Map click into `pressTarget` so subclasses can `ripple.pulse(x, y)`. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `openMenu()` | `—` | `Md3SplitButton` | Open Menu. |
| `dismissMenu()` | `—` | `Md3SplitButton` | Dismiss Menu. |
| `activate(fromKeyboard)` | `—` | [`Md3AbstractButton`](Md3AbstractButton.md) | Activate. |
| `markKeyboardFocus()` | `—` | [`Md3AbstractButton`](Md3AbstractButton.md) | Mark Keyboard Focus. |

## Example

```qml
import Md3

Md3SplitButton {
    variant: Md3SplitButton.Filled
    menuModel: []
    overlayWindow: null
    text: ""
    icon: ""
    accessibleName: text.length ? text : (icon.length ? icon : qsTr("Button"))
}
```
