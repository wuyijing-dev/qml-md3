# Floating Action Button (Md3Fab)

## Sources
- M3: https://m3.material.io/components/floating-action-button/specs
- Flutter: `packages/flutter/lib/src/material/floating_action_button.dart` (`_FABDefaultsM3`)
- Flutter API: https://api.flutter.dev/flutter/material/FloatingActionButton-class.html

## Variants
- **Color**: Primary (default), Secondary, Tertiary, Surface
- **Size**: Small (40), Regular (56), Large (96)

Flutter default color mapping uses `primaryContainer` / `colorOnPrimaryContainer`. Color variants map containers as:

| Color | Container | Content |
|-------|-----------|---------|
| Primary | primaryContainer | colorOnPrimaryContainer |
| Secondary | secondaryContainer | colorOnSecondaryContainer |
| Tertiary | tertiaryContainer | colorOnTertiaryContainer |
| Surface | surfaceContainerHigh | primary |

## Metrics (Flutter `_FABDefaultsM3`)

| Size | Width×Height | Corner | Icon |
|------|--------------|--------|------|
| Small | 40×40 | 12 (medium) | 24 |
| Regular | 56×56 | 16 (large) | 24 |
| Large | 96×96 | 28 (extraLarge) | 36 |

## Elevation
| State | Level |
|-------|-------|
| default | 6 |
| hover | 8 |
| focus | 6 |
| pressed (highlight) | 6 |

## State layers
- hover: on* @ 0.08
- focus / press splash: on* @ 0.12 (Flutter focus/splash 0.1 ≈ M3 pressed 0.12; we use Md3StateLayer tokens)

## Motion
- Ripple expand: `Md3Motion.medium2` + `standardDecelerate`
- Elevation change: `Md3Motion.short4` + `standard`
- State overlay: `Md3Motion.short2` + `standard`

## Accessibility
- Touch target: at least 48×48 (small FAB sits in 48 hit area)
- Keyboard focus ring
- `Accessible.name` from `accessibleName` / tooltip

## Gallery checklist
- [ ] sizes × color variants
- [ ] hover / focus / press elevation
- [ ] disabled
- [ ] light / dark
