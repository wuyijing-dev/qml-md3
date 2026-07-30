import QtQuick
import Md3

/*
  Material You–style dynamic scheme from a seed color.
  Approximates ColorScheme.fromSeed (HCT) via HSL tonal mapping —
  enough for live theming without a native material-color-utilities port.
*/
QtObject {
    id: root

    function clamp01(x) { return Math.max(0, Math.min(1, x)) }

    function hsl(h, s, l, a) {
        // h in 0..1, s/l in 0..1
        return Qt.hsla(clamp01(h), clamp01(s), clamp01(l), a === undefined ? 1 : a)
    }

    function wrapHue(h) {
        let x = h % 1
        if (x < 0)
            x += 1
        return x
    }

    /// Relative luminance helper for contrast picks
    function luminance(c) {
        return 0.2126 * c.r + 0.7152 * c.g + 0.0722 * c.b
    }

    function onColorFor(bg) {
        return luminance(bg) > 0.45 ? "#1C1B1F" : "#FFFFFF"
    }

    /**
     * Apply a full MD3 role set onto `scheme` (Md3ColorScheme).
     * @param scheme Md3ColorScheme instance
     * @param seedColor Qt color / string
     * @param isDark bool
     */
    function applyTo(scheme, seedColor, isDark) {
        const seed = Qt.color(seedColor)
        const h = seed.hslHue
        const hTer = wrapHue(h + 0.18)   // ~65°
        const hErr = 0.03                // reds

        // Keep some chroma from seed, but clamp for readable palettes
        const seedChroma = Math.max(0.25, Math.min(0.65, seed.hslSaturation))

        if (isDark) {
            scheme.primary = hsl(h, seedChroma * 0.7, 0.80)
            scheme.colorOnPrimary = hsl(h, 0.40, 0.20)
            scheme.primaryContainer = hsl(h, seedChroma * 0.55, 0.35)
            scheme.colorOnPrimaryContainer = hsl(h, 0.40, 0.90)
            scheme.primaryFixed = hsl(h, 0.55, 0.90)
            scheme.primaryFixedDim = hsl(h, 0.45, 0.80)
            scheme.colorOnPrimaryFixed = hsl(h, 0.40, 0.12)
            scheme.colorOnPrimaryFixedVariant = hsl(h, 0.35, 0.35)

            scheme.secondary = hsl(h, 0.20, 0.80)
            scheme.colorOnSecondary = hsl(h, 0.20, 0.20)
            scheme.secondaryContainer = hsl(h, 0.18, 0.30)
            scheme.colorOnSecondaryContainer = hsl(h, 0.15, 0.90)
            scheme.secondaryFixed = hsl(h, 0.20, 0.90)
            scheme.secondaryFixedDim = hsl(h, 0.18, 0.80)
            scheme.colorOnSecondaryFixed = hsl(h, 0.15, 0.12)
            scheme.colorOnSecondaryFixedVariant = hsl(h, 0.12, 0.35)

            scheme.tertiary = hsl(hTer, 0.35, 0.80)
            scheme.colorOnTertiary = hsl(hTer, 0.30, 0.20)
            scheme.tertiaryContainer = hsl(hTer, 0.28, 0.32)
            scheme.colorOnTertiaryContainer = hsl(hTer, 0.25, 0.90)
            scheme.tertiaryFixed = hsl(hTer, 0.40, 0.90)
            scheme.tertiaryFixedDim = hsl(hTer, 0.32, 0.80)
            scheme.colorOnTertiaryFixed = hsl(hTer, 0.30, 0.12)
            scheme.colorOnTertiaryFixedVariant = hsl(hTer, 0.25, 0.35)

            scheme.error = hsl(hErr, 0.55, 0.80)
            scheme.colorOnError = hsl(hErr, 0.50, 0.20)
            scheme.errorContainer = hsl(hErr, 0.45, 0.30)
            scheme.colorOnErrorContainer = hsl(hErr, 0.40, 0.90)

            scheme.dark = true
            scheme.surface = hsl(h, 0.08, 0.08)
            scheme.colorOnSurface = hsl(h, 0.06, 0.90)
            scheme.surfaceDim = hsl(h, 0.08, 0.08)
            // Keep surface steps tight; tracks use outlineVariant (not translucent onSurface).
            scheme.surfaceBright = hsl(h, 0.07, 0.28)
            scheme.surfaceContainerLowest = hsl(h, 0.08, 0.05)
            scheme.surfaceContainerLow = hsl(h, 0.07, 0.12)
            scheme.surfaceContainer = hsl(h, 0.07, 0.14)
            scheme.surfaceContainerHigh = hsl(h, 0.06, 0.20)
            scheme.surfaceContainerHighest = hsl(h, 0.06, 0.24)
            scheme.colorOnSurfaceVariant = hsl(h, 0.08, 0.78)
            scheme.outline = hsl(h, 0.08, 0.60)
            scheme.outlineVariant = hsl(h, 0.08, 0.36)
            scheme.inverseSurface = hsl(h, 0.06, 0.90)
            scheme.colorOnInverseSurface = hsl(h, 0.07, 0.18)
            scheme.inversePrimary = hsl(h, seedChroma * 0.55, 0.40)
            scheme.surfaceTint = scheme.primary
        } else {
            scheme.primary = hsl(h, seedChroma * 0.75, 0.40)
            scheme.colorOnPrimary = "#FFFFFF"
            scheme.primaryContainer = hsl(h, seedChroma * 0.55, 0.90)
            scheme.colorOnPrimaryContainer = hsl(h, 0.45, 0.15)
            scheme.primaryFixed = scheme.primaryContainer
            scheme.primaryFixedDim = hsl(h, seedChroma * 0.55, 0.80)
            scheme.colorOnPrimaryFixed = hsl(h, 0.45, 0.12)
            scheme.colorOnPrimaryFixedVariant = hsl(h, 0.40, 0.35)

            scheme.secondary = hsl(h, 0.16, 0.40)
            scheme.colorOnSecondary = "#FFFFFF"
            scheme.secondaryContainer = hsl(h, 0.22, 0.90)
            scheme.colorOnSecondaryContainer = hsl(h, 0.18, 0.15)
            scheme.secondaryFixed = scheme.secondaryContainer
            scheme.secondaryFixedDim = hsl(h, 0.18, 0.80)
            scheme.colorOnSecondaryFixed = hsl(h, 0.15, 0.12)
            scheme.colorOnSecondaryFixedVariant = hsl(h, 0.12, 0.35)

            scheme.tertiary = hsl(hTer, 0.28, 0.40)
            scheme.colorOnTertiary = "#FFFFFF"
            scheme.tertiaryContainer = hsl(hTer, 0.40, 0.90)
            scheme.colorOnTertiaryContainer = hsl(hTer, 0.30, 0.15)
            scheme.tertiaryFixed = scheme.tertiaryContainer
            scheme.tertiaryFixedDim = hsl(hTer, 0.32, 0.80)
            scheme.colorOnTertiaryFixed = hsl(hTer, 0.30, 0.12)
            scheme.colorOnTertiaryFixedVariant = hsl(hTer, 0.25, 0.35)

            scheme.error = hsl(hErr, 0.65, 0.40)
            scheme.colorOnError = "#FFFFFF"
            scheme.errorContainer = hsl(hErr, 0.55, 0.90)
            scheme.colorOnErrorContainer = hsl(hErr, 0.55, 0.15)

            scheme.dark = false
            scheme.surface = hsl(h, 0.20, 0.98)
            scheme.colorOnSurface = hsl(h, 0.08, 0.12)
            scheme.surfaceDim = hsl(h, 0.10, 0.87)
            scheme.surfaceBright = scheme.surface
            scheme.surfaceContainerLowest = "#FFFFFF"
            scheme.surfaceContainerLow = hsl(h, 0.16, 0.96)
            scheme.surfaceContainer = hsl(h, 0.14, 0.94)
            scheme.surfaceContainerHigh = hsl(h, 0.12, 0.92)
            scheme.surfaceContainerHighest = hsl(h, 0.10, 0.90)
            scheme.colorOnSurfaceVariant = hsl(h, 0.08, 0.32)
            scheme.outline = hsl(h, 0.08, 0.50)
            scheme.outlineVariant = hsl(h, 0.10, 0.80)
            scheme.inverseSurface = hsl(h, 0.08, 0.20)
            scheme.colorOnInverseSurface = hsl(h, 0.10, 0.95)
            scheme.inversePrimary = hsl(h, seedChroma * 0.55, 0.80)
            scheme.surfaceTint = scheme.primary
        }

        scheme.shadow = "#000000"
        scheme.scrim = "#000000"
        scheme.background = scheme.surface
        scheme.colorOnBackground = scheme.colorOnSurface
        scheme.surfaceVariant = scheme.surfaceContainerHighest
    }
}
