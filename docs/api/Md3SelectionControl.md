# Md3SelectionControl

Shared shell for selection controls such as Checkbox / Radio / Switch. Subclasses provide the left-side chrome and handle `onActivated`.

- **Source:** `src/Md3/primitives/Md3SelectionControl.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 9 | 1 | 1 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `checked` | `bool` | `false` | read/write | `Md3SelectionControl` | Checked / on state. |
| `text` | `string` | `""` | read/write | `Md3SelectionControl` | Primary label text. |
| `accessibleName` | `string` | `text.length ? text : qsTr("Selection control")` | read/write | `Md3SelectionControl` | Accessible name override. |
| `accessibleRole` | `int` | `Accessible.CheckBox` | read/write | `Md3SelectionControl` | Accessible Role. |
| `chromeWidth` | `real` | `48` | read/write | `Md3SelectionControl` | Chrome Width. |
| `labelSpacing` | `real` | `12` | read/write | `Md3SelectionControl` | Label Spacing. |
| `labelRole` | `int` | `Md3Text.BodyLarge` | read/write | `Md3SelectionControl` | Label Role. |
| `hovered` | `bool` | `mouse.containsMouse` | readonly | `Md3SelectionControl` | Hovered. |
| `pressed` | `bool` | `mouse.pressed` | readonly | `Md3SelectionControl` | Pressed. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `activated()` | `Md3SelectionControl` | Emitted when activated. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `activate()` | `—` | `Md3SelectionControl` | Activate. |

## Example

```qml
import Md3

Md3SelectionControl {
    checked: false
    text: ""
    accessibleName: text.length ? text : qsTr("Selection control")
    accessibleRole: Accessible.CheckBox
    chromeWidth: 48
    labelSpacing: 12
}
```
