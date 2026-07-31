# Md3MorphLoadingIndicator

Material 3 Expressive morph loading indicator — rounded 8-lobe clover / asterisk.

- **Source:** `src/Md3/components/Md3MorphLoadingIndicator.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Enums

### `Md3MorphLoadingIndicator.Variant`

`Md3MorphLoadingIndicator.Bare`, `Md3MorphLoadingIndicator.Contained`

### `Md3MorphLoadingIndicator.Size`

`Md3MorphLoadingIndicator.Small`, `Md3MorphLoadingIndicator.Medium`, `Md3MorphLoadingIndicator.Large`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `variant` | `int` | `Md3MorphLoadingIndicator.Bare` | read/write | `Md3MorphLoadingIndicator` | — |
| `sizePreset` | `int` | `Md3MorphLoadingIndicator.Medium` | read/write | `Md3MorphLoadingIndicator` | — |
| `indeterminate` | `bool` | `true` | read/write | `Md3MorphLoadingIndicator` | — |
| `indicatorColor` | `color` | `Md3Theme.colorScheme.primary` | read/write | `Md3MorphLoadingIndicator` | — |
| `containerColor` | `color` | `Md3Theme.colorScheme.primaryContainer` | read/write | `Md3MorphLoadingIndicator` | — |
| `morphPhase` | `real` | `0` | read/write | `Md3MorphLoadingIndicator` | — |
| `spin` | `real` | `0` | read/write | `Md3MorphLoadingIndicator` | — |
| `hostWindow` | `var` | `null` | read/write | `Md3MorphLoadingIndicator` | Optional Window for scene-active checks (else OverlayHost). |
| `box` | `real` | `{…}` | readonly | `Md3MorphLoadingIndicator` | — |
| `sceneActive` | `bool` | `enabled && _treeShown && indeterminate` | readonly | `Md3MorphLoadingIndicator` | — |

## Signals

_None._

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `rebuildPath()` | `Md3MorphLoadingIndicator` | Flower / clover path: r(θ) = R*(a + b*cos(8θ)) with morphing a/b. |

## Example

```qml
import Md3

Md3MorphLoadingIndicator {
    variant: Md3MorphLoadingIndicator.Bare
    sizePreset: Md3MorphLoadingIndicator.Medium
    indeterminate: true
    indicatorColor: Md3Theme.colorScheme.primary
    containerColor: Md3Theme.colorScheme.primaryContainer
}
```
