# Md3DatePicker

Material 3 date picker — calendar / input, year grid, min/max, today, week start. Inline by default. Set `modal: true` and `open` with anchors.fill on a host for dialog overlay.

- **Source:** `src/Md3/components/Md3DatePicker.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Enums

### `Md3DatePicker.DisplayMode`

`Md3DatePicker.Calendar`, `Md3DatePicker.Input`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `title` | `string` | `qsTr("Select date")` | read/write | `Md3DatePicker` | — |
| `selectedDate` | `date` | `new Date()` | read/write | `Md3DatePicker` | — |
| `viewDate` | `date` | `selectedDate` | read/write | `Md3DatePicker` | — |
| `minimumDate` | `date` | `—` | read/write | `Md3DatePicker` | — |
| `maximumDate` | `date` | `—` | read/write | `Md3DatePicker` | — |
| `weekStartsOn` | `int` | `{…}` | read/write | `Md3DatePicker` | 0 = Sunday … 6 = Saturday |
| `displayMode` | `int` | `Md3DatePicker.Calendar` | read/write | `Md3DatePicker` | — |
| `showModeToggle` | `bool` | `true` | read/write | `Md3DatePicker` | — |
| `showTodayIndicator` | `bool` | `true` | read/write | `Md3DatePicker` | — |
| `showOutsideDays` | `bool` | `true` | read/write | `Md3DatePicker` | — |
| `showActions` | `bool` | `true` | read/write | `Md3DatePicker` | — |
| `yearPickerOpen` | `bool` | `false` | read/write | `Md3DatePicker` | — |
| `yearFrom` | `int` | `1900` | read/write | `Md3DatePicker` | — |
| `yearTo` | `int` | `2100` | read/write | `Md3DatePicker` | — |
| `confirmText` | `string` | `qsTr("OK")` | read/write | `Md3DatePicker` | — |
| `dismissText` | `string` | `qsTr("Cancel")` | read/write | `Md3DatePicker` | — |
| `dateFormat` | `string` | `"yyyy-MM-dd"` | read/write | `Md3DatePicker` | — |
| `modal` | `bool` | `false` | read/write | `Md3DatePicker` | — |
| `open` | `bool` | `true` | read/write | `Md3DatePicker` | — |
| `unloadWhenPageInactive` | `bool` | `true` | read/write | `Md3DatePicker` | Drop day/year cells while modal closed or page off-display. |
| `today` | `date` | `{…}` | readonly | `Md3DatePicker` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `accepted(date date)` | `Md3DatePicker` | — |
| `cancelled()` | `Md3DatePicker` | — |
| `dateClicked(date date)` | `Md3DatePicker` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `daysInMonth(year, month)` | `Md3DatePicker` | — |
| `stripTime(d)` | `Md3DatePicker` | — |
| `sameDay(a, b)` | `Md3DatePicker` | — |
| `hasMin()` | `Md3DatePicker` | — |
| `hasMax()` | `Md3DatePicker` | — |
| `isDateEnabled(d)` | `Md3DatePicker` | — |
| `clampToBounds(d)` | `Md3DatePicker` | — |
| `weekdayLabels()` | `Md3DatePicker` | — |
| `calendarCells()` | `Md3DatePicker` | — |
| `shiftMonth(delta)` | `Md3DatePicker` | — |
| `selectDate(d)` | `Md3DatePicker` | — |
| `commitInput()` | `Md3DatePicker` | — |
| `confirm()` | `Md3DatePicker` | — |
| `cancel()` | `Md3DatePicker` | — |
| `toggleDisplayMode()` | `Md3DatePicker` | — |
| `pickYear(y)` | `Md3DatePicker` | — |

## Example

```qml
import Md3

Md3DatePicker {
    title: qsTr("Select date")
    selectedDate: new Date()
    viewDate: selectedDate
    minimumDate: /* … */
    maximumDate: /* … */
}
```
