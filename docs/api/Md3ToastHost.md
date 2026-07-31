# Md3ToastHost

Window-level toast host: stacked multi-toast with position + enter/exit animation.

- **Source:** `src/Md3/components/Md3ToastHost.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Enums

### `Md3ToastHost.Position`

`Md3ToastHost.TopCenter`, `Md3ToastHost.TopRight`, `Md3ToastHost.TopLeft`, `Md3ToastHost.BottomRight`, `Md3ToastHost.BottomLeft`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `position` | `int` | `Md3ToastHost.TopCenter` | read/write | `Md3ToastHost` | — |
| `maxVisible` | `int` | `4` | read/write | `Md3ToastHost` | — |
| `spacing` | `int` | `8` | read/write | `Md3ToastHost` | — |
| `defaultDurationMs` | `int` | `2200` | read/write | `Md3ToastHost` | — |
| `edgeMargin` | `real` | `16` | read/write | `Md3ToastHost` | — |
| `sideMargin` | `real` | `16` | read/write | `Md3ToastHost` | — |
| `dodgeBottom` | `real` | `0` | read/write | `Md3ToastHost` | — |
| `dodgeTop` | `real` | `0` | read/write | `Md3ToastHost` | — |

## Signals

_None._

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `show(message, options)` | `Md3ToastHost` | — |
| `dismissAll()` | `Md3ToastHost` | — |

## Example

```qml
import Md3

Md3ToastHost {
    position: Md3ToastHost.TopCenter
    maxVisible: 4
    spacing: 8
    defaultDurationMs: 2200
    edgeMargin: 16
}
```
