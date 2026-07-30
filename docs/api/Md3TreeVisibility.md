# Md3TreeVisibility

Singleton helpers for ancestor / window visibility (PageHost hides cached pages via opacity).

- **Source:** `src/Md3/foundation/Md3TreeVisibility.qml`
- **Type:** Singleton

## Import

```qml
import Md3
```

## API

| Function | Description |
|----------|-------------|
| `isItemShown(item)` | `item` and ancestors are visible with opacity > 0.01 |
| `isWindowActive(win)` | `win` not Hidden/Minimized (missing win → false) |
| `isSceneActive(item, win)` | Tree shown and window active — pass `Window.window` |
| `isLiveMotionScene(item, win)` | Scene active and app not suspended/hidden |

## Example

```qml
readonly property bool chartActive: enabled
        && Md3TreeVisibility.isLiveMotionScene(root, Window.window)
```

See [module-boundaries.md](../module-boundaries.md).
