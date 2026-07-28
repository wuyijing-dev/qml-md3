# Md3DataTable

Data table: sort, multi-select, sticky header, empty/loading, pagination, column resize, horizontal scroll, row action menu.

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
| `selectedRow` | `int` | `-1` | read/write | `Md3DataTable` | — |
| `selectionEnabled` | `bool` | `false` | read/write | `Md3DataTable` | — |
| `selectedIndices` | `var` | `[]` | read/write | `Md3DataTable` | — |
| `sortColumn` | `int` | `-1` | read/write | `Md3DataTable` | — |
| `sortOrder` | `int` | `Qt.AscendingOrder` | read/write | `Md3DataTable` | — |
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
| `columnResizeEnabled` | `bool` | `true` | read/write | `Md3DataTable` | — |
| `minColumnWidth` | `real` | `64` | read/write | `Md3DataTable` | — |
| `rowActions` | `var` | `[]` | read/write | `Md3DataTable` | [{ text, icon?, id? }] — trailing ⋮ menu per row |
| `columnWidths` | `var` | `[]` | read/write | `Md3DataTable` | — |
| `rowMenuSourceIndex` | `int` | `-1` | read/write | `Md3DataTable` | — |
| `totalCount` | `int` | `rows ? rows.length : 0` | readonly | `Md3DataTable` | — |
| `selectionColWidth` | `real` | `selectionEnabled ? 48 : 0` | readonly | `Md3DataTable` | — |
| `actionsColWidth` | `real` | `(rowActions && rowActions.length) ? 48 : 0` | readonly | `Md3DataTable` | — |
| `effectiveWidths` | `var` | `{…}` | readonly | `Md3DataTable` | — |
| `tableContentWidth` | `real` | `{…}` | readonly | `Md3DataTable` | — |
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
| `rowActionTriggered(int sourceIndex, var action)` | `Md3DataTable` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `setColumnWidth(index, w)` | `Md3DataTable` | — |
| `clearSelection()` | `Md3DataTable` | — |
| `toggleSort(columnIndex)` | `Md3DataTable` | — |
| `selectPage(on)` | `Md3DataTable` | — |
| `openRowMenu(sourceIndex, anchorItem)` | `Md3DataTable` | — |

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
