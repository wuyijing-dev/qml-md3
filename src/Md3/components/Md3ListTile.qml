import QtQuick

Item {
    id: root

    property string title: ""
    property string subtitle: ""
    property string supportingText: ""
    property string leadingIcon: ""
    property string trailingIcon: ""
    /// Degrees applied to trailing icon (e.g. ExpansionTile chevron).
    property real trailingRotation: 0
    property bool selected: false
    property bool enabled: true
    property bool showDivider: false

    signal clicked()
    signal trailingClicked()

    readonly property int lines: {
        if (supportingText.length > 0)
            return 3
        if (subtitle.length > 0)
            return 2
        return 1
    }
    readonly property real minH: lines === 1 ? 56 : (lines === 2 ? 72 : 88)

    implicitHeight: Math.max(minH, col.implicitHeight + 16)
    implicitWidth: 320
    height: implicitHeight
    width: implicitWidth
    activeFocusOnTab: enabled
    Accessible.name: title
    Accessible.role: Accessible.ListItem

    Rectangle {
        anchors.fill: parent
        color: root.selected ? Md3Theme.colorScheme.secondaryContainer : "transparent"
        Md3StateOverlay {
            overlayColor: root.selected ? Md3Theme.colorScheme.colorOnSecondaryContainer
                                        : Md3Theme.colorScheme.colorOnSurface
            hovered: mouse.containsMouse
            focused: root.activeFocus
            pressed: mouse.pressed
            controlEnabled: root.enabled
        }
    }

    Row {
        anchors.fill: parent
        anchors.leftMargin: 16
        anchors.rightMargin: 16
        spacing: 16

        Md3Icon {
            visible: root.leadingIcon.length > 0
            icon: root.leadingIcon
            size: 24
            iconColor: root.enabled ? Md3Theme.colorScheme.colorOnSurfaceVariant
                                    : Md3Theme.colorScheme.disabledContent()
            anchors.verticalCenter: parent.verticalCenter
        }

        Column {
            id: col
            anchors.verticalCenter: parent.verticalCenter
            width: {
                let w = parent.width
                if (root.leadingIcon.length > 0)
                    w -= 24 + 16
                if (root.trailingIcon.length > 0)
                    w -= 24 + 16
                return Math.max(0, w)
            }
            spacing: 2

            Text {
                width: parent.width
                text: root.title
                color: root.enabled
                       ? (root.selected ? Md3Theme.colorScheme.colorOnSecondaryContainer : Md3Theme.colorScheme.colorOnSurface)
                       : Md3Theme.colorScheme.disabledContent()
                font.family: Md3Theme.typography.fontFamily
                font.pixelSize: Md3Theme.scaled(Md3Theme.typography.bodyLarge.size)
                elide: Text.ElideRight
            }
            Text {
                visible: root.subtitle.length > 0
                width: parent.width
                text: root.subtitle
                color: root.enabled ? Md3Theme.colorScheme.colorOnSurfaceVariant
                                    : Md3Theme.colorScheme.disabledContent()
                font.family: Md3Theme.typography.fontFamily
                font.pixelSize: Md3Theme.scaled(Md3Theme.typography.bodyMedium.size)
                elide: Text.ElideRight
            }
            Text {
                visible: root.supportingText.length > 0
                width: parent.width
                text: root.supportingText
                color: root.enabled ? Md3Theme.colorScheme.colorOnSurfaceVariant
                                    : Md3Theme.colorScheme.disabledContent()
                font.family: Md3Theme.typography.fontFamily
                font.pixelSize: Md3Theme.scaled(Md3Theme.typography.bodyMedium.size)
                wrapMode: Text.Wrap
                maximumLineCount: 2
            }
        }

        Md3Icon {
            visible: root.trailingIcon.length > 0
            icon: root.trailingIcon
            size: 24
            iconColor: Md3Theme.colorScheme.colorOnSurfaceVariant
            anchors.verticalCenter: parent.verticalCenter
            rotation: root.trailingRotation
            Behavior on rotation {
                NumberAnimation {
                    duration: Md3Motion.spatialSnapDuration
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Md3Motion.emphasized
                }
            }
            MouseArea {
                anchors.fill: parent
                enabled: root.enabled
                onClicked: root.trailingClicked()
            }
        }
    }

    Md3Divider {
        visible: root.showDivider
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        variant: Md3Divider.Inset
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        enabled: root.enabled
        z: -1
        onClicked: {
            root.forceActiveFocus()
            root.clicked()
        }
    }
}
