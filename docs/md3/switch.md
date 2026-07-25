# Switch (Md3Switch)

## Sources
- M3: https://m3.material.io/components/switch/specs
- Flutter: `Switch` / `_SwitchDefaultsM3`

## Metrics
| Token | Value |
|-------|-------|
| track | 52×32 |
| track corner | full |
| thumb unselected | 16 |
| thumb selected | 24 |
| icon (optional) | 16 |
| touch | 48 |

## Color roles
| State | Track | Thumb |
|-------|-------|-------|
| selected | primary | colorOnPrimary |
| unselected | surfaceContainerHighest | outline |
| disabled selected | colorOnSurface@0.12 | surface |
| disabled unselected | surfaceContainerHighest@0.12 | colorOnSurface@0.38 |

## Motion
- Thumb travel: `Md3Motion.short4` + `emphasized`
- Thumb size morph: `Md3Motion.short3` + `standard`

## Accessibility
- `Accessible.checkable`
- Space toggles

## Gallery checklist
- [ ] with / without icon
- [ ] disabled
- [ ] light / dark
