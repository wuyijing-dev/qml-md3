# Md3AvatarGroup

Overlapping row of avatars. model: [{ source?, initials?, icon?, color? }, ...] or strings (initials).

- **Source:** `src/Md3/components/Md3AvatarGroup.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 11 | 1 | 1 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `model` | `var` | `[]` | read/write | `Md3AvatarGroup` | Data model. |
| `sizePreset` | `int` | `Md3Avatar.Medium` | read/write | `Md3AvatarGroup` | Size Preset. |
| `maxVisible` | `int` | `4` | read/write | `Md3AvatarGroup` | Max Visible. |
| `overlap` | `real` | `0.32` | read/write | `Md3AvatarGroup` | Overlap. |
| `surplusColor` | `color` | `Md3Theme.colorScheme.surfaceContainerHighest` | read/write | `Md3AvatarGroup` | Surplus Color. |
| `surplusContentColor` | `color` | `Md3Theme.colorScheme.colorOnSurfaceVariant` | read/write | `Md3AvatarGroup` | Surplus Content Color. |
| `avatarSize` | `real` | `{…}` | readonly | `Md3AvatarGroup` | Avatar Size. |
| `total` | `int` | `model ? model.length : 0` | readonly | `Md3AvatarGroup` | Total. |
| `shown` | `int` | `Math.min(total, maxVisible)` | readonly | `Md3AvatarGroup` | Shown. |
| `surplus` | `int` | `Math.max(0, total - maxVisible)` | readonly | `Md3AvatarGroup` | Surplus. |
| `step` | `real` | `avatarSize * (1 - overlap)` | readonly | `Md3AvatarGroup` | Step. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `avatarClicked(int index)` | `Md3AvatarGroup` | Emitted when avatar Clicked. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `entryInitials(m)` | `—` | `Md3AvatarGroup` | Entry Initials. |

## Example

```qml
import Md3

Md3AvatarGroup {
    model: []
    sizePreset: Md3Avatar.Medium
    maxVisible: 4
    overlap: 0.32
    surplusColor: Md3Theme.colorScheme.surfaceContainerHighest
    surplusContentColor: Md3Theme.colorScheme.colorOnSurfaceVariant
}
```
