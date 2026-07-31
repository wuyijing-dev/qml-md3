# Md3SelectionControl

Shared shell for selection controls such as Checkbox / Radio / Switch. Subclasses provide the left-side chrome and handle `onActivated`.

- **Source:** `src/Md3/primitives/Md3SelectionControl.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `checked` | `bool` | `false` | read/write | `Md3SelectionControl` | — |
| `text` | `string` | `""` | read/write | `Md3SelectionControl` | — |
| `accessibleName` | `string` | `text.length ? text : qsTr("Selection control")` | read/write | `Md3SelectionControl` | — |
| `accessibleRole` | `int` | `Accessible.CheckBox` | read/write | `Md3SelectionControl` | — |
| `chromeWidth` | `real` | `48` | read/write | `Md3SelectionControl` | — |
| `labelSpacing` | `real` | `12` | read/write | `Md3SelectionControl` | — |
| `labelRole` | `int` | `Md3Text.BodyLarge` | read/write | `Md3SelectionControl` | — |
| `hovered` | `bool` | `mouse.containsMouse` | readonly | `Md3SelectionControl` | — |
| `pressed` | `bool` | `mouse.pressed` | readonly | `Md3SelectionControl` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `activated()` | `Md3SelectionControl` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `activate()` | `Md3SelectionControl` | — |

## Example

```qml
import Md3

Md3SelectionControl {
    checked: false
    text: ""
    accessibleName: text.length ? text : qsTr("Selection control")
    accessibleRole: Accessible.CheckBox
    chromeWidth: 48
}
```
