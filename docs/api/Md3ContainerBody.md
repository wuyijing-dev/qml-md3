# Md3ContainerBody

Fit / Scroll content host embedded by Md3 container components.

- **Source:** `src/Md3/components/Md3ContainerBody.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Enums

### `Md3ContainerBody.LayoutMode`

`Md3ContainerBody.Fit`, `Md3ContainerBody.Scroll`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `layoutMode` | `int` | `Md3ContainerBody.Fit` | read/write | `Md3ContainerBody` | — |
| `padding` | `real` | `0` | read/write | `Md3ContainerBody` | — |
| `clipContent` | `bool` | `true` | read/write | `Md3ContainerBody` | — |
| `fitFallbackHeight` | `real` | `320` | read/write | `Md3ContainerBody` | — |
| `content` | `alias` | `contentHost.data` | default read/write | `Md3ContainerBody` | Default property → `contentHost.data` |
| `contentHost` | `alias` | `contentHost` | read/write | `Md3ContainerBody` | Alias → `contentHost` |
| `contentImplicitWidth` | `real` | `contentHost.childrenRect.width` | readonly | `Md3ContainerBody` | — |
| `hasParentFillChild` | `bool` | `_hasParentFillChild()` | readonly | `Md3ContainerBody` | — |
| `contentImplicitHeight` | `real` | `_measureContentHeight()` | readonly | `Md3ContainerBody` | — |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3ContainerBody {
    layoutMode: Md3ContainerBody.Fit
    padding: 0
    clipContent: true
    fitFallbackHeight: 320
}
```
