# Common buttons (Md3Button)

## Sources
- M3: https://m3.material.io/components/buttons/specs
- Flutter: Flutter FilledButton / ElevatedButton / OutlinedButton / TextButton / FilledButton.tonal

## Variants
- Filled, Filled Tonal, Elevated, Outlined, Text
- Sizes: ExtraSmall(32), Small(40), Medium(56), Large(96)

## Metrics
| Token | Value |
|-------|-------|
| height | 32/40/56/96 |
| horizontal padding | 12–24 |
| corner | full (pill) default; square scale by size |
| icon | 18 |

## Color roles
| State | Filled container | Content |
|-------|------------------|----------|
| enabled | primary | colorOnPrimary |
| tonal | secondaryContainer | colorOnSecondaryContainer |
| elevated | surfaceContainerLow | primary |
| outlined/text | transparent | primary |
| disabled | colorOnSurface@12% | colorOnSurface@38% |

## Typography
- Default label: `labelLarge` unless noted

## Shape / elevation / tint
- See metrics; elevation uses `Md3Theme.elevation` + surface tint

## Motion
- press ripple: medium2 / standardDecelerate; state overlay: short2

## Accessibility
- Minimum touch target 48×48 dp
- Keyboard focus via `Md3FocusRing`
- Disabled content opacity 0.38

## Gallery checklist
- [ ] variants
- [ ] state matrix
- [ ] light / dark
