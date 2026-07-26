# Md3Snackbar

- **Source:** `src/Md3/components/Md3Snackbar.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `text` | `string` | `""` | read/write | `Md3Snackbar` | — |
| `actionText` | `string` | `""` | read/write | `Md3Snackbar` | — |
| `dualLine` | `bool` | `false` | read/write | `Md3Snackbar` | — |
| `open` | `bool` | `false` | read/write | `Md3Snackbar` | — |
| `durationMs` | `int` | `4000` | read/write | `Md3Snackbar` | — |
| `slideY` | `real` | `open ? 0 : height + 8` | read/write | `Md3Snackbar` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `actionClicked()` | `Md3Snackbar` | — |
| `closed()` | `Md3Snackbar` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `show(message)` | `Md3Snackbar` | — |
| `dismiss()` | `Md3Snackbar` | — |

## Example

```qml
import Md3

Md3Snackbar {
    text: ""
    actionText: ""
    dualLine: false
    open: false
    durationMs: 4000
}
```
