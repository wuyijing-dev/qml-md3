import QtQuick
import QtQuick.Window

/// Data table: sort, multi-select, sticky header, empty/loading, pagination,
/// column resize, horizontal scroll, row action menu.
Item {
    id: root

    property var columns: [] // [{ title, role, width, minWidth?, sortable? }]
    property var rows: []
    property int selectedRow: -1
    property bool selectionEnabled: false
    property var selectedIndices: []
    property int sortColumn: -1
    property int sortOrder: Qt.AscendingOrder
    property real rowHeight: 52
    property real headerHeight: 56
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
    /// [{ text, icon?, id? }] — trailing ⋮ menu per row
    property var rowActions: []

    signal rowClicked(int sourceIndex)
    signal selectionChanged()
    signal sortChanged(int column, int order)
    signal emptyActionClicked()
    signal pageChanged(int page)
    signal rowActionTriggered(int sourceIndex, var action)

    property var columnWidths: []
    property int rowMenuSourceIndex: -1

    readonly property int totalCount: rows ? rows.length : 0
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
    readonly property real tableContentWidth: {
        let w = selectionColWidth + actionsColWidth + 16
        const widths = effectiveWidths
        for (let i = 0; i < widths.length; ++i)
            w += widths[i]
        return Math.max(w, width)
    }
    readonly property var sortedEntries: {
        const list = []
        const src = root.rows || []
        for (let i = 0; i < src.length; ++i)
            list.push({ row: src[i], sourceIndex: i })
        if (root.sortColumn < 0 || !root.columns || root.sortColumn >= root.columns.length)
            return list
        const col = root.columns[root.sortColumn]
        const role = col && col.role !== undefined ? col.role : ""
        if (!role.length)
            return list
        const asc = root.sortOrder === Qt.AscendingOrder
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
    readonly property int pageCount: {
        if (!pagination || pageSize <= 0)
            return 1
        return Math.max(1, Math.ceil(sortedEntries.length / pageSize))
    }
    readonly property var pageEntries: {
        const all = sortedEntries
        if (!pagination || pageSize <= 0)
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
    implicitHeight: headerHeight + bodyHeight + (pagination ? 48 : 0)
    width: parent ? parent.width : implicitWidth
    height: implicitHeight

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
        const win = Window.window
        const target = (win && win.contentItem) ? win.contentItem : null
        if (!target)
            return
        const p = anchorItem.mapToItem(target, 0, anchorItem.height)
        rowMenu.popup(p.x, p.y)
    }

    onColumnsChanged: _syncWidthsFromColumns()
    Component.onCompleted: _syncWidthsFromColumns()
    onRowsChanged: {
        if (currentPage >= pageCount)
            currentPage = Math.max(0, pageCount - 1)
    }
    onPageSizeChanged: currentPage = 0

    Column {
        id: chrome
        width: parent.width
        spacing: 0

        Item {
            id: tableStack
            width: parent.width
            height: root.headerHeight + root.bodyHeight
            clip: true

            Flickable {
                id: hFlick
                anchors.fill: parent
                contentWidth: Math.max(width, root.tableContentWidth)
                contentHeight: height
                clip: true
                flickableDirection: Flickable.HorizontalFlick
                boundsBehavior: Flickable.StopAtBounds
                interactive: contentWidth > width + 1

                Column {
                    width: Math.max(hFlick.width, root.tableContentWidth)

                    Rectangle {
                        id: headerBar
                        width: parent.width
                        height: root.headerHeight
                        color: Md3Theme.colorScheme.surfaceContainerLow

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
                                model: root.columns
                                delegate: Item {
                                    id: hcell
                                    required property int index
                                    required property var modelData
                                    width: root.effectiveWidths[index] || 120
                                    height: headerBar.height

                                    readonly property bool sortable: modelData.sortable !== false
                                    readonly property bool activeSort: root.sortColumn === index

                                    Text {
                                        anchors.left: parent.left
                                        anchors.leftMargin: 8
                                        anchors.right: parent.right
                                        anchors.rightMargin: hcell.activeSort ? 28 : 12
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: modelData.title !== undefined ? modelData.title : ""
                                        color: Md3Theme.colorScheme.colorOnSurface
                                        font.family: Md3Theme.typography.fontFamily
                                        font.pixelSize: Md3Theme.typography.labelLarge.size
                                        font.weight: Font.Medium
                                        elide: Text.ElideRight
                                    }
                                    Md3Icon {
                                        visible: hcell.activeSort
                                        anchors.right: parent.right
                                        anchors.rightMargin: 10
                                        anchors.verticalCenter: parent.verticalCenter
                                        icon: root.sortOrder === Qt.AscendingOrder ? "arrow_upward" : "arrow_downward"
                                        size: 16
                                        iconColor: Md3Theme.colorScheme.primary
                                    }
                                    MouseArea {
                                        anchors.fill: parent
                                        anchors.rightMargin: 6
                                        enabled: hcell.sortable
                                        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                                        onClicked: root.toggleSort(index)
                                    }
                                    MouseArea {
                                        anchors.right: parent.right
                                        anchors.top: parent.top
                                        anchors.bottom: parent.bottom
                                        width: 6
                                        visible: root.columnResizeEnabled
                                        cursorShape: Qt.SplitHCursor
                                        preventStealing: true
                                        property real startX: 0
                                        property real startW: 0
                                        onPressed: function (mouse) {
                                            startX = mapToItem(headerBar, mouse.x, 0).x
                                            startW = hcell.width
                                        }
                                        onPositionChanged: function (mouse) {
                                            if (!pressed)
                                                return
                                            const x = mapToItem(headerBar, mouse.x, 0).x
                                            root.setColumnWidth(index, startW + (x - startX))
                                        }
                                    }
                                }
                            }

                            Item {
                                visible: root.actionsColWidth > 0
                                width: 48
                                height: parent.height
                            }
                        }

                        Md3Divider {
                            anchors.bottom: parent.bottom
                            width: parent.width
                        }
                    }

                    Flickable {
                        id: bodyFlick
                        width: parent.width
                        height: root.bodyHeight
                        clip: true
                        contentWidth: width
                        contentHeight: rowsCol.height
                        boundsBehavior: Flickable.StopAtBounds
                        interactive: !root.loading && root.pageEntries.length > 0
                        flickableDirection: Flickable.VerticalFlick

                        Column {
                            id: rowsCol
                            width: bodyFlick.width

                            Repeater {
                                model: root.loading ? 0 : root.pageEntries
                                delegate: Rectangle {
                                    id: rowItem
                                    required property int index
                                    required property var modelData
                                    readonly property int sourceIndex: modelData.sourceIndex
                                    readonly property var rowData: modelData.row
                                    readonly property bool checked: root._isSelected(sourceIndex)
                                    readonly property bool highlighted: root.selectedRow === sourceIndex || checked

                                    width: rowsCol.width
                                    height: root.rowHeight
                                    color: highlighted ? Md3Theme.colorScheme.secondaryContainer : "transparent"

                                    Row {
                                        anchors.fill: parent
                                        anchors.leftMargin: 8
                                        anchors.rightMargin: 8

                                        Item {
                                            visible: root.selectionEnabled
                                            width: 48
                                            height: parent.height
                                            Md3Checkbox {
                                                anchors.centerIn: parent
                                                checked: rowItem.checked
                                                onToggled: function (state) {
                                                    root._setSelected(rowItem.sourceIndex, state === Qt.Checked)
                                                }
                                            }
                                        }

                                        Repeater {
                                            model: root.columns
                                            delegate: Text {
                                                required property int index
                                                required property var modelData
                                                width: root.effectiveWidths[index] || 120
                                                anchors.verticalCenter: parent.verticalCenter
                                                leftPadding: 8
                                                text: {
                                                    const role = modelData.role
                                                    const row = rowItem.rowData
                                                    return row && role !== undefined && row[role] !== undefined
                                                           ? String(row[role]) : ""
                                                }
                                                color: Md3Theme.colorScheme.colorOnSurface
                                                font.family: Md3Theme.typography.fontFamily
                                                font.pixelSize: Md3Theme.typography.bodyMedium.size
                                                elide: Text.ElideRight
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
                                                onClicked: root.openRowMenu(rowItem.sourceIndex, moreBtn)
                                            }
                                        }
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        anchors.leftMargin: root.selectionEnabled ? 48 : 0
                                        anchors.rightMargin: root.actionsColWidth
                                        z: -1
                                        onClicked: {
                                            root.selectedRow = rowItem.sourceIndex
                                            root.rowClicked(rowItem.sourceIndex)
                                        }
                                    }

                                    Md3Divider {
                                        anchors.bottom: parent.bottom
                                        width: parent.width
                                    }
                                }
                            }
                        }
                    }
                }
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
                    Md3CircularProgressIndicator {
                        anchors.horizontalCenter: parent.horizontalCenter
                        indeterminate: true
                        size: 40
                    }
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: qsTr("Loading…")
                        color: Md3Theme.colorScheme.colorOnSurfaceVariant
                        font.pixelSize: Md3Theme.typography.bodyMedium.size
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
}
