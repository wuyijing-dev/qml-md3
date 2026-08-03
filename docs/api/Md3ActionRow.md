# Md3ActionRow

Compact vertical stack of full-width actions (detail cards / sheets).

- **Source:** `src/Md3/components/Md3ActionRow.qml`
- **Extends:** `Column`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 4 | 1 | 0 | 0 |

_Also inherits Qt Quick `Column` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `model` | `var` | `[]` | read/write | `Md3ActionRow` | Data model. |
| `rowSpacing` | `real` | `8` | read/write | `Md3ActionRow` | Row Spacing. |
| `maxVisible` | `int` | `0` | read/write | `Md3ActionRow` | When > 0 and model is longer, collapse remainder into an overflow menu. |
| `overflowText` | `string` | `qsTr("More actions")` | read/write | `Md3ActionRow` | Overflow Text. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `actionClicked(int index)` | `Md3ActionRow` | Emitted when action Clicked. |

## Methods

_None._

## Example

```qml
import Md3

Md3ActionRow {
    model: []
    rowSpacing: 8
    maxVisible: 0
    overflowText: qsTr("More actions")
}
```
