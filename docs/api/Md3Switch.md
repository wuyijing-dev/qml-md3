# Md3Switch

- **Source:** `src/Md3/components/Md3Switch.qml`

## Properties

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `checked` | bool | `false` | — |
| `showIcon` | bool | `false` | Check/close glyph in thumb |
| `text` | string | `""` | Visible label (no Row+Text glue) |
| `accessibleName` | string | `text` or `"Switch"` | — |
| `labelSpacing` | real | `12` | Gap between chrome and label |

Uses `Item.enabled` (do not redeclare).

## Signals / methods

`toggled(bool checked)`, `toggle()`

## Example

```qml
Md3Switch {
    text: qsTr("Dark theme")
    checked: true
}
```
