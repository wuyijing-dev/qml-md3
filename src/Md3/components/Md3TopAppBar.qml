import QtQuick
import Md3

Rectangle {
    id: root

    enum Size { Small, CenterAligned, Medium, Large }

    property int size: Md3TopAppBar.Small
    property string title: ""
    property string leadingIcon: "menu"
    property bool showLeading: true
    property var trailingIcons: []

    signal leadingClicked()
    signal trailingClicked(int index)

    readonly property real barHeight: {
        switch (size) {
        case Md3TopAppBar.Medium: return 112
        case Md3TopAppBar.Large: return 152
        default: return 64
        }
    }

    width: parent ? parent.width : 360
    height: barHeight
    color: Md3Theme.colorScheme.surface

    Row {
        id: topRow
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 64
        spacing: 4
        leftPadding: 4
        rightPadding: 4

        Md3IconButton {
            visible: root.showLeading
            icon: root.leadingIcon
            anchors.verticalCenter: parent.verticalCenter
            onClicked: root.leadingClicked()
        }

        Text {
            visible: root.size === Md3TopAppBar.Small || root.size === Md3TopAppBar.CenterAligned
            text: root.title
            color: Md3Theme.colorScheme.colorOnSurface
            font.family: Md3Theme.typography.fontFamily
            font.pixelSize: Md3Theme.typography.titleLarge.size
            anchors.verticalCenter: parent.verticalCenter
            width: root.size === Md3TopAppBar.CenterAligned
                   ? parent.width - 96
                   : parent.width - 48 - root.trailingIcons.length * 48
            horizontalAlignment: root.size === Md3TopAppBar.CenterAligned ? Text.AlignHCenter : Text.AlignLeft
            elide: Text.ElideRight
        }

        Item { width: 1; height: 1; visible: root.size === Md3TopAppBar.CenterAligned }

        Repeater {
            model: root.trailingIcons
            Md3IconButton {
                required property int index
                required property var modelData
                icon: typeof modelData === "string" ? modelData : modelData.icon
                badgeText: {
                    if (typeof modelData === "string")
                        return ""
                    if (modelData.badgeDot)
                        return ""
                    if (modelData.badge !== undefined && modelData.badge !== null)
                        return String(modelData.badge)
                    if (modelData.badgeText !== undefined)
                        return String(modelData.badgeText)
                    return ""
                }
                badgeDot: typeof modelData === "object" && !!modelData.badgeDot
                badgeMax: typeof modelData === "object" && modelData.badgeMax !== undefined
                          ? Number(modelData.badgeMax) : 99
                anchors.verticalCenter: parent.verticalCenter
                onClicked: root.trailingClicked(index)
            }
        }
    }

    Text {
        visible: root.size === Md3TopAppBar.Medium || root.size === Md3TopAppBar.Large
        anchors.left: parent.left
        anchors.leftMargin: 16
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 16
        text: root.title
        color: Md3Theme.colorScheme.colorOnSurface
        font.family: Md3Theme.typography.fontFamily
        font.pixelSize: root.size === Md3TopAppBar.Large
                        ? Md3Theme.typography.headlineMedium.size
                        : Md3Theme.typography.headlineSmall.size
    }
}
