import QtQuick
import QtQuick.Layouts
import Md3

Flickable {
    id: root
    contentWidth: width
    contentHeight: column.height
    clip: true
    flickableDirection: Flickable.VerticalFlick

    ColumnLayout {
        id: column
        width: root.width
        spacing: 28

        Text {
            text: qsTr("动效")
            color: Md3Theme.colorScheme.colorOnSurface
            font.pixelSize: Md3Theme.typography.headlineMedium.size
            font.family: Md3Theme.typography.fontFamily
        }

        Rectangle {
            Layout.fillWidth: true
            visible: Md3Theme.reduceMotion
            height: visible ? warnCol.implicitHeight + 24 : 0
            radius: Md3Theme.shape.medium
            color: Md3Theme.colorScheme.errorContainer

            Column {
                id: warnCol
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 12
                spacing: 8
                Text {
                    width: parent.width
                    wrapMode: Text.Wrap
                    text: qsTr("「减弱动效」已开启：所有时长≈1ms，演示会瞬移并可能残影。请到「主题」页关闭。")
                    color: Md3Theme.colorScheme.colorOnErrorContainer
                    font.family: Md3Theme.typography.fontFamily
                    font.pixelSize: Md3Theme.typography.bodyMedium.size
                }
                Md3Button {
                    text: qsTr("关闭减弱动效")
                    onClicked: Md3Theme.reduceMotion = false
                }
            }
        }

        Text {
            Layout.fillWidth: true
            wrapMode: Text.Wrap
            text: qsTr("实际 token：medium4=%1ms，short4=%2ms，ripple=%3ms，scale=%4×%5")
                    .arg(Md3Motion.medium4)
                    .arg(Md3Motion.short4)
                    .arg(Md3Motion.rippleDuration)
                    .arg(Md3Motion.durationScale.toFixed(1))
                    .arg(Md3Motion.reduced ? qsTr("（已减弱）") : "")
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.bodyMedium.size
            font.family: Md3Theme.typography.fontFamily
        }

        Text {
            text: "emphasized · medium4"
            color: Md3Theme.colorScheme.colorOnSurface
            font.pixelSize: Md3Theme.typography.titleMedium.size
            font.family: Md3Theme.typography.fontFamily
            font.weight: Font.Medium
        }

        Item {
            Layout.fillWidth: true
            height: 72
            Rectangle {
                id: box
                width: 56
                height: 56
                radius: Md3Theme.shape.medium
                color: Md3Theme.colorScheme.primary
                y: 8
                x: 0

                // Restart when durations / reduceMotion change so we don't keep a 1ms loop.
                SequentialAnimation on x {
                    id: boxAnim
                    loops: Animation.Infinite
                    running: root.visible && !Md3Theme.reduceMotion
                    NumberAnimation {
                        to: Math.max(0, root.width - 80)
                        duration: Md3Motion.medium4
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Md3Motion.emphasized
                    }
                    PauseAnimation { duration: Md3Motion.short4 }
                    NumberAnimation {
                        to: 0
                        duration: Md3Motion.medium4
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Md3Motion.emphasized
                    }
                    PauseAnimation { duration: Md3Motion.short4 }
                }

                Connections {
                    target: Md3Theme
                    function onReduceMotionChanged() {
                        box.x = 0
                        if (!Md3Theme.reduceMotion)
                            boxAnim.restart()
                        else
                            boxAnim.stop()
                    }
                }
            }
        }

        RowLayout {
            spacing: 24
            Md3Switch { checked: true }
            Md3Switch { }
            Md3Button { text: qsTr("Button ripple") }
            Md3Button { text: qsTr("Outlined"); variant: Md3Button.Outlined }
        }

        GridLayout {
            columns: 4
            columnSpacing: 12
            rowSpacing: 8
            Layout.fillWidth: true
            Repeater {
                model: [
                    "short2=" + Md3Motion.short2,
                    "short3=" + Md3Motion.short3,
                    "short4=" + Md3Motion.short4,
                    "medium2=" + Md3Motion.medium2,
                    "medium3=" + Md3Motion.medium3,
                    "medium4=" + Md3Motion.medium4,
                    "ripple=" + Md3Motion.rippleDuration,
                    "state=" + Md3Motion.stateDuration
                ]
                delegate: Rectangle {
                    required property string modelData
                    Layout.preferredWidth: 120
                    Layout.preferredHeight: 36
                    radius: Md3Theme.shape.extraSmall
                    color: Md3Theme.colorScheme.surfaceContainerHigh
                    Text {
                        anchors.centerIn: parent
                        text: modelData
                        color: Md3Theme.colorScheme.colorOnSurface
                        font.pixelSize: 12
                        font.family: Md3Theme.typography.fontFamily
                    }
                }
            }
        }
    }
}
