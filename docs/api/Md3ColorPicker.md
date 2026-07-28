# Md3ColorPicker

Compact HSL color picker for theme seed / design tools.

- **Source:** `src/Md3/components/Md3ColorPicker.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `color` | `color` | `Md3Theme.seed` | read/write | `Md3ColorPicker` | — |
| `showHex` | `bool` | `true` | read/write | `Md3ColorPicker` | — |
| `showApplySeed` | `bool` | `false` | read/write | `Md3ColorPicker` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `colorEdited(color c)` | `Md3ColorPicker` | — |
| `applySeedRequested(color c)` | `Md3ColorPicker` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `setFromColor(c)` | `Md3ColorPicker` | — |

## Example

```qml
import Md3

Md3ColorPicker {
    color: Md3Theme.seed
    showHex: true
    showApplySeed: false
}
```
