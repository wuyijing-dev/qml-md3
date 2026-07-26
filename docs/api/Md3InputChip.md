# Md3InputChip

- **Source:** `src/Md3/components/Md3InputChip.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `text` | `string` | `""` | read/write | `Md3InputChip` | — |
| `avatarIcon` | `string` | `""` | read/write | `Md3InputChip` | — |
| `enabled` | `bool` | `true` | read/write | `Md3InputChip` | — |
| `accessibleName` | `string` | `text` | read/write | `Md3InputChip` | — |
| `contentColor` | `color` | `enabled ? Md3Theme.colorScheme.colorOnSurfaceVariant` | readonly | `Md3InputChip` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `clicked()` | `Md3InputChip` | — |
| `removed()` | `Md3InputChip` | — |

## Methods

_None._

## Example

```qml
import Md3

Md3InputChip {
    text: ""
    avatarIcon: ""
    accessibleName: text
}
```
