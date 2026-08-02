# Md3PageActivityGate

Tracks ancestor `md3PageActive` (injected by Md3PageHost) for unload-on-leave. Keep chrome/shell; clear models or Loader.active when `contentActive` is false.

- **Source:** `src/Md3/foundation/Md3PageActivityGate.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 4 | 0 | 1 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `watchItem` | `Item` | `parent` | read/write | `Md3PageActivityGate` | Watch Item. |
| `unloadWhenPageInactive` | `bool` | `true` | read/write | `Md3PageActivityGate` | Unload When Page Inactive. |
| `pageActive` | `bool` | `true` | read/write | `Md3PageActivityGate` | Page Active. |
| `contentActive` | `bool` | `!unloadWhenPageInactive \|\| pageActive` | readonly | `Md3PageActivityGate` | Content Active. |

## Signals

_None._

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `resolve()` | `—` | `Md3PageActivityGate` | Resolve. |

## Example

```qml
import Md3

Md3PageActivityGate {
    watchItem: parent
    unloadWhenPageInactive: true
    pageActive: true
}
```
