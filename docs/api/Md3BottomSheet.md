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
| `layoutMode` | `int` | `Md3ContainerBody.Fit` | read/write | `Md3BottomSheet` | — |
| `title` | `string` | `""` | read/write | `Md3BottomSheet` | — |
| `text` | `string` | `""` | read/write | `Md3BottomSheet` | — |
| `confirmText` | `string` | `""` | read/write | `Md3BottomSheet` | — |
| `dismissText` | `string` | `""` | read/write | `Md3BottomSheet` | — |
| `dismissDragThreshold` | `real` | `96` | read/write | `Md3BottomSheet` | Drag distance (px) before release dismisses the sheet. |
| `content` | `alias` | `bodySlot.data` | default read/write | `Md3BottomSheet` | Default property → `bodySlot.data` |
| `maxSheetHeight` | `real` | `parent ? parent.height * 0.6 : 480` | readonly | `Md3BottomSheet` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `dismissed()` | `Md3BottomSheet` | — |
| `confirmed()` | `Md3BottomSheet` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `accept()` | `Md3BottomSheet` | — |
| `reject()` | `Md3BottomSheet` | — |

## Example

```qml
import Md3

Md3BottomSheet {
    open: false
    modal: true
    layoutMode: Md3ContainerBody.Fit
    title: ""
    text: ""
}
```
