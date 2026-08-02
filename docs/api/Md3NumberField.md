# Md3NumberField

Numeric spin field: TextField chrome + step buttons (form-friendly SpinBox).

- **Source:** `src/Md3/components/Md3NumberField.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 19 | 1 | 5 | 1 |

_Also inherits Qt Quick `Item` members (not listed)._

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
| `variant` | `int (Md3NumberField.Variant)` | `Md3NumberField.Outlined` | read/write | `Md3NumberField` | Visual / role variant (see Enums). |
| `value` | `real` | `0` | read/write | `Md3NumberField` | Current value. |
| `from` | `real` | `0` | read/write | `Md3NumberField` | Range lower bound. |
| `to` | `real` | `100` | read/write | `Md3NumberField` | Range upper bound. |
| `stepSize` | `real` | `1` | read/write | `Md3NumberField` | Step Size. |
| `decimals` | `int` | `0` | read/write | `Md3NumberField` | Decimals. |
| `label` | `string` | `""` | read/write | `Md3NumberField` | Field / control label. |
| `supportingText` | `string` | `""` | read/write | `Md3NumberField` | Supporting Text. |
| `errorText` | `string` | `""` | read/write | `Md3NumberField` | Validation error string (empty = ok). |
| `error` | `bool` | `false` | read/write | `Md3NumberField` | Error. |
| `name` | `string` | `""` | read/write | `Md3NumberField` | Form field key for Md3Form.validate / error auto-wiring. |
| `prefix` | `string` | `""` | read/write | `Md3NumberField` | Prefix. |
| `suffix` | `string` | `""` | read/write | `Md3NumberField` | Suffix. |
| `accessibleName` | `string` | `""` | read/write | `Md3NumberField` | Accessible name override. |
| `hasError` | `bool` | `error \|\| errorText.length > 0` | readonly | `Md3NumberField` | Has Error. |
| `helper` | `string` | `hasError ? (errorText.length ? errorText : supportingText) : supportingText` | readonly | `Md3NumberField` | Helper. |
| `activeColor` | `color` | `hasError ? Md3Theme.colorScheme.error` | readonly | `Md3NumberField` | Active Color. |
| `atMin` | `bool` | `value <= from + 1e-9` | readonly | `Md3NumberField` | At Min. |
| `atMax` | `bool` | `value >= to - 1e-9` | readonly | `Md3NumberField` | At Max. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `valueModified(real value)` | `Md3NumberField` | Emitted when value Modified. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `formatValue(v)` | `—` | `Md3NumberField` | Format Value. |
| `clamp(v)` | `—` | `Md3NumberField` | Clamp. |
| `setValue(v, emitSignal)` | `—` | `Md3NumberField` | Set Value. |
| `stepBy(dir)` | `—` | `Md3NumberField` | Step By. |
| `commitText()` | `—` | `Md3NumberField` | Commit Text. |

## Example

```qml
import Md3

Md3NumberField {
    variant: Md3NumberField.Outlined
    value: 0
    from: 0
    to: 100
    stepSize: 1
    decimals: 0
}
```
