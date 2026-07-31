import QtQuick
import QtQuick.Window
import Md3

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

    // Report the whole strip so native resize edges leave these pixels as HTCLIENT.
    // Do not map the maximize cell to HTMAXBUTTON — that blocks QML hover/cursor/click.
    function reportCaptionButtonsHitTest() {
        if (!root.targetWindow || !root.windowHelper || !root.visible)
            return
        const host = root.targetWindow.contentItem
        if (!host)
            return
        const p = root.mapToItem(host, 0, 0)
        root.windowHelper.setMaximizeButtonRect(root.targetWindow, p.x, p.y, root.width, root.height)
    }

    onWidthChanged: reportCaptionButtonsHitTest()
    onHeightChanged: reportCaptionButtonsHitTest()
    onXChanged: reportCaptionButtonsHitTest()
    onYChanged: reportCaptionButtonsHitTest()
    onVisibleChanged: reportCaptionButtonsHitTest()
    Component.onCompleted: Qt.callLater(reportCaptionButtonsHitTest)
    Component.onDestruction: {
        if (root.windowHelper && root.targetWindow)
            root.windowHelper.clearMaximizeButtonRect(root.targetWindow)
    }

    Connections {
        target: root.targetWindow
        function onWidthChanged() { root.reportCaptionButtonsHitTest() }
        function onHeightChanged() { root.reportCaptionButtonsHitTest() }
        function onVisibilityChanged() { root.reportCaptionButtonsHitTest() }
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
            onClicked: {
                if (!root.targetWindow)
                    return
                if (root.maximized)
                    root.targetWindow.showNormal()
                else
                    root.targetWindow.showMaximized()
            }
            onWidthChanged: root.reportCaptionButtonsHitTest()
            onHeightChanged: root.reportCaptionButtonsHitTest()
            onXChanged: root.reportCaptionButtonsHitTest()
            onYChanged: root.reportCaptionButtonsHitTest()
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
            onClicked: btn.clicked()
        }
    }
}
