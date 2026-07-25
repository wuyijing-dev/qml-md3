import QtQuick

Item {
    id: root

    enum Variant { Filled, Outlined }

    property int variant: Md3TextField.Filled
    property alias text: input.text
    property string label: ""
    property string placeholderText: ""
    property string supportingText: ""
    property string errorText: ""
    property bool error: false
    property bool enabled: true
    property bool multiline: false
    property int maximumLineCount: multiline ? 4 : 1
    property string leadingIcon: ""
    property string trailingIcon: ""
    property bool password: false
    property bool passwordVisible: false
    // When true (default for trailing "close"), clears text on trailing tap.
    property bool clearOnTrailing: true

    signal trailingClicked()
    signal accepted()

    readonly property bool focused: input.activeFocus
    readonly property bool floated: focused || text.length > 0
    readonly property bool hasError: error || errorText.length > 0
    readonly property string helper: hasError ? (errorText.length ? errorText : supportingText) : supportingText
    readonly property color activeColor: hasError ? Md3Theme.colorScheme.error
                                                  : Md3Theme.colorScheme.primary
    readonly property color fieldSurface: Md3Theme.colorScheme.surface

    readonly property string effectiveTrailingIcon: {
        if (password)
            return passwordVisible ? "visibility_off" : "visibility"
        return trailingIcon
    }

    implicitWidth: 280
    implicitHeight: (multiline ? Math.max(56, input.contentHeight + 32) : 56)
                    + (helper.length > 0 ? 20 : 0)
    width: implicitWidth
    height: implicitHeight

    function handleTrailing() {
        if (!enabled)
            return
        if (password) {
            passwordVisible = !passwordVisible
            trailingClicked()
            return
        }
        if (clearOnTrailing && (trailingIcon === "close" || trailingIcon === "clear")) {
            input.clear()
            trailingClicked()
            return
        }
        trailingClicked()
    }

    Column {
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 4

        Item {
            id: fieldBox
            width: parent.width
            height: root.multiline ? Math.max(56, input.contentHeight + 32) : 56

            Rectangle {
                id: fill
                anchors.fill: parent
                radius: root.variant === Md3TextField.Outlined ? Md3Theme.shape.extraSmall : 0
                topLeftRadius: Md3Theme.shape.extraSmall
                topRightRadius: Md3Theme.shape.extraSmall
                bottomLeftRadius: root.variant === Md3TextField.Outlined ? Md3Theme.shape.extraSmall : 0
                bottomRightRadius: root.variant === Md3TextField.Outlined ? Md3Theme.shape.extraSmall : 0
                color: {
                    if (root.variant === Md3TextField.Outlined)
                        return "transparent"
                    if (!root.enabled)
                        return Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.colorOnSurface, 0.04)
                    return Md3Theme.colorScheme.surfaceContainerHighest
                }
                border.width: root.variant === Md3TextField.Outlined ? (root.focused ? 2 : 1) : 0
                border.color: {
                    if (!root.enabled)
                        return Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.colorOnSurface, 0.12)
                    if (root.focused || root.hasError)
                        return root.activeColor
                    return Md3Theme.colorScheme.outline
                }

                Behavior on border.color {
                    ColorAnimation {
                        duration: Md3Motion.short2
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Md3Motion.uiEffects
                    }
                }

                Rectangle {
                    visible: root.variant === Md3TextField.Filled
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    height: root.focused || root.hasError ? 2 : 1
                    color: {
                        if (!root.enabled)
                            return Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.colorOnSurface, 0.38)
                        if (root.focused || root.hasError)
                            return root.activeColor
                        return Md3Theme.colorScheme.colorOnSurfaceVariant
                    }
                    Behavior on height {
                        NumberAnimation {
                    duration: Md3Motion.spatialSnapDuration
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Md3Motion.emphasized
                }
                    }
                }

                // Leading icon
                Md3Icon {
                    id: leading
                    visible: root.leadingIcon.length > 0
                    anchors.left: parent.left
                    anchors.leftMargin: 12
                    anchors.verticalCenter: parent.verticalCenter
                    icon: root.leadingIcon
                    size: 24
                    iconColor: root.enabled ? Md3Theme.colorScheme.colorOnSurfaceVariant
                                            : Md3Theme.colorScheme.disabledContent()
                }

                // Trailing action — own hit target above the field (z)
                Item {
                    id: trailingHit
                    visible: {
                        if (root.password)
                            return true
                        if (root.trailingIcon.length === 0)
                            return false
                        if (root.trailingIcon === "close" || root.trailingIcon === "clear")
                            return root.text.length > 0
                        return true
                    }
                    width: 48
                    height: parent.height
                    anchors.right: parent.right
                    anchors.rightMargin: 4
                    z: 3

                    Md3Icon {
                        anchors.centerIn: parent
                        icon: root.effectiveTrailingIcon
                        size: 24
                        iconColor: root.hasError ? Md3Theme.colorScheme.error
                                                 : (root.enabled ? Md3Theme.colorScheme.colorOnSurfaceVariant
                                                                 : Md3Theme.colorScheme.disabledContent())
                    }
                    MouseArea {
                        anchors.fill: parent
                        enabled: root.enabled
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.handleTrailing()
                    }
                }

                TextInput {
                    id: input
                    anchors.left: parent.left
                    anchors.leftMargin: 12 + (root.leadingIcon.length > 0 ? 36 : 0)
                    anchors.right: parent.right
                    anchors.rightMargin: trailingHit.visible ? 52 : 12
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: root.floated && root.label.length > 0 ? 6 : 0
                    enabled: root.enabled
                    color: root.enabled ? Md3Theme.colorScheme.colorOnSurface
                                        : Md3Theme.colorScheme.disabledContent()
                    selectedTextColor: Md3Theme.colorScheme.colorOnPrimary
                    selectionColor: Md3Theme.colorScheme.primary
                    font.family: Md3Theme.typography.fontFamily
                    font.pixelSize: Md3Theme.scaled(Md3Theme.typography.bodyLarge.size)
                    echoMode: (root.password && !root.passwordVisible) ? TextInput.Password
                                                                       : TextInput.Normal
                    wrapMode: root.multiline ? TextInput.Wrap : TextInput.NoWrap
                    clip: true
                    onAccepted: root.accepted()
                }

                Text {
                    anchors.fill: input
                    text: root.placeholderText
                    visible: root.text.length === 0 && root.label.length === 0
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font: input.font
                    opacity: 0.7
                    elide: Text.ElideRight
                }
            }

            // Floating label — below trailing hit (z:2 < 3) so icons stay clickable
            Item {
                id: labelSlot
                visible: root.label.length > 0
                height: labelItem.height
                width: labelItem.width + (root.variant === Md3TextField.Outlined && root.floated ? 8 : 0)
                x: 12 + (root.leadingIcon.length > 0 && !root.floated ? 36 : 0)
                y: root.floated
                   ? (root.variant === Md3TextField.Outlined ? -labelItem.height / 2 : 4)
                   : (fieldBox.height - labelItem.height) / 2
                z: 2

                Behavior on y {
                    NumberAnimation {
                    duration: Md3Motion.spatialSnapDuration
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Md3Motion.emphasized
                }
                }
                Behavior on x {
                    NumberAnimation {
                    duration: Md3Motion.spatialSnapDuration
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Md3Motion.emphasized
                }
                }

                Rectangle {
                    visible: root.variant === Md3TextField.Outlined && root.floated
                    anchors.centerIn: labelItem
                    width: labelItem.width + 8
                    height: Math.max(4, labelItem.height * 0.45)
                    color: root.fieldSurface
                }

                Text {
                    id: labelItem
                    text: root.label
                    color: {
                        if (!root.enabled)
                            return Md3Theme.colorScheme.disabledContent()
                        if (root.focused || root.hasError)
                            return root.activeColor
                        return Md3Theme.colorScheme.colorOnSurfaceVariant
                    }
                    font.family: Md3Theme.typography.fontFamily
                    font.pixelSize: root.floated
                                    ? Md3Theme.scaled(Md3Theme.typography.labelSmall.size)
                                    : Md3Theme.scaled(Md3Theme.typography.bodyLarge.size)
                    font.weight: root.floated ? Font.Medium : Font.Normal

                    Behavior on font.pixelSize {
                        NumberAnimation {
                    duration: Md3Motion.spatialSnapDuration
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Md3Motion.emphasized
                }
                    }
                }
            }
        }

        Text {
            visible: root.helper.length > 0
            width: parent.width
            leftPadding: 16
            text: root.helper
            color: root.hasError ? Md3Theme.colorScheme.error
                                 : Md3Theme.colorScheme.colorOnSurfaceVariant
            font.family: Md3Theme.typography.fontFamily
            font.pixelSize: Md3Theme.scaled(Md3Theme.typography.bodySmall.size)
            wrapMode: Text.Wrap
        }
    }
}
