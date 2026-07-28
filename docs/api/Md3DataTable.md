# Md3DataTable

Data table with sort, multi-select, sticky header, empty/loading, and pagination.

- **Source:** `src/Md3/components/Md3DataTable.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `columns` | `var` | `[]` | read/write | `Md3DataTable` | — |
| `rows` | `var` | `[]` | read/write | `Md3DataTable` | — |
| `selectedRow` | `int` | `-1` | read/write | `Md3DataTable` | Single-row highlight (independent of checkbox selection). |
| `selectionEnabled` | `bool` | `false` | read/write | `Md3DataTable` | — |
| `selectedIndices` | `var` | `[]` | read/write | `Md3DataTable` | Indices into `rows` (source order). |
| `sortColumn` | `int` | `-1` | read/write | `Md3DataTable` | — |
| `sortOrder` | `int` | `Qt.AscendingOrder` | read/write | `Md3DataTable` | Qt.AscendingOrder / Qt.DescendingOrder |
| `stickyHeader` | `bool` | `true` | read/write | `Md3DataTable` | — |
| `rowHeight` | `real` | `52` | read/write | `Md3DataTable` | — |
| `headerHeight` | `real` | `56` | read/write | `Md3DataTable` | — |
| `bodyHeight` | `real` | `280` | read/write | `Md3DataTable` | — |
| `loading` | `bool` | `false` | read/write | `Md3DataTable` | — |
| `emptyIcon` | `string` | `"inbox"` | read/write | `Md3DataTable` | — |
| `emptyTitle` | `string` | `qsTr("No data")` | read/write | `Md3DataTable` | — |
| `emptyBody` | `string` | `""` | read/write | `Md3DataTable` | — |
| `emptyActionText` | `string` | `""` | read/write | `Md3DataTable` | — |
| `pagination` | `bool` | `true` | read/write | `Md3DataTable` | — |
| `pageSize` | `int` | `8` | read/write | `Md3DataTable` | — |
| `currentPage` | `int` | `0` | read/write | `Md3DataTable` | — |
| `totalCount` | `int` | `rows ? rows.length : 0` | readonly | `Md3DataTable` | — |
| `sortedEntries` | `var` | `{…}` | readonly | `Md3DataTable` | — |
| `pageCount` | `int` | `{…}` | readonly | `Md3DataTable` | — |
| `pageEntries` | `var` | `{…}` | readonly | `Md3DataTable` | — |
| `headerCheckState` | `int` | `{…}` | readonly | `Md3DataTable` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `rowClicked(int sourceIndex)` | `Md3DataTable` | — |
| `selectionChanged()` | `Md3DataTable` | — |
| `sortChanged(int column, int order)` | `Md3DataTable` | — |
| `emptyActionClicked()` | `Md3DataTable` | — |
| `pageChanged(int page)` | `Md3DataTable` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `toggleRowSelection(sourceIndex)` | `Md3DataTable` | — |
| `clearSelection()` | `Md3DataTable` | — |
| `toggleSort(columnIndex)` | `Md3DataTable` | — |
| `selectPage(on)` | `Md3DataTable` | — |

## Example

```qml
import Md3

Md3DataTable {
    columns: []
    rows: []
    selectedRow: -1
    selectionEnabled: false
    selectedIndices: []
}
```
