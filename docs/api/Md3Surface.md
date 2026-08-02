# Md3Surface

- **Source:** `src/Md3/primitives/Md3Surface.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 6 | 0 | 0 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `color` | `color` | `Md3Theme.colorScheme.surface` | read/write | `Md3Surface` | Foreground / content color. |
| `elevation` | `real` | `0` | read/write | `Md3Surface` | Elevation. |
| `radius` | `real` | `Md3Theme.shape.medium` | read/write | `Md3Surface` | Corner radius. |
| `clipContent` | `bool` | `true` | read/write | `Md3Surface` | Clip Content. |
| `tintColor` | `color` | `Md3Theme.colorScheme.surfaceTint` | read/write | `Md3Surface` | Tint Color. |
| `layoutMode` | `int` | `Md3ContainerBody.Fit` | read/write | `Md3Surface` | Layout Mode. |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3Surface {
    color: Md3Theme.colorScheme.surface
    elevation: 0
    radius: Md3Theme.shape.medium
    clipContent: true
    tintColor: Md3Theme.colorScheme.surfaceTint
    layoutMode: Md3ContainerBody.Fit
}
```
