# Md3DateRangePicker

Material 3 date range picker — shared chrome with Md3DatePicker (calendar/input/year/min-max).

- **Source:** `src/Md3/components/Md3DateRangePicker.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 23 | 3 | 20 | 1 |

_Also inherits Qt Quick `Item` members (not listed)._

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
| `title` | `string` | `qsTr("Select dates")` | read/write | `Md3DateRangePicker` | Title text. |
| `startDate` | `date` | `new Date()` | read/write | `Md3DateRangePicker` | Start Date. |
| `endDate` | `date` | `new Date()` | read/write | `Md3DateRangePicker` | End Date. |
| `viewDate` | `date` | `startDate` | read/write | `Md3DateRangePicker` | View Date. |
| `minimumDate` | `date` | `—` | read/write | `Md3DateRangePicker` | Minimum Date. |
| `maximumDate` | `date` | `—` | read/write | `Md3DateRangePicker` | Maximum Date. |
| `weekStartsOn` | `int` | `{…}` | read/write | `Md3DateRangePicker` | Week Starts On. |
| `displayMode` | `int (Md3DateRangePicker.DisplayMode)` | `Md3DateRangePicker.Calendar` | read/write | `Md3DateRangePicker` | Display Mode. |
| `showModeToggle` | `bool` | `true` | read/write | `Md3DateRangePicker` | Show Mode Toggle. |
| `showTodayIndicator` | `bool` | `true` | read/write | `Md3DateRangePicker` | Show Today Indicator. |
| `showOutsideDays` | `bool` | `true` | read/write | `Md3DateRangePicker` | Show Outside Days. |
| `showActions` | `bool` | `true` | read/write | `Md3DateRangePicker` | Show Actions. |
| `yearPickerOpen` | `bool` | `false` | read/write | `Md3DateRangePicker` | Year Picker Open. |
| `selectingStart` | `bool` | `true` | read/write | `Md3DateRangePicker` | Selecting Start. |
| `yearFrom` | `int` | `1900` | read/write | `Md3DateRangePicker` | Year From. |
| `yearTo` | `int` | `2100` | read/write | `Md3DateRangePicker` | Year To. |
| `confirmText` | `string` | `qsTr("OK")` | read/write | `Md3DateRangePicker` | Confirm Text. |
| `dismissText` | `string` | `qsTr("Cancel")` | read/write | `Md3DateRangePicker` | Dismiss Text. |
| `dateFormat` | `string` | `"yyyy-MM-dd"` | read/write | `Md3DateRangePicker` | Date Format. |
| `modal` | `bool` | `false` | read/write | `Md3DateRangePicker` | Modal. |
| `open` | `bool` | `true` | read/write | `Md3DateRangePicker` | Open the overlay / dialog. |
| `unloadWhenPageInactive` | `bool` | `true` | read/write | `Md3DateRangePicker` | Drop day/year cells while modal closed or page off-display. |
| `today` | `date` | `{…}` | readonly | `Md3DateRangePicker` | Today. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `accepted(date start, date end)` | `Md3DateRangePicker` | Emitted when accepted. |
| `cancelled()` | `Md3DateRangePicker` | Emitted when cancelled. |
| `rangeChanged(date start, date end)` | `Md3DateRangePicker` | Emitted when range Changed. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `daysInMonth(year, month)` | `—` | `Md3DateRangePicker` | Days In Month. |
| `stripTime(d)` | `—` | `Md3DateRangePicker` | Strip Time. |
| `dayTime(d)` | `—` | `Md3DateRangePicker` | Day Time. |
| `sameDay(a, b)` | `—` | `Md3DateRangePicker` | Same Day. |
| `hasMin()` | `—` | `Md3DateRangePicker` | Has Min. |
| `hasMax()` | `—` | `Md3DateRangePicker` | Has Max. |
| `isDateEnabled(d)` | `—` | `Md3DateRangePicker` | Is Date Enabled. |
| `inRange(d)` | `—` | `Md3DateRangePicker` | In Range. |
| `isEndpoint(d)` | `—` | `Md3DateRangePicker` | Is Endpoint. |
| `weekdayLabels()` | `—` | `Md3DateRangePicker` | Weekday Labels. |
| `calendarCells()` | `—` | `Md3DateRangePicker` | Calendar Cells. |
| `shiftMonth(delta)` | `—` | `Md3DateRangePicker` | Shift Month. |
| `pickDay(d)` | `—` | `Md3DateRangePicker` | Pick Day. |
| `syncInputs()` | `—` | `Md3DateRangePicker` | Sync Inputs. |
| `parseField(text)` | `—` | `Md3DateRangePicker` | Parse Field. |
| `commitInputs()` | `—` | `Md3DateRangePicker` | Commit Inputs. |
| `confirm()` | `—` | `Md3DateRangePicker` | Confirm. |
| `cancel()` | `—` | `Md3DateRangePicker` | Cancel. |
| `toggleDisplayMode()` | `—` | `Md3DateRangePicker` | Toggle Display Mode. |
| `pickYear(y)` | `—` | `Md3DateRangePicker` | Pick Year. |

## Example

```qml
import Md3

Md3DateRangePicker {
    title: qsTr("Select dates")
    startDate: new Date()
    endDate: new Date()
    viewDate: startDate
    minimumDate: /* … */
    maximumDate: /* … */
}
```
