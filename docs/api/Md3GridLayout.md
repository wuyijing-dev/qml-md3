# Md3GridLayout

- **Source:** `src/Md3/layout/Md3GridLayout.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `content` | `alias` | `host.data` | default read/write | `Md3GridLayout` | Default property -> `host.data` |
| `columns` | `int` | `0` | read/write | `Md3GridLayout` | Fixed columns (`<=0` uses auto columns) |
| `minCellWidth` | `real` | `160` | read/write | `Md3GridLayout` | Target minimum width per cell in auto mode |
| `spacing` | `real` | `12` | read/write | `Md3GridLayout` | Horizontal spacing |
| `rowSpacing` | `real` | `spacing` | read/write | `Md3GridLayout` | Vertical spacing |
| `padding` | `real` | `0` | read/write | `Md3GridLayout` | Inner padding |
| `stretchCells` | `bool` | `true` | read/write | `Md3GridLayout` | Force each child width to computed cell width |
| `effectiveColumns` | `int` | `_effectiveColumns` | readonly | `Md3GridLayout` | Computed columns |
| `cellWidth` | `real` | `_cellWidth` | readonly | `Md3GridLayout` | Computed cell width |

## Signals

_None._

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `relayout()` | `Md3GridLayout` | Recompute child placement |

## Example

```qml
import Md3

Md3GridLayout {
    minCellWidth: 180
    spacing: 12
    Repeater {
        model: 6
        delegate: Md3Card {
            implicitHeight: 88
            Text { text: "Card " + (index + 1) }
        }
    }
}
```
