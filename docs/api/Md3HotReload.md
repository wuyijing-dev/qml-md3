# Md3HotReload

QML hot-reload watcher.

- **Source:** `src/Md3/diagnostics/md3hotreload.h`
- **Extends:** `QObject`
- **Kind:** C++ / QML_ELEMENT (generated from header)

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 4 | 0 | 3 | 0 |

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `enabled` | `bool` | `—` | read/write | `Md3HotReload` | Notify: `enabledChanged` |
| `watchPaths` | `var` | `—` | read/write | `Md3HotReload` | Notify: `watchPathsChanged` |
| `galleryPagesDir` | `string` | `—` | readonly | `Md3HotReload` | Notify: `galleryPagesDirChanged` |
| `md3QmlDir` | `string` | `—` | readonly | `Md3HotReload` | Notify: `md3QmlDirChanged` |

## Signals

_None._

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `addWatchPath(const QString &path)` | `void` | `Md3HotReload` | Add Watch Path. |
| `clearComponentCache(QObject *engineOwner)` | `void` | `Md3HotReload` | Clear Component Cache. |
| `rediscoverSourceTrees()` | `void` | `Md3HotReload` | Rediscover Source Trees. |

## Example

```qml
import Md3

// C++ / host type — typically used from QML as `Md3HotReload { }`
Md3HotReload {
    // see properties / methods above
}
```
