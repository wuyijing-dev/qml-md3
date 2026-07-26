# Md3Button

- **Source:** `src/Md3/components/Md3Button.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Enums

### `Md3Button.Variant`

`Md3Button.Filled`, `Md3Button.FilledTonal`, `Md3Button.Elevated`, `Md3Button.Outlined`, `Md3Button.Text`

### `Md3Button.Size`

`Md3Button.ExtraSmall`, `Md3Button.Small`, `Md3Button.Medium`, `Md3Button.Large`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `variant` | `int` | `Md3Button.Filled` | read/write | `Md3Button` | — |
| `size` | `int` | `Md3Button.Small` | read/write | `Md3Button` | — |
| `text` | `string` | `""` | read/write | `Md3Button` | — |
| `icon` | `string` | `""` | read/write | `Md3Button` | — |
| `enabled` | `bool` | `true` | read/write | `Md3Button` | — |
| `accessibleName` | `string` | `text` | read/write | `Md3Button` | — |
| `visualFocus` | `bool` | `false` | read/write | `Md3Button` | — |
| `h` | `real` | `{…}` | readonly | `Md3Button` | — |
| `padH` | `real` | `size === Md3Button.ExtraSmall ? 12 : (size === Md3Button.Large ? 24 : 16)` | readonly | `Md3Button` | — |
| `corner` | `real` | `{…}` | readonly | `Md3Button` | — |
| `elev` | `real` | `variant === Md3Button.Elevated ? (hovered \|\| pressed ? 2 : 1) : 0` | readonly | `Md3Button` | — |
| `containerColor` | `color` | `{…}` | readonly | `Md3Button` | — |
| `contentColor` | `color` | `{…}` | readonly | `Md3Button` | — |
| `hovered` | `bool` | `mouse.containsMouse` | readonly | `Md3Button` | — |
| `pressed` | `bool` | `mouse.pressed` | readonly | `Md3Button` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `clicked()` | `Md3Button` | — |

## Methods

_None._

## Example

```qml
import Md3

Md3Button {
    variant: Md3Button.Filled
    size: Md3Button.Small
    text: ""
    icon: ""
    accessibleName: text
}
```
