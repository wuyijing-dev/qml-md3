# Md3AnimatedFlow

- **Source:** `src/Md3/layout/Md3AnimatedFlow.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `content` | `alias` | `host.data` | read/write | `Md3AnimatedFlow` | — |
| `spacing` | `real` | `8` | read/write | `Md3AnimatedFlow` | — |
| `rowSpacing` | `real` | `8` | read/write | `Md3AnimatedFlow` | — |
| `animate` | `bool` | `true` | read/write | `Md3AnimatedFlow` | — |
| `moveDuration` | `int` | `Md3Motion.spatialDuration` | read/write | `Md3AnimatedFlow` | — |
| `moveEasing` | `var` | `Md3Motion.spatialDefault` | read/write | `Md3AnimatedFlow` | — |
| `fillWidth` | `bool` | `true` | read/write | `Md3AnimatedFlow` | — |
| `rowCount` | `int` | `_rowCount` | readonly | `Md3AnimatedFlow` | — |
| `wrapped` | `bool` | `_rowCount > 1` | readonly | `Md3AnimatedFlow` | — |
| `contentHeight` | `real` | `_contentHeight` | readonly | `Md3AnimatedFlow` | — |
| `contentWidth` | `real` | `_contentWidth` | readonly | `Md3AnimatedFlow` | — |
| `_rowCount` | `int` | `1` | read/write | `Md3AnimatedFlow` | — |
| `_firstLayout` | `bool` | `true` | read/write | `Md3AnimatedFlow` | — |
| `_contentWidth` | `real` | `0` | read/write | `Md3AnimatedFlow` | — |
| `_contentHeight` | `real` | `0` | read/write | `Md3AnimatedFlow` | — |
| `_sizeCache` | `var` | `({})` | read/write | `Md3AnimatedFlow` | Per-child last size { w, h } keyed by child index — no dynamic props on Items |
| `_animCache` | `var` | `({})` | read/write | `Md3AnimatedFlow` | — |

## Signals

_None._

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `relayout()` | `Md3AnimatedFlow` | — |

## Example

```qml
import Md3

Md3AnimatedFlow {
    content: host.data
    spacing: 8
    rowSpacing: 8
    animate: true
    moveDuration: Md3Motion.spatialDuration
}
```
