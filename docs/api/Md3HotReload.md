# Md3HotReload

- **Source:** `src/Md3/diagnostics/md3hotreload.h`
- **Type:** `QML_ELEMENT` (instantiate; also used by `Md3ApplicationWindow.hotReload`)

## Properties

| Name | Type | Description |
|------|------|-------------|
| `enabled` | `bool` | Watch filesystem |
| `watchPaths` | `list` | Dirs/files to watch |
| `galleryPagesDir` | `string` | Auto-discovered gallery pages path |
| `md3QmlDir` | `string` | Auto-discovered Md3 QML tree |

## Methods

`addWatchPath(path)`, `clearComponentCache(engineOwner)`, `rediscoverSourceTrees()`

## Signals

`reloadRequested(path)` — ApplicationWindow clears cache and calls `pageHost.reloadCurrent()`.

Enable via `Md3ApplicationWindow.hotReload: true` or CLI `--hot-reload`.
