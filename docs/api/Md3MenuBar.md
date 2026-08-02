# Md3MenuBar

- **Source:** `src/Md3/components/Md3MenuBar.qml`
- **Extends:** `Rectangle`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 3 | 1 | 0 | 0 |

_Also inherits Qt Quick `Rectangle` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `model` | `var` | `[]` | read/write | `Md3MenuBar` | [{ text, icon?, items?: [...] }] — use `items` (not `children`; that clashes with Item) |
| `overlayWindow` | `var` | `null` | read/write | `Md3MenuBar` | Optional explicit Window for menu overlay (else Window.window). |
| `highlightedIndex` | `int` | `0` | read/write | `Md3MenuBar` | Keyboard highlight among top-level menus. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `itemClicked(string path)` | `Md3MenuBar` | Emitted when item Clicked. |

## Methods

_None._

## Example

```qml
import Md3

Md3MenuBar {
    model: []
    overlayWindow: null
    highlightedIndex: 0
}
```
