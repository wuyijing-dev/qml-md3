# Md3InspectorLayout

List + detail nested split (inspector pattern). Direct children: pane0 = list, pane1 = detail.

- **Source:** `src/Md3/layout/Md3InspectorLayout.qml`
- **Extends:** `Md3SplitView`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 0 | 0 | 0 | 0 |

## Import

```qml
import Md3
```

## Inheritance

[`Md3InspectorLayout`](Md3InspectorLayout.md) → [`Md3SplitView`](Md3SplitView.md)

## Enums

### `Md3SplitView.Orientation` _(from [Md3SplitView](Md3SplitView.md))_

`Md3SplitView.Horizontal`, `Md3SplitView.Vertical`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `orientation` | `int (Md3SplitView.Orientation)` | `Md3SplitView.Horizontal` | read/write | [`Md3SplitView`](Md3SplitView.md) | Layout orientation. |
| `splitRatio` | `real` | `0.35` | read/write | [`Md3SplitView`](Md3SplitView.md) | Split Ratio. |
| `minPane1` | `real` | `180` | read/write | [`Md3SplitView`](Md3SplitView.md) | Min Pane1. |
| `minPane2` | `real` | `240` | read/write | [`Md3SplitView`](Md3SplitView.md) | Min Pane2. |
| `handleThickness` | `real` | `6` | read/write | [`Md3SplitView`](Md3SplitView.md) | Handle Thickness. |
| `showHandle` | `bool` | `true` | read/write | [`Md3SplitView`](Md3SplitView.md) | Show Handle. |
| `handleColor` | `color` | `Md3Theme.colorScheme.outlineVariant` | read/write | [`Md3SplitView`](Md3SplitView.md) | Handle Color. |
| `manageGeometry` | `bool` | `true` | read/write | [`Md3SplitView`](Md3SplitView.md) | When true (default), this control owns pane geometry. |
| `pane1Collapsed` | `bool` | `false` | read/write | [`Md3SplitView`](Md3SplitView.md) | Collapse first / second pane (ratio → 0 / 1). Prefer SideSheet for transient detail. |
| `pane2Collapsed` | `bool` | `false` | read/write | [`Md3SplitView`](Md3SplitView.md) | Pane2Collapsed. |
| `warnAnchorsFill` | `bool` | `true` | read/write | [`Md3SplitView`](Md3SplitView.md) | Warn in console when a direct child uses anchors.fill (Debug / Qt.debug builds). |
| `content` | `alias` | `paneHost.data` | default read/write | [`Md3SplitView`](Md3SplitView.md) | Content. |
| `horizontal` | `bool` | `orientation === Md3SplitView.Horizontal` | readonly | [`Md3SplitView`](Md3SplitView.md) | Horizontal. |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3InspectorLayout {
    orientation: Md3SplitView.Horizontal
    splitRatio: 0.35
    minPane1: 180
    minPane2: 240
    handleThickness: 6
    showHandle: true
}
```
