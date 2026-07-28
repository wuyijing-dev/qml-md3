# Md3AvatarGroup

Overlapping row of avatars. model: [{ source?, initials?, icon?, color? }, ...] or strings (initials).

- **Source:** `src/Md3/components/Md3AvatarGroup.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `model` | `var` | `[]` | read/write | `Md3AvatarGroup` | — |
| `sizePreset` | `int` | `Md3Avatar.Medium` | read/write | `Md3AvatarGroup` | — |
| `maxVisible` | `int` | `4` | read/write | `Md3AvatarGroup` | — |
| `overlap` | `real` | `0.32` | read/write | `Md3AvatarGroup` | — |
| `surplusColor` | `color` | `Md3Theme.colorScheme.surfaceContainerHighest` | read/write | `Md3AvatarGroup` | — |
| `surplusContentColor` | `color` | `Md3Theme.colorScheme.colorOnSurfaceVariant` | read/write | `Md3AvatarGroup` | — |
| `avatarSize` | `real` | `{…}` | readonly | `Md3AvatarGroup` | — |
| `total` | `int` | `model ? model.length : 0` | readonly | `Md3AvatarGroup` | — |
| `shown` | `int` | `Math.min(total, maxVisible)` | readonly | `Md3AvatarGroup` | — |
| `surplus` | `int` | `Math.max(0, total - maxVisible)` | readonly | `Md3AvatarGroup` | — |
| `step` | `real` | `avatarSize * (1 - overlap)` | readonly | `Md3AvatarGroup` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `avatarClicked(int index)` | `Md3AvatarGroup` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `entryInitials(m)` | `Md3AvatarGroup` | — |

## Example

```qml
import Md3

Md3AvatarGroup {
    model: []
    sizePreset: Md3Avatar.Medium
    maxVisible: 4
    overlap: 0.32
    surplusColor: Md3Theme.colorScheme.surfaceContainerHighest
}
```
