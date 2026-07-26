# Md3Chart

Base for all Md3 charts — shared plot metrics, theme resolve, pause/rebuild API.

- **Source:** `src/Md3/components/Md3Chart.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `values` | `var` | `[]` | read/write | `Md3Chart` | — |
| `series` | `var` | `[]` | read/write | `Md3Chart` | — |
| `seriesColors` | `var` | `[]` | read/write | `Md3Chart` | — |
| `followTheme` | `bool` | `true` | read/write | `Md3Chart` | When true, unresolved colors read Md3Theme at rebuild (no per-role bindings). |
| `lineColor` | `color` | `"transparent"` | read/write | `Md3Chart` | Explicit colors (alpha > 0) override theme. |
| `fillColor` | `color` | `"transparent"` | read/write | `Md3Chart` | — |
| `gridColor` | `color` | `"transparent"` | read/write | `Md3Chart` | — |
| `axisLabelColor` | `color` | `"transparent"` | read/write | `Md3Chart` | — |
| `backgroundColor` | `color` | `"transparent"` | read/write | `Md3Chart` | — |
| `surfaceColor` | `color` | `"transparent"` | read/write | `Md3Chart` | — |
| `lineWidth` | `real` | `2.5` | read/write | `Md3Chart` | — |
| `showArea` | `bool` | `true` | read/write | `Md3Chart` | — |
| `showDots` | `bool` | `false` | read/write | `Md3Chart` | — |
| `showGrid` | `bool` | `true` | read/write | `Md3Chart` | — |
| `showYLabels` | `bool` | `true` | read/write | `Md3Chart` | — |
| `showXLabels` | `bool` | `false` | read/write | `Md3Chart` | — |
| `smooth` | `bool` | `true` | read/write | `Md3Chart` | — |
| `minY` | `real` | `Number.NaN` | read/write | `Md3Chart` | — |
| `maxY` | `real` | `Number.NaN` | read/write | `Md3Chart` | — |
| `horizontalGridLines` | `int` | `4` | read/write | `Md3Chart` | — |
| `contentPadding` | `real` | `8` | read/write | `Md3Chart` | — |
| `labelWidth` | `real` | `showYLabels ? 36 : 0` | read/write | `Md3Chart` | — |
| `dotRadius` | `real` | `3` | read/write | `Md3Chart` | — |
| `yUnit` | `string` | `""` | read/write | `Md3Chart` | — |
| `valueDecimals` | `int` | `0` | read/write | `Md3Chart` | — |
| `smoothMaxPoints` | `int` | `400` | read/write | `Md3Chart` | — |
| `dotsMaxPoints` | `int` | `80` | read/write | `Md3Chart` | — |
| `labels` | `var` | `[]` | read/write | `Md3Chart` | Category labels for probe / axes (optional, length ≈ values). |
| `probeTitle` | `string` | `qsTr("Point")` | read/write | `Md3Chart` | — |
| `interactive` | `bool` | `true` | read/write | `Md3Chart` | Wheel zoom + drag pan + inertia (X window over data). Default on. |
| `showProbe` | `bool` | `true` | read/write | `Md3Chart` | Hover/tap nearest-point readout. |
| `viewStart` | `real` | `0` | read/write | `Md3Chart` | Visible window in normalized data space [0, 1]. |
| `viewSpan` | `real` | `1` | read/write | `Md3Chart` | — |
| `minViewSpan` | `real` | `0.04` | read/write | `Md3Chart` | — |
| `panInertia` | `real` | `0.92` | read/write | `Md3Chart` | Inertia decay per second after pan release (0 = hard stop). |
| `probeIndex` | `int` | `-1` | read/write | `Md3Chart` | — |
| `probePixelX` | `real` | `0` | read/write | `Md3Chart` | — |
| `probePixelY` | `real` | `0` | read/write | `Md3Chart` | — |
| `probeActive` | `bool` | `false` | read/write | `Md3Chart` | — |
| `probeSeries` | `var` | `[]` | read/write | `Md3Chart` | [{ label, value, color }] |
| `gestureActive` | `bool` | `false` | read/write | `Md3Chart` | True while user is dragging / wheeling — charts should skip heavy work. |
| `_panVelocity` | `real` | `0` | read/write | `Md3Chart` | — |
| `_viewDirty` | `bool` | `false` | read/write | `Md3Chart` | — |
| `paused` | `bool` | `false` | read/write | `Md3Chart` | — |
| `interactionBlocked` | `bool` | `{…}` | readonly | `Md3Chart` | Only block when minimized/hidden — never for theme reveal. |
| `chartActive` | `bool` | `!paused && !interactionBlocked && enabled` | readonly | `Md3Chart` | — |
| `renderedPointCount` | `int` | `0` | read/write | `Md3Chart` | — |
| `plotLeft` | `real` | `contentPadding + labelWidth` | readonly | `Md3Chart` | — |
| `plotRight` | `real` | `width - contentPadding` | readonly | `Md3Chart` | — |
| `plotTop` | `real` | `contentPadding + 4` | readonly | `Md3Chart` | — |
| `plotBottom` | `real` | `height - contentPadding - (showXLabels ? 16 : 0)` | readonly | `Md3Chart` | — |
| `plotWidth` | `real` | `Math.max(1, plotRight - plotLeft)` | readonly | `Md3Chart` | — |
| `plotHeight` | `real` | `Math.max(1, plotBottom - plotTop)` | readonly | `Md3Chart` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `cleared()` | `Md3Chart` | — |
| `rebuilt()` | `Md3Chart` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `resolvedLineColor()` | `Md3Chart` | — |
| `resolvedFillColor()` | `Md3Chart` | — |
| `resolvedGridColor()` | `Md3Chart` | — |
| `resolvedAxisLabelColor()` | `Md3Chart` | — |
| `resolvedSurfaceColor()` | `Md3Chart` | — |
| `colorAt(index)` | `Md3Chart` | — |
| `asNumber(v)` | `Md3Chart` | — |
| `seriesNums(s)` | `Md3Chart` | — |
| `rangeFromSeries(all)` | `Md3Chart` | — |
| `rebuild()` | `Md3Chart` | — |
| `requestRebuild()` | `Md3Chart` | — |
| `pause()` | `Md3Chart` | — |
| `resume()` | `Md3Chart` | — |
| `clear()` | `Md3Chart` | — |
| `fitY()` | `Md3Chart` | — |
| `setValues(list)` | `Md3Chart` | — |
| `resetView()` | `Md3Chart` | — |
| `clampView()` | `Md3Chart` | — |
| `beginGesture()` | `Md3Chart` | — |
| `endGesture()` | `Md3Chart` | — |
| `zoomAt(frac, factor)` | `Md3Chart` | Zoom centered on frac in [0,1] of plot width (0=left). |
| `panByFrac(delta, trackVelocity)` | `Md3Chart` | — |
| `setProbe(index, pixelX, seriesInfo, pixelY)` | `Md3Chart` | — |
| `clearProbe()` | `Md3Chart` | — |
| `categoryLabel(index)` | `Md3Chart` | — |
| `windowIndices(n)` | `Md3Chart` | Visible sample window for length-n series under viewStart/viewSpan. |
| `indexAtPlotX(px, n)` | `Md3Chart` | — |
| `plotXForIndex(index, n)` | `Md3Chart` | — |

## Example

```qml
import Md3

Md3Chart {
    values: []
    series: []
    seriesColors: []
    followTheme: true
    lineColor: "transparent"
}
```
