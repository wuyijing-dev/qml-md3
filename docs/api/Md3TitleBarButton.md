# Md3TitleBarButton

- **Source:** `src/Md3/window/Md3TitleBarButton.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 8 | 1 | 0 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `icon` | `string` | `"contrast"` | read/write | `Md3TitleBarButton` | Material icon name or empty. |
| `accessibleName` | `string` | `icon` | read/write | `Md3TitleBarButton` | Accessible name override. |
| `checked` | `bool` | `false` | read/write | `Md3TitleBarButton` | Checked / on state. |
| `destructive` | `bool` | `false` | read/write | `Md3TitleBarButton` | Destructive. |
| `enabled` | `bool` | `true` | read/write | `Md3TitleBarButton` | Whether the control accepts interaction. |
| `buttonWidth` | `real` | `40` | read/write | `Md3TitleBarButton` | Button Width. |
| `buttonHeight` | `real` | `28` | read/write | `Md3TitleBarButton` | Button Height. |
| `iconSize` | `real` | `14` | read/write | `Md3TitleBarButton` | Icon Size. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `clicked()` | `Md3TitleBarButton` | Emitted when clicked. |

## Methods

_None._

## Example

```qml
import Md3

Md3TitleBarButton {
    icon: "contrast"
    accessibleName: icon
    checked: false
    destructive: false
    buttonWidth: 40
    buttonHeight: 28
}
```
