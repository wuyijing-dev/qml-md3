# Md3IconButton

- **Source:** `src/Md3/components/Md3IconButton.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Enums

### `Md3IconButton.Variant`

`Md3IconButton.Standard`, `Md3IconButton.Filled`, `Md3IconButton.FilledTonal`, `Md3IconButton.Outlined`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `variant` | `int` | `Md3IconButton.Standard` | read/write | `Md3IconButton` | — |
| `icon` | `string` | `"favorite"` | read/write | `Md3IconButton` | — |
| `enabled` | `bool` | `true` | read/write | `Md3IconButton` | — |
| `selected` | `bool` | `false` | read/write | `Md3IconButton` | — |
| `accessibleName` | `string` | `icon` | read/write | `Md3IconButton` | — |
| `visualFocus` | `bool` | `false` | read/write | `Md3IconButton` | — |
| `badgeText` | `string` | `""` | read/write | `Md3IconButton` | Built-in badge label |
| `badgeDot` | `bool` | `false` | read/write | `Md3IconButton` | Dot badge |
| `badgeMax` | `int` | `99` | read/write | `Md3IconButton` | Cap for numeric badge |
| `circleSize` | `real` | `40` | readonly | `Md3IconButton` | — |
| `circleRadius` | `real` | `circleSize / 2` | readonly | `Md3IconButton` | — |
| `containerColor` | `color` | `{…}` | readonly | `Md3IconButton` | — |
| `contentColor` | `color` | `{…}` | readonly | `Md3IconButton` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `clicked()` | `Md3IconButton` | — |

## Methods

_None._

## Example

```qml
import Md3

Md3IconButton {
    icon: "notifications"
    badgeText: "3"
}
```
