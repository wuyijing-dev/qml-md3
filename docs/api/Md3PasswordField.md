# Md3PasswordField

Password field with visibility toggle (via Md3TextField) and optional strength meter.

- **Source:** `src/Md3/components/Md3PasswordField.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 15 | 2 | 0 | 1 |

_Also inherits Qt Quick `Item` members (not listed)._

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
| `variant` | `int (Md3PasswordField.Variant)` | `Md3PasswordField.Filled` | read/write | `Md3PasswordField` | Visual / role variant (see Enums). |
| `text` | `alias` | `field.text` | read/write | `Md3PasswordField` | Primary label text. |
| `label` | `string` | `qsTr("Password")` | read/write | `Md3PasswordField` | Field / control label. |
| `placeholderText` | `string` | `""` | read/write | `Md3PasswordField` | Placeholder when empty. |
| `supportingText` | `string` | `""` | read/write | `Md3PasswordField` | Supporting Text. |
| `errorText` | `string` | `""` | read/write | `Md3PasswordField` | Validation error string (empty = ok). |
| `error` | `bool` | `false` | read/write | `Md3PasswordField` | Error. |
| `name` | `string` | `""` | read/write | `Md3PasswordField` | Form field key / identity. |
| `showStrength` | `bool` | `true` | read/write | `Md3PasswordField` | Show Strength. |
| `minLength` | `int` | `8` | read/write | `Md3PasswordField` | Min Length. |
| `passwordVisible` | `alias` | `field.passwordVisible` | read/write | `Md3PasswordField` | Password Visible. |
| `accessibleName` | `string` | `""` | read/write | `Md3PasswordField` | Accessible name override. |
| `strength` | `int` | `_score(text)` | readonly | `Md3PasswordField` | Strength. |
| `strengthLabel` | `string` | `{…}` | readonly | `Md3PasswordField` | Strength Label. |
| `strengthColor` | `color` | `{…}` | readonly | `Md3PasswordField` | Strength Color. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `accepted()` | `Md3PasswordField` | Emitted when accepted. |
| `strengthChangedByUser(int score)` | `Md3PasswordField` | Emitted when strength Changed By User. |

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
    error: false
}
```
