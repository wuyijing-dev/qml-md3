# Md3SideSheet

Modal/standard side sheet — slides from start (left) or end (right).

- **Source:** `src/Md3/components/Md3SideSheet.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Enums

### `Md3SideSheet.Edge`

`Md3SideSheet.Start`, `Md3SideSheet.End`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `open` | `bool` | `false` | read/write | `Md3SideSheet` | — |
| `modal` | `bool` | `true` | read/write | `Md3SideSheet` | — |
| `edge` | `int` | `Md3SideSheet.End` | read/write | `Md3SideSheet` | — |
| `sheetWidth` | `real` | `360` | read/write | `Md3SideSheet` | — |
| `title` | `string` | `""` | read/write | `Md3SideSheet` | — |
| `content` | `alias` | `sheetBody.data` | default read/write | `Md3SideSheet` | Default property → `sheetBody.data` |
| `fromEnd` | `bool` | `edge === Md3SideSheet.End` | readonly | `Md3SideSheet` | — |
| `panelWidth` | `real` | `Math.min(sheetWidth, Math.max(240, width * 0.92))` | readonly | `Md3SideSheet` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `dismissed()` | `Md3SideSheet` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `dismiss()` | `Md3SideSheet` | — |

## Example

```qml
import Md3

Md3SideSheet {
    open: false
    modal: true
    edge: Md3SideSheet.End
    sheetWidth: 360
    title: ""
}
```
