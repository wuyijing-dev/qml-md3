# Md3TreeVisibility

Shared ancestor / window visibility checks (PageHost hides pages via opacity). Prefer this over duplicating `while (parent)` walks in components.

- **Source:** `src/Md3/foundation/Md3TreeVisibility.qml`
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
| `isItemShown(item)` | `Md3TreeVisibility` | Walk `item` and ancestors: all must be visible with opacity > 0.01. |
| `isWindowActive(win)` | `Md3TreeVisibility` | Window is mapped and not minimized/hidden. Missing window → inactive. |
| `isSceneActive(item, win)` | `Md3TreeVisibility` | Tree shown and window active. Pass explicit `win` / `hostWindow`, or `null`/`undefined` to resolve via Md3OverlayHost. |
| `isLiveMotionScene(item, win)` | `Md3TreeVisibility` | Scene active and application not suspended/hidden (for live timers / FrameAnimation). |
| `findPageRoot(item)` | `Md3TreeVisibility` | Nearest ancestor that declares boolean `md3PageActive` (PageHost injectable). |
| `isPageActive(item)` | `Md3TreeVisibility` | True when no page root, or `md3PageActive` is true. |

## Example

```qml
import Md3

// Singleton — use as `Md3TreeVisibility.…`
console.log(Md3TreeVisibility)
```
