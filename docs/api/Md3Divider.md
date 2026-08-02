# Md3Divider

- **Source:** `src/Md3/components/Md3Divider.qml`
- **Extends:** `Rectangle`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 4 | 0 | 0 | 2 |

_Also inherits Qt Quick `Rectangle` members (not listed)._

## Import

```qml
import Md3
```

## Enums

### `Md3Divider.Variant`

`Md3Divider.Full`, `Md3Divider.Inset`, `Md3Divider.Middle`

### `Md3Divider.Orientation`

`Md3Divider.Horizontal`, `Md3Divider.Vertical`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `variant` | `int (Md3Divider.Variant)` | `Md3Divider.Full` | read/write | `Md3Divider` | Visual / role variant (see Enums). |
| `orientation` | `int (Md3Divider.Orientation)` | `Md3Divider.Horizontal` | read/write | `Md3Divider` | Layout orientation. |
| `vertical` | `bool` | `false` | read/write | `Md3Divider` | Toolbar convenience; when true, draws a vertical rule. |
| `inset` | `real` | `16` | read/write | `Md3Divider` | Inset. |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3Divider {
    variant: Md3Divider.Full
    orientation: Md3Divider.Horizontal
    vertical: false
    inset: 16
}
```
