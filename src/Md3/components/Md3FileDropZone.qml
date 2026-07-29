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

    // Own surface — avoid nesting fill-anchored content inside Md3Card bodySlot.
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

        Md3StateOverlay {
            visible: root.clickable
            anchors.fill: parent
            radius: surface.radius
            overlayColor: Md3Theme.colorScheme.colorOnSurface
            hovered: clickArea.containsMouse
            pressed: clickArea.pressed
            controlEnabled: root.enabled && root.clickable
        }

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

            Md3Text {
                width: parent.width
                text: root.title
                role: Md3Text.TitleMedium
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
            }

            Md3Text {
                width: parent.width
                text: root.dragActive ? qsTr("Release to import") : root.subtitle
                role: Md3Text.BodyMedium
                tone: root.dragActive ? Md3Text.Primary : Md3Text.OnSurfaceVariant
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
            }

            Md3Text {
                width: parent.width
                text: root.summaryText
                role: Md3Text.LabelMedium
                tone: Md3Text.OnSurfaceVariant
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideMiddle
            }
        }
    }

    MouseArea {
        id: clickArea
        anchors.fill: parent
        enabled: root.clickable && root.enabled
        hoverEnabled: root.clickable
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: root.clicked()
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
