import QtQuick

Item {
    id: root

    enum Variant { Elevated, Filled, Outlined }

    property int variant: Md3Card.Elevated
    // Use Item.enabled (do not redeclare — Qt 6.11 warns on override)
    property bool clickable: false
    property real padding: 16
    property int layoutMode: Md3ContainerBody.Fit
    /// Optional header — when set, users need not nest title Text manually.
    property string title: ""
    property string subtitle: ""
    /// Trailing controls in the header row (e.g. Md3Button).
    property alias headerTrailing: headerTrailingSlot.data
    /// [{ text, icon?, variant? }] — compact header actions without Row glue.
    property var actions: []
    default property alias content: bodySlot.data

    signal clicked()
    signal actionClicked(int index)

    // Intrinsic only — never bind width/height to implicit* (Layout + fill children loop).
    implicitWidth: Math.max(280, contentHost.contentImplicitWidth + padding * 2)
    implicitHeight: contentHost.contentImplicitHeight + padding * 2

    readonly property real elev: variant === Md3Card.Elevated ? 1 : 0
    readonly property bool hasHeader: title.length > 0 || subtitle.length > 0
                                      || headerTrailingSlot.children.length > 0
                                      || (actions && actions.length > 0)
    readonly property color containerColor: {
        switch (variant) {
        case Md3Card.Filled: return Md3Theme.colorScheme.surfaceContainerHighest
        case Md3Card.Outlined: return Md3Theme.colorScheme.surface
        default: return Md3Theme.colorScheme.surfaceContainerLow
        }
    }

    function _actionVariant(e) {
        if (!e || e.variant === undefined)
            return Md3Button.Outlined
        if (typeof e.variant === "number")
            return e.variant
        const s = String(e.variant).toLowerCase()
        if (s === "filled" || s === "fill")
            return Md3Button.Filled
        if (s === "tonal" || s === "filledtonal")
            return Md3Button.FilledTonal
        if (s === "text")
            return Md3Button.Text
        return Md3Button.Outlined
    }

    Md3Shadow {
        anchors.fill: bg
        elevation: root.elev
        cornerRadius: Md3Theme.shape.medium
    }

    Rectangle {
        id: bg
        anchors.fill: parent
        radius: Md3Theme.shape.medium
        color: root.containerColor
        border.width: root.variant === Md3Card.Outlined ? 1 : 0
        border.color: Md3Theme.colorScheme.outlineVariant
        clip: true

        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: Md3Theme.colorScheme.surfaceTint
            opacity: Md3Theme.elevation.tintOpacity(root.elev)
            visible: root.elev > 0
        }

        Md3StateOverlay {
            visible: root.clickable
            overlayColor: Md3Theme.colorScheme.colorOnSurface
            hovered: mouse.containsMouse
            pressed: mouse.pressed
            controlEnabled: root.enabled && root.clickable
            radius: bg.radius
        }

        Md3ContainerBody {
            id: contentHost
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: root.padding
            layoutMode: root.layoutMode
            height: root.height >= root.padding * 2 + 1
                    ? root.height - root.padding * 2
                    : implicitHeight

            Md3VStack {
                width: parent.width
                spacing: 8
                fillWidth: true

                Row {
                    id: headerRow
                    visible: root.hasHeader
                    width: parent.width
                    spacing: 8

                    Column {
                        width: Math.max(40, parent.width
                                        - headerTrailingSlot.width
                                        - actionsRow.width
                                        - (headerTrailingSlot.visible ? parent.spacing : 0)
                                        - (actionsRow.visible ? parent.spacing : 0))
                        spacing: 2
                        Md3Text {
                            visible: root.title.length > 0
                            width: parent.width
                            text: root.title
                            role: Md3Text.TitleMedium
                            wrapMode: Text.WordWrap
                        }
                        Md3Text {
                            visible: root.subtitle.length > 0
                            width: parent.width
                            text: root.subtitle
                            role: Md3Text.BodyMedium
                            tone: Md3Text.OnSurfaceVariant
                            wrapMode: Text.WordWrap
                        }
                    }

                    Item {
                        id: headerTrailingSlot
                        visible: children.length > 0
                        width: childrenRect.width
                        height: Math.max(childrenRect.height, 24)
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Row {
                        id: actionsRow
                        visible: root.actions && root.actions.length > 0
                        spacing: 4
                        anchors.verticalCenter: parent.verticalCenter
                        Repeater {
                            model: root.actions
                            Md3Button {
                                required property int index
                                required property var modelData
                                text: modelData.text !== undefined ? String(modelData.text) : String(modelData)
                                icon: modelData.icon !== undefined ? String(modelData.icon) : ""
                                variant: root._actionVariant(modelData)
                                onClicked: root.actionClicked(index)
                            }
                        }
                    }
                }

                Item {
                    id: bodySlot
                    width: parent.width
                    // Fill-anchored children (common for tables/lists) cannot drive
                    // height via childrenRect — that collapses to 0. Expand to the
                    // remaining card body height instead.
                    readonly property bool hasFillChild: {
                        void children.length
                        const kids = children
                        for (let i = 0; i < kids.length; ++i) {
                            const c = kids[i]
                            if (!c || c.visible === false || !c.anchors)
                                continue
                            if (c.anchors.fill === bodySlot)
                                return true
                            if (c.anchors.top === bodySlot.top && c.anchors.bottom === bodySlot.bottom)
                                return true
                        }
                        return false
                    }
                    height: {
                        if (hasFillChild && root.height > root.padding * 2 + 1) {
                            const headerH = headerRow.visible ? (headerRow.height + 8) : 0
                            return Math.max(1, contentHost.height - headerH)
                        }
                        return childrenRect.height
                    }
                    implicitHeight: hasFillChild ? Math.max(48, childrenRect.height) : childrenRect.height
                    implicitWidth: childrenRect.width
                }
            }
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        enabled: root.clickable && root.enabled
        hoverEnabled: true
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: root.clicked()
    }
}
