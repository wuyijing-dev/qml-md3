# Md3AdaptiveContainer

Standalone column-stacking adaptive container (gallery / direct use). Md3 container components embed `Md3ContainerBody` and expose `layoutMode` directly. Uses Md3VStack (HeightSync) instead of bare Column to avoid Qt 6.8 height-collapse overlaps.

- **Source:** `src/Md3/components/Md3AdaptiveContainer.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 5 | 0 | 0 | 1 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Enums

### `Md3AdaptiveContainer.LayoutMode`

`Md3AdaptiveContainer.Fit`, `Md3AdaptiveContainer.Scroll`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `layoutMode` | `int (Md3AdaptiveContainer.LayoutMode)` | `Md3AdaptiveContainer.Fit` | read/write | `Md3AdaptiveContainer` | Layout Mode. |
| `padding` | `real` | `0` | read/write | `Md3AdaptiveContainer` | Uniform padding. |
| `clipContent` | `bool` | `true` | read/write | `Md3AdaptiveContainer` | Clip Content. |
| `contentSpacing` | `real` | `12` | read/write | `Md3AdaptiveContainer` | Content Spacing. |
| `content` | `alias` | `contentStack.content` | default read/write | `Md3AdaptiveContainer` | Content. |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3AdaptiveContainer {
    layoutMode: Md3AdaptiveContainer.Fit
    padding: 0
    clipContent: true
    contentSpacing: 12
}
```
