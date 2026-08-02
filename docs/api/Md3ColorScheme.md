# Md3ColorScheme

- **Source:** `src/Md3/foundation/Md3ColorScheme.qml`
- **Extends:** `QtObject`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 54 | 0 | 3 | 0 |

_Also inherits Qt Quick `QtObject` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `dark` | `bool` | `false` | read/write | `Md3ColorScheme` | Dark. |
| `primary` | `color` | `"#6750A4"` | read/write | `Md3ColorScheme` | Primary. |
| `colorOnPrimary` | `color` | `"#FFFFFF"` | read/write | `Md3ColorScheme` | Color On Primary. |
| `primaryContainer` | `color` | `"#EADDFF"` | read/write | `Md3ColorScheme` | Primary Container. |
| `colorOnPrimaryContainer` | `color` | `"#21005D"` | read/write | `Md3ColorScheme` | Color On Primary Container. |
| `primaryFixed` | `color` | `"#EADDFF"` | read/write | `Md3ColorScheme` | Primary Fixed. |
| `primaryFixedDim` | `color` | `"#D0BCFF"` | read/write | `Md3ColorScheme` | Primary Fixed Dim. |
| `colorOnPrimaryFixed` | `color` | `"#21005D"` | read/write | `Md3ColorScheme` | Color On Primary Fixed. |
| `colorOnPrimaryFixedVariant` | `color` | `"#4F378B"` | read/write | `Md3ColorScheme` | Color On Primary Fixed Variant. |
| `secondary` | `color` | `"#625B71"` | read/write | `Md3ColorScheme` | Secondary. |
| `colorOnSecondary` | `color` | `"#FFFFFF"` | read/write | `Md3ColorScheme` | Color On Secondary. |
| `secondaryContainer` | `color` | `"#E8DEF8"` | read/write | `Md3ColorScheme` | Secondary Container. |
| `colorOnSecondaryContainer` | `color` | `"#1D192B"` | read/write | `Md3ColorScheme` | Color On Secondary Container. |
| `secondaryFixed` | `color` | `"#E8DEF8"` | read/write | `Md3ColorScheme` | Secondary Fixed. |
| `secondaryFixedDim` | `color` | `"#CCC2DC"` | read/write | `Md3ColorScheme` | Secondary Fixed Dim. |
| `colorOnSecondaryFixed` | `color` | `"#1D192B"` | read/write | `Md3ColorScheme` | Color On Secondary Fixed. |
| `colorOnSecondaryFixedVariant` | `color` | `"#4A4458"` | read/write | `Md3ColorScheme` | Color On Secondary Fixed Variant. |
| `tertiary` | `color` | `"#7D5260"` | read/write | `Md3ColorScheme` | Tertiary. |
| `colorOnTertiary` | `color` | `"#FFFFFF"` | read/write | `Md3ColorScheme` | Color On Tertiary. |
| `tertiaryContainer` | `color` | `"#FFD8E4"` | read/write | `Md3ColorScheme` | Tertiary Container. |
| `colorOnTertiaryContainer` | `color` | `"#31111D"` | read/write | `Md3ColorScheme` | Color On Tertiary Container. |
| `tertiaryFixed` | `color` | `"#FFD8E4"` | read/write | `Md3ColorScheme` | Tertiary Fixed. |
| `tertiaryFixedDim` | `color` | `"#EFB8C8"` | read/write | `Md3ColorScheme` | Tertiary Fixed Dim. |
| `colorOnTertiaryFixed` | `color` | `"#31111D"` | read/write | `Md3ColorScheme` | Color On Tertiary Fixed. |
| `colorOnTertiaryFixedVariant` | `color` | `"#633B48"` | read/write | `Md3ColorScheme` | Color On Tertiary Fixed Variant. |
| `error` | `color` | `"#B3261E"` | read/write | `Md3ColorScheme` | Error. |
| `colorOnError` | `color` | `"#FFFFFF"` | read/write | `Md3ColorScheme` | Color On Error. |
| `errorContainer` | `color` | `"#F9DEDC"` | read/write | `Md3ColorScheme` | Error Container. |
| `colorOnErrorContainer` | `color` | `"#410E0B"` | read/write | `Md3ColorScheme` | Color On Error Container. |
| `surface` | `color` | `"#FEF7FF"` | read/write | `Md3ColorScheme` | Surface. |
| `colorOnSurface` | `color` | `"#1D1B20"` | read/write | `Md3ColorScheme` | Color On Surface. |
| `surfaceDim` | `color` | `"#DED8E1"` | read/write | `Md3ColorScheme` | Surface Dim. |
| `surfaceBright` | `color` | `"#FEF7FF"` | read/write | `Md3ColorScheme` | Surface Bright. |
| `surfaceContainerLowest` | `color` | `"#FFFFFF"` | read/write | `Md3ColorScheme` | Surface Container Lowest. |
| `surfaceContainerLow` | `color` | `"#F7F2FA"` | read/write | `Md3ColorScheme` | Surface Container Low. |
| `surfaceContainer` | `color` | `"#F3EDF7"` | read/write | `Md3ColorScheme` | Surface Container. |
| `surfaceContainerHigh` | `color` | `"#ECE6F0"` | read/write | `Md3ColorScheme` | Surface Container High. |
| `surfaceContainerHighest` | `color` | `"#E6E0E9"` | read/write | `Md3ColorScheme` | Surface Container Highest. |
| `colorOnSurfaceVariant` | `color` | `"#49454F"` | read/write | `Md3ColorScheme` | Color On Surface Variant. |
| `outline` | `color` | `"#79747E"` | read/write | `Md3ColorScheme` | Outline. |
| `outlineVariant` | `color` | `"#CAC4D0"` | read/write | `Md3ColorScheme` | Outline Variant. |
| `shadow` | `color` | `"#000000"` | read/write | `Md3ColorScheme` | Shadow. |
| `scrim` | `color` | `"#000000"` | read/write | `Md3ColorScheme` | Scrim. |
| `inverseSurface` | `color` | `"#322F35"` | read/write | `Md3ColorScheme` | Inverse Surface. |
| `colorOnInverseSurface` | `color` | `"#F5EFF7"` | read/write | `Md3ColorScheme` | Color On Inverse Surface. |
| `inversePrimary` | `color` | `"#D0BCFF"` | read/write | `Md3ColorScheme` | Inverse Primary. |
| `surfaceTint` | `color` | `"#6750A4"` | read/write | `Md3ColorScheme` | Surface Tint. |
| `background` | `color` | `surface` | read/write | `Md3ColorScheme` | Background. |
| `colorOnBackground` | `color` | `colorOnSurface` | read/write | `Md3ColorScheme` | Color On Background. |
| `surfaceVariant` | `color` | `surfaceContainerHighest` | read/write | `Md3ColorScheme` | Surface Variant. |
| `disabledContentColor` | `color` | `Qt.rgba(colorOnSurface.r, colorOnSurface.g, colorOnSurface.b, 0.38)` | readonly | `Md3ColorScheme` | Cached disabled tokens — avoid Qt.rgba on every binding eval across buttons/lists. |
| `disabledContainerColor` | `color` | `Qt.rgba(colorOnSurface.r, colorOnSurface.g, colorOnSurface.b, 0.12)` | readonly | `Md3ColorScheme` | Disabled Container Color. |
| `gaugeTrack` | `color` | `dark ? outlineVariant : surfaceContainerHighest` | readonly | `Md3ColorScheme` | Inactive gauge / chart track — solid roles (opacity tracks look washed out). Dark uses outlineVariant so arcs stay visible on surface *and* container cards. |
| `gaugeDial` | `color` | `dark ? surfaceContainerHigh : surfaceContainerHighest` | readonly | `Md3ColorScheme` | Filled dial face (wave / compass / knob). |

## Signals

_None._

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `withOpacity(c, a)` | `—` | `Md3ColorScheme` | With Opacity. |
| `disabledContent()` | `—` | `Md3ColorScheme` | Disabled Content. |
| `disabledContainer()` | `—` | `Md3ColorScheme` | Disabled Container. |

## Example

```qml
import Md3

Md3ColorScheme {
    dark: false
    primary: "#6750A4"
    colorOnPrimary: "#FFFFFF"
    primaryContainer: "#EADDFF"
    colorOnPrimaryContainer: "#21005D"
    primaryFixed: "#EADDFF"
}
```
