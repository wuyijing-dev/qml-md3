# Md3IconButton

- **Source:** `src/Md3/components/Md3IconButton.qml`
- **Extends:** `Md3AbstractButton`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 10 | 0 | 0 | 1 |

## Import

```qml
import Md3
```

## Inheritance

[`Md3IconButton`](Md3IconButton.md) → [`Md3AbstractButton`](Md3AbstractButton.md)

## Enums

### `Md3IconButton.Variant`

`Md3IconButton.Standard`, `Md3IconButton.Filled`, `Md3IconButton.FilledTonal`, `Md3IconButton.Outlined`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `variant` | `int (Md3IconButton.Variant)` | `Md3IconButton.Standard` | read/write | `Md3IconButton` | Visual / role variant (see Enums). |
| `selected` | `bool` | `false` | read/write | `Md3IconButton` | Selected. |
| `badgeText` | `string` | `""` | read/write | `Md3IconButton` | Badge Text. |
| `badgeDot` | `bool` | `false` | read/write | `Md3IconButton` | Badge Dot. |
| `badgeMax` | `int` | `99` | read/write | `Md3IconButton` | Badge Max. |
| `badgeSizePreset` | `int` | `Md3Badge.Medium` | read/write | `Md3IconButton` | Badge Size Preset. |
| `badgeColor` | `color` | `Md3Theme.colorScheme.error` | read/write | `Md3IconButton` | Badge Color. |
| `badgeLabelColor` | `color` | `Md3Theme.colorScheme.colorOnError` | read/write | `Md3IconButton` | Badge Label Color. |
| `circleSize` | `real` | `Md3Theme.iconCircleSize` | readonly | `Md3IconButton` | Circle Size. |
| `circleRadius` | `real` | `circleSize / 2` | readonly | `Md3IconButton` | Circle Radius. |
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

Md3IconButton {
    variant: Md3IconButton.Standard
    selected: false
    badgeText: ""
    badgeDot: false
    badgeMax: 99
    badgeSizePreset: Md3Badge.Medium
}
```
