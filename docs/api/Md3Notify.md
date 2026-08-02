# Md3Notify

App-wide notify helpers. Hosts register from Md3ApplicationWindow automatically.

- **Source:** `src/Md3/foundation/Md3Notify.qml`
- **Extends:** `QtObject`
- **Singleton:** `true` (`pragma Singleton`)

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 2 | 0 | 8 | 0 |

_Also inherits Qt Quick `QtObject` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `host` | `var` | `null` | read/write | `Md3Notify` | Host. |
| `toastHost` | `var` | `null` | read/write | `Md3Notify` | Toast Host. |

## Signals

_None._

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `registerHost(h)` | `—` | `Md3Notify` | Register Host. |
| `unregisterHost(h)` | `—` | `Md3Notify` | Unregister Host. |
| `registerToastHost(h)` | `—` | `Md3Notify` | Register Toast Host. |
| `unregisterToastHost(h)` | `—` | `Md3Notify` | Unregister Toast Host. |
| `snackbar(message, options)` | `—` | `Md3Notify` | Bottom snackbar queue. options: { actionText, dualLine, durationMs, id, priority } |
| `toast(message, options)` | `—` | `Md3Notify` | Toast. options: { severity, durationMs, position, id } position: Md3ToastHost.TopCenter\|TopRight\|TopLeft\|BottomRight\|BottomLeft or string "topCenter" / "topRight" / "topLeft" / "bottomRight" / "bottomLeft" severity: Md3Toast.Default \| Success \| Warning \| Error (or 0–3) |
| `copy(text, options)` | `—` | `Md3Notify` | Copy text then toast. options: { feedback?, severity?, durationMs?, id? } feedback defaults to qsTr("Copied"). Set feedback: "" to skip toast. |
| `dismissAll()` | `—` | `Md3Notify` | Dismiss All. |

## Example

```qml
import Md3

// Singleton — use as `Md3Notify.…`
console.log(Md3Notify)
```
