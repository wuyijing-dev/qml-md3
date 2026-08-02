# Md3LiquidGlassFusionPlayground

EXPERIMENTAL: Liquid Glass fusion demo API may change. Two draggable glass bodies rendered in one fused SDF pass (real metaball merge).

- **Source:** `src/Md3/components/Md3LiquidGlassFusionPlayground.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 10 | 0 | 0 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `sourceItem` | `Item` | `null` | read/write | `Md3LiquidGlassFusionPlayground` | Source Item. |
| `fusionStrength` | `real` | `0.14` | read/write | `Md3LiquidGlassFusionPlayground` | Fusion Strength. |
| `squircleN` | `real` | `5.0` | read/write | `Md3LiquidGlassFusionPlayground` | Squircle N. |
| `quality` | `int` | `2` | read/write | `Md3LiquidGlassFusionPlayground` | Quality. |
| `dragCount` | `int` | `0` | read/write | `Md3LiquidGlassFusionPlayground` | Drag Count. |
| `liveSampling` | `bool` | `true` | read/write | `Md3LiquidGlassFusionPlayground` | Live Sampling. |
| `samplePadding` | `real` | `28` | read/write | `Md3LiquidGlassFusionPlayground` | Sample Padding. |
| `playgroundAspect` | `real` | `width / Math.max(1, height)` | readonly | `Md3LiquidGlassFusionPlayground` | Playground Aspect. |
| `mergeA` | `vector4d` | `_bodyFromRect(blobA.x, blobA.y, blobA.width, blobA.height)` | readonly | `Md3LiquidGlassFusionPlayground` | Merge A. |
| `mergeB` | `vector4d` | `_bodyFromRect(blobB.x, blobB.y, blobB.width, blobB.height)` | readonly | `Md3LiquidGlassFusionPlayground` | Merge B. |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3LiquidGlassFusionPlayground {
    sourceItem: null
    fusionStrength: 0.14
    squircleN: 5.0
    quality: 2
    dragCount: 0
    liveSampling: true
}
```
