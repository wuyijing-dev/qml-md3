import QtQuick
import QtQuick.Layouts
import Md3

Flickable {
    id: root
    contentWidth: width
    contentHeight: column.height
    clip: true

    QtObject {
        id: radioGroup
        property var selectedValue: "a"
    }

    component VolumeRow: ColumnLayout {
        property string iconName: "volume_up"
        property string title: ""
        property alias from: slider.from
        property alias to: slider.to
        property alias value: slider.value
        property alias stepSize: slider.stepSize
        property alias discrete: slider.discrete
        Layout.fillWidth: true
        spacing: 6

        RowLayout {
            spacing: 8
            Md3Icon {
                icon: iconName
                size: 20
                iconColor: Md3Theme.colorScheme.primary
            }
            Text {
                text: title
                color: Md3Theme.colorScheme.colorOnSurface
                font.pixelSize: Md3Theme.typography.bodyMedium.size
                font.family: Md3Theme.typography.fontFamily
                Layout.fillWidth: true
            }
        }
            Md3Slider {
                id: slider
                Layout.fillWidth: true
                trackHeight: 20
                handleWidth: 10
                showStopIndicator: true
            }
    }

    ColumnLayout {
        id: column
        width: root.width
        spacing: 20

        Text {
            text: qsTr("Selection")
            color: Md3Theme.colorScheme.colorOnSurface
            font.pixelSize: Md3Theme.typography.headlineMedium.size
            font.family: Md3Theme.typography.fontFamily
        }

        RowLayout {
            spacing: 8
            Md3Checkbox { checked: true }
            Md3Checkbox { }
            Md3Checkbox { tristate: true; checkState: Qt.PartiallyChecked }
            Md3Checkbox { enabled: false; checked: true }
        }

        RowLayout {
            spacing: 8
            Md3Radio { value: "a"; group: radioGroup; checked: true; accessibleName: "Option A" }
            Md3Radio { value: "b"; group: radioGroup; accessibleName: "Option B" }
            Md3Radio { value: "c"; group: radioGroup; enabled: false; accessibleName: "Option C" }
        }

        RowLayout {
            spacing: 16
            Md3Switch { }
            Md3Switch { checked: true }
            Md3Switch { checked: true; showIcon: true }
            Md3Switch { enabled: false; checked: true }
        }

        Text {
            text: qsTr("Sliders (Material 3 capsule)")
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.titleSmall.size
            font.family: Md3Theme.typography.fontFamily
        }

        VolumeRow {
            iconName: "call"
            title: qsTr("Call volume")
            from: 0; to: 100; value: 75; stepSize: 0
        }
        VolumeRow {
            iconName: "alarm"
            title: qsTr("Alarm volume")
            from: 0; to: 100; value: 75; stepSize: 10; discrete: true
        }
        VolumeRow {
            iconName: "notifications"
            title: qsTr("Ring volume")
            from: 0; to: 100; value: 25; stepSize: 0
        }
        VolumeRow {
            iconName: "music_note"
            title: qsTr("Media volume")
            from: 0; to: 100; value: 28; stepSize: 0
        }

        Md3Slider {
            Layout.fillWidth: true
            from: 0
            to: 100
            value: 35
            stepSize: 1
            showLabel: true
            discrete: true
        }

        Md3RangeSlider {
            Layout.fillWidth: true
            from: 0
            to: 100
            firstValue: 20
            secondValue: 70
            stepSize: 1
        }
    }
}
