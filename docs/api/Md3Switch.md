# Md3Switch

- **Source:** `src/Md3/components/Md3Switch.qml`
- **Extends:** `Md3SelectionControl`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 4 | 1 | 1 | 0 |

## Import

```qml
import Md3
```

## Inheritance

[`Md3Switch`](Md3Switch.md) → [`Md3SelectionControl`](Md3SelectionControl.md)

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `showIcon` | `bool` | `false` | read/write | `Md3Switch` | Show Icon. |
| `trackColor` | `color` | `{…}` | readonly | `Md3Switch` | Track Color. |
| `thumbColor` | `color` | `{…}` | readonly | `Md3Switch` | Thumb Color. |
| `thumbSize` | `real` | `checked ? 24 : 16` | readonly | `Md3Switch` | Thumb Size. |
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
| `toggled(bool checked)` | `Md3Switch` | Emitted when toggled. |
| `activated()` | [`Md3SelectionControl`](Md3SelectionControl.md) | Emitted when activated. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `toggle()` | `—` | `Md3Switch` | Toggle open / checked state. |
| `activate()` | `—` | [`Md3SelectionControl`](Md3SelectionControl.md) | Activate. |

## Example

```qml
import Md3

Md3Switch {
    showIcon: false
    checked: false
    text: ""
    accessibleName: text.length ? text : qsTr("Selection control")
    accessibleRole: Accessible.CheckBox
    chromeWidth: 48
}
```
