import QtQuick
import QtQuick.Window
import Md3

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
    /// Form field key for Md3Form.validate / error auto-wiring.
    property string name: ""
    // Use Item.enabled (do not redeclare)
    property bool multiline: false
    property int maximumLineCount: multiline ? 4 : 1
    property string leadingIcon: ""
    property string trailingIcon: ""
    property bool password: false
    property bool passwordVisible: false
    // When true (default for trailing "close"), clears text on trailing tap.
    property bool clearOnTrailing: true
    /// When true, shows a clear affordance whenever the field has text (unless password).
    property bool showClearButton: false
    /// Shake + announce when error becomes active; optional Android haptic.
    property bool announceErrors: true
    property bool errorFeedbackEnabled: true
    property int errorShakeMs: Md3Motion.short3
    property real errorShakePx: 6
    property real _shakeX: 0

    /// Enable typeahead popup from `suggestions`.
    property bool autoComplete: false
    /// string[] or [{ label, value }]
    property var suggestions: []
    property int suggestionLimit: 6
    property bool suggestionOpen: false
    /// Keyboard highlight in the suggestion list (-1 = none).
    property int suggestionIndex: -1
    property string accessibleName: ""
    property string accessibleDescription: ""
    /// Optional explicit Window for autocomplete overlay reparent.
    property var overlayWindow: null

    signal trailingClicked()
    signal accepted()
    signal suggestionChosen(var suggestion)

    readonly property bool focused: input.activeFocus
    readonly property bool floated: focused || text.length > 0
    readonly property bool hasError: error || errorText.length > 0
    readonly property string helper: hasError ? (errorText.length ? errorText : supportingText) : supportingText
    readonly property color activeColor: hasError ? Md3Theme.colorScheme.error
                                                  : Md3Theme.colorScheme.primary
    readonly property color fieldSurface: Md3Theme.colorScheme.surface

    activeFocusOnTab: enabled
    Accessible.name: accessibleName.length ? accessibleName : (label.length ? label : qsTr("Text field"))
    Accessible.description: accessibleDescription.length ? accessibleDescription
                            : (hasError && errorText.length ? errorText : supportingText)
    Accessible.role: Accessible.EditableText
    Accessible.editable: true
    Accessible.readOnly: !enabled
    Accessible.multiLine: multiline
    Accessible.passwordEdit: password && !passwordVisible

    readonly property string effectiveTrailingIcon: {
        if (password)
            return passwordVisible ? "visibility_off" : "visibility"
        if (showClearButton && text.length > 0
                && (trailingIcon.length === 0 || trailingIcon === "close" || trailingIcon === "clear"))
            return "clear"
        return trailingIcon
    }

    readonly property var filteredSuggestions: {
        if (!autoComplete || !suggestions || suggestions.length === 0)
            return []
        const q = String(text || "").trim().toLowerCase()
        const out = []
        for (let i = 0; i < suggestions.length; ++i) {
            const s = suggestions[i]
            const label = (s && s.label !== undefined) ? String(s.label)
                          : (s && s.value !== undefined) ? String(s.value)
                          : String(s)
            if (q.length === 0 || label.toLowerCase().indexOf(q) >= 0)
                out.push(s)
            if (out.length >= suggestionLimit)
                break
        }
        return out
    }

    function _suggestionLabel(s) {
        if (s && s.label !== undefined)
            return String(s.label)
        if (s && s.value !== undefined)
            return String(s.value)
        return String(s)
    }

    function _suggestionValue(s) {
        if (s && s.value !== undefined)
            return String(s.value)
        if (s && s.label !== undefined)
            return String(s.label)
        return String(s)
    }

    function applySuggestion(s) {
        if (s === undefined || s === null)
            return
        input.text = _suggestionValue(s)
        suggestionOpen = false
        suggestionIndex = -1
        suggestionChosen(s)
        Md3Accessibility.announce(qsTr("已选择 %1").arg(_suggestionLabel(s)))
        input.forceActiveFocus()
    }

    function applyHighlightedSuggestion() {
        if (!suggestionOpen || filteredSuggestions.length === 0)
            return false
        const i = suggestionIndex >= 0 ? suggestionIndex : 0
        applySuggestion(filteredSuggestions[Math.min(i, filteredSuggestions.length - 1)])
        return true
    }

    function moveSuggestionHighlight(delta) {
        if (!autoComplete || !enabled)
            return
        _syncSuggestionPopup()
        if (!suggestionOpen || filteredSuggestions.length === 0)
            return
        const n = filteredSuggestions.length
        if (suggestionIndex < 0)
            suggestionIndex = delta > 0 ? 0 : n - 1
        else
            suggestionIndex = (suggestionIndex + delta + n) % n
        filteredList.positionViewAtIndex(suggestionIndex, ListView.Contain)
        Md3Accessibility.announce(_suggestionLabel(filteredSuggestions[suggestionIndex]))
    }

    function _syncSuggestionPopup() {
        const open = autoComplete && enabled && !password && !multiline
                && focused && filteredSuggestions.length > 0
        suggestionOpen = open
        if (!open)
            suggestionIndex = -1
        else if (suggestionIndex >= filteredSuggestions.length)
            suggestionIndex = filteredSuggestions.length - 1
    }

    onFilteredSuggestionsChanged: {
        if (suggestionIndex >= filteredSuggestions.length)
            suggestionIndex = filteredSuggestions.length > 0 ? filteredSuggestions.length - 1 : -1
        _syncSuggestionPopup()
        _armSuggestionSync()
    }
    onFocusedChanged: {
        if (!focused)
            Qt.callLater(function () {
                if (!focused) {
                    suggestionOpen = false
                    suggestionIndex = -1
                }
            })
        else
            _syncSuggestionPopup()
    }
    onAutoCompleteChanged: _syncSuggestionPopup()
    onTextChanged: {
        if (autoComplete && focused) {
            // Typing resets highlight so Enter applies the top match unless arrows used
            if (suggestionIndex >= 0)
                suggestionIndex = -1
            _syncSuggestionPopup()
        }
    }

    implicitWidth: 280
    implicitHeight: (multiline ? Math.max(Md3Theme.fieldHeight, input.contentHeight + 32) : Md3Theme.fieldHeight)
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
        if (clearOnTrailing && (effectiveTrailingIcon === "close" || effectiveTrailingIcon === "clear")) {
            input.clear()
            trailingClicked()
            return
        }
        trailingClicked()
    }

    function _errorFeedback() {
        if (!errorFeedbackEnabled || !hasError)
            return
        if (!Md3Theme.reduceMotion) {
            shakeAnim.stop()
            shakeAnim.start()
        }
        if (announceErrors && typeof Md3Accessibility !== "undefined" && Md3Accessibility.announceError) {
            const msg = errorText.length ? errorText : qsTr("Invalid input")
            Md3Accessibility.announceError(msg)
        }
        const win = Window.window
        if (win && typeof win.hapticFeedback === "function"
                && typeof Md3WindowCapabilities !== "undefined"
                && Md3WindowCapabilities.hapticFeedback) {
            win.hapticFeedback(0)
        } else if (win && typeof win.vibrate === "function"
                   && typeof Md3WindowCapabilities !== "undefined"
                   && Md3WindowCapabilities.vibrate) {
            win.vibrate(28)
        }
    }

    onHasErrorChanged: {
        if (hasError)
            Qt.callLater(_errorFeedback)
    }

    Column {
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 4

        Item {
            id: fieldBox
            width: parent.width
            height: root.multiline ? Math.max(Md3Theme.fieldHeight, input.contentHeight + 32) : Md3Theme.fieldHeight
            transform: Translate { x: root._shakeX }

            SequentialAnimation {
                id: shakeAnim
                NumberAnimation {
                    target: root
                    property: "_shakeX"
                    to: root.errorShakePx
                    duration: Math.max(1, Math.round(root.errorShakeMs / 4))
                    easing.type: Easing.OutQuad
                }
                NumberAnimation {
                    target: root
                    property: "_shakeX"
                    to: -root.errorShakePx
                    duration: Math.max(1, Math.round(root.errorShakeMs / 2))
                    easing.type: Easing.InOutQuad
                }
                NumberAnimation {
                    target: root
                    property: "_shakeX"
                    to: 0
                    duration: Math.max(1, Math.round(root.errorShakeMs / 4))
                    easing.type: Easing.OutQuad
                }
            }

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
                        if (root.effectiveTrailingIcon.length === 0)
                            return false
                        if (root.effectiveTrailingIcon === "close" || root.effectiveTrailingIcon === "clear")
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
                    Keys.priority: Keys.BeforeItem
                    Keys.onPressed: function (event) {
                        if (!root.autoComplete)
                            return
                        if (event.key === Qt.Key_Down) {
                            root.moveSuggestionHighlight(1)
                            event.accepted = true
                        } else if (event.key === Qt.Key_Up) {
                            root.moveSuggestionHighlight(-1)
                            event.accepted = true
                        } else if (event.key === Qt.Key_Escape) {
                            if (root.suggestionOpen) {
                                root.suggestionOpen = false
                                root.suggestionIndex = -1
                                event.accepted = true
                            }
                        } else if (event.key === Qt.Key_Tab && root.suggestionOpen
                                   && root.suggestionIndex >= 0) {
                            root.applyHighlightedSuggestion()
                            event.accepted = true
                        }
                    }
                    onAccepted: {
                        if (root.applyHighlightedSuggestion())
                            return
                        if (root.hasError && root.announceErrors)
                            root._errorFeedback()
                        root.accepted()
                    }
                }

                Md3FocusRing {
                    anchors.fill: parent
                    anchors.margins: -3
                    radius: Md3Theme.shape.extraSmall
                    focused: input.activeFocus
                    controlEnabled: root.enabled
                    // Outlined already thickens its border on focus — a second outer ring looks like a double frame.
                    visualFocus: root.variant !== Md3TextField.Outlined
                                 && Md3Accessibility.showFocusRings && input.activeFocus
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

    // AutoComplete popup — reparented to window contentItem so it escapes clip.
    // Position synced explicitly: mapToItem bindings do not track Flickable scroll.
    property real _suggestionX: 0
    property real _suggestionY: 0

    function _suggestionHost() {
        return Md3OverlayHost.contentItem(root.overlayWindow, root) || root
    }

    function _syncSuggestionGeometry() {
        const host = _suggestionHost()
        suggestionPanel.parent = host
        suggestionPanel.width = Math.max(fieldBox.width, 160)
        if (host === root) {
            _suggestionX = 0
            _suggestionY = fieldBox.height + 4
            return
        }
        // Global round-trip is reliable across Flickable / custom chrome.
        const g = fieldBox.mapToGlobal(0, fieldBox.height + 4)
        const p = host.mapFromGlobal(g.x, g.y)
        let y = p.y
        const h = suggestionPanel.height
        if (host.height > 0 && y + h + 8 > host.height) {
            const gAbove = fieldBox.mapToGlobal(0, -h - 4)
            const above = host.mapFromGlobal(gAbove.x, gAbove.y)
            if (above.y >= 8)
                y = above.y
        }
        _suggestionX = p.x
        _suggestionY = y
    }

    function _armSuggestionSync() {
        if (suggestionOpen)
            Qt.callLater(_syncSuggestionGeometry)
    }

    property var _suggestionScrollHooks: []

    function _clearSuggestionScrollHooks() {
        const hooks = _suggestionScrollHooks || []
        for (let i = 0; i < hooks.length; ++i) {
            const t = hooks[i]
            if (!t)
                continue
            try {
                t.contentXChanged.disconnect(_armSuggestionSync)
                t.contentYChanged.disconnect(_armSuggestionSync)
            } catch (e) { /* already gone */ }
        }
        _suggestionScrollHooks = []
    }

    function _hookSuggestionScrollParents() {
        _clearSuggestionScrollHooks()
        const hooks = []
        let p = parent
        while (p) {
            if (p.contentX !== undefined && p.contentY !== undefined) {
                p.contentXChanged.connect(_armSuggestionSync)
                p.contentYChanged.connect(_armSuggestionSync)
                hooks.push(p)
            }
            p = p.parent
        }
        _suggestionScrollHooks = hooks
    }

    onSuggestionOpenChanged: {
        if (suggestionOpen) {
            _hookSuggestionScrollParents()
            Qt.callLater(_syncSuggestionGeometry)
        } else {
            _clearSuggestionScrollHooks()
        }
    }
    onWidthChanged: _armSuggestionSync()
    onHeightChanged: _armSuggestionSync()
    onXChanged: _armSuggestionSync()
    onYChanged: _armSuggestionSync()
    Component.onDestruction: _clearSuggestionScrollHooks()

    /// Window is not an Item — Connections needs contentItem.
    readonly property Item _windowContent: Window.window ? Window.window.contentItem : null

    Connections {
        target: root._windowContent
        enabled: root.suggestionOpen && root._windowContent
        function onWidthChanged() { root._armSuggestionSync() }
        function onHeightChanged() { root._armSuggestionSync() }
    }

    Rectangle {
        id: suggestionPanel
        visible: root.suggestionOpen && filteredList.count > 0
        width: Math.max(fieldBox.width, 160)
        height: Math.min(240, Math.max(48, filteredList.contentHeight + 8))
        x: root._suggestionX
        y: root._suggestionY
        radius: Md3Theme.shape.medium
        color: Md3Theme.colorScheme.surfaceContainerHigh
        border.width: 1
        border.color: Md3Theme.colorScheme.outlineVariant
        z: 10000

        Md3Shadow {
            anchors.fill: parent
            elevation: 2
            cornerRadius: parent.radius
        }

        ListView {
            id: filteredList
            anchors.fill: parent
            anchors.margins: 4
            clip: true
            model: root.filteredSuggestions
            spacing: 0
            currentIndex: root.suggestionIndex
            keyNavigationEnabled: false
            Accessible.role: Accessible.List
            Accessible.name: qsTr("建议")

            delegate: Item {
                required property var modelData
                required property int index
                width: filteredList.width
                height: 40

                readonly property bool highlighted: index === root.suggestionIndex
                        || (root.suggestionIndex < 0 && index === 0 && rowMouse.containsMouse)
                        || rowMouse.containsMouse

                Rectangle {
                    anchors.fill: parent
                    radius: Md3Theme.shape.small
                    color: {
                        if (index === root.suggestionIndex)
                            return Md3Theme.colorScheme.secondaryContainer
                        if (rowMouse.containsMouse)
                            return Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.colorOnSurface, 0.08)
                        return "transparent"
                    }
                }
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 12
                    anchors.right: parent.right
                    anchors.rightMargin: 12
                    text: root._suggestionLabel(modelData)
                    elide: Text.ElideRight
                    color: index === root.suggestionIndex
                           ? Md3Theme.colorScheme.colorOnSecondaryContainer
                           : Md3Theme.colorScheme.colorOnSurface
                    font.family: Md3Theme.typography.fontFamily
                    font.pixelSize: Md3Theme.typography.bodyLarge.size
                }
                MouseArea {
                    id: rowMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onEntered: root.suggestionIndex = index
                    onClicked: root.applySuggestion(modelData)
                }
                Accessible.role: Accessible.ListItem
                Accessible.name: root._suggestionLabel(modelData)
                Accessible.onPressAction: root.applySuggestion(modelData)
            }
        }
    }
}
