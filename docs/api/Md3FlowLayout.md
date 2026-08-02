# Md3FlowLayout

Wrapping flow — thin wrapper over Md3AnimatedFlow (no animation by default).

- **Source:** `src/Md3/layout/Md3FlowLayout.qml`
- **Extends:** `Md3AnimatedFlow`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 0 | 0 | 0 | 0 |

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
| `content` | `alias` | `host.data` | default read/write | [`Md3AnimatedFlow`](Md3AnimatedFlow.md) | Content. |
| `spacing` | `real` | `8` | read/write | [`Md3AnimatedFlow`](Md3AnimatedFlow.md) | Child spacing. |
| `rowSpacing` | `real` | `8` | read/write | [`Md3AnimatedFlow`](Md3AnimatedFlow.md) | Row Spacing. |
| `padding` | `real` | `0` | read/write | [`Md3AnimatedFlow`](Md3AnimatedFlow.md) | Uniform padding. |
| `leftPadding` | `real` | `padding` | read/write | [`Md3AnimatedFlow`](Md3AnimatedFlow.md) | Left Padding. |
| `rightPadding` | `real` | `padding` | read/write | [`Md3AnimatedFlow`](Md3AnimatedFlow.md) | Right Padding. |
| `topPadding` | `real` | `padding` | read/write | [`Md3AnimatedFlow`](Md3AnimatedFlow.md) | Top Padding. |
| `bottomPadding` | `real` | `padding` | read/write | [`Md3AnimatedFlow`](Md3AnimatedFlow.md) | Bottom Padding. |
| `animate` | `bool` | `true` | read/write | [`Md3AnimatedFlow`](Md3AnimatedFlow.md) | Animate. |
| `moveDuration` | `int` | `Md3Motion.spatialDuration` | read/write | [`Md3AnimatedFlow`](Md3AnimatedFlow.md) | Move Duration. |
| `moveEasing` | `var` | `Md3Motion.spatialDefault` | read/write | [`Md3AnimatedFlow`](Md3AnimatedFlow.md) | Move Easing. |
| `fillWidth` | `bool` | `true` | read/write | [`Md3AnimatedFlow`](Md3AnimatedFlow.md) | Fill Width. |
| `alignment` | `int (Md3AnimatedFlow.Alignment)` | `Md3AnimatedFlow.Start` | read/write | [`Md3AnimatedFlow`](Md3AnimatedFlow.md) | Alignment. |
| `rowCount` | `int` | `_rowCount` | readonly | [`Md3AnimatedFlow`](Md3AnimatedFlow.md) | Row Count. |
| `wrapped` | `bool` | `_rowCount > 1` | readonly | [`Md3AnimatedFlow`](Md3AnimatedFlow.md) | Wrapped. |
| `contentHeight` | `real` | `_contentHeight` | readonly | [`Md3AnimatedFlow`](Md3AnimatedFlow.md) | Content Height. |
| `contentWidth` | `real` | `_contentWidth` | readonly | [`Md3AnimatedFlow`](Md3AnimatedFlow.md) | Content Width. |

## Signals

_None._

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `relayout()` | `—` | [`Md3AnimatedFlow`](Md3AnimatedFlow.md) | Relayout. |

## Example

```qml
import Md3

Md3FlowLayout {
    spacing: 8
    rowSpacing: 8
    padding: 0
    leftPadding: padding
    rightPadding: padding
    topPadding: padding
}
```
