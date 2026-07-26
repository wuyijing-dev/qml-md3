# Md3FullscreenDialog

- **Source:** `src/Md3/components/Md3FullscreenDialog.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `open` | `bool` | `false` | read/write | `Md3FullscreenDialog` | — |
| `title` | `string` | `""` | read/write | `Md3FullscreenDialog` | — |
| `confirmText` | `string` | `"Save"` | read/write | `Md3FullscreenDialog` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `confirmed()` | `Md3FullscreenDialog` | — |
| `dismissed()` | `Md3FullscreenDialog` | — |

## Methods

_None._

## Example

```qml
import Md3

Md3FullscreenDialog {
    open: false
    title: ""
    confirmText: "Save"
}
```
