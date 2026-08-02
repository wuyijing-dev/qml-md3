import QtQuick
import Md3

Md3Page {
    id: page

    property var fileTreeModel: [
        {
            title: "Workspace",
            icon: "folder",
            expanded: true,
            checkState: Qt.PartiallyChecked,
            children: [
                {
                    title: "src",
                    icon: "folder",
                    expanded: true,
                    checkState: Qt.Checked,
                    childrenLoaded: true,
                    children: [
                        { title: "main.cpp", icon: "description", kind: "file", path: "D:/QML_MD3/QML_MD3/src/main.cpp", size: "6 KB", modified: "Today 14:12", status: "Active", team: "App" },
                        { title: "CMakeLists.txt", icon: "description", kind: "file", path: "D:/QML_MD3/QML_MD3/src/CMakeLists.txt", size: "3 KB", modified: "Today 13:18", status: "Active", team: "Build" }
                    ]
                },
                {
                    title: "gallery",
                    icon: "folder",
                    expanded: true,
                    checkState: Qt.PartiallyChecked,
                    childrenLoaded: true,
                    children: [
                        { title: "Main.qml", icon: "description", kind: "file", path: "D:/QML_MD3/QML_MD3/gallery/Main.qml", size: "12 KB", modified: "Today 14:31", status: "Active", team: "UI" },
                        { title: "pages", icon: "folder", expanded: false, childrenLoaded: false, lazyStub: true, children: [] }
                    ]
                },
                {
                    title: "resources",
                    icon: "folder",
                    expanded: false,
                    checkState: Qt.Unchecked,
                    childrenLoaded: true,
                    children: [
                        { title: "icons", icon: "image", kind: "folder", path: "D:/QML_MD3/QML_MD3/resources/icons", size: "14 items", modified: "Yesterday", status: "Away", team: "Assets" }
                    ]
                }
            ]
        }
    ]
    property string currentPath: "D:/QML_MD3/QML_MD3"
    property string pendingFolderPath: ""
    property int serverPage: 0
    property int serverPageSize: 6
    property int fakeTotalCount: 24
    property var allRows: []
    property var currentRows: []
    property string currentStatusFilter: ""
    property var _pendingUndo: null

    function galleryWindow() {
        const w = hostWindow()
        return (w && w.galleryTableSelection !== undefined) ? w : null
    }

    function applyStatus(message) {
        const w = galleryWindow()
        if (w) {
            w.galleryTableSelection = fileTable.selectedIndices.length
            w.galleryTableLoading = fileTable.loading
            w.galleryTreeSelection = currentPath.length ? qsTr("Path: %1").arg(currentPath) : ""
            if (message && message.length)
                w.showStatusMessage(message)
        }
    }

    function flattenFiles(nodes, out) {
        if (!nodes)
            return
        for (let i = 0; i < nodes.length; ++i) {
            const n = nodes[i]
            if (!n)
                continue
            if (n.kind === "file")
                out.push({
                    name: n.title,
                    status: n.status || "Active",
                    size: n.size || "",
                    modified: n.modified || "",
                    team: n.team || "",
                    path: n.path || n.title,
                    notes: n.kind === "file" ? qsTr("Editable") : qsTr("Folder")
                })
            if (n.children && n.children.length)
                flattenFiles(n.children, out)
        }
    }

    function collectRowsForNode(node) {
        const out = []
        if (!node)
            return out
        if (node.kind === "file") {
            out.push({
                name: node.title,
                status: node.status || "Active",
                size: node.size || "",
                modified: node.modified || "",
                team: node.team || "",
                path: node.path || node.title,
                notes: qsTr("Single file")
            })
            return out
        }
        flattenFiles(node.children || [], out)
        return out
    }

    function rebuildServerRows() {
        const start = serverPage * serverPageSize
        currentRows = allRows.slice(start, start + serverPageSize)
        fileTable.rows = currentRows
        fileTable.serverTotalCount = allRows.length
        applyStatus("")
    }

    function applyRowDelete(sourceIndex) {
        const globalIndex = serverPage * serverPageSize + sourceIndex
        if (globalIndex < 0 || globalIndex >= allRows.length)
            return
        const removed = allRows[globalIndex]
        const name = removed && removed.name ? removed.name : ("#" + globalIndex)
        const next = allRows.slice()
        next.splice(globalIndex, 1)
        allRows = next
        _pendingUndo = { kind: "delete", row: removed, index: globalIndex, name: name }
        if (currentRows.length <= 1 && serverPage > 0)
            serverPage = Math.max(0, serverPage - 1)
        fileTable.currentPage = serverPage
        rebuildServerRows()
        applyStatus(qsTr("Deleted %1").arg(name))
        Md3Notify.snackbar(qsTr("Deleted “%1”").arg(name), {
            id: "desktop-row-undo",
            actionText: qsTr("Undo"),
            durationMs: 6500
        })
    }

    function applyRowRename(sourceIndex) {
        const globalIndex = serverPage * serverPageSize + sourceIndex
        if (globalIndex < 0 || globalIndex >= allRows.length)
            return
        const row = allRows[globalIndex]
        const oldName = row && row.name ? row.name : ("#" + globalIndex)
        const newName = oldName + qsTr(" (renamed)")
        const next = allRows.slice()
        const copy = Object.assign({}, row, { name: newName })
        next[globalIndex] = copy
        allRows = next
        _pendingUndo = { kind: "rename", row: row, index: globalIndex, name: oldName }
        rebuildServerRows()
        applyStatus(qsTr("Renamed %1 → %2").arg(oldName).arg(newName))
        Md3Notify.snackbar(qsTr("Renamed “%1”").arg(oldName), {
            id: "desktop-row-undo",
            actionText: qsTr("Undo"),
            durationMs: 6500
        })
    }

    function undoPendingRowAction() {
        const u = _pendingUndo
        _pendingUndo = null
        if (!u || !u.row)
            return
        const next = allRows.slice()
        if (u.kind === "delete") {
            const idx = Math.max(0, Math.min(next.length, Number(u.index) || 0))
            next.splice(idx, 0, u.row)
            allRows = next
            applyStatus(qsTr("Restored %1").arg(u.name || u.row.name || ""))
        } else if (u.kind === "rename") {
            const idx = Number(u.index)
            if (idx >= 0 && idx < next.length) {
                next[idx] = u.row
                allRows = next
            }
            applyStatus(qsTr("Undo rename — back to %1").arg(u.name || u.row.name || ""))
        }
        rebuildServerRows()
    }

    Connections {
        target: Md3Notify.host
        function onActionTriggered(snackId, actionText) {
            if (String(snackId) === "desktop-row-undo" && page.md3PageActive)
                page.undoPendingRowAction()
        }
    }

    function selectNode(node) {
        currentPath = node && node.path ? node.path : (node && node.title ? node.title : "D:/QML_MD3/QML_MD3")
        pathField.path = currentPath
        allRows = collectRowsForNode(node)
        serverPage = 0
        fileTable.currentPage = 0
        rebuildServerRows()
    }

    function insertLazyChildren(path, newChildren) {
        function walk(nodes, depth) {
            if (!nodes)
                return false
            const idx = path[depth]
            if (idx < 0 || idx >= nodes.length)
                return false
            const n = nodes[idx]
            if (depth === path.length - 1) {
                n.children = newChildren
                n.childrenLoaded = true
                n.expanded = true
                return true
            }
            return walk(n.children, depth + 1)
        }
        const copy = JSON.parse(JSON.stringify(fileTreeModel))
        if (walk(copy, 0))
            fileTreeModel = copy
    }

    Component.onCompleted: {
        selectNode(fileTreeModel[0])
        pathField.recentPaths = JSON.parse(String(Md3AppSettings.value("desktop/recentPaths", "[]")))
        applyStatus(qsTr("Desktop patterns ready"))
    }

    onMd3PageActiveChanged: {
        if (!md3PageActive) {
            allRows = []
            currentRows = []
            if (fileTable)
                fileTable.rows = []
            return
        }
        if (fileTreeModel && fileTreeModel.length)
            selectNode(fileTreeModel[0])
    }

    Md3VStack {
        anchors.fill: parent
        width: parent.width
        spacing: 12

        Md3Text {
            text: qsTr("Desktop Patterns")
            role: Md3Text.HeadlineMedium
        }
        Md3Text {
            width: parent.width
            wrapMode: Text.Wrap
            text: qsTr("选中行 → StatusBar 提示 → 行操作 Delete/Rename 弹出 Snackbar Undo（可恢复）。")
            role: Md3Text.BodySmall
            tone: Md3Text.OnSurfaceVariant
        }

        Md3Text {
            width: parent.width
            text: qsTr("TreeView + PathField + DataTable + StatusBar wired into a desktop file manager layout.")
            role: Md3Text.BodyMedium
            tone: Md3Text.OnSurfaceVariant
            wrapMode: Text.WordWrap
        }

        Md3HStack {
            width: parent.width
            spacing: 12
            Md3DropDownButton {
                text: qsTr("Pull")
                split: true
                menuModel: [
                    { text: qsTr("Pull (ff-only)") },
                    { text: qsTr("Pull --rebase") }
                ]
                onPrimaryClicked: page.applyStatus(qsTr("Pull ff-only"))
                onMenuItemClicked: function (i) {
                    page.applyStatus(i === 0 ? qsTr("Pull ff-only") : qsTr("Pull rebase"))
                }
            }
            Md3Divider {
                vertical: true
                height: 28
                anchors.verticalCenter: parent.verticalCenter
            }
            Md3EmptyState {
                width: Math.min(280, parent.width * 0.4)
                icon: "folder_off"
                title: qsTr("No selection")
                description: qsTr("description alias works")
                actionText: qsTr("Refresh")
                onActionClicked: page.applyStatus(qsTr("Refresh"))
            }
        }

        Md3PageHeader {
            width: parent.width
            title: qsTr("Workspace tools")
            subtitle: qsTr("Narrow the window to fold trailing actions into overflow")
            Md3Button {
                text: qsTr("Scan")
                onClicked: page.applyStatus(qsTr("Scan started"))
            }
            Md3Button {
                text: qsTr("Stop")
                variant: Md3Button.Outlined
                onClicked: page.applyStatus(qsTr("Scan stopped"))
            }
            Md3Button {
                text: qsTr("Rebuild index")
                variant: Md3Button.Text
                onClicked: page.applyStatus(qsTr("Rebuild index"))
            }
            Md3Button {
                text: qsTr("Clean")
                variant: Md3Button.Text
                onClicked: page.applyStatus(qsTr("Clean"))
            }
            Md3Button {
                text: qsTr("Delete forever")
                variant: Md3Button.Text
                danger: true
                onClicked: page.applyStatus(qsTr("Delete forever"))
            }
        }

        Md3TaskProgress {
            width: parent.width
            active: true
            label: qsTr("Indexing local files…")
            secondaryLabel: qsTr("Cancel stops the worker; UI stays responsive")
            indeterminate: true
            cancelable: true
            onCanceled: page.applyStatus(qsTr("Index canceled"))
        }

        Md3StatusLine {
            width: parent.width
            icon: "database"
            text: qsTr("Local index 24 entries")
            secondaryText: qsTr("Built today · SQL LIMIT pages the table below")
            actionText: qsTr("Details")
            onActionClicked: page.applyStatus(qsTr("Index details"))
        }

        Md3SelectionToolbar {
            width: parent.width
            selectedCount: fileTable.selectedIndices.length
            Md3Button {
                text: qsTr("Clean selected")
                onClicked: page.applyStatus(qsTr("Clean %1 rows").arg(fileTable.selectedIndices.length))
            }
            Md3Button {
                text: qsTr("Clear")
                variant: Md3Button.Text
                onClicked: fileTable.clearSelection()
            }
        }

        Md3HStack {
            width: parent.width
            spacing: 8

            Md3PathField {
                id: pathField
                width: Math.max(0, parent.width - reloadBtn.width - parent.spacing)
                label: qsTr("Current path")
                mode: Md3PathField.Folder
                path: page.currentPath
                showBreadcrumb: true
                rememberRecent: true
                recentStoreKey: "desktop/recentPaths"
                validateExists: true
                validateWritable: true
                existsProbe: function (p) { return String(p).length >= 3 }
                writableProbe: function (p) { return String(p).toLowerCase().indexOf("windows/system32") < 0 }
                pathValidator: function (p) {
                    if (String(p).indexOf("*") >= 0)
                        return { valid: false, message: qsTr("Wildcard path is not allowed") }
                    return { valid: true, message: "" }
                }
                onAccepted: function (p) {
                    currentPath = p
                    applyStatus(qsTr("Navigated to %1").arg(p))
                }
            }

            Md3Button {
                id: reloadBtn
                text: qsTr("Reload")
                variant: Md3Button.Outlined
                onClicked: {
                    fileTable.loading = true
                    applyStatus(qsTr("Refreshing %1").arg(currentPath))
                    reloadTimer.restart()
                }
            }
        }

        Md3SplitView {
            width: parent.width
            height: Math.max(0, page.height - 320)
            splitRatio: 0.32
            minPane1: 240
            minPane2: 320

            Md3Card {
                variant: Md3Card.Outlined
                Item {
                    anchors.fill: parent
                    anchors.margins: 8
                    Md3TreeView {
                        id: treeView
                        anchors.fill: parent
                        showConnectors: true
                        checkEnabled: true
                        triStateCheck: true
                        lazyLoad: true
                        showFilter: true
                        filterLabel: qsTr("Filter tree")
                        filterPlaceholder: qsTr("Search folders or files")
                        model: page.fileTreeModel
                        onActivated: function (flatIndex, node) {
                            page.selectNode(node)
                            page.applyStatus(qsTr("Selected %1").arg(node.title || node.text || ""))
                        }
                        onCheckedChanged: page.applyStatus(qsTr("Tree selection updated"))
                        onFetchChildren: function (node, path) {
                            pendingFolderPath = node && node.title ? node.title : ""
                            lazyPath = path
                            lazyTimer.restart()
                        }
                        contextMenu: treeMenu
                    }
                }
            }

            Md3Card {
                variant: Md3Card.Outlined
                Md3VStack {
                    width: parent.width
                    spacing: 8

                    Md3HStack {
                        id: filesHeader
                        width: parent.width
                        spacing: 8
                        Md3Text {
                            width: Math.max(80, parent.width - densityBtn.width - parent.spacing)
                            text: qsTr("Files in %1").arg(page.currentPath)
                            role: Md3Text.TitleMedium
                            elide: Text.ElideMiddle
                        }
                        Md3Button {
                            id: densityBtn
                            text: fileTable.density === Md3DataTable.Compact ? qsTr("Comfortable") : qsTr("Compact")
                            variant: Md3Button.Text
                            onClicked: fileTable.density = fileTable.density === Md3DataTable.Compact
                                    ? Md3DataTable.Comfortable : Md3DataTable.Compact
                        }
                    }

                    Md3HStack {
                        id: filesFilters
                        width: parent.width
                        spacing: 8
                        Md3TextField {
                            id: statusFilterField
                            width: 200
                            label: qsTr("Status filter")
                            placeholderText: qsTr("Active / Away")
                            text: page.currentStatusFilter
                            onTextChanged: {
                                page.currentStatusFilter = text
                                fileTable.setColumnFilterValue(1, text)
                            }
                        }
                        Md3Button {
                            text: qsTr("Clear filters")
                            variant: Md3Button.Text
                            onClicked: {
                                statusFilterField.text = ""
                                fileTable.clearFilters()
                            }
                        }
                    }

                    Md3DataTable {
                        id: fileTable
                        width: parent.width
                        // Prefer leftover card height; minimum body when card is auto-sized.
                        height: Math.max(280, page.height - 280)
                        selectionEnabled: true
                        pagination: true
                        pageSize: page.serverPageSize
                        bodyHeight: 240
                        showFilterBar: true
                        showColumnFilterIcons: true
                        filterPlaceholder: qsTr("Search files in current folder")
                        frozenColumnCount: 1
                        keyboardNavigationEnabled: true
                        rowReorderEnabled: true
                        autoReorderRows: true
                        serverSidePagination: true
                        rowActions: [
                            { id: "open", text: qsTr("Open"), icon: "folder_open" },
                            { id: "rename", text: qsTr("Rename"), icon: "edit" },
                            { id: "delete", text: qsTr("Delete"), icon: "delete" }
                        ]
                        columns: [
                            { title: qsTr("Name"), role: "name", width: 180 },
                            {
                                title: qsTr("Status"), role: "status", width: 120, filterable: true,
                                type: "chip",
                                chipIconMap: { "Active": "check_circle", "Away": "schedule" }
                            },
                            { title: qsTr("Size"), role: "size", width: 100 },
                            { title: qsTr("Modified"), role: "modified", width: 140 },
                            { title: qsTr("Team"), role: "team", width: 120 },
                            { title: qsTr("Path"), role: "path", width: 280 }
                        ]
                        onPageRequested: function (pageIndex, sortColumn, sortOrder) {
                            page.serverPage = pageIndex
                            loading = true
                            page.applyStatus(qsTr("Loading page %1").arg(pageIndex + 1))
                            pageTimer.restart()
                        }
                        onSelectionChanged: page.applyStatus("")
                        onRowActionTriggered: function (sourceIndex, action) {
                            const id = action && action.id !== undefined ? String(action.id) : ""
                            if (id === "delete") {
                                page.applyRowDelete(sourceIndex)
                                return
                            }
                            if (id === "rename") {
                                page.applyRowRename(sourceIndex)
                                return
                            }
                            page.applyStatus(qsTr("%1 row %2").arg(action.text).arg(sourceIndex))
                        }
                        onRowDoubleClicked: function (sourceIndex) {
                            const row = rows[sourceIndex]
                            page.applyStatus(qsTr("Opened %1").arg(row && row.name ? row.name : sourceIndex))
                        }
                        onRowOrderChanged: function (fromSourceIndex, toSourceIndex) {
                            page.allRows = rows.slice()
                            page.applyStatus(qsTr("Moved row %1 to %2").arg(fromSourceIndex).arg(toSourceIndex))
                        }
                    }
                }
            }
        }
    }

    property var lazyPath: []

    Md3Menu {
        id: treeMenu
        menuWidth: 200

        Md3MenuItem {
            text: qsTr("New file")
            icon: "note_add"
            onClicked: page.applyStatus(qsTr("Create file in %1").arg(page.currentPath))
        }
        Md3MenuItem {
            text: qsTr("Rename")
            icon: "edit"
            onClicked: page.applyStatus(qsTr("Rename %1").arg(page.pendingFolderPath || page.currentPath))
        }
        Md3MenuItem {
            text: qsTr("Delete")
            icon: "delete"
            onClicked: page.applyStatus(qsTr("Delete request for %1").arg(page.pendingFolderPath || page.currentPath))
        }
    }

    Timer {
        id: reloadTimer
        interval: 700
        onTriggered: {
            if (!page.md3PageActive)
                return
            fileTable.loading = false
            applyStatus(qsTr("Refresh finished"))
        }
    }

    Timer {
        id: pageTimer
        interval: 600
        onTriggered: {
            if (!page.md3PageActive)
                return
            fileTable.loading = false
            rebuildServerRows()
            applyStatus(qsTr("Loaded page %1").arg(serverPage + 1))
        }
    }

    Timer {
        id: lazyTimer
        interval: 500
        onTriggered: {
            if (!page.md3PageActive)
                return
            insertLazyChildren(lazyPath, [
                { title: "DesktopPatternsPage.qml", icon: "description", kind: "file", path: "D:/QML_MD3/QML_MD3/gallery/pages/DesktopPatternsPage.qml", size: "15 KB", modified: "Today 14:47", status: "Active", team: "UI" },
                { title: "ExtrasPage.qml", icon: "description", kind: "file", path: "D:/QML_MD3/QML_MD3/gallery/pages/ExtrasPage.qml", size: "18 KB", modified: "Today 14:30", status: "Away", team: "UI" }
            ])
            applyStatus(qsTr("Loaded children for %1").arg(pendingFolderPath))
        }
    }
}
