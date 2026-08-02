# Md3Typography

- **Source:** `src/Md3/foundation/Md3Typography.qml`
- **Extends:** `QtObject`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 20 | 0 | 2 | 0 |

_Also inherits Qt Quick `QtObject` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `fontFamily` | `string` | `"HarmonyOS Sans SC"` | readonly | `Md3Typography` | Font Family. |
| `fontFamilyFallback` | `string` | `{…}` | readonly | `Md3Typography` | Font Family Fallback. |
| `iconFontFamily` | `string` | `"Material Icons"` | readonly | `Md3Typography` | Icon Font Family. |
| `iconFontFamilyOutlined` | `string` | `"Material Icons Outlined"` | readonly | `Md3Typography` | Icon Font Family Outlined. |
| `iconFontFamilyFallback` | `string` | `"Segoe MDL2 Assets"` | readonly | `Md3Typography` | Icon Font Family Fallback. |
| `displayLarge` | `var` | `{…}` | readonly | `Md3Typography` | Display Large. |
| `displayMedium` | `var` | `{…}` | readonly | `Md3Typography` | Display Medium. |
| `displaySmall` | `var` | `{…}` | readonly | `Md3Typography` | Display Small. |
| `headlineLarge` | `var` | `{…}` | readonly | `Md3Typography` | Headline Large. |
| `headlineMedium` | `var` | `{…}` | readonly | `Md3Typography` | Headline Medium. |
| `headlineSmall` | `var` | `{…}` | readonly | `Md3Typography` | Headline Small. |
| `titleLarge` | `var` | `{…}` | readonly | `Md3Typography` | Title Large. |
| `titleMedium` | `var` | `{…}` | readonly | `Md3Typography` | Title Medium. |
| `titleSmall` | `var` | `{…}` | readonly | `Md3Typography` | Title Small. |
| `bodyLarge` | `var` | `{…}` | readonly | `Md3Typography` | Body Large. |
| `bodyMedium` | `var` | `{…}` | readonly | `Md3Typography` | Body Medium. |
| `bodySmall` | `var` | `{…}` | readonly | `Md3Typography` | Body Small. |
| `labelLarge` | `var` | `{…}` | readonly | `Md3Typography` | Label Large. |
| `labelMedium` | `var` | `{…}` | readonly | `Md3Typography` | Label Medium. |
| `labelSmall` | `var` | `{…}` | readonly | `Md3Typography` | Label Small. |

## Signals

_None._

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `applyUiFont(textItem)` | `—` | `Md3Typography` | Apply Ui Font. |
| `applyTo(textItem, role)` | `—` | `Md3Typography` | Apply To. |

## Example

```qml
import Md3

Md3Typography {
    // see properties above
}
```
