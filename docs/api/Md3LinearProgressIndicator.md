# Md3LinearProgressIndicator

Linear progress — Standard uses Rectangles; wavy uses QtQuick.Shapes (GPU stroke, RoundJoin, no seams).

- **Source:** `src/Md3/components/Md3LinearProgressIndicator.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Enums

### `Md3LinearProgressIndicator.Style`

`Md3LinearProgressIndicator.Standard`, `Md3LinearProgressIndicator.Wavy`, `Md3LinearProgressIndicator.Lively`, `Md3LinearProgressIndicator.Soft`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `value` | `real` | `0` | read/write | `Md3LinearProgressIndicator` | — |
| `indeterminate` | `bool` | `false` | read/write | `Md3LinearProgressIndicator` | — |
| `enabled` | `bool` | `true` | read/write | `Md3LinearProgressIndicator` | — |
| `style` | `int` | `Md3LinearProgressIndicator.Standard` | read/write | `Md3LinearProgressIndicator` | — |
| `wavelength` | `real` | `style === Md3LinearProgressIndicator.Lively ? 28` | read/write | `Md3LinearProgressIndicator` | — |
| `amplitude` | `real` | `{…}` | read/write | `Md3LinearProgressIndicator` | — |
| `trackThickness` | `real` | `{…}` | read/write | Indicator thickness (active segment). |
| `contained` | `bool` | `true` | Thin track + thicker active segment. |
| `trackLineThickness` | `real` | readonly | Drawn track height when `contained`. |
| `indicatorThickness` | `real` | readonly | Drawn active segment thickness. |
| `wavePhase` | `real` | `0` | read/write | `Md3LinearProgressIndicator` | — |
| `showStopIndicator` | `bool` | `true` | read/write | `Md3LinearProgressIndicator` | — |
| `waveSpeed` | `real` | `Math.PI * 2 / 1.8` | read/write | `Md3LinearProgressIndicator` | — |
| `isWavy` | `bool` | `style !== Md3LinearProgressIndicator.Standard` | readonly | `Md3LinearProgressIndicator` | — |
| `progress` | `real` | `Math.max(0, Math.min(1, value))` | readonly | `Md3LinearProgressIndicator` | — |
| `barWidth` | `real` | `indeterminate ? Math.max(48, width * 0.35) : width * progress` | readonly | `Md3LinearProgressIndicator` | — |
| `_treeShown` | `bool` | `true` | read/write | `Md3LinearProgressIndicator` | — |
| `sceneActive` | `bool` | `enabled && _treeShown` | readonly | `Md3LinearProgressIndicator` | — |
| `travelX` | `real` | `-barWidth` | read/write | `Md3LinearProgressIndicator` | — |

## Signals

_None._

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `rebuildWave()` | `Md3LinearProgressIndicator` | — |

## Example

```qml
import Md3

Md3LinearProgressIndicator {
    value: 0
    indeterminate: false
    style: Md3LinearProgressIndicator.Standard
    wavelength: style === Md3LinearProgressIndicator.Lively ? 28
    amplitude: /* … */
}
```
