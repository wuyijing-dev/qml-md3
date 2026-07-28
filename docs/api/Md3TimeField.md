# Md3TimeField

Docked MD3 time field: text field + time picker popup (peer of [Md3DateField](Md3DateField.md)).

- **Source:** `src/Md3/components/Md3TimeField.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `label` / `supportingText` / `errorText` / `error` / `placeholderText` | alias | — | Forwarded to inner `Md3TextField` |
| `hour` | int | `10` | 0–23 |
| `minute` | int | `0` | 0–59 |
| `use24Hour` | bool | `false` | Display / parse 24h |
| `controlEnabled` | bool | `true` | — |
| `name` | string | `""` | Form field key |
| `accessibleName` | string | `""` | — |
| `pickerOpen` | bool | — | readonly |

## Signals

`accepted(int hour, int minute)`

## Methods

`openPicker()`, `closePicker()`, `applyTime(h, m)`

## Example

```qml
Md3TimeField {
    label: qsTr("Start time")
    hour: 10
    minute: 30
    onAccepted: (h, m) => console.log(h, m)
}
```
