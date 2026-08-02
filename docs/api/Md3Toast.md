# Md3Toast

Short-lived toast chip. Prefer Md3ToastHost / Md3Notify.toast for stacking & position.

- **Source:** `src/Md3/components/Md3Toast.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 8 | 1 | 2 | 1 |

_Also inherits Qt Quick `Item` members (not listed)._

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
| `text` | `string` | `""` | read/write | `Md3Toast` | Primary label text. |
| `severity` | `int (Md3Toast.Severity)` | `Md3Toast.Default` | read/write | `Md3Toast` | Severity. |
| `durationMs` | `int` | `2200` | read/write | `Md3Toast` | Duration Ms. |
| `open` | `bool` | `false` | read/write | `Md3Toast` | Open the overlay / dialog. |
| `maxWidth` | `real` | `420` | read/write | `Md3Toast` | Max Width. |
| `pauseOnHover` | `bool` | `true` | read/write | `Md3Toast` | Pause On Hover. |
| `bg` | `color` | `{…}` | readonly | `Md3Toast` | Bg. |
| `fg` | `color` | `{…}` | readonly | `Md3Toast` | Fg. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `closed()` | `Md3Toast` | Emitted when closed. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `show(message, options)` | `—` | `Md3Toast` | Show. |
| `dismiss()` | `—` | `Md3Toast` | Dismiss. |

## Example

```qml
import Md3

Md3Toast {
    text: ""
    severity: Md3Toast.Default
    durationMs: 2200
    open: false
    maxWidth: 420
    pauseOnHover: true
}
```
