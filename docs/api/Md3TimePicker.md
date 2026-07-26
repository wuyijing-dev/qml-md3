# Md3TimePicker

- **Source:** `src/Md3/components/Md3TimePicker.qml`
- **Extends:** `Rectangle`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `hour` | `int` | `10` | read/write | `Md3TimePicker` | — |
| `minute` | `int` | `0` | read/write | `Md3TimePicker` | — |
| `isPm` | `bool` | `false` | read/write | `Md3TimePicker` | — |
| `use24Hour` | `bool` | `false` | read/write | `Md3TimePicker` | — |
| `dialMode` | `bool` | `true` | read/write | `Md3TimePicker` | — |
| `displayHour` | `int` | `use24Hour ? hour : ((hour % 12) === 0 ? 12 : hour % 12)` | readonly | `Md3TimePicker` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `accepted(int hour, int minute)` | `Md3TimePicker` | — |
| `cancelled()` | `Md3TimePicker` | — |

## Methods

_None._

## Example

```qml
import Md3

Md3TimePicker {
    hour: 10
    minute: 0
    isPm: false
    use24Hour: false
    dialMode: true
}
```
