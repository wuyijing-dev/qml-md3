# Md3ExtendedFab

- **Source:** `src/Md3/components/Md3ExtendedFab.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Enums

### `Md3ExtendedFab.ColorRole`

`Md3ExtendedFab.Primary`, `Md3ExtendedFab.Secondary`, `Md3ExtendedFab.Tertiary`, `Md3ExtendedFab.Surface`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `colorRole` | `int` | `Md3ExtendedFab.Primary` | read/write | `Md3ExtendedFab` | — |
| `icon` | `string` | `"add"` | read/write | `Md3ExtendedFab` | — |
| `text` | `string` | `"Create"` | read/write | `Md3ExtendedFab` | — |
| `extended` | `bool` | `true` | read/write | `Md3ExtendedFab` | — |
| `enabled` | `bool` | `true` | read/write | `Md3ExtendedFab` | — |
| `accessibleName` | `string` | `text` | read/write | `Md3ExtendedFab` | — |
| `fabHeight` | `real` | `56` | readonly | `Md3ExtendedFab` | — |
| `corner` | `real` | `Md3Theme.shape.large` | readonly | `Md3ExtendedFab` | — |
| `iconSize` | `real` | `24` | readonly | `Md3ExtendedFab` | — |
| `padStart` | `real` | `icon.length > 0 ? 16 : 20` | readonly | `Md3ExtendedFab` | — |
| `padEnd` | `real` | `20` | readonly | `Md3ExtendedFab` | — |
| `containerColor` | `color` | `{…}` | readonly | `Md3ExtendedFab` | — |
| `contentColor` | `color` | `{…}` | readonly | `Md3ExtendedFab` | — |
| `hovered` | `bool` | `mouse.containsMouse` | readonly | `Md3ExtendedFab` | — |
| `pressed` | `bool` | `mouse.pressed` | readonly | `Md3ExtendedFab` | — |
| `focused` | `bool` | `activeFocus` | readonly | `Md3ExtendedFab` | — |
| `elev` | `real` | `enabled ? (hovered && !pressed ? 8 : 6) : 0` | readonly | `Md3ExtendedFab` | — |
| `shadowPad` | `real` | `28` | readonly | `Md3ExtendedFab` | — |
| `collapsedWidth` | `real` | `fabHeight` | readonly | `Md3ExtendedFab` | — |
| `expandedWidth` | `real` | `padStart + (icon.length > 0 ? iconSize + 8 : 0)` | readonly | `Md3ExtendedFab` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `clicked()` | `Md3ExtendedFab` | — |

## Methods

_None._

## Example

```qml
import Md3

Md3ExtendedFab {
    colorRole: Md3ExtendedFab.Primary
    icon: "add"
    text: "Create"
    extended: true
    accessibleName: text
}
```
