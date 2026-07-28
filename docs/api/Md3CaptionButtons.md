# Md3CaptionButtons

- **Source:** `src/Md3/window/Md3CaptionButtons.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `targetWindow` | `var` | `null` | read/write | `Md3CaptionButtons` | — |
| `windowHelper` | `var` | `null` | read/write | `Md3CaptionButtons` | — |
| `showMinimize` | `bool` | `true` | read/write | `Md3CaptionButtons` | — |
| `showMaximize` | `bool` | `true` | read/write | `Md3CaptionButtons` | — |
| `showClose` | `bool` | `true` | read/write | `Md3CaptionButtons` | — |
| `buttonWidth` | `real` | `40` | read/write | `Md3CaptionButtons` | — |
| `cornerRadius` | `real` | `0` | read/write | `Md3CaptionButtons` | — |
| `maximized` | `bool` | `{…}` | readonly | `Md3CaptionButtons` | — |
| `maximizeButton` | `alias` | `maxBtn` | read/write | `Md3CaptionButtons` | Alias → `maxBtn` |

## Signals

_None._

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `reportMaximizeHitTest()` | `Md3CaptionButtons` | — |

## Example

```qml
import Md3

Md3CaptionButtons {
    targetWindow: null
    windowHelper: null
    showMinimize: true
    showMaximize: true
    showClose: true
}
```
