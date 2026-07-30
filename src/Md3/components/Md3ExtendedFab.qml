import QtQuick
import Md3

Md3AbstractButton {
    id: root

    enum ColorRole { Primary, Secondary, Tertiary, Surface }

    property int colorRole: Md3ExtendedFab.Primary
    property bool extended: true

    icon: "add"
    text: qsTr("Create")
    accessibleName: text
    cornerRadius: Md3Theme.shape.large

    readonly property real fabHeight: 56
    readonly property real iconSize: 24
    readonly property real padStart: icon.length > 0 ? 16 : 20
    readonly property real padEnd: 20
    readonly property real elev: enabled ? (hovered && !pressed ? 8 : 6) : 0
    readonly property real shadowPad: 28
    readonly property real collapsedWidth: fabHeight
    readonly property real expandedWidth: padStart + (icon.length > 0 ? iconSize + 8 : 0)
                                          + label.implicitWidth + padEnd

    containerColor: {
        if (!enabled)
            return Md3Theme.colorScheme.disabledContainer()
        switch (colorRole) {
        case Md3ExtendedFab.Secondary: return Md3Theme.colorScheme.secondaryContainer
        case Md3ExtendedFab.Tertiary: return Md3Theme.colorScheme.tertiaryContainer
        case Md3ExtendedFab.Surface: return Md3Theme.colorScheme.surfaceContainerHigh
        default: return Md3Theme.colorScheme.primaryContainer
        }
    }
    contentColor: {
        if (!enabled)
            return Md3Theme.colorScheme.disabledContent()
        switch (colorRole) {
        case Md3ExtendedFab.Secondary: return Md3Theme.colorScheme.colorOnSecondaryContainer
        case Md3ExtendedFab.Tertiary: return Md3Theme.colorScheme.colorOnTertiaryContainer
        case Md3ExtendedFab.Surface: return Md3Theme.colorScheme.primary
        default: return Md3Theme.colorScheme.colorOnPrimaryContainer
        }
    }

    pressTarget: bg
    onPressFeedback: function (x, y) { ripple.pulse(x, y) }

    implicitWidth: (extended ? expandedWidth : collapsedWidth) + shadowPad * 2
    implicitHeight: fabHeight + shadowPad * 2
    width: implicitWidth
    height: implicitHeight

    Behavior on width {
        NumberAnimation {
            duration: Md3Motion.spatialDuration
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Md3Motion.emphasized
        }
    }

    Md3Shadow {
        anchors.centerIn: parent
        width: bg.width
        height: bg.height
        elevation: root.elev
        cornerRadius: root.cornerRadius
    }

    Rectangle {
        id: bg
        anchors.centerIn: parent
        width: root.extended ? root.expandedWidth : root.collapsedWidth
        height: root.fabHeight
        radius: root.cornerRadius
        color: root.containerColor
        clip: true

        Behavior on width {
            NumberAnimation {
                duration: Md3Motion.spatialDuration
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Md3Motion.emphasized
            }
        }

        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: Md3Theme.colorScheme.surfaceTint
            opacity: Md3Theme.elevation.tintOpacity(root.elev)
            visible: root.enabled
        }

        Md3Ripple {
            id: ripple
            rippleColor: root.contentColor
            clipRadius: root.cornerRadius
        }

        Md3StateOverlay {
            overlayColor: root.contentColor
            hovered: root.hovered
            focused: root.activeFocus && root.visualFocus
            pressed: root.pressed
            controlEnabled: root.enabled
            radius: root.cornerRadius
        }

        Row {
            id: row
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: root.extended ? root.padStart : (parent.width - root.iconSize) / 2
            spacing: 8

            Behavior on anchors.leftMargin {
                NumberAnimation {
                    duration: Md3Motion.spatialDuration
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Md3Motion.emphasized
                }
            }

            Md3Icon {
                visible: root.icon.length > 0
                icon: root.icon
                size: root.iconSize
                iconColor: root.contentColor
                anchors.verticalCenter: parent.verticalCenter
            }

            Md3Text {
                id: label
                text: root.text
                role: Md3Text.LabelLarge
                tone: Md3Text.Custom
                customColor: root.contentColor
                visible: root.extended
                opacity: root.extended ? 1 : 0
                anchors.verticalCenter: parent.verticalCenter

                Behavior on opacity {
                    NumberAnimation {
                        duration: Md3Motion.short3
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Md3Motion.standard
                    }
                }
            }
        }
    }

    Md3FocusRing {
        anchors.centerIn: parent
        width: bg.width + 6
        height: bg.height + 6
        radius: root.cornerRadius + 3
        focused: root.activeFocus
        visualFocus: root.visualFocus
        controlEnabled: root.enabled
    }
}
