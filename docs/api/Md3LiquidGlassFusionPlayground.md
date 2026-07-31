# Md3LiquidGlassFusionPlayground

EXPERIMENTAL: Liquid Glass fusion demo API may change. Two draggable glass bodies rendered in one fused SDF pass (real metaball merge).

- **Source:** `src/Md3/components/Md3LiquidGlassFusionPlayground.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `sourceItem` | `Item` | `null` | read/write | `Md3LiquidGlassFusionPlayground` | — |
| `fusionStrength` | `real` | `0.14` | read/write | `Md3LiquidGlassFusionPlayground` | — |
| `squircleN` | `real` | `5.0` | read/write | `Md3LiquidGlassFusionPlayground` | — |
| `quality` | `int` | `2` | read/write | `Md3LiquidGlassFusionPlayground` | — |
| `dragCount` | `int` | `0` | read/write | `Md3LiquidGlassFusionPlayground` | — |
| `liveSampling` | `bool` | `true` | read/write | `Md3LiquidGlassFusionPlayground` | — |
| `samplePadding` | `real` | `28` | read/write | `Md3LiquidGlassFusionPlayground` | — |
| `playgroundAspect` | `real` | `width / Math.max(1, height)` | readonly | `Md3LiquidGlassFusionPlayground` | — |
| `mergeA` | `vector4d` | `_bodyFromRect(blobA.x, blobA.y, blobA.width, blobA.height)` | readonly | `Md3LiquidGlassFusionPlayground` | — |
| `mergeB` | `vector4d` | `_bodyFromRect(blobB.x, blobB.y, blobB.width, blobB.height)` | readonly | `Md3LiquidGlassFusionPlayground` | — |

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
}
```
