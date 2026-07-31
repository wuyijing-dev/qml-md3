# Md3FlowLayout

Wrapping flow — thin wrapper over Md3AnimatedFlow (no animation by default).

- **Source:** `src/Md3/layout/Md3FlowLayout.qml`
- **Extends:** `Md3AnimatedFlow`

## Import

```qml
import Md3
```

## Inheritance

[`Md3FlowLayout`](Md3FlowLayout.md) → [`Md3AnimatedFlow`](Md3AnimatedFlow.md)

## Enums

### `Md3AnimatedFlow.Alignment` _(from [Md3AnimatedFlow](Md3AnimatedFlow.md))_

`Md3AnimatedFlow.Start`, `Md3AnimatedFlow.Center`, `Md3AnimatedFlow.End`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `content` | `alias` | `host.data` | default read/write | [`Md3AnimatedFlow`](Md3AnimatedFlow.md) | Default property → `host.data` |
| `spacing` | `real` | `8` | read/write | [`Md3AnimatedFlow`](Md3AnimatedFlow.md) | — |
| `rowSpacing` | `real` | `8` | read/write | [`Md3AnimatedFlow`](Md3AnimatedFlow.md) | — |
| `padding` | `real` | `0` | read/write | [`Md3AnimatedFlow`](Md3AnimatedFlow.md) | — |
| `leftPadding` | `real` | `padding` | read/write | [`Md3AnimatedFlow`](Md3AnimatedFlow.md) | — |
| `rightPadding` | `real` | `padding` | read/write | [`Md3AnimatedFlow`](Md3AnimatedFlow.md) | — |
| `topPadding` | `real` | `padding` | read/write | [`Md3AnimatedFlow`](Md3AnimatedFlow.md) | — |
| `bottomPadding` | `real` | `padding` | read/write | [`Md3AnimatedFlow`](Md3AnimatedFlow.md) | — |
| `animate` | `bool` | `true` | read/write | [`Md3AnimatedFlow`](Md3AnimatedFlow.md) | — |
| `moveDuration` | `int` | `Md3Motion.spatialDuration` | read/write | [`Md3AnimatedFlow`](Md3AnimatedFlow.md) | — |
| `moveEasing` | `var` | `Md3Motion.spatialDefault` | read/write | [`Md3AnimatedFlow`](Md3AnimatedFlow.md) | — |
| `fillWidth` | `bool` | `true` | read/write | [`Md3AnimatedFlow`](Md3AnimatedFlow.md) | — |
| `alignment` | `int` | `Md3AnimatedFlow.Start` | read/write | [`Md3AnimatedFlow`](Md3AnimatedFlow.md) | — |
| `rowCount` | `int` | `_rowCount` | readonly | [`Md3AnimatedFlow`](Md3AnimatedFlow.md) | — |
| `wrapped` | `bool` | `_rowCount > 1` | readonly | [`Md3AnimatedFlow`](Md3AnimatedFlow.md) | — |
| `contentHeight` | `real` | `_contentHeight` | readonly | [`Md3AnimatedFlow`](Md3AnimatedFlow.md) | — |
| `contentWidth` | `real` | `_contentWidth` | readonly | [`Md3AnimatedFlow`](Md3AnimatedFlow.md) | — |

## Signals

_None._

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `relayout()` | [`Md3AnimatedFlow`](Md3AnimatedFlow.md) | — |

## Example

```qml
import Md3

Md3FlowLayout {
    spacing: 8
    rowSpacing: 8
    padding: 0
    leftPadding: padding
    rightPadding: padding
}
```
