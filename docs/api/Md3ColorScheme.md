# Md3ColorScheme

- **Source:** `src/Md3/foundation/Md3ColorScheme.qml`
- **Extends:** `QtObject`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `dark` | `bool` | `false` | read/write | `Md3ColorScheme` | — |
| `primary` | `color` | `"#6750A4"` | read/write | `Md3ColorScheme` | — |
| `colorOnPrimary` | `color` | `"#FFFFFF"` | read/write | `Md3ColorScheme` | — |
| `primaryContainer` | `color` | `"#EADDFF"` | read/write | `Md3ColorScheme` | — |
| `colorOnPrimaryContainer` | `color` | `"#21005D"` | read/write | `Md3ColorScheme` | — |
| `primaryFixed` | `color` | `"#EADDFF"` | read/write | `Md3ColorScheme` | — |
| `primaryFixedDim` | `color` | `"#D0BCFF"` | read/write | `Md3ColorScheme` | — |
| `colorOnPrimaryFixed` | `color` | `"#21005D"` | read/write | `Md3ColorScheme` | — |
| `colorOnPrimaryFixedVariant` | `color` | `"#4F378B"` | read/write | `Md3ColorScheme` | — |
| `secondary` | `color` | `"#625B71"` | read/write | `Md3ColorScheme` | — |
| `colorOnSecondary` | `color` | `"#FFFFFF"` | read/write | `Md3ColorScheme` | — |
| `secondaryContainer` | `color` | `"#E8DEF8"` | read/write | `Md3ColorScheme` | — |
| `colorOnSecondaryContainer` | `color` | `"#1D192B"` | read/write | `Md3ColorScheme` | — |
| `secondaryFixed` | `color` | `"#E8DEF8"` | read/write | `Md3ColorScheme` | — |
| `secondaryFixedDim` | `color` | `"#CCC2DC"` | read/write | `Md3ColorScheme` | — |
| `colorOnSecondaryFixed` | `color` | `"#1D192B"` | read/write | `Md3ColorScheme` | — |
| `colorOnSecondaryFixedVariant` | `color` | `"#4A4458"` | read/write | `Md3ColorScheme` | — |
| `tertiary` | `color` | `"#7D5260"` | read/write | `Md3ColorScheme` | — |
| `colorOnTertiary` | `color` | `"#FFFFFF"` | read/write | `Md3ColorScheme` | — |
| `tertiaryContainer` | `color` | `"#FFD8E4"` | read/write | `Md3ColorScheme` | — |
| `colorOnTertiaryContainer` | `color` | `"#31111D"` | read/write | `Md3ColorScheme` | — |
| `tertiaryFixed` | `color` | `"#FFD8E4"` | read/write | `Md3ColorScheme` | — |
| `tertiaryFixedDim` | `color` | `"#EFB8C8"` | read/write | `Md3ColorScheme` | — |
| `colorOnTertiaryFixed` | `color` | `"#31111D"` | read/write | `Md3ColorScheme` | — |
| `colorOnTertiaryFixedVariant` | `color` | `"#633B48"` | read/write | `Md3ColorScheme` | — |
| `error` | `color` | `"#B3261E"` | read/write | `Md3ColorScheme` | — |
| `colorOnError` | `color` | `"#FFFFFF"` | read/write | `Md3ColorScheme` | — |
| `errorContainer` | `color` | `"#F9DEDC"` | read/write | `Md3ColorScheme` | — |
| `colorOnErrorContainer` | `color` | `"#410E0B"` | read/write | `Md3ColorScheme` | — |
| `surface` | `color` | `"#FEF7FF"` | read/write | `Md3ColorScheme` | — |
| `colorOnSurface` | `color` | `"#1D1B20"` | read/write | `Md3ColorScheme` | — |
| `surfaceDim` | `color` | `"#DED8E1"` | read/write | `Md3ColorScheme` | — |
| `surfaceBright` | `color` | `"#FEF7FF"` | read/write | `Md3ColorScheme` | — |
| `surfaceContainerLowest` | `color` | `"#FFFFFF"` | read/write | `Md3ColorScheme` | — |
| `surfaceContainerLow` | `color` | `"#F7F2FA"` | read/write | `Md3ColorScheme` | — |
| `surfaceContainer` | `color` | `"#F3EDF7"` | read/write | `Md3ColorScheme` | — |
| `surfaceContainerHigh` | `color` | `"#ECE6F0"` | read/write | `Md3ColorScheme` | — |
| `surfaceContainerHighest` | `color` | `"#E6E0E9"` | read/write | `Md3ColorScheme` | — |
| `colorOnSurfaceVariant` | `color` | `"#49454F"` | read/write | `Md3ColorScheme` | — |
| `outline` | `color` | `"#79747E"` | read/write | `Md3ColorScheme` | — |
| `outlineVariant` | `color` | `"#CAC4D0"` | read/write | `Md3ColorScheme` | — |
| `shadow` | `color` | `"#000000"` | read/write | `Md3ColorScheme` | — |
| `scrim` | `color` | `"#000000"` | read/write | `Md3ColorScheme` | — |
| `inverseSurface` | `color` | `"#322F35"` | read/write | `Md3ColorScheme` | — |
| `colorOnInverseSurface` | `color` | `"#F5EFF7"` | read/write | `Md3ColorScheme` | — |
| `inversePrimary` | `color` | `"#D0BCFF"` | read/write | `Md3ColorScheme` | — |
| `surfaceTint` | `color` | `"#6750A4"` | read/write | `Md3ColorScheme` | — |
| `background` | `color` | `surface` | read/write | `Md3ColorScheme` | — |
| `colorOnBackground` | `color` | `colorOnSurface` | read/write | `Md3ColorScheme` | — |
| `surfaceVariant` | `color` | `surfaceContainerHighest` | read/write | `Md3ColorScheme` | — |
| `gaugeTrack` | `color` | `dark ? outlineVariant : surfaceContainerHighest` | readonly | `Md3ColorScheme` | Inactive gauge / chart track — solid roles (opacity tracks look washed out). Dark uses outlineVariant so arcs stay visible on surface *and* container cards. |
| `gaugeDial` | `color` | `dark ? surfaceContainerHigh : surfaceContainerHighest` | readonly | `Md3ColorScheme` | Filled dial face (wave / compass / knob). |

## Signals

_None._

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `withOpacity(c, a)` | `Md3ColorScheme` | — |
| `disabledContent()` | `Md3ColorScheme` | — |
| `disabledContainer()` | `Md3ColorScheme` | — |

## Example

```qml
import Md3

Md3ColorScheme {
    dark: false
    primary: "#6750A4"
    colorOnPrimary: "#FFFFFF"
    primaryContainer: "#EADDFF"
    colorOnPrimaryContainer: "#21005D"
}
```
