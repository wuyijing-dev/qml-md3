# Md3ContainerBody

Fit / Scroll content host embedded by Md3 container components.

- **Source:** `src/Md3/components/Md3ContainerBody.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 9 | 0 | 0 | 1 |

_Also inherits Qt Quick `Item` members (not listed)._

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
| `layoutMode` | `int (Md3ContainerBody.LayoutMode)` | `Md3ContainerBody.Fit` | read/write | `Md3ContainerBody` | Layout Mode. |
| `padding` | `real` | `0` | read/write | `Md3ContainerBody` | Uniform padding. |
| `clipContent` | `bool` | `true` | read/write | `Md3ContainerBody` | Clip Content. |
| `fitFallbackHeight` | `real` | `320` | read/write | `Md3ContainerBody` | Fit Fallback Height. |
| `content` | `alias` | `contentHost.data` | default read/write | `Md3ContainerBody` | Content. |
| `contentHost` | `alias` | `contentHost` | read/write | `Md3ContainerBody` | Content Host. |
| `contentImplicitWidth` | `real` | `contentHost.childrenRect.width` | readonly | `Md3ContainerBody` | Content Implicit Width. |
| `hasParentFillChild` | `bool` | `_hasParentFillChild()` | readonly | `Md3ContainerBody` | Has Parent Fill Child. |
| `contentImplicitHeight` | `real` | `hasParentFillChild ? 0 : _measuredContentH` | readonly | `Md3ContainerBody` | Content Implicit Height. |

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
