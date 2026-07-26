# Md3FocusRing

- **Source:** `src/Md3/primitives/Md3FocusRing.qml`
- **Extends:** `Rectangle`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `focused` | `bool` | `false` | read/write | `Md3FocusRing` | — |
| `controlEnabled` | `bool` | `true` | read/write | `Md3FocusRing` | — |
| `visualFocus` | `bool` | `false` | read/write | `Md3FocusRing` | — |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3FocusRing {
    focused: false
    controlEnabled: true
    visualFocus: false
}
```
