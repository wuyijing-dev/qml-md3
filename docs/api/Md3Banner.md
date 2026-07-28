# Md3Banner

- **Source:** `src/Md3/components/Md3Banner.qml`
- **Extends:** `Rectangle`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `text` | `string` | `""` | read/write | `Md3Banner` | — |
| `leadingIcon` | `string` | `"info"` | read/write | `Md3Banner` | — |
| `primaryAction` | `string` | `""` | read/write | `Md3Banner` | — |
| `secondaryAction` | `string` | `""` | read/write | `Md3Banner` | — |
| `showClose` | `bool` | `true` | read/write | `Md3Banner` | — |
| `open` | `bool` | `true` | read/write | `Md3Banner` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `primaryClicked()` | `Md3Banner` | — |
| `secondaryClicked()` | `Md3Banner` | — |
| `closed()` | `Md3Banner` | — |

## Methods

_None._

## Example

```qml
import Md3

Md3Banner {
    text: ""
    leadingIcon: "info"
    primaryAction: ""
    secondaryAction: ""
    showClose: true
}
```
