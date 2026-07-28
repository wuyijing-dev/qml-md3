# Md3Badged

Wraps content and positions an Md3Badge (top-end by default).

- **Source:** `src/Md3/components/Md3Badged.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `badge` | `alias` | `badgeItem` | read/write | `Md3Badged` | Alias → `badgeItem` |
| `badgeText` | `string` | `""` | read/write | `Md3Badged` | — |
| `badgeDot` | `bool` | `false` | read/write | `Md3Badged` | — |
| `badgeMax` | `int` | `99` | read/write | `Md3Badged` | — |
| `badgeSizePreset` | `int` | `Md3Badge.Medium` | read/write | `Md3Badged` | — |
| `badgeColor` | `color` | `Md3Theme.colorScheme.error` | read/write | `Md3Badged` | — |
| `badgeLabelColor` | `color` | `Md3Theme.colorScheme.colorOnError` | read/write | `Md3Badged` | — |
| `badgeVisible` | `bool` | `badgeDot \|\| badgeText.length > 0` | read/write | `Md3Badged` | — |
| `badgeOffsetX` | `real` | `2` | read/write | `Md3Badged` | Offset from the top-end corner |
| `badgeOffsetY` | `real` | `-2` | read/write | `Md3Badged` | — |
| `content` | `alias` | `contentHost.data` | default read/write | `Md3Badged` | Default property → `contentHost.data` |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3Badged {
    badgeText: ""
    badgeDot: false
    badgeMax: 99
    badgeSizePreset: Md3Badge.Medium
    badgeColor: Md3Theme.colorScheme.error
}
```
