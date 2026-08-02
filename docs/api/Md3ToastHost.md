# Md3ToastHost

Window-level toast host: stacked multi-toast with position + enter/exit animation.

- **Source:** `src/Md3/components/Md3ToastHost.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 8 | 0 | 2 | 1 |

_Also inherits Qt Quick `Item` members (not listed)._

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
| `position` | `int (Md3ToastHost.Position)` | `Md3ToastHost.TopCenter` | read/write | `Md3ToastHost` | Position. |
| `maxVisible` | `int` | `4` | read/write | `Md3ToastHost` | Max Visible. |
| `spacing` | `int` | `8` | read/write | `Md3ToastHost` | Child spacing. |
| `defaultDurationMs` | `int` | `2200` | read/write | `Md3ToastHost` | Default Duration Ms. |
| `edgeMargin` | `real` | `16` | read/write | `Md3ToastHost` | Edge Margin. |
| `sideMargin` | `real` | `16` | read/write | `Md3ToastHost` | Side Margin. |
| `dodgeBottom` | `real` | `0` | read/write | `Md3ToastHost` | Dodge Bottom. |
| `dodgeTop` | `real` | `0` | read/write | `Md3ToastHost` | Dodge Top. |

## Signals

_None._

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `show(message, options)` | `—` | `Md3ToastHost` | Show. |
| `dismissAll()` | `—` | `Md3ToastHost` | Dismiss All. |

## Example

```qml
import Md3

Md3ToastHost {
    position: Md3ToastHost.TopCenter
    maxVisible: 4
    spacing: 8
    defaultDurationMs: 2200
    edgeMargin: 16
    sideMargin: 16
}
```
