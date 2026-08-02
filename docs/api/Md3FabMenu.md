# Md3FabMenu

- **Source:** `src/Md3/components/Md3FabMenu.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 7 | 2 | 1 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `model` | `var` | `[]` | read/write | `Md3FabMenu` | [{ icon, text?, colorRole?, enabled? }] — first item nearest primary |
| `open` | `bool` | `false` | read/write | `Md3FabMenu` | Open the overlay / dialog. |
| `colorRole` | `int` | `Md3Fab.Primary` | read/write | `Md3FabMenu` | Color Role. |
| `icon` | `string` | `"add"` | read/write | `Md3FabMenu` | Material icon name or empty. |
| `closeIcon` | `string` | `"close"` | read/write | `Md3FabMenu` | Close Icon. |
| `actionGap` | `real` | `4` | read/write | `Md3FabMenu` | Action Gap. |
| `stackedModel` | `var` | `{…}` | readonly | `Md3FabMenu` | Stacked Model. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `clicked()` | `Md3FabMenu` | Emitted when clicked. |
| `actionClicked(int index)` | `Md3FabMenu` | Emitted when action Clicked. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `toggle()` | `—` | `Md3FabMenu` | Toggle open / checked state. |

## Example

```qml
import Md3

Md3FabMenu {
    model: []
    open: false
    colorRole: Md3Fab.Primary
    icon: "add"
    closeIcon: "close"
    actionGap: 4
}
```
