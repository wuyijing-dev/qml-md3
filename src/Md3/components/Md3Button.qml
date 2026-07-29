import QtQuick
import QtQuick.Effects

Item {
    id: root

    enum Variant { Filled, FilledTonal, Elevated, Outlined, Text }
    enum Size { ExtraSmall, Small, Medium, Large }

    property int variant: Md3Button.Filled
    property int size: Md3Button.Small
    property string text: ""
    property string icon: ""
    property bool enabled: true
    property string accessibleName: text
    property bool visualFocus: false

    signal clicked()

    readonly property real h: {
        switch (size) {
        case Md3Button.ExtraSmall: return 32
        case Md3Button.Medium: return 56
        case Md3Button.Large: return 96
        default: return 40
        }
    }
    readonly property real padH: size === Md3Button.ExtraSmall ? 12 : (size === Md3Button.Large ? 24 : 16)
    readonly property real corner: {
        switch (size) {
        case Md3Button.ExtraSmall: return Md3Theme.shape.small
        case Md3Button.Large: return Md3Theme.shape.large
        default: return h / 2 // pill
        }
    }
    readonly property real elev: variant === Md3Button.Elevated ? (hovered || pressed ? 2 : 1) : 0

    readonly property color containerColor: {
        if (!enabled) return Md3Theme.colorScheme.disabledContainer()
        switch (variant) {
        case Md3Button.Filled: return Md3Theme.colorScheme.primary
        case Md3Button.FilledTonal: return Md3Theme.colorScheme.secondaryContainer
        case Md3Button.Elevated: return Md3Theme.colorScheme.surfaceContainerLow
        case Md3Button.Outlined:
        case Md3Button.Text: return "transparent"
        default: return Md3Theme.colorScheme.primary
        }
    }
    readonly property color contentColor: {
        if (!enabled) return Md3Theme.colorScheme.disabledContent()
        switch (variant) {
        case Md3Button.Filled: return Md3Theme.colorScheme.colorOnPrimary
        case Md3Button.FilledTonal: return Md3Theme.colorScheme.colorOnSecondaryContainer
        case Md3Button.Elevated: return Md3Theme.colorScheme.primary
        case Md3Button.Outlined:
        case Md3Button.Text: return Md3Theme.colorScheme.primary
        default: return Md3Theme.colorScheme.colorOnPrimary
        }
    }
    readonly property bool hovered: mouse.containsMouse
    readonly property bool pressed: mouse.pressed

    implicitWidth: Math.max(48, row.implicitWidth + padH * 2)
    implicitHeight: Math.max(48, h)
    width: implicitWidth
    height: implicitHeight
    activeFocusOnTab: enabled
    Accessible.name: accessibleName
    Accessible.role: Accessible.Button
    Accessible.onPressAction: if (enabled) root.clicked()

    Keys.onPressed: function (event) {
        if (event.key === Qt.Key_Tab || event.key === Qt.Key_Backtab)
            root.visualFocus = true
    }
    Keys.onReturnPressed: if (enabled) { visualFocus = true; clicked() }
    Keys.onEnterPressed: if (enabled) { visualFocus = true; clicked() }
    Keys.onSpacePressed: if (enabled) { visualFocus = true; clicked() }

    Md3Shadow {
        anchors.centerIn: parent
        width: bg.width
        height: bg.height
        elevation: root.elev
        cornerRadius: root.corner
    }

    Item {
        id: bg
        anchors.centerIn: parent
        width: parent.width
        height: root.h

        layer.enabled: true
        layer.smooth: true
        layer.effect: MultiEffect {
            maskEnabled: true
            maskSource: btnMask
        }

        Rectangle {
            anchors.fill: parent
            radius: root.corner
            color: root.containerColor
            border.width: root.variant === Md3Button.Outlined ? 1 : 0
            border.color: root.enabled ? Md3Theme.colorScheme.outline : Md3Theme.colorScheme.disabledContent()
        }

        Md3Ripple {
            id: ripple
            rippleColor: root.contentColor
            clipRadius: root.corner
        }
        Md3StateOverlay {
            overlayColor: root.contentColor
            hovered: root.hovered
            focused: root.activeFocus && root.visualFocus
            pressed: root.pressed
            controlEnabled: root.enabled
            radius: root.corner
        }

        Row {
            id: row
            anchors.centerIn: parent
            spacing: 8
            Md3Icon {
                visible: root.icon.length > 0
                icon: root.icon
                size: 18
                iconColor: root.contentColor
                anchors.verticalCenter: parent.verticalCenter
            }
            Text {
                text: root.text
                color: root.contentColor
                font.family: Md3Theme.typography.fontFamily
                font.pixelSize: Md3Theme.scaled(Md3Theme.typography.labelLarge.size)
                font.weight: Md3Theme.typography.labelLarge.weight
                font.letterSpacing: Md3Theme.typography.labelLarge.letterSpacing
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    Item {
        id: btnMask
        width: bg.width
        height: bg.height
        layer.enabled: true
        visible: false
        Rectangle {
            anchors.fill: parent
            radius: root.corner
            color: "#ffffff"
        }
    }

    Md3FocusRing {
        anchors.centerIn: parent
        width: bg.width + 6
        height: bg.height + 6
        radius: root.corner + 3
        focused: root.activeFocus
        visualFocus: root.visualFocus
        controlEnabled: root.enabled
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        enabled: root.enabled
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: function (mouse) {
            root.visualFocus = false
            const local = mapToItem(bg, mouse.x, mouse.y)
            ripple.pulse(local.x, local.y)
            root.forceActiveFocus()
            root.clicked()
        }
    }
}
