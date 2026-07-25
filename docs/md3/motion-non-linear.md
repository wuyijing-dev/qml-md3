# Motion (original pacing)

## Rules
- Durations from Flutter `material/motion.dart` (`short*` / `medium*`)
- Curves: M3 `emphasized` / `standard` / expressive `spatial*` / `effects*`
- Interactive UI uses `NumberAnimation` + `Behavior` (retargets on interrupt)
- Buttons: ripple `medium2` (300ms), state overlay `short2` (100ms)
- Progress indeterminate loops stay continuous (no jump-back); durations via `progress*`

## Key durations
| Token | ms | Typical use |
|-------|-----|-------------|
| stateDuration / short2 | 100 | hover / press overlay |
| short4 | 200 | switch thumb, color |
| rippleDuration / medium2 | 300 | button ink |
| spatialSnapDuration | 300 | tab / indicator |
| spatialDuration / medium4 | 400 | drawer / sheet |
| menuDuration | 400 | menus / dialogs |
