# Checkbox (Md3Checkbox)

## Sources
- M3: https://m3.material.io/components/checkbox/specs
- Flutter: `packages/flutter/lib/src/material/checkbox.dart` (`_CheckboxDefaultsM3`)

## Variants
- Unchecked / Checked / Indeterminate (tristate)

## Metrics
| Token | Value |
|-------|-------|
| container | 18×18 |
| corner | 2 |
| icon | 18 |
| state layer | 40 |
| touch target | 48 |

## Color roles (Flutter M3)
| State | Container | Icon / outline |
|-------|-----------|----------------|
| selected | primary | colorOnPrimary |
| unselected | transparent | outline (2dp stroke) |
| disabled selected | colorOnSurface@0.38 | surface |
| disabled unselected | transparent | colorOnSurface@0.38 |

## Motion
- Check / indeterminate mark: `Md3Motion.short4` + `emphasized`
- Container fill: `Md3Motion.short3` + `standard`

## Accessibility
- `Accessible.checkable` / `checked`
- Space toggles; touch 48×48

## Gallery checklist
- [ ] checked / unchecked / indeterminate
- [ ] disabled
- [ ] light / dark
