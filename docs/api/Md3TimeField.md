# Md3TimeField

Docked MD3 time field: text field + time picker popup (peer of Md3DateField).

- **Source:** `src/Md3/components/Md3TimeField.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `label` | `alias` | `field.label` | read/write | `Md3TimeField` | Alias → `field.label` |
| `supportingText` | `alias` | `field.supportingText` | read/write | `Md3TimeField` | Alias → `field.supportingText` |
| `errorText` | `alias` | `field.errorText` | read/write | `Md3TimeField` | Alias → `field.errorText` |
| `error` | `alias` | `field.error` | read/write | `Md3TimeField` | Alias → `field.error` |
| `placeholderText` | `alias` | `field.placeholderText` | read/write | `Md3TimeField` | Alias → `field.placeholderText` |
| `hour` | `int` | `10` | read/write | `Md3TimeField` | 0–23 |
| `minute` | `int` | `0` | read/write | `Md3TimeField` | 0–59 |
| `use24Hour` | `bool` | `false` | read/write | `Md3TimeField` | — |
| `controlEnabled` | `bool` | `true` | read/write | `Md3TimeField` | — |
| `accessibleName` | `string` | `""` | read/write | `Md3TimeField` | — |
| `name` | `string` | `""` | read/write | `Md3TimeField` | — |
| `overlayWindow` | `var` | `null` | read/write | `Md3TimeField` | Optional explicit Window for overlay reparent (else Window.window). |
| `pickerOpen` | `bool` | `host.visible` | readonly | `Md3TimeField` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `accepted(int hour, int minute)` | `Md3TimeField` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `formatTime(h, m)` | `Md3TimeField` | — |
| `openPicker()` | `Md3TimeField` | — |
| `closePicker()` | `Md3TimeField` | — |
| `hostEnsureParent()` | `Md3TimeField` | — |
| `applyTime(h, m)` | `Md3TimeField` | — |
| `syncField()` | `Md3TimeField` | — |

## Example

```qml
import Md3

Md3TimeField {
    hour: 10
    minute: 0
    use24Hour: false
    controlEnabled: true
    accessibleName: ""
}
```
