# Md3BarChart

Vertical / horizontal / stacked bar chart — zoom/pan/probe like Md3LineChart.

- **Source:** `src/Md3/components/Md3BarChart.qml`
- **Extends:** `Md3Chart`

## Import

```qml
import Md3
```

## Inheritance

[`Md3BarChart`](Md3BarChart.md) → [`Md3Chart`](Md3Chart.md)

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `barGap` | `real` | `0.28` | read/write | `Md3BarChart` | — |
| `barRadius` | `real` | `4` | read/write | `Md3BarChart` | — |
| `stacked` | `bool` | `false` | read/write | `Md3BarChart` | Grouped (side-by-side) vs stacked. |
| `horizontal` | `bool` | `false` | read/write | `Md3BarChart` | Horizontal bars (categories on Y). |
| `values` | `var` | `[]` | read/write | [`Md3Chart`](Md3Chart.md) | — |
| `series` | `var` | `[]` | read/write | [`Md3Chart`](Md3Chart.md) | — |
| `seriesColors` | `var` | `[]` | read/write | [`Md3Chart`](Md3Chart.md) | — |
| `followTheme` | `bool` | `true` | read/write | [`Md3Chart`](Md3Chart.md) | When true, unresolved colors read Md3Theme at rebuild (no per-role bindings). |
| `lineColor` | `color` | `"transparent"` | read/write | [`Md3Chart`](Md3Chart.md) | Explicit colors (alpha > 0) override theme. |
| `fillColor` | `color` | `"transparent"` | read/write | [`Md3Chart`](Md3Chart.md) | — |
| `gridColor` | `color` | `"transparent"` | read/write | [`Md3Chart`](Md3Chart.md) | — |
| `axisLabelColor` | `color` | `"transparent"` | read/write | [`Md3Chart`](Md3Chart.md) | — |
| `backgroundColor` | `color` | `"transparent"` | read/write | [`Md3Chart`](Md3Chart.md) | — |
| `surfaceColor` | `color` | `"transparent"` | read/write | [`Md3Chart`](Md3Chart.md) | — |
| `lineWidth` | `real` | `2.5` | read/write | [`Md3Chart`](Md3Chart.md) | — |
| `showArea` | `bool` | `true` | read/write | [`Md3Chart`](Md3Chart.md) | — |
| `areaOpacity` | `real` | `0.28` | read/write | [`Md3Chart`](Md3Chart.md) | 0–1 multiplier on theme/default area fill (higher = stronger area emphasis). |
| `areaEmphasis` | `bool` | `false` | read/write | [`Md3Chart`](Md3Chart.md) | — |
| `showDots` | `bool` | `false` | read/write | [`Md3Chart`](Md3Chart.md) | — |
| `showGrid` | `bool` | `true` | read/write | [`Md3Chart`](Md3Chart.md) | — |
| `showYLabels` | `bool` | `true` | read/write | [`Md3Chart`](Md3Chart.md) | — |
| `showXLabels` | `bool` | `false` | read/write | [`Md3Chart`](Md3Chart.md) | — |
| `smooth` | `bool` | `true` | read/write | [`Md3Chart`](Md3Chart.md) | — |
| `minY` | `real` | `Number.NaN` | read/write | [`Md3Chart`](Md3Chart.md) | — |
| `maxY` | `real` | `Number.NaN` | read/write | [`Md3Chart`](Md3Chart.md) | — |
| `horizontalGridLines` | `int` | `4` | read/write | [`Md3Chart`](Md3Chart.md) | — |
| `contentPadding` | `real` | `8` | read/write | [`Md3Chart`](Md3Chart.md) | — |
| `labelWidth` | `real` | `showYLabels ? 36 : 0` | read/write | [`Md3Chart`](Md3Chart.md) | — |
| `dotRadius` | `real` | `3` | read/write | [`Md3Chart`](Md3Chart.md) | — |
| `yUnit` | `string` | `""` | read/write | [`Md3Chart`](Md3Chart.md) | — |
| `valueDecimals` | `int` | `0` | read/write | [`Md3Chart`](Md3Chart.md) | — |
| `smoothMaxPoints` | `int` | `400` | read/write | [`Md3Chart`](Md3Chart.md) | — |
| `dotsMaxPoints` | `int` | `80` | read/write | [`Md3Chart`](Md3Chart.md) | — |
| `labels` | `var` | `[]` | read/write | [`Md3Chart`](Md3Chart.md) | Category labels for probe / axes (optional, length ≈ values). |
| `probeTitle` | `string` | `qsTr("Point")` | read/write | [`Md3Chart`](Md3Chart.md) | — |
| `interactive` | `bool` | `true` | read/write | [`Md3Chart`](Md3Chart.md) | Wheel zoom + drag pan + inertia (X window over data). Default on. |
| `showProbe` | `bool` | `true` | read/write | [`Md3Chart`](Md3Chart.md) | Hover/tap nearest-point readout. |
| `viewStart` | `real` | `0` | read/write | [`Md3Chart`](Md3Chart.md) | Visible window in normalized data space [0, 1]. |
| `viewSpan` | `real` | `1` | read/write | [`Md3Chart`](Md3Chart.md) | — |
| `minViewSpan` | `real` | `0.04` | read/write | [`Md3Chart`](Md3Chart.md) | — |
| `panInertia` | `real` | `Md3Theme.effectsChartInertia ? 0.92 : 0` | read/write | [`Md3Chart`](Md3Chart.md) | Inertia decay per second after pan release (0 = hard stop). Overridden by effects level. |
| `probeIndex` | `int` | `-1` | read/write | [`Md3Chart`](Md3Chart.md) | — |
| `probePixelX` | `real` | `0` | read/write | [`Md3Chart`](Md3Chart.md) | — |
| `probePixelY` | `real` | `0` | read/write | [`Md3Chart`](Md3Chart.md) | — |
| `probeActive` | `bool` | `false` | read/write | [`Md3Chart`](Md3Chart.md) | — |
| `probeSeries` | `var` | `[]` | read/write | [`Md3Chart`](Md3Chart.md) | [{ label, value, color }] |
| `gestureActive` | `bool` | `false` | read/write | [`Md3Chart`](Md3Chart.md) | True while user is dragging / wheeling — charts should skip heavy work. |
| `hostWindow` | `var` | `null` | read/write | [`Md3Chart`](Md3Chart.md) | Optional Window for live-motion checks (else OverlayHost). |
| `viewMoving` | `bool` | `gestureActive \|\| Math.abs(_panVelocity) > 1e-5` | readonly | [`Md3Chart`](Md3Chart.md) | True while dragging or coasting — skip Catmull / async Shape to avoid release flicker. |
| `paused` | `bool` | `false` | read/write | [`Md3Chart`](Md3Chart.md) | — |
| `chartActive` | `bool` | `!paused && enabled` | readonly | [`Md3Chart`](Md3Chart.md) | Page/window/app visibility — no per-scroll mapToItem (that starved the UI thread / rail). |
| `renderedPointCount` | `int` | `0` | read/write | [`Md3Chart`](Md3Chart.md) | — |
| `plotLeft` | `real` | `contentPadding + labelWidth` | readonly | [`Md3Chart`](Md3Chart.md) | — |
| `plotRight` | `real` | `width - contentPadding` | readonly | [`Md3Chart`](Md3Chart.md) | — |
| `plotTop` | `real` | `contentPadding + 4` | readonly | [`Md3Chart`](Md3Chart.md) | — |
| `plotBottom` | `real` | `height - contentPadding - (showXLabels ? 16 : 0)` | readonly | [`Md3Chart`](Md3Chart.md) | — |
| `plotWidth` | `real` | `Math.max(1, plotRight - plotLeft)` | readonly | [`Md3Chart`](Md3Chart.md) | — |
| `plotHeight` | `real` | `Math.max(1, plotBottom - plotTop)` | readonly | [`Md3Chart`](Md3Chart.md) | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `cleared()` | [`Md3Chart`](Md3Chart.md) | — |
| `rebuilt()` | [`Md3Chart`](Md3Chart.md) | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `rebuild()` | `Md3BarChart` | — |
| `resolvedLineColor()` | [`Md3Chart`](Md3Chart.md) | — |
| `resolvedFillColor()` | [`Md3Chart`](Md3Chart.md) | — |
| `resolvedGridColor()` | [`Md3Chart`](Md3Chart.md) | — |
| `resolvedAxisLabelColor()` | [`Md3Chart`](Md3Chart.md) | — |
| `resolvedSurfaceColor()` | [`Md3Chart`](Md3Chart.md) | — |
| `colorAt(index)` | [`Md3Chart`](Md3Chart.md) | — |
| `asNumber(v)` | [`Md3Chart`](Md3Chart.md) | — |
| `seriesNums(s)` | [`Md3Chart`](Md3Chart.md) | — |
| `rangeFromSeries(all)` | [`Md3Chart`](Md3Chart.md) | — |
| `requestRebuild()` | [`Md3Chart`](Md3Chart.md) | — |
| `pause()` | [`Md3Chart`](Md3Chart.md) | — |
| `resume()` | [`Md3Chart`](Md3Chart.md) | — |
| `clear()` | [`Md3Chart`](Md3Chart.md) | — |
| `fitY()` | [`Md3Chart`](Md3Chart.md) | — |
| `setValues(list)` | [`Md3Chart`](Md3Chart.md) | — |
| `resetView()` | [`Md3Chart`](Md3Chart.md) | — |
| `clampView()` | [`Md3Chart`](Md3Chart.md) | — |
| `beginGesture()` | [`Md3Chart`](Md3Chart.md) | — |
| `endGesture()` | [`Md3Chart`](Md3Chart.md) | — |
| `zoomAt(frac, factor)` | [`Md3Chart`](Md3Chart.md) | Zoom centered on frac in [0,1] of plot width (0=left). |
| `panByFrac(delta, trackVelocity)` | [`Md3Chart`](Md3Chart.md) | — |
| `setProbe(index, pixelX, seriesInfo, pixelY)` | [`Md3Chart`](Md3Chart.md) | — |
| `clearProbe()` | [`Md3Chart`](Md3Chart.md) | — |
| `categoryLabel(index)` | [`Md3Chart`](Md3Chart.md) | — |
| `windowIndices(n)` | [`Md3Chart`](Md3Chart.md) | Visible sample window for length-n series under viewStart/viewSpan. |
| `indexAtPlotX(px, n)` | [`Md3Chart`](Md3Chart.md) | — |
| `plotXForIndex(index, n)` | [`Md3Chart`](Md3Chart.md) | — |

## Example

```qml
import Md3

Md3BarChart {
    barGap: 0.28
    barRadius: 4
    stacked: false
    horizontal: false
    values: []
}
```
