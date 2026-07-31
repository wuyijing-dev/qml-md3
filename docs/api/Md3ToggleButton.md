# Md3ToggleButton

Text toggle button (WinUI ToggleButton / MD3 toggle). Prefer Md3ToggleIconButton for icon-only.

- **Source:** `src/Md3/components/Md3ToggleButton.qml`
- **Extends:** `Md3AbstractButton`

## Import

```qml
import Md3
```

## Inheritance

[`Md3ToggleButton`](Md3ToggleButton.md) → [`Md3AbstractButton`](Md3AbstractButton.md)

## Enums

### `Md3ToggleButton.Variant`

`Md3ToggleButton.Filled`, `Md3ToggleButton.Outlined`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `variant` | `int` | `Md3ToggleButton.Filled` | read/write | `Md3ToggleButton` | — |
| `size` | `int` | `Md3Button.Small` | read/write | `Md3ToggleButton` | — |
| `h` | `real` | `{…}` | readonly | `Md3ToggleButton` | — |
| `padH` | `real` | `size === Md3Button.ExtraSmall ? 12 : (size === Md3Button.Large ? 24 : 16)` | readonly | `Md3ToggleButton` | — |
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
| `toggle()` | `Md3ToggleButton` | — |
| `activate(fromKeyboard)` | [`Md3AbstractButton`](Md3AbstractButton.md) | — |
| `markKeyboardFocus()` | [`Md3AbstractButton`](Md3AbstractButton.md) | — |

## Example

```qml
import Md3

Md3ToggleButton {
    variant: Md3ToggleButton.Filled
    size: Md3Button.Small
    text: ""
    icon: ""
    accessibleName: text.length ? text : (icon.length ? icon : qsTr("Button"))
}
```

## WinUI 对照

| WinUI | Md3 | 说明 |
|-------|-----|------|
| ToggleButton | `Md3ToggleButton` | 文本 + 可选图标；`Filled` / `Outlined` |
| （图标 Toggle） | `Md3ToggleIconButton` | 圆形图标切换，见该类型 |

## 用法

```qml
Md3ToggleButton {
    text: qsTr("Bold")
    icon: "format_bold"
    checked: true
    onToggled: (on) => console.log("bold", on)
}

Md3ToggleButton {
    text: qsTr("Italic")
    variant: Md3ToggleButton.Outlined
}
```

`size` 复用 `Md3Button` 尺寸枚举（`ExtraSmall` / `Small` / `Medium` / `Large`）。
