# Md3Radio

- **Source:** `src/Md3/components/Md3Radio.qml`
- **Extends:** `Md3SelectionControl`

## Import

```qml
import Md3
```

## Inheritance

[`Md3Radio`](Md3Radio.md) → [`Md3SelectionControl`](Md3SelectionControl.md)

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `group` | `var` | `null` | read/write | `Md3Radio` | — |
| `value` | `var` | `null` | read/write | `Md3Radio` | — |
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
| `clicked()` | `Md3Radio` | — |
| `activated()` | [`Md3SelectionControl`](Md3SelectionControl.md) | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `select()` | `Md3Radio` | — |
| `activate()` | [`Md3SelectionControl`](Md3SelectionControl.md) | — |

## Example

```qml
import Md3

Md3Radio {
    group: null
    value: null
    checked: false
    text: ""
    accessibleName: text.length ? text : qsTr("Selection control")
}
```
