import QtQuick

/// Themed scroll view: Flickable + optional Md3ScrollBar overlays.
Item {
    id: root

    property alias contentWidth: flick.contentWidth
    property alias contentHeight: flick.contentHeight
    property alias contentX: flick.contentX
    property alias contentY: flick.contentY
    property alias flickable: flick
    property alias clip: flick.clip
    property bool interactive: true
    property bool showVerticalScrollBar: true
    property bool showHorizontalScrollBar: true
    property bool scrollBarAutoHide: true
    property real scrollBarThickness: 10
    /// When true (default), content width matches the viewport.
    property bool fillContentWidth: true

    default property alias content: contentHost.data

    implicitWidth: 320
    implicitHeight: 240

    Flickable {
        id: flick
        anchors.fill: parent
        clip: true
        interactive: root.interactive
        boundsBehavior: Flickable.StopAtBounds
        flickableDirection: {
            const h = contentWidth > width + 1
            const v = contentHeight > height + 1
            if (h && v)
                return Flickable.HorizontalAndVerticalFlick
            if (h)
                return Flickable.HorizontalFlick
            return Flickable.VerticalFlick
        }
        contentWidth: root.fillContentWidth ? width : Math.max(width, contentHost.childrenRect.width)
        contentHeight: Math.max(height, contentHost.childrenRect.height)

        Item {
            id: contentHost
            width: flick.width
            height: childrenRect.height
        }
    }

    Md3ScrollBar {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        visible: root.showVerticalScrollBar
        flickable: flick
        orientation: Qt.Vertical
        thickness: root.scrollBarThickness
        autoHide: root.scrollBarAutoHide
    }

    Md3ScrollBar {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        visible: root.showHorizontalScrollBar
        flickable: flick
        orientation: Qt.Horizontal
        thickness: root.scrollBarThickness
        autoHide: root.scrollBarAutoHide
    }
}
