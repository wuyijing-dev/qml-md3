# Md3DataTable

- **Source:** `src/Md3/components/Md3DataTable.qml`
- **Extends:** `Column`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `columns` | `var` | `[]` | read/write | `Md3DataTable` | — |
| `rows` | `var` | `[]` | read/write | `Md3DataTable` | — |
| `selectedRow` | `int` | `-1` | read/write | `Md3DataTable` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `rowClicked(int index)` | `Md3DataTable` | — |

## Methods

_None._

## Example

```qml
import Md3

Md3DataTable {
    columns: []
    rows: []
    selectedRow: -1
}
```
