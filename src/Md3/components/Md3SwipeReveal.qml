import QtQuick
import Md3

/// Swipe-to-reveal trailing actions behind content (WinUI SwipeControl-lite).
Item {
    id: root

    property real actionWidth: 72
    /// [{ icon, label?, color?, destructive? }, ...] revealed on swipe left.
    property var trailingActions: []
    property real openThreshold: 0.4
    property bool interactive: true

    readonly property bool open: Math.abs(panel.x) > 4
    readonly property real revealWidth: trailingActions.length * actionWidth

    signal actionTriggered(int index)
    signal opened()
    signal closed()

    default property alias contentData: panel.data

    clip: true
    implicitWidth: 320
    implicitHeight: Math.max(56, panel.childrenRect.height)

    property bool _wasOpen: false

    function close() { panel.x = 0 }
    function reveal() { panel.x = -revealWidth }

    Row {
        id: actions
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: root.revealWidth
        z: 0

        Repeater {
            model: root.trailingActions
            delegate: Rectangle {
                required property int index
                required property var modelData
                width: root.actionWidth
                height: actions.height
                color: {
                    if (modelData.color !== undefined)
                        return modelData.color
                    if (modelData.destructive)
                        return Md3Theme.colorScheme.error
                    return Md3Theme.colorScheme.primary
                }

                Column {
                    anchors.centerIn: parent
                    spacing: 2
                    Md3Icon {
                        anchors.horizontalCenter: parent.horizontalCenter
                        icon: modelData.icon !== undefined ? modelData.icon : "more_horiz"
                        size: 22
                        iconColor: Md3Theme.colorScheme.colorOnPrimary
                    }
                    Md3Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        visible: modelData.label !== undefined && String(modelData.label).length > 0
                        text: modelData.label !== undefined ? String(modelData.label) : ""
                        role: Md3Text.LabelSmall
                        tone: Md3Text.Custom
                        customColor: Md3Theme.colorScheme.colorOnPrimary
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        root.actionTriggered(index)
                        root.close()
                    }
                }
            }
        }
    }

    Item {
        id: panel
        width: parent.width
        height: parent.height
        x: 0
        z: 1

        Behavior on x {
            id: slideBehavior
            enabled: true
            NumberAnimation {
                duration: Md3Motion.short4
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Md3Motion.emphasized
            }
        }

        onXChanged: {
            if (Math.abs(x) < 1 && root._wasOpen) {
                root._wasOpen = false
                root.closed()
            } else if (Math.abs(x) > 4 && !root._wasOpen) {
                root._wasOpen = true
                root.opened()
            }
        }

        DragHandler {
            id: drag
            enabled: root.interactive && root.revealWidth > 0
            target: null
            xAxis.enabled: true
            yAxis.enabled: false
            property real startX: 0

            onActiveChanged: {
                if (active) {
                    slideBehavior.enabled = false
                    startX = panel.x
                } else {
                    slideBehavior.enabled = true
                    const open = Math.abs(panel.x) > root.revealWidth * root.openThreshold
                    panel.x = open ? -root.revealWidth : 0
                }
            }
            onTranslationChanged: {
                if (!active)
                    return
                panel.x = Math.min(0, Math.max(-root.revealWidth, startX + translation.x))
            }
        }
    }
}
