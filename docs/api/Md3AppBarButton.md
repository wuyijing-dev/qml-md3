# Md3AppBarButton

Compact command-bar action (WinUI AppBarButton / AppBarToggleButton). Set `checkable: true` for toggle behavior.

- **Source:** `src/Md3/components/Md3AppBarButton.qml`
- **Extends:** `Md3AbstractButton`

## Import

```qml
import Md3
```

## Inheritance

[`Md3AppBarButton`](Md3AppBarButton.md) → [`Md3AbstractButton`](Md3AbstractButton.md)

## Enums

### `Md3AppBarButton.Layout`

`Md3AppBarButton.IconOnly`, `Md3AppBarButton.IconAndLabel`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `layout` | `int` | `Md3AppBarButton.IconAndLabel` | read/write | `Md3AppBarButton` | — |
| `label` | `string` | `text` | read/write | `Md3AppBarButton` | Shown under/beside the icon when layout is IconAndLabel. |
| `tileSize` | `real` | `40` | readonly | `Md3AppBarButton` | — |
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

Md3AppBarButton {
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
| AppBarButton | `Md3AppBarButton` | 图标 + 可选标签 |
| AppBarToggleButton | `Md3AppBarToggleButton` 或本类型 `checkable: true` | 按下保持 |

## 用法

```qml
Md3AppBarButton {
    icon: "save"
    label: qsTr("Save")
    onClicked: save()
}

Md3AppBarButton {
    icon: "search"
    layout: Md3AppBarButton.IconOnly
    accessibleName: qsTr("Search")
}
```

优先放在 [`Md3CommandBar`](Md3CommandBar.md) 内；也可用在 `Md3AppToolBar`。
