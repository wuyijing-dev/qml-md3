# Md3Avatar

Circular avatar: image, initials, or icon fallback.

- **Source:** `src/Md3/components/Md3Avatar.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Enums

### `Md3Avatar.Size`

`Md3Avatar.ExtraSmall`, `Md3Avatar.Small`, `Md3Avatar.Medium`, `Md3Avatar.Large`, `Md3Avatar.ExtraLarge`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `sizePreset` | `int` | `Md3Avatar.Medium` | read/write | `Md3Avatar` | — |
| `source` | `url` | `""` | read/write | `Md3Avatar` | — |
| `initials` | `string` | `""` | read/write | `Md3Avatar` | — |
| `icon` | `string` | `"person"` | read/write | `Md3Avatar` | — |
| `color` | `color` | `Md3Theme.colorScheme.primaryContainer` | read/write | `Md3Avatar` | — |
| `contentColor` | `color` | `Md3Theme.colorScheme.colorOnPrimaryContainer` | read/write | `Md3Avatar` | — |
| `accessibleName` | `string` | `""` | read/write | `Md3Avatar` | — |
| `pixelSize` | `real` | `{…}` | readonly | `Md3Avatar` | — |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3Avatar {
    sizePreset: Md3Avatar.Medium
    source: ""
    initials: ""
    icon: "person"
    color: Md3Theme.colorScheme.primaryContainer
}
```
