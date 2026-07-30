import QtQuick
import Md3

/// Desktop shortcut capture field: captures a single chord like Ctrl+K / Shift+Enter.
Item {
    id: root

    property string label: ""
    property string placeholderText: qsTr("Press shortcut")
    property string supportingText: ""
    property bool captureEnabled: true
    property bool autoAcceptOnEnter: true
    property bool requireModifier: true
    property bool allowSingleKeyFunctionKeys: true
    property bool allowSingleKeyNavigation: false
    property bool allowSingleKeyLetters: false
    property bool allowSingleKeyDigits: false
    property var allowedBaseKeys: [] // optional whitelist like ["K","Enter","F5"]

    /// Normalized display format: "Ctrl+K", "Shift+Enter", etc.
    property string sequence: ""

    /// Reserved sequences to detect conflict.
    property var reservedShortcuts: [] // string[]
    readonly property bool hasConflict: {
        const list = reservedShortcuts || []
        const s = normalizeSeq(sequence)
        if (!s.length)
            return false
        for (let i = 0; i < list.length; ++i) {
            const it = list[i]
            if (it !== undefined && normalizeSeq(String(it)) === s)
                return true
        }
        return false
    }

    signal captured(string sequence)
    signal sequenceAccepted(string sequence)

    implicitWidth: 320
    implicitHeight: 56
    width: parent ? parent.width : implicitWidth
    height: implicitHeight

    Accessible.role: Accessible.EditableText
    Accessible.name: label.length ? label : (placeholderText.length ? placeholderText : qsTr("Key sequence field"))

    function normalizeSeq(s) {
        if (s === undefined || s === null)
            return ""
        return String(s)
                .trim()
                .replace(/\s+/g, "")
                .toLowerCase()
    }

    function _modifierParts(modifiers) {
        const out = []
        if (modifiers & Qt.ControlModifier)
            out.push("Ctrl")
        if (modifiers & Qt.AltModifier)
            out.push("Alt")
        if (modifiers & Qt.ShiftModifier)
            out.push("Shift")
        if (modifiers & Qt.MetaModifier)
            out.push("Meta")
        return out
    }

    function _keyName(event) {
        // Map by key code first — with Ctrl/Alt, event.text is often a
        // non-printable control character (shows as tofu / □).
        if (event.key === Qt.Key_Escape)
            return "Esc"
        if (event.key === Qt.Key_Backspace)
            return "Backspace"
        if (event.key === Qt.Key_Tab)
            return "Tab"
        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter)
            return "Enter"
        if (event.key === Qt.Key_Space)
            return "Space"
        if (event.key === Qt.Key_Delete)
            return "Delete"
        if (event.key === Qt.Key_Insert)
            return "Insert"
        if (event.key === Qt.Key_Home)
            return "Home"
        if (event.key === Qt.Key_End)
            return "End"
        if (event.key === Qt.Key_PageUp)
            return "PageUp"
        if (event.key === Qt.Key_PageDown)
            return "PageDown"
        if (event.key === Qt.Key_Left)
            return "Left"
        if (event.key === Qt.Key_Right)
            return "Right"
        if (event.key === Qt.Key_Up)
            return "Up"
        if (event.key === Qt.Key_Down)
            return "Down"
        if (event.key >= Qt.Key_F1 && event.key <= Qt.Key_F35)
            return "F" + String(event.key - Qt.Key_F1 + 1)
        if (event.key >= Qt.Key_A && event.key <= Qt.Key_Z)
            return String.fromCharCode(65 + (event.key - Qt.Key_A))
        if (event.key >= Qt.Key_0 && event.key <= Qt.Key_9)
            return String.fromCharCode(48 + (event.key - Qt.Key_0))

        const t = event.text !== undefined ? String(event.text) : ""
        if (t.length === 1) {
            const code = t.charCodeAt(0)
            // Only printable characters (skip Ctrl-generated C0 controls → tofu).
            if (code >= 32 && code !== 127) {
                if (/[a-zA-Z]/.test(t))
                    return t.toUpperCase()
                if (/^\d$/.test(t))
                    return t
                if (/^[\S]$/.test(t))
                    return t
            }
        }
        return ""
    }

    function _buildSequence(modifiers, baseKey) {
        if (!baseKey || baseKey.length === 0)
            return ""
        const mods = _modifierParts(modifiers)
        if (mods.length === 0)
            return baseKey
        return mods.join("+") + "+" + baseKey
    }

    function _baseKeyAllowed(baseKey, modifiers) {
        if (!baseKey || !baseKey.length)
            return false
        if (allowedBaseKeys && allowedBaseKeys.length > 0) {
            let ok = false
            for (let i = 0; i < allowedBaseKeys.length; ++i) {
                if (String(allowedBaseKeys[i]).toLowerCase() === String(baseKey).toLowerCase()) {
                    ok = true
                    break
                }
            }
            if (!ok)
                return false
        }
        if (modifiers !== Qt.NoModifier)
            return true
        if (/^F\d+$/.test(baseKey))
            return allowSingleKeyFunctionKeys
        if (/^[A-Z]$/.test(baseKey))
            return allowSingleKeyLetters
        if (/^\d$/.test(baseKey))
            return allowSingleKeyDigits
        if (["Left", "Right", "Up", "Down", "Home", "End", "PageUp", "PageDown", "Tab", "Enter", "Space"].indexOf(baseKey) >= 0)
            return allowSingleKeyNavigation
        return !requireModifier
    }

    function clear() {
        if (root.sequence.length) {
            root.sequence = ""
            captured(root.sequence)
        }
    }

    Rectangle {
        id: box
        anchors.fill: parent
        radius: Md3Theme.shape.extraSmall
        color: Md3Theme.colorScheme.surface
        border.width: 1
        border.color: root.hasConflict
                       ? Md3Theme.colorScheme.error
                       : (input.activeFocus ? Md3Theme.colorScheme.outlineVariant
                                             : Md3Theme.colorScheme.outlineVariant)
        clip: true
    }

    Md3StateOverlay {
        anchors.fill: box
        radius: box.radius
        overlayColor: Md3Theme.colorScheme.colorOnSurface
        hovered: pointerHit.containsMouse
        pressed: pointerHit.pressed
        controlEnabled: root.captureEnabled
    }

    MouseArea {
        id: pointerHit
        anchors.fill: box
        enabled: root.captureEnabled
        hoverEnabled: true
        cursorShape: Qt.IBeamCursor
        onPressed: input.forceActiveFocus()
    }

    Md3FocusRing {
        anchors.fill: box
        anchors.margins: -3
        radius: Md3Theme.shape.extraSmall
        focused: input.activeFocus
        controlEnabled: root.captureEnabled
        visualFocus: false
    }

    Row {
        anchors.fill: box
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        spacing: 12

        Md3Icon {
            visible: label.length > 0 || root.sequence.length > 0 || root.hasConflict
            icon: root.hasConflict ? "error" : "keyboard"
            size: 22
            iconColor: root.hasConflict ? Md3Theme.colorScheme.error
                                         : Md3Theme.colorScheme.colorOnSurfaceVariant
            anchors.verticalCenter: parent.verticalCenter
        }

        Column {
            spacing: 4
            width: parent.width - (Md3Icon.visible ? 22 + 12 : 0)

            Text {
                text: label.length ? label : ""
                visible: label.length > 0
                color: Md3Theme.colorScheme.colorOnSurfaceVariant
                font.family: Md3Theme.typography.fontFamily
                font.pixelSize: Md3Theme.typography.labelSmall.size
                elide: Text.ElideRight
            }

            TextInput {
                id: input
                readOnly: true
                selectByMouse: true
                focus: true
                activeFocusOnTab: true
                enabled: root.captureEnabled
                anchors.left: parent.left
                width: parent.width
                height: 32
                verticalAlignment: TextInput.AlignVCenter
                horizontalAlignment: TextInput.AlignLeft
                font.family: Md3Theme.typography.fontFamily
                font.pixelSize: Md3Theme.typography.bodyLarge.size

                text: root.sequence.length ? root.sequence : ""
                color: root.sequence.length ? Md3Theme.colorScheme.colorOnSurface
                                              : Md3Theme.colorScheme.colorOnSurfaceVariant

                Keys.priority: Keys.BeforeItem
                Keys.onPressed: function (event) {
                    if (!root.captureEnabled)
                        return

                    // Clear
                    if (event.key === Qt.Key_Escape || event.key === Qt.Key_Backspace) {
                        clear()
                        event.accepted = true
                        return
                    }

                    // Ignore pure modifier keys so we don't produce "Ctrl" alone.
                    if (event.key === Qt.Key_Control || event.key === Qt.Key_Shift
                            || event.key === Qt.Key_Alt || event.key === Qt.Key_Meta) {
                        event.accepted = true
                        return
                    }

                    const base = _keyName(event)
                    if (!_baseKeyAllowed(base, event.modifiers)) {
                        event.accepted = true
                        return
                    }
                    const seq = _buildSequence(event.modifiers, base)
                    if (!seq.length) {
                        event.accepted = true
                        return
                    }

                    if (root.sequence !== seq) {
                        root.sequence = seq
                        captured(seq)
                    }

                    if (root.autoAcceptOnEnter && (event.key === Qt.Key_Return || event.key === Qt.Key_Enter)) {
                        sequenceAccepted(root.sequence)
                    }
                    event.accepted = true
                }
            }

            Text {
                visible: (root.sequence.length === 0 && !input.activeFocus) || root.hasConflict || root.supportingText.length > 0
                text: root.hasConflict
                      ? qsTr("Conflicts with an existing shortcut")
                      : (root.sequence.length === 0 && !input.activeFocus ? root.placeholderText : root.supportingText)
                color: root.hasConflict ? Md3Theme.colorScheme.error : Md3Theme.colorScheme.colorOnSurfaceVariant
                font.family: Md3Theme.typography.fontFamily
                font.pixelSize: Md3Theme.typography.labelSmall.size
                elide: Text.ElideRight
            }
        }
    }

    // Ensure we can capture even when empty.
    Component.onCompleted: input.forceActiveFocus()
}

