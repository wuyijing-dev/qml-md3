# Md3StatusBar

Desktop status bar — left / center / right zones, transient messages.

- **Source:** `src/Md3/components/Md3StatusBar.qml`
- **Extends:** `Rectangle`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 10 | 1 | 2 | 0 |

_Also inherits Qt Quick `Rectangle` members (not listed)._

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `text` | `string` | `""` | read/write | `Md3StatusBar` | Primary label text. |
| `centerText` | `string` | `""` | read/write | `Md3StatusBar` | Center Text. |
| `leadingIcon` | `string` | `""` | read/write | `Md3StatusBar` | Leading Icon. |
| `progress` | `real` | `-1` | read/write | `Md3StatusBar` | Progress. |
| `indeterminateProgress` | `bool` | `false` | read/write | `Md3StatusBar` | Indeterminate Progress. |
| `showProgress` | `bool` | `progress >= 0 \|\| indeterminateProgress` | read/write | `Md3StatusBar` | Show Progress. |
| `leftContent` | `alias` | `leftExtra.data` | default read/write | `Md3StatusBar` | Left Content. |
| `centerContent` | `alias` | `centerRow.data` | read/write | `Md3StatusBar` | Center Content. |
| `rightContent` | `alias` | `trailExtras.data` | read/write | `Md3StatusBar` | Right Content. |
| `displayText` | `string` | `_showTransient && _transientText.length` | readonly | `Md3StatusBar` | Display Text. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `messageClicked()` | `Md3StatusBar` | Emitted when message Clicked. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `showMessage(message, timeout)` | `—` | `Md3StatusBar` | Show Message. |
| `clearMessage()` | `—` | `Md3StatusBar` | Clear Message. |

## Example

```qml
import Md3

Md3StatusBar {
    text: ""
    centerText: ""
    leadingIcon: ""
    progress: -1
    indeterminateProgress: false
    showProgress: progress >= 0 || indeterminateProgress
}
```
