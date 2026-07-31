# Md3NumberField

Numeric spin field: TextField chrome + step buttons (form-friendly SpinBox).

- **Source:** `src/Md3/components/Md3NumberField.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Enums

### `Md3NumberField.Variant`

`Md3NumberField.Filled`, `Md3NumberField.Outlined`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `variant` | `int` | `Md3NumberField.Outlined` | read/write | `Md3NumberField` | — |
| `value` | `real` | `0` | read/write | `Md3NumberField` | — |
| `from` | `real` | `0` | read/write | `Md3NumberField` | — |
| `to` | `real` | `100` | read/write | `Md3NumberField` | — |
| `stepSize` | `real` | `1` | read/write | `Md3NumberField` | — |
| `decimals` | `int` | `0` | read/write | `Md3NumberField` | — |
| `label` | `string` | `""` | read/write | `Md3NumberField` | — |
| `supportingText` | `string` | `""` | read/write | `Md3NumberField` | — |
| `errorText` | `string` | `""` | read/write | `Md3NumberField` | — |
| `error` | `bool` | `false` | read/write | `Md3NumberField` | — |
| `name` | `string` | `""` | read/write | `Md3NumberField` | Form field key for Md3Form.validate / error auto-wiring. |
| `prefix` | `string` | `""` | read/write | `Md3NumberField` | — |
| `suffix` | `string` | `""` | read/write | `Md3NumberField` | — |
| `accessibleName` | `string` | `""` | read/write | `Md3NumberField` | — |
| `hasError` | `bool` | `error \|\| errorText.length > 0` | readonly | `Md3NumberField` | — |
| `helper` | `string` | `hasError ? (errorText.length ? errorText : supportingText) : supportingText` | readonly | `Md3NumberField` | — |
| `activeColor` | `color` | `hasError ? Md3Theme.colorScheme.error` | readonly | `Md3NumberField` | — |
| `atMin` | `bool` | `value <= from + 1e-9` | readonly | `Md3NumberField` | — |
| `atMax` | `bool` | `value >= to - 1e-9` | readonly | `Md3NumberField` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `valueModified(real value)` | `Md3NumberField` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `formatValue(v)` | `Md3NumberField` | — |
| `clamp(v)` | `Md3NumberField` | — |
| `setValue(v, emitSignal)` | `Md3NumberField` | — |
| `stepBy(dir)` | `Md3NumberField` | — |
| `commitText()` | `Md3NumberField` | — |

## Example

```qml
import Md3

Md3NumberField {
    variant: Md3NumberField.Outlined
    value: 0
    from: 0
    to: 100
    stepSize: 1
}
```
