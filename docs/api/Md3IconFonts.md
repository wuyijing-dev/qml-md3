# Md3IconFonts

Shared Material Icons font faces — one FontLoader pair for the whole app (not per Md3Icon).

- **Source:** `src/Md3/foundation/Md3IconFonts.qml`
- **Extends:** `QtObject`
- **Singleton:** `true` (`pragma Singleton`)

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `filledSource` | `url` | `"qrc:/md3/fonts/resources/fonts/MaterialIcons-Regular.ttf"` | readonly | `Md3IconFonts` | — |
| `outlinedSource` | `url` | `"qrc:/md3/fonts/resources/fonts/MaterialIconsOutlined-Regular.otf"` | readonly | `Md3IconFonts` | — |
| `filledLoader` | `FontLoader` | `{…}` | readonly | `Md3IconFonts` | — |
| `outlinedLoader` | `FontLoader` | `{…}` | readonly | `Md3IconFonts` | — |
| `filledReady` | `bool` | `filledLoader.status === FontLoader.Ready` | readonly | `Md3IconFonts` | — |
| `outlinedReady` | `bool` | `outlinedLoader.status === FontLoader.Ready` | readonly | `Md3IconFonts` | — |
| `filledFamily` | `string` | `filledReady ? filledLoader.name : Md3Theme.typography.iconFontFamily` | readonly | `Md3IconFonts` | — |
| `outlinedFamily` | `string` | `outlinedReady ? outlinedLoader.name : Md3Theme.typography.iconFontFamilyOutlined` | readonly | `Md3IconFonts` | — |

## Signals

_None._

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `familyFor(variant)` | `Md3IconFonts` | — |

## Example

```qml
import Md3

// Singleton — use as `Md3IconFonts.…`
console.log(Md3IconFonts)
```
