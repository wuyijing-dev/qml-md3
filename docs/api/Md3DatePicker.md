# Md3DatePicker

- **Source:** `src/Md3/components/Md3DatePicker.qml`
- **Extends:** `Rectangle`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `selectedDate` | `date` | `new Date()` | read/write | `Md3DatePicker` | — |
| `viewDate` | `date` | `selectedDate` | read/write | `Md3DatePicker` | — |
| `modal` | `bool` | `false` | read/write | `Md3DatePicker` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `accepted(date date)` | `Md3DatePicker` | — |
| `cancelled()` | `Md3DatePicker` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `daysInMonth(year, month)` | `Md3DatePicker` | — |
| `sameDay(a, b)` | `Md3DatePicker` | — |

## Example

```qml
import Md3

Md3DatePicker {
    selectedDate: new Date()
    viewDate: selectedDate
    modal: false
}
```
