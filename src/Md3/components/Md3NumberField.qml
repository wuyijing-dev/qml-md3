import QtQuick

/// Numeric spin field: TextField chrome + step buttons (form-friendly SpinBox).
Item {
    id: root

    enum Variant { Filled, Outlined }

    property int variant: Md3NumberField.Outlined
    property real value: 0
    property real from: 0
    property real to: 100
    property real stepSize: 1
    property int decimals: 0
    property string label: ""
    property string supportingText: ""
    property string errorText: ""
    property bool error: false
    /// Form field key for Md3Form.validate / error auto-wiring.
    property string name: ""
    // Use Item.enabled (do not redeclare)
    property string prefix: ""
    property string suffix: ""
    property string accessibleName: ""

    signal valueModified(real value)

    readonly property bool hasError: error || errorText.length > 0
    readonly property string helper: hasError ? (errorText.length ? errorText : supportingText) : supportingText
    readonly property color activeColor: hasError ? Md3Theme.colorScheme.error
                                                  : Md3Theme.colorScheme.primary
    readonly property bool atMin: value <= from + 1e-9
    readonly property bool atMax: value >= to - 1e-9

    implicitWidth: 200
    implicitHeight: 56 + (helper.length > 0 ? 20 : 0)
    width: implicitWidth
    height: implicitHeight
    activeFocusOnTab: enabled
    Accessible.name: accessibleName.length ? accessibleName : (label.length ? label : qsTr("Number"))
    Accessible.role: Accessible.SpinBox
    Accessible.description: helper

    function formatValue(v) {
        const n = Number(v)
        if (!isFinite(n))
            return ""
        return decimals > 0 ? n.toFixed(decimals) : String(Math.round(n))
    }

    function clamp(v) {
        return Math.max(from, Math.min(to, v))
    }

    function setValue(v, emitSignal) {
        const next = clamp(Number(v))
        const rounded = decimals > 0
                        ? Number(next.toFixed(decimals))
                        : Math.round(next)
        if (Math.abs(rounded - value) < 1e-12) {
            input.text = formatValue(value)
            return
        }
        value = rounded
        input.text = formatValue(value)
        if (emitSignal !== false)
            valueModified(value)
    }

    function stepBy(dir) {
        if (!enabled)
            return
        const step = stepSize > 0 ? stepSize : 1
        setValue(value + dir * step, true)
    }

    function commitText() {
        let t = String(input.text || "").trim()
        if (prefix.length && t.startsWith(prefix))
            t = t.slice(prefix.length).trim()
        if (suffix.length && t.endsWith(suffix))
            t = t.slice(0, t.length - suffix.length).trim()
        const n = Number(t)
        if (!isFinite(n)) {
            input.text = formatValue(value)
            return
        }
        setValue(n, true)
    }

    onValueChanged: {
        if (!input.activeFocus)
            input.text = formatValue(value)
    }

    Component.onCompleted: input.text = formatValue(value)

    Column {
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 4

        Rectangle {
            id: field
            width: parent.width
            height: 56
            radius: Md3Theme.shape.extraSmall
            color: root.variant === Md3NumberField.Filled
                   ? Md3Theme.colorScheme.surfaceContainerHighest
                   : "transparent"
            border.width: root.variant === Md3NumberField.Outlined
                          ? (input.activeFocus || root.hasError ? 2 : 1) : 0
            border.color: {
                if (!root.enabled)
                    return Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.colorOnSurface, 0.12)
                if (root.hasError)
                    return Md3Theme.colorScheme.error
                if (input.activeFocus)
                    return root.activeColor
                return Md3Theme.colorScheme.outline
            }

            Rectangle {
                visible: root.variant === Md3NumberField.Filled
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: input.activeFocus || root.hasError ? 2 : 1
                color: {
                    if (!root.enabled)
                        return Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.colorOnSurface, 0.38)
                    if (root.hasError)
                        return Md3Theme.colorScheme.error
                    if (input.activeFocus)
                        return root.activeColor
                    return Md3Theme.colorScheme.colorOnSurfaceVariant
                }
            }

            Text {
                id: labelItem
                text: root.label
                visible: root.label.length > 0
                x: 16
                y: (input.activeFocus || input.text.length > 0) ? 6 : (parent.height - height) / 2
                z: 2
                color: input.activeFocus || root.hasError ? root.activeColor
                       : Md3Theme.colorScheme.colorOnSurfaceVariant
                font.family: Md3Theme.typography.fontFamily
                font.pixelSize: (input.activeFocus || input.text.length > 0)
                                ? Md3Theme.typography.labelSmall.size
                                : Md3Theme.typography.bodyLarge.size
                font.weight: Font.Medium

                Rectangle {
                    visible: root.variant === Md3NumberField.Outlined
                             && (input.activeFocus || input.text.length > 0)
                    anchors.centerIn: parent
                    width: parent.width + 8
                    height: 6
                    color: Md3Theme.colorScheme.surface
                    z: -1
                }
            }

            // Steppers fill the full field height so they stay vertically centered
            // even when the value row is offset for a floating label.
            Column {
                id: steppers
                anchors.right: parent.right
                anchors.rightMargin: 2
                anchors.verticalCenter: parent.verticalCenter
                spacing: 0
                width: 40
                height: 40

                Item {
                    width: 40
                    height: 20
                    Md3Icon {
                        anchors.centerIn: parent
                        icon: "arrow_drop_up"
                        size: 20
                        iconColor: root.enabled && !root.atMax
                                   ? Md3Theme.colorScheme.colorOnSurfaceVariant
                                   : Md3Theme.colorScheme.disabledContent()
                    }
                    MouseArea {
                        anchors.fill: parent
                        enabled: root.enabled && !root.atMax
                        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                        onClicked: root.stepBy(1)
                    }
                }
                Item {
                    width: 40
                    height: 20
                    Md3Icon {
                        anchors.centerIn: parent
                        icon: "arrow_drop_down"
                        size: 20
                        iconColor: root.enabled && !root.atMin
                                   ? Md3Theme.colorScheme.colorOnSurfaceVariant
                                   : Md3Theme.colorScheme.disabledContent()
                    }
                    MouseArea {
                        anchors.fill: parent
                        enabled: root.enabled && !root.atMin
                        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                        onClicked: root.stepBy(-1)
                    }
                }
            }

            Row {
                anchors.left: parent.left
                anchors.right: steppers.left
                anchors.leftMargin: 16
                anchors.rightMargin: 4
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: root.label.length > 0 ? 18 : 0
                spacing: 4

                Text {
                    visible: root.prefix.length > 0
                    anchors.verticalCenter: parent.verticalCenter
                    text: root.prefix
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.family: Md3Theme.typography.fontFamily
                    font.pixelSize: Md3Theme.typography.bodyLarge.size
                }

                TextInput {
                    id: input
                    anchors.verticalCenter: parent.verticalCenter
                    width: Math.max(24, parent.width
                                    - (root.prefix.length > 0 ? 28 : 0)
                                    - (root.suffix.length > 0 ? 28 : 0))
                    height: parent.height
                    verticalAlignment: TextInput.AlignVCenter
                    color: root.enabled ? Md3Theme.colorScheme.colorOnSurface
                                        : Md3Theme.colorScheme.disabledContent()
                    font.family: Md3Theme.typography.fontFamily
                    font.pixelSize: Md3Theme.typography.bodyLarge.size
                    selectByMouse: true
                    enabled: root.enabled
                    inputMethodHints: Qt.ImhFormattedNumbersOnly
                    validator: DoubleValidator {
                        bottom: Math.min(root.from, root.to)
                        top: Math.max(root.from, root.to)
                        decimals: Math.max(0, root.decimals)
                        notation: DoubleValidator.StandardNotation
                    }
                    onEditingFinished: root.commitText()
                    Keys.onUpPressed: root.stepBy(1)
                    Keys.onDownPressed: root.stepBy(-1)
                }

                Text {
                    visible: root.suffix.length > 0
                    anchors.verticalCenter: parent.verticalCenter
                    text: root.suffix
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.family: Md3Theme.typography.fontFamily
                    font.pixelSize: Md3Theme.typography.bodyLarge.size
                }
            }
        }

        Text {
            visible: root.helper.length > 0
            width: parent.width
            leftPadding: 16
            text: root.helper
            wrapMode: Text.Wrap
            color: root.hasError ? Md3Theme.colorScheme.error
                                 : Md3Theme.colorScheme.colorOnSurfaceVariant
            font.family: Md3Theme.typography.fontFamily
            font.pixelSize: Md3Theme.typography.bodySmall.size
        }
    }
}
