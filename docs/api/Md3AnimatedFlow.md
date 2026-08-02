# Md3AnimatedFlow

Flow layout: children reflow with spatial easing. Sizes use max(explicit, implicit) so callers need not mirror width/height into implicit*.

- **Source:** `src/Md3/layout/Md3AnimatedFlow.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 17 | 0 | 1 | 1 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Enums

### `Md3AnimatedFlow.Alignment`

`Md3AnimatedFlow.Start`, `Md3AnimatedFlow.Center`, `Md3AnimatedFlow.End`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `content` | `alias` | `host.data` | default read/write | `Md3AnimatedFlow` | Content. |
| `spacing` | `real` | `8` | read/write | `Md3AnimatedFlow` | Child spacing. |
| `rowSpacing` | `real` | `8` | read/write | `Md3AnimatedFlow` | Row Spacing. |
| `padding` | `real` | `0` | read/write | `Md3AnimatedFlow` | Uniform padding. |
| `leftPadding` | `real` | `padding` | read/write | `Md3AnimatedFlow` | Left Padding. |
| `rightPadding` | `real` | `padding` | read/write | `Md3AnimatedFlow` | Right Padding. |
| `topPadding` | `real` | `padding` | read/write | `Md3AnimatedFlow` | Top Padding. |
| `bottomPadding` | `real` | `padding` | read/write | `Md3AnimatedFlow` | Bottom Padding. |
| `animate` | `bool` | `true` | read/write | `Md3AnimatedFlow` | Animate. |
| `moveDuration` | `int` | `Md3Motion.spatialDuration` | read/write | `Md3AnimatedFlow` | Move Duration. |
| `moveEasing` | `var` | `Md3Motion.spatialDefault` | read/write | `Md3AnimatedFlow` | Move Easing. |
| `fillWidth` | `bool` | `true` | read/write | `Md3AnimatedFlow` | Fill Width. |
| `alignment` | `int (Md3AnimatedFlow.Alignment)` | `Md3AnimatedFlow.Start` | read/write | `Md3AnimatedFlow` | Alignment. |
| `rowCount` | `int` | `_rowCount` | readonly | `Md3AnimatedFlow` | Row Count. |
| `wrapped` | `bool` | `_rowCount > 1` | readonly | `Md3AnimatedFlow` | Wrapped. |
| `contentHeight` | `real` | `_contentHeight` | readonly | `Md3AnimatedFlow` | Content Height. |
| `contentWidth` | `real` | `_contentWidth` | readonly | `Md3AnimatedFlow` | Content Width. |

## Signals

_None._

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `relayout()` | `—` | `Md3AnimatedFlow` | Relayout. |

## Example

```qml
import Md3

Md3AnimatedFlow {
    spacing: 8
    rowSpacing: 8
    padding: 0
    leftPadding: padding
    rightPadding: padding
    topPadding: padding
}
```
