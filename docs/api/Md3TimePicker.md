# Md3TimePicker

Material 3 time picker — dial / keyboard input, hour↔minute, AM/PM, 12h/24h, modal.

- **Source:** `src/Md3/components/Md3TimePicker.qml`
- **Extends:** `Item`

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
| `title` | `string` | `qsTr("Select time")` | read/write | `Md3TimePicker` | — |
| `hour` | `int` | `10` | read/write | `Md3TimePicker` | 0–23 always stored in 24h |
| `minute` | `int` | `0` | read/write | `Md3TimePicker` | — |
| `use24Hour` | `bool` | `false` | read/write | `Md3TimePicker` | — |
| `displayMode` | `int` | `Md3TimePicker.Dial` | read/write | `Md3TimePicker` | — |
| `dialSelection` | `int` | `Md3TimePicker.Hour` | read/write | `Md3TimePicker` | — |
| `showModeToggle` | `bool` | `true` | read/write | `Md3TimePicker` | — |
| `showActions` | `bool` | `true` | read/write | `Md3TimePicker` | — |
| `confirmText` | `string` | `qsTr("OK")` | read/write | `Md3TimePicker` | — |
| `dismissText` | `string` | `qsTr("Cancel")` | read/write | `Md3TimePicker` | — |
| `modal` | `bool` | `false` | read/write | `Md3TimePicker` | — |
| `open` | `bool` | `true` | read/write | `Md3TimePicker` | — |
| `minuteStep` | `int` | `1` | read/write | `Md3TimePicker` | — |
| `isPm` | `bool` | `hour >= 12` | readonly | `Md3TimePicker` | — |
| `displayHour12` | `int` | `{…}` | readonly | `Md3TimePicker` | — |
| `displayHour` | `int` | `use24Hour ? hour : displayHour12` | readonly | `Md3TimePicker` | — |
| `dialAngle` | `real` | `{…}` | readonly | `Md3TimePicker` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `accepted(int hour, int minute)` | `Md3TimePicker` | — |
| `cancelled()` | `Md3TimePicker` | — |
| `timeChanged(int hour, int minute)` | `Md3TimePicker` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `setPeriod(pm)` | `Md3TimePicker` | — |
| `applyDialFromPoint(mx, my, dialSize)` | `Md3TimePicker` | — |
| `setHourFrom12(h12)` | `Md3TimePicker` | — |
| `toggleDisplayMode()` | `Md3TimePicker` | — |
| `syncInputs()` | `Md3TimePicker` | — |
| `commitInputs()` | `Md3TimePicker` | — |
| `confirm()` | `Md3TimePicker` | — |
| `cancel()` | `Md3TimePicker` | — |

## Example

```qml
import Md3

Md3TimePicker {
    title: qsTr("Select time")
    hour: 10
    minute: 0
    use24Hour: false
    displayMode: Md3TimePicker.Dial
}
```
