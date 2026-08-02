# Md3ListTile

- **Source:** `src/Md3/components/Md3ListTile.qml`
- **Extends:** `Md3AbstractButton`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 18 | 1 | 0 | 0 |

## Import

```qml
import Md3
```

## Inheritance

[`Md3ListTile`](Md3ListTile.md) → [`Md3AbstractButton`](Md3AbstractButton.md)

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `title` | `string` | `""` | read/write | `Md3ListTile` | Title text. |
| `subtitle` | `string` | `""` | read/write | `Md3ListTile` | Secondary supporting text. |
| `supportingText` | `string` | `""` | read/write | `Md3ListTile` | Supporting Text. |
| `leadingIcon` | `string` | `""` | read/write | `Md3ListTile` | Leading Icon. |
| `trailingIcon` | `string` | `""` | read/write | `Md3ListTile` | Trailing Icon. |
| `leadingAvatar` | `string` | `""` | read/write | `Md3ListTile` | Initials for a leading Md3Avatar (when no `leading:` slot). |
| `leadingAvatarSource` | `url` | `""` | read/write | `Md3ListTile` | Image URL for a leading Md3Avatar. |
| `trailingRotation` | `real` | `0` | read/write | `Md3ListTile` | Degrees applied to trailing icon (e.g. ExpansionTile chevron). |
| `selected` | `bool` | `false` | read/write | `Md3ListTile` | Selected. |
| `showDivider` | `bool` | `false` | read/write | `Md3ListTile` | Show Divider. |
| `fillWidth` | `bool` | `true` | read/write | `Md3ListTile` | Stretch to parent width (default) — removes `width: parent.width` glue. |
| `leading` | `alias` | `leadingSlot.data` | read/write | `Md3ListTile` | Optional leading control slot (e.g. custom avatar) — peer of `trailing:`. |
| `trailing` | `alias` | `trailingSlot.data` | read/write | `Md3ListTile` | Optional trailing control slot (e.g. Md3Switch) — prefer over inventing a Row. |
| `lines` | `int` | `{…}` | readonly | `Md3ListTile` | Lines. |
| `minH` | `real` | `{…}` | readonly | `Md3ListTile` | Min H. |
| `hasTrailingSlot` | `bool` | `trailingSlot.children.length > 0` | readonly | `Md3ListTile` | Has Trailing Slot. |
| `hasLeadingSlot` | `bool` | `leadingSlot.children.length > 0` | readonly | `Md3ListTile` | Has Leading Slot. |
| `hasLeadingAvatar` | `bool` | `leadingAvatar.length > 0` | readonly | `Md3ListTile` | Has Leading Avatar. |
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
| `trailingClicked()` | `Md3ListTile` | Emitted when trailing Clicked. |
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

Md3ListTile {
    title: ""
    subtitle: ""
    supportingText: ""
    leadingIcon: ""
    trailingIcon: ""
    leadingAvatar: ""
}
```
