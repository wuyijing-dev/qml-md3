# Md3HeightSync

Keep item height/width aligned with implicit size.

- **Source:** `src/Md3/layout/md3heightsync.h`
- **Extends:** `QObject`
- **Kind:** C++ / QML_ELEMENT (generated from header)

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 6 | 0 | 1 | 1 |

## Import

```qml
import Md3
```

## Enums

### `Md3HeightSync.Policy`

`Md3HeightSync.implicitHeight) — fixes collapse without fighting parents.
        AtLeastImplicit`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `READ` | `QQuickItem *target` | `—` | read/write | `Md3HeightSync` | Notify: `targetChanged` |
| `enabled` | `bool` | `—` | read/write | `Md3HeightSync` | Notify: `enabledChanged` |
| `syncHeight` | `bool` | `—` | read/write | `Md3HeightSync` | Notify: `syncHeightChanged` |
| `syncWidth` | `bool` | `—` | read/write | `Md3HeightSync` | Notify: `syncWidthChanged` |
| `policy` | `int` | `—` | read/write | `Md3HeightSync` | Notify: `policyChanged` |
| `epsilon` | `real` | `—` | read/write | `Md3HeightSync` | Notify: `epsilonChanged` |

## Signals

_None._

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `syncNow()` | `void` | `Md3HeightSync` | Sync Now. |

## Example

```qml
import Md3

// C++ / host type — typically used from QML as `Md3HeightSync { }`
Md3HeightSync {
    // see properties / methods above
}
```
