# Text field (Md3TextField)

## Sources
- M3: https://m3.material.io/components/text-fields/specs
- Flutter: `InputDecoration` / `InputDecorator` Material 3

## Variants
- Filled (surfaceContainerHighest + indicator)
- Outlined (outline / primary when focused)

## Metrics
| Token | Value |
|-------|-------|
| container height | 56 |
| corner filled | extraSmall top (4) / bottom 0 |
| corner outlined | extraSmall (4) |
| label | bodyLarge resting → labelSmall floated |
| supporting text | bodySmall |
| horizontal padding | 16 |
| indicator (filled) | 1 → 2 focused |

## Color roles
| State | Container / outline | Label / text |
|-------|---------------------|--------------|
| enabled | surfaceContainerHighest / outline | colorOnSurfaceVariant / colorOnSurface |
| focused | + primary indicator/outline | primary (label) |
| error | error indicator/outline | error |
| disabled | colorOnSurface@0.04 / @0.12 | colorOnSurface@0.38 |

## Motion
- Label float: `Md3Motion.short4` + `emphasized`
- Indicator thickness: `Md3Motion.short2` + `standard`

## Gallery checklist
- [ ] filled / outlined
- [ ] error / supporting
- [ ] prefix / suffix
- [ ] multiline
- [ ] light / dark
