# Md3Checkbox

- **Source:** `src/Md3/components/Md3Checkbox.qml`

## Properties

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `checked` | bool | `false` | — |
| `tristate` | bool | `false` | Allow partial |
| `checkState` | var | Unchecked/Checked | Qt check state |
| `text` | string | `""` | Visible label |
| `accessibleName` | string | `text` or `"Checkbox"` | — |
| `labelSpacing` | real | `12` | — |

## Signals / methods

`toggled(var state)`, `cycle()`

## Example

```qml
Md3Checkbox { text: qsTr("Remember me"); checked: true }
```
