# Md3Chart

Base for all Md3 charts — shared plot metrics, theme resolve, pause/rebuild API.

- **Source:** `src/Md3/components/Md3Chart.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 55 | 2 | 29 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `values` | `var` | `[]` | read/write | `Md3Chart` | Values. |
| `series` | `var` | `[]` | read/write | `Md3Chart` | Series. |
| `seriesColors` | `var` | `[]` | read/write | `Md3Chart` | Series Colors. |
| `followTheme` | `bool` | `true` | read/write | `Md3Chart` | When true, unresolved colors read Md3Theme at rebuild (no per-role bindings). |
| `lineColor` | `color` | `"transparent"` | read/write | `Md3Chart` | Explicit colors (alpha > 0) override theme. |
| `fillColor` | `color` | `"transparent"` | read/write | `Md3Chart` | Fill Color. |
| `gridColor` | `color` | `"transparent"` | read/write | `Md3Chart` | Grid Color. |
| `axisLabelColor` | `color` | `"transparent"` | read/write | `Md3Chart` | Axis Label Color. |
| `backgroundColor` | `color` | `"transparent"` | read/write | `Md3Chart` | Background Color. |
| `surfaceColor` | `color` | `"transparent"` | read/write | `Md3Chart` | Surface Color. |
| `lineWidth` | `real` | `2.5` | read/write | `Md3Chart` | Line Width. |
| `showArea` | `bool` | `true` | read/write | `Md3Chart` | Show Area. |
| `areaOpacity` | `real` | `0.28` | read/write | `Md3Chart` | 0–1 multiplier on theme/default area fill (higher = stronger area emphasis). |
| `areaEmphasis` | `bool` | `false` | read/write | `Md3Chart` | Area Emphasis. |
| `showDots` | `bool` | `false` | read/write | `Md3Chart` | Show Dots. |
| `showGrid` | `bool` | `true` | read/write | `Md3Chart` | Show Grid. |
| `showYLabels` | `bool` | `true` | read/write | `Md3Chart` | Show YLabels. |
| `showXLabels` | `bool` | `false` | read/write | `Md3Chart` | Show XLabels. |
| `smooth` | `bool` | `true` | read/write | `Md3Chart` | Smooth. |
| `minY` | `real` | `Number.NaN` | read/write | `Md3Chart` | Min Y. |
| `maxY` | `real` | `Number.NaN` | read/write | `Md3Chart` | Max Y. |
| `horizontalGridLines` | `int` | `4` | read/write | `Md3Chart` | Horizontal Grid Lines. |
| `contentPadding` | `real` | `8` | read/write | `Md3Chart` | Content Padding. |
| `labelWidth` | `real` | `showYLabels ? 36 : 0` | read/write | `Md3Chart` | Label Width. |
| `dotRadius` | `real` | `3` | read/write | `Md3Chart` | Dot Radius. |
| `yUnit` | `string` | `""` | read/write | `Md3Chart` | Y Unit. |
| `valueDecimals` | `int` | `0` | read/write | `Md3Chart` | Value Decimals. |
| `smoothMaxPoints` | `int` | `400` | read/write | `Md3Chart` | Smooth Max Points. |
| `dotsMaxPoints` | `int` | `80` | read/write | `Md3Chart` | Dots Max Points. |
| `labels` | `var` | `[]` | read/write | `Md3Chart` | Category labels for probe / axes (optional, length ≈ values). |
| `probeTitle` | `string` | `qsTr("Point")` | read/write | `Md3Chart` | Probe Title. |
| `interactive` | `bool` | `true` | read/write | `Md3Chart` | Wheel zoom + drag pan + inertia (X window over data). Default on. |
| `showProbe` | `bool` | `true` | read/write | `Md3Chart` | Hover/tap nearest-point readout. |
| `viewStart` | `real` | `0` | read/write | `Md3Chart` | Visible window in normalized data space [0, 1]. |
| `viewSpan` | `real` | `1` | read/write | `Md3Chart` | View Span. |
| `minViewSpan` | `real` | `0.04` | read/write | `Md3Chart` | Min View Span. |
| `panInertia` | `real` | `Md3Theme.effectsChartInertia ? 0.92 : 0` | read/write | `Md3Chart` | Inertia decay per second after pan release (0 = hard stop). Overridden by effects level. |
| `probeIndex` | `int` | `-1` | read/write | `Md3Chart` | Probe Index. |
| `probePixelX` | `real` | `0` | read/write | `Md3Chart` | Probe Pixel X. |
| `probePixelY` | `real` | `0` | read/write | `Md3Chart` | Probe Pixel Y. |
| `probeActive` | `bool` | `false` | read/write | `Md3Chart` | Probe Active. |
| `probeSeries` | `var` | `[]` | read/write | `Md3Chart` | [{ label, value, color }] |
| `gestureActive` | `bool` | `false` | read/write | `Md3Chart` | True while user is dragging / wheeling — charts should skip heavy work. |
| `hostWindow` | `var` | `null` | read/write | `Md3Chart` | Optional Window for live-motion checks (else OverlayHost). |
| `viewMoving` | `bool` | `gestureActive \|\| Math.abs(_panVelocity) > 1e-5` | readonly | `Md3Chart` | True while dragging or coasting — skip Catmull / async Shape to avoid release flicker. |
| `paused` | `bool` | `false` | read/write | `Md3Chart` | Paused. |
| `unloadWhenPageInactive` | `bool` | `true` | read/write | `Md3Chart` | Drop Canvas/Shape while page is off-display (PageHost `md3PageActive`). |
| `chartActive` | `bool` | `!paused && enabled && pageGate.contentActive` | readonly | `Md3Chart` | Page/window/app visibility — Gate tracks `md3PageActive` (bindings alone do not). |
| `renderedPointCount` | `int` | `0` | read/write | `Md3Chart` | Rendered Point Count. |
| `plotLeft` | `real` | `contentPadding + labelWidth` | readonly | `Md3Chart` | Plot Left. |
| `plotRight` | `real` | `width - contentPadding` | readonly | `Md3Chart` | Plot Right. |
| `plotTop` | `real` | `contentPadding + 4` | readonly | `Md3Chart` | Plot Top. |
| `plotBottom` | `real` | `height - contentPadding - (showXLabels ? 16 : 0)` | readonly | `Md3Chart` | Plot Bottom. |
| `plotWidth` | `real` | `Math.max(1, plotRight - plotLeft)` | readonly | `Md3Chart` | Plot Width. |
| `plotHeight` | `real` | `Math.max(1, plotBottom - plotTop)` | readonly | `Md3Chart` | Plot Height. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `cleared()` | `Md3Chart` | Emitted when cleared. |
| `rebuilt()` | `Md3Chart` | Emitted when rebuilt. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `resolvedLineColor()` | `—` | `Md3Chart` | Resolved Line Color. |
| `resolvedFillColor()` | `—` | `Md3Chart` | Resolved Fill Color. |
| `resolvedGridColor()` | `—` | `Md3Chart` | Resolved Grid Color. |
| `resolvedAxisLabelColor()` | `—` | `Md3Chart` | Resolved Axis Label Color. |
| `resolvedSurfaceColor()` | `—` | `Md3Chart` | Resolved Surface Color. |
| `colorAt(index)` | `—` | `Md3Chart` | Color At. |
| `asNumber(v)` | `—` | `Md3Chart` | As Number. |
| `seriesNums(s)` | `—` | `Md3Chart` | Series Nums. |
| `rangeFromSeries(all)` | `—` | `Md3Chart` | Range From Series. |
| `rebuild()` | `—` | `Md3Chart` | Rebuild. |
| `requestRebuild()` | `—` | `Md3Chart` | Request Rebuild. |
| `pause()` | `—` | `Md3Chart` | Pause. |
| `resume()` | `—` | `Md3Chart` | Resume. |
| `clear()` | `—` | `Md3Chart` | Clear value / selection. |
| `fitY()` | `—` | `Md3Chart` | Fit Y. |
| `setValues(list)` | `—` | `Md3Chart` | Set Values. |
| `resetView()` | `—` | `Md3Chart` | Reset View. |
| `clampView()` | `—` | `Md3Chart` | Clamp View. |
| `beginGesture()` | `—` | `Md3Chart` | Begin Gesture. |
| `endGesture()` | `—` | `Md3Chart` | End Gesture. |
| `zoomAt(frac, factor)` | `—` | `Md3Chart` | Zoom centered on frac in [0,1] of plot width (0=left). |
| `panByFrac(delta, trackVelocity)` | `—` | `Md3Chart` | Pan By Frac. |
| `setProbe(index, pixelX, seriesInfo, pixelY)` | `—` | `Md3Chart` | Set Probe. |
| `clearProbe()` | `—` | `Md3Chart` | Clear Probe. |
| `nudgeProbe(delta)` | `—` | `Md3Chart` | Move probe by ±1 sample (Line/Bar override with geom.sampleCount). |
| `categoryLabel(index)` | `—` | `Md3Chart` | Category Label. |
| `windowIndices(n)` | `—` | `Md3Chart` | Visible sample window for length-n series under viewStart/viewSpan. |
| `indexAtPlotX(px, n)` | `—` | `Md3Chart` | Index At Plot X. |
| `plotXForIndex(index, n)` | `—` | `Md3Chart` | Plot XFor Index. |

## Example

```qml
import Md3

Md3Chart {
    values: []
    series: []
    seriesColors: []
    followTheme: true
    lineColor: "transparent"
    fillColor: "transparent"
}
```
