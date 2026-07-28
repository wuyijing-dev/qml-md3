# Md3CircularProgressIndicator

Circular progress — Standard animates PathAngleArc in-place; wavy uses sparse polyline.

- **Source:** `src/Md3/components/Md3CircularProgressIndicator.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Enums

### `Md3CircularProgressIndicator.Style`

`Md3CircularProgressIndicator.Standard`, `Md3CircularProgressIndicator.Wavy`, `Md3CircularProgressIndicator.Lively`, `Md3CircularProgressIndicator.Soft`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `value` | `real` | `0` | read/write | `Md3CircularProgressIndicator` | — |
| `indeterminate` | `bool` | `true` | read/write | `Md3CircularProgressIndicator` | — |
| `style` | `int` | `Md3CircularProgressIndicator.Standard` | read/write | `Md3CircularProgressIndicator` | — |
| `strokeWidth` | `real` | `{…}` | read/write | `Md3CircularProgressIndicator` | — |
| `size` | `real` | `style === Md3CircularProgressIndicator.Standard ? 48 : 52` | read/write | `Md3CircularProgressIndicator` | — |
| `amplitude` | `real` | `{…}` | read/write | `Md3CircularProgressIndicator` | — |
| `waveCount` | `int` | `{…}` | read/write | `Md3CircularProgressIndicator` | — |
| `wavePhase` | `real` | `0` | read/write | `Md3CircularProgressIndicator` | — |
| `rotation` | `real` | `-Math.PI / 2` | read/write | `Md3CircularProgressIndicator` | — |
| `sweep` | `real` | `Math.PI * 0.55` | read/write | `Md3CircularProgressIndicator` | — |
| `waveSpeed` | `real` | `Math.PI * 2 / 1.8` | read/write | `Md3CircularProgressIndicator` | — |
| `spinSpeed` | `real` | `Math.PI * 2 / (Md3Motion.progressSpin / 1000)` | read/write | `Md3CircularProgressIndicator` | — |
| `contained` | `bool` | `true` | read/write | `Md3CircularProgressIndicator` | Thin track + thicker active arc (M3 expressive). |
| `trackLineWidth` | `real` | `contained` | readonly | `Md3CircularProgressIndicator` | — |
| `indicatorLineWidth` | `real` | `strokeWidth` | readonly | `Md3CircularProgressIndicator` | — |
| `sweepMin` | `real` | `Math.PI * 0.28` | readonly | `Md3CircularProgressIndicator` | — |
| `sweepMax` | `real` | `Math.PI * 1.15` | readonly | `Md3CircularProgressIndicator` | — |
| `isWavy` | `bool` | `style !== Md3CircularProgressIndicator.Standard` | readonly | `Md3CircularProgressIndicator` | — |
| `sceneActive` | `bool` | `enabled && _treeShown` | readonly | `Md3CircularProgressIndicator` | — |
| `radius` | `real` | `Math.min(width, height) / 2 - indicatorLineWidth - (isWavy ? amplitude : 0)` | readonly | `Md3CircularProgressIndicator` | — |
| `sweepDir` | `real` | `1` | read/write | `Md3CircularProgressIndicator` | — |

## Signals

_None._

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `radToDeg(r)` | `Md3CircularProgressIndicator` | — |
| `rebuildWavy()` | `Md3CircularProgressIndicator` | — |
| `syncStandardArc()` | `Md3CircularProgressIndicator` | — |

## Example

```qml
import Md3

Md3CircularProgressIndicator {
    value: 0
    indeterminate: true
    style: Md3CircularProgressIndicator.Standard
    strokeWidth: /* … */
    size: style === Md3CircularProgressIndicator.Standard ? 48 : 52
}
```
