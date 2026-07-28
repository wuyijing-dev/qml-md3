# Md3CommandPalette

Spotlight-style command palette (Ctrl+K). model: [{ title, subtitle?, icon?, id? }]

- **Source:** `src/Md3/components/Md3CommandPalette.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `open` | `bool` | `false` | read/write | `Md3CommandPalette` | — |
| `placeholder` | `string` | `qsTr("Type a command…")` | read/write | `Md3CommandPalette` | — |
| `model` | `var` | `[]` | read/write | `Md3CommandPalette` | — |
| `maxResults` | `int` | `12` | read/write | `Md3CommandPalette` | — |
| `query` | `string` | `""` | read/write | `Md3CommandPalette` | — |
| `highlightIndex` | `int` | `0` | read/write | `Md3CommandPalette` | — |
| `filtered` | `var` | `{…}` | readonly | `Md3CommandPalette` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `activated(var item)` | `Md3CommandPalette` | — |
| `closed()` | `Md3CommandPalette` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `dismiss()` | `Md3CommandPalette` | — |
| `activateIndex(i)` | `Md3CommandPalette` | — |
| `moveHighlight(delta)` | `Md3CommandPalette` | — |

## Example

```qml
import Md3

Md3CommandPalette {
    open: false
    placeholder: qsTr("Type a command…")
    model: []
    maxResults: 12
    query: ""
}
```
