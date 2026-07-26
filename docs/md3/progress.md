# Progress indicators

## Sources
- M3: https://m3.material.io/components/progress-indicators/specs
- Expressive wavy: Android `LinearWavyProgressIndicator` / `CircularWavyProgressIndicator`
- **Renderer:** `QtQuick.Shapes` (`Shape` + `PathPolyline` / `PathAngleArc`)

## Architecture
| Layer | Role |
|-------|------|
| `Md3LinearProgressIndicator.qml` / Circular / Loading | Theme + public API + Shape GPU stroke |

## Linear / Circular styles
See component `Style` enums: Standard, Wavy, Soft, Lively.

## Motion
- Tokens: `progressTravel` 1800, `progressSpin` 1600, `progressSweep` 1100, `progressWave` 2400
