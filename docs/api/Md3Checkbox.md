# Md3Checkbox

- **Source:** `src/Md3/components/Md3Checkbox.qml`
- **Extends:** `Md3SelectionControl`

## Import

```qml
import Md3
```

## Inheritance

[`Md3Checkbox`](Md3Checkbox.md) → [`Md3SelectionControl`](Md3SelectionControl.md)

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `tristate` | `bool` | `false` | read/write | `Md3Checkbox` | — |
| `checkState` | `var` | `checked ? Qt.Checked : Qt.Unchecked` | read/write | `Md3Checkbox` | — |
| `isChecked` | `bool` | `checkState === Qt.Checked` | readonly | `Md3Checkbox` | — |
| `isPartial` | `bool` | `checkState === Qt.PartiallyChecked` | readonly | `Md3Checkbox` | — |
| `selected` | `bool` | `isChecked \|\| isPartial` | readonly | `Md3Checkbox` | — |
| `checked` | `bool` | `false` | read/write | [`Md3SelectionControl`](Md3SelectionControl.md) | — |
| `text` | `string` | `""` | read/write | [`Md3SelectionControl`](Md3SelectionControl.md) | — |
| `accessibleName` | `string` | `text.length ? text : qsTr("Selection control")` | read/write | [`Md3SelectionControl`](Md3SelectionControl.md) | — |
| `accessibleRole` | `int` | `Accessible.CheckBox` | read/write | [`Md3SelectionControl`](Md3SelectionControl.md) | — |
| `chromeWidth` | `real` | `48` | read/write | [`Md3SelectionControl`](Md3SelectionControl.md) | — |
| `labelSpacing` | `real` | `12` | read/write | [`Md3SelectionControl`](Md3SelectionControl.md) | — |
| `labelRole` | `int` | `Md3Text.BodyLarge` | read/write | [`Md3SelectionControl`](Md3SelectionControl.md) | — |
| `hovered` | `bool` | `mouse.containsMouse` | readonly | [`Md3SelectionControl`](Md3SelectionControl.md) | — |
| `pressed` | `bool` | `mouse.pressed` | readonly | [`Md3SelectionControl`](Md3SelectionControl.md) | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `toggled(var state)` | `Md3Checkbox` | — |
| `activated()` | [`Md3SelectionControl`](Md3SelectionControl.md) | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `cycle()` | `Md3Checkbox` | — |
| `activate()` | [`Md3SelectionControl`](Md3SelectionControl.md) | — |

## Example

```qml
import Md3

Md3Checkbox {
    tristate: false
    checkState: checked ? Qt.Checked : Qt.Unchecked
    checked: false
    text: ""
    accessibleName: text.length ? text : qsTr("Selection control")
}
```
