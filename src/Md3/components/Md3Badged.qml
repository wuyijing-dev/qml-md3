import QtQuick

/// Wraps content and positions an Md3Badge (top-end by default).
Item {
    id: root

    property alias badge: badgeItem
    property string badgeText: ""
    property bool badgeDot: false
    property int badgeMax: 99
    property int badgeSizePreset: Md3Badge.Medium
    property color badgeColor: Md3Theme.colorScheme.error
    property color badgeLabelColor: Md3Theme.colorScheme.colorOnError
    property bool badgeVisible: badgeDot || badgeText.length > 0
    /// Offset from the top-end corner
    property real badgeOffsetX: 2
    property real badgeOffsetY: -2

    default property alias content: contentHost.data

    implicitWidth: contentHost.childrenRect.width
    implicitHeight: contentHost.childrenRect.height
    width: implicitWidth
    height: implicitHeight

    Item {
        id: contentHost
        anchors.fill: parent
    }

    Md3Badge {
        id: badgeItem
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: -root.badgeOffsetX
        anchors.topMargin: root.badgeOffsetY
        z: 10
        visible: root.badgeVisible
        text: root.badgeText
        dot: root.badgeDot
        max: root.badgeMax
        sizePreset: root.badgeSizePreset
        badgeColor: root.badgeColor
        labelColor: root.badgeLabelColor
    }
}
