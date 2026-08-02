# Md3Badged

Wraps content and positions an Md3Badge (top-end by default).

- **Source:** `src/Md3/components/Md3Badged.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 11 | 0 | 0 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `badge` | `alias` | `badgeItem` | read/write | `Md3Badged` | Badge. |
| `badgeText` | `string` | `""` | read/write | `Md3Badged` | Badge Text. |
| `badgeDot` | `bool` | `false` | read/write | `Md3Badged` | Badge Dot. |
| `badgeMax` | `int` | `99` | read/write | `Md3Badged` | Badge Max. |
| `badgeSizePreset` | `int` | `Md3Badge.Medium` | read/write | `Md3Badged` | Badge Size Preset. |
| `badgeColor` | `color` | `Md3Theme.colorScheme.error` | read/write | `Md3Badged` | Badge Color. |
| `badgeLabelColor` | `color` | `Md3Theme.colorScheme.colorOnError` | read/write | `Md3Badged` | Badge Label Color. |
| `badgeVisible` | `bool` | `badgeDot \|\| badgeText.length > 0` | read/write | `Md3Badged` | Badge Visible. |
| `badgeOffsetX` | `real` | `2` | read/write | `Md3Badged` | Offset from the top-end corner |
| `badgeOffsetY` | `real` | `-2` | read/write | `Md3Badged` | Badge Offset Y. |
| `content` | `alias` | `contentHost.data` | default read/write | `Md3Badged` | Content. |

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
    badgeLabelColor: Md3Theme.colorScheme.colorOnError
}
```
