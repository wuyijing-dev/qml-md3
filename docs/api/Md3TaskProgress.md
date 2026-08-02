# Md3TaskProgress

Long-running / cancellable activity strip (scan, index, delete…).

- **Source:** `src/Md3/components/Md3TaskProgress.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 7 | 1 | 0 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `label` | `string` | `""` | read/write | `Md3TaskProgress` | Field / control label. |
| `secondaryLabel` | `string` | `""` | read/write | `Md3TaskProgress` | Secondary Label. |
| `indeterminate` | `bool` | `true` | read/write | `Md3TaskProgress` | Indeterminate. |
| `value` | `real` | `0` | read/write | `Md3TaskProgress` | 0…1 when determinate |
| `cancelable` | `bool` | `false` | read/write | `Md3TaskProgress` | Cancelable. |
| `cancelText` | `string` | `qsTr("Cancel")` | read/write | `Md3TaskProgress` | Cancel Text. |
| `active` | `bool` | `true` | read/write | `Md3TaskProgress` | Active. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `canceled()` | `Md3TaskProgress` | Emitted when canceled. |

## Methods

_None._

## Example

```qml
import Md3

Md3TaskProgress {
    label: ""
    secondaryLabel: ""
    indeterminate: true
    value: 0
    cancelable: false
    cancelText: qsTr("Cancel")
}
```
