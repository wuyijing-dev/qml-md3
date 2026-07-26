# Md3Checkbox

- **Source:** `src/Md3/components/Md3Checkbox.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `checked` | `bool` | `false` | read/write | `Md3Checkbox` | — |
| `tristate` | `bool` | `false` | read/write | `Md3Checkbox` | — |
| `checkState` | `var` | `checked ? Qt.Checked : Qt.Unchecked // Qt.PartiallyChecked` | read/write | `Md3Checkbox` | — |
| `enabled` | `bool` | `true` | read/write | `Md3Checkbox` | — |
| `accessibleName` | `string` | `"Checkbox"` | read/write | `Md3Checkbox` | — |
| `isChecked` | `bool` | `checkState === Qt.Checked` | readonly | `Md3Checkbox` | — |
| `isPartial` | `bool` | `checkState === Qt.PartiallyChecked` | readonly | `Md3Checkbox` | — |
| `selected` | `bool` | `isChecked \|\| isPartial` | readonly | `Md3Checkbox` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `toggled(var state)` | `Md3Checkbox` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `cycle()` | `Md3Checkbox` | — |

## Example

```qml
import Md3

Md3Checkbox {
    checked: false
    tristate: false
    checkState: checked ? Qt.Checked : Qt.Unchecked // Qt.PartiallyChecked
    accessibleName: "Checkbox"
}
```
