# Md3Radio

- **Source:** `src/Md3/components/Md3Radio.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `checked` | `bool` | `false` | read/write | `Md3Radio` | — |
| `group` | `var` | `null // optional shared QtObject with property selectedValue` | read/write | `Md3Radio` | — |
| `value` | `var` | `null` | read/write | `Md3Radio` | — |
| `enabled` | `bool` | `true` | read/write | `Md3Radio` | — |
| `accessibleName` | `string` | `"Radio"` | read/write | `Md3Radio` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `clicked()` | `Md3Radio` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `select()` | `Md3Radio` | — |

## Example

```qml
import Md3

Md3Radio {
    checked: false
    group: null // optional shared QtObject with property selectedValue
    value: null
    accessibleName: "Radio"
}
```
