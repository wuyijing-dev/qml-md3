# Md3PasswordField

Password field with visibility toggle (via Md3TextField) and optional strength meter.

- **Source:** `src/Md3/components/Md3PasswordField.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Enums

### `Md3PasswordField.Variant`

`Md3PasswordField.Filled`, `Md3PasswordField.Outlined`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `variant` | `int` | `Md3PasswordField.Filled` | read/write | `Md3PasswordField` | — |
| `text` | `alias` | `field.text` | read/write | `Md3PasswordField` | Alias → `field.text` |
| `label` | `string` | `qsTr("Password")` | read/write | `Md3PasswordField` | — |
| `placeholderText` | `string` | `""` | read/write | `Md3PasswordField` | — |
| `supportingText` | `string` | `""` | read/write | `Md3PasswordField` | — |
| `errorText` | `string` | `""` | read/write | `Md3PasswordField` | — |
| `error` | `bool` | `false` | read/write | `Md3PasswordField` | — |
| `name` | `string` | `""` | read/write | `Md3PasswordField` | — |
| `showStrength` | `bool` | `true` | read/write | `Md3PasswordField` | — |
| `minLength` | `int` | `8` | read/write | `Md3PasswordField` | — |
| `passwordVisible` | `alias` | `field.passwordVisible` | read/write | `Md3PasswordField` | Alias → `field.passwordVisible` |
| `accessibleName` | `string` | `""` | read/write | `Md3PasswordField` | — |
| `strength` | `int` | `_score(text)` | readonly | `Md3PasswordField` | — |
| `strengthLabel` | `string` | `{…}` | readonly | `Md3PasswordField` | — |
| `strengthColor` | `color` | `{…}` | readonly | `Md3PasswordField` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `accepted()` | `Md3PasswordField` | — |
| `strengthChangedByUser(int score)` | `Md3PasswordField` | — |

## Methods

_None._

## Example

```qml
import Md3

Md3PasswordField {
    variant: Md3PasswordField.Filled
    label: qsTr("Password")
    placeholderText: ""
    supportingText: ""
    errorText: ""
}
```
