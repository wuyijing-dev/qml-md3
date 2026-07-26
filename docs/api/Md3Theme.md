# Md3Theme

- **Source:** `src/Md3/foundation/Md3Theme.qml`
- **Extends:** `QtObject`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `dark` | `bool` | `false` | read/write | `Md3Theme` | — |
| `seed` | `color` | `"#6750A4"` | read/write | `Md3Theme` | — |
| `textScale` | `real` | `1.0` | read/write | `Md3Theme` | — |
| `highContrast` | `bool` | `false` | read/write | `Md3Theme` | — |
| `colorScheme` | `Md3ColorScheme` | `Md3ColorScheme { }` | read/write | `Md3Theme` | — |
| `dynamicScheme` | `Md3DynamicScheme` | `Md3DynamicScheme { }` | read/write | `Md3Theme` | — |
| `typography` | `Md3Typography` | `Md3Typography {}` | read/write | `Md3Theme` | — |
| `shape` | `Md3Shape` | `Md3Shape {}` | read/write | `Md3Theme` | — |
| `elevation` | `Md3Elevation` | `Md3Elevation {}` | read/write | `Md3Theme` | — |
| `stateLayer` | `Md3StateLayer` | `Md3StateLayer {}` | read/write | `Md3Theme` | — |

## Signals

_None._

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `applySeed(c)` | `Md3Theme` | Rebuild the full MD3 role set from seed + dark (Material You–style). |
| `toggleDark()` | `Md3Theme` | — |
| `scaled(px)` | `Md3Theme` | — |

## Example

```qml
import Md3

Md3Theme {
    dark: false
    seed: "#6750A4"
    textScale: 1.0
    highContrast: false
    colorScheme: Md3ColorScheme { }
}
```
