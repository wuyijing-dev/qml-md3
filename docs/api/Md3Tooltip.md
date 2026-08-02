# Md3Tooltip

Plain or rich tooltip: hover, keyboard focus, and long-press; flips to stay on-screen.

- **Source:** `src/Md3/components/Md3Tooltip.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 9 | 0 | 2 | 1 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Enums

### `Md3Tooltip.Placement`

`Md3Tooltip.Top`, `Md3Tooltip.Bottom`, `Md3Tooltip.Start`, `Md3Tooltip.End`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `text` | `string` | `""` | read/write | `Md3Tooltip` | Primary label text. |
| `open` | `bool` | `false` | read/write | `Md3Tooltip` | Open the overlay / dialog. |
| `showDelay` | `int` | `500` | read/write | `Md3Tooltip` | Show Delay. |
| `focusShowDelay` | `int` | `700` | read/write | `Md3Tooltip` | Separate delay when the host gains keyboard focus (defaults slightly longer than hover). |
| `longPressMs` | `int` | `550` | read/write | `Md3Tooltip` | Long Press Ms. |
| `showOnFocus` | `bool` | `true` | read/write | `Md3Tooltip` | Show On Focus. |
| `placement` | `int (Md3Tooltip.Placement)` | `Md3Tooltip.Top` | read/write | `Md3Tooltip` | Placement. |
| `effectivePlacement` | `int` | `placement` | read/write | `Md3Tooltip` | Applied placement after edge avoidance (read-only for hosts). |
| `content` | `alias` | `host.data` | default read/write | `Md3Tooltip` | Content. |

## Signals

_None._

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `showNow()` | `—` | `Md3Tooltip` | Show Now. |
| `hideNow()` | `—` | `Md3Tooltip` | Hide Now. |

## Example

```qml
import Md3

Md3Tooltip {
    text: ""
    open: false
    showDelay: 500
    focusShowDelay: 700
    longPressMs: 550
    showOnFocus: true
}
```
