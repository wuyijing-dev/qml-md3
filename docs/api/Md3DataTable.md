# Md3DataTable

Enterprise data table: sort, filter, multi-select, pagination, frozen columns, column resize, custom cell delegate, keyboard nav, row reorder, server paging.

- **Source:** `src/Md3/components/Md3DataTable.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 59 | 13 | 18 | 1 |

_Also inherits Qt Quick `Item` members (not listed)._

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
| `columns` | `var` | `[]` | read/write | `Md3DataTable` | [{ title, role, width, minWidth?, sortable?, filterable? }] |
| `rows` | `var` | `[]` | read/write | `Md3DataTable` | Row data or count. |
| `selectedRow` | `int` | `-1` | read/write | `Md3DataTable` | Selected row index (−1 = none). |
| `selectionEnabled` | `bool` | `false` | read/write | `Md3DataTable` | Enable row selection UI. |
| `selectedIndices` | `var` | `[]` | read/write | `Md3DataTable` | Multi-selection indices. |
| `sortColumn` | `int` | `-1` | read/write | `Md3DataTable` | Sorted column index (−1 = none). |
| `sortOrder` | `int` | `Qt.AscendingOrder` | read/write | `Md3DataTable` | `Qt.AscendingOrder` / `Qt.DescendingOrder`. |
| `density` | `int` | `Md3Theme.density` | read/write | `Md3DataTable` | Layout density (see Enums / theme). |
| `rowHeight` | `real` | `Md3Theme.tableRowHeight` | read/write | `Md3DataTable` | Row Height. |
| `headerHeight` | `real` | `density === Md3DataTable.Compact ? 44 : 56` | read/write | `Md3DataTable` | Header Height. |
| `bodyHeight` | `real` | `280` | read/write | `Md3DataTable` | Body Height. |
| `loading` | `bool` | `false` | read/write | `Md3DataTable` | Show loading / busy presentation. |
| `emptyIcon` | `string` | `"inbox"` | read/write | `Md3DataTable` | Empty-state icon name. |
| `emptyTitle` | `string` | `qsTr("No data")` | read/write | `Md3DataTable` | Empty-state title. |
| `emptyBody` | `string` | `""` | read/write | `Md3DataTable` | Empty-state body. |
| `emptyActionText` | `string` | `""` | read/write | `Md3DataTable` | Empty-state action label. |
| `pagination` | `bool` | `true` | read/write | `Md3DataTable` | Pagination. |
| `pageSize` | `int` | `8` | read/write | `Md3DataTable` | Rows / items per page. |
| `currentPage` | `int` | `0` | read/write | `Md3DataTable` | Zero-based page index. |
| `columnResizeEnabled` | `bool` | `true` | read/write | `Md3DataTable` | Column Resize Enabled. |
| `minColumnWidth` | `real` | `64` | read/write | `Md3DataTable` | Min Column Width. |
| `frozenColumnCount` | `int` | `0` | read/write | `Md3DataTable` | Frozen Column Count. |
| `filterText` | `string` | `""` | read/write | `Md3DataTable` | Global filter string. |
| `columnFilters` | `var` | `{…}` | read/write | `Md3DataTable` | Column Filters. |
| `showFilterBar` | `bool` | `false` | read/write | `Md3DataTable` | Show Filter Bar. |
| `filterPlaceholder` | `string` | `qsTr("Search table…")` | read/write | `Md3DataTable` | Filter Placeholder. |
| `overlayWindow` | `var` | `null` | read/write | `Md3DataTable` | Optional explicit Window for row-action menu overlay. |
| `accessibleName` | `string` | `""` | read/write | `Md3DataTable` | Screen-reader label (defaults to “Data table”). |
| `serverSidePagination` | `bool` | `false` | read/write | `Md3DataTable` | Server Side Pagination. |
| `serverTotalCount` | `int` | `0` | read/write | `Md3DataTable` | Server Total Count. |
| `keyboardNavigationEnabled` | `bool` | `true` | read/write | `Md3DataTable` | Keyboard Navigation Enabled. |
| `rowReorderEnabled` | `bool` | `false` | read/write | `Md3DataTable` | Row Reorder Enabled. |
| `autoReorderRows` | `bool` | `true` | read/write | `Md3DataTable` | Auto Reorder Rows. |
| `showColumnFilterIcons` | `bool` | `false` | read/write | `Md3DataTable` | Show Column Filter Icons. |
| `rowActions` | `var` | `[]` | read/write | `Md3DataTable` | Row Actions. |
| `cellDelegate` | `Component` | `null` | read/write | `Md3DataTable` | Optional cell renderer: set `rowData`, `columnDef`, `columnIndex`, `displayText`, `sourceIndex`. |
| `unloadWhenPageInactive` | `bool` | `true` | read/write | `Md3DataTable` | Drop TableView row models while page is off-display (chrome height stays). |
| `editingSourceIndex` | `int` | `-1` | read/write | `Md3DataTable` | In-cell edit target (−1 = none). Column must set `editable: true`. |
| `editingColumnIndex` | `int` | `-1` | read/write | `Md3DataTable` | Editing Column Index. |
| `focusedColumnIndex` | `int` | `-1` | read/write | `Md3DataTable` | Keyboard focus column for F2 / Left-Right (first editable when unset). |
| `columnWidths` | `var` | `[]` | read/write | `Md3DataTable` | Column Widths. |
| `columnWidthsPersistKey` | `string` | `""` | read/write | `Md3DataTable` | When set, columnWidths are loaded/saved via Md3AppSettings (JSON number array). |
| `rowMenuSourceIndex` | `int` | `-1` | read/write | `Md3DataTable` | Row Menu Source Index. |
| `focusedPageRow` | `int` | `-1` | read/write | `Md3DataTable` | Focused Page Row. |
| `filterMenuColumnIndex` | `int` | `-1` | read/write | `Md3DataTable` | Filter Menu Column Index. |
| `filterMenuSearchText` | `string` | `""` | read/write | `Md3DataTable` | Filter Menu Search Text. |
| `frozenCount` | `int` | `Math.max(0, Math.min(frozenColumnCount, columns ? columns.length : 0))` | readonly | `Md3DataTable` | Frozen Count. |
| `selectionColWidth` | `real` | `selectionEnabled ? 48 : 0` | readonly | `Md3DataTable` | Selection Col Width. |
| `actionsColWidth` | `real` | `(rowActions && rowActions.length) ? 48 : 0` | readonly | `Md3DataTable` | Actions Col Width. |
| `effectiveWidths` | `var` | `{…}` | readonly | `Md3DataTable` | Effective Widths. |
| `frozenStripWidth` | `real` | `{…}` | readonly | `Md3DataTable` | Frozen Strip Width. |
| `scrollColsWidth` | `real` | `{…}` | readonly | `Md3DataTable` | Scroll Cols Width. |
| `tableContentWidth` | `real` | `Math.max(width, frozenStripWidth + scrollColsWidth)` | readonly | `Md3DataTable` | Table Content Width. |
| `filteredEntries` | `var` | `{…}` | readonly | `Md3DataTable` | Filtered Entries. |
| `sortedEntries` | `var` | `{…}` | readonly | `Md3DataTable` | Sorted Entries. |
| `totalCount` | `int` | `serverSidePagination` | readonly | `Md3DataTable` | Total Count. |
| `pageCount` | `int` | `{…}` | readonly | `Md3DataTable` | Page Count. |
| `pageEntries` | `var` | `{…}` | readonly | `Md3DataTable` | Page Entries. |
| `headerCheckState` | `int` | `{…}` | readonly | `Md3DataTable` | Header Check State. |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `rowClicked(int sourceIndex)` | `Md3DataTable` | Emitted when row Clicked. |
| `rowDoubleClicked(int sourceIndex)` | `Md3DataTable` | Emitted when row Double Clicked. |
| `rowActivated(int sourceIndex)` | `Md3DataTable` | Emitted when row Activated. |
| `selectionChanged()` | `Md3DataTable` | Emitted when selection Changed. |
| `sortChanged(int column, int order)` | `Md3DataTable` | Emitted when sort Changed. |
| `filterChanged()` | `Md3DataTable` | Emitted when filter Changed. |
| `emptyActionClicked()` | `Md3DataTable` | Emitted when empty Action Clicked. |
| `pageChanged(int page)` | `Md3DataTable` | Emitted when page Changed. |
| `pageRequested(int page, int sortColumn, int sortOrder)` | `Md3DataTable` | Emitted when page Requested. |
| `rowActionTriggered(int sourceIndex, var action)` | `Md3DataTable` | Emitted when row Action Triggered. |
| `rowOrderChanged(int fromSourceIndex, int toSourceIndex)` | `Md3DataTable` | Emitted when row Order Changed. |
| `exportRequested(string format, string payload)` | `Md3DataTable` | Emitted when export Requested. |
| `cellEdited(int sourceIndex, string role, var newValue, var oldValue)` | `Md3DataTable` | Emitted after a successful in-cell edit commit. |

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `setColumnWidth(index, w)` | `—` | `Md3DataTable` | Set Column Width. |
| `loadColumnWidths()` | `—` | `Md3DataTable` | Load Column Widths. |
| `saveColumnWidths()` | `—` | `Md3DataTable` | Save Column Widths. |
| `exportCsv(includeHeader)` | `—` | `Md3DataTable` | CSV of visible (filtered) rows using column `role` / header. Does not write disk. |
| `exportJson()` | `—` | `Md3DataTable` | JSON array of row objects (filtered). Does not write disk. |
| `cellText(rowData, colDef)` | `—` | `Md3DataTable` | Cell Text. |
| `beginCellEdit(sourceIndex, columnIndex)` | `—` | `Md3DataTable` | Begin Cell Edit. |
| `cancelCellEdit()` | `—` | `Md3DataTable` | Cancel Cell Edit. |
| `commitCellEdit(newValue)` | `—` | `Md3DataTable` | Commit Cell Edit. |
| `clearSelection()` | `—` | `Md3DataTable` | Clear Selection. |
| `clearFilters()` | `—` | `Md3DataTable` | Clear Filters. |
| `toggleSort(columnIndex)` | `—` | `Md3DataTable` | Toggle Sort. |
| `selectPage(on)` | `—` | `Md3DataTable` | Select Page. |
| `openRowMenu(sourceIndex, anchorItem)` | `—` | `Md3DataTable` | Open Row Menu. |
| `openColumnFilter(columnIndex, anchorItem)` | `—` | `Md3DataTable` | Open Column Filter. |
| `setColumnFilterValue(columnIndex, value)` | `—` | `Md3DataTable` | Set Column Filter Value. |
| `moveRow(fromSourceIndex, toSourceIndex)` | `—` | `Md3DataTable` | Move Row. |
| `focusTable()` | `—` | `Md3DataTable` | Focus Table. |

## Example

```qml
import Md3

Md3DataTable {
    columns: []
    rows: []
    selectedRow: -1
    selectionEnabled: false
    selectedIndices: []
    sortColumn: -1
}
```

## 就地编辑

列定义 `editable: true`（文本列）。双击行或 **F2** 进入编辑；`cellEdited(sourceIndex, role, newValue, oldValue)`。

```qml
columns: [
    { title: "Notes", role: "notes", width: 160, editable: true }
]
```
