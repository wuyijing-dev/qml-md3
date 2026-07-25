# Slider & Range slider

## Sources
- M3: https://m3.material.io/components/sliders/specs
- Flutter: `Slider` / `RangeSlider` M3 defaults

## Metrics
| Token | Value |
|-------|-------|
| track height | 4 (inactive/active) — M3 also supports stop indicators |
| thumb | 20 diameter |
| value indicator | labelLarge on inverseSurface |
| touch | 48 height |

## Color roles
| Part | Color |
|------|-------|
| active track | primary |
| inactive track | surfaceContainerHighest |
| thumb | primary |
| disabled | colorOnSurface@0.38 / @0.12 |

## Motion
- Thumb / value: `Md3Motion.short2` while dragging; settle `short4` + `standard`

## Gallery checklist
- [ ] continuous / discrete
- [ ] range
- [ ] disabled
- [ ] light / dark
