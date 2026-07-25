# Extended FAB (Md3ExtendedFab)

## Sources
- M3: https://m3.material.io/components/extended-fab/specs
- Flutter: `FloatingActionButton.extended` + `_FABDefaultsM3` extended branch

## Variants
- Color: Primary / Secondary / Tertiary / Surface (same roles as FAB)
- Expanded (icon + label) and icon-only collapsed

## Metrics (Flutter M3)
| Token | Value |
|-------|-------|
| height | 56 |
| corner | 16 (large) |
| icon | 24 |
| icon–label spacing | 8 |
| padding start (with icon) | 16 |
| padding end | 20 |
| elevation | 6 (hover 8) |

## Color roles
Same container/content mapping as `Md3Fab`.

## Motion
- Expand / collapse width: `Md3Motion.medium4` + `emphasized`
- Label opacity: `Md3Motion.short4` + `standard`
- Ripple / state overlay: same as FAB

## Accessibility
- Name = label text
- Focus ring on container

## Gallery checklist
- [ ] expanded / collapsed toggle
- [ ] color variants
- [ ] light / dark
