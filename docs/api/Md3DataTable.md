# Md3DataTable

Enterprise data table: sort, filter, multi-select, pagination, frozen columns, column resize, custom cell delegate, keyboard nav, row reorder, server paging.

- **Source:** `src/Md3/components/Md3DataTable.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Enums

### `Md3DataTable.Density`

`Md3DataTable.Comfortable`, `Md3DataTable.Compact`

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
| `density` | `int` | `Md3DataTable.Comfortable` | read/write | `Md3DataTable` | — |
| `rowHeight` | `real` | `density === Md3DataTable.Compact ? 40 : 52` | read/write | `Md3DataTable` | — |
| `headerHeight` | `real` | `density === Md3DataTable.Compact ? 44 : 56` | read/write | `Md3DataTable` | — |
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
| `frozenColumnCount` | `int` | `0` | read/write | `Md3DataTable` | — |
| `filterText` | `string` | `""` | read/write | `Md3DataTable` | — |
| `columnFilters` | `var` | `{…}` | read/write | `Md3DataTable` | — |
| `showFilterBar` | `bool` | `false` | read/write | `Md3DataTable` | — |
| `filterPlaceholder` | `string` | `qsTr("Search table…")` | read/write | `Md3DataTable` | — |
| `serverSidePagination` | `bool` | `false` | read/write | `Md3DataTable` | — |
| `serverTotalCount` | `int` | `0` | read/write | `Md3DataTable` | — |
| `keyboardNavigationEnabled` | `bool` | `true` | read/write | `Md3DataTable` | — |
| `rowReorderEnabled` | `bool` | `false` | read/write | `Md3DataTable` | — |
| `rowActions` | `var` | `[]` | read/write | `Md3DataTable` | — |
| `cellDelegate` | `Component` | `null` | read/write | `Md3DataTable` | Optional cell renderer: set `rowData`, `columnDef`, `columnIndex`, `displayText`, `sourceIndex`. |
| `columnWidths` | `var` | `[]` | read/write | `Md3DataTable` | — |
| `rowMenuSourceIndex` | `int` | `-1` | read/write | `Md3DataTable` | — |
| `focusedPageRow` | `int` | `-1` | read/write | `Md3DataTable` | — |
| `frozenCount` | `int` | `Math.max(0, Math.min(frozenColumnCount, columns ? columns.length : 0))` | readonly | `Md3DataTable` | — |
| `selectionColWidth` | `real` | `selectionEnabled ? 48 : 0` | readonly | `Md3DataTable` | — |
| `actionsColWidth` | `real` | `(rowActions && rowActions.length) ? 48 : 0` | readonly | `Md3DataTable` | — |
| `effectiveWidths` | `var` | `{…}` | readonly | `Md3DataTable` | — |
| `frozenStripWidth` | `real` | `{…}` | readonly | `Md3DataTable` | — |
| `scrollColsWidth` | `real` | `{…}` | readonly | `Md3DataTable` | — |
| `tableContentWidth` | `real` | `Math.max(width, frozenStripWidth + scrollColsWidth)` | readonly | `Md3DataTable` | — |
| `filteredEntries` | `var` | `{…}` | readonly | `Md3DataTable` | — |
| `sortedEntries` | `var` | `{…}` | readonly | `Md3DataTable` | — |
| `totalCount` | `int` | `serverSidePagination` | readonly | `Md3DataTable` | — |
| `pageCount` | `int` | `{…}` | readonly | `Md3DataTable` | — |
| `pageEntries` | `var` | `{…}` | readonly | `Md3DataTable` | — |
| `headerCheckState` | `int` | `{…}` | readonly | `Md3DataTable` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `rowClicked(int sourceIndex)` | `Md3DataTable` | — |
| `rowDoubleClicked(int sourceIndex)` | `Md3DataTable` | — |
| `rowActivated(int sourceIndex)` | `Md3DataTable` | — |
| `selectionChanged()` | `Md3DataTable` | — |
| `sortChanged(int column, int order)` | `Md3DataTable` | — |
| `filterChanged()` | `Md3DataTable` | — |
| `emptyActionClicked()` | `Md3DataTable` | — |
| `pageChanged(int page)` | `Md3DataTable` | — |
| `pageRequested(int page, int sortColumn, int sortOrder)` | `Md3DataTable` | — |
| `rowActionTriggered(int sourceIndex, var action)` | `Md3DataTable` | — |
| `rowOrderChanged(int fromSourceIndex, int toSourceIndex)` | `Md3DataTable` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `setColumnWidth(index, w)` | `Md3DataTable` | — |
| `cellText(rowData, colDef)` | `Md3DataTable` | — |
| `clearSelection()` | `Md3DataTable` | — |
| `clearFilters()` | `Md3DataTable` | — |
| `toggleSort(columnIndex)` | `Md3DataTable` | — |
| `selectPage(on)` | `Md3DataTable` | — |
| `openRowMenu(sourceIndex, anchorItem)` | `Md3DataTable` | — |
| `focusTable()` | `Md3DataTable` | — |

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
