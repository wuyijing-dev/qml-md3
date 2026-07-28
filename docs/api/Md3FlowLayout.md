# Md3FlowLayout

- **Source:** `src/Md3/layout/Md3FlowLayout.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `content` | `alias` | `flow.data` | default read/write | `Md3FlowLayout` | Default property -> `flow.data` |
| `spacing` | `real` | `8` | read/write | `Md3FlowLayout` | Item spacing |
| `rowSpacing` | `real` | `8` | read/write | `Md3FlowLayout` | Extra vertical rhythm between wrapped rows |
| `padding` | `real` | `0` | read/write | `Md3FlowLayout` | Inner padding |
| `fillWidth` | `bool` | `true` | read/write | `Md3FlowLayout` | Stretch to parent width |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3FlowLayout {
    spacing: 8
    rowSpacing: 8
    Repeater {
        model: 8
        delegate: Md3SuggestionChip { text: "Chip " + (index + 1) }
    }
}
```
