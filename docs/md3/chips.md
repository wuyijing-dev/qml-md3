# Chips (Assist / Filter / Input / Suggestion)

## Sources
- M3: https://m3.material.io/components/chips/specs
- Flutter: `ActionChip`, `FilterChip`, `InputChip`, `RawChip` M3

## Shared metrics
| Token | Value |
|-------|-------|
| height | 32 |
| corner | 8 (small) |
| icon | 18 |
| label | labelLarge |
| padding H | 8–16 |

## Variants
| Chip | Container (unselected) | Selected |
|------|------------------------|----------|
| Assist | surface / outline | — (action only) |
| Filter | surface / outline | secondaryContainer |
| Input | surfaceContainerLow | — + delete icon |
| Suggestion | surface / outline | — |

Elevated variants use elevation 1 + surfaceContainerLow.

## Motion
- Selection: `Md3Motion.short4` + `emphasized`
- Ripple on press

## Gallery checklist
- [ ] all four types
- [ ] elevated
- [ ] selected filter
- [ ] light / dark
