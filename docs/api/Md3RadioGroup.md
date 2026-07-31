# Md3RadioGroup

Model-driven radio row/column — no host QtObject + manual Md3Radio list.

- **Source:** `src/Md3/components/Md3RadioGroup.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Enums

### `Md3RadioGroup.Orientation`

`Md3RadioGroup.Horizontal`, `Md3RadioGroup.Vertical`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `model` | `var` | `[]` | read/write | `Md3RadioGroup` | [{ text, value?, enabled? }] — value defaults to text when omitted. |
| `value` | `var` | `null` | read/write | `Md3RadioGroup` | — |
| `orientation` | `int` | `Md3RadioGroup.Horizontal` | read/write | `Md3RadioGroup` | — |
| `spacing` | `real` | `8` | read/write | `Md3RadioGroup` | — |
| `currentIndex` | `int` | `{…}` | readonly | `Md3RadioGroup` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `selected(var value)` | `Md3RadioGroup` | Emitted when the user picks a radio (not when `value` is set programmatically with the same value). |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `select(v)` | `Md3RadioGroup` | — |

## Example

```qml
import Md3

Md3RadioGroup {
    model: []
    value: null
    orientation: Md3RadioGroup.Horizontal
    spacing: 8
}
```
