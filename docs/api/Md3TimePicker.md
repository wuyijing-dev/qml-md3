# Md3TimePicker

Material 3 time picker — dial / keyboard input, hour↔minute, AM/PM, 12h/24h, modal.

- **Source:** `src/Md3/components/Md3TimePicker.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 18 | 3 | 8 | 2 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Enums

### `Md3TimePicker.DisplayMode`

`Md3TimePicker.Dial`, `Md3TimePicker.Input`

### `Md3TimePicker.DialSelection`

`Md3TimePicker.Hour`, `Md3TimePicker.Minute`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `title` | `string` | `qsTr("Select time")` | read/write | `Md3TimePicker` | Title text. |
| `hour` | `int` | `10` | read/write | `Md3TimePicker` | 0–23 always stored in 24h |
| `minute` | `int` | `0` | read/write | `Md3TimePicker` | Minute. |
| `use24Hour` | `bool` | `false` | read/write | `Md3TimePicker` | Use24Hour. |
| `displayMode` | `int (Md3TimePicker.DisplayMode)` | `Md3TimePicker.Dial` | read/write | `Md3TimePicker` | Display Mode. |
| `dialSelection` | `int (Md3TimePicker.DialSelection)` | `Md3TimePicker.Hour` | read/write | `Md3TimePicker` | Dial Selection. |
| `showModeToggle` | `bool` | `true` | read/write | `Md3TimePicker` | Show Mode Toggle. |
| `showActions` | `bool` | `true` | read/write | `Md3TimePicker` | Show Actions. |
| `confirmText` | `string` | `qsTr("OK")` | read/write | `Md3TimePicker` | Confirm Text. |
| `dismissText` | `string` | `qsTr("Cancel")` | read/write | `Md3TimePicker` | Dismiss Text. |
| `modal` | `bool` | `false` | read/write | `Md3TimePicker` | Modal. |
| `open` | `bool` | `true` | read/write | `Md3TimePicker` | Open the overlay / dialog. |
| `minuteStep` | `int` | `1` | read/write | `Md3TimePicker` | dial snap; 5 matches classic MD clock ticks |
| `unloadWhenPageInactive` | `bool` | `true` | read/write | `Md3TimePicker` | Drop dial ticks while modal closed or page off-display. |
| `isPm` | `bool` | `hour >= 12` | readonly | `Md3TimePicker` | Is Pm. |
| `displayHour12` | `int` | `{…}` | readonly | `Md3TimePicker` | Display Hour12. |
| `displayHour` | `int` | `use24Hour ? hour : displayHour12` | readonly | `Md3TimePicker` | Display Hour. |
| `dialAngle` | `real` | `{…}` | readonly | `Md3TimePicker` | Dial Angle. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `accepted(int hour, int minute)` | `Md3TimePicker` | Emitted when accepted. |
| `cancelled()` | `Md3TimePicker` | Emitted when cancelled. |
| `timeChanged(int hour, int minute)` | `Md3TimePicker` | Emitted when time Changed. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `setPeriod(pm)` | `—` | `Md3TimePicker` | Set Period. |
| `applyDialFromPoint(mx, my, dialSize)` | `—` | `Md3TimePicker` | Apply Dial From Point. |
| `setHourFrom12(h12)` | `—` | `Md3TimePicker` | Set Hour From12. |
| `toggleDisplayMode()` | `—` | `Md3TimePicker` | Toggle Display Mode. |
| `syncInputs()` | `—` | `Md3TimePicker` | Sync Inputs. |
| `commitInputs()` | `—` | `Md3TimePicker` | Commit Inputs. |
| `confirm()` | `—` | `Md3TimePicker` | Confirm. |
| `cancel()` | `—` | `Md3TimePicker` | Cancel. |

## Example

```qml
import Md3

Md3TimePicker {
    title: qsTr("Select time")
    hour: 10
    minute: 0
    use24Hour: false
    displayMode: Md3TimePicker.Dial
    dialSelection: Md3TimePicker.Hour
}
```
