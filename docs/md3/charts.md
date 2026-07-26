# Charts

## Hierarchy
| Type | Role |
|------|------|
| **`Md3Chart`** | Base: plot metrics, theme resolve, `pause` / `resume` / `clear` / `fitY`, coalesced rebuild |
| **`Md3LineChart`** | Shape stroke line/area + optional `live` |
| **`Md3BarChart`** | Grouped vertical bars |
| **`Md3ChartData`** | C++ only: million-point ingest + downsample → `points` |

## Theme / performance
- Default colors are **transparent** → resolved from `Md3Theme` at rebuild (no per-role bindings).
- Seed drag debounces **50 ms**; **dark toggle rebuilds immediately** so circular theme reveal shows NEW theme inside the hole and OLD snapshot outside.
- Live animation uses `chartActive` (`!paused`, not minimized) — **not** paused during theme reveal.

## Md3Chart API
| API | Notes |
|-----|-------|
| `pause()` / `resume()` / `paused` | Freeze live & optional work |
| `clear()` / `setValues(list)` / `fitY()` | Data ops |
| `followTheme` | Debounced theme rebuild |
| `values` / `series` / `seriesColors` | Shared data |

## Large series
```qml
Md3ChartData { id: data }
Md3LineChart { values: data.points }
// data.fillSine(1000000)
```
