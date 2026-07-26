# Md3DropdownMenu

- **Source:** `src/Md3/components/Md3DropdownMenu.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `text` | `string` | `""` | read/write | `Md3DropdownMenu` | — |
| `label` | `string` | `"Select"` | read/write | `Md3DropdownMenu` | — |
| `leadingIcon` | `string` | `""` | read/write | `Md3DropdownMenu` | — |
| `model` | `var` | `[]` | read/write | `Md3DropdownMenu` | — |
| `currentIndex` | `int` | `-1` | read/write | `Md3DropdownMenu` | — |
| `enabled` | `bool` | `true` | read/write | `Md3DropdownMenu` | — |
| `open` | `bool` | `menu.open` | readonly | `Md3DropdownMenu` | — |
| `displayText` | `string` | `{…}` | readonly | `Md3DropdownMenu` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `activated(int index)` | `Md3DropdownMenu` | — |
| `opened()` | `Md3DropdownMenu` | — |
| `closed()` | `Md3DropdownMenu` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `toggle()` | `Md3DropdownMenu` | — |
| `openMenu()` | `Md3DropdownMenu` | — |

## Example

```qml
import Md3

Md3DropdownMenu {
    text: ""
    label: "Select"
    leadingIcon: ""
    model: []
    currentIndex: -1
}
```
