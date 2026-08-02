# Md3DatePicker

Material 3 date picker — calendar / input, year grid, min/max, today, week start. Inline by default. Set `modal: true` and `open` with anchors.fill on a host for dialog overlay.

- **Source:** `src/Md3/components/Md3DatePicker.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 21 | 3 | 16 | 1 |

_Also inherits Qt Quick `Item` members (not listed)._

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
| `title` | `string` | `qsTr("Select date")` | read/write | `Md3DatePicker` | Title text. |
| `selectedDate` | `date` | `new Date()` | read/write | `Md3DatePicker` | Selected Date. |
| `viewDate` | `date` | `selectedDate` | read/write | `Md3DatePicker` | View Date. |
| `minimumDate` | `date` | `—` | read/write | `Md3DatePicker` | Minimum Date. |
| `maximumDate` | `date` | `—` | read/write | `Md3DatePicker` | Maximum Date. |
| `weekStartsOn` | `int` | `{…}` | read/write | `Md3DatePicker` | 0 = Sunday … 6 = Saturday |
| `displayMode` | `int (Md3DatePicker.DisplayMode)` | `Md3DatePicker.Calendar` | read/write | `Md3DatePicker` | Display Mode. |
| `showModeToggle` | `bool` | `true` | read/write | `Md3DatePicker` | Show Mode Toggle. |
| `showTodayIndicator` | `bool` | `true` | read/write | `Md3DatePicker` | Show Today Indicator. |
| `showOutsideDays` | `bool` | `true` | read/write | `Md3DatePicker` | Show Outside Days. |
| `showActions` | `bool` | `true` | read/write | `Md3DatePicker` | Show Actions. |
| `yearPickerOpen` | `bool` | `false` | read/write | `Md3DatePicker` | Year Picker Open. |
| `yearFrom` | `int` | `1900` | read/write | `Md3DatePicker` | Year From. |
| `yearTo` | `int` | `2100` | read/write | `Md3DatePicker` | Year To. |
| `confirmText` | `string` | `qsTr("OK")` | read/write | `Md3DatePicker` | Confirm Text. |
| `dismissText` | `string` | `qsTr("Cancel")` | read/write | `Md3DatePicker` | Dismiss Text. |
| `dateFormat` | `string` | `"yyyy-MM-dd"` | read/write | `Md3DatePicker` | Date Format. |
| `modal` | `bool` | `false` | read/write | `Md3DatePicker` | Modal. |
| `open` | `bool` | `true` | read/write | `Md3DatePicker` | Open the overlay / dialog. |
| `unloadWhenPageInactive` | `bool` | `true` | read/write | `Md3DatePicker` | Drop day/year cells while modal closed or page off-display. |
| `today` | `date` | `{…}` | readonly | `Md3DatePicker` | Today. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `accepted(date date)` | `Md3DatePicker` | Emitted when accepted. |
| `cancelled()` | `Md3DatePicker` | Emitted when cancelled. |
| `dateClicked(date date)` | `Md3DatePicker` | Emitted when date Clicked. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `daysInMonth(year, month)` | `—` | `Md3DatePicker` | Days In Month. |
| `stripTime(d)` | `—` | `Md3DatePicker` | Strip Time. |
| `sameDay(a, b)` | `—` | `Md3DatePicker` | Same Day. |
| `hasMin()` | `—` | `Md3DatePicker` | Has Min. |
| `hasMax()` | `—` | `Md3DatePicker` | Has Max. |
| `isDateEnabled(d)` | `—` | `Md3DatePicker` | Is Date Enabled. |
| `clampToBounds(d)` | `—` | `Md3DatePicker` | Clamp To Bounds. |
| `weekdayLabels()` | `—` | `Md3DatePicker` | Weekday Labels. |
| `calendarCells()` | `—` | `Md3DatePicker` | Calendar Cells. |
| `shiftMonth(delta)` | `—` | `Md3DatePicker` | Shift Month. |
| `selectDate(d)` | `—` | `Md3DatePicker` | Select Date. |
| `commitInput()` | `—` | `Md3DatePicker` | Commit Input. |
| `confirm()` | `—` | `Md3DatePicker` | Confirm. |
| `cancel()` | `—` | `Md3DatePicker` | Cancel. |
| `toggleDisplayMode()` | `—` | `Md3DatePicker` | Toggle Display Mode. |
| `pickYear(y)` | `—` | `Md3DatePicker` | Pick Year. |

## Example

```qml
import Md3

Md3DatePicker {
    title: qsTr("Select date")
    selectedDate: new Date()
    viewDate: selectedDate
    minimumDate: /* … */
    maximumDate: /* … */
    weekStartsOn: /* … */
}
```
