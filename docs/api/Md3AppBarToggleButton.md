# Md3AppBarToggleButton

WinUI AppBarToggleButton — toolbar action that stays pressed when checked.

- **Source:** `src/Md3/components/Md3AppBarToggleButton.qml`
- **Extends:** `Md3AppBarButton`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 0 | 0 | 0 | 0 |

## Import

```qml
import Md3
```

## Inheritance

[`Md3AppBarToggleButton`](Md3AppBarToggleButton.md) → [`Md3AppBarButton`](Md3AppBarButton.md) → [`Md3AbstractButton`](Md3AbstractButton.md)

## Enums

### `Md3AppBarButton.Layout` _(from [Md3AppBarButton](Md3AppBarButton.md))_

`Md3AppBarButton.IconOnly`, `Md3AppBarButton.IconAndLabel`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `layout` | `int (Md3AppBarButton.Layout)` | `Md3AppBarButton.IconAndLabel` | read/write | [`Md3AppBarButton`](Md3AppBarButton.md) | Layout. |
| `label` | `string` | `text` | read/write | [`Md3AppBarButton`](Md3AppBarButton.md) | Shown under/beside the icon when layout is IconAndLabel. |
| `tileSize` | `real` | `40` | readonly | [`Md3AppBarButton`](Md3AppBarButton.md) | Tile Size. |
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

Md3AppBarToggleButton {
    layout: Md3AppBarButton.IconAndLabel
    label: text
    text: ""
    icon: ""
    accessibleName: text.length ? text : (icon.length ? icon : qsTr("Button"))
    accessibleRole: Accessible.Button
}
```

## WinUI 对照

| WinUI | Md3 | 说明 |
|-------|-----|------|
| AppBarToggleButton | `Md3AppBarToggleButton` | 默认 `checkable: true` |

## 用法

```qml
Md3AppBarToggleButton {
    icon: "grid_view"
    label: qsTr("Grid")
    checked: viewMode === "grid"
    onToggled: (on) => { if (on) viewMode = "grid" }
}

Md3AppBarToggleButton {
    icon: "view_list"
    label: qsTr("List")
    checked: viewMode === "list"
    onToggled: (on) => { if (on) viewMode = "list" }
}
```

互斥视图模式：在 `onToggled` 里改共享状态，或外层用 ButtonGroup 语义自行协调。
