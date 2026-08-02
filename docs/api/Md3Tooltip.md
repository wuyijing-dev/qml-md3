# Md3Tooltip

Plain or rich tooltip: hover, keyboard focus, and long-press; flips to stay on-screen.

- **Source:** `src/Md3/components/Md3Tooltip.qml`
- **Extends:** `Item`

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
| `text` | `string` | `""` | read/write | `Md3Tooltip` | — |
| `open` | `bool` | `false` | read/write | `Md3Tooltip` | — |
| `showDelay` | `int` | `500` | read/write | `Md3Tooltip` | — |
| `focusShowDelay` | `int` | `700` | read/write | `Md3Tooltip` | Separate delay when the host gains keyboard focus (defaults slightly longer than hover). |
| `longPressMs` | `int` | `550` | read/write | `Md3Tooltip` | — |
| `showOnFocus` | `bool` | `true` | read/write | `Md3Tooltip` | — |
| `placement` | `int` | `Md3Tooltip.Top` | read/write | `Md3Tooltip` | — |
| `effectivePlacement` | `int` | `placement` | read/write | `Md3Tooltip` | Applied placement after edge avoidance (read-only for hosts). |
| `content` | `alias` | `host.data` | default read/write | `Md3Tooltip` | Default property → `host.data` |

## Signals

_None._

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `showNow()` | `Md3Tooltip` | — |
| `hideNow()` | `Md3Tooltip` | — |

## Example

```qml
import Md3

Md3Tooltip {
    text: ""
    open: false
    showDelay: 500
    focusShowDelay: 700
    longPressMs: 550
}
```
