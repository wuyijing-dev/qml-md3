# Icon button

## Sources
- M3: https://m3.material.io/components/icon-buttons/specs
- Flutter: Flutter IconButton / IconButton.filled / filledTonal / outlined

## Variants
- Standard, Filled, Filled Tonal, Outlined

## Metrics
| Token | Value |
|-------|-------|
| touch | 48 |
| container | 40 |
| icon | 24 |
| corner | full |

## Color roles
Standard: colorOnSurfaceVariant; Filled: primary/colorOnPrimary; Tonal: secondaryContainer; Outlined: outline

## Typography
- Default label: `labelLarge` unless noted

## Shape / elevation / tint
- See metrics; elevation uses `Md3Theme.elevation` + surface tint

## Motion
- short4 / standard

## Accessibility
- Minimum touch target 48×48 dp
- Keyboard focus via `Md3FocusRing`
- Disabled content opacity 0.38

## Gallery checklist
- [ ] variants
- [ ] state matrix
- [ ] light / dark
