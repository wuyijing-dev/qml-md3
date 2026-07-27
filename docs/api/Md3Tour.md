# Md3Tour

- **Source:** `src/Md3/components/Md3Tour.qml`

Guided spotlight overlay with **rounded-rect cutout** (MultiEffect inverted mask) and **animated** hole / card transitions.

## Properties

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `active` | `bool` | `false` | Overlay visible |
| `currentIndex` | `int` | `0` | Step index |
| `steps` | `var` | `[]` | `{ target, title, body, placement, radius? }` |
| `holePad` | `real` | `10` | Padding around target |
| `transitionDuration` | `int` | `Md3Motion.medium2` | Hole / card move |
| `persistCompleted` | `bool` | `true` | Write settings on finish |
| `completedKey` | `string` | `tour/completed` | Settings key |

## Methods

`start(at?)`, `stop(completed)`, `next()`, `previous()`

## Signals

`finished()`, `skipped()`, `stepChanged(int)`
