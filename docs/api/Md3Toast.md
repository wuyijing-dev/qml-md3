# Md3Toast

Short-lived toast chip. Prefer Md3ToastHost / Md3Notify.toast for stacking & position.

- **Source:** `src/Md3/components/Md3Toast.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Enums

### `Md3Toast.Severity`

`Md3Toast.Default`, `Md3Toast.Success`, `Md3Toast.Warning`, `Md3Toast.Error`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `text` | `string` | `""` | read/write | `Md3Toast` | — |
| `severity` | `int` | `Md3Toast.Default` | read/write | `Md3Toast` | — |
| `durationMs` | `int` | `2200` | read/write | `Md3Toast` | — |
| `open` | `bool` | `false` | read/write | `Md3Toast` | — |
| `maxWidth` | `real` | `420` | read/write | `Md3Toast` | — |
| `bg` | `color` | `{…}` | readonly | `Md3Toast` | — |
| `fg` | `color` | `{…}` | readonly | `Md3Toast` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `closed()` | `Md3Toast` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `show(message, options)` | `Md3Toast` | — |
| `dismiss()` | `Md3Toast` | — |

## Example

```qml
import Md3

Md3Toast {
    text: ""
    severity: Md3Toast.Default
    durationMs: 2200
    open: false
    maxWidth: 420
}
```
