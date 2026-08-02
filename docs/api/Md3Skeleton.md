# Md3Skeleton

MD3 skeleton bone — low-cost opacity pulse (avoids continuous sheen transforms).

- **Source:** `src/Md3/components/Md3Skeleton.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 6 | 0 | 0 | 1 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Enums

### `Md3Skeleton.Variant`

`Md3Skeleton.Text`, `Md3Skeleton.Circular`, `Md3Skeleton.Rounded`, `Md3Skeleton.Rectangular`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `variant` | `int (Md3Skeleton.Variant)` | `Md3Skeleton.Rounded` | read/write | `Md3Skeleton` | Visual / role variant (see Enums). |
| `active` | `bool` | `true` | read/write | `Md3Skeleton` | Active. |
| `boneHeight` | `real` | `variant === Md3Skeleton.Text ? 12 : height` | read/write | `Md3Skeleton` | Bone Height. |
| `baseColor` | `color` | `Md3Theme.colorScheme.surfaceContainerHighest` | read/write | `Md3Skeleton` | Base Color. |
| `pulseOpacity` | `real` | `0.7` | read/write | `Md3Skeleton` | Pulse Opacity. |
| `unloadWhenPageInactive` | `bool` | `true` | read/write | `Md3Skeleton` | Unload When Page Inactive. |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3Skeleton {
    variant: Md3Skeleton.Rounded
    active: true
    boneHeight: variant === Md3Skeleton.Text ? 12 : height
    baseColor: Md3Theme.colorScheme.surfaceContainerHighest
    pulseOpacity: 0.7
    unloadWhenPageInactive: true
}
```
