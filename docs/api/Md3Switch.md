# Md3Switch

- **Source:** `src/Md3/components/Md3Switch.qml`
- **Extends:** `Md3SelectionControl`

## Import

```qml
import Md3
```

## Inheritance

[`Md3Switch`](Md3Switch.md) → [`Md3SelectionControl`](Md3SelectionControl.md)

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `showIcon` | `bool` | `false` | read/write | `Md3Switch` | — |
| `trackColor` | `color` | `{…}` | readonly | `Md3Switch` | — |
| `thumbColor` | `color` | `{…}` | readonly | `Md3Switch` | — |
| `thumbSize` | `real` | `checked ? 24 : 16` | readonly | `Md3Switch` | — |
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
| `toggled(bool checked)` | `Md3Switch` | — |
| `activated()` | [`Md3SelectionControl`](Md3SelectionControl.md) | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `toggle()` | `Md3Switch` | — |
| `activate()` | [`Md3SelectionControl`](Md3SelectionControl.md) | — |

## Example

```qml
import Md3

Md3Switch {
    showIcon: false
    checked: false
    text: ""
    accessibleName: text.length ? text : qsTr("Selection control")
    accessibleRole: Accessible.CheckBox
}
```
