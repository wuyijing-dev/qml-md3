# Md3Switch

- **Source:** `src/Md3/components/Md3Switch.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `checked` | `bool` | `false` | read/write | `Md3Switch` | — |
| `enabled` | `bool` | `true` | read/write | `Md3Switch` | — |
| `showIcon` | `bool` | `false` | read/write | `Md3Switch` | — |
| `accessibleName` | `string` | `"Switch"` | read/write | `Md3Switch` | — |
| `trackColor` | `color` | `{…}` | readonly | `Md3Switch` | — |
| `thumbColor` | `color` | `{…}` | readonly | `Md3Switch` | — |
| `thumbSize` | `real` | `checked ? 24 : 16` | readonly | `Md3Switch` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `toggled(bool checked)` | `Md3Switch` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `toggle()` | `Md3Switch` | — |

## Example

```qml
import Md3

Md3Switch {
    checked: false
    showIcon: false
    accessibleName: "Switch"
}
```
