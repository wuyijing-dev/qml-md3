# Md3BottomAppBar

- **Source:** `src/Md3/components/Md3BottomAppBar.qml`
- **Extends:** `Rectangle`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 2 | 2 | 0 | 0 |

_Also inherits Qt Quick `Rectangle` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `actions` | `var` | `[]` | read/write | `Md3BottomAppBar` | icon names |
| `showFab` | `bool` | `false` | read/write | `Md3BottomAppBar` | Show Fab. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `actionClicked(int index)` | `Md3BottomAppBar` | Emitted when action Clicked. |
| `fabClicked()` | `Md3BottomAppBar` | Emitted when fab Clicked. |

## Methods

_None._

## Example

```qml
import Md3

Md3BottomAppBar {
    actions: []
    showFab: false
}
```
