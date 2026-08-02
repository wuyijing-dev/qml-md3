# Md3Notify

App-wide notify helpers. Hosts register from Md3ApplicationWindow automatically.

- **Source:** `src/Md3/foundation/Md3Notify.qml`
- **Extends:** `QtObject`
- **Singleton:** `true` (`pragma Singleton`)

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `host` | `var` | `null` | read/write | `Md3Notify` | — |
| `toastHost` | `var` | `null` | read/write | `Md3Notify` | — |

## Signals

_None._

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `registerHost(h)` | `Md3Notify` | — |
| `unregisterHost(h)` | `Md3Notify` | — |
| `registerToastHost(h)` | `Md3Notify` | — |
| `unregisterToastHost(h)` | `Md3Notify` | — |
| `snackbar(message, options)` | `Md3Notify` | Bottom snackbar queue. options: { actionText, dualLine, durationMs, id, priority } |
| `toast(message, options)` | `Md3Notify` | Toast. options: { severity, durationMs, position, id } position: Md3ToastHost.TopCenter\|TopRight\|TopLeft\|BottomRight\|BottomLeft or string "topCenter" / "topRight" / "topLeft" / "bottomRight" / "bottomLeft" severity: Md3Toast.Default \| Success \| Warning \| Error (or 0–3) |
| `copy(text, options)` | `Md3Notify` | Copy text then toast. options: { feedback?, severity?, durationMs?, id? } feedback defaults to qsTr("Copied"). Set feedback: "" to skip toast. |
| `dismissAll()` | `Md3Notify` | — |

## Example

```qml
import Md3

// Singleton — use as `Md3Notify.…`
console.log(Md3Notify)
```
