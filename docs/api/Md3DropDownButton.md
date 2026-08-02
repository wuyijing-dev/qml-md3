# Md3DropDownButton

Single-piece button that opens a menu (WinUI DropDownButton). Unlike Md3SplitButton, the whole control opens the menu — no primary action.

- **Source:** `src/Md3/components/Md3DropDownButton.qml`
- **Extends:** `Md3AbstractButton`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 6 | 1 | 3 | 1 |

## Import

```qml
import Md3
```

## Inheritance

[`Md3DropDownButton`](Md3DropDownButton.md) → [`Md3AbstractButton`](Md3AbstractButton.md)

## Enums

### `Md3DropDownButton.Variant`

`Md3DropDownButton.Filled`, `Md3DropDownButton.FilledTonal`, `Md3DropDownButton.Outlined`, `Md3DropDownButton.Text`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `variant` | `int (Md3DropDownButton.Variant)` | `Md3DropDownButton.Filled` | read/write | `Md3DropDownButton` | Visual / role variant (see Enums). |
| `menuModel` | `var` | `[]` | read/write | `Md3DropDownButton` | Menu Model. |
| `overlayWindow` | `var` | `null` | read/write | `Md3DropDownButton` | Optional explicit Window for menu overlay. |
| `menuOpen` | `bool` | `menu.open` | readonly | `Md3DropDownButton` | Menu Open. |
| `h` | `real` | `40` | readonly | `Md3DropDownButton` | H. |
| `padH` | `real` | `16` | readonly | `Md3DropDownButton` | Pad H. |
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
| `menuItemClicked(int index)` | `Md3DropDownButton` | Emitted when menu Item Clicked. |
| `clicked()` | [`Md3AbstractButton`](Md3AbstractButton.md) | Emitted when clicked. |
| `toggled(bool checked)` | [`Md3AbstractButton`](Md3AbstractButton.md) | Emitted when toggled. |
| `pressFeedback(real x, real y)` | [`Md3AbstractButton`](Md3AbstractButton.md) | Map click into `pressTarget` so subclasses can `ripple.pulse(x, y)`. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `toggleMenu()` | `—` | `Md3DropDownButton` | Toggle Menu. |
| `openMenu()` | `—` | `Md3DropDownButton` | Open Menu. |
| `dismissMenu()` | `—` | `Md3DropDownButton` | Dismiss Menu. |
| `activate(fromKeyboard)` | `—` | [`Md3AbstractButton`](Md3AbstractButton.md) | Activate. |
| `markKeyboardFocus()` | `—` | [`Md3AbstractButton`](Md3AbstractButton.md) | Mark Keyboard Focus. |

## Example

```qml
import Md3

Md3DropDownButton {
    variant: Md3DropDownButton.Filled
    menuModel: []
    overlayWindow: null
    text: ""
    icon: ""
    accessibleName: text.length ? text : (icon.length ? icon : qsTr("Button"))
}
```

## WinUI 对照

| WinUI | Md3 | 说明 |
|-------|-----|------|
| DropDownButton | `Md3DropDownButton` | 整钮打开菜单，无独立主操作 |
| SplitButton | `Md3SplitButton` | 主区 `clicked` + 尾段开菜单 |

## 用法

```qml
Md3DropDownButton {
    text: qsTr("Export")
    variant: Md3DropDownButton.Outlined
    menuModel: [
        { text: "PDF", icon: "picture_as_pdf" },
        { text: "CSV", icon: "table_view" },
        { text: "JSON", enabled: false }
    ]
    onMenuItemClicked: (index) => exportAs(index)
}
```

`menuModel` 项：`{ text, icon?, enabled? }`。键盘 ↓ 打开菜单。
