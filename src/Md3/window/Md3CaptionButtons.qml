import QtQuick
import QtQuick.Window

// Win11 / Electron-style caption buttons (full title-bar height)
Item {
    id: root

    property var targetWindow: null
    property var windowHelper: null
    property bool showMinimize: true
    property bool showMaximize: true
    property bool showClose: true
    property real buttonWidth: 40
    // Match window top-right corner so close hover does not square off the frame
    property real cornerRadius: 0

    readonly property bool maximized: {
        if (!targetWindow)
            return false
        return targetWindow.visibility === Window.Maximized
                || targetWindow.visibility === Window.FullScreen
    }

    readonly property alias maximizeButton: maxBtn

    implicitWidth: row.implicitWidth
    implicitHeight: parent ? parent.height : 48
    height: implicitHeight
    width: implicitWidth
    visible: Md3WindowCapabilities.captionButtons

    function reportMaximizeHitTest() {
        if (!root.targetWindow || !root.windowHelper || !maxBtn.visible)
            return
        const host = root.targetWindow.contentItem
        if (!host)
            return
        const p = maxBtn.mapToItem(host, 0, 0)
        root.windowHelper.setMaximizeButtonRect(root.targetWindow, p.x, p.y, maxBtn.width, maxBtn.height)
    }

    onWidthChanged: reportMaximizeHitTest()
    onHeightChanged: reportMaximizeHitTest()
    onXChanged: reportMaximizeHitTest()
    onYChanged: reportMaximizeHitTest()
    Component.onCompleted: Qt.callLater(reportMaximizeHitTest)
    Component.onDestruction: {
        if (root.windowHelper && root.targetWindow)
            root.windowHelper.clearMaximizeButtonRect(root.targetWindow)
    }

    Connections {
        target: root.targetWindow
        function onWidthChanged() { root.reportMaximizeHitTest() }
        function onHeightChanged() { root.reportMaximizeHitTest() }
        function onVisibilityChanged() { root.reportMaximizeHitTest() }
    }

    Row {
        id: row
        anchors.fill: parent
        spacing: 0

        CaptionButton {
            visible: root.showMinimize
            width: root.buttonWidth
            height: parent.height
            iconName: "remove"
            accessibleName: qsTr("Minimize")
            onClicked: if (root.targetWindow) root.targetWindow.showMinimized()
        }
        CaptionButton {
            id: maxBtn
            visible: root.showMaximize
            width: root.buttonWidth
            height: parent.height
            iconName: root.maximized ? "filter_none" : "crop_square"
            accessibleName: root.maximized ? qsTr("Restore") : qsTr("Maximize")
            // Win11 snap: HTMAXBUTTON owns hover flyout; QML click remains fallback if OS does not claim
            onClicked: {
                if (!root.targetWindow)
                    return
                if (root.maximized)
                    root.targetWindow.showNormal()
                else
                    root.targetWindow.showMaximized()
            }
            onWidthChanged: root.reportMaximizeHitTest()
            onHeightChanged: root.reportMaximizeHitTest()
            onXChanged: root.reportMaximizeHitTest()
            onYChanged: root.reportMaximizeHitTest()
        }
        CaptionButton {
            visible: root.showClose
            width: root.buttonWidth
            height: parent.height
            iconName: "close"
            accessibleName: qsTr("Close")
            destructive: true
            roundTopRight: true
            onClicked: if (root.targetWindow) root.targetWindow.close()
        }
    }

    component CaptionButton: Item {
        id: btn
        property string iconName: ""
        property string accessibleName: ""
        property bool destructive: false
        property bool roundTopRight: false
        signal clicked()

        Accessible.name: accessibleName
        Accessible.role: Accessible.Button
        Accessible.onPressAction: btn.clicked()

        Rectangle {
            anchors.fill: parent
            topRightRadius: btn.roundTopRight ? root.cornerRadius : 0
            color: {
                if (!mouse.containsMouse && !mouse.pressed)
                    return "transparent"
                if (btn.destructive)
                    return mouse.pressed ? "#C42B1C" : "#E81123"
                return Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.colorOnSurface, mouse.pressed ? 0.12 : 0.06)
            }
            Behavior on color {
                ColorAnimation {
                    duration: Md3Motion.short2
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Md3Motion.standard
                }
            }
        }

        Md3Icon {
            anchors.centerIn: parent
            icon: btn.iconName
            size: 10
            iconColor: {
                if (btn.destructive && mouse.containsMouse)
                    return "#FFFFFF"
                return Md3Theme.colorScheme.colorOnSurface
            }
        }

        MouseArea {
            id: mouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            // When snap layouts claim HTMAXBUTTON, OS may swallow events; still wire click for other platforms
            onClicked: btn.clicked()
            onContainsMouseChanged: {
                if (btn === maxBtn)
                    root.reportMaximizeHitTest()
            }
        }
    }
}
