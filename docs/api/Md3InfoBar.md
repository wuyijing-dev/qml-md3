# Md3InfoBar

- **Source:** `src/Md3/components/Md3InfoBar.qml`
- **Extends:** `Rectangle`

WinUI-style persistent in-page alert. Prefer over Snackbar for lasting status.

## Enums

`Informational`, `Success`, `Warning`, `Critical`

## Properties

| Name | Type | Default |
|------|------|---------|
| `severity` | `int` | `Informational` |
| `title` / `message` / `actionText` / `icon` | `string` | |
| `showClose` / `open` | `bool` | `true` |

## Signals

`actionClicked()`, `closed()`
