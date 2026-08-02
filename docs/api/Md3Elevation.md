# Md3Elevation

- **Source:** `src/Md3/foundation/Md3Elevation.qml`
- **Extends:** `QtObject`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 6 | 0 | 10 | 0 |

_Also inherits Qt Quick `QtObject` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `level0` | `real` | `0` | readonly | `Md3Elevation` | Level0. |
| `level1` | `real` | `1` | readonly | `Md3Elevation` | Level1. |
| `level2` | `real` | `3` | readonly | `Md3Elevation` | Level2. |
| `level3` | `real` | `6` | readonly | `Md3Elevation` | Level3. |
| `level4` | `real` | `8` | readonly | `Md3Elevation` | Level4. |
| `level5` | `real` | `12` | readonly | `Md3Elevation` | Level5. |

## Signals

_None._

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `tintOpacity(level)` | `—` | `Md3Elevation` | Tint Opacity. |
| `keyY(level)` | `—` | `Md3Elevation` | Key Y. |
| `keyBlur(level)` | `—` | `Md3Elevation` | Key Blur. |
| `keyOpacity(level)` | `—` | `Md3Elevation` | Key Opacity. |
| `ambientY(level)` | `—` | `Md3Elevation` | Ambient Y. |
| `ambientBlur(level)` | `—` | `Md3Elevation` | Ambient Blur. |
| `ambientOpacity(level)` | `—` | `Md3Elevation` | Ambient Opacity. |
| `shadowY(level)` | `—` | `Md3Elevation` | Shadow Y. |
| `shadowBlur(level)` | `—` | `Md3Elevation` | Shadow Blur. |
| `shadowOpacity(level)` | `—` | `Md3Elevation` | Shadow Opacity. |

## Example

```qml
import Md3

Md3Elevation {
    // see properties above
}
```
