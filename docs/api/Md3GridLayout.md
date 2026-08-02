# Md3GridLayout

Responsive uniform grid for arbitrary child items.

- **Source:** `src/Md3/layout/Md3GridLayout.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 16 | 0 | 1 | 1 |

_Also inherits Qt Quick `Item` members (not listed)._

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
| `minCellWidth` | `real` | `160` | read/write | `Md3GridLayout` | Min Cell Width. |
| `minCellHeight` | `real` | `0` | read/write | `Md3GridLayout` | Min Cell Height. |
| `spacing` | `real` | `12` | read/write | `Md3GridLayout` | Child spacing. |
| `rowSpacing` | `real` | `spacing` | read/write | `Md3GridLayout` | Row Spacing. |
| `padding` | `real` | `0` | read/write | `Md3GridLayout` | Uniform padding. |
| `leftPadding` | `real` | `padding` | read/write | `Md3GridLayout` | Left Padding. |
| `rightPadding` | `real` | `padding` | read/write | `Md3GridLayout` | Right Padding. |
| `topPadding` | `real` | `padding` | read/write | `Md3GridLayout` | Top Padding. |
| `bottomPadding` | `real` | `padding` | read/write | `Md3GridLayout` | Bottom Padding. |
| `stretchCells` | `bool` | `true` | read/write | `Md3GridLayout` | Stretch Cells. |
| `equalRowHeight` | `bool` | `true` | read/write | `Md3GridLayout` | Equal Row Height. |
| `cellAlignment` | `int (Md3GridLayout.Alignment)` | `Md3GridLayout.Center` | read/write | `Md3GridLayout` | Cell Alignment. |
| `content` | `alias` | `host.data` | default read/write | `Md3GridLayout` | Content. |
| `effectiveColumns` | `int` | `_effectiveColumns` | readonly | `Md3GridLayout` | Effective Columns. |
| `cellWidth` | `real` | `_cellWidth` | readonly | `Md3GridLayout` | Cell Width. |

## Signals

_None._

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `relayout()` | `—` | `Md3GridLayout` | Relayout. |

## Example

```qml
import Md3

Md3GridLayout {
    columns: 0
    minCellWidth: 160
    minCellHeight: 0
    spacing: 12
    rowSpacing: spacing
    padding: 0
}
```
