# Line chart

## Sources
- Material 3 color / shape tokens
- Flutter fl_chart–style smooth line + area fill (not an official M3 widget)

## Md3LineChart
| API | Notes |
|-----|-------|
| `values` | `number[]` or `{x,y}[]` |
| `series` | Multi-series `number[][]` (overrides `values`) |
| `seriesColors` | Per-series colors; else primary / secondary / tertiary |
| `showArea` / `smooth` / `showDots` / `showGrid` | Visual toggles |
| `minY` / `maxY` | Optional fixed scale |
| Colors | `lineColor`, `fillColor`, grid → `outlineVariant`, labels → `onSurfaceVariant` |

Container: typically `Md3Card` (`Filled` / `Outlined` / `Elevated`).

## Gallery performance HUD
Not part of the Md3 module. Lives under `gallery/`:

| File | Role |
|------|------|
| `gallery/performancemonitor.*` | Real `frameSwapped` FPS + Win process CPU / working set |
| `gallery/PerformancePanel.qml` | Floating HUD using `Md3LineChart` |
| Title-bar `speed` toggle | Show / hide panel |

Metrics are sampled from the live window and OS APIs — not synthetic demo data.

### CPU notes
- `frameSwapped` uses **DirectConnection** + atomics (no per-frame GUI queue)
- UI / chart refresh defaults to **500 ms**
- Sampling pauses when the panel is hidden or the window is minimized
