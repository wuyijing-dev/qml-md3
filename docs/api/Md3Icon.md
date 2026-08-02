# Md3Icon

- **Source:** `src/Md3/primitives/Md3Icon.qml`
- **Extends:** `Text`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 4 | 0 | 1 | 0 |

_Also inherits Qt Quick `Text` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `icon` | `string` | `"circle"` | read/write | `Md3Icon` | Material icon name or empty. |
| `size` | `int` | `24` | read/write | `Md3Icon` | Control size token (see Enums). |
| `iconColor` | `color` | `Md3Theme.colorScheme.colorOnSurface` | read/write | `Md3Icon` | Icon Color. |
| `variant` | `string` | `"filled"` | read/write | `Md3Icon` | Visual / role variant (see Enums). |

## Signals

_None._

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `ligatureFor(name)` | `—` | `Md3Icon` | Ligature For. |

## Example

```qml
import Md3

Md3Icon {
    icon: "circle"
    size: 24
    iconColor: Md3Theme.colorScheme.colorOnSurface
    variant: "filled"
}
```
