import QtQuick
import Md3

/// Long-running / cancellable activity strip (scan, index, delete…).
Item {
    id: root

    property string label: ""
    property string secondaryLabel: ""
    property bool indeterminate: true
    property real value: 0 // 0…1 when determinate
    property bool cancelable: false
    property string cancelText: qsTr("Cancel")
    property bool active: true

    signal canceled()

    visible: active
    implicitHeight: visible ? col.implicitHeight : 0
    implicitWidth: 280
    height: implicitHeight

    Column {
        id: col
        width: parent.width
        spacing: 8

        Row {
            width: parent.width
            spacing: 12

            Column {
                width: parent.width - (root.cancelable ? cancelBtn.width + 12 : 0)
                spacing: 2
                Md3Text {
                    width: parent.width
                    text: root.label
                    role: Md3Text.LabelLarge
                    elide: Text.ElideRight
                    visible: root.label.length > 0
                }
                Md3Text {
                    width: parent.width
                    text: root.secondaryLabel
                    role: Md3Text.BodySmall
                    tone: Md3Text.OnSurfaceVariant
                    elide: Text.ElideRight
                    visible: root.secondaryLabel.length > 0
                }
            }

            Md3Button {
                id: cancelBtn
                visible: root.cancelable
                text: root.cancelText
                variant: Md3Button.Text
                anchors.verticalCenter: parent.verticalCenter
                onClicked: root.canceled()
            }
        }

        Md3LinearProgressIndicator {
            width: parent.width
            indeterminate: root.indeterminate
            value: root.value
        }
    }
}
