# Md3SideSheet

Modal/standard side sheet — slides from start (left) or end (right).

- **Source:** `src/Md3/components/Md3SideSheet.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 11 | 1 | 1 | 1 |

_Also inherits Qt Quick `Item` members (not listed)._

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
| `open` | `bool` | `false` | read/write | `Md3SideSheet` | Open the overlay / dialog. |
| `modal` | `bool` | `true` | read/write | `Md3SideSheet` | Modal. |
| `edge` | `int (Md3SideSheet.Edge)` | `Md3SideSheet.End` | read/write | `Md3SideSheet` | Edge. |
| `sheetWidth` | `real` | `360` | read/write | `Md3SideSheet` | Sheet Width. |
| `title` | `string` | `""` | read/write | `Md3SideSheet` | Title text. |
| `text` | `string` | `""` | read/write | `Md3SideSheet` | Primary label text. |
| `layoutMode` | `int` | `Md3ContainerBody.Fit` | read/write | `Md3SideSheet` | Layout Mode. |
| `writeOpenOnClose` | `bool` | `true` | read/write | `Md3SideSheet` | When true (default), dismiss writes ``open = false``. Set false if ``open`` is bound externally. |
| `content` | `alias` | `customSlot.data` | default read/write | `Md3SideSheet` | Content. |
| `fromEnd` | `bool` | `edge === Md3SideSheet.End` | readonly | `Md3SideSheet` | From End. |
| `panelWidth` | `real` | `Math.min(sheetWidth, Math.max(240, width * 0.92))` | readonly | `Md3SideSheet` | Panel Width. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `dismissed()` | `Md3SideSheet` | Emitted when dismissed. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `dismiss()` | `—` | `Md3SideSheet` | Dismiss. |

## Example

```qml
import Md3

Md3SideSheet {
    open: false
    modal: true
    edge: Md3SideSheet.End
    sheetWidth: 360
    title: ""
    text: ""
}
```
