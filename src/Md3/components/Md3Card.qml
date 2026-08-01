import QtQuick
import Md3

Item {
    id: root

    enum Variant { Elevated, Filled, Outlined }

    property int variant: Md3Card.Elevated
    // Use Item.enabled (do not redeclare — Qt 6.11 warns on override)
    property bool clickable: false
    property real padding: Md3Theme.spacingLg
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
    // HeightSync AtLeastImplicit raises unset height for Column; does not fight explicit height.
    implicitWidth: Math.max(280, contentHost.contentImplicitWidth + padding * 2)
    implicitHeight: contentHost.contentImplicitHeight + padding * 2
    readonly property Md3HeightSync _heightSync: Md3HeightSync {
        target: root
        enabled: !root.anchors.fill
        policy: Md3HeightSync.AtLeastImplicit
    }

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

    Accessible.role: Accessible.Pane
    Accessible.name: title.length ? title : qsTr("Card")

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
            // Break contentHost ↔ root.implicitHeight feedback when auto-sized.
            height: {
                const autoSized = Math.abs(root.height - root.implicitHeight) <= 1.5
                if (!autoSized && root.height >= root.padding * 2 + 1)
                    return root.height - root.padding * 2
                return implicitHeight
            }

            Md3VStack {
                id: cardStack
                width: parent.width
                // Prefer ContainerBody viewport height when the card is explicitly sized.
                // Parent of this VStack is ContainerBody's inner Item (often height 0);
                // expand children need a real stack height or lists/grids stay empty.
                height: {
                    const viewport = contentHost.height
                    const autoSized = Math.abs(root.height - root.implicitHeight) <= 1.5
                    if (!autoSized && viewport > 1)
                        return viewport
                    return implicitHeight
                }
                spacing: 8
                fillWidth: true

                // HStack (not Row): expand title column; avoid Row+verticalCenter polish issues.
                Md3HStack {
                    id: headerRow
                    visible: root.hasHeader
                    width: parent.width
                    spacing: 8
                    alignment: Md3HStack.Center

                    Column {
                        id: headerTitles
                        property bool expand: true
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
                        width: Math.max(1, childrenRect.width)
                        height: Math.max(childrenRect.height, 24)
                    }

                    Row {
                        id: actionsRow
                        visible: root.actions && root.actions.length > 0
                        spacing: 4
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
                    /// Measured without binding to childrenRect (avoids implicit size loops).
                    property real contentHeight: 0
                    property bool _measureGuard: false
                    readonly property real fillFallback: 160
                    readonly property bool hasFillChild: {
                        void children.length
                        const kids = children
                        for (let i = 0; i < kids.length; ++i) {
                            const c = kids[i]
                            if (!c || c.visible === false || !c.anchors)
                                continue
                            if (c.anchors.fill)
                                return true
                            if (c.anchors.top && c.anchors.bottom
                                    && c.anchors.top === bodySlot.top
                                    && c.anchors.bottom === bodySlot.bottom)
                                return true
                        }
                        return false
                    }
                    /// VStack expand: fill leftover when card is explicitly sized.
                    property bool expand: hasFillChild

                    // Width is always parent-driven; never bind implicitWidth to width/childrenRect.
                    implicitWidth: 1
                    implicitHeight: hasFillChild ? fillFallback : contentHeight
                    readonly property Md3HeightSync _heightSync: Md3HeightSync {
                        target: bodySlot
                        enabled: !bodySlot.hasFillChild
                        policy: Md3HeightSync.Exact
                    }

                    function _syncFromChildrenRect() {
                        if (_measureGuard || hasFillChild)
                            return
                        _measureGuard = true
                        contentHeight = Math.max(0, childrenRect.height)
                        _measureGuard = false
                    }

                    onChildrenChanged: Qt.callLater(_syncFromChildrenRect)
                    onChildrenRectChanged: Qt.callLater(_syncFromChildrenRect)
                    onWidthChanged: Qt.callLater(_syncFromChildrenRect)
                    onHasFillChildChanged: {
                        if (hasFillChild)
                            contentHeight = fillFallback
                        else
                            Qt.callLater(_syncFromChildrenRect)
                    }
                    Component.onCompleted: Qt.callLater(_syncFromChildrenRect)
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
