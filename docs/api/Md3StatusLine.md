# Md3StatusLine

Compact persistent status line (index health, cache, non-alert state).

- **Source:** `src/Md3/components/Md3StatusLine.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 4 | 1 | 0 | 0 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `icon` | `string` | `""` | read/write | `Md3StatusLine` | Material icon name or empty. |
| `text` | `string` | `""` | read/write | `Md3StatusLine` | Primary label text. |
| `secondaryText` | `string` | `""` | read/write | `Md3StatusLine` | Secondary Text. |
| `actionText` | `string` | `""` | read/write | `Md3StatusLine` | Action Text. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `actionClicked()` | `Md3StatusLine` | Emitted when action Clicked. |

## Methods

_None._

## Example

```qml
import Md3

Md3StatusLine {
    icon: ""
    text: ""
    secondaryText: ""
    actionText: ""
}
```
