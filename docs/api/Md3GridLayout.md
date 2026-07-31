# Md3GridLayout

Responsive uniform grid for arbitrary child items.

- **Source:** `src/Md3/layout/Md3GridLayout.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Enums

### `Md3GridLayout.Alignment`

`Md3GridLayout.Start`, `Md3GridLayout.Center`, `Md3GridLayout.End`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `columns` | `int` | `0` | read/write | `Md3GridLayout` | Fixed columns; <= 0 means auto by minCellWidth. |
| `minCellWidth` | `real` | `160` | read/write | `Md3GridLayout` | — |
| `minCellHeight` | `real` | `0` | read/write | `Md3GridLayout` | — |
| `spacing` | `real` | `12` | read/write | `Md3GridLayout` | — |
| `rowSpacing` | `real` | `spacing` | read/write | `Md3GridLayout` | — |
| `padding` | `real` | `0` | read/write | `Md3GridLayout` | — |
| `leftPadding` | `real` | `padding` | read/write | `Md3GridLayout` | — |
| `rightPadding` | `real` | `padding` | read/write | `Md3GridLayout` | — |
| `topPadding` | `real` | `padding` | read/write | `Md3GridLayout` | — |
| `bottomPadding` | `real` | `padding` | read/write | `Md3GridLayout` | — |
| `stretchCells` | `bool` | `true` | read/write | `Md3GridLayout` | — |
| `equalRowHeight` | `bool` | `true` | read/write | `Md3GridLayout` | — |
| `cellAlignment` | `int` | `Md3GridLayout.Center` | read/write | `Md3GridLayout` | — |
| `content` | `alias` | `host.data` | default read/write | `Md3GridLayout` | Default property → `host.data` |
| `effectiveColumns` | `int` | `_effectiveColumns` | readonly | `Md3GridLayout` | — |
| `cellWidth` | `real` | `_cellWidth` | readonly | `Md3GridLayout` | — |

## Signals

_None._

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `relayout()` | `Md3GridLayout` | — |

## Example

```qml
import Md3

Md3GridLayout {
    columns: 0
    minCellWidth: 160
    minCellHeight: 0
    spacing: 12
    rowSpacing: spacing
}
```
