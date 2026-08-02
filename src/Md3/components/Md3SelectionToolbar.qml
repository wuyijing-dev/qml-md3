import QtQuick
import Md3

/// Selection action bar: “N selected” + trailing actions (for tables / lists).
Item {
    id: root

    property int selectedCount: 0
    property string label: selectedCount === 1 ? qsTr("1 selected")
                          : qsTr("%1 selected").arg(selectedCount)
    property bool autoHide: true
    default property alias actions: actionsRow.data

    readonly property bool bare: selectedCount <= 0
    visible: !autoHide || selectedCount > 0
    implicitHeight: visible ? Math.max(48, Math.max(labelText.implicitHeight, actionsRow.implicitHeight) + 16) : 0
    implicitWidth: 320
    height: implicitHeight

    Rectangle {
        anchors.fill: parent
        radius: Md3Theme.shape.medium
        color: Md3Theme.colorScheme.secondaryContainer
    }

    Item {
        anchors.fill: parent
        anchors.margins: 8

        Md3Text {
            id: labelText
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: actionsRow.left
            anchors.rightMargin: 12
            text: root.label
            role: Md3Text.LabelLarge
            tone: Md3Text.Custom
            customColor: Md3Theme.colorScheme.colorOnSecondaryContainer
            elide: Text.ElideRight
        }

        Row {
            id: actionsRow
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            spacing: 8
        }
    }
}
