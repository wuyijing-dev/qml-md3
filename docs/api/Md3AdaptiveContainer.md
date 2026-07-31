# Md3AdaptiveContainer

Standalone column-stacking adaptive container (gallery / direct use). Md3 container components embed `Md3ContainerBody` and expose `layoutMode` directly.

- **Source:** `src/Md3/components/Md3AdaptiveContainer.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Enums

### `Md3AdaptiveContainer.LayoutMode`

`Md3AdaptiveContainer.Fit`, `Md3AdaptiveContainer.Scroll`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `layoutMode` | `int` | `Md3AdaptiveContainer.Fit` | read/write | `Md3AdaptiveContainer` | — |
| `padding` | `real` | `0` | read/write | `Md3AdaptiveContainer` | — |
| `clipContent` | `bool` | `true` | read/write | `Md3AdaptiveContainer` | — |
| `contentSpacing` | `real` | `12` | read/write | `Md3AdaptiveContainer` | — |
| `content` | `alias` | `contentColumn.data` | default read/write | `Md3AdaptiveContainer` | Default property → `contentColumn.data` |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3AdaptiveContainer {
    layoutMode: Md3AdaptiveContainer.Fit
    padding: 0
    clipContent: true
    contentSpacing: 12
}
```
