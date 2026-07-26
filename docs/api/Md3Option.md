# Md3Option

- **Source:** `src/Md3/components/Md3Option.qml`
- **Extends:** `Md3DropdownMenu`

## Import

```qml
import Md3
```

## Inheritance

[`Md3Option`](Md3Option.md) → [`Md3DropdownMenu`](Md3DropdownMenu.md)

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `text` | `string` | `""` | read/write | [`Md3DropdownMenu`](Md3DropdownMenu.md) | — |
| `label` | `string` | `"Select"` | read/write | [`Md3DropdownMenu`](Md3DropdownMenu.md) | — |
| `leadingIcon` | `string` | `""` | read/write | [`Md3DropdownMenu`](Md3DropdownMenu.md) | — |
| `model` | `var` | `[]` | read/write | [`Md3DropdownMenu`](Md3DropdownMenu.md) | — |
| `currentIndex` | `int` | `-1` | read/write | [`Md3DropdownMenu`](Md3DropdownMenu.md) | — |
| `enabled` | `bool` | `true` | read/write | [`Md3DropdownMenu`](Md3DropdownMenu.md) | — |
| `open` | `bool` | `menu.open` | readonly | [`Md3DropdownMenu`](Md3DropdownMenu.md) | — |
| `displayText` | `string` | `{…}` | readonly | [`Md3DropdownMenu`](Md3DropdownMenu.md) | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `activated(int index)` | [`Md3DropdownMenu`](Md3DropdownMenu.md) | — |
| `opened()` | [`Md3DropdownMenu`](Md3DropdownMenu.md) | — |
| `closed()` | [`Md3DropdownMenu`](Md3DropdownMenu.md) | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `toggle()` | [`Md3DropdownMenu`](Md3DropdownMenu.md) | — |
| `openMenu()` | [`Md3DropdownMenu`](Md3DropdownMenu.md) | — |

## Example

```qml
import Md3

Md3Option {
    text: ""
    label: "Select"
    leadingIcon: ""
    model: []
    currentIndex: -1
}
```
