# Md3LiquidGlass

Draggable Liquid Glass — regional backdrop sample (not full-scene blur).

- **Source:** `src/Md3/components/Md3LiquidGlass.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `sourceItem` | `Item` | `null` | read/write | `Md3LiquidGlass` | — |
| `radius` | `real` | `28` | read/write | `Md3LiquidGlass` | — |
| `elevation` | `real` | `2` | read/write | `Md3LiquidGlass` | — |
| `draggable` | `bool` | `true` | read/write | `Md3LiquidGlass` | — |
| `boundToParent` | `bool` | `true` | read/write | `Md3LiquidGlass` | — |
| `squircleN` | `real` | `5.0` | read/write | `Md3LiquidGlass` | — |
| `adaptiveTint` | `real` | `0.25` | read/write | `Md3LiquidGlass` | — |
| `liquidDeform` | `real` | `1.0` | read/write | `Md3LiquidGlass` | — |
| `quality` | `int` | `1` | read/write | `Md3LiquidGlass` | 0=Low, 1=Medium, 2=High — scales sample res, frost taps, chroma. |
| `liveSampling` | `bool` | `true` | read/write | `Md3LiquidGlass` | Keep sampling every frame (video). For static images set false — updates on move. |
| `blurAmount` | `real` | `0.18` | read/write | `Md3LiquidGlass` | Lower = clearer glass. |
| `blurMax` | `real` | `64` | read/write | `Md3LiquidGlass` | — |
| `tintOpacity` | `real` | `0.02` | read/write | `Md3LiquidGlass` | — |
| `tintColor` | `color` | `"#FFFFFF"` | read/write | `Md3LiquidGlass` | — |
| `edgeStrength` | `real` | `1.0` | read/write | `Md3LiquidGlass` | — |
| `refraction` | `real` | `1.15` | read/write | `Md3LiquidGlass` | — |
| `chromaticAberration` | `real` | `0.25` | read/write | `Md3LiquidGlass` | — |
| `fusionAmount` | `real` | `0.0` | read/write | `Md3LiquidGlass` | 0..1 SDF blend between the base glass body and droplets. |
| `mergeBody` | `vector4d` | `Qt.vector4d(0, 0, 0, 0)` | read/write | `Md3LiquidGlass` | Second body in UV space `(cx, cy, halfW, halfH)`. |
| `dropletA` | `vector4d` | `Qt.vector4d(0.5, 0.5, 0.0, 0.0)` | read/write | `Md3LiquidGlass` | UV-space droplet: `x, y, radius, enabled`. |
| `dropletB` | `vector4d` | `Qt.vector4d(0.5, 0.5, 0.0, 0.0)` | read/write | `Md3LiquidGlass` | UV-space droplet: `x, y, radius, enabled`. |
| `dropletC` | `vector4d` | `Qt.vector4d(0.5, 0.5, 0.0, 0.0)` | read/write | `Md3LiquidGlass` | UV-space droplet: `x, y, radius, enabled`. |
| `edgeSpectralStrength` | `real` | `1.35` | read/write | `Md3LiquidGlass` | Refracted scene-light color injected into the glass edge. |
| `sceneColorStrength` | `real` | `0.4` | read/write | `Md3LiquidGlass` | Dynamic background color pickup blended into the glass body. |
| `samplePadding` | `real` | `24` | read/write | `Md3LiquidGlass` | — |
| `contentData` | `alias` | `contentHost.data` | default read/write | `Md3LiquidGlass` | Default property → `contentHost.data` |
| `dragging` | `bool` | `dragArea.pressed` | readonly | `Md3LiquidGlass` | — |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3LiquidGlass {
    sourceItem: backdrop
    radius: 28
    elevation: 2
    refraction: 1.35
    fusionAmount: 0.6
    edgeSpectralStrength: 0.9
    sceneColorStrength: 0.55
    dropletA: Qt.vector4d(0.30, 0.34, 0.16, 1.0)
    dropletB: Qt.vector4d(0.68, 0.58, 0.14, 1.0)
    dropletC: Qt.vector4d(0.48, 0.72, 0.10, 1.0)
}
```

## Notes

- **Two-block fusion:** use `Md3LiquidGlassFusionPlayground` (Gallery → **液态玻璃**) — two draggable bodies share one SDF field and mask, so they visually merge when close.
- Single `Md3LiquidGlass` cards use the same SDF mask; optional `mergeBody` can attach a second body in UV space.
- Open Gallery **容器** for multi-card draggable demos; **液态玻璃** for droplet/body fusion.
- `dropletA/B/C` use normalized UV coordinates:
  - `x`, `y`: center in `0..1`
  - `radius`: relative droplet radius
  - `enabled`: `0` = off, `1` = on
- The new edge spectral lighting samples backdrop color near the refracted boundary, so bright or saturated backgrounds will tint the rim automatically.
- The dynamic scene color pickup averages nearby backdrop samples and mixes that hue back into the glass body.
