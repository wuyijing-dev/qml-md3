# Md3SplitView

Horizontal (or vertical) draggable split panes for list/detail layouts.

- **Source:** `src/Md3/components/Md3SplitView.qml`
- **Extends:** `Item`

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
| `orientation` | `int` | `Md3SplitView.Horizontal` | read/write | `Md3SplitView` | — |
| `splitRatio` | `real` | `0.35` | read/write | `Md3SplitView` | — |
| `minPane1` | `real` | `180` | read/write | `Md3SplitView` | — |
| `minPane2` | `real` | `240` | read/write | `Md3SplitView` | — |
| `handleThickness` | `real` | `6` | read/write | `Md3SplitView` | — |
| `showHandle` | `bool` | `true` | read/write | `Md3SplitView` | — |
| `handleColor` | `color` | `Md3Theme.colorScheme.outlineVariant` | read/write | `Md3SplitView` | — |
| `content` | `alias` | `paneHost.data` | default read/write | `Md3SplitView` | Default property → `paneHost.data` |
| `horizontal` | `bool` | `orientation === Md3SplitView.Horizontal` | readonly | `Md3SplitView` | — |

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
}
```
