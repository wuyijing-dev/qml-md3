# Md3Divider

- **Source:** `src/Md3/components/Md3Divider.qml`
- **Extends:** `Rectangle`

## Import

```qml
import Md3
```

## Enums

### `Md3Divider.Variant`

`Md3Divider.Full`, `Md3Divider.Inset`, `Md3Divider.Middle`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `variant` | `int` | `Md3Divider.Full` | read/write | `Md3Divider` | — |
| `inset` | `real` | `16` | read/write | `Md3Divider` | — |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3Divider {
    variant: Md3Divider.Full
    inset: 16
}
```
