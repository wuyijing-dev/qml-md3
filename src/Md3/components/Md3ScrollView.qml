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
    /// When true, contentHeight is at least the viewport (old behavior — empty scroll room).
    /// Default false: short content does not create a tall empty flick area.
    property bool minContentHeightToViewport: false
    /// Inset subtracted from content width when ``fillContentWidth`` (e.g. ``scrollBarThickness``
    /// or ``4`` so labels are not clipped under the vertical overlay bar).
    property real verticalScrollbarGutter: 0
    /// Viewport width minus ``verticalScrollbarGutter`` — bind child ``width`` to this in panes.
    readonly property real contentAvailableWidth: Math.max(0, width - verticalScrollbarGutter)
    /// Optional FAB that appears after scrolling down; animates back to top.
    property bool showScrollToTop: false
    property real scrollToTopThreshold: 120

    default property alias content: contentHost.data

    implicitWidth: 320
    implicitHeight: 240

    property real _measuredContentW: 0
    property real _measuredContentH: 0
    property bool _measureGuard: false
    readonly property bool _canScrollToTop: showScrollToTop && flick.contentY > scrollToTopThreshold

    function scrollToTop() {
        if (Md3Theme.reduceMotion) {
            flick.contentY = 0
            return
        }
        scrollTopAnim.stop()
        scrollTopAnim.from = flick.contentY
        scrollTopAnim.to = 0
        scrollTopAnim.start()
    }

    function _syncMeasuredSize() {
        if (_measureGuard)
            return
        _measureGuard = true
        _measuredContentW = Math.max(0, contentHost.childrenRect.width)
        _measuredContentH = Math.max(0, contentHost.childrenRect.height)
        _measureGuard = false
    }

    NumberAnimation {
        id: scrollTopAnim
        target: flick
        property: "contentY"
        duration: Md3Motion.medium2
        easing.type: Easing.BezierSpline
        easing.bezierCurve: Md3Motion.emphasized
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
        contentWidth: root.fillContentWidth
                      ? Math.max(1, width - root.verticalScrollbarGutter)
                      : Math.max(width, root._measuredContentW)
        contentHeight: root.minContentHeightToViewport
                       ? Math.max(height, root._measuredContentH)
                       : Math.max(1, root._measuredContentH)

        Item {
            id: contentHost
            width: root.fillContentWidth
                   ? Math.max(1, flick.width - root.verticalScrollbarGutter)
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

    Md3Fab {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 4
        size: Md3Fab.Small
        colorRole: Md3Fab.Surface
        icon: "keyboard_arrow_up"
        tooltip: qsTr("Back to top")
        shadowPad: 12
        opacity: root._canScrollToTop ? 1 : 0
        visible: root.showScrollToTop && opacity > 0.02
        scale: root._canScrollToTop ? 1 : 0.86
        z: 40
        Accessible.name: qsTr("Scroll to top")
        Behavior on opacity {
            enabled: !Md3Theme.reduceMotion
            NumberAnimation {
                duration: Md3Motion.overlayDuration
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Md3Motion.standard
            }
        }
        Behavior on scale {
            enabled: !Md3Theme.reduceMotion
            NumberAnimation {
                duration: Md3Motion.short3
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Md3Motion.emphasized
            }
        }
        onClicked: root.scrollToTop()
    }
}
