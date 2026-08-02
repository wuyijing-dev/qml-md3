# Md3Option

- **Source:** `src/Md3/components/Md3Option.qml`
- **Extends:** `Md3DropdownMenu`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 0 | 0 | 0 | 0 |

## Import

```qml
import Md3
```

## Inheritance

[`Md3Option`](Md3Option.md) → [`Md3DropdownMenu`](Md3DropdownMenu.md)

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `text` | `string` | `""` | read/write | [`Md3DropdownMenu`](Md3DropdownMenu.md) | Primary label text. |
| `label` | `string` | `qsTr("Select")` | read/write | [`Md3DropdownMenu`](Md3DropdownMenu.md) | Field / control label. |
| `leadingIcon` | `string` | `""` | read/write | [`Md3DropdownMenu`](Md3DropdownMenu.md) | Leading Icon. |
| `model` | `var` | `[]` | read/write | [`Md3DropdownMenu`](Md3DropdownMenu.md) | Data model. |
| `currentIndex` | `int` | `-1` | read/write | [`Md3DropdownMenu`](Md3DropdownMenu.md) | Current index. |
| `overlayWindow` | `var` | `null` | read/write | [`Md3DropdownMenu`](Md3DropdownMenu.md) | Optional explicit Window for menu overlay. |
| `open` | `bool` | `menu.open` | readonly | [`Md3DropdownMenu`](Md3DropdownMenu.md) | Open the overlay / dialog. |
| `displayText` | `string` | `{…}` | readonly | [`Md3DropdownMenu`](Md3DropdownMenu.md) | Display Text. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `activated(int index)` | [`Md3DropdownMenu`](Md3DropdownMenu.md) | Emitted when activated. |
| `opened()` | [`Md3DropdownMenu`](Md3DropdownMenu.md) | Emitted when opened. |
| `closed()` | [`Md3DropdownMenu`](Md3DropdownMenu.md) | Emitted when closed. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `toggle()` | `—` | [`Md3DropdownMenu`](Md3DropdownMenu.md) | Toggle open / checked state. |
| `openMenu()` | `—` | [`Md3DropdownMenu`](Md3DropdownMenu.md) | Open Menu. |

## Example

```qml
import Md3

Md3Option {
    text: ""
    label: qsTr("Select")
    leadingIcon: ""
    model: []
    currentIndex: -1
    overlayWindow: null
}
```
