# Md3SearchView

- **Source:** `src/Md3/components/Md3SearchView.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 3 | 2 | 0 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `open` | `bool` | `false` | read/write | `Md3SearchView` | Open the overlay / dialog. |
| `text` | `string` | `""` | read/write | `Md3SearchView` | Primary label text. |
| `suggestions` | `var` | `[]` | read/write | `Md3SearchView` | Suggestions. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `suggestionChosen(string value)` | `Md3SearchView` | Emitted when suggestion Chosen. |
| `closed()` | `Md3SearchView` | Emitted when closed. |

## Methods

_None._

## Example

```qml
import Md3

Md3SearchView {
    open: false
    text: ""
    suggestions: []
}
```
