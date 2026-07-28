# Md3Fab

- **Source:** `src/Md3/components/Md3Fab.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Enums

### `Md3Fab.Size`

`Md3Fab.Small`, `Md3Fab.Regular`, `Md3Fab.Large`

### `Md3Fab.ColorRole`

`Md3Fab.Primary`, `Md3Fab.Secondary`, `Md3Fab.Tertiary`, `Md3Fab.Surface`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `size` | `int` | `Md3Fab.Regular` | read/write | `Md3Fab` | — |
| `colorRole` | `int` | `Md3Fab.Primary` | read/write | `Md3Fab` | — |
| `icon` | `string` | `"add"` | read/write | `Md3Fab` | — |
| `enabled` | `bool` | `true` | read/write | `Md3Fab` | — |
| `accessibleName` | `string` | `"Floating action button"` | read/write | `Md3Fab` | — |
| `tooltip` | `string` | `""` | read/write | `Md3Fab` | — |
| `fabSize` | `real` | `{…}` | readonly | `Md3Fab` | — |
| `corner` | `real` | `{…}` | readonly | `Md3Fab` | — |
| `iconSize` | `real` | `size === Md3Fab.Large ? 36 : 24` | readonly | `Md3Fab` | — |
| `shadowPad` | `real` | `28` | read/write | `Md3Fab` | — |
| `containerColor` | `color` | `{…}` | readonly | `Md3Fab` | — |
| `contentColor` | `color` | `{…}` | readonly | `Md3Fab` | — |
| `hovered` | `bool` | `mouse.containsMouse` | readonly | `Md3Fab` | — |
| `pressed` | `bool` | `mouse.pressed` | readonly | `Md3Fab` | — |
| `focused` | `bool` | `activeFocus` | readonly | `Md3Fab` | — |
| `elev` | `real` | `{…}` | readonly | `Md3Fab` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `clicked()` | `Md3Fab` | — |

## Methods

_None._

## Example

```qml
import Md3

Md3Fab {
    size: Md3Fab.Regular
    colorRole: Md3Fab.Primary
    icon: "add"
    accessibleName: "Floating action button"
    tooltip: ""
}
```
