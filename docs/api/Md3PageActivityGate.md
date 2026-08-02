# Md3PageActivityGate

Tracks ancestor `md3PageActive` (injected by Md3PageHost) for unload-on-leave. Keep chrome/shell; clear models or Loader.active when `contentActive` is false.

- **Source:** `src/Md3/foundation/Md3PageActivityGate.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `watchItem` | `Item` | `parent` | read/write | `Md3PageActivityGate` | — |
| `unloadWhenPageInactive` | `bool` | `true` | read/write | `Md3PageActivityGate` | — |
| `pageActive` | `bool` | `true` | read/write | `Md3PageActivityGate` | — |
| `contentActive` | `bool` | `!unloadWhenPageInactive \|\| pageActive` | readonly | `Md3PageActivityGate` | — |

## Signals

_None._

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `resolve()` | `Md3PageActivityGate` | — |

## Example

```qml
import Md3

Md3PageActivityGate {
    watchItem: parent
    unloadWhenPageInactive: true
    pageActive: true
}
```
