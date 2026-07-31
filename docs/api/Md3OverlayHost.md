# Md3OverlayHost

Resolve overlay parents / popup coordinates without each control re-implementing Window.window. Prefer explicit `win` (`hostWindow` / `overlayWindow`); fall back to `Window.window` of `anchor`.

- **Source:** `src/Md3/foundation/Md3OverlayHost.qml`
- **Extends:** `QtObject`
- **Singleton:** `true` (`pragma Singleton`)

## Import

```qml
import Md3
```

## Properties

_None._

## Signals

_None._

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `resolveWindow(win, anchor)` | `Md3OverlayHost` | — |
| `contentItem(win, anchor)` | `Md3OverlayHost` | Top-level contentItem for popup reparenting. |
| `mapToOverlay(fromItem, x, y, win)` | `Md3OverlayHost` | Map local point on `fromItem` into overlay content coordinates. |
| `ensureHostParent(host, win, anchor, zOrder)` | `Md3OverlayHost` | Reparent `host` to fill the overlay contentItem (menus / pickers). |

## Example

```qml
import Md3

// Singleton — use as `Md3OverlayHost.…`
console.log(Md3OverlayHost)
```
