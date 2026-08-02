# Md3TimeField

Docked MD3 time field: text field + time picker popup (peer of Md3DateField).

- **Source:** `src/Md3/components/Md3TimeField.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 13 | 1 | 6 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `label` | `alias` | `field.label` | read/write | `Md3TimeField` | Field / control label. |
| `supportingText` | `alias` | `field.supportingText` | read/write | `Md3TimeField` | Supporting Text. |
| `errorText` | `alias` | `field.errorText` | read/write | `Md3TimeField` | Validation error string (empty = ok). |
| `error` | `alias` | `field.error` | read/write | `Md3TimeField` | Error. |
| `placeholderText` | `alias` | `field.placeholderText` | read/write | `Md3TimeField` | Placeholder when empty. |
| `hour` | `int` | `10` | read/write | `Md3TimeField` | 0–23 |
| `minute` | `int` | `0` | read/write | `Md3TimeField` | 0–59 |
| `use24Hour` | `bool` | `false` | read/write | `Md3TimeField` | Use24Hour. |
| `controlEnabled` | `bool` | `true` | read/write | `Md3TimeField` | Control Enabled. |
| `accessibleName` | `string` | `""` | read/write | `Md3TimeField` | Accessible name override. |
| `name` | `string` | `""` | read/write | `Md3TimeField` | Form field key / identity. |
| `overlayWindow` | `var` | `null` | read/write | `Md3TimeField` | Optional explicit Window for overlay reparent (else Window.window). |
| `pickerOpen` | `bool` | `host.visible` | readonly | `Md3TimeField` | Picker Open. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `accepted(int hour, int minute)` | `Md3TimeField` | Emitted when accepted. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `formatTime(h, m)` | `—` | `Md3TimeField` | Format Time. |
| `openPicker()` | `—` | `Md3TimeField` | Open Picker. |
| `closePicker()` | `—` | `Md3TimeField` | Close Picker. |
| `hostEnsureParent()` | `—` | `Md3TimeField` | Host Ensure Parent. |
| `applyTime(h, m)` | `—` | `Md3TimeField` | Apply Time. |
| `syncField()` | `—` | `Md3TimeField` | Sync Field. |

## Example

```qml
import Md3

Md3TimeField {
    hour: 10
    minute: 0
    use24Hour: false
    controlEnabled: true
    accessibleName: ""
    name: ""
}
```
