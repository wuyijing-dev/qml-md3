# Md3Shadow

- **Source:** `src/Md3/primitives/Md3Shadow.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `elevation` | `real` | `0` | read/write | `Md3Shadow` | — |
| `cornerRadius` | `real` | `0` | read/write | `Md3Shadow` | — |
| `shadowColor` | `color` | `Md3Theme.colorScheme.shadow` | read/write | `Md3Shadow` | — |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3Shadow {
    elevation: 0
    cornerRadius: 0
    shadowColor: Md3Theme.colorScheme.shadow
}
```
