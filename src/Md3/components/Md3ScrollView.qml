import QtQuick
import Md3

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

    property real _measuredContentW: 0
    property real _measuredContentH: 0
    property bool _measureGuard: false

    function _syncMeasuredSize() {
        if (_measureGuard)
            return
        _measureGuard = true
        _measuredContentW = Math.max(0, contentHost.childrenRect.width)
        _measuredContentH = Math.max(0, contentHost.childrenRect.height)
        _measureGuard = false
    }

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
        contentWidth: root.fillContentWidth ? width : Math.max(width, root._measuredContentW)
        contentHeight: Math.max(height, root._measuredContentH)

        Item {
            id: contentHost
            width: root.fillContentWidth ? flick.width
                                         : Math.max(flick.width, root._measuredContentW)
            // Never bind height to childrenRect — polish loop with contentHeight.
            height: Math.max(root._measuredContentH, 1)

            onChildrenChanged: Qt.callLater(root._syncMeasuredSize)
            onChildrenRectChanged: Qt.callLater(root._syncMeasuredSize)
            onWidthChanged: Qt.callLater(root._syncMeasuredSize)
        }
    }

    Component.onCompleted: Qt.callLater(_syncMeasuredSize)

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
