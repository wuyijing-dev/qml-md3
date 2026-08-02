# Md3Badge

Material Badge — numeric / dot / max-count, attach to any item via anchors.

- **Source:** `src/Md3/components/Md3Badge.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 12 | 0 | 0 | 1 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Enums

### `Md3Badge.Size`

`Md3Badge.Small`, `Md3Badge.Medium`, `Md3Badge.Large`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `text` | `string` | `""` | read/write | `Md3Badge` | Primary label text. |
| `dot` | `bool` | `false` | read/write | `Md3Badge` | Dot. |
| `max` | `int` | `999` | read/write | `Md3Badge` | Cap display, e.g. 99 → "99+" |
| `sizePreset` | `int (Md3Badge.Size)` | `Md3Badge.Medium` | read/write | `Md3Badge` | Size Preset. |
| `badgeColor` | `color` | `Md3Theme.colorScheme.error` | read/write | `Md3Badge` | Badge Color. |
| `labelColor` | `color` | `Md3Theme.colorScheme.colorOnError` | read/write | `Md3Badge` | Label Color. |
| `displayText` | `string` | `{…}` | readonly | `Md3Badge` | Display Text. |
| `large` | `bool` | `!dot && displayText.length > 0` | readonly | `Md3Badge` | Large. |
| `padX` | `real` | `{…}` | readonly | `Md3Badge` | Pad X. |
| `fixedHeight` | `real` | `{…}` | readonly | `Md3Badge` | Fixed height per preset (label badges); dots use a smaller side. |
| `dotSide` | `real` | `{…}` | readonly | `Md3Badge` | Dot Side. |
| `fontPx` | `real` | `{…}` | readonly | `Md3Badge` | Font Px. |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3Badge {
    text: ""
    dot: false
    max: 999
    sizePreset: Md3Badge.Medium
    badgeColor: Md3Theme.colorScheme.error
    labelColor: Md3Theme.colorScheme.colorOnError
}
```
