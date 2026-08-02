# Md3CommandPalette

Spotlight-style command palette (Ctrl+K). model: [{ title, subtitle?, icon?, id? }]

- **Source:** `src/Md3/components/Md3CommandPalette.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 7 | 2 | 3 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `open` | `bool` | `false` | read/write | `Md3CommandPalette` | Open the overlay / dialog. |
| `placeholder` | `string` | `qsTr("Type a command…")` | read/write | `Md3CommandPalette` | Placeholder. |
| `model` | `var` | `[]` | read/write | `Md3CommandPalette` | Data model. |
| `maxResults` | `int` | `12` | read/write | `Md3CommandPalette` | Max Results. |
| `query` | `string` | `""` | read/write | `Md3CommandPalette` | Query. |
| `highlightIndex` | `int` | `0` | read/write | `Md3CommandPalette` | Highlight Index. |
| `filtered` | `var` | `{…}` | readonly | `Md3CommandPalette` | Filtered. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `activated(var item)` | `Md3CommandPalette` | Emitted when activated. |
| `closed()` | `Md3CommandPalette` | Emitted when closed. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `dismiss()` | `—` | `Md3CommandPalette` | Dismiss. |
| `activateIndex(i)` | `—` | `Md3CommandPalette` | Activate Index. |
| `moveHighlight(delta)` | `—` | `Md3CommandPalette` | Move Highlight. |

## Example

```qml
import Md3

Md3CommandPalette {
    open: false
    placeholder: qsTr("Type a command…")
    model: []
    maxResults: 12
    query: ""
    highlightIndex: 0
}
```
