# Md3ListTile

- **Source:** `src/Md3/components/Md3ListTile.qml`
- **Extends:** `Md3AbstractButton`

## Import

```qml
import Md3
```

## Inheritance

[`Md3ListTile`](Md3ListTile.md) → [`Md3AbstractButton`](Md3AbstractButton.md)

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `title` | `string` | `""` | read/write | `Md3ListTile` | — |
| `subtitle` | `string` | `""` | read/write | `Md3ListTile` | — |
| `supportingText` | `string` | `""` | read/write | `Md3ListTile` | — |
| `leadingIcon` | `string` | `""` | read/write | `Md3ListTile` | — |
| `trailingIcon` | `string` | `""` | read/write | `Md3ListTile` | — |
| `leadingAvatar` | `string` | `""` | read/write | `Md3ListTile` | Initials for a leading Md3Avatar (when no `leading:` slot). |
| `leadingAvatarSource` | `url` | `""` | read/write | `Md3ListTile` | Image URL for a leading Md3Avatar. |
| `trailingRotation` | `real` | `0` | read/write | `Md3ListTile` | Degrees applied to trailing icon (e.g. ExpansionTile chevron). |
| `selected` | `bool` | `false` | read/write | `Md3ListTile` | — |
| `showDivider` | `bool` | `false` | read/write | `Md3ListTile` | — |
| `fillWidth` | `bool` | `true` | read/write | `Md3ListTile` | Stretch to parent width (default) — removes `width: parent.width` glue. |
| `leading` | `alias` | `leadingSlot.data` | read/write | `Md3ListTile` | Optional leading control slot (e.g. custom avatar) — peer of `trailing:`. |
| `trailing` | `alias` | `trailingSlot.data` | read/write | `Md3ListTile` | Optional trailing control slot (e.g. Md3Switch) — prefer over inventing a Row. |
| `lines` | `int` | `{…}` | readonly | `Md3ListTile` | — |
| `minH` | `real` | `{…}` | readonly | `Md3ListTile` | — |
| `hasTrailingSlot` | `bool` | `trailingSlot.children.length > 0` | readonly | `Md3ListTile` | — |
| `hasLeadingSlot` | `bool` | `leadingSlot.children.length > 0` | readonly | `Md3ListTile` | — |
| `hasLeadingAvatar` | `bool` | `leadingAvatar.length > 0` | readonly | `Md3ListTile` | — |
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
| `pressRightMargin` | `real` | `0` | read/write | [`Md3AbstractButton`](Md3AbstractButton.md) | — |
| `pressLeftMargin` | `real` | `0` | read/write | [`Md3AbstractButton`](Md3AbstractButton.md) | — |
| `hovered` | `bool` | `mouse.containsMouse` | readonly | [`Md3AbstractButton`](Md3AbstractButton.md) | — |
| `pressed` | `bool` | `mouse.pressed` | readonly | [`Md3AbstractButton`](Md3AbstractButton.md) | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `trailingClicked()` | `Md3ListTile` | — |
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

Md3ListTile {
    title: ""
    subtitle: ""
    supportingText: ""
    leadingIcon: ""
    trailingIcon: ""
}
```
