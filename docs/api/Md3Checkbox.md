# Md3Checkbox

- **Source:** `src/Md3/components/Md3Checkbox.qml`
- **Extends:** `Md3SelectionControl`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 5 | 1 | 1 | 0 |

## Import

```qml
import Md3
```

## Inheritance

[`Md3Checkbox`](Md3Checkbox.md) → [`Md3SelectionControl`](Md3SelectionControl.md)

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `tristate` | `bool` | `false` | read/write | `Md3Checkbox` | Tristate. |
| `checkState` | `var` | `checked ? Qt.Checked : Qt.Unchecked` | read/write | `Md3Checkbox` | Check State. |
| `isChecked` | `bool` | `checkState === Qt.Checked` | readonly | `Md3Checkbox` | Is Checked. |
| `isPartial` | `bool` | `checkState === Qt.PartiallyChecked` | readonly | `Md3Checkbox` | Is Partial. |
| `selected` | `bool` | `isChecked \|\| isPartial` | readonly | `Md3Checkbox` | Selected. |
| `checked` | `bool` | `false` | read/write | [`Md3SelectionControl`](Md3SelectionControl.md) | Checked / on state. |
| `text` | `string` | `""` | read/write | [`Md3SelectionControl`](Md3SelectionControl.md) | Primary label text. |
| `accessibleName` | `string` | `text.length ? text : qsTr("Selection control")` | read/write | [`Md3SelectionControl`](Md3SelectionControl.md) | Accessible name override. |
| `accessibleRole` | `int` | `Accessible.CheckBox` | read/write | [`Md3SelectionControl`](Md3SelectionControl.md) | Accessible Role. |
| `chromeWidth` | `real` | `48` | read/write | [`Md3SelectionControl`](Md3SelectionControl.md) | Chrome Width. |
| `labelSpacing` | `real` | `12` | read/write | [`Md3SelectionControl`](Md3SelectionControl.md) | Label Spacing. |
| `labelRole` | `int` | `Md3Text.BodyLarge` | read/write | [`Md3SelectionControl`](Md3SelectionControl.md) | Label Role. |
| `hovered` | `bool` | `mouse.containsMouse` | readonly | [`Md3SelectionControl`](Md3SelectionControl.md) | Hovered. |
| `pressed` | `bool` | `mouse.pressed` | readonly | [`Md3SelectionControl`](Md3SelectionControl.md) | Pressed. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `toggled(var state)` | `Md3Checkbox` | Emitted when toggled. |
| `activated()` | [`Md3SelectionControl`](Md3SelectionControl.md) | Emitted when activated. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `cycle()` | `—` | `Md3Checkbox` | Cycle. |
| `activate()` | `—` | [`Md3SelectionControl`](Md3SelectionControl.md) | Activate. |

## Example

```qml
import Md3

Md3Checkbox {
    tristate: false
    checkState: checked ? Qt.Checked : Qt.Unchecked
    checked: false
    text: ""
    accessibleName: text.length ? text : qsTr("Selection control")
    accessibleRole: Accessible.CheckBox
}
```
