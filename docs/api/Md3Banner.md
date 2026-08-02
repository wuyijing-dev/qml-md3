# Md3Banner

- **Source:** `src/Md3/components/Md3Banner.qml`
- **Extends:** `Rectangle`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 6 | 3 | 0 | 0 |

_Also inherits Qt Quick `Rectangle` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `text` | `string` | `""` | read/write | `Md3Banner` | Primary label text. |
| `leadingIcon` | `string` | `"info"` | read/write | `Md3Banner` | Leading Icon. |
| `primaryAction` | `string` | `""` | read/write | `Md3Banner` | Primary Action. |
| `secondaryAction` | `string` | `""` | read/write | `Md3Banner` | Secondary Action. |
| `showClose` | `bool` | `true` | read/write | `Md3Banner` | Show Close. |
| `open` | `bool` | `true` | read/write | `Md3Banner` | Open the overlay / dialog. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `primaryClicked()` | `Md3Banner` | Emitted when primary Clicked. |
| `secondaryClicked()` | `Md3Banner` | Emitted when secondary Clicked. |
| `closed()` | `Md3Banner` | Emitted when closed. |

## Methods

_None._

## Example

```qml
import Md3

Md3Banner {
    text: ""
    leadingIcon: "info"
    primaryAction: ""
    secondaryAction: ""
    showClose: true
    open: true
}
```
