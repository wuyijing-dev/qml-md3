# Md3InfoBar

WinUI-style in-page info bar — persistent until dismissed (unlike Snackbar).

- **Source:** `src/Md3/components/Md3InfoBar.qml`
- **Extends:** `Rectangle`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 9 | 2 | 0 | 1 |

_Also inherits Qt Quick `Rectangle` members (not listed)._

## Import

```qml
import Md3
```

## Enums

### `Md3InfoBar.Severity`

`Md3InfoBar.Informational`, `Md3InfoBar.Success`, `Md3InfoBar.Warning`, `Md3InfoBar.Critical`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `severity` | `int (Md3InfoBar.Severity)` | `Md3InfoBar.Informational` | read/write | `Md3InfoBar` | Severity. |
| `title` | `string` | `""` | read/write | `Md3InfoBar` | Title text. |
| `message` | `string` | `""` | read/write | `Md3InfoBar` | Message. |
| `actionText` | `string` | `""` | read/write | `Md3InfoBar` | Action Text. |
| `showClose` | `bool` | `true` | read/write | `Md3InfoBar` | Show Close. |
| `open` | `bool` | `true` | read/write | `Md3InfoBar` | Open the overlay / dialog. |
| `accent` | `color` | `{…}` | readonly | `Md3InfoBar` | Accent. |
| `defaultIcon` | `string` | `{…}` | readonly | `Md3InfoBar` | Default Icon. |
| `icon` | `string` | `defaultIcon` | read/write | `Md3InfoBar` | Material icon name or empty. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `actionClicked()` | `Md3InfoBar` | Emitted when action Clicked. |
| `closed()` | `Md3InfoBar` | Emitted when closed. |

## Methods

_None._

## Example

```qml
import Md3

Md3InfoBar {
    severity: Md3InfoBar.Informational
    title: ""
    message: ""
    actionText: ""
    showClose: true
    open: true
}
```
