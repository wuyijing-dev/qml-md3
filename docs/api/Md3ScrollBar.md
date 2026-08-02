# Md3ScrollBar

Themed scrollbar attached to a Flickable (vertical or horizontal). Optional `annotations` enable WinUI AnnotatedScrollBar-style letter/tick labels.

- **Source:** `src/Md3/components/Md3ScrollBar.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 16 | 0 | 1 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `flickable` | `Flickable` | `null` | read/write | `Md3ScrollBar` | Flickable. |
| `orientation` | `int` | `Qt.Vertical` | read/write | `Md3ScrollBar` | Layout orientation. |
| `thickness` | `real` | `10` | read/write | `Md3ScrollBar` | Thickness. |
| `minThumb` | `real` | `28` | read/write | `Md3ScrollBar` | Min Thumb. |
| `autoHide` | `bool` | `true` | read/write | `Md3ScrollBar` | Auto Hide. |
| `fadeDelayMs` | `int` | `900` | read/write | `Md3ScrollBar` | Fade Delay Ms. |
| `annotations` | `var` | `[]` | read/write | `Md3ScrollBar` | Equal-spaced labels (e.g. A–Z) or [{ position: 0..1, label }]. Vertical only. |
| `showAnnotations` | `bool` | `annotations && annotations.length > 0` | read/write | `Md3ScrollBar` | Show Annotations. |
| `annotationGutter` | `real` | `showAnnotations && vertical ? 18 : 0` | read/write | `Md3ScrollBar` | Annotation Gutter. |
| `vertical` | `bool` | `orientation === Qt.Vertical` | readonly | `Md3ScrollBar` | Vertical. |
| `needed` | `bool` | `false` | read/write | `Md3ScrollBar` | Writable + hysteresis avoids visible↔size binding loops with paired bars. |
| `thumbRatio` | `real` | `needed ? Math.min(1, _view / Math.max(1, _content)) : 1` | readonly | `Md3ScrollBar` | Thumb Ratio. |
| `thumbSize` | `real` | `needed ? Math.max(minThumb, (_view - 4) * thumbRatio) : 0` | readonly | `Md3ScrollBar` | Thumb Size. |
| `travel` | `real` | `Math.max(0, _view - 4 - thumbSize)` | readonly | `Md3ScrollBar` | Travel. |
| `thumbPos` | `real` | `{…}` | readonly | `Md3ScrollBar` | Thumb Pos. |
| `activeAnnotation` | `string` | `{…}` | readonly | `Md3ScrollBar` | Active Annotation. |

## Signals

_None._

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `scrollToAnnotation(index)` | `—` | `Md3ScrollBar` | Scroll To Annotation. |

## Example

```qml
import Md3

Md3ScrollBar {
    flickable: null
    orientation: Qt.Vertical
    thickness: 10
    minThumb: 28
    autoHide: true
    fadeDelayMs: 900
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
