# Md3Radio

- **Source:** `src/Md3/components/Md3Radio.qml`

## Properties

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `checked` | bool | `false` | — |
| `group` | var | `null` | Shared object with `selectedValue` |
| `value` | var | `null` | Value written to group |
| `text` | string | `""` | Visible label |
| `accessibleName` | string | `text` or `"Radio"` | — |
| `labelSpacing` | real | `12` | — |

## Signals / methods

`clicked()`, `select()`

## Example

```qml
QtObject { id: g; property var selectedValue: "a" }
Md3Radio { text: qsTr("A"); value: "a"; group: g; checked: true }
Md3Radio { text: qsTr("B"); value: "b"; group: g }
```
