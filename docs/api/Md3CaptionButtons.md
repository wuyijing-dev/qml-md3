# Md3CaptionButtons

- **Source:** `src/Md3/window/Md3CaptionButtons.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 10 | 0 | 3 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `targetWindow` | `var` | `null` | read/write | `Md3CaptionButtons` | Target Window. |
| `windowHelper` | `var` | `null` | read/write | `Md3CaptionButtons` | Window Helper. |
| `showMinimize` | `bool` | `true` | read/write | `Md3CaptionButtons` | Show Minimize. |
| `showMaximize` | `bool` | `true` | read/write | `Md3CaptionButtons` | Show Maximize. |
| `showClose` | `bool` | `true` | read/write | `Md3CaptionButtons` | Show Close. |
| `buttonWidth` | `real` | `40` | read/write | `Md3CaptionButtons` | Button Width. |
| `cornerRadius` | `real` | `0` | read/write | `Md3CaptionButtons` | Corner radius. |
| `maximized` | `bool` | `{…}` | readonly | `Md3CaptionButtons` | Maximized. |
| `maximizeButton` | `alias` | `maxBtn` | read/write | `Md3CaptionButtons` | Maximize Button. |
| `snapLayoutsEnabled` | `bool` | `Md3WindowCapabilities.snapLayouts` | readonly | `Md3CaptionButtons` | Snap Layouts Enabled. |

## Signals

_None._

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `reportCaptionButtonsHitTest()` | `—` | `Md3CaptionButtons` | Report Caption Buttons Hit Test. |
| `reportSnapMaximizeRect()` | `—` | `Md3CaptionButtons` | Report Snap Maximize Rect. |
| `armSnapLayouts(armed)` | `—` | `Md3CaptionButtons` | Arm Snap Layouts. |

## Example

```qml
import Md3

Md3CaptionButtons {
    targetWindow: null
    windowHelper: null
    showMinimize: true
    showMaximize: true
    showClose: true
    buttonWidth: 40
}
```
