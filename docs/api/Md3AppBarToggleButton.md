# Md3AppBarToggleButton

WinUI AppBarToggleButton — toolbar action that stays pressed when checked.

- **Source:** `src/Md3/components/Md3AppBarToggleButton.qml`
- **Extends:** `Md3AppBarButton`

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
| `layout` | `int` | `Md3AppBarButton.IconAndLabel` | read/write | [`Md3AppBarButton`](Md3AppBarButton.md) | — |
| `label` | `string` | `text` | read/write | [`Md3AppBarButton`](Md3AppBarButton.md) | Shown under/beside the icon when layout is IconAndLabel. |
| `tileSize` | `real` | `40` | readonly | [`Md3AppBarButton`](Md3AppBarButton.md) | — |
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

Md3AppBarToggleButton {
    layout: Md3AppBarButton.IconAndLabel
    label: text
    text: ""
    icon: ""
    accessibleName: text.length ? text : (icon.length ? icon : qsTr("Button"))
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
