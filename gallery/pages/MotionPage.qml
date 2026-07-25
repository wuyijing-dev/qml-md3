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
            text: "Motion — original pacing"
            color: Md3Theme.colorScheme.colorOnSurface
            font.pixelSize: Md3Theme.typography.headlineMedium.size
            font.family: Md3Theme.typography.fontFamily
        }

        Text {
            Layout.fillWidth: true
            wrapMode: Text.Wrap
            text: "Durations follow Flutter material/motion.dart (short*/medium*). Curves use M3 emphasized / standard. Behavior still retargets if interrupted mid-flight."
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
                SequentialAnimation on x {
                    loops: Animation.Infinite
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
            }
        }

        RowLayout {
            spacing: 24
            Md3Switch { checked: true }
            Md3Switch { }
            Md3Button { text: "Button ripple" }
            Md3Button { text: "Outlined"; variant: Md3Button.Outlined }
        }

        GridLayout {
            columns: 4
            columnSpacing: 12
            rowSpacing: 8
            Layout.fillWidth: true
            Repeater {
                model: [
                    "short2=100", "short3=150", "short4=200",
                    "medium2=300", "medium3=350", "medium4=400",
                    "ripple=300", "state=100"
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
