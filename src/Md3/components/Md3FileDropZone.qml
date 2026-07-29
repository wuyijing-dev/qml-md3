import QtQuick
import QtQuick.Dialogs

/// Desktop file drop target with scrollable table preview of dropped files.
Item {
    id: root

    property string title: qsTr("Drop files here")
    property string subtitle: qsTr("Drag files from Explorer/Finder")
    property string emptyHint: qsTr("or click to browse")
    property var acceptedExtensions: [] // [".zip", ".qml"]
    property bool allowMultiple: true
    property bool clickable: true
    property bool dragActive: dropArea.containsDrag
    property var droppedPaths: []
    property var droppedUrls: []
    property var droppedItems: [] // [{ name, path, url, extension }]
    property string leadingIcon: "upload_file"
    property bool showTable: true
    property real tableBodyHeight: 168
    property real rowHeight: 44
    property bool appendOnDrop: true

    signal filesDropped(var items)
    signal itemRemoved(int index, var item)
    signal clicked()

    implicitWidth: 360
    implicitHeight: hasFiles && showTable ? (52 + 36 + tableBodyHeight + 24) : 180

    readonly property bool hasFiles: droppedItems && droppedItems.length > 0
    readonly property string summaryText: {
        if (!hasFiles)
            return emptyHint
        if (droppedItems.length === 1)
            return droppedItems[0].path
        return qsTr("%1 files").arg(droppedItems.length)
    }

    function _urlToLocal(u) {
        let p = u ? u.toString() : ""
        if (p.indexOf("file:///") === 0) {
            p = p.substring(8)
            if (Qt.platform.os === "windows" || Qt.platform.os === "winrt")
                return decodeURIComponent(p)
            return "/" + decodeURIComponent(p)
        }
        if (p.indexOf("file://") === 0)
            return decodeURIComponent(p.substring(7))
        return p
    }

    function _fileName(path) {
        const p = String(path || "").replace(/\\/g, "/")
        const idx = p.lastIndexOf("/")
        return idx >= 0 ? p.substring(idx + 1) : p
    }

    function _extensionFor(path) {
        const p = String(path || "")
        const idx = p.lastIndexOf(".")
        return idx >= 0 ? p.substring(idx).toLowerCase() : ""
    }

    function _acceptPath(path) {
        if (!acceptedExtensions || acceptedExtensions.length === 0)
            return true
        const ext = _extensionFor(path)
        for (let i = 0; i < acceptedExtensions.length; ++i) {
            if (String(acceptedExtensions[i]).toLowerCase() === ext)
                return true
        }
        return false
    }

    function clear() {
        droppedPaths = []
        droppedUrls = []
        droppedItems = []
    }

    function removeAt(index) {
        if (index < 0 || index >= droppedItems.length)
            return
        const removed = droppedItems[index]
        const nextItems = droppedItems.slice()
        nextItems.splice(index, 1)
        const nextPaths = []
        const nextUrls = []
        for (let i = 0; i < nextItems.length; ++i) {
            nextPaths.push(nextItems[i].path)
            nextUrls.push(nextItems[i].url)
        }
        droppedItems = nextItems
        droppedPaths = nextPaths
        droppedUrls = nextUrls
        itemRemoved(index, removed)
    }

    function _applyUrls(urls) {
        const paths = appendOnDrop && allowMultiple ? droppedPaths.slice() : []
        const items = appendOnDrop && allowMultiple ? droppedItems.slice() : []
        const urlList = appendOnDrop && allowMultiple ? droppedUrls.slice() : []
        const seen = {}
        for (let i = 0; i < paths.length; ++i)
            seen[String(paths[i]).toLowerCase()] = true

        const added = []
        for (let i = 0; i < urls.length; ++i) {
            const path = _urlToLocal(urls[i])
            if (!_acceptPath(path))
                continue
            const key = String(path).toLowerCase()
            if (seen[key])
                continue
            seen[key] = true
            const item = {
                name: _fileName(path),
                path: path,
                url: String(urls[i]),
                extension: _extensionFor(path)
            }
            paths.push(path)
            urlList.push(String(urls[i]))
            items.push(item)
            added.push(item)
            if (!allowMultiple)
                break
        }
        droppedUrls = urlList
        droppedPaths = paths
        droppedItems = items
        if (added.length > 0)
            filesDropped(added)
    }

    function _openBrowse() {
        if (!root.clickable || !root.enabled)
            return
        browseDialog.open()
    }

    Rectangle {
        id: surface
        anchors.fill: parent
        radius: Md3Theme.shape.medium
        color: root.dragActive
               ? Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.primary, 0.10)
               : Md3Theme.colorScheme.surface
        border.width: root.dragActive ? 2 : 1
        border.color: root.dragActive
                      ? Md3Theme.colorScheme.primary
                      : Md3Theme.colorScheme.outlineVariant
        border.pixelAligned: true
        clip: true

        Column {
            visible: !root.hasFiles || root.dragActive
            anchors.centerIn: parent
            width: parent.width - 24
            spacing: 10
            z: 1

            Md3Icon {
                anchors.horizontalCenter: parent.horizontalCenter
                icon: root.leadingIcon
                size: 32
                iconColor: root.dragActive
                           ? Md3Theme.colorScheme.primary
                           : Md3Theme.colorScheme.colorOnSurfaceVariant
            }

            Md3Text {
                width: parent.width
                text: root.dragActive ? qsTr("Release to import") : root.title
                role: Md3Text.TitleMedium
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
            }

            Md3Text {
                width: parent.width
                text: root.dragActive ? qsTr("Files will be added to the list") : root.subtitle
                role: Md3Text.BodyMedium
                tone: root.dragActive ? Md3Text.Primary : Md3Text.OnSurfaceVariant
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
            }

            Md3Text {
                width: parent.width
                visible: !root.hasFiles
                text: root.emptyHint
                role: Md3Text.LabelMedium
                tone: Md3Text.OnSurfaceVariant
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideMiddle
            }
        }

        Column {
            id: filledCol
            visible: root.hasFiles && root.showTable && !root.dragActive
            anchors.fill: parent
            anchors.margins: 12
            spacing: 8

            Row {
                width: parent.width
                spacing: 8
                height: 36

                Md3Icon {
                    anchors.verticalCenter: parent.verticalCenter
                    icon: "folder_open"
                    size: 20
                    iconColor: Md3Theme.colorScheme.primary
                }

                Md3Text {
                    anchors.verticalCenter: parent.verticalCenter
                    width: Math.max(40, parent.width - 168)
                    text: qsTr("%1 file(s)").arg(root.droppedItems.length)
                    role: Md3Text.TitleSmall
                    elide: Text.ElideRight
                }

                Md3Button {
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("Add")
                    variant: Md3Button.Text
                    visible: root.clickable
                    onClicked: root._openBrowse()
                }

                Md3Button {
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("Clear")
                    variant: Md3Button.Text
                    onClicked: root.clear()
                }
            }

            // Table header
            Rectangle {
                width: parent.width
                height: 36
                radius: Md3Theme.shape.extraSmall
                color: Md3Theme.colorScheme.surfaceContainerHighest

                Row {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 8
                    spacing: 8

                    Md3Text {
                        width: Math.max(80, parent.width * 0.28)
                        anchors.verticalCenter: parent.verticalCenter
                        text: qsTr("Name")
                        role: Md3Text.LabelMedium
                        tone: Md3Text.OnSurfaceVariant
                        elide: Text.ElideRight
                    }
                    Md3Text {
                        width: 64
                        anchors.verticalCenter: parent.verticalCenter
                        text: qsTr("Type")
                        role: Md3Text.LabelMedium
                        tone: Md3Text.OnSurfaceVariant
                    }
                    Md3Text {
                        width: Math.max(80, parent.width - 80 - 64 - 40 - 24)
                        anchors.verticalCenter: parent.verticalCenter
                        text: qsTr("Path")
                        role: Md3Text.LabelMedium
                        tone: Md3Text.OnSurfaceVariant
                        elide: Text.ElideRight
                    }
                    Item { width: 32; height: 1 }
                }
            }

            // Scrollable table body
            Md3ScrollView {
                id: tableScroll
                width: parent.width
                height: Math.max(80, Math.min(root.tableBodyHeight,
                                              root.height - 12 * 2 - 36 - 36 - 8 * 2))
                showHorizontalScrollBar: false

                Column {
                    width: tableScroll.width
                    spacing: 0

                    Repeater {
                        model: root.droppedItems

                        Rectangle {
                            id: rowRoot
                            required property int index
                            required property var modelData

                            width: parent.width
                            height: root.rowHeight
                            color: rowHover.containsMouse
                                   ? Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.colorOnSurface, 0.06)
                                   : "transparent"

                            Row {
                                anchors.fill: parent
                                anchors.leftMargin: 12
                                anchors.rightMargin: 4
                                spacing: 8

                                Md3Text {
                                    width: Math.max(80, parent.width * 0.28)
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: rowRoot.modelData && rowRoot.modelData.name
                                          ? String(rowRoot.modelData.name) : ""
                                    role: Md3Text.BodyMedium
                                    elide: Text.ElideMiddle
                                }
                                Md3Text {
                                    width: 64
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: rowRoot.modelData && rowRoot.modelData.extension
                                          ? String(rowRoot.modelData.extension) : "—"
                                    role: Md3Text.BodySmall
                                    tone: Md3Text.OnSurfaceVariant
                                }
                                Md3Text {
                                    width: Math.max(40, parent.width - parent.width * 0.28 - 64 - 48 - 24)
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: rowRoot.modelData && rowRoot.modelData.path
                                          ? String(rowRoot.modelData.path) : ""
                                    role: Md3Text.BodySmall
                                    tone: Md3Text.OnSurfaceVariant
                                    elide: Text.ElideMiddle
                                }
                                Md3IconButton {
                                    anchors.verticalCenter: parent.verticalCenter
                                    icon: "close"
                                    accessibleName: qsTr("Remove")
                                    onClicked: root.removeAt(rowRoot.index)
                                }
                            }

                            Md3Divider {
                                anchors.bottom: parent.bottom
                                width: parent.width
                            }

                            MouseArea {
                                id: rowHover
                                anchors.fill: parent
                                hoverEnabled: true
                                acceptedButtons: Qt.NoButton
                            }
                        }
                    }
                }
            }
        }
    }

    DropArea {
        id: dropArea
        anchors.fill: parent
        enabled: root.enabled
        z: 0
        onDropped: function (drop) {
            if (!drop.hasUrls || !drop.urls.length)
                return
            root._applyUrls(drop.urls)
            drop.acceptProposedAction()
        }
    }

    MouseArea {
        anchors.fill: parent
        enabled: root.clickable && root.enabled && !root.hasFiles
        hoverEnabled: root.clickable
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        z: 2
        onClicked: {
            root.clicked()
            root._openBrowse()
        }
    }

    FileDialog {
        id: browseDialog
        title: qsTr("Choose files")
        fileMode: root.allowMultiple ? FileDialog.OpenFiles : FileDialog.OpenFile
        nameFilters: {
            if (!root.acceptedExtensions || root.acceptedExtensions.length === 0)
                return [qsTr("All files (*)")]
            const parts = []
            for (let i = 0; i < root.acceptedExtensions.length; ++i) {
                let e = String(root.acceptedExtensions[i]).toLowerCase()
                if (e.charAt(0) !== ".")
                    e = "." + e
                parts.push("*" + e)
            }
            return [qsTr("Accepted (%1)").arg(parts.join(" ")), qsTr("All files (*)")]
        }
        onAccepted: {
            const files = selectedFiles || []
            const urls = files.length ? files : (selectedFile ? [selectedFile] : [])
            if (urls.length)
                root._applyUrls(urls)
        }
    }
}
