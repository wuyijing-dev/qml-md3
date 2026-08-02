# Md3Shape

- **Source:** `src/Md3/foundation/Md3Shape.qml`
- **Extends:** `QtObject`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 7 | 0 | 1 | 0 |

_Also inherits Qt Quick `QtObject` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `none` | `real` | `0` | readonly | `Md3Shape` | None. |
| `extraSmall` | `real` | `4` | readonly | `Md3Shape` | Extra Small. |
| `small` | `real` | `8` | readonly | `Md3Shape` | Small. |
| `medium` | `real` | `12` | readonly | `Md3Shape` | Medium. |
| `large` | `real` | `16` | readonly | `Md3Shape` | Large. |
| `extraLarge` | `real` | `28` | readonly | `Md3Shape` | Extra Large. |
| `full` | `real` | `9999` | readonly | `Md3Shape` | Full. |

## Signals

_None._

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `radius(token)` | `—` | `Md3Shape` | Corner radius. |

## Example

```qml
import Md3

Md3Shape {
    // see properties above
}
```
