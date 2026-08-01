import QtQuick
import Md3

Flickable {
    id: root
    contentWidth: width
    contentHeight: column.implicitHeight
    clip: true
    flickableDirection: Flickable.VerticalFlick

    property bool md3PageActive: true

    Md3VStack {
        id: column
        width: root.width
        spacing: 28

        Md3Text {
            text: qsTr("动效")
            role: Md3Text.HeadlineMedium
        }

        Md3Surface {
            width: parent.width
            visible: Md3Theme.reduceMotion
            height: visible ? warnCol.implicitHeight + 24 : 0
            radius: Md3Theme.shape.medium
            elevation: 0
            color: Md3Theme.colorScheme.errorContainer

            Md3VStack {
                id: warnCol
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 12
                spacing: 8
                Md3Text {
                    width: parent.width
                    wrapMode: Text.Wrap
                    text: qsTr("「减弱动效」已开启：所有时长≈1ms，演示会瞬移并可能残影。请到「主题」页关闭。")
                    role: Md3Text.BodyMedium
                    tone: Md3Text.Custom
                    customColor: Md3Theme.colorScheme.colorOnErrorContainer
                }
                Md3Button {
                    text: qsTr("关闭减弱动效")
                    onClicked: Md3Theme.reduceMotion = false
                }
            }
        }

        Md3Text {
            width: parent.width
            wrapMode: Text.Wrap
            text: qsTr("实际 token：medium4=%1ms，short4=%2ms，ripple=%3ms，scale=%4×%5")
                    .arg(Md3Motion.medium4)
                    .arg(Md3Motion.short4)
                    .arg(Md3Motion.rippleDuration)
                    .arg(Md3Motion.durationScale.toFixed(1))
                    .arg(Md3Motion.reduced ? qsTr("（已减弱）") : "")
            role: Md3Text.BodyMedium
            tone: Md3Text.OnSurfaceVariant
        }

        Md3Text {
            text: "emphasized · medium4"
            role: Md3Text.TitleMedium
        }

        Item {
            width: parent.width
            height: 72
            Rectangle {
                id: box
                width: 56
                height: 56
                radius: Md3Theme.shape.medium
                color: Md3Theme.colorScheme.primary
                y: 8
                x: 0

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

        Md3HStack {
            spacing: 24
            Md3Switch { checked: true }
            Md3Switch { }
            Md3Button { text: qsTr("Button ripple") }
            Md3Button { text: qsTr("Outlined"); variant: Md3Button.Outlined }
        }

        Md3GridLayout {
            columns: 4
            spacing: 12
            rowSpacing: 8
            minCellHeight: 36
            width: parent.width

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
                    radius: Md3Theme.shape.extraSmall
                    color: Md3Theme.colorScheme.surfaceContainerHigh
                    Md3Text {
                        anchors.centerIn: parent
                        text: modelData
                        role: Md3Text.LabelSmall
                    }
                }
            }
        }
    }
}
