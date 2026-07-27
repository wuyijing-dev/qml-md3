# Md3Typography

- **Source:** `src/Md3/foundation/Md3Typography.qml`
- **Extends:** `QtObject`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `fontFamily` | `string` | `"HarmonyOS Sans SC"` | readonly | `Md3Typography` | — |
| `fontFamilyFallback` | `string` | `"Segoe UI"` | readonly | `Md3Typography` | — |
| `iconFontFamily` | `string` | `"Material Icons"` | readonly | `Md3Typography` | — |
| `iconFontFamilyOutlined` | `string` | `"Material Icons Outlined"` | readonly | `Md3Typography` | — |
| `iconFontFamilyFallback` | `string` | `"Segoe MDL2 Assets"` | readonly | `Md3Typography` | — |
| `displayLarge` | `var` | `({ size: 57, weight: Font.Normal, letterSpacing: -0.25, lineHeight: 64 })` | readonly | `Md3Typography` | — |
| `displayMedium` | `var` | `({ size: 45, weight: Font.Normal, letterSpacing: 0, lineHeight: 52 })` | readonly | `Md3Typography` | — |
| `displaySmall` | `var` | `({ size: 36, weight: Font.Normal, letterSpacing: 0, lineHeight: 44 })` | readonly | `Md3Typography` | — |
| `headlineLarge` | `var` | `({ size: 32, weight: Font.Normal, letterSpacing: 0, lineHeight: 40 })` | readonly | `Md3Typography` | — |
| `headlineMedium` | `var` | `({ size: 28, weight: Font.Normal, letterSpacing: 0, lineHeight: 36 })` | readonly | `Md3Typography` | — |
| `headlineSmall` | `var` | `({ size: 24, weight: Font.Normal, letterSpacing: 0, lineHeight: 32 })` | readonly | `Md3Typography` | — |
| `titleLarge` | `var` | `({ size: 22, weight: Font.Normal, letterSpacing: 0, lineHeight: 28 })` | readonly | `Md3Typography` | — |
| `titleMedium` | `var` | `({ size: 16, weight: Font.Medium, letterSpacing: 0.15, lineHeight: 24 })` | readonly | `Md3Typography` | — |
| `titleSmall` | `var` | `({ size: 14, weight: Font.Medium, letterSpacing: 0.1, lineHeight: 20 })` | readonly | `Md3Typography` | — |
| `bodyLarge` | `var` | `({ size: 16, weight: Font.Normal, letterSpacing: 0.5, lineHeight: 24 })` | readonly | `Md3Typography` | — |
| `bodyMedium` | `var` | `({ size: 14, weight: Font.Normal, letterSpacing: 0.25, lineHeight: 20 })` | readonly | `Md3Typography` | — |
| `bodySmall` | `var` | `({ size: 12, weight: Font.Normal, letterSpacing: 0.4, lineHeight: 16 })` | readonly | `Md3Typography` | — |
| `labelLarge` | `var` | `({ size: 14, weight: Font.Medium, letterSpacing: 0.1, lineHeight: 20 })` | readonly | `Md3Typography` | — |
| `labelMedium` | `var` | `({ size: 12, weight: Font.Medium, letterSpacing: 0.5, lineHeight: 16 })` | readonly | `Md3Typography` | — |
| `labelSmall` | `var` | `({ size: 11, weight: Font.Medium, letterSpacing: 0.5, lineHeight: 16 })` | readonly | `Md3Typography` | — |

## Signals

_None._

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `applyTo(textItem, role)` | `Md3Typography` | — |

## Example

```qml
import Md3

Md3Typography {
    // see properties above
}
```
