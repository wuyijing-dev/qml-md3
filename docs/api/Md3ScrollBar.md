# Md3ScrollBar

Themed scrollbar attached to a Flickable (vertical or horizontal).

- **Source:** `src/Md3/components/Md3ScrollBar.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `flickable` | `Flickable` | `null` | read/write | `Md3ScrollBar` | — |
| `orientation` | `int` | `Qt.Vertical` | read/write | `Md3ScrollBar` | — |
| `thickness` | `real` | `10` | read/write | `Md3ScrollBar` | — |
| `minThumb` | `real` | `28` | read/write | `Md3ScrollBar` | — |
| `autoHide` | `bool` | `true` | read/write | `Md3ScrollBar` | — |
| `fadeDelayMs` | `int` | `900` | read/write | `Md3ScrollBar` | — |
| `vertical` | `bool` | `orientation === Qt.Vertical` | readonly | `Md3ScrollBar` | — |
| `needed` | `bool` | `flickable && _content > _view + 1` | readonly | `Md3ScrollBar` | — |
| `thumbRatio` | `real` | `needed ? Math.min(1, _view / Math.max(1, _content)) : 1` | readonly | `Md3ScrollBar` | — |
| `thumbSize` | `real` | `needed ? Math.max(minThumb, (_view - 4) * thumbRatio) : 0` | readonly | `Md3ScrollBar` | — |
| `travel` | `real` | `Math.max(0, _view - 4 - thumbSize)` | readonly | `Md3ScrollBar` | — |
| `thumbPos` | `real` | `{…}` | readonly | `Md3ScrollBar` | — |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3ScrollBar {
    flickable: null
    orientation: Qt.Vertical
    thickness: 10
    minThumb: 28
    autoHide: true
}
```
