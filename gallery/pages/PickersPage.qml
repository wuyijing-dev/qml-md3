import QtQuick
import Md3

Md3Page {
    id: page

    property bool modalDateOpen: false
    property bool modalTimeOpen: false

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

            Md3DeferredSection {
                width: parent.width
                preferredHeight: 1100
                delayMs: 24
                asynchronous: true
                sourceComponent: Component {
                    Md3VStack {
                        width: parent ? parent.width : 400
                        spacing: 20

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
                onClicked: page.modalDateOpen = true
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

            Md3Button {
                text: qsTr("Open modal time picker")
                variant: Md3Button.Outlined
                onClicked: page.modalTimeOpen = true
            }
                    }
                }
            }

            Item { width: parent.width; height: 48 }
        }
    }

    Loader {
        anchors.fill: parent
        active: page.modalDateOpen
        z: 2000
        sourceComponent: Component {
            Md3DatePicker {
                anchors.fill: parent
                modal: true
                open: true
                title: qsTr("Select date")
                onAccepted: function (d) {
                    console.log("modal", d)
                    page.modalDateOpen = false
                }
                onCancelled: page.modalDateOpen = false
            }
        }
    }

    Loader {
        anchors.fill: parent
        active: page.modalTimeOpen
        z: 2001
        sourceComponent: Component {
            Md3TimePicker {
                anchors.fill: parent
                modal: true
                open: true
                title: qsTr("Select time")
                onAccepted: function (h, m) {
                    console.log("modal time", h, m)
                    page.modalTimeOpen = false
                }
                onCancelled: page.modalTimeOpen = false
            }
        }
    }
}
