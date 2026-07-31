import QtQuick
import Md3

/// Page indicator / WinUI PipsPager — dots or pills bound to a page count.
Item {
    id: root

    enum Style { Dot, Pill }

    property int count: 0
    property int currentIndex: 0
    property int style: Md3PipsPager.Pill
    property real spacing: 8
    property real inactiveSize: 8
    property real activeWidth: 18
    property bool interactive: true

    signal indexRequested(int index)

    implicitWidth: row.implicitWidth
    implicitHeight: Math.max(24, inactiveSize + 8)
    height: implicitHeight
    width: implicitWidth

    Accessible.role: Accessible.PageTabList
    Accessible.name: qsTr("Page indicators")

    function goTo(index) {
        if (index < 0 || index >= count)
            return
        if (currentIndex !== index)
            currentIndex = index
        indexRequested(index)
    }

    Row {
        id: row
        anchors.centerIn: parent
        spacing: root.spacing

        Repeater {
            model: Math.max(0, root.count)
            delegate: Rectangle {
                required property int index
                width: root.style === Md3PipsPager.Pill
                       ? (root.currentIndex === index ? root.activeWidth : root.inactiveSize)
                       : root.inactiveSize
                height: root.inactiveSize
                radius: root.inactiveSize / 2
                color: root.currentIndex === index
                       ? Md3Theme.colorScheme.primary
                       : Md3Theme.colorScheme.outlineVariant

                Behavior on width {
                    NumberAnimation {
                        duration: Md3Motion.spatialSnapDuration
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Md3Motion.emphasized
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -6
                    enabled: root.interactive
                    cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                    onClicked: root.goTo(index)
                }
            }
        }
    }
}
