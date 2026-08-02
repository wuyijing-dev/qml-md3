# Md3Radio

- **Source:** `src/Md3/components/Md3Radio.qml`
- **Extends:** `Md3SelectionControl`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 2 | 1 | 1 | 0 |

## Import

```qml
import Md3
```

## Inheritance

[`Md3Radio`](Md3Radio.md) → [`Md3SelectionControl`](Md3SelectionControl.md)

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `group` | `var` | `null` | read/write | `Md3Radio` | Group. |
| `value` | `var` | `null` | read/write | `Md3Radio` | Current value. |
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
| `clicked()` | `Md3Radio` | Emitted when clicked. |
| `activated()` | [`Md3SelectionControl`](Md3SelectionControl.md) | Emitted when activated. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `select()` | `—` | `Md3Radio` | Select. |
| `activate()` | `—` | [`Md3SelectionControl`](Md3SelectionControl.md) | Activate. |

## Example

```qml
import Md3

Md3Radio {
    group: null
    value: null
    checked: false
    text: ""
    accessibleName: text.length ? text : qsTr("Selection control")
    accessibleRole: Accessible.CheckBox
}
```
