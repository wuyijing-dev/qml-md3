# Md3ChartData

- **Source:** `src/Md3/charts/md3chartdata.h`
- **QML:** `Md3ChartData` (`QML_ELEMENT`)
- **C++:** `#include "md3chartdata.h"`

C++ helper for large series: ingest / generate in C++, expose a downsampled `points` list for QML charts.

## Properties

| Name | Type | Access | Notify | Description |
|------|------|--------|--------|-------------|
| `points` | `list` (numbers) | readonly | `pointsChanged` | Downsampled Y values for plotting |
| `rawCount` | `int` | readonly | `pointsChanged` | Raw sample count before downsample |
| `pointCount` | `int` | readonly | `pointsChanged` | `points.length` |
| `targetPoints` | `int` | read/write | `targetPointsChanged` | Downsample budget (default `512`) |

## Signals

| Signal | Description |
|--------|-------------|
| `pointsChanged()` | Display series updated |
| `targetPointsChanged()` | `targetPoints` changed |

## Methods

| Method | Description |
|--------|-------------|
| `fillSine(count, mid = 50, amp1 = 30, amp2 = 12, noise = 6)` | Generate sine (+ noise) in C++, then downsample |
| `setFloatValues(QByteArray floats)` | Ingest raw float binary blob |
| `setValues(list values)` | Ingest QVariantList of numbers |
| `clear()` | Clear series |

## Example

```qml
import Md3
Md3ChartData {
    id: data
    targetPoints: 256
    Component.onCompleted: fillSine(100000)
}
Md3LineChart {
    values: data.points
}
```
