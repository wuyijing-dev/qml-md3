# Design tokens

Aligned with Material Design 3 and Flutter Material (`ColorScheme`, `TextTheme`, `Durations`, `Easings`, state-layer opacities).

## Sources

- https://m3.material.io/styles/color/roles
- https://m3.material.io/styles/typography/type-scale-tokens
- https://m3.material.io/styles/shape/shape-scale-tokens
- https://m3.material.io/styles/elevation
- https://m3.material.io/styles/motion/easing-and-duration/tokens-specs
- https://api.flutter.dev/flutter/material/ColorScheme-class.html
- https://github.com/flutter/flutter/blob/main/packages/flutter/lib/src/material/motion.dart

## Color roles

Full Flutter `ColorScheme` surface (light/dark baseline seed `#6750A4`):

- primary / colorOnPrimary / primaryContainer / colorOnPrimaryContainer
- primaryFixed / primaryFixedDim / colorOnPrimaryFixed / colorOnPrimaryFixedVariant
- secondary / colorOnSecondary / secondaryContainer / colorOnSecondaryContainer (+ Fixed*)
- tertiary / colorOnTertiary / tertiaryContainer / colorOnTertiaryContainer (+ Fixed*)
- error / colorOnError / errorContainer / colorOnErrorContainer
- surface / colorOnSurface / surfaceDim / surfaceBright
- surfaceContainerLowest / Low / (default) / High / Highest
- colorOnSurfaceVariant / outline / outlineVariant
- shadow / scrim / inverseSurface / colorOnInverseSurface / inversePrimary / surfaceTint

Disabled content uses `colorOnSurface` @ **0.38** opacity; disabled containers @ **0.12**.

## State layers

Drawn as `on*` color over the container:

| State | Opacity |
|-------|---------|
| hover | 0.08 |
| focus | 0.12 |
| press | 0.12 |
| drag | 0.16 |

## Typography (dp / sp)

| Role | Size | Weight | Tracking | Line height |
|------|------|--------|----------|-------------|
| displayLarge | 57 | Regular 400 | -0.25 | 64 |
| displayMedium | 45 | Regular 400 | 0 | 52 |
| displaySmall | 36 | Regular 400 | 0 | 44 |
| headlineLarge | 32 | Regular 400 | 0 | 40 |
| headlineMedium | 28 | Regular 400 | 0 | 36 |
| headlineSmall | 24 | Regular 400 | 0 | 32 |
| titleLarge | 22 | Regular 400 | 0 | 28 |
| titleMedium | 16 | Medium 500 | 0.15 | 24 |
| titleSmall | 14 | Medium 500 | 0.1 | 20 |
| bodyLarge | 16 | Regular 400 | 0.5 | 24 |
| bodyMedium | 14 | Regular 400 | 0.25 | 20 |
| bodySmall | 12 | Regular 400 | 0.4 | 16 |
| labelLarge | 14 | Medium 500 | 0.1 | 20 |
| labelMedium | 12 | Medium 500 | 0.5 | 16 |
| labelSmall | 11 | Medium 500 | 0.5 | 16 |

Font family: **HarmonyOS Sans SC** (Regular bundled by default; Medium/Bold optional via `MD3_BUNDLE_EXTRA_UI_FONTS` or app `fonts/`). Fallback: system UI sans.

Icon fonts (bundled locally):
- **Material Icons Outlined** — default for `Md3Icon` (`variant: "outlined"`)
- **Material Icons** — filled (`variant: "filled"`)

Re-download: `powershell -File scripts/assets/download-fonts.ps1`

## Shape scale (dp)

| Token | Radius |
|-------|--------|
| none | 0 |
| extraSmall | 4 |
| small | 8 |
| medium | 12 |
| large | 16 |
| extraLarge | 28 |
| full | 9999 (pill) |

## Elevation

Levels 0–5. MD3 surfaces tint with `surfaceTint` as elevation increases.

Shadows use a **key + ambient** pair (`Md3Shadow` + `MultiEffect` blur) so elevated controls (FAB, menus) separate clearly from the page.

## Motion (Flutter `Durations` / `Easings`)

### Durations

| Token | ms |
|-------|-----|
| short1 | 50 |
| short2 | 100 |
| short3 | 150 |
| short4 | 200 |
| medium1 | 250 |
| medium2 | 300 |
| medium3 | 350 |
| medium4 | 400 |
| long1 | 450 |
| long2 | 500 |
| long3 | 550 |
| long4 | 600 |
| extraLong1 | 700 |
| extraLong2 | 800 |
| extraLong3 | 900 |
| extraLong4 | 1000 |

### Easings (cubic-bezier → Qt `Easing.BezierSpline`)

| Token | Curve |
|-------|-------|
| snapOut (`ui` / `uiSpatial`) | 0.0, 0.0, 0.2, 1.0 — fast start |
| emphasized | 0.2, 0.0, 0.0, 1.0 |
| emphasizedDecelerate | 0.05, 0.7, 0.1, 1.0 |
| emphasizedAccelerate (`uiExit`) | 0.3, 0.0, 0.8, 0.15 |
| standard | 0.2, 0.0, 0.0, 1.0 |
| standardDecelerate | 0.0, 0.0, 0.0, 1.0 |
| standardAccelerate | 0.3, 0.0, 1.0, 1.0 |

**Interactive UI** uses `SmoothedAnimation` + `Sync` (`smoothSnap*` / `smoothPanel*`) — see [Md3Motion](api/Md3Motion.md).

## Density & spacing

`Md3Theme.density`: `0` Comfortable (default) / `1` Compact.

| Token | Comfortable | Compact |
|-------|-------------|---------|
| `spacingXs` | 4 | 4 |
| `spacingSm` | 8 | 6 |
| `spacingMd` | 12 | 8 |
| `spacingLg` | 16 | 12 |
| `spacingXl` | 24 | 16 |
| `pagePadding` | 20 | 12 |
| `controlHeight` | 40 | 36 |
| `tableRowHeight` | 52 | 40 |

`setDensity(0|1)` / `densityLabel()`. Align `Md3DataTable.density` with `densityCompact`. Full UX rules: [design-guidelines.md](design-guidelines.md).

