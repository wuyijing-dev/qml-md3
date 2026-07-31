# Md3InfoBar

WinUI-style in-page info bar — persistent until dismissed (unlike Snackbar).

- **Source:** `src/Md3/components/Md3InfoBar.qml`
- **Extends:** `Rectangle`

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
| `severity` | `int` | `Md3InfoBar.Informational` | read/write | `Md3InfoBar` | — |
| `title` | `string` | `""` | read/write | `Md3InfoBar` | — |
| `message` | `string` | `""` | read/write | `Md3InfoBar` | — |
| `actionText` | `string` | `""` | read/write | `Md3InfoBar` | — |
| `showClose` | `bool` | `true` | read/write | `Md3InfoBar` | — |
| `open` | `bool` | `true` | read/write | `Md3InfoBar` | — |
| `accent` | `color` | `{…}` | readonly | `Md3InfoBar` | — |
| `defaultIcon` | `string` | `{…}` | readonly | `Md3InfoBar` | — |
| `icon` | `string` | `defaultIcon` | read/write | `Md3InfoBar` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `actionClicked()` | `Md3InfoBar` | — |
| `closed()` | `Md3InfoBar` | — |

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
}
```
