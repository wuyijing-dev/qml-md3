import QtQuick

/// Data table with sort, multi-select, sticky header, empty/loading, and pagination.
Item {
    id: root

    property var columns: [] // [{ title, role, width, sortable? }]
    property var rows: []    // array of objects
    /// Single-row highlight (independent of checkbox selection).
    property int selectedRow: -1
    property bool selectionEnabled: false
    /// Indices into `rows` (source order).
    property var selectedIndices: []
    property int sortColumn: -1
    /// Qt.AscendingOrder / Qt.DescendingOrder
    property int sortOrder: Qt.AscendingOrder
    property bool stickyHeader: true
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

    signal rowClicked(int sourceIndex)
    signal selectionChanged()
    signal sortChanged(int column, int order)
    signal emptyActionClicked()
    signal pageChanged(int page)

    readonly property int totalCount: rows ? rows.length : 0
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
    implicitHeight: headerHeight + bodyHeight
                   + (pagination ? 48 : 0)
    width: parent ? parent.width : implicitWidth
    height: implicitHeight

    function _isSelected(sourceIndex) {
        const sel = selectedIndices || []
        return sel.indexOf(sourceIndex) >= 0
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

    function toggleRowSelection(sourceIndex) {
        _setSelected(sourceIndex, !_isSelected(sourceIndex))
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

    onRowsChanged: {
        if (currentPage >= pageCount)
            currentPage = Math.max(0, pageCount - 1)
    }
    onPageSizeChanged: currentPage = 0
    onPaginationChanged: currentPage = 0

    Column {
        id: chrome
        width: parent.width
        spacing: 0

        // Sticky header
        Rectangle {
            id: headerBar
            width: parent.width
            height: root.headerHeight
            color: Md3Theme.colorScheme.surfaceContainerLow
            z: 2

            Row {
                id: headerRow
                anchors.fill: parent
                anchors.leftMargin: 8
                anchors.rightMargin: 16
                spacing: 0

                Item {
                    visible: root.selectionEnabled
                    width: 48
                    height: parent.height
                    Md3Checkbox {
                        anchors.centerIn: parent
                        tristate: true
                        checkState: root.headerCheckState
                        accessibleName: qsTr("Select page")
                    }
                    MouseArea {
                        anchors.fill: parent
                        z: 1
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.selectPage(root.headerCheckState !== Qt.Checked)
                    }
                }

                Repeater {
                    model: root.columns
                    delegate: Item {
                        id: hcell
                        required property int index
                        required property var modelData
                        width: modelData.width !== undefined ? modelData.width : 120
                        height: headerBar.height

                        readonly property bool sortable: modelData.sortable !== false
                        readonly property bool activeSort: root.sortColumn === index

                        Row {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 8
                            spacing: 4
                            width: parent.width - 8

                            Text {
                                text: modelData.title !== undefined ? modelData.title : ""
                                color: Md3Theme.colorScheme.colorOnSurface
                                font.family: Md3Theme.typography.fontFamily
                                font.pixelSize: Md3Theme.typography.labelLarge.size
                                font.weight: Font.Medium
                                elide: Text.ElideRight
                                width: Math.max(0, parent.width - (hcell.activeSort ? 20 : 0))
                            }
                            Md3Icon {
                                visible: hcell.activeSort
                                icon: root.sortOrder === Qt.AscendingOrder ? "arrow_upward" : "arrow_downward"
                                size: 16
                                iconColor: Md3Theme.colorScheme.primary
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            enabled: hcell.sortable
                            cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                            hoverEnabled: true
                            onClicked: root.toggleSort(index)
                        }
                    }
                }
            }

            Md3Divider {
                anchors.bottom: parent.bottom
                width: parent.width
            }
        }

        // Body
        Item {
            width: parent.width
            height: root.bodyHeight

            Flickable {
                id: bodyFlick
                anchors.fill: parent
                clip: true
                contentWidth: width
                contentHeight: rowsCol.height
                boundsBehavior: Flickable.StopAtBounds
                interactive: !root.loading && pageEntries.length > 0

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
                                anchors.rightMargin: 16

                                Item {
                                    visible: root.selectionEnabled
                                    width: 48
                                    height: parent.height
                                    Md3Checkbox {
                                        anchors.centerIn: parent
                                        checked: rowItem.checked
                                        accessibleName: qsTr("Select row")
                                        onToggled: function (state) {
                                            root._setSelected(rowItem.sourceIndex, state === Qt.Checked)
                                        }
                                    }
                                }

                                Repeater {
                                    model: root.columns
                                    delegate: Text {
                                        required property var modelData
                                        width: modelData.width !== undefined ? modelData.width : 120
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
                            }

                            MouseArea {
                                anchors.fill: parent
                                anchors.leftMargin: root.selectionEnabled ? 48 : 0
                                hoverEnabled: true
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

            // Loading overlay
            Rectangle {
                anchors.fill: parent
                visible: root.loading
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
                        font.family: Md3Theme.typography.fontFamily
                        font.pixelSize: Md3Theme.typography.bodyMedium.size
                    }
                }
            }

            // Empty state
            Md3EmptyState {
                anchors.centerIn: parent
                width: Math.min(parent.width - 24, 360)
                visible: !root.loading && root.totalCount === 0
                icon: root.emptyIcon
                title: root.emptyTitle
                body: root.emptyBody
                actionText: root.emptyActionText
                onActionClicked: root.emptyActionClicked()
            }
        }

        Md3Divider {
            width: parent.width
            visible: root.pagination
        }

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
}
