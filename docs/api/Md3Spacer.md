# Md3Spacer

- **Source:** `src/Md3/layout/Md3Spacer.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `spacerWidth` | `real` | `0` | read/write | `Md3Spacer` | Implicit width |
| `spacerHeight` | `real` | `0` | read/write | `Md3Spacer` | Implicit height |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3HStack {
    Md3Button { text: "Left" }
    Md3Spacer { spacerWidth: 24 }
    Md3Button { text: "Right" }
}
```
