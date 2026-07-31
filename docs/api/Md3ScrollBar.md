# Md3ScrollBar

Themed scrollbar attached to a Flickable (vertical or horizontal). Optional `annotations` enable WinUI AnnotatedScrollBar-style letter/tick labels.

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
| `annotations` | `var` | `[]` | read/write | `Md3ScrollBar` | Equal-spaced labels (e.g. A–Z) or [{ position: 0..1, label }]. Vertical only. |
| `showAnnotations` | `bool` | `annotations && annotations.length > 0` | read/write | `Md3ScrollBar` | — |
| `annotationGutter` | `real` | `showAnnotations && vertical ? 18 : 0` | read/write | `Md3ScrollBar` | — |
| `vertical` | `bool` | `orientation === Qt.Vertical` | readonly | `Md3ScrollBar` | — |
| `needed` | `bool` | `flickable && _content > _view + 1` | readonly | `Md3ScrollBar` | — |
| `thumbRatio` | `real` | `needed ? Math.min(1, _view / Math.max(1, _content)) : 1` | readonly | `Md3ScrollBar` | — |
| `thumbSize` | `real` | `needed ? Math.max(minThumb, (_view - 4) * thumbRatio) : 0` | readonly | `Md3ScrollBar` | — |
| `travel` | `real` | `Math.max(0, _view - 4 - thumbSize)` | readonly | `Md3ScrollBar` | — |
| `thumbPos` | `real` | `{…}` | readonly | `Md3ScrollBar` | — |
| `activeAnnotation` | `string` | `{…}` | readonly | `Md3ScrollBar` | — |

## Signals

_None._

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `scrollToAnnotation(index)` | `Md3ScrollBar` | — |

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

## AnnotatedScrollBar

设置 `annotations`（字符串均分，或 `{ position, label }`）启用字母索引 gutter 与拖动提示气泡。

```qml
Md3ScrollBar {
    flickable: list
    annotations: ["A", "F", "L", "R", "Z"]
}
```
