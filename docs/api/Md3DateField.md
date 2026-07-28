# Md3DateField

Docked MD3 date field: text field + calendar popup (Material docked date picker).

- **Source:** `src/Md3/components/Md3DateField.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `label` | `alias` | `field.label` | read/write | `Md3DateField` | Alias → `field.label` |
| `supportingText` | `alias` | `field.supportingText` | read/write | `Md3DateField` | Alias → `field.supportingText` |
| `errorText` | `alias` | `field.errorText` | read/write | `Md3DateField` | Alias → `field.errorText` |
| `error` | `alias` | `field.error` | read/write | `Md3DateField` | Alias → `field.error` |
| `placeholderText` | `alias` | `field.placeholderText` | read/write | `Md3DateField` | Alias → `field.placeholderText` |
| `selectedDate` | `date` | `new Date()` | read/write | `Md3DateField` | — |
| `minimumDate` | `date` | `—` | read/write | `Md3DateField` | — |
| `maximumDate` | `date` | `—` | read/write | `Md3DateField` | — |
| `dateFormat` | `string` | `"yyyy-MM-dd"` | read/write | `Md3DateField` | — |
| `weekStartsOn` | `int` | `-1` | read/write | `Md3DateField` | — |
| `controlEnabled` | `bool` | `true` | read/write | `Md3DateField` | — |
| `accessibleName` | `string` | `""` | read/write | `Md3DateField` | — |
| `pickerOpen` | `bool` | `host.visible` | readonly | `Md3DateField` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `accepted(date date)` | `Md3DateField` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `openPicker()` | `Md3DateField` | — |
| `closePicker()` | `Md3DateField` | — |
| `hostEnsureParent()` | `Md3DateField` | — |
| `applyDate(d)` | `Md3DateField` | — |

## Example

```qml
import Md3

Md3DateField {
    selectedDate: new Date()
    minimumDate: /* … */
    maximumDate: /* … */
    dateFormat: "yyyy-MM-dd"
    weekStartsOn: -1
}
```
