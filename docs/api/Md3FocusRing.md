# Md3FocusRing

- **Source:** `src/Md3/primitives/Md3FocusRing.qml`
- **Extends:** `Rectangle`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 3 | 0 | 0 | 0 |

_Also inherits Qt Quick `Rectangle` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `focused` | `bool` | `false` | read/write | `Md3FocusRing` | Focused. |
| `controlEnabled` | `bool` | `true` | read/write | `Md3FocusRing` | Control Enabled. |
| `visualFocus` | `bool` | `false` | read/write | `Md3FocusRing` | Visual Focus. |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3FocusRing {
    focused: false
    controlEnabled: true
    visualFocus: false
}
```
