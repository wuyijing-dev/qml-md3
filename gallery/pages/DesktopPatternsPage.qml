import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import Md3

Item {
    id: page

    property var md3HostWindow: null

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

    function galleryWindow() {
        if (typeof md3HostWindow !== "undefined" && md3HostWindow
                && md3HostWindow.galleryTableSelection !== undefined)
            return md3HostWindow
        const w = Window.window
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

    ColumnLayout {
        anchors.fill: parent
        spacing: 12

        Text {
            text: qsTr("Desktop Patterns")
            color: Md3Theme.colorScheme.colorOnSurface
            font.pixelSize: Md3Theme.typography.headlineMedium.size
        }

        Text {
            Layout.fillWidth: true
            text: qsTr("TreeView + PathField + DataTable + StatusBar wired into a desktop file manager layout.")
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            wrapMode: Text.WordWrap
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Md3PathField {
                id: pathField
                Layout.fillWidth: true
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
                text: qsTr("Reload")
                variant: Md3Button.Outlined
                onClicked: {
                    fileTable.loading = true
                    applyStatus(qsTr("Refreshing %1").arg(currentPath))
                    reloadTimer.restart()
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 12

            Md3Card {
                variant: Md3Card.Outlined
                Layout.preferredWidth: 300
                Layout.fillHeight: true

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 8

                    Md3TreeView {
                        id: treeView
                        Layout.fillWidth: true
                        Layout.fillHeight: true
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
                Layout.fillWidth: true
                Layout.fillHeight: true

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 8

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        Text {
                            Layout.fillWidth: true
                            text: qsTr("Files in %1").arg(page.currentPath)
                            color: Md3Theme.colorScheme.colorOnSurface
                            font.pixelSize: Md3Theme.typography.titleMedium.size
                            elide: Text.ElideMiddle
                        }

                        Md3Button {
                            text: fileTable.density === Md3DataTable.Compact ? qsTr("Comfortable") : qsTr("Compact")
                            variant: Md3Button.Text
                            onClicked: fileTable.density = fileTable.density === Md3DataTable.Compact
                                    ? Md3DataTable.Comfortable : Md3DataTable.Compact
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        Md3TextField {
                            id: statusFilterField
                            Layout.preferredWidth: 200
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
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        selectionEnabled: true
                        pagination: true
                        pageSize: page.serverPageSize
                        bodyHeight: Math.max(240, page.height - 260)
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
            fileTable.loading = false
            applyStatus(qsTr("Refresh finished"))
        }
    }

    Timer {
        id: pageTimer
        interval: 600
        onTriggered: {
            fileTable.loading = false
            rebuildServerRows()
            applyStatus(qsTr("Loaded page %1").arg(serverPage + 1))
        }
    }

    Timer {
        id: lazyTimer
        interval: 500
        onTriggered: {
            insertLazyChildren(lazyPath, [
                { title: "DesktopPatternsPage.qml", icon: "description", kind: "file", path: "D:/QML_MD3/QML_MD3/gallery/pages/DesktopPatternsPage.qml", size: "15 KB", modified: "Today 14:47", status: "Active", team: "UI" },
                { title: "ExtrasPage.qml", icon: "description", kind: "file", path: "D:/QML_MD3/QML_MD3/gallery/pages/ExtrasPage.qml", size: "18 KB", modified: "Today 14:30", status: "Away", team: "UI" }
            ])
            applyStatus(qsTr("Loaded children for %1").arg(pendingFolderPath))
        }
    }
}
