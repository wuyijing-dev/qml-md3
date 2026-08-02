# Md3LiquidGlass

EXPERIMENTAL: Liquid Glass API may change without compatibility guarantees. Draggable Liquid Glass — regional backdrop sample (not full-scene blur).

- **Source:** `src/Md3/components/Md3LiquidGlass.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 28 | 0 | 0 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `sourceItem` | `Item` | `null` | read/write | `Md3LiquidGlass` | Source Item. |
| `radius` | `real` | `28` | read/write | `Md3LiquidGlass` | Corner radius. |
| `elevation` | `real` | `2` | read/write | `Md3LiquidGlass` | Elevation. |
| `draggable` | `bool` | `true` | read/write | `Md3LiquidGlass` | Draggable. |
| `boundToParent` | `bool` | `true` | read/write | `Md3LiquidGlass` | Bound To Parent. |
| `squircleN` | `real` | `5.0` | read/write | `Md3LiquidGlass` | Squircle N. |
| `adaptiveTint` | `real` | `0.85` | read/write | `Md3LiquidGlass` | Adaptive Tint. |
| `liquidDeform` | `real` | `1.0` | read/write | `Md3LiquidGlass` | Liquid Deform. |
| `quality` | `int` | `Md3Theme.effectsGlassQuality` | read/write | `Md3LiquidGlass` | 0=Low, 1=Medium, 2=High — scales sample res, frost taps, chroma. |
| `liveSampling` | `bool` | `false` | read/write | `Md3LiquidGlass` | Keep sampling every frame (video). Default off — updates on move/resize/drag (static chrome & lists); set true for video / animated backdrops. |
| `blurAmount` | `real` | `0.4` | read/write | `Md3LiquidGlass` | Blur Amount. |
| `blurMax` | `real` | `64` | read/write | `Md3LiquidGlass` | Blur Max. |
| `tintOpacity` | `real` | `0.08` | read/write | `Md3LiquidGlass` | Tint Opacity. |
| `tintColor` | `color` | `"#FFFFFF"` | read/write | `Md3LiquidGlass` | Tint Color. |
| `edgeStrength` | `real` | `0.9` | read/write | `Md3LiquidGlass` | Edge Strength. |
| `refraction` | `real` | `1.2` | read/write | `Md3LiquidGlass` | Refraction. |
| `chromaticAberration` | `real` | `0.5` | read/write | `Md3LiquidGlass` | Chromatic Aberration. |
| `fusionAmount` | `real` | `0.0` | read/write | `Md3LiquidGlass` | 0..1 SDF blend between base glass body and droplets. |
| `mergeBody` | `vector4d` | `Qt.vector4d(0, 0, 0, 0)` | read/write | `Md3LiquidGlass` | Second body in UV space (cx, cy, halfW, halfH). Set halfW=0 to disable. |
| `dropletA` | `vector4d` | `Qt.vector4d(0.5, 0.5, 0.0, 0.0)` | read/write | `Md3LiquidGlass` | Optional droplets in UV space: Qt.vector4d(x, y, radius, enabled) |
| `dropletB` | `vector4d` | `Qt.vector4d(0.5, 0.5, 0.0, 0.0)` | read/write | `Md3LiquidGlass` | Droplet B. |
| `dropletC` | `vector4d` | `Qt.vector4d(0.5, 0.5, 0.0, 0.0)` | read/write | `Md3LiquidGlass` | Droplet C. |
| `edgeSpectralStrength` | `real` | `0.7` | read/write | `Md3LiquidGlass` | White Fresnel rim / specular strength (not coloured scene glow). |
| `sceneColorStrength` | `real` | `0.12` | read/write | `Md3LiquidGlass` | Light ambient spill from backdrop (keep low). |
| `samplePadding` | `real` | `28` | read/write | `Md3LiquidGlass` | Sample Padding. |
| `layoutMode` | `int` | `Md3ContainerBody.Fit` | read/write | `Md3LiquidGlass` | Layout Mode. |
| `contentData` | `alias` | `contentHost.content` | default read/write | `Md3LiquidGlass` | Content Data. |
| `dragging` | `bool` | `dragArea.pressed` | readonly | `Md3LiquidGlass` | Dragging. |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3LiquidGlass {
    sourceItem: null
    radius: 28
    elevation: 2
    draggable: true
    boundToParent: true
    squircleN: 5.0
}
```
