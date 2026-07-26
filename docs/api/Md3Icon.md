# Md3Icon

- **Source:** `src/Md3/primitives/Md3Icon.qml`
- **Extends:** `Text`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `icon` | `string` | `"circle"` | read/write | `Md3Icon` | — |
| `size` | `int` | `24` | read/write | `Md3Icon` | — |
| `iconColor` | `color` | `Md3Theme.colorScheme.colorOnSurface` | read/write | `Md3Icon` | — |
| `variant` | `string` | `"filled"` | read/write | `Md3Icon` | — |

## Signals

_None._

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `ligatureFor(name)` | `Md3Icon` | — |

## Example

```qml
import Md3

Md3Icon {
    icon: "circle"
    size: 24
    iconColor: Md3Theme.colorScheme.colorOnSurface
    variant: "filled"
}
```
