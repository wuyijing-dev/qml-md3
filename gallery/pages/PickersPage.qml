import QtQuick
import QtQuick.Layouts
import Md3

Item {
    id: page

    Flickable {
        id: flick
        anchors.fill: parent
        contentWidth: width
        contentHeight: column.height
        clip: true

        ColumnLayout {
            id: column
            width: flick.width
            spacing: 20

            Text {
                text: qsTr("Pickers")
                color: Md3Theme.colorScheme.colorOnSurface
                font.pixelSize: Md3Theme.typography.headlineMedium.size
            }

            Text {
                text: qsTr("Docked date field")
                color: Md3Theme.colorScheme.colorOnSurfaceVariant
                font.pixelSize: Md3Theme.typography.labelLarge.size
            }
            Md3DateField {
                Layout.maximumWidth: 320
                Layout.fillWidth: true
                label: qsTr("Birthday")
                supportingText: qsTr("Tap calendar icon · min 2000-01-01")
                minimumDate: new Date(2000, 0, 1)
                maximumDate: new Date()
                onAccepted: function (d) {
                    console.log("docked", d)
                }
            }

            Text {
                text: qsTr("Inline date picker")
                color: Md3Theme.colorScheme.colorOnSurfaceVariant
                font.pixelSize: Md3Theme.typography.labelLarge.size
            }
            Md3DatePicker {
                id: inlinePicker
                Layout.alignment: Qt.AlignLeft
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

            Text {
                text: qsTr("Date range")
                color: Md3Theme.colorScheme.colorOnSurfaceVariant
                font.pixelSize: Md3Theme.typography.labelLarge.size
            }
            Md3DateRangePicker {
                Layout.alignment: Qt.AlignLeft
                weekStartsOn: 1
                onAccepted: function (a, b) { console.log("range", a, b) }
            }

            Text {
                text: qsTr("Time")
                color: Md3Theme.colorScheme.colorOnSurfaceVariant
                font.pixelSize: Md3Theme.typography.labelLarge.size
            }
            Md3TimePicker {
                id: timePicker
                Layout.alignment: Qt.AlignLeft
                hour: 10
                minute: 30
                onAccepted: function (h, m) { console.log("time", h, m) }
            }

            Md3Button {
                text: qsTr("Open modal time picker")
                variant: Md3Button.Outlined
                onClicked: modalTime.open = true
            }

            Item { Layout.preferredHeight: 48; Layout.fillWidth: true }
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
