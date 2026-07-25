# Segmented Button (Md3SegmentedButton)

## Sources
- M3: https://m3.material.io/components/segmented-buttons/specs
- Flutter: `SegmentedButton` / `ButtonSegment`

## Variants
- Single-select
- Multi-select
- With / without leading icon

## Metrics
| Token | Value |
|-------|-------|
| height | 40 |
| corner (outer) | full (stadium) / 20 |
| segment padding H | 12 |
| icon | 18 |
| outline | 1 dp outline |
| check icon when selected (multi) | 18 |

## Color roles
| State | Container | Content | Outline |
|-------|-----------|---------|---------|
| unselected | transparent / surface | colorOnSurface | outline |
| selected | secondaryContainer | colorOnSecondaryContainer | outline |
| disabled | colorOnSurface@12% | colorOnSurface@38% | outline@12% |

## Motion
- Selection container: `Md3Motion.short4` + `emphasized`
- Check icon fade: `Md3Motion.short3` + `standard`

## Accessibility
- Each segment is a button; selected reflected in Accessible state
- Keyboard: Left/Right to move, Space to toggle

## Gallery checklist
- [ ] single / multi
- [ ] icons
- [ ] disabled segment
- [ ] light / dark
