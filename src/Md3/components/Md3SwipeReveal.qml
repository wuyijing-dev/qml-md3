import QtQuick
import Md3

/// Swipe-to-reveal leading / trailing actions (WinUI SwipeControl–inspired).
/// Actions sit under an opaque sliding panel so they stay hidden until swiped.
/// Only one reveal stays open at a time (via Md3OverlayHost).
Item {
    id: root

    property real actionWidth: 72
    /// [{ icon, label?, color?, destructive? }, ...] revealed on swipe right.
    property var leadingActions: []
    /// [{ icon, label?, color?, destructive? }, ...] revealed on swipe left.
    property var trailingActions: []
    property real openThreshold: 0.4
    property bool interactive: true
    /// When true (default), opening this closes any other SwipeReveal.
    property bool exclusive: true
    /// Panel fill — must be opaque or actions show through ListTile (transparent bg).
    property color panelColor: Md3Theme.colorScheme.surface
    /// Keyboard focus index into the currently revealed action strip (-1 = none).
    property int actionFocusIndex: -1

    readonly property real leadingWidth: leadingActions.length * actionWidth
    readonly property real trailingWidth: trailingActions.length * actionWidth
    readonly property bool open: Math.abs(panel.x) > 4
    readonly property bool leadingOpen: panel.x > 4
    readonly property bool trailingOpen: panel.x < -4
    readonly property real revealWidth: trailingOpen ? trailingWidth
                                      : (leadingOpen ? leadingWidth : Math.max(leadingWidth, trailingWidth))

    signal actionTriggered(int index, bool leading)
    signal opened()
    signal closed()

    default property alias contentData: contentHost.data

    clip: true
    implicitWidth: 320
    implicitHeight: Math.max(Md3Theme.tableRowHeight + 16, contentHost.childrenRect.height)
    height: implicitHeight
    focus: true
    activeFocusOnTab: interactive

    Accessible.role: Accessible.ListItem
    Accessible.name: qsTr("Swipe reveal")
    Accessible.onPressAction: togglePrimary()

    property bool _wasOpen: false

    function close() {
        panel.x = 0
        actionFocusIndex = -1
        Md3OverlayHost.releaseSwipeReveal(root)
    }

    function revealTrailing() {
        if (trailingWidth <= 0)
            return
        if (exclusive)
            Md3OverlayHost.claimSwipeReveal(root)
        panel.x = -trailingWidth
        actionFocusIndex = 0
        forceActiveFocus()
    }

    function revealLeading() {
        if (leadingWidth <= 0)
            return
        if (exclusive)
            Md3OverlayHost.claimSwipeReveal(root)
        panel.x = leadingWidth
        actionFocusIndex = 0
        forceActiveFocus()
    }

    /// Prefer trailing when both exist (mail / list convention).
    function reveal() {
        if (trailingWidth > 0)
            revealTrailing()
        else
            revealLeading()
    }

    function togglePrimary() {
        if (open)
            close()
        else
            reveal()
    }

    function _actionCount() {
        if (trailingOpen)
            return trailingActions.length
        if (leadingOpen)
            return leadingActions.length
        return 0
    }

    function _triggerFocused() {
        const n = _actionCount()
        if (n <= 0 || actionFocusIndex < 0 || actionFocusIndex >= n)
            return
        actionTriggered(actionFocusIndex, leadingOpen)
        close()
    }

    function _fireAction(index, leading) {
        actionTriggered(index, leading)
        close()
    }

    Keys.onPressed: function (event) {
        if (!interactive)
            return
        if (event.key === Qt.Key_Escape) {
            if (open) {
                close()
                event.accepted = true
            }
            return
        }
        if (event.key === Qt.Key_Left) {
            if (!open && trailingWidth > 0)
                revealTrailing()
            else if (trailingOpen) {
                actionFocusIndex = Math.min(_actionCount() - 1, Math.max(0, actionFocusIndex) + 1)
            } else if (leadingOpen) {
                if (actionFocusIndex <= 0)
                    close()
                else
                    actionFocusIndex -= 1
            }
            event.accepted = true
        } else if (event.key === Qt.Key_Right) {
            if (!open && leadingWidth > 0)
                revealLeading()
            else if (leadingOpen) {
                actionFocusIndex = Math.min(_actionCount() - 1, Math.max(0, actionFocusIndex) + 1)
            } else if (trailingOpen) {
                if (actionFocusIndex <= 0)
                    close()
                else
                    actionFocusIndex -= 1
            }
            event.accepted = true
        } else if (event.key === Qt.Key_Space || event.key === Qt.Key_Return
                   || event.key === Qt.Key_Enter) {
            if (!open)
                reveal()
            else
                _triggerFocused()
            event.accepted = true
        }
    }

    Component {
        id: actionDelegate
        Rectangle {
            id: act
            property int actionIndex: 0
            property var modelData: ({})
            property bool leadingSide: false
            property bool focusedAction: false

            width: root.actionWidth
            height: parent ? parent.height : root.height
            color: {
                if (modelData.color !== undefined)
                    return modelData.color
                if (modelData.destructive)
                    return Md3Theme.colorScheme.error
                return Md3Theme.colorScheme.primary
            }
            opacity: focusedAction ? 1 : 0.92
            border.width: focusedAction ? 2 : 0
            border.color: Md3Theme.colorScheme.colorOnPrimary

            Column {
                anchors.centerIn: parent
                spacing: 2
                Md3Icon {
                    anchors.horizontalCenter: parent.horizontalCenter
                    icon: modelData.icon !== undefined ? modelData.icon : "more_horiz"
                    size: 22
                    iconColor: Md3Theme.colorScheme.colorOnPrimary
                }
                Md3Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    visible: modelData.label !== undefined && String(modelData.label).length > 0
                    text: modelData.label !== undefined ? String(modelData.label) : ""
                    role: Md3Text.LabelSmall
                    tone: Md3Text.Custom
                    customColor: Md3Theme.colorScheme.colorOnPrimary
                }
            }

            MouseArea {
                anchors.fill: parent
                enabled: root.open
                cursorShape: Qt.PointingHandCursor
                onClicked: root._fireAction(act.actionIndex, act.leadingSide)
            }
        }
    }

    // Leading underlay (left)
    Row {
        id: leadingRow
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: Math.max(0, root.leadingWidth)
        z: 0

        Repeater {
            model: root.leadingActions
            delegate: Loader {
                required property int index
                required property var modelData
                width: root.actionWidth
                height: leadingRow.height
                sourceComponent: actionDelegate
                onLoaded: {
                    item.actionIndex = index
                    item.modelData = modelData
                    item.leadingSide = true
                    item.focusedAction = root.leadingOpen && root.actionFocusIndex === index
                }
                Connections {
                    target: root
                    function onActionFocusIndexChanged() {
                        if (item)
                            item.focusedAction = root.leadingOpen && root.actionFocusIndex === index
                    }
                    function onOpenChanged() {
                        if (item)
                            item.focusedAction = root.leadingOpen && root.actionFocusIndex === index
                    }
                }
            }
        }
    }

    // Trailing underlay (right)
    Row {
        id: trailingRow
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: Math.max(0, root.trailingWidth)
        z: 0

        Repeater {
            model: root.trailingActions
            delegate: Loader {
                required property int index
                required property var modelData
                width: root.actionWidth
                height: trailingRow.height
                sourceComponent: actionDelegate
                onLoaded: {
                    item.actionIndex = index
                    item.modelData = modelData
                    item.leadingSide = false
                    item.focusedAction = root.trailingOpen && root.actionFocusIndex === index
                }
                Connections {
                    target: root
                    function onActionFocusIndexChanged() {
                        if (item)
                            item.focusedAction = root.trailingOpen && root.actionFocusIndex === index
                    }
                    function onOpenChanged() {
                        if (item)
                            item.focusedAction = root.trailingOpen && root.actionFocusIndex === index
                    }
                }
            }
        }
    }

    Item {
        id: panel
        width: root.width
        height: root.height
        x: 0
        z: 1

        Rectangle {
            anchors.fill: parent
            color: root.panelColor
        }

        Item {
            id: contentHost
            anchors.fill: parent
        }

        Behavior on x {
            id: slideBehavior
            enabled: true
            NumberAnimation {
                duration: Md3Motion.short3
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Md3Motion.standard
            }
        }

        onXChanged: {
            if (Math.abs(x) < 1 && root._wasOpen) {
                root._wasOpen = false
                root.actionFocusIndex = -1
                Md3OverlayHost.releaseSwipeReveal(root)
                root.closed()
            } else if (Math.abs(x) > 4 && !root._wasOpen) {
                root._wasOpen = true
                if (root.exclusive)
                    Md3OverlayHost.claimSwipeReveal(root)
                if (root.actionFocusIndex < 0)
                    root.actionFocusIndex = 0
                root.opened()
            }
        }

        DragHandler {
            id: drag
            enabled: root.interactive && (root.leadingWidth > 0 || root.trailingWidth > 0)
            target: null
            xAxis.enabled: true
            yAxis.enabled: false
            property real startX: 0

            onActiveChanged: {
                if (active) {
                    slideBehavior.enabled = false
                    startX = panel.x
                    if (root.exclusive)
                        Md3OverlayHost.claimSwipeReveal(root)
                } else {
                    slideBehavior.enabled = true
                    const x = panel.x
                    if (x < 0 && root.trailingWidth > 0) {
                        const shouldOpen = Math.abs(x) > root.trailingWidth * root.openThreshold
                        panel.x = shouldOpen ? -root.trailingWidth : 0
                    } else if (x > 0 && root.leadingWidth > 0) {
                        const shouldOpen = x > root.leadingWidth * root.openThreshold
                        panel.x = shouldOpen ? root.leadingWidth : 0
                    } else {
                        panel.x = 0
                    }
                }
            }
            onTranslationChanged: {
                if (!active)
                    return
                const minX = root.trailingWidth > 0 ? -root.trailingWidth : 0
                const maxX = root.leadingWidth > 0 ? root.leadingWidth : 0
                panel.x = Math.min(maxX, Math.max(minX, startX + translation.x))
            }
        }
    }

    Component.onDestruction: Md3OverlayHost.releaseSwipeReveal(root)
}
