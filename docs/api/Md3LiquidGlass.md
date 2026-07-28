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
| `adaptiveTint` | `real` | `1.0` | read/write | `Md3LiquidGlass` | — |
| `liquidDeform` | `real` | `1.0` | read/write | `Md3LiquidGlass` | — |
| `quality` | `int` | `1` | read/write | `Md3LiquidGlass` | 0=Low, 1=Medium, 2=High — scales sample res, frost taps, chroma. |
| `liveSampling` | `bool` | `true` | read/write | `Md3LiquidGlass` | Keep sampling every frame (video). For static images set false — updates on move. |
| `blurAmount` | `real` | `0.45` | read/write | `Md3LiquidGlass` | — |
| `blurMax` | `real` | `64` | read/write | `Md3LiquidGlass` | — |
| `tintOpacity` | `real` | `0.08` | read/write | `Md3LiquidGlass` | — |
| `tintColor` | `color` | `"#FFFFFF"` | read/write | `Md3LiquidGlass` | — |
| `edgeStrength` | `real` | `0.9` | read/write | `Md3LiquidGlass` | — |
| `refraction` | `real` | `1.2` | read/write | `Md3LiquidGlass` | — |
| `chromaticAberration` | `real` | `0.5` | read/write | `Md3LiquidGlass` | — |
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
    sourceItem: null
    radius: 28
    elevation: 2
    draggable: true
    boundToParent: true
}
```
