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
| `confirmText` | `string` | `qsTr("Save")` | read/write | `Md3FullscreenDialog` | — |
| `layoutMode` | `int` | `Md3ContainerBody.Fit` | read/write | `Md3FullscreenDialog` | — |
| `content` | `alias` | `body.content` | default read/write | `Md3FullscreenDialog` | Default property → `body.content` |

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
    confirmText: qsTr("Save")
    layoutMode: Md3ContainerBody.Fit
}
```
