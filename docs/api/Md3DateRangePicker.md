# Md3DateRangePicker

Dual-bound date range calendar (start → end). Same chrome as Md3DatePicker.

- **Source:** `src/Md3/components/Md3DateRangePicker.qml`
- **Extends:** `Rectangle`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `startDate` | `date` | `new Date()` | read/write | `Md3DateRangePicker` | — |
| `endDate` | `date` | `new Date()` | read/write | `Md3DateRangePicker` | — |
| `viewDate` | `date` | `startDate` | read/write | `Md3DateRangePicker` | — |
| `selectingStart` | `bool` | `true` | read/write | `Md3DateRangePicker` | Internal: true while choosing the start bound. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `accepted(date start, date end)` | `Md3DateRangePicker` | — |
| `cancelled()` | `Md3DateRangePicker` | — |
| `rangeChanged(date start, date end)` | `Md3DateRangePicker` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `daysInMonth(year, month)` | `Md3DateRangePicker` | — |
| `sameDay(a, b)` | `Md3DateRangePicker` | — |
| `dayTime(d)` | `Md3DateRangePicker` | — |
| `inRange(d)` | `Md3DateRangePicker` | — |
| `isEndpoint(d)` | `Md3DateRangePicker` | — |
| `pickDay(day)` | `Md3DateRangePicker` | — |

## Example

```qml
import Md3

Md3DateRangePicker {
    startDate: new Date()
    endDate: new Date()
    viewDate: startDate
    selectingStart: true
}
```
