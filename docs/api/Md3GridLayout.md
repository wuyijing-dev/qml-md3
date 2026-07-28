# Md3GridLayout

Responsive uniform grid. Cell size uses `max(explicit, implicit)` and optional `minCellHeight`.

- **Source:** `src/Md3/layout/Md3GridLayout.qml`

## Properties

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `content` | alias | default | Children |
| `columns` | int | `0` | Fixed columns; `<=0` = auto from `minCellWidth` |
| `minCellWidth` | real | `160` | Auto-column target |
| `minCellHeight` | real | `0` | Floor for row height |
| `spacing` / `rowSpacing` | real | `12` / `spacing` | Gaps |
| `padding` (+ edge paddings) | real | `0` | — |
| `stretchCells` | bool | `true` | Force each cell to grid cell size |
| `equalRowHeight` | bool | `true` | All rows share max row height |
| `cellAlignment` | int | `Center` | When not stretching: Start/Center/End |
| `effectiveColumns` / `cellWidth` | readonly | — | Metrics |

## Methods

| Method | Description |
|--------|-------------|
| `relayout()` | Recompute placement |

## Example

```qml
Md3GridLayout {
    minCellWidth: 140
    minCellHeight: 84
    Repeater {
        model: 4
        delegate: Md3Card { title: "Grid " + (index + 1); variant: Md3Card.Filled }
    }
}
```
