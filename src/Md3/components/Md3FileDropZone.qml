import QtQuick

/// Desktop file drop target with preview, extension filtering, and structured results.
Item {
    id: root

    property string title: qsTr("Drop files here")
    property string subtitle: qsTr("Drag files from Explorer/Finder")
    property string emptyHint: qsTr("or click to browse")
    property var acceptedExtensions: [] // [".zip", ".qml"]
    property bool allowMultiple: true
    // Use Item.enabled (do not redeclare)
    property bool clickable: false
    property bool dragActive: dropArea.containsDrag
    property var droppedPaths: []
    property var droppedUrls: []
    property var droppedItems: [] // [{ path, url, extension }]
    property string leadingIcon: "upload_file"

    signal filesDropped(var items)
    signal clicked()

    implicitWidth: 320
    implicitHeight: 180

    readonly property string summaryText: {
        if (!droppedItems || droppedItems.length === 0)
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

    function _applyUrls(urls) {
        const paths = []
        const items = []
        for (let i = 0; i < urls.length; ++i) {
            const path = _urlToLocal(urls[i])
            if (!_acceptPath(path))
                continue
            paths.push(path)
            items.push({
                path: path,
                url: String(urls[i]),
                extension: _extensionFor(path)
            })
            if (!allowMultiple)
                break
        }
        droppedUrls = urls
        droppedPaths = paths
        droppedItems = items
        filesDropped(items)
    }

    Md3Card {
        anchors.fill: parent
        variant: Md3Card.Outlined
        clickable: root.clickable
        onClicked: root.clicked()

        Rectangle {
            anchors.fill: parent
            radius: Md3Theme.shape.medium
            color: root.dragActive
                   ? Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.primary, 0.10)
                   : "transparent"
            border.width: root.dragActive ? 2 : 1
            border.color: root.dragActive
                          ? Md3Theme.colorScheme.primary
                          : Md3Theme.colorScheme.outlineVariant
            border.pixelAligned: true
            anchors.margins: 1

            Column {
                anchors.centerIn: parent
                width: parent.width - 24
                spacing: 10

                Md3Icon {
                    anchors.horizontalCenter: parent.horizontalCenter
                    icon: root.leadingIcon
                    size: 32
                    iconColor: root.dragActive
                               ? Md3Theme.colorScheme.primary
                               : Md3Theme.colorScheme.colorOnSurfaceVariant
                }

                Text {
                    width: parent.width
                    text: root.title
                    horizontalAlignment: Text.AlignHCenter
                    color: Md3Theme.colorScheme.colorOnSurface
                    font.family: Md3Theme.typography.fontFamily
                    font.pixelSize: Md3Theme.typography.titleMedium.size
                    font.weight: Font.Medium
                    wrapMode: Text.WordWrap
                }

                Text {
                    width: parent.width
                    text: root.dragActive ? qsTr("Release to import") : root.subtitle
                    horizontalAlignment: Text.AlignHCenter
                    color: root.dragActive
                           ? Md3Theme.colorScheme.primary
                           : Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.family: Md3Theme.typography.fontFamily
                    font.pixelSize: Md3Theme.typography.bodyMedium.size
                    wrapMode: Text.WordWrap
                }

                Text {
                    width: parent.width
                    text: root.summaryText
                    horizontalAlignment: Text.AlignHCenter
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.family: Md3Theme.typography.fontFamily
                    font.pixelSize: Md3Theme.typography.labelMedium.size
                    elide: Text.ElideMiddle
                }
            }
        }
    }

    DropArea {
        id: dropArea
        anchors.fill: parent
        enabled: root.enabled
        onDropped: function (drop) {
            if (!drop.hasUrls || !drop.urls.length)
                return
            root._applyUrls(drop.urls)
            drop.acceptProposedAction()
        }
    }
}

