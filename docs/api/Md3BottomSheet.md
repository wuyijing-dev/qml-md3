# Md3BottomSheet

- **Source:** `src/Md3/components/Md3BottomSheet.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `open` | `bool` | `false` | read/write | `Md3BottomSheet` | — |
| `modal` | `bool` | `true` | read/write | `Md3BottomSheet` | — |
| `content` | `alias` | `sheetContent.data` | default read/write | `Md3BottomSheet` | Default property → `sheetContent.data` |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `dismissed()` | `Md3BottomSheet` | — |

## Methods

_None._

## Example

```qml
import Md3

Md3BottomSheet {
    open: false
    modal: true
}
```
