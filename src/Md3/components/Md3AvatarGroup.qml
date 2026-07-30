import QtQuick
import Md3

/// Overlapping row of avatars. model: [{ source?, initials?, icon?, color? }, ...] or strings (initials).
Item {
    id: root

    property var model: []
    property int sizePreset: Md3Avatar.Medium
    property int maxVisible: 4
    property real overlap: 0.32
    property color surplusColor: Md3Theme.colorScheme.surfaceContainerHighest
    property color surplusContentColor: Md3Theme.colorScheme.colorOnSurfaceVariant

    signal avatarClicked(int index)

    readonly property real avatarSize: {
        switch (sizePreset) {
        case Md3Avatar.ExtraSmall: return 24
        case Md3Avatar.Small: return 32
        case Md3Avatar.Large: return 56
        case Md3Avatar.ExtraLarge: return 72
        default: return 40
        }
    }

    readonly property int total: model ? model.length : 0
    readonly property int shown: Math.min(total, maxVisible)
    readonly property int surplus: Math.max(0, total - maxVisible)
    readonly property real step: avatarSize * (1 - overlap)

    implicitWidth: shown <= 0 ? 0
                   : (shown + (surplus > 0 ? 1 : 0) - 1) * step + avatarSize
    implicitHeight: avatarSize
    height: implicitHeight
    width: implicitWidth

    function entryInitials(m) {
        if (m === undefined || m === null)
            return ""
        if (typeof m === "string")
            return m
        if (m.initials !== undefined)
            return String(m.initials)
        if (m.name !== undefined) {
            const parts = String(m.name).trim().split(/\s+/)
            if (parts.length >= 2)
                return (parts[0][0] + parts[1][0]).toUpperCase()
            return parts[0].slice(0, 2).toUpperCase()
        }
        return ""
    }

    Repeater {
        model: root.shown

        Md3Avatar {
            required property int index
            x: index * root.step
            z: index
            sizePreset: root.sizePreset
            source: {
                const m = root.model[index]
                return (m && m.source !== undefined) ? m.source : ""
            }
            initials: root.entryInitials(root.model[index])
            icon: {
                const m = root.model[index]
                return (m && m.icon !== undefined) ? String(m.icon) : "person"
            }
            color: {
                const m = root.model[index]
                return (m && m.color !== undefined) ? m.color : Md3Theme.colorScheme.primaryContainer
            }
            contentColor: {
                const m = root.model[index]
                return (m && m.contentColor !== undefined) ? m.contentColor
                       : Md3Theme.colorScheme.colorOnPrimaryContainer
            }

            Rectangle {
                anchors.fill: parent
                anchors.margins: -2
                radius: width / 2
                color: "transparent"
                border.width: 2
                border.color: Md3Theme.colorScheme.surface
                z: -1
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: root.avatarClicked(index)
            }
        }
    }

    Md3Avatar {
        visible: root.surplus > 0
        x: root.shown * root.step
        z: root.shown
        sizePreset: root.sizePreset
        initials: "+" + root.surplus
        color: root.surplusColor
        contentColor: root.surplusContentColor

        Rectangle {
            anchors.fill: parent
            anchors.margins: -2
            radius: width / 2
            color: "transparent"
            border.width: 2
            border.color: Md3Theme.colorScheme.surface
            z: -1
        }
    }
}
