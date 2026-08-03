import QtQuick
import QtQuick.Layouts
import Md3

/// Spotlight-style command palette (Ctrl+K).
/// model: [{ title, subtitle?, icon?, section?, visibleWhen?, id? }] or plain strings.
Item {
    id: root

    property bool open: false
    property string placeholder: qsTr("Type a command…")
    property var model: []
    property int maxResults: 12
    /// When true, insert section headers from item.section.
    property bool groupBySection: true
    /// Depend so app models that read ``Md3I18n.revision`` rebuild after language change.
    readonly property int localeRevision: Md3I18n.revision

    signal activated(var item)
    signal closed()

    anchors.fill: parent
    visible: open || panel.opacity > 0.01 || scrim.opacity > 0.01
    z: 4000
    Accessible.role: Accessible.Dialog
    Accessible.name: placeholder.length ? placeholder : qsTr("Command palette")

    property string query: ""
    property int highlightIndex: 0
    property var _focusBeforeOpen: null

    readonly property var filtered: {
        void root.localeRevision
        if (!open)
            return []
        const q = String(query || "").trim().toLowerCase()
        const src = model || []
        const out = []
        let lastSection = ""
        for (let i = 0; i < src.length; ++i) {
            const it = src[i]
            if (!it)
                continue
            if (typeof it !== "string" && it.visibleWhen === false)
                continue
            if (typeof it !== "string" && typeof it.visibleWhen === "function" && !it.visibleWhen())
                continue
            const title = typeof it === "string" ? it : String(it.title || "")
            const sub = typeof it === "string" ? "" : String(it.subtitle || "")
            if (q.length && title.toLowerCase().indexOf(q) < 0
                    && sub.toLowerCase().indexOf(q) < 0)
                continue
            const row = typeof it === "string"
                        ? { title: it, subtitle: "", icon: "chevron_right", section: "" }
                        : it
            if (groupBySection && row.section !== undefined) {
                const sec = String(row.section || "")
                if (sec.length && sec !== lastSection) {
                    out.push({ _sectionHeader: true, title: sec })
                    lastSection = sec
                    if (out.length >= maxResults)
                        break
                }
            }
            out.push(row)
            if (out.length >= maxResults)
                break
        }
        return out
    }

    onOpenChanged: {
        if (open) {
            query = ""
            highlightIndex = 0
            const win = Md3OverlayHost.resolveWindow(null, root)
            if (win && win.activeFocusItem)
                _focusBeforeOpen = win.activeFocusItem
            Qt.callLater(function () { searchField.forceActiveFocus() })
        } else {
            const prev = _focusBeforeOpen
            _focusBeforeOpen = null
            if (prev && typeof prev.forceActiveFocus === "function") {
                Qt.callLater(function () {
                    try { prev.forceActiveFocus() } catch (e) { /* destroyed */ }
                })
            }
            closed()
        }
    }

    onFilteredChanged: {
        if (highlightIndex >= filtered.length)
            highlightIndex = Math.max(0, filtered.length - 1)
    }

    function dismiss() {
        open = false
    }

    function activateIndex(i) {
        if (i < 0 || i >= filtered.length)
            return
        const it = filtered[i]
        if (it && it._sectionHeader)
            return
        activated(it)
        dismiss()
    }

    function moveHighlight(delta) {
        if (filtered.length === 0)
            return
        let next = highlightIndex
        for (let n = 0; n < filtered.length; ++n) {
            next = (next + delta + filtered.length) % filtered.length
            if (!filtered[next] || !filtered[next]._sectionHeader) {
                highlightIndex = next
                break
            }
        }
        if (list.count > 0)
            list.positionViewAtIndex(highlightIndex, ListView.Contain)
    }

    onHighlightIndexChanged: {
        if (open && list.count > 0)
            list.positionViewAtIndex(highlightIndex, ListView.Contain)
    }

    Rectangle {
        id: scrim
        anchors.fill: parent
        color: Md3Theme.colorScheme.scrim
        opacity: root.open ? 0.4 : 0
        Behavior on opacity {
            NumberAnimation {
                duration: Md3Motion.overlayDuration
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Md3Motion.standard
            }
        }
        MouseArea {
            anchors.fill: parent
            enabled: root.open
            cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
            onClicked: root.dismiss()
        }
    }

    Md3Shadow {
        anchors.fill: panel
        elevation: root.open ? 3 : 0
        cornerRadius: Md3Theme.shape.extraLarge
        opacity: panel.opacity
    }

    Rectangle {
        id: panel
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: Math.max(48, parent.height * 0.12)
        width: Math.min(560, parent.width - 48)
        height: Math.min(column.implicitHeight, parent.height * 0.7)
        radius: Md3Theme.shape.extraLarge
        color: Md3Theme.colorScheme.surfaceContainerHigh
        opacity: root.open ? 1 : 0
        scale: root.open ? 1 : 0.96
        transformOrigin: Item.Top

        Behavior on opacity {
            NumberAnimation {
                duration: Md3Motion.overlayDuration
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Md3Motion.standard
            }
        }
        Behavior on scale {
            NumberAnimation {
                duration: Md3Motion.menuDuration
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Md3Motion.emphasizedDecelerate
            }
        }

        Column {
            id: column
            width: parent.width
            spacing: 0

            Item {
                width: parent.width
                height: 56

                Md3Icon {
                    id: searchIcon
                    anchors.left: parent.left
                    anchors.leftMargin: 16
                    anchors.verticalCenter: parent.verticalCenter
                    icon: "search"
                    size: 22
                    iconColor: Md3Theme.colorScheme.colorOnSurfaceVariant
                }

                TextInput {
                    id: searchField
                    anchors.left: searchIcon.right
                    anchors.leftMargin: 12
                    anchors.right: parent.right
                    anchors.rightMargin: 16
                    anchors.verticalCenter: parent.verticalCenter
                    height: 28
                    color: Md3Theme.colorScheme.colorOnSurface
                    font.family: Md3Theme.typography.fontFamily
                    font.pixelSize: Md3Theme.typography.bodyLarge.size
                    selectedTextColor: Md3Theme.colorScheme.colorOnPrimary
                    selectionColor: Md3Theme.colorScheme.primary
                    clip: true
                    text: root.query
                    onTextChanged: {
                        if (root.query !== text)
                            root.query = text
                        root.highlightIndex = 0
                    }
                    Keys.onPressed: function (event) {
                        if (event.key === Qt.Key_Escape) {
                            root.dismiss()
                            event.accepted = true
                        } else if (event.key === Qt.Key_Down) {
                            root.moveHighlight(1)
                            event.accepted = true
                        } else if (event.key === Qt.Key_Up) {
                            root.moveHighlight(-1)
                            event.accepted = true
                        } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            root.activateIndex(root.highlightIndex)
                            event.accepted = true
                        }
                    }
                }

                Text {
                    anchors.fill: searchField
                    visible: searchField.text.length === 0
                    text: root.placeholder
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font: searchField.font
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Md3Divider { width: parent.width }

            ListView {
                id: list
                width: parent.width
                height: Math.min(contentHeight, 360)
                clip: true
                model: root.filtered
                currentIndex: root.highlightIndex
                boundsBehavior: Flickable.StopAtBounds

                delegate: Item {
                    id: del
                    required property int index
                    required property var modelData
                    readonly property bool isSection: !!(modelData && modelData._sectionHeader)
                    width: list.width
                    height: isSection ? 32 : 52

                    Rectangle {
                        anchors.fill: parent
                        anchors.leftMargin: 8
                        anchors.rightMargin: 8
                        anchors.topMargin: 2
                        anchors.bottomMargin: 2
                        radius: Md3Theme.shape.small
                        visible: !del.isSection
                        color: index === root.highlightIndex
                               ? Md3Theme.colorScheme.secondaryContainer
                               : "transparent"
                        Behavior on color {
                            enabled: !Md3Theme.reduceMotion
                            ColorAnimation {
                                duration: Md3Motion.short2
                                easing.type: Easing.BezierSpline
                                easing.bezierCurve: Md3Motion.standard
                            }
                        }
                    }

                    Text {
                        visible: del.isSection
                        anchors.fill: parent
                        anchors.leftMargin: 20
                        anchors.rightMargin: 20
                        text: String(modelData.title || "")
                        color: Md3Theme.colorScheme.colorOnSurfaceVariant
                        font.family: Md3Theme.typography.fontFamily
                        font.pixelSize: Md3Theme.typography.labelMedium.size
                        font.weight: Font.DemiBold
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }

                    RowLayout {
                        visible: !del.isSection
                        anchors.fill: parent
                        anchors.leftMargin: 20
                        anchors.rightMargin: 20
                        spacing: 12

                        Md3Icon {
                            icon: modelData.icon && String(modelData.icon).length
                                  ? String(modelData.icon) : "chevron_right"
                            size: 20
                            iconColor: index === root.highlightIndex
                                       ? Md3Theme.colorScheme.colorOnSecondaryContainer
                                       : Md3Theme.colorScheme.colorOnSurfaceVariant
                        }
                        Column {
                            Layout.fillWidth: true
                            spacing: 2
                            Text {
                                width: parent.width
                                text: String(modelData.title || "")
                                elide: Text.ElideRight
                                color: index === root.highlightIndex
                                       ? Md3Theme.colorScheme.colorOnSecondaryContainer
                                       : Md3Theme.colorScheme.colorOnSurface
                                font.family: Md3Theme.typography.fontFamily
                                font.pixelSize: Md3Theme.typography.bodyLarge.size
                            }
                            Text {
                                visible: modelData.subtitle && String(modelData.subtitle).length
                                width: parent.width
                                text: String(modelData.subtitle || "")
                                elide: Text.ElideRight
                                color: Md3Theme.colorScheme.colorOnSurfaceVariant
                                font.family: Md3Theme.typography.fontFamily
                                font.pixelSize: Md3Theme.typography.bodySmall.size
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        enabled: !del.isSection
                        hoverEnabled: true
                        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                        onEntered: root.highlightIndex = index
                        onClicked: root.activateIndex(index)
                    }
                }
            }

            Item {
                visible: root.filtered.length === 0
                width: parent.width
                height: 72
                Text {
                    anchors.centerIn: parent
                    text: qsTr("No matching commands")
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.family: Md3Theme.typography.fontFamily
                    font.pixelSize: Md3Theme.typography.bodyMedium.size
                }
            }
        }
    }
}
