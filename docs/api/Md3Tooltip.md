# Md3Tooltip

- **Source:** `src/Md3/components/Md3Tooltip.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `text` | `string` | `""` | read/write | `Md3Tooltip` | — |
| `open` | `bool` | `false` | read/write | `Md3Tooltip` | — |
| `showDelay` | `int` | `500` | read/write | `Md3Tooltip` | — |
| `content` | `alias` | `host.data` | default read/write | `Md3Tooltip` | Default property → `host.data` |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3Tooltip {
    text: ""
    open: false
    showDelay: 500
}
```
