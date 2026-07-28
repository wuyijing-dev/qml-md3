# Md3DateRangePicker

Material 3 date range picker — shared chrome with Md3DatePicker (calendar/input/year/min-max).

- **Source:** `src/Md3/components/Md3DateRangePicker.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Enums

### `Md3DateRangePicker.DisplayMode`

`Md3DateRangePicker.Calendar`, `Md3DateRangePicker.Input`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `title` | `string` | `qsTr("Select dates")` | read/write | `Md3DateRangePicker` | — |
| `startDate` | `date` | `new Date()` | read/write | `Md3DateRangePicker` | — |
| `endDate` | `date` | `new Date()` | read/write | `Md3DateRangePicker` | — |
| `viewDate` | `date` | `startDate` | read/write | `Md3DateRangePicker` | — |
| `minimumDate` | `date` | `—` | read/write | `Md3DateRangePicker` | — |
| `maximumDate` | `date` | `—` | read/write | `Md3DateRangePicker` | — |
| `weekStartsOn` | `int` | `{…}` | read/write | `Md3DateRangePicker` | — |
| `displayMode` | `int` | `Md3DateRangePicker.Calendar` | read/write | `Md3DateRangePicker` | — |
| `showModeToggle` | `bool` | `true` | read/write | `Md3DateRangePicker` | — |
| `showTodayIndicator` | `bool` | `true` | read/write | `Md3DateRangePicker` | — |
| `showOutsideDays` | `bool` | `true` | read/write | `Md3DateRangePicker` | — |
| `showActions` | `bool` | `true` | read/write | `Md3DateRangePicker` | — |
| `yearPickerOpen` | `bool` | `false` | read/write | `Md3DateRangePicker` | — |
| `selectingStart` | `bool` | `true` | read/write | `Md3DateRangePicker` | — |
| `yearFrom` | `int` | `1900` | read/write | `Md3DateRangePicker` | — |
| `yearTo` | `int` | `2100` | read/write | `Md3DateRangePicker` | — |
| `confirmText` | `string` | `qsTr("OK")` | read/write | `Md3DateRangePicker` | — |
| `dismissText` | `string` | `qsTr("Cancel")` | read/write | `Md3DateRangePicker` | — |
| `dateFormat` | `string` | `"yyyy-MM-dd"` | read/write | `Md3DateRangePicker` | — |
| `modal` | `bool` | `false` | read/write | `Md3DateRangePicker` | — |
| `open` | `bool` | `true` | read/write | `Md3DateRangePicker` | — |
| `today` | `date` | `{…}` | readonly | `Md3DateRangePicker` | — |

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
| `stripTime(d)` | `Md3DateRangePicker` | — |
| `dayTime(d)` | `Md3DateRangePicker` | — |
| `sameDay(a, b)` | `Md3DateRangePicker` | — |
| `hasMin()` | `Md3DateRangePicker` | — |
| `hasMax()` | `Md3DateRangePicker` | — |
| `isDateEnabled(d)` | `Md3DateRangePicker` | — |
| `inRange(d)` | `Md3DateRangePicker` | — |
| `isEndpoint(d)` | `Md3DateRangePicker` | — |
| `weekdayLabels()` | `Md3DateRangePicker` | — |
| `calendarCells()` | `Md3DateRangePicker` | — |
| `shiftMonth(delta)` | `Md3DateRangePicker` | — |
| `pickDay(d)` | `Md3DateRangePicker` | — |
| `syncInputs()` | `Md3DateRangePicker` | — |
| `parseField(text)` | `Md3DateRangePicker` | — |
| `commitInputs()` | `Md3DateRangePicker` | — |
| `confirm()` | `Md3DateRangePicker` | — |
| `cancel()` | `Md3DateRangePicker` | — |
| `toggleDisplayMode()` | `Md3DateRangePicker` | — |
| `pickYear(y)` | `Md3DateRangePicker` | — |

## Example

```qml
import Md3

Md3DateRangePicker {
    title: qsTr("Select dates")
    startDate: new Date()
    endDate: new Date()
    viewDate: startDate
    minimumDate: /* … */
}
```
