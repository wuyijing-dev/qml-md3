# Md3Badge

Material Badge — numeric / dot / max-count, attach to any item via anchors.

- **Source:** `src/Md3/components/Md3Badge.qml`
- **Extends:** `Item`

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
| `text` | `string` | `""` | read/write | `Md3Badge` | — |
| `dot` | `bool` | `false` | read/write | `Md3Badge` | — |
| `max` | `int` | `999` | read/write | `Md3Badge` | Cap display, e.g. 99 → "99+" |
| `sizePreset` | `int` | `Md3Badge.Medium` | read/write | `Md3Badge` | — |
| `badgeColor` | `color` | `Md3Theme.colorScheme.error` | read/write | `Md3Badge` | — |
| `labelColor` | `color` | `Md3Theme.colorScheme.colorOnError` | read/write | `Md3Badge` | — |
| `displayText` | `string` | `{…}` | readonly | `Md3Badge` | — |
| `large` | `bool` | `!dot && displayText.length > 0` | readonly | `Md3Badge` | — |
| `padX` | `real` | `{…}` | readonly | `Md3Badge` | — |
| `fixedHeight` | `real` | `{…}` | readonly | `Md3Badge` | Fixed height per preset (label badges); dots use a smaller side. |
| `dotSide` | `real` | `{…}` | readonly | `Md3Badge` | — |
| `fontPx` | `real` | `{…}` | readonly | `Md3Badge` | — |

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
}
```
