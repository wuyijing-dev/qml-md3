# Md3SplitView

Horizontal (or vertical) draggable split panes for list/detail layouts.

- **Source:** `src/Md3/components/Md3SplitView.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 9 | 0 | 0 | 1 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Enums

### `Md3SplitView.Orientation`

`Md3SplitView.Horizontal`, `Md3SplitView.Vertical`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `orientation` | `int (Md3SplitView.Orientation)` | `Md3SplitView.Horizontal` | read/write | `Md3SplitView` | Layout orientation. |
| `splitRatio` | `real` | `0.35` | read/write | `Md3SplitView` | Split Ratio. |
| `minPane1` | `real` | `180` | read/write | `Md3SplitView` | Min Pane1. |
| `minPane2` | `real` | `240` | read/write | `Md3SplitView` | Min Pane2. |
| `handleThickness` | `real` | `6` | read/write | `Md3SplitView` | Handle Thickness. |
| `showHandle` | `bool` | `true` | read/write | `Md3SplitView` | Show Handle. |
| `handleColor` | `color` | `Md3Theme.colorScheme.outlineVariant` | read/write | `Md3SplitView` | Handle Color. |
| `content` | `alias` | `paneHost.data` | default read/write | `Md3SplitView` | Content. |
| `horizontal` | `bool` | `orientation === Md3SplitView.Horizontal` | readonly | `Md3SplitView` | Horizontal. |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3SplitView {
    orientation: Md3SplitView.Horizontal
    splitRatio: 0.35
    minPane1: 180
    minPane2: 240
    handleThickness: 6
    showHandle: true
}
```
