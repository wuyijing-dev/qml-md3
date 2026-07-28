# Md3DeferredSection

Within-page progressive load: placeholder first, then create `sourceComponent`. Honors Md3Theme.progressiveContent (default on). Set forceImmediate to always load now.

- **Source:** `src/Md3/components/Md3DeferredSection.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `sourceComponent` | `Component` | `null` | read/write | `Md3DeferredSection` | — |
| `delayMs` | `int` | `0` | read/write | `Md3DeferredSection` | Delay before arming when progressiveContent is on (ms). 0 = next event-loop tick. |
| `preferredHeight` | `real` | `120` | read/write | `Md3DeferredSection` | Height reserved while empty / loading (also used as Layout.preferredHeight hint). |
| `asynchronous` | `bool` | `false` | read/write | `Md3DeferredSection` | Prefer sync create to avoid "destroyed during incubation" on fast page switches. |
| `forceImmediate` | `bool` | `false` | read/write | `Md3DeferredSection` | Ignore Md3Theme.progressiveContent and load immediately. |
| `progressive` | `bool` | `Md3Theme.progressiveContent && !forceImmediate` | readonly | `Md3DeferredSection` | — |
| `ready` | `bool` | `loader.status === Loader.Ready` | readonly | `Md3DeferredSection` | — |
| `item` | `Item` | `loader.item` | readonly | `Md3DeferredSection` | — |

## Signals

_None._

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `arm()` | `Md3DeferredSection` | — |

## Example

```qml
import Md3

Md3DeferredSection {
    sourceComponent: null
    delayMs: 0
    preferredHeight: 120
    asynchronous: false
    forceImmediate: false
}
```
