# Md3LiquidGlass

Draggable Liquid Glass — regional backdrop sample (not full-scene blur).

- **Source:** `src/Md3/components/Md3LiquidGlass.qml`
- **Extends:** `Item`
- **Stability:** **Experimental** (API and behavior may change)

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
| `adaptiveTint` | `real` | `0.85` | read/write | `Md3LiquidGlass` | — |
| `liquidDeform` | `real` | `1.0` | read/write | `Md3LiquidGlass` | — |
| `quality` | `int` | `2` | read/write | `Md3LiquidGlass` | 0=Low, 1=Medium, 2=High — scales sample res, frost taps, chroma. |
| `liveSampling` | `bool` | `true` | read/write | `Md3LiquidGlass` | Keep sampling every frame (video). For static images set false — updates on move. |
| `blurAmount` | `real` | `0.4` | read/write | `Md3LiquidGlass` | Frost strength; lower = clearer glass. |
| `blurMax` | `real` | `64` | read/write | `Md3LiquidGlass` | — |
| `tintOpacity` | `real` | `0.08` | read/write | `Md3LiquidGlass` | — |
| `tintColor` | `color` | `"#FFFFFF"` | read/write | `Md3LiquidGlass` | — |
| `edgeStrength` | `real` | `0.9` | read/write | `Md3LiquidGlass` | UI overlay rim strength. |
| `refraction` | `real` | `1.2` | read/write | `Md3LiquidGlass` | Maps toward IOR ≈ 1.5 (glass) via Snell's Law slope. |
| `chromaticAberration` | `real` | `0.5` | read/write | `Md3LiquidGlass` | Subtle R/G/B IOR split (`±dispersion×0.02`). |
| `fusionAmount` | `real` | `0.0` | read/write | `Md3LiquidGlass` | 0..1 SDF blend between the base glass body and droplets. |
| `mergeBody` | `vector4d` | `Qt.vector4d(0, 0, 0, 0)` | read/write | `Md3LiquidGlass` | Second body in UV space `(cx, cy, halfW, halfH)`. |
| `dropletA` | `vector4d` | `Qt.vector4d(0.5, 0.5, 0.0, 0.0)` | read/write | `Md3LiquidGlass` | UV-space droplet: `x, y, radius, enabled`. |
| `dropletB` | `vector4d` | `Qt.vector4d(0.5, 0.5, 0.0, 0.0)` | read/write | `Md3LiquidGlass` | UV-space droplet: `x, y, radius, enabled`. |
| `dropletC` | `vector4d` | `Qt.vector4d(0.5, 0.5, 0.0, 0.0)` | read/write | `Md3LiquidGlass` | UV-space droplet: `x, y, radius, enabled`. |
| `edgeSpectralStrength` | `real` | `0.7` | read/write | `Md3LiquidGlass` | White Fresnel rim + specular strength. |
| `sceneColorStrength` | `real` | `0.12` | read/write | `Md3LiquidGlass` | Light ambient spill from backdrop. |
| `samplePadding` | `real` | `28` | read/write | `Md3LiquidGlass` | — |
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
    refraction: 1.2
    blurAmount: 0.4
    chromaticAberration: 0.5
    edgeSpectralStrength: 0.7
}
```

## Notes

- Lens math follows open recreations ([kennsorr/glass-lens-effect](https://github.com/kennsorr/glass-lens-effect), [glass-gl](https://github.com/wiiiimm/glass-gl)): Snell's Law `surfaceSlope`, subtle chroma (`±0.02×dispersion`), white Fresnel rim.
- Gallery 默认不展示 Liquid Glass；请在业务中按需接入，并先完成性能与兼容性验证。
- 融合能力参见 `Md3LiquidGlassFusionPlayground`，同属 Experimental。
- `dropletA/B/C` use normalized UV coordinates:
  - `x`, `y`: center in `0..1`
  - `radius`: relative droplet radius
  - `enabled`: `0` = off, `1` = on
- The new edge spectral lighting samples backdrop color near the refracted boundary, so bright or saturated backgrounds will tint the rim automatically.
- The dynamic scene color pickup averages nearby backdrop samples and mixes that hue back into the glass body.
