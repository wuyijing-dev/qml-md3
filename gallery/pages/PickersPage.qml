import QtQuick
import Md3

Md3Page {
    id: page

    Flickable {
        id: flick
        anchors.fill: parent
        contentWidth: width
        contentHeight: column.implicitHeight
        clip: true

        Md3VStack {
            id: column
            width: flick.width
            spacing: 20

            Md3Text {
                text: qsTr("Pickers")
                role: Md3Text.HeadlineMedium
            }

            Md3Text {
                text: qsTr("Docked date field")
                role: Md3Text.LabelLarge
                tone: Md3Text.OnSurfaceVariant
            }
            Md3DateField {
                width: Math.min(parent.width, 320)
                label: qsTr("Birthday")
                supportingText: qsTr("Tap calendar icon · min 2000-01-01")
                minimumDate: new Date(2000, 0, 1)
                maximumDate: new Date()
                onAccepted: function (d) {
                    console.log("docked", d)
                }
            }

            Md3Text {
                text: qsTr("Inline date picker")
                role: Md3Text.LabelLarge
                tone: Md3Text.OnSurfaceVariant
            }
            Md3DatePicker {
                id: inlinePicker
                weekStartsOn: 1
                minimumDate: new Date(2020, 0, 1)
                maximumDate: new Date(2030, 11, 31)
                onAccepted: function (d) { console.log("date", d) }
            }

            Md3Button {
                text: qsTr("Open modal date picker")
                variant: Md3Button.FilledTonal
                onClicked: modalPicker.open = true
            }

            Md3Text {
                text: qsTr("Date range")
                role: Md3Text.LabelLarge
                tone: Md3Text.OnSurfaceVariant
            }
            Md3DateRangePicker {
                weekStartsOn: 1
                onAccepted: function (a, b) { console.log("range", a, b) }
            }

            Md3Text {
                text: qsTr("Time")
                role: Md3Text.LabelLarge
                tone: Md3Text.OnSurfaceVariant
            }
            Md3TimeField {
                width: 200
                label: qsTr("Start time")
                hour: 10
                minute: 30
                supportingText: qsTr("Docked field — peer of Md3DateField")
                onAccepted: function (h, m) { console.log("time field", h, m) }
            }
            Md3TimePicker {
                id: timePicker
                hour: 14
                minute: 0
                onAccepted: function (h, m) { console.log("time", h, m) }
            }

            Md3Button {
                text: qsTr("Open modal time picker")
                variant: Md3Button.Outlined
                onClicked: modalTime.open = true
            }

            Item { width: parent.width; height: 48 }
        }
    }

    Md3DatePicker {
        id: modalPicker
        anchors.fill: parent
        modal: true
        open: false
        title: qsTr("Select date")
        z: 2000
        onAccepted: function (d) { console.log("modal", d) }
    }

    Md3TimePicker {
        id: modalTime
        anchors.fill: parent
        modal: true
        open: false
        title: qsTr("Select time")
        z: 2001
        onAccepted: function (h, m) { console.log("modal time", h, m) }
    }
}
