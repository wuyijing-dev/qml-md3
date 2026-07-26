# Md3FilterChip

- **Source:** `src/Md3/components/Md3FilterChip.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `text` | `string` | `""` | read/write | `Md3FilterChip` | — |
| `icon` | `string` | `""` | read/write | `Md3FilterChip` | — |
| `selected` | `bool` | `false` | read/write | `Md3FilterChip` | — |
| `elevated` | `bool` | `false` | read/write | `Md3FilterChip` | — |
| `enabled` | `bool` | `true` | read/write | `Md3FilterChip` | — |
| `accessibleName` | `string` | `text` | read/write | `Md3FilterChip` | — |
| `chipHeight` | `real` | `32` | read/write | `Md3FilterChip` | Compact density for title bars (e.g. 24) |
| `iconSize` | `real` | `18` | read/write | `Md3FilterChip` | — |
| `fontSize` | `real` | `Md3Theme.scaled(Md3Theme.typography.labelLarge.size)` | read/write | `Md3FilterChip` | — |
| `containerColor` | `color` | `{…}` | readonly | `Md3FilterChip` | — |
| `contentColor` | `color` | `{…}` | readonly | `Md3FilterChip` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `clicked()` | `Md3FilterChip` | — |

## Methods

_None._

## Example

```qml
import Md3

Md3FilterChip {
    text: ""
    icon: ""
    selected: false
    elevated: false
    accessibleName: text
}
```
