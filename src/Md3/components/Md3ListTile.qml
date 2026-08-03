import QtQuick
import Md3

/// List tile with optional trailing action icons and overflow (narrow panes).
Md3AbstractButton {
    id: root

    property string title: ""
    property string subtitle: ""
    property string supportingText: ""
    property string leadingIcon: ""
    property string trailingIcon: ""
    property string leadingAvatar: ""
    property url leadingAvatarSource: ""
    property real trailingRotation: 0
    property bool selected: false
    property bool showDivider: false
    property bool fillWidth: true
    property alias leading: leadingSlot.data
    property alias trailing: trailingSlot.data
    /// [{ icon, text?, enabled?, accessibleName? }] — icons to the right of title.
    property var trailingActions: []
    /// Max icons before collapsing into overflow menu (0 = show all).
    property int maxVisibleTrailingActions: 0
    property bool trailingOverflowEnabled: true
    property string trailingOverflowIcon: "more_vert"

    signal trailingClicked()
    signal trailingActionClicked(int index)

    readonly property int lines: {
        if (supportingText.length > 0)
            return 3
        if (subtitle.length > 0)
            return 2
        return 1
    }
    readonly property real minH: {
        const compact = Md3Theme.densityCompact
        if (lines === 1)
            return compact ? 48 : 56
        if (lines === 2)
            return compact ? 64 : 72
        return compact ? 80 : 88
    }
    readonly property bool hasTrailingSlot: trailingSlot.children.length > 0
    readonly property bool hasLeadingSlot: leadingSlot.children.length > 0
    readonly property bool hasLeadingAvatar: leadingAvatar.length > 0
                                               || (leadingAvatarSource && String(leadingAvatarSource).length > 0)
    readonly property int _actionCount: trailingActions && trailingActions.length ? trailingActions.length : 0
    readonly property bool _actionsOverflow: {
        if (!trailingOverflowEnabled || maxVisibleTrailingActions <= 0 || _actionCount <= maxVisibleTrailingActions)
            return false
        return _actionCount > maxVisibleTrailingActions
    }
    readonly property int _visibleActionCount: _actionsOverflow ? Math.max(0, maxVisibleTrailingActions)
                                                                : _actionCount

    implicitHeight: Math.max(minH, col.implicitHeight + 16)
    implicitWidth: 320
    height: implicitHeight
    property bool _densityHeightAnim: false
    Behavior on height {
        enabled: !Md3Theme.reduceMotion && root._densityHeightAnim
        NumberAnimation {
            duration: Md3Motion.medium2
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Md3Motion.standard
        }
    }
    Connections {
        target: Md3Theme
        function onDensityChanged() {
            root._densityHeightAnim = true
            densityAnimGate.restart()
        }
    }
    Timer {
        id: densityAnimGate
        interval: Md3Motion.medium2 + 40
        onTriggered: root._densityHeightAnim = false
    }
    width: fillWidth && parent ? parent.width : implicitWidth
    accessibleName: title
    accessibleRole: Accessible.ListItem

    Rectangle {
        id: bg
        anchors.fill: parent
        color: root.selected ? Md3Theme.colorScheme.secondaryContainer : "transparent"
        Md3StateOverlay {
            overlayColor: root.selected ? Md3Theme.colorScheme.colorOnSecondaryContainer
                                        : Md3Theme.colorScheme.colorOnSurface
            hovered: root.hovered
            focused: root.activeFocus && root.visualFocus
            pressed: root.pressed
            controlEnabled: root.enabled
        }
    }

    pressTarget: bg
    pressRightMargin: {
        if (root.hasTrailingSlot)
            return trailingSlot.width + 16
        if (root._actionCount > 0)
            return actionsHost.width + 16
        if (root.trailingIcon.length > 0)
            return 40
        return 0
    }
    onPressFeedback: function (x, y) { }

    function _actionIcon(e) {
        if (!e)
            return "more_horiz"
        if (e.icon !== undefined)
            return String(e.icon)
        return "more_horiz"
    }

    function _actionLabel(e, i) {
        if (!e)
            return qsTr("Action %1").arg(i + 1)
        if (e.text !== undefined && String(e.text).length)
            return String(e.text)
        if (e.accessibleName !== undefined && String(e.accessibleName).length)
            return String(e.accessibleName)
        return _actionIcon(e)
    }

    function _overflowModel() {
        const out = []
        for (let i = root._visibleActionCount; i < root._actionCount; ++i) {
            const e = root.trailingActions[i]
            out.push({
                text: root._actionLabel(e, i),
                enabled: !e || e.enabled !== false,
                _index: i
            })
        }
        return out
    }

    Row {
        anchors.fill: parent
        anchors.leftMargin: 16
        anchors.rightMargin: 16
        spacing: 16

        Item {
            id: leadingSlot
            visible: root.hasLeadingSlot
            width: childrenRect.width
            height: Math.max(childrenRect.height, 24)
            anchors.verticalCenter: parent.verticalCenter
        }

        Md3Avatar {
            visible: !root.hasLeadingSlot && root.hasLeadingAvatar
            initials: root.leadingAvatar
            source: root.leadingAvatarSource
            sizePreset: Md3Avatar.Small
            anchors.verticalCenter: parent.verticalCenter
        }

        Md3Icon {
            visible: !root.hasLeadingSlot && !root.hasLeadingAvatar && root.leadingIcon.length > 0
            icon: root.leadingIcon
            size: 24
            iconColor: root.enabled ? Md3Theme.colorScheme.colorOnSurfaceVariant
                                    : Md3Theme.colorScheme.disabledContent()
            anchors.verticalCenter: parent.verticalCenter
        }

        Column {
            id: col
            anchors.verticalCenter: parent.verticalCenter
            width: {
                let w = parent.width
                if (root.hasLeadingSlot)
                    w -= leadingSlot.width + 16
                else if (root.hasLeadingAvatar)
                    w -= 32 + 16
                else if (root.leadingIcon.length > 0)
                    w -= 24 + 16
                if (root.trailingIcon.length > 0 && root._actionCount === 0 && !root.hasTrailingSlot)
                    w -= 24 + 16
                if (root.hasTrailingSlot)
                    w -= trailingSlot.width + 16
                if (root._actionCount > 0)
                    w -= actionsHost.width + 16
                return Math.max(0, w)
            }
            spacing: 2

            Md3Text {
                width: parent.width
                text: root.title
                role: Md3Text.BodyLarge
                tone: Md3Text.Custom
                customColor: root.enabled
                             ? (root.selected ? Md3Theme.colorScheme.colorOnSecondaryContainer : Md3Theme.colorScheme.colorOnSurface)
                             : Md3Theme.colorScheme.disabledContent()
                elide: Text.ElideRight
            }
            Md3Text {
                visible: root.subtitle.length > 0
                width: parent.width
                text: root.subtitle
                role: Md3Text.BodyMedium
                tone: Md3Text.Custom
                customColor: root.enabled ? Md3Theme.colorScheme.colorOnSurfaceVariant
                                          : Md3Theme.colorScheme.disabledContent()
                elide: Text.ElideRight
            }
            Md3Text {
                visible: root.supportingText.length > 0
                width: parent.width
                text: root.supportingText
                role: Md3Text.BodyMedium
                tone: Md3Text.Custom
                customColor: root.enabled ? Md3Theme.colorScheme.colorOnSurfaceVariant
                                          : Md3Theme.colorScheme.disabledContent()
                wrapMode: Text.Wrap
                maximumLineCount: 2
            }
        }

        Item {
            id: actionsHost
            visible: root._actionCount > 0 && !root.hasTrailingSlot
            width: actionsRow.width
            height: Math.max(40, actionsRow.height)
            anchors.verticalCenter: parent.verticalCenter

            Row {
                id: actionsRow
                spacing: 0
                Repeater {
                    model: root._visibleActionCount
                    Md3IconButton {
                        required property int index
                        icon: root._actionIcon(root.trailingActions[index])
                        enabled: root.enabled && (!root.trailingActions[index]
                                                  || root.trailingActions[index].enabled !== false)
                        accessibleName: root._actionLabel(root.trailingActions[index], index)
                        onClicked: root.trailingActionClicked(index)
                    }
                }
                Md3IconButton {
                    visible: root._actionsOverflow
                    icon: root.trailingOverflowIcon
                    accessibleName: qsTr("More actions")
                    onClicked: {
                        overflowMenu.model = root._overflowModel()
                        overflowMenu.rebuildFromModel()
                        overflowMenu.open = true
                    }
                }
            }

            Md3Menu {
                id: overflowMenu
                model: []
                onItemClicked: function (path) {
                    const rows = overflowMenu.model
                    for (let i = 0; i < rows.length; ++i) {
                        if (String(rows[i].text) === String(path)) {
                            root.trailingActionClicked(rows[i]._index)
                            return
                        }
                    }
                }
            }
        }

        Item {
            id: trailingSlot
            visible: root.hasTrailingSlot
            width: childrenRect.width
            height: Math.max(childrenRect.height, 24)
            anchors.verticalCenter: parent.verticalCenter
        }

        Md3Icon {
            visible: root.trailingIcon.length > 0 && !root.hasTrailingSlot && root._actionCount === 0
            icon: root.trailingIcon
            size: 24
            iconColor: Md3Theme.colorScheme.colorOnSurfaceVariant
            anchors.verticalCenter: parent.verticalCenter
            rotation: root.trailingRotation
            Behavior on rotation {
                NumberAnimation {
                    duration: Md3Motion.spatialSnapDuration
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Md3Motion.emphasized
                }
            }
            MouseArea {
                anchors.fill: parent
                enabled: root.enabled
                cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                onClicked: root.trailingClicked()
            }
        }
    }

    Md3Divider {
        visible: root.showDivider
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        variant: Md3Divider.Inset
    }
}
