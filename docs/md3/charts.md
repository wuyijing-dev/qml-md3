# Line chart

## Approach
| Layer | Role |
|-------|------|
| **`Md3LineChart.qml`** | `QtQuick.Shapes` GPU stroke (`RoundCap` / `RoundJoin`) — Canvas-quality look |
| **`Md3ChartData` (C++)** | Million-scale generate / ingest + min/max downsample only |

QML cannot paint a million vertices every frame. After downsample to ~2.5× plot width, Shapes is fast and looks like the old Canvas charts.

## Md3LineChart
| API | Notes |
|-----|-------|
| `values` / `series` | Prefer already-small or `Md3ChartData.points` |
| `live` | Small animated sine in QML (`FrameAnimation`) |
| Theme | Defaults bind `Md3Theme` (`primary`, `outlineVariant`, …) |

## Md3ChartData
| API | Notes |
|-----|-------|
| `fillSine(n)` | Build in C++ |
| `points` | Downsampled `number[]` for the Shape chart |
| `rawCount` / `pointCount` | Diagnostics |
| `targetPoints` | Cap after downsample (set from chart width) |
