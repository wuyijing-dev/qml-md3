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

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `swipeRevealActive` | `var` | `null` | read/write | `Md3OverlayHost` | Exclusive open SwipeReveal (one open panel at a time). |

## Signals

_None._

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `resolveWindow(win, anchor)` | `Md3OverlayHost` | — |
| `contentItem(win, anchor)` | `Md3OverlayHost` | Top-level contentItem for popup reparenting. |
| `mapToOverlay(fromItem, x, y, win)` | `Md3OverlayHost` | Map local point on `fromItem` into overlay content coordinates. |
| `ensureHostParent(host, win, anchor, zOrder)` | `Md3OverlayHost` | Reparent `host` to fill the overlay contentItem (menus / pickers). |
| `claimSwipeReveal(item)` | `Md3OverlayHost` | — |
| `releaseSwipeReveal(item)` | `Md3OverlayHost` | — |

## Example

```qml
import Md3

// Singleton — use as `Md3OverlayHost.…`
console.log(Md3OverlayHost)
```
