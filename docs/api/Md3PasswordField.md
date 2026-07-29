# Md3PasswordField

- **Source:** `src/Md3/components/Md3PasswordField.qml`
- **Extends:** `Item`

Password TextField with visibility toggle and optional strength meter.

## Properties

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `text` | `alias` | | Bound to inner field |
| `showStrength` | `bool` | `true` | Strength bars + label |
| `minLength` | `int` | `8` | Scoring threshold |
| `strength` | `int` | readonly | 0–4 |
| `passwordVisible` | `alias` | | Visibility toggle |

## Example

```qml
Md3PasswordField { label: qsTr("Password"); showStrength: true }
```
