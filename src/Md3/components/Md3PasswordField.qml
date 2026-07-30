import QtQuick
import Md3

/// Password field with visibility toggle (via Md3TextField) and optional strength meter.
Item {
    id: root

    enum Variant { Filled, Outlined }

    property int variant: Md3PasswordField.Filled
    property alias text: field.text
    property string label: qsTr("Password")
    property string placeholderText: ""
    property string supportingText: ""
    property string errorText: ""
    property bool error: false
    property string name: ""
    property bool showStrength: true
    property int minLength: 8
    property alias passwordVisible: field.passwordVisible
    property string accessibleName: ""

    readonly property int strength: _score(text)
    readonly property string strengthLabel: {
        switch (strength) {
        case 0: return text.length ? qsTr("Too weak") : ""
        case 1: return qsTr("Weak")
        case 2: return qsTr("Fair")
        case 3: return qsTr("Good")
        default: return qsTr("Strong")
        }
    }
    readonly property color strengthColor: {
        switch (strength) {
        case 0: return Md3Theme.colorScheme.error
        case 1: return Md3Theme.colorScheme.error
        case 2: return Md3Theme.colorScheme.tertiary
        case 3: return Md3Theme.colorScheme.secondary
        default: return Md3Theme.colorScheme.primary
        }
    }

    signal accepted()
    signal strengthChangedByUser(int score)

    function _score(pw) {
        const s = String(pw || "")
        if (!s.length)
            return 0
        let score = 0
        if (s.length >= minLength)
            score += 1
        if (s.length >= minLength + 4)
            score += 1
        if (/[a-z]/.test(s) && /[A-Z]/.test(s))
            score += 1
        if (/\d/.test(s))
            score += 1
        if (/[^A-Za-z0-9]/.test(s))
            score += 1
        // Map 0–5 → 0–4 bands
        if (score <= 1)
            return s.length ? 1 : 0
        if (score === 2)
            return 2
        if (score === 3)
            return 3
        return 4
    }

    width: parent ? Math.min(parent.width, 360) : 360
    implicitHeight: col.implicitHeight
    height: implicitHeight

    onStrengthChanged: strengthChangedByUser(strength)

    Column {
        id: col
        width: parent.width
        spacing: 6

        Md3TextField {
            id: field
            width: parent.width
            variant: root.variant === Md3PasswordField.Outlined ? Md3TextField.Outlined
                                                                : Md3TextField.Filled
            label: root.label
            placeholderText: root.placeholderText
            supportingText: root.showStrength ? "" : root.supportingText
            errorText: root.errorText
            error: root.error
            name: root.name
            password: true
            enabled: root.enabled
            accessibleName: root.accessibleName.length ? root.accessibleName : root.label
            onAccepted: root.accepted()
        }

        Column {
            width: parent.width
            spacing: 4
            visible: root.showStrength
            leftPadding: 4
            rightPadding: 4

            Row {
                spacing: 4
                width: parent.width
                Repeater {
                    model: 4
                    Rectangle {
                        required property int index
                        width: (parent.width - 12) / 4
                        height: 4
                        radius: 2
                        color: index < root.strength ? root.strengthColor
                                                     : Md3Theme.colorScheme.surfaceContainerHighest
                        Behavior on color {
                            ColorAnimation { duration: Md3Motion.effectsDuration }
                        }
                    }
                }
            }

            Text {
                width: parent.width
                text: root.strengthLabel.length ? root.strengthLabel
                      : (root.supportingText.length ? root.supportingText
                         : qsTr("Use %1+ chars with mixed case, numbers, symbols").arg(root.minLength))
                color: root.strengthLabel.length ? root.strengthColor
                                                 : Md3Theme.colorScheme.colorOnSurfaceVariant
                font.family: Md3Theme.typography.fontFamily
                font.pixelSize: Md3Theme.typography.bodySmall.size
                wrapMode: Text.Wrap
            }
        }
    }
}
