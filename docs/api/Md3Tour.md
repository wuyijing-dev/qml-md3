# Md3Tour

- **Source:** `src/Md3/components/Md3Tour.qml`

Guided spotlight overlay.

## Properties

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `active` | `bool` | `false` | Overlay visible |
| `currentIndex` | `int` | `0` | Step index |
| `steps` | `var` | `[]` | `{ target, title, body, placement }` |
| `persistCompleted` | `bool` | `true` | Write `completedKey` on finish |
| `completedKey` | `string` | `tour/completed` | Md3AppSettings key |

## Methods

`start(at?)`, `stop(completed)`, `next()`, `previous()`

## Signals

`finished()`, `skipped()`, `stepChanged(int)`
