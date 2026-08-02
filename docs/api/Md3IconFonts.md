# Md3IconFonts

Shared Material Icons font faces — one FontLoader pair for the whole app (not per Md3Icon).

- **Source:** `src/Md3/foundation/Md3IconFonts.qml`
- **Extends:** `QtObject`
- **Singleton:** `true` (`pragma Singleton`)

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 8 | 0 | 1 | 0 |

_Also inherits Qt Quick `QtObject` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `filledSource` | `url` | `"qrc:/md3/fonts/resources/fonts/MaterialIcons-Regular.ttf"` | readonly | `Md3IconFonts` | Filled Source. |
| `outlinedSource` | `url` | `"qrc:/md3/fonts/resources/fonts/MaterialIconsOutlined-Regular.otf"` | readonly | `Md3IconFonts` | Outlined Source. |
| `filledLoader` | `FontLoader` | `{…}` | readonly | `Md3IconFonts` | Filled Loader. |
| `outlinedLoader` | `FontLoader` | `{…}` | readonly | `Md3IconFonts` | Outlined Loader. |
| `filledReady` | `bool` | `filledLoader.status === FontLoader.Ready` | readonly | `Md3IconFonts` | Filled Ready. |
| `outlinedReady` | `bool` | `outlinedLoader.status === FontLoader.Ready` | readonly | `Md3IconFonts` | Outlined Ready. |
| `filledFamily` | `string` | `filledReady ? filledLoader.name : Md3Theme.typography.iconFontFamily` | readonly | `Md3IconFonts` | Filled Family. |
| `outlinedFamily` | `string` | `outlinedReady ? outlinedLoader.name : Md3Theme.typography.iconFontFamilyOutlined` | readonly | `Md3IconFonts` | Outlined Family. |

## Signals

_None._

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `familyFor(variant)` | `—` | `Md3IconFonts` | Family For. |

## Example

```qml
import Md3

// Singleton — use as `Md3IconFonts.…`
console.log(Md3IconFonts)
```
