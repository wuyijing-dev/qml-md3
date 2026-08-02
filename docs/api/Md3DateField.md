# Md3DateField

Docked MD3 date field: text field + calendar popup (Material docked date picker).

- **Source:** `src/Md3/components/Md3DateField.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 14 | 1 | 4 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `label` | `alias` | `field.label` | read/write | `Md3DateField` | Field / control label. |
| `supportingText` | `alias` | `field.supportingText` | read/write | `Md3DateField` | Supporting Text. |
| `errorText` | `alias` | `field.errorText` | read/write | `Md3DateField` | Validation error string (empty = ok). |
| `error` | `alias` | `field.error` | read/write | `Md3DateField` | Error. |
| `placeholderText` | `alias` | `field.placeholderText` | read/write | `Md3DateField` | Placeholder when empty. |
| `selectedDate` | `date` | `new Date()` | read/write | `Md3DateField` | Selected Date. |
| `minimumDate` | `date` | `—` | read/write | `Md3DateField` | Minimum Date. |
| `maximumDate` | `date` | `—` | read/write | `Md3DateField` | Maximum Date. |
| `dateFormat` | `string` | `"yyyy-MM-dd"` | read/write | `Md3DateField` | Date Format. |
| `weekStartsOn` | `int` | `-1` | read/write | `Md3DateField` | Week Starts On. |
| `controlEnabled` | `bool` | `true` | read/write | `Md3DateField` | Control Enabled. |
| `accessibleName` | `string` | `""` | read/write | `Md3DateField` | Accessible name override. |
| `overlayWindow` | `var` | `null` | read/write | `Md3DateField` | Optional explicit Window for overlay reparent (else Window.window). |
| `pickerOpen` | `bool` | `host.visible` | readonly | `Md3DateField` | Picker Open. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `accepted(date date)` | `Md3DateField` | Emitted when accepted. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `openPicker()` | `—` | `Md3DateField` | Open Picker. |
| `closePicker()` | `—` | `Md3DateField` | Close Picker. |
| `hostEnsureParent()` | `—` | `Md3DateField` | Host Ensure Parent. |
| `applyDate(d)` | `—` | `Md3DateField` | Apply Date. |

## Example

```qml
import Md3

Md3DateField {
    selectedDate: new Date()
    minimumDate: /* … */
    maximumDate: /* … */
    dateFormat: "yyyy-MM-dd"
    weekStartsOn: -1
    controlEnabled: true
}
```
