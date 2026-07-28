# Md3Theme

- **Source:** `src/Md3/foundation/Md3Theme.qml`
- **Extends:** `QtObject`
- **Singleton:** `true` (`pragma Singleton`)

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
| `reduceMotion` | `bool` | `false` | read/write | `Md3Theme` | Prefer near-instant motion for vestibular / a11y preferences. |
| `progressiveContent` | `bool` | `true` | read/write | `Md3Theme` | Within-page progressive load (Md3DeferredSection). Default on; set false to load everything immediately. |
| `colorScheme` | `Md3ColorScheme` | `{…}` | read/write | `Md3Theme` | — |
| `dynamicScheme` | `Md3DynamicScheme` | `{…}` | read/write | `Md3Theme` | — |
| `typography` | `Md3Typography` | `{…}` | read/write | `Md3Theme` | — |
| `shape` | `Md3Shape` | `{…}` | read/write | `Md3Theme` | — |
| `elevation` | `Md3Elevation` | `{…}` | read/write | `Md3Theme` | — |
| `stateLayer` | `Md3StateLayer` | `{…}` | read/write | `Md3Theme` | — |
| `accessibleOutline` | `color` | `highContrast` | readonly | `Md3Theme` | Outline role — stronger in high-contrast mode. |

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

// Singleton — use as `Md3Theme.…`
console.log(Md3Theme)
```
