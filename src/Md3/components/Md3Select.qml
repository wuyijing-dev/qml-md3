import QtQuick

/// Field-style select (ComboBox): label, helper/error, menu — aligned with Md3TextField.
/// Supports searchable filtering and multi-select.
Item {
    id: root

    enum Variant { Filled, Outlined }

    property int variant: Md3Select.Outlined
    property string label: ""
    property string placeholderText: ""
    /// string[] or [{ text, icon?, value? }]
    property var model: []
    property int currentIndex: -1
    /// Multi-select indices into `model` (used when multiSelect is true).
    property var selectedIndices: []
    property string supportingText: ""
    property string errorText: ""
    property bool error: false
    property bool enabled: true
    property string leadingIcon: ""
    property string accessibleName: ""
    property bool searchable: false
    property bool multiSelect: false
    property string searchPlaceholder: qsTr("Search")
    property int suggestionLimit: 0 // 0 = unlimited

    signal activated(int index)
    signal selectionChanged()
    signal opened()
    signal closed()

    readonly property bool hasError: error || errorText.length > 0
    readonly property string helper: hasError ? (errorText.length ? errorText : supportingText) : supportingText
    readonly property color activeColor: hasError ? Md3Theme.colorScheme.error : Md3Theme.colorScheme.primary
    readonly property bool open: menu.open
    readonly property bool floated: open || hasSelection || placeholderText.length === 0
    readonly property bool hasSelection: multiSelect
                                         ? (selectedIndices && selectedIndices.length > 0)
                                         : currentIndex >= 0

    readonly property var currentItem: {
        if (multiSelect)
            return null
        if (currentIndex < 0 || !model || currentIndex >= model.length)
            return null
        return model[currentIndex]
    }

    readonly property string displayText: {
        if (multiSelect) {
            const sel = selectedIndices || []
            if (sel.length === 0)
                return ""
            if (sel.length === 1)
                return itemLabel(model[sel[0]])
            return qsTr("%1 selected").arg(sel.length)
        }
        const m = currentItem
        if (!m)
            return ""
        return itemLabel(m)
    }

    readonly property var currentValue: {
        if (multiSelect) {
            const out = []
            const sel = selectedIndices || []
            for (let i = 0; i < sel.length; ++i) {
                const m = model[sel[i]]
                if (m === undefined || m === null)
                    continue
                if (typeof m === "string")
                    out.push(m)
                else if (m.value !== undefined)
                    out.push(m.value)
                else if (m.text !== undefined)
                    out.push(m.text)
                else
                    out.push(m)
            }
            return out
        }
        const m = currentItem
        if (!m)
            return undefined
        if (typeof m === "string")
            return m
        if (m.value !== undefined)
            return m.value
        if (m.text !== undefined)
            return m.text
        return m
    }

    readonly property var filteredEntries: {
        const src = model || []
        const q = searchable ? String(searchField.text || "").trim().toLowerCase() : ""
        const out = []
        for (let i = 0; i < src.length; ++i) {
            const label = itemLabel(src[i]).toLowerCase()
            if (q.length === 0 || label.indexOf(q) >= 0)
                out.push({ index: i, item: src[i] })
            if (suggestionLimit > 0 && out.length >= suggestionLimit)
                break
        }
        return out
    }

    implicitWidth: 280
    implicitHeight: 56 + (helper.length > 0 ? 20 : 0)
    width: implicitWidth
    height: implicitHeight
    activeFocusOnTab: enabled
    Accessible.name: accessibleName.length ? accessibleName : (label.length ? label : qsTr("Select"))
    Accessible.role: Accessible.ComboBox
    Accessible.description: helper

    function itemLabel(m) {
        if (m === undefined || m === null)
            return ""
        if (typeof m === "string")
            return m
        if (m.text !== undefined)
            return String(m.text)
        if (m.label !== undefined)
            return String(m.label)
        return String(m)
    }

    function itemIcon(m) {
        if (m && m.icon !== undefined)
            return String(m.icon)
        return ""
    }

    function isIndexSelected(index) {
        if (multiSelect) {
            const sel = selectedIndices || []
            return sel.indexOf(index) >= 0
        }
        return currentIndex === index
    }

    function toggleIndex(index) {
        if (multiSelect) {
            const sel = (selectedIndices || []).slice()
            const at = sel.indexOf(index)
            if (at >= 0)
                sel.splice(at, 1)
            else
                sel.push(index)
            selectedIndices = sel
            selectionChanged()
            activated(index)
        } else {
            currentIndex = index
            activated(index)
            menu.dismiss()
        }
    }

    function toggle() {
        if (!enabled)
            return
        if (menu.open)
            menu.dismiss()
        else
            openMenu()
    }

    function openMenu() {
        if (!enabled)
            return
        if (searchable)
            searchField.text = ""
        const p = field.mapToItem(null, 0, field.height + 4)
        menu.menuWidth = field.width
        menu.popup(p.x, p.y)
        root.opened()
        if (searchable)
            Qt.callLater(function () { searchField.forceActiveFocus() })
    }

    function clear() {
        if (multiSelect) {
            selectedIndices = []
            selectionChanged()
        } else {
            currentIndex = -1
        }
    }

    Column {
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 4

        Rectangle {
            id: field
            width: parent.width
            height: 56
            radius: Md3Theme.shape.extraSmall
            color: root.variant === Md3Select.Filled
                   ? Md3Theme.colorScheme.surfaceContainerHighest
                   : "transparent"
            border.width: root.variant === Md3Select.Outlined
                          ? (menu.open || mouse.containsMouse || root.hasError ? 2 : 1) : 0
            border.color: {
                if (!root.enabled)
                    return Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.colorOnSurface, 0.12)
                if (root.hasError)
                    return Md3Theme.colorScheme.error
                if (menu.open)
                    return root.activeColor
                return Md3Theme.colorScheme.outline
            }

            Rectangle {
                visible: root.variant === Md3Select.Filled
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: menu.open || root.hasError ? 2 : 1
                color: {
                    if (!root.enabled)
                        return Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.colorOnSurface, 0.38)
                    if (root.hasError)
                        return Md3Theme.colorScheme.error
                    if (menu.open)
                        return root.activeColor
                    return Md3Theme.colorScheme.colorOnSurfaceVariant
                }
            }

            Md3StateOverlay {
                overlayColor: Md3Theme.colorScheme.colorOnSurface
                hovered: mouse.containsMouse
                pressed: mouse.pressed
                controlEnabled: root.enabled
                radius: field.radius
            }

            Text {
                id: labelItem
                text: root.label
                visible: root.label.length > 0
                x: root.leadingIcon.length > 0 ? 48 : 16
                y: (root.displayText.length > 0 || menu.open || root.placeholderText.length > 0)
                        ? 6 : (parent.height - height) / 2
                z: 2
                color: menu.open || root.hasError ? root.activeColor
                       : Md3Theme.colorScheme.colorOnSurfaceVariant
                font.family: Md3Theme.typography.fontFamily
                font.pixelSize: (root.displayText.length > 0 || menu.open || root.placeholderText.length > 0)
                                ? Md3Theme.typography.labelSmall.size
                                : Md3Theme.typography.bodyLarge.size
                font.weight: Font.Medium

                Rectangle {
                    visible: root.variant === Md3Select.Outlined
                             && (root.displayText.length > 0 || menu.open || root.placeholderText.length > 0)
                    anchors.centerIn: parent
                    width: parent.width + 8
                    height: 6
                    color: Md3Theme.colorScheme.surface
                    z: -1
                }
            }

            Row {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 8
                anchors.topMargin: root.label.length > 0 ? 18 : 0
                spacing: 12

                Md3Icon {
                    visible: root.leadingIcon.length > 0
                    icon: root.leadingIcon
                    size: 24
                    iconColor: root.enabled ? Md3Theme.colorScheme.colorOnSurfaceVariant
                                            : Md3Theme.colorScheme.disabledContent()
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width - (root.leadingIcon.length > 0 ? 36 : 0) - 40
                    text: root.displayText.length > 0 ? root.displayText : root.placeholderText
                    elide: Text.ElideRight
                    color: {
                        if (!root.enabled)
                            return Md3Theme.colorScheme.disabledContent()
                        if (root.displayText.length === 0)
                            return Md3Theme.colorScheme.colorOnSurfaceVariant
                        return Md3Theme.colorScheme.colorOnSurface
                    }
                    font.family: Md3Theme.typography.fontFamily
                    font.pixelSize: Md3Theme.typography.bodyLarge.size
                    opacity: (root.displayText.length > 0 || root.placeholderText.length > 0
                              || root.label.length === 0) ? 1 : 0
                }

                Md3Icon {
                    icon: "expand_more"
                    size: 24
                    iconColor: root.enabled ? Md3Theme.colorScheme.colorOnSurfaceVariant
                                            : Md3Theme.colorScheme.disabledContent()
                    anchors.verticalCenter: parent.verticalCenter
                    rotation: menu.open ? 180 : 0
                    Behavior on rotation {
                        NumberAnimation {
                            duration: Md3Motion.spatialSnapDuration
                            easing.type: Easing.BezierSpline
                            easing.bezierCurve: Md3Motion.emphasized
                        }
                    }
                }
            }

            MouseArea {
                id: mouse
                anchors.fill: parent
                hoverEnabled: true
                enabled: root.enabled
                cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                onClicked: root.toggle()
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

    Md3Menu {
        id: menu
        modal: true
        onOpenChanged: {
            if (!open)
                root.closed()
        }

        Item {
            visible: root.searchable
            width: Math.max(menu.menuWidth, 168)
            height: visible ? 52 : 0

            Rectangle {
                anchors.fill: parent
                anchors.leftMargin: 8
                anchors.rightMargin: 8
                anchors.topMargin: 4
                anchors.bottomMargin: 4
                radius: Md3Theme.shape.extraSmall
                color: Md3Theme.colorScheme.surfaceContainerHighest

                Row {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    spacing: 8

                    Md3Icon {
                        anchors.verticalCenter: parent.verticalCenter
                        icon: "search"
                        size: 20
                        iconColor: Md3Theme.colorScheme.colorOnSurfaceVariant
                    }

                    TextInput {
                        id: searchField
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width - 36
                        height: parent.height
                        verticalAlignment: TextInput.AlignVCenter
                        color: Md3Theme.colorScheme.colorOnSurface
                        font.family: Md3Theme.typography.fontFamily
                        font.pixelSize: Md3Theme.typography.bodyMedium.size
                        selectByMouse: true
                        clip: true

                        Text {
                            anchors.fill: parent
                            verticalAlignment: Text.AlignVCenter
                            visible: !searchField.text.length && !searchField.activeFocus
                            text: root.searchPlaceholder
                            color: Md3Theme.colorScheme.colorOnSurfaceVariant
                            font: searchField.font
                        }
                    }
                }
            }
        }

        Md3MenuDivider { visible: root.searchable }

        Repeater {
            model: root.filteredEntries
            Md3MenuItem {
                required property int index
                required property var modelData
                width: Math.max(menu.menuWidth, 168)
                text: root.itemLabel(modelData.item)
                icon: root.itemIcon(modelData.item)
                selected: root.isIndexSelected(modelData.index)
                showCheck: true
                leadingCheck: root.multiSelect
                onClicked: root.toggleIndex(modelData.index)
            }
        }

        Item {
            visible: root.multiSelect && root.hasSelection
            width: Math.max(menu.menuWidth, 168)
            height: visible ? 48 : 0
            Md3MenuDivider { anchors.top: parent.top; width: parent.width }
            Md3Button {
                anchors.centerIn: parent
                text: qsTr("Done")
                variant: Md3Button.Text
                onClicked: menu.dismiss()
            }
        }

        Text {
            visible: root.searchable && root.filteredEntries.length === 0
            width: Math.max(menu.menuWidth, 168)
            height: 48
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: qsTr("No matches")
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.family: Md3Theme.typography.fontFamily
            font.pixelSize: Md3Theme.typography.bodyMedium.size
        }
    }
}
