# Md3BarChart

Vertical / horizontal / stacked bar chart — zoom/pan/probe like Md3LineChart. Bars + grid drawn on one Canvas (no per-bar Rectangle Repeater).

- **Source:** `src/Md3/components/Md3BarChart.qml`
- **Extends:** `Md3Chart`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 4 | 0 | 2 | 0 |

## Import

```qml
import Md3
```

## Inheritance

[`Md3BarChart`](Md3BarChart.md) → [`Md3Chart`](Md3Chart.md)

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `barGap` | `real` | `0.28` | read/write | `Md3BarChart` | Bar Gap. |
| `barRadius` | `real` | `4` | read/write | `Md3BarChart` | Bar Radius. |
| `stacked` | `bool` | `false` | read/write | `Md3BarChart` | Grouped (side-by-side) vs stacked. |
| `horizontal` | `bool` | `false` | read/write | `Md3BarChart` | Horizontal bars (categories on Y). |
| `values` | `var` | `[]` | read/write | [`Md3Chart`](Md3Chart.md) | Values. |
| `series` | `var` | `[]` | read/write | [`Md3Chart`](Md3Chart.md) | Series. |
| `seriesColors` | `var` | `[]` | read/write | [`Md3Chart`](Md3Chart.md) | Series Colors. |
| `followTheme` | `bool` | `true` | read/write | [`Md3Chart`](Md3Chart.md) | When true, unresolved colors read Md3Theme at rebuild (no per-role bindings). |
| `lineColor` | `color` | `"transparent"` | read/write | [`Md3Chart`](Md3Chart.md) | Explicit colors (alpha > 0) override theme. |
| `fillColor` | `color` | `"transparent"` | read/write | [`Md3Chart`](Md3Chart.md) | Fill Color. |
| `gridColor` | `color` | `"transparent"` | read/write | [`Md3Chart`](Md3Chart.md) | Grid Color. |
| `axisLabelColor` | `color` | `"transparent"` | read/write | [`Md3Chart`](Md3Chart.md) | Axis Label Color. |
| `backgroundColor` | `color` | `"transparent"` | read/write | [`Md3Chart`](Md3Chart.md) | Background Color. |
| `surfaceColor` | `color` | `"transparent"` | read/write | [`Md3Chart`](Md3Chart.md) | Surface Color. |
| `lineWidth` | `real` | `2.5` | read/write | [`Md3Chart`](Md3Chart.md) | Line Width. |
| `showArea` | `bool` | `true` | read/write | [`Md3Chart`](Md3Chart.md) | Show Area. |
| `areaOpacity` | `real` | `0.28` | read/write | [`Md3Chart`](Md3Chart.md) | 0–1 multiplier on theme/default area fill (higher = stronger area emphasis). |
| `areaEmphasis` | `bool` | `false` | read/write | [`Md3Chart`](Md3Chart.md) | Area Emphasis. |
| `showDots` | `bool` | `false` | read/write | [`Md3Chart`](Md3Chart.md) | Show Dots. |
| `showGrid` | `bool` | `true` | read/write | [`Md3Chart`](Md3Chart.md) | Show Grid. |
| `showYLabels` | `bool` | `true` | read/write | [`Md3Chart`](Md3Chart.md) | Show YLabels. |
| `showXLabels` | `bool` | `false` | read/write | [`Md3Chart`](Md3Chart.md) | Show XLabels. |
| `smooth` | `bool` | `true` | read/write | [`Md3Chart`](Md3Chart.md) | Smooth. |
| `minY` | `real` | `Number.NaN` | read/write | [`Md3Chart`](Md3Chart.md) | Min Y. |
| `maxY` | `real` | `Number.NaN` | read/write | [`Md3Chart`](Md3Chart.md) | Max Y. |
| `horizontalGridLines` | `int` | `4` | read/write | [`Md3Chart`](Md3Chart.md) | Horizontal Grid Lines. |
| `contentPadding` | `real` | `8` | read/write | [`Md3Chart`](Md3Chart.md) | Content Padding. |
| `labelWidth` | `real` | `showYLabels ? 36 : 0` | read/write | [`Md3Chart`](Md3Chart.md) | Label Width. |
| `dotRadius` | `real` | `3` | read/write | [`Md3Chart`](Md3Chart.md) | Dot Radius. |
| `yUnit` | `string` | `""` | read/write | [`Md3Chart`](Md3Chart.md) | Y Unit. |
| `valueDecimals` | `int` | `0` | read/write | [`Md3Chart`](Md3Chart.md) | Value Decimals. |
| `smoothMaxPoints` | `int` | `400` | read/write | [`Md3Chart`](Md3Chart.md) | Smooth Max Points. |
| `dotsMaxPoints` | `int` | `80` | read/write | [`Md3Chart`](Md3Chart.md) | Dots Max Points. |
| `labels` | `var` | `[]` | read/write | [`Md3Chart`](Md3Chart.md) | Category labels for probe / axes (optional, length ≈ values). |
| `probeTitle` | `string` | `qsTr("Point")` | read/write | [`Md3Chart`](Md3Chart.md) | Probe Title. |
| `interactive` | `bool` | `true` | read/write | [`Md3Chart`](Md3Chart.md) | Wheel zoom + drag pan + inertia (X window over data). Default on. |
| `showProbe` | `bool` | `true` | read/write | [`Md3Chart`](Md3Chart.md) | Hover/tap nearest-point readout. |
| `viewStart` | `real` | `0` | read/write | [`Md3Chart`](Md3Chart.md) | Visible window in normalized data space [0, 1]. |
| `viewSpan` | `real` | `1` | read/write | [`Md3Chart`](Md3Chart.md) | View Span. |
| `minViewSpan` | `real` | `0.04` | read/write | [`Md3Chart`](Md3Chart.md) | Min View Span. |
| `panInertia` | `real` | `Md3Theme.effectsChartInertia ? 0.92 : 0` | read/write | [`Md3Chart`](Md3Chart.md) | Inertia decay per second after pan release (0 = hard stop). Overridden by effects level. |
| `probeIndex` | `int` | `-1` | read/write | [`Md3Chart`](Md3Chart.md) | Probe Index. |
| `probePixelX` | `real` | `0` | read/write | [`Md3Chart`](Md3Chart.md) | Probe Pixel X. |
| `probePixelY` | `real` | `0` | read/write | [`Md3Chart`](Md3Chart.md) | Probe Pixel Y. |
| `probeActive` | `bool` | `false` | read/write | [`Md3Chart`](Md3Chart.md) | Probe Active. |
| `probeSeries` | `var` | `[]` | read/write | [`Md3Chart`](Md3Chart.md) | [{ label, value, color }] |
| `gestureActive` | `bool` | `false` | read/write | [`Md3Chart`](Md3Chart.md) | True while user is dragging / wheeling — charts should skip heavy work. |
| `hostWindow` | `var` | `null` | read/write | [`Md3Chart`](Md3Chart.md) | Optional Window for live-motion checks (else OverlayHost). |
| `viewMoving` | `bool` | `gestureActive \|\| Math.abs(_panVelocity) > 1e-5` | readonly | [`Md3Chart`](Md3Chart.md) | True while dragging or coasting — skip Catmull / async Shape to avoid release flicker. |
| `paused` | `bool` | `false` | read/write | [`Md3Chart`](Md3Chart.md) | Paused. |
| `unloadWhenPageInactive` | `bool` | `true` | read/write | [`Md3Chart`](Md3Chart.md) | Drop Canvas/Shape while page is off-display (PageHost `md3PageActive`). |
| `chartActive` | `bool` | `!paused && enabled && pageGate.contentActive` | readonly | [`Md3Chart`](Md3Chart.md) | Page/window/app visibility — Gate tracks `md3PageActive` (bindings alone do not). |
| `renderedPointCount` | `int` | `0` | read/write | [`Md3Chart`](Md3Chart.md) | Rendered Point Count. |
| `plotLeft` | `real` | `contentPadding + labelWidth` | readonly | [`Md3Chart`](Md3Chart.md) | Plot Left. |
| `plotRight` | `real` | `width - contentPadding` | readonly | [`Md3Chart`](Md3Chart.md) | Plot Right. |
| `plotTop` | `real` | `contentPadding + 4` | readonly | [`Md3Chart`](Md3Chart.md) | Plot Top. |
| `plotBottom` | `real` | `height - contentPadding - (showXLabels ? 16 : 0)` | readonly | [`Md3Chart`](Md3Chart.md) | Plot Bottom. |
| `plotWidth` | `real` | `Math.max(1, plotRight - plotLeft)` | readonly | [`Md3Chart`](Md3Chart.md) | Plot Width. |
| `plotHeight` | `real` | `Math.max(1, plotBottom - plotTop)` | readonly | [`Md3Chart`](Md3Chart.md) | Plot Height. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `cleared()` | [`Md3Chart`](Md3Chart.md) | Emitted when cleared. |
| `rebuilt()` | [`Md3Chart`](Md3Chart.md) | Emitted when rebuilt. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `rebuild()` | `—` | `Md3BarChart` | Rebuild. |
| `nudgeProbe(delta)` | `—` | `Md3BarChart` | Nudge Probe. |
| `resolvedLineColor()` | `—` | [`Md3Chart`](Md3Chart.md) | Resolved Line Color. |
| `resolvedFillColor()` | `—` | [`Md3Chart`](Md3Chart.md) | Resolved Fill Color. |
| `resolvedGridColor()` | `—` | [`Md3Chart`](Md3Chart.md) | Resolved Grid Color. |
| `resolvedAxisLabelColor()` | `—` | [`Md3Chart`](Md3Chart.md) | Resolved Axis Label Color. |
| `resolvedSurfaceColor()` | `—` | [`Md3Chart`](Md3Chart.md) | Resolved Surface Color. |
| `colorAt(index)` | `—` | [`Md3Chart`](Md3Chart.md) | Color At. |
| `asNumber(v)` | `—` | [`Md3Chart`](Md3Chart.md) | As Number. |
| `seriesNums(s)` | `—` | [`Md3Chart`](Md3Chart.md) | Series Nums. |
| `rangeFromSeries(all)` | `—` | [`Md3Chart`](Md3Chart.md) | Range From Series. |
| `requestRebuild()` | `—` | [`Md3Chart`](Md3Chart.md) | Request Rebuild. |
| `pause()` | `—` | [`Md3Chart`](Md3Chart.md) | Pause. |
| `resume()` | `—` | [`Md3Chart`](Md3Chart.md) | Resume. |
| `clear()` | `—` | [`Md3Chart`](Md3Chart.md) | Clear value / selection. |
| `fitY()` | `—` | [`Md3Chart`](Md3Chart.md) | Fit Y. |
| `setValues(list)` | `—` | [`Md3Chart`](Md3Chart.md) | Set Values. |
| `resetView()` | `—` | [`Md3Chart`](Md3Chart.md) | Reset View. |
| `clampView()` | `—` | [`Md3Chart`](Md3Chart.md) | Clamp View. |
| `beginGesture()` | `—` | [`Md3Chart`](Md3Chart.md) | Begin Gesture. |
| `endGesture()` | `—` | [`Md3Chart`](Md3Chart.md) | End Gesture. |
| `zoomAt(frac, factor)` | `—` | [`Md3Chart`](Md3Chart.md) | Zoom centered on frac in [0,1] of plot width (0=left). |
| `panByFrac(delta, trackVelocity)` | `—` | [`Md3Chart`](Md3Chart.md) | Pan By Frac. |
| `setProbe(index, pixelX, seriesInfo, pixelY)` | `—` | [`Md3Chart`](Md3Chart.md) | Set Probe. |
| `clearProbe()` | `—` | [`Md3Chart`](Md3Chart.md) | Clear Probe. |
| `categoryLabel(index)` | `—` | [`Md3Chart`](Md3Chart.md) | Category Label. |
| `windowIndices(n)` | `—` | [`Md3Chart`](Md3Chart.md) | Visible sample window for length-n series under viewStart/viewSpan. |
| `indexAtPlotX(px, n)` | `—` | [`Md3Chart`](Md3Chart.md) | Index At Plot X. |
| `plotXForIndex(index, n)` | `—` | [`Md3Chart`](Md3Chart.md) | Plot XFor Index. |

## Example

```qml
import Md3

Md3BarChart {
    barGap: 0.28
    barRadius: 4
    stacked: false
    horizontal: false
    values: []
    series: []
}
```
