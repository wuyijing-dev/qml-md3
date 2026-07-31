import QtQuick
import Md3

Flickable {
    id: root
    contentWidth: width
    contentHeight: column.implicitHeight
    clip: true

    Md3VStack {
        id: column
        width: root.width
        spacing: 20

        Md3Text {
            text: qsTr("Selection")
            role: Md3Text.HeadlineMedium
        }

        Md3HStack {
            spacing: 8
            Md3Checkbox { text: qsTr("Checked"); checked: true }
            Md3Checkbox { text: qsTr("Unchecked") }
            Md3Checkbox { text: qsTr("Partial"); tristate: true; checkState: Qt.PartiallyChecked }
            Md3Checkbox { text: qsTr("Disabled"); enabled: false; checked: true }
        }

        Md3RadioGroup {
            value: "a"
            model: [
                { text: qsTr("Option A"), value: "a" },
                { text: qsTr("Option B"), value: "b" },
                { text: qsTr("Option C"), value: "c", enabled: false }
            ]
        }

        Md3HStack {
            spacing: 16
            Md3Switch { text: qsTr("Off") }
            Md3Switch { text: qsTr("On"); checked: true }
            Md3Switch { text: qsTr("Icons"); checked: true; showIcon: true }
            Md3Switch { text: qsTr("Disabled"); enabled: false; checked: true }
        }

        Md3Text {
            text: qsTr("Sliders (Material 3 capsule)")
            role: Md3Text.TitleSmall
            tone: Md3Text.OnSurfaceVariant
        }

        Md3Slider {
            width: parent.width
            leadingIcon: "call"
            label: qsTr("Call volume")
            from: 0; to: 100; value: 75
            trackHeight: 20
            handleWidth: 10
        }
        Md3Slider {
            width: parent.width
            leadingIcon: "alarm"
            label: qsTr("Alarm volume")
            from: 0; to: 100; value: 75; stepSize: 10; discrete: true
            trackHeight: 20
            handleWidth: 10
        }
        Md3Slider {
            width: parent.width
            leadingIcon: "notifications"
            label: qsTr("Ring volume")
            from: 0; to: 100; value: 25
            trackHeight: 20
            handleWidth: 10
        }
        Md3Slider {
            width: parent.width
            leadingIcon: "music_note"
            label: qsTr("Media volume")
            from: 0; to: 100; value: 28
            trackHeight: 20
            handleWidth: 10
        }

        Md3Slider {
            width: parent.width
            label: qsTr("Discrete with bubble")
            showValue: true
            from: 0
            to: 100
            value: 35
            stepSize: 1
            showLabel: true
            discrete: true
        }

        Md3RangeSlider {
            width: parent.width
            label: qsTr("Price range")
            showValue: true
            from: 0
            to: 100
            firstValue: 20
            secondValue: 70
            stepSize: 1
        }
    }
}
