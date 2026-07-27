# Md3MorphLoadingIndicator

Material 3 Expressive morph loading — rounded 8-lobe clover / asterisk that spins and morphs.

- **Source:** `src/Md3/components/Md3MorphLoadingIndicator.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Enums

### `Variant`

`Bare`, `Contained` — contained draws the morph shape inside a circular primary-container disc.

### `Size`

`Small` (28), `Medium` (40), `Large` (56)

## Properties

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `variant` | `enum` | `Bare` | Bare flower or contained-in-circle. |
| `sizePreset` | `enum` | `Medium` | Overall size. |
| `indeterminate` | `bool` | `true` | Animation runs while true. |
| `indicatorColor` | `color` | `primary` | Fill of the morph shape. |
| `containerColor` | `color` | `primaryContainer` | Contained disc fill. |

## Example

```qml
Md3MorphLoadingIndicator { }

Md3MorphLoadingIndicator {
    variant: Md3MorphLoadingIndicator.Contained
    sizePreset: Md3MorphLoadingIndicator.Large
}
```
