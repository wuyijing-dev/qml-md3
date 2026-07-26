# Line chart

## Sources
- Material 3 color tokens
- **Renderer:** Qt Quick Scene Graph (`QSGGeometry`) — GPU path used by production chart UIs
- Downsample: min/max buckets ≈ pixel density (same idea as LTTB / trading terminals)
- Archived: `src/Md3/components/archive/Md3LineChart.Canvas.qml` (pure QML Canvas — too slow)

## Why not Canvas / QPainter?
| Path | Role |
|------|------|
| QML `Canvas` | JS + CPU raster — unsuitable for large / animated series |
| `QQuickPaintedItem` / QPainter | Still CPU blit each frame |
| **Scene Graph geometry** | Upload verts once per update; GPU draws strips — industry default in Qt |

## Md3LineChart (C++)
| API | Notes |
|-----|-------|
| `values` / `series` | Small/medium series from QML |
| `fillSine(n)` / `setFloatValues(bytes)` | Million-scale — build or ingest in C++ |
| `rawPointCount` / `renderedPointCount` | Diagnostics |
| `showArea` / `smooth` / `showDots` / `showGrid` | Visual toggles |
| `minY` / `maxY` | Optional fixed scale |

Future bar / area / scatter charts should share the same Scene Graph + downsample pattern.

## Gallery performance HUD
Not part of the Md3 module. Lives under `gallery/`:

| File | Role |
|------|------|
| `gallery/performancemonitor.*` | Real `frameSwapped` FPS + Win process CPU / working set |
| `gallery/PerformancePanel.qml` | Floating HUD using `Md3LineChart` |
| Title-bar `speed` toggle | Show / hide panel |
