import QtQuick
import Md3

/// Enterprise data table: sort, filter, multi-select, pagination, frozen columns,
/// column resize, custom cell delegate, keyboard nav, row reorder, server paging.
Item {
    id: root

    enum Density { Comfortable, Compact }

    property var columns: [] // [{ title, role, width, minWidth?, sortable?, filterable? }]
    property var rows: []
    property int selectedRow: -1
    property bool selectionEnabled: false
    property var selectedIndices: []
    property int sortColumn: -1
    property int sortOrder: Qt.AscendingOrder
    property int density: Md3Theme.density
    property real rowHeight: Md3Theme.tableRowHeight
    property real headerHeight: density === Md3DataTable.Compact ? 44 : 56
    property real bodyHeight: 280
    property bool loading: false
    property string emptyIcon: "inbox"
    property string emptyTitle: qsTr("No data")
    property string emptyBody: ""
    property string emptyActionText: ""
    property bool pagination: true
    property int pageSize: 8
    property int currentPage: 0
    property bool columnResizeEnabled: true
    property real minColumnWidth: 64
    property int frozenColumnCount: 0
    property string filterText: ""
    property var columnFilters: ({})
    property bool showFilterBar: false
    property string filterPlaceholder: qsTr("Search table…")
    /// Optional explicit Window for row-action menu overlay.
    property var overlayWindow: null

    Accessible.role: Accessible.Table
    Accessible.name: qsTr("Data table")

    property bool serverSidePagination: false
    property int serverTotalCount: 0
    property bool keyboardNavigationEnabled: true
    property bool rowReorderEnabled: false
    property bool autoReorderRows: true
    property bool showColumnFilterIcons: false
    property var rowActions: []
    /// Optional cell renderer: set `rowData`, `columnDef`, `columnIndex`, `displayText`, `sourceIndex`.
    property Component cellDelegate: null
    /// In-cell edit target (−1 = none). Column must set `editable: true`.
    property int editingSourceIndex: -1
    property int editingColumnIndex: -1

    signal rowClicked(int sourceIndex)
    signal rowDoubleClicked(int sourceIndex)
    signal rowActivated(int sourceIndex)
    signal selectionChanged()
    signal sortChanged(int column, int order)
    signal filterChanged()
    signal emptyActionClicked()
    signal pageChanged(int page)
    signal pageRequested(int page, int sortColumn, int sortOrder)
    signal rowActionTriggered(int sourceIndex, var action)
    signal rowOrderChanged(int fromSourceIndex, int toSourceIndex)
    signal exportRequested(string format, string payload)
    /// Emitted after a successful in-cell edit commit.
    signal cellEdited(int sourceIndex, string role, var newValue, var oldValue)

    property var columnWidths: []
    /// When set, columnWidths are loaded/saved via Md3AppSettings (JSON number array).
    property string columnWidthsPersistKey: ""
    property int rowMenuSourceIndex: -1
    property int focusedPageRow: -1
    property int filterMenuColumnIndex: -1
    property string filterMenuSearchText: ""

    readonly property int frozenCount: Math.max(0, Math.min(frozenColumnCount, columns ? columns.length : 0))
    readonly property real selectionColWidth: selectionEnabled ? 48 : 0
    readonly property real actionsColWidth: (rowActions && rowActions.length) ? 48 : 0
    readonly property var effectiveWidths: {
        const cols = columns || []
        const cw = columnWidths || []
        const out = []
        for (let i = 0; i < cols.length; ++i) {
            if (i < cw.length && typeof cw[i] === "number" && cw[i] > 0)
                out.push(cw[i])
            else
                out.push(cols[i].width !== undefined ? cols[i].width : 120)
        }
        return out
    }
    readonly property real frozenStripWidth: {
        let w = selectionColWidth
        const widths = effectiveWidths
        for (let i = 0; i < frozenCount && i < widths.length; ++i)
            w += widths[i]
        return w + 8
    }
    readonly property real scrollColsWidth: {
        let w = 0
        const widths = effectiveWidths
        for (let i = frozenCount; i < widths.length; ++i)
            w += widths[i]
        return w + actionsColWidth + 8
    }
    readonly property real tableContentWidth: Math.max(width, frozenStripWidth + scrollColsWidth)
    readonly property var filteredEntries: {
        if (serverSidePagination) {
            const list = []
            const src = rows || []
            for (let i = 0; i < src.length; ++i)
                list.push({ row: src[i], sourceIndex: i })
            return list
        }
        const list = []
        const src = rows || []
        for (let i = 0; i < src.length; ++i) {
            if (_rowMatchesFilter(src[i]))
                list.push({ row: src[i], sourceIndex: i })
        }
        return list
    }
    readonly property var sortedEntries: {
        const list = filteredEntries.slice()
        if (sortColumn < 0 || !columns || sortColumn >= columns.length)
            return list
        const col = columns[sortColumn]
        const role = col && col.role !== undefined ? col.role : ""
        if (!role.length)
            return list
        const asc = sortOrder === Qt.AscendingOrder
        list.sort(function (a, b) {
            const va = a.row && a.row[role] !== undefined ? a.row[role] : ""
            const vb = b.row && b.row[role] !== undefined ? b.row[role] : ""
            let cmp = 0
            if (typeof va === "number" && typeof vb === "number")
                cmp = va - vb
            else
                cmp = String(va).localeCompare(String(vb), undefined, { numeric: true, sensitivity: "base" })
            return asc ? cmp : -cmp
        })
        return list
    }
    readonly property int totalCount: serverSidePagination
            ? Math.max(0, serverTotalCount)
            : (filteredEntries ? filteredEntries.length : 0)
    readonly property int pageCount: {
        if (!pagination || pageSize <= 0)
            return 1
        return Math.max(1, Math.ceil(totalCount / pageSize))
    }
    readonly property var pageEntries: {
        const all = sortedEntries
        if (!pagination || pageSize <= 0 || serverSidePagination)
            return all
        const start = Math.max(0, currentPage) * pageSize
        return all.slice(start, start + pageSize)
    }
    readonly property int headerCheckState: {
        if (!selectionEnabled || pageEntries.length === 0)
            return Qt.Unchecked
        let n = 0
        for (let i = 0; i < pageEntries.length; ++i) {
            if (_isSelected(pageEntries[i].sourceIndex))
                ++n
        }
        if (n === 0)
            return Qt.Unchecked
        if (n === pageEntries.length)
            return Qt.Checked
        return Qt.PartiallyChecked
    }

    implicitWidth: 480
    implicitHeight: (showFilterBar ? 56 : 0) + headerHeight + bodyHeight + (pagination ? 48 : 0)
    width: parent ? parent.width : implicitWidth
    height: implicitHeight

    onFilterTextChanged: filterChanged()
    onColumnFiltersChanged: filterChanged()
    onCurrentPageChanged: {
        if (serverSidePagination)
            pageRequested(currentPage, sortColumn, sortOrder)
    }

    function _syncWidthsFromColumns() {
        const cols = columns || []
        const out = []
        for (let i = 0; i < cols.length; ++i)
            out.push(cols[i].width !== undefined ? cols[i].width : 120)
        columnWidths = out
    }

    function setColumnWidth(index, w) {
        const cols = columns || []
        if (index < 0 || index >= cols.length)
            return
        const minW = (cols[index].minWidth !== undefined) ? cols[index].minWidth : minColumnWidth
        const arr = effectiveWidths.slice()
        arr[index] = Math.max(minW, w)
        columnWidths = arr
        if (columnWidthsPersistKey.length)
            Qt.callLater(saveColumnWidths)
    }

    function loadColumnWidths() {
        if (!columnWidthsPersistKey.length)
            return
        const raw = Md3AppSettings.value(columnWidthsPersistKey, "")
        if (!raw || !String(raw).length)
            return
        try {
            const parsed = JSON.parse(String(raw))
            if (parsed && parsed.length)
                columnWidths = parsed
        } catch (e) { /* ignore corrupt */ }
    }

    function saveColumnWidths() {
        if (!columnWidthsPersistKey.length)
            return
        Md3AppSettings.setValue(columnWidthsPersistKey, JSON.stringify(effectiveWidths))
        Md3AppSettings.sync()
    }

    /// CSV of visible (filtered) rows using column `role` / header. Does not write disk.
    function exportCsv(includeHeader) {
        const cols = columns || []
        const entries = filteredEntries || []
        const lines = []
        if (includeHeader !== false) {
            const headers = []
            for (let i = 0; i < cols.length; ++i)
                headers.push(_csvEscape(cols[i].title !== undefined ? cols[i].title
                             : (cols[i].role !== undefined ? cols[i].role : ("c" + i))))
            lines.push(headers.join(","))
        }
        for (let r = 0; r < entries.length; ++r) {
            const row = entries[r].row
            const cells = []
            for (let c = 0; c < cols.length; ++c)
                cells.push(_csvEscape(cellText(row, cols[c])))
            lines.push(cells.join(","))
        }
        const payload = lines.join("\n")
        exportRequested("csv", payload)
        return payload
    }

    /// JSON array of row objects (filtered). Does not write disk.
    function exportJson() {
        const cols = columns || []
        const entries = filteredEntries || []
        const out = []
        for (let r = 0; r < entries.length; ++r) {
            const row = entries[r].row
            const obj = {}
            for (let c = 0; c < cols.length; ++c) {
                const role = cols[c].role !== undefined ? String(cols[c].role) : ("c" + c)
                obj[role] = cellText(row, cols[c])
            }
            out.push(obj)
        }
        const payload = JSON.stringify(out, null, 2)
        exportRequested("json", payload)
        return payload
    }

    function _csvEscape(v) {
        const s = String(v === undefined || v === null ? "" : v)
        if (/[",\n\r]/.test(s))
            return "\"" + s.replace(/"/g, "\"\"") + "\""
        return s
    }

    function cellText(rowData, colDef) {
        const role = colDef && colDef.role
        return rowData && role !== undefined && rowData[role] !== undefined
                ? String(rowData[role]) : ""
    }

    function beginCellEdit(sourceIndex, columnIndex) {
        const cols = columns || []
        if (sourceIndex < 0 || columnIndex < 0 || columnIndex >= cols.length)
            return
        const col = cols[columnIndex]
        if (!col || col.editable !== true)
            return
        editingSourceIndex = sourceIndex
        editingColumnIndex = columnIndex
    }

    function cancelCellEdit() {
        editingSourceIndex = -1
        editingColumnIndex = -1
    }

    function commitCellEdit(newValue) {
        if (editingSourceIndex < 0 || editingColumnIndex < 0)
            return
        const cols = columns || []
        const col = cols[editingColumnIndex]
        if (!col || col.role === undefined) {
            cancelCellEdit()
            return
        }
        const role = String(col.role)
        const rowsCopy = (rows || []).slice()
        if (editingSourceIndex >= rowsCopy.length) {
            cancelCellEdit()
            return
        }
        const row = Object.assign({}, rowsCopy[editingSourceIndex])
        const oldValue = row[role]
        row[role] = newValue
        rowsCopy[editingSourceIndex] = row
        rows = rowsCopy
        const src = editingSourceIndex
        cancelCellEdit()
        cellEdited(src, role, newValue, oldValue)
    }

    function _rowMatchesFilter(row) {
        if (!row)
            return false
        const ft = String(filterText || "").trim().toLowerCase()
        if (ft.length) {
            let hit = false
            const cols = columns || []
            for (let c = 0; c < cols.length; ++c) {
                const role = cols[c].role
                if (role === undefined)
                    continue
                const v = row[role]
                if (v !== undefined && String(v).toLowerCase().indexOf(ft) >= 0) {
                    hit = true
                    break
                }
            }
            if (!hit)
                return false
        }
        const cf = columnFilters || {}
        const cols = columns || []
        for (let c = 0; c < cols.length; ++c) {
            const role = cols[c].role
            if (!role || cf[role] === undefined)
                continue
            const fv = String(cf[role] || "").trim().toLowerCase()
            if (!fv.length)
                continue
            const v = row[role]
            if (String(v !== undefined ? v : "").toLowerCase().indexOf(fv) < 0)
                return false
        }
        return true
    }

    function _isSelected(sourceIndex) {
        return (selectedIndices || []).indexOf(sourceIndex) >= 0
    }

    function _setSelected(sourceIndex, on) {
        const sel = (selectedIndices || []).slice()
        const i = sel.indexOf(sourceIndex)
        if (on && i < 0)
            sel.push(sourceIndex)
        else if (!on && i >= 0)
            sel.splice(i, 1)
        selectedIndices = sel
        selectionChanged()
    }

    function clearSelection() {
        selectedIndices = []
        selectionChanged()
    }

    function clearFilters() {
        filterText = ""
        columnFilters = {}
        currentPage = 0
        filterChanged()
    }

    function toggleSort(columnIndex) {
        if (!columns || columnIndex < 0 || columnIndex >= columns.length)
            return
        const col = columns[columnIndex]
        if (col && col.sortable === false)
            return
        if (sortColumn !== columnIndex) {
            sortColumn = columnIndex
            sortOrder = Qt.AscendingOrder
        } else if (sortOrder === Qt.AscendingOrder) {
            sortOrder = Qt.DescendingOrder
        } else {
            sortColumn = -1
        }
        currentPage = 0
        sortChanged(sortColumn, sortOrder)
        if (serverSidePagination)
            pageRequested(currentPage, sortColumn, sortOrder)
    }

    function selectPage(on) {
        const sel = (selectedIndices || []).slice()
        for (let i = 0; i < pageEntries.length; ++i) {
            const idx = pageEntries[i].sourceIndex
            const at = sel.indexOf(idx)
            if (on && at < 0)
                sel.push(idx)
            else if (!on && at >= 0)
                sel.splice(at, 1)
        }
        selectedIndices = sel
        selectionChanged()
    }

    function openRowMenu(sourceIndex, anchorItem) {
        if (!rowActions || !rowActions.length || !anchorItem)
            return
        rowMenuSourceIndex = sourceIndex
        const p = Md3OverlayHost.mapToOverlay(anchorItem, 0, anchorItem.height, root.overlayWindow)
        if (rowMenu.overlayWindow !== undefined)
            rowMenu.overlayWindow = root.overlayWindow
        rowMenu.popup(p.x, p.y)
    }

    function _columnUniqueValues(columnIndex) {
        const out = []
        if (!columns || columnIndex < 0 || columnIndex >= columns.length)
            return out
        const role = columns[columnIndex].role
        if (!role)
            return out
        const seen = {}
        const src = rows || []
        for (let i = 0; i < src.length; ++i) {
            const v = src[i] && src[i][role] !== undefined ? String(src[i][role]) : ""
            if (!seen[v]) {
                seen[v] = true
                out.push(v)
            }
        }
        out.sort(function (a, b) { return a.localeCompare(b, undefined, { numeric: true, sensitivity: "base" }) })
        return out
    }

    function _columnFilterValues() {
        const values = _columnUniqueValues(filterMenuColumnIndex)
        const q = String(filterMenuSearchText || "").trim().toLowerCase()
        if (!q.length)
            return values
        return values.filter(function (v) { return String(v).toLowerCase().indexOf(q) >= 0 })
    }

    function openColumnFilter(columnIndex, anchorItem) {
        if (!showColumnFilterIcons || !anchorItem)
            return
        filterMenuColumnIndex = columnIndex
        filterMenuSearchText = ""
        columnFilterMenu.popupAtItem(anchorItem, 0, anchorItem.height)
    }

    function setColumnFilterValue(columnIndex, value) {
        if (!columns || columnIndex < 0 || columnIndex >= columns.length)
            return
        const role = columns[columnIndex].role
        if (!role)
            return
        const next = Object.assign({}, columnFilters || {})
        if (value === undefined || value === null || String(value).length === 0)
            delete next[role]
        else
            next[role] = String(value)
        columnFilters = next
        currentPage = 0
        filterChanged()
    }

    function moveRow(fromSourceIndex, toSourceIndex) {
        if (serverSidePagination)
            return
        const src = rows || []
        if (fromSourceIndex < 0 || fromSourceIndex >= src.length
                || toSourceIndex < 0 || toSourceIndex >= src.length
                || fromSourceIndex === toSourceIndex)
            return
        const next = src.slice()
        const moved = next.splice(fromSourceIndex, 1)[0]
        next.splice(toSourceIndex, 0, moved)
        rows = next
        rowOrderChanged(fromSourceIndex, toSourceIndex)
    }

    function focusTable() {
        tableFocus.forceActiveFocus()
    }

    function _moveFocus(delta) {
        const n = pageEntries.length
        if (n === 0) {
            focusedPageRow = -1
            return
        }
        let next = focusedPageRow < 0 ? 0 : focusedPageRow + delta
        next = Math.max(0, Math.min(n - 1, next))
        focusedPageRow = next
        const entry = pageEntries[next]
        if (entry)
            selectedRow = entry.sourceIndex
    }

    function _activateFocusedRow() {
        if (focusedPageRow < 0 || focusedPageRow >= pageEntries.length)
            return
        const idx = pageEntries[focusedPageRow].sourceIndex
        rowActivated(idx)
        rowClicked(idx)
    }

    onColumnsChanged: _syncWidthsFromColumns()
    Component.onCompleted: {
        _syncWidthsFromColumns()
        loadColumnWidths()
    }
    onRowsChanged: {
        if (currentPage >= pageCount)
            currentPage = Math.max(0, pageCount - 1)
    }
    onPageSizeChanged: currentPage = 0
    onPageEntriesChanged: {
        if (focusedPageRow >= pageEntries.length)
            focusedPageRow = pageEntries.length ? 0 : -1
    }

    component HeaderCell: Item {
        id: hcell
        property int columnIndex: 0
        property var columnDef: ({})
        property bool showResize: true
        readonly property bool sortable: columnDef.sortable !== false
        readonly property bool activeSort: root.sortColumn === columnIndex

        Text {
            anchors.left: parent.left
            anchors.leftMargin: 8
            anchors.right: parent.right
            anchors.rightMargin: (hcell.activeSort || (root.showColumnFilterIcons && hcell.columnDef.filterable !== false)) ? 42 : 12
            anchors.verticalCenter: parent.verticalCenter
            text: hcell.columnDef.title !== undefined ? hcell.columnDef.title : ""
            color: Md3Theme.colorScheme.colorOnSurface
            font.family: Md3Theme.typography.fontFamily
            font.pixelSize: Md3Theme.typography.labelLarge.size
            font.weight: Font.Medium
            elide: Text.ElideRight
        }
        Md3Icon {
            visible: hcell.activeSort
            anchors.right: parent.right
            anchors.rightMargin: root.showColumnFilterIcons && hcell.columnDef.filterable !== false ? 26 : 10
            anchors.verticalCenter: parent.verticalCenter
            icon: root.sortOrder === Qt.AscendingOrder ? "arrow_upward" : "arrow_downward"
            size: 16
            iconColor: Md3Theme.colorScheme.primary
        }
        Md3IconButton {
            id: filterBtn
            visible: root.showColumnFilterIcons && hcell.columnDef.filterable !== false
            anchors.right: parent.right
            anchors.rightMargin: 2
            anchors.verticalCenter: parent.verticalCenter
            icon: "filter_list"
            onClicked: root.openColumnFilter(hcell.columnIndex, filterBtn)
        }
        MouseArea {
            anchors.fill: parent
            anchors.rightMargin: 6
            enabled: hcell.sortable
            cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
            onClicked: root.toggleSort(hcell.columnIndex)
        }
        MouseArea {
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: 6
            visible: root.columnResizeEnabled && hcell.showResize
            cursorShape: Qt.SplitHCursor
            preventStealing: true
            property real startX: 0
            property real startW: 0
            onPressed: function (mouse) {
                startX = mapToItem(root, mouse.x, 0).x
                startW = hcell.width
            }
            onPositionChanged: function (mouse) {
                if (!pressed)
                    return
                const x = mapToItem(root, mouse.x, 0).x
                root.setColumnWidth(hcell.columnIndex, startW + (x - startX))
            }
        }
    }

    component DataCell: Item {
        id: cellHost
        property var rowData
        property var columnDef
        property int columnIndex: 0
        property int sourceIndex: -1
        property string displayText: root.cellText(rowData, columnDef)

        readonly property string cellType: {
            const t = columnDef && columnDef.type !== undefined ? String(columnDef.type).toLowerCase() : "text"
            return t.length ? t : "text"
        }
        readonly property bool useBuiltin: root.cellDelegate === null
        readonly property bool editable: columnDef && columnDef.editable === true
        readonly property bool editing: editable
                && root.editingSourceIndex === sourceIndex
                && root.editingColumnIndex === columnIndex

        Loader {
            anchors.fill: parent
            active: root.cellDelegate !== null
            sourceComponent: root.cellDelegate
            onLoaded: {
                if (!item)
                    return
                item.rowData = cellHost.rowData
                item.columnDef = cellHost.columnDef
                item.columnIndex = cellHost.columnIndex
                item.displayText = cellHost.displayText
                item.sourceIndex = cellHost.sourceIndex
            }
        }

        // type: "text" (default)
        Text {
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width
            leftPadding: 8
            visible: cellHost.useBuiltin && cellHost.cellType === "text" && !cellHost.editing
            text: cellHost.displayText
            color: Md3Theme.colorScheme.colorOnSurface
            font.family: Md3Theme.typography.fontFamily
            font.pixelSize: Md3Theme.typography.bodyMedium.size
            elide: Text.ElideRight
        }

        TextInput {
            id: cellEditor
            anchors.fill: parent
            anchors.margins: 4
            leftPadding: 8
            rightPadding: 8
            verticalAlignment: TextInput.AlignVCenter
            visible: cellHost.useBuiltin && cellHost.editing
            color: Md3Theme.colorScheme.colorOnSurface
            font.family: Md3Theme.typography.fontFamily
            font.pixelSize: Md3Theme.typography.bodyMedium.size
            selectByMouse: true
            clip: true

            Rectangle {
                anchors.fill: parent
                z: -1
                radius: Md3Theme.shape.extraSmall
                color: Md3Theme.colorScheme.surfaceContainerHighest
                border.width: 1
                border.color: Md3Theme.colorScheme.primary
            }

            onVisibleChanged: {
                if (visible) {
                    text = cellHost.displayText
                    forceActiveFocus()
                    selectAll()
                }
            }
            Keys.onReturnPressed: root.commitCellEdit(text)
            Keys.onEnterPressed: root.commitCellEdit(text)
            Keys.onEscapePressed: root.cancelCellEdit()
            onEditingFinished: {
                if (cellHost.editing)
                    root.commitCellEdit(text)
            }
        }

        // type: "chip" — optional chipIcon / chipIconMap / chipIconRole
        Md3AssistChip {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 4
            visible: cellHost.useBuiltin && cellHost.cellType === "chip"
            text: cellHost.displayText
            icon: {
                const def = cellHost.columnDef || {}
                if (def.chipIcon)
                    return String(def.chipIcon)
                if (def.chipIconRole && cellHost.rowData)
                    return String(cellHost.rowData[def.chipIconRole] || "")
                if (def.chipIconMap && typeof def.chipIconMap === "object") {
                    const k = cellHost.displayText
                    if (def.chipIconMap[k] !== undefined)
                        return String(def.chipIconMap[k])
                }
                return ""
            }
        }

        // type: "avatar" — initials from displayText or avatarRole / avatarSourceRole
        Md3Avatar {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 8
            visible: cellHost.useBuiltin && cellHost.cellType === "avatar"
            sizePreset: Md3Avatar.ExtraSmall
            initials: {
                const def = cellHost.columnDef || {}
                if (def.avatarRole && cellHost.rowData && cellHost.rowData[def.avatarRole] !== undefined)
                    return String(cellHost.rowData[def.avatarRole])
                const t = cellHost.displayText.trim()
                if (!t.length)
                    return ""
                const parts = t.split(/\s+/)
                if (parts.length >= 2)
                    return (parts[0][0] + parts[1][0]).toUpperCase()
                return t.slice(0, 2).toUpperCase()
            }
            source: {
                const def = cellHost.columnDef || {}
                if (def.avatarSourceRole && cellHost.rowData)
                    return cellHost.rowData[def.avatarSourceRole] || ""
                return ""
            }
        }

        // type: "check" — truthy display / boolean role
        Md3Checkbox {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 8
            visible: cellHost.useBuiltin && cellHost.cellType === "check"
            enabled: false
            checked: {
                const v = cellHost.rowData && cellHost.columnDef && cellHost.columnDef.role
                          ? cellHost.rowData[cellHost.columnDef.role]
                          : cellHost.displayText
                if (typeof v === "boolean")
                    return v
                const s = String(v).toLowerCase()
                return s === "1" || s === "true" || s === "yes" || s === "checked"
            }
        }
    }

    component BodyRow: Rectangle {
        id: bodyRow
        property int pageRowIndex: 0
        property var entry
        readonly property int sourceIndex: entry ? entry.sourceIndex : -1
        readonly property var rowData: entry ? entry.row : null
        readonly property bool checked: root._isSelected(sourceIndex)
        readonly property bool highlighted: root.selectedRow === sourceIndex || checked
        readonly property bool keyboardFocused: root.focusedPageRow === pageRowIndex

        width: parent ? parent.width : 0
        height: root.rowHeight
        color: keyboardFocused ? Md3Theme.colorScheme.primaryContainer
              : (highlighted ? Md3Theme.colorScheme.secondaryContainer : "transparent")
        border.width: keyboardFocused && tableFocus.activeFocus ? 2 : 0
        border.color: Md3Theme.colorScheme.secondary

        property int dragFromIndex: -1
        property int dragTargetIndex: -1

        Row {
            anchors.fill: parent
            anchors.leftMargin: 8
            anchors.rightMargin: 8
            spacing: 0

            Item {
                visible: root.selectionEnabled
                width: 48
                height: parent.height
                Md3Checkbox {
                    anchors.centerIn: parent
                    checked: bodyRow.checked
                    onToggled: function (state) {
                        root._setSelected(bodyRow.sourceIndex, state === Qt.Checked)
                    }
                }
            }

            Repeater {
                model: root.columns
                delegate: DataCell {
                    required property int index
                    required property var modelData
                    width: root.effectiveWidths[index] || 120
                    height: bodyRow.height
                    visible: index >= 0
                    rowData: bodyRow.rowData
                    columnDef: modelData
                    columnIndex: index
                    sourceIndex: bodyRow.sourceIndex
                }
            }

            Item {
                visible: root.actionsColWidth > 0
                width: 48
                height: parent.height
                Md3IconButton {
                    id: moreBtn
                    anchors.centerIn: parent
                    icon: "more_vert"
                    accessibleName: qsTr("Row actions")
                    onClicked: root.openRowMenu(bodyRow.sourceIndex, moreBtn)
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            anchors.leftMargin: root.selectionEnabled ? 48 : 0
            anchors.rightMargin: root.actionsColWidth
            z: -1
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onClicked: function (mouse) {
                root.focusedPageRow = bodyRow.pageRowIndex
                root.selectedRow = bodyRow.sourceIndex
                root.rowClicked(bodyRow.sourceIndex)
                tableFocus.forceActiveFocus()
            }
            onDoubleClicked: {
                const cols = root.columns || []
                for (let i = 0; i < cols.length; ++i) {
                    if (cols[i] && cols[i].editable === true) {
                        root.beginCellEdit(bodyRow.sourceIndex, i)
                        return
                    }
                }
                root.rowDoubleClicked(bodyRow.sourceIndex)
                root.rowActivated(bodyRow.sourceIndex)
            }
        }

        DragHandler {
            enabled: root.rowReorderEnabled
            target: null
            onActiveChanged: {
                if (active) {
                    bodyRow.dragFromIndex = bodyRow.sourceIndex
                    bodyRow.dragTargetIndex = bodyRow.sourceIndex
                } else if (bodyRow.dragFromIndex >= 0 && bodyRow.dragTargetIndex >= 0
                           && bodyRow.dragFromIndex !== bodyRow.dragTargetIndex) {
                    if (root.autoReorderRows)
                        root.moveRow(bodyRow.dragFromIndex, bodyRow.dragTargetIndex)
                    else
                        root.rowOrderChanged(bodyRow.dragFromIndex, bodyRow.dragTargetIndex)
                }
            }
            onTranslationChanged: {
                if (!active || bodyRow.dragFromIndex < 0)
                    return
                const y = bodyRow.mapToItem(rowsCol, 0, translation.y).y
                const idx = Math.max(0, Math.min(root.pageEntries.length - 1, Math.floor(y / root.rowHeight)))
                const target = root.pageEntries[idx]
                if (target)
                    bodyRow.dragTargetIndex = target.sourceIndex
            }
        }

        Md3Divider {
            anchors.bottom: parent.bottom
            width: parent.width
        }
    }

    FocusScope {
        id: tableFocus
        anchors.fill: parent
        focus: root.keyboardNavigationEnabled

        Keys.onPressed: function (event) {
            if (!root.keyboardNavigationEnabled)
                return
            switch (event.key) {
            case Qt.Key_Up:
                root._moveFocus(-1)
                event.accepted = true
                break
            case Qt.Key_Down:
                root._moveFocus(1)
                event.accepted = true
                break
            case Qt.Key_Return:
            case Qt.Key_Enter:
                root._activateFocusedRow()
                event.accepted = true
                break
            case Qt.Key_F2: {
                if (root.focusedPageRow >= 0) {
                    const e = root.pageEntries[root.focusedPageRow]
                    const cols = root.columns || []
                    if (e) {
                        for (let i = 0; i < cols.length; ++i) {
                            if (cols[i] && cols[i].editable === true) {
                                root.beginCellEdit(e.sourceIndex, i)
                                event.accepted = true
                                break
                            }
                        }
                    }
                }
                break
            }
            case Qt.Key_Escape:
                if (root.editingSourceIndex >= 0) {
                    root.cancelCellEdit()
                    event.accepted = true
                }
                break
            case Qt.Key_Space:
                if (root.selectionEnabled && root.focusedPageRow >= 0) {
                    const e = root.pageEntries[root.focusedPageRow]
                    if (e)
                        root._setSelected(e.sourceIndex, !root._isSelected(e.sourceIndex))
                }
                event.accepted = true
                break
            case Qt.Key_Home:
                root.focusedPageRow = root.pageEntries.length ? 0 : -1
                event.accepted = true
                break
            case Qt.Key_End:
                root.focusedPageRow = root.pageEntries.length ? root.pageEntries.length - 1 : -1
                event.accepted = true
                break
            case Qt.Key_PageUp:
                root._moveFocus(-Math.max(1, Math.floor(root.bodyHeight / root.rowHeight) - 1))
                event.accepted = true
                break
            case Qt.Key_PageDown:
                root._moveFocus(Math.max(1, Math.floor(root.bodyHeight / root.rowHeight) - 1))
                event.accepted = true
                break
            }
        }

        Md3FocusRing {
            anchors.fill: parent
            anchors.margins: 2
            radius: Md3Theme.shape.small
            focused: tableFocus.activeFocus
            controlEnabled: root.keyboardNavigationEnabled
            visualFocus: tableFocus.activeFocus
            z: 20
        }

        Column {
            id: chrome
            width: parent.width
            spacing: 0

            Item {
                visible: root.showFilterBar
                width: parent.width
                height: visible ? 56 : 0
                Md3SearchBar {
                    anchors.fill: parent
                    anchors.margins: 4
                    text: root.filterText
                    placeholderText: root.filterPlaceholder
                    onTextChanged: root.filterText = text
                }
            }

            Item {
                id: tableStack
                width: parent.width
                height: root.headerHeight + root.bodyHeight
                clip: true

                Row {
                    anchors.fill: parent
                    spacing: 0
                    visible: root.frozenCount > 0

                    // Frozen strip
                    Column {
                        id: frozenPane
                        visible: root.frozenCount > 0
                        width: visible ? root.frozenStripWidth : 0
                        height: parent.height
                        z: 2
                        clip: true

                        Rectangle {
                            width: parent.width
                            height: root.headerHeight
                            color: Md3Theme.colorScheme.surfaceContainerLow
                            Row {
                                anchors.fill: parent
                                anchors.leftMargin: 8
                                spacing: 0
                                Item {
                                    visible: root.selectionEnabled
                                    width: 48
                                    height: parent.height
                                    Md3Checkbox {
                                        anchors.centerIn: parent
                                        tristate: true
                                        checkState: root.headerCheckState
                                    }
                                    MouseArea {
                                        anchors.fill: parent
                                        z: 1
                                        onClicked: root.selectPage(root.headerCheckState !== Qt.Checked)
                                    }
                                }
                                Repeater {
                                    model: root.frozenCount
                                    delegate: HeaderCell {
                                        required property int index
                                        columnIndex: index
                                        columnDef: root.columns[index]
                                        width: root.effectiveWidths[index] || 120
                                        height: root.headerHeight
                                    }
                                }
                            }
                            Md3Divider { anchors.bottom: parent.bottom; width: parent.width }
                        }

                        Flickable {
                            id: bodyFrozen
                            width: parent.width
                            height: root.bodyHeight
                            clip: true
                            contentHeight: frozenRows.height
                            boundsBehavior: Flickable.StopAtBounds
                            flickableDirection: Flickable.VerticalFlick
                            interactive: !root.loading && root.pageEntries.length > 0

                            Column {
                                id: frozenRows
                                width: parent.width
                                Repeater {
                                    model: root.loading ? 0 : root.pageEntries
                                    delegate: Item {
                                        id: frozenRowItem
                                        required property int index
                                        required property var modelData
                                        width: frozenRows.width
                                        height: root.rowHeight
                                        Row {
                                            anchors.fill: parent
                                            anchors.leftMargin: 8
                                            Item {
                                                visible: root.selectionEnabled
                                                width: 48
                                                height: parent.height
                                                Md3Checkbox {
                                                    anchors.centerIn: parent
                                                    checked: root._isSelected(frozenRowItem.modelData.sourceIndex)
                                                    onToggled: function (state) {
                                                        root._setSelected(frozenRowItem.modelData.sourceIndex, state === Qt.Checked)
                                                    }
                                                }
                                            }
                                            Repeater {
                                                model: root.frozenCount
                                                delegate: DataCell {
                                                    required property int index
                                                    width: root.effectiveWidths[index] || 120
                                                    height: parent.height
                                                    rowData: frozenRowItem.modelData.row
                                                    columnDef: root.columns[index]
                                                    columnIndex: index
                                                    sourceIndex: frozenRowItem.modelData.sourceIndex
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        Rectangle {
                            anchors.right: parent.right
                            width: 4
                            height: parent.height
                            visible: bodyFlick.contentX > 0.5
                            gradient: Gradient {
                                orientation: Gradient.Horizontal
                                GradientStop { position: 0; color: "transparent" }
                                GradientStop { position: 1; color: Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.shadow, 0.15) }
                            }
                        }
                    }

                    // Scrollable region (H+V); sticky header tracks contentX
                    Item {
                        id: scrollPane
                        width: parent.width - frozenPane.width
                        height: parent.height
                        clip: true

                        readonly property real _paneContentW: Math.max(width, root.scrollColsWidth)

                        Item {
                            id: scrollHeaderClip
                            width: parent.width
                            height: root.headerHeight
                            clip: true
                            z: 1

                            Rectangle {
                                id: headerBar
                                x: -bodyFlick.contentX
                                width: scrollPane._paneContentW
                                height: root.headerHeight
                                color: Md3Theme.colorScheme.surfaceContainerLow
                                Row {
                                    anchors.fill: parent
                                    anchors.leftMargin: 8
                                    anchors.rightMargin: 8
                                    spacing: 0
                                    Repeater {
                                        model: {
                                            const out = []
                                            for (let i = root.frozenCount; i < (root.columns || []).length; ++i)
                                                out.push(i)
                                            return out
                                        }
                                        delegate: HeaderCell {
                                            required property var modelData
                                            columnIndex: modelData
                                            columnDef: root.columns[modelData]
                                            width: root.effectiveWidths[modelData] || 120
                                            height: headerBar.height
                                        }
                                    }
                                    Item {
                                        visible: root.actionsColWidth > 0
                                        width: 48
                                        height: parent.height
                                    }
                                }
                                Md3Divider { anchors.bottom: parent.bottom; width: parent.width }
                            }
                        }

                        Flickable {
                            id: bodyFlick
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.top: scrollHeaderClip.bottom
                            anchors.bottom: parent.bottom
                            clip: true
                            contentWidth: scrollPane._paneContentW
                            contentHeight: rowsCol.height
                            boundsBehavior: Flickable.StopAtBounds
                            interactive: !root.loading && root.pageEntries.length > 0
                            flickableDirection: {
                                const h = contentWidth > width + 1
                                const v = contentHeight > height + 1
                                if (h && v)
                                    return Flickable.HorizontalAndVerticalFlick
                                if (h)
                                    return Flickable.HorizontalFlick
                                return Flickable.VerticalFlick
                            }
                            onContentYChanged: {
                                if (bodyFrozen.contentY !== contentY)
                                    bodyFrozen.contentY = contentY
                            }

                            Connections {
                                target: bodyFrozen
                                function onContentYChanged() {
                                    if (bodyFlick.contentY !== bodyFrozen.contentY)
                                        bodyFlick.contentY = bodyFrozen.contentY
                                }
                            }

                            Column {
                                id: rowsCol
                                width: scrollPane._paneContentW
                                Repeater {
                                    model: root.loading ? 0 : root.pageEntries
                                    delegate: Item {
                                        id: scrollRowItem
                                        required property int index
                                        required property var modelData
                                        width: rowsCol.width
                                        height: root.rowHeight
                                        Row {
                                            anchors.fill: parent
                                            anchors.leftMargin: 8
                                            anchors.rightMargin: 8
                                            Repeater {
                                                model: {
                                                    const out = []
                                                    for (let i = root.frozenCount; i < (root.columns || []).length; ++i)
                                                        out.push(i)
                                                    return out
                                                }
                                                delegate: DataCell {
                                                    required property var modelData
                                                    width: root.effectiveWidths[modelData] || 120
                                                    height: parent.height
                                                    rowData: scrollRowItem.modelData.row
                                                    columnDef: root.columns[modelData]
                                                    columnIndex: modelData
                                                    sourceIndex: scrollRowItem.modelData.sourceIndex
                                                }
                                            }
                                            Item {
                                                visible: root.actionsColWidth > 0
                                                width: 48
                                                height: parent.height
                                                Md3IconButton {
                                                    id: scrollMoreBtn
                                                    anchors.centerIn: parent
                                                    icon: "more_vert"
                                                    onClicked: root.openRowMenu(scrollRowItem.modelData.sourceIndex, scrollMoreBtn)
                                                }
                                            }
                                        }
                                        MouseArea {
                                            cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                                            anchors.fill: parent
                                            anchors.rightMargin: root.actionsColWidth
                                            z: -1
                                            onClicked: {
                                                root.focusedPageRow = scrollRowItem.index
                                                root.selectedRow = scrollRowItem.modelData.sourceIndex
                                                root.rowClicked(scrollRowItem.modelData.sourceIndex)
                                                tableFocus.forceActiveFocus()
                                            }
                                            onDoubleClicked: {
                                                const cols = root.columns || []
                                                const src = scrollRowItem.modelData.sourceIndex
                                                for (let i = 0; i < cols.length; ++i) {
                                                    if (cols[i] && cols[i].editable === true) {
                                                        root.beginCellEdit(src, i)
                                                        return
                                                    }
                                                }
                                                root.rowDoubleClicked(src)
                                                root.rowActivated(src)
                                            }
                                        }
                                        Rectangle {
                                            anchors.bottom: parent.bottom
                                            width: parent.width
                                            height: 1
                                            color: "transparent"
                                            Md3Divider { anchors.fill: parent }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                // Full-width rows when no frozen columns (simpler path)
                Loader {
                    id: freeLoader
                    anchors.fill: parent
                    active: root.frozenCount === 0
                    sourceComponent: freeTableComponent
                }

                Md3ScrollBar {
                    id: tableVBar
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.topMargin: root.headerHeight
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: tableHBar.visible ? tableHBar.height : 0
                    z: 5
                    flickable: root.frozenCount > 0 ? bodyFlick : (freeLoader.item ? freeLoader.item.bodyFlickable : null)
                    orientation: Qt.Vertical
                }

                Md3ScrollBar {
                    id: tableHBar
                    anchors.left: parent.left
                    anchors.leftMargin: root.frozenCount > 0 ? frozenPane.width : 0
                    anchors.right: parent.right
                    anchors.rightMargin: tableVBar.visible ? tableVBar.width : 0
                    anchors.bottom: parent.bottom
                    z: 5
                    flickable: root.frozenCount > 0 ? bodyFlick : (freeLoader.item ? freeLoader.item.bodyFlickable : null)
                    orientation: Qt.Horizontal
                }

                Rectangle {
                    anchors.fill: parent
                    anchors.topMargin: root.headerHeight
                    visible: root.loading
                    z: 4
                    color: Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.surface, 0.72)
                    Column {
                        anchors.centerIn: parent
                        spacing: 12
                        Md3CircularProgressIndicator { anchors.horizontalCenter: parent.horizontalCenter; indeterminate: true; size: 40 }
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: qsTr("Loading…")
                            color: Md3Theme.colorScheme.colorOnSurfaceVariant
                        }
                    }
                }

                Md3EmptyState {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: root.headerHeight
                    width: Math.min(parent.width - 24, 360)
                    height: root.bodyHeight
                    z: 4
                    visible: !root.loading && root.totalCount === 0
                    icon: root.emptyIcon
                    title: root.emptyTitle
                    body: root.emptyBody
                    actionText: root.emptyActionText
                    onActionClicked: root.emptyActionClicked()
                }
            }

            Md3Divider { width: parent.width; visible: root.pagination }

            Md3Pagination {
                width: parent.width
                visible: root.pagination
                pageCount: root.pageCount
                currentPage: root.currentPage
                pageSize: root.pageSize
                totalCount: root.totalCount
                enabled: !root.loading && root.totalCount > 0
                onPageRequested: function (page) {
                    root.currentPage = page
                    root.pageChanged(page)
                    if (root.serverSidePagination)
                        root.pageRequested(page, root.sortColumn, root.sortOrder)
                }
            }
        }
    }

    Component {
        id: freeTableComponent
        Item {
            id: freeRoot
            readonly property alias bodyFlickable: freeBody

            readonly property real _contentW: Math.max(width, root.tableContentWidth)

            Item {
                id: freeHeaderClip
                width: parent.width
                height: root.headerHeight
                clip: true
                z: 1

                Rectangle {
                    x: -freeBody.contentX
                    width: freeRoot._contentW
                    height: root.headerHeight
                    color: Md3Theme.colorScheme.surfaceContainerLow
                    Row {
                        anchors.fill: parent
                        anchors.leftMargin: 8
                        anchors.rightMargin: 8
                        Item {
                            visible: root.selectionEnabled
                            width: 48
                            height: parent.height
                            Md3Checkbox { anchors.centerIn: parent; tristate: true; checkState: root.headerCheckState }
                            MouseArea {
                                cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                                anchors.fill: parent
                                z: 1
                                onClicked: root.selectPage(root.headerCheckState !== Qt.Checked)
                            }
                        }
                        Repeater {
                            model: root.columns
                            delegate: HeaderCell {
                                required property int index
                                required property var modelData
                                columnIndex: index
                                columnDef: modelData
                                width: root.effectiveWidths[index] || 120
                                height: root.headerHeight
                            }
                        }
                        Item { visible: root.actionsColWidth > 0; width: 48; height: parent.height }
                    }
                    Md3Divider { anchors.bottom: parent.bottom; width: parent.width }
                }
            }

            Flickable {
                id: freeBody
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: freeHeaderClip.bottom
                anchors.bottom: parent.bottom
                contentWidth: freeRoot._contentW
                contentHeight: freeRows.height
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                interactive: !root.loading && (contentWidth > width + 1 || contentHeight > height + 1)
                flickableDirection: {
                    const h = contentWidth > width + 1
                    const v = contentHeight > height + 1
                    if (h && v)
                        return Flickable.HorizontalAndVerticalFlick
                    if (h)
                        return Flickable.HorizontalFlick
                    return Flickable.VerticalFlick
                }
                Column {
                    id: freeRows
                    width: freeRoot._contentW
                    Repeater {
                        model: root.loading ? 0 : root.pageEntries
                        delegate: BodyRow {
                            required property int index
                            required property var modelData
                            width: freeRows.width
                            pageRowIndex: index
                            entry: modelData
                        }
                    }
                }
            }
        }
    }

    Md3Menu {
        id: rowMenu
        modal: true
        Repeater {
            model: root.rowActions
            Md3MenuItem {
                required property var modelData
                text: modelData.text !== undefined ? modelData.text : String(modelData)
                icon: modelData.icon !== undefined ? modelData.icon : ""
                onClicked: {
                    root.rowActionTriggered(root.rowMenuSourceIndex, modelData)
                    rowMenu.dismiss()
                }
            }
        }
    }

    Md3Menu {
        id: columnFilterMenu
        modal: true
        menuWidth: 260

        Item {
            width: parent.width
            height: 52
            Md3TextField {
                anchors.fill: parent
                anchors.margins: 8
                variant: Md3TextField.Outlined
                label: qsTr("Filter")
                text: root.filterMenuSearchText
                onTextChanged: root.filterMenuSearchText = text
            }
        }
        Md3MenuItem {
            text: qsTr("Clear filter")
            icon: "filter_alt_off"
            onClicked: {
                root.setColumnFilterValue(root.filterMenuColumnIndex, "")
                columnFilterMenu.dismiss()
            }
        }
        Md3MenuDivider {}
        Repeater {
            model: root._columnFilterValues()
            Md3MenuItem {
                required property var modelData
                text: String(modelData)
                onClicked: {
                    root.setColumnFilterValue(root.filterMenuColumnIndex, modelData)
                    columnFilterMenu.dismiss()
                }
            }
        }
    }
}
