# Radio button (Md3Radio)

## Sources
- M3: https://m3.material.io/components/radio-button/specs
- Flutter: `Radio` / `_RadioDefaultsM3`

## Metrics
| Token | Value |
|-------|-------|
| outer diameter | 20 |
| inner (selected) | 10 |
| stroke | 2 |
| state layer | 40 |
| touch | 48 |

## Color roles
| State | Outer / inner |
|-------|---------------|
| selected | primary |
| unselected | colorOnSurfaceVariant / outline |
| disabled | colorOnSurface@0.38 |

## Motion
- Inner scale: `Md3Motion.short4` + `emphasized`

## Accessibility
- Exclusive within `ButtonGroup` / shared `group` property
- Space selects

## Gallery checklist
- [ ] group selection
- [ ] disabled
- [ ] light / dark
