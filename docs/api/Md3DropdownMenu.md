# Md3DropdownMenu

- **Source:** `src/Md3/components/Md3DropdownMenu.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 8 | 3 | 2 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `text` | `string` | `""` | read/write | `Md3DropdownMenu` | Primary label text. |
| `label` | `string` | `qsTr("Select")` | read/write | `Md3DropdownMenu` | Field / control label. |
| `leadingIcon` | `string` | `""` | read/write | `Md3DropdownMenu` | Leading Icon. |
| `model` | `var` | `[]` | read/write | `Md3DropdownMenu` | Data model. |
| `currentIndex` | `int` | `-1` | read/write | `Md3DropdownMenu` | Current index. |
| `overlayWindow` | `var` | `null` | read/write | `Md3DropdownMenu` | Optional explicit Window for menu overlay. |
| `open` | `bool` | `menu.open` | readonly | `Md3DropdownMenu` | Open the overlay / dialog. |
| `displayText` | `string` | `{…}` | readonly | `Md3DropdownMenu` | Display Text. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `activated(int index)` | `Md3DropdownMenu` | Emitted when activated. |
| `opened()` | `Md3DropdownMenu` | Emitted when opened. |
| `closed()` | `Md3DropdownMenu` | Emitted when closed. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `toggle()` | `—` | `Md3DropdownMenu` | Toggle open / checked state. |
| `openMenu()` | `—` | `Md3DropdownMenu` | Open Menu. |

## Example

```qml
import Md3

Md3DropdownMenu {
    text: ""
    label: qsTr("Select")
    leadingIcon: ""
    model: []
    currentIndex: -1
    overlayWindow: null
}
```
