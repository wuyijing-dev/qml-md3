# Md3Stepper

- **Source:** `src/Md3/components/Md3Stepper.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `model` | `var` | `[]` | read/write | `Md3Stepper` | — |
| `currentStep` | `int` | `0` | read/write | `Md3Stepper` | — |
| `vertical` | `bool` | `false` | read/write | `Md3Stepper` | — |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3Stepper {
    model: []
    currentStep: 0
    vertical: false
}
```
