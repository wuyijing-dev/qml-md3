import QtQuick

/// Material Badge — numeric / dot / max-count, attach to any item via anchors.
Item {
    id: root

    enum Size { Small, Medium, Large }

    property string text: ""
    property bool dot: false
    /// Cap display, e.g. 99 → "99+"
    property int max: 999
    property int sizePreset: Md3Badge.Medium
    property color badgeColor: Md3Theme.colorScheme.error
    property color labelColor: Md3Theme.colorScheme.colorOnError

    readonly property string displayText: {
        if (dot || text.length === 0)
            return ""
        const n = Number(text)
        if (!isNaN(n) && max > 0 && n > max)
            return String(max) + "+"
        return text
    }

    readonly property bool large: !dot && displayText.length > 0

    readonly property real padX: {
        switch (sizePreset) {
        case Md3Badge.Small: return 4
        case Md3Badge.Large: return 10
        default: return 6
        }
    }
    readonly property real minSide: {
        switch (sizePreset) {
        case Md3Badge.Small: return 6
        case Md3Badge.Large: return 20
        default: return large ? 16 : 6
        }
    }
    readonly property real fontPx: {
        switch (sizePreset) {
        case Md3Badge.Small: return 9
        case Md3Badge.Large: return 13
        default: return Md3Theme.typography.labelSmall.size
        }
    }

    implicitWidth: large ? Math.max(minSide, label.implicitWidth + padX * 2) : minSide
    implicitHeight: large ? Math.max(minSide, label.implicitHeight + 2) : minSide
    width: implicitWidth
    height: implicitHeight

    Rectangle {
        anchors.fill: parent
        radius: Md3Theme.shape.full
        color: root.badgeColor

        Text {
            id: label
            anchors.centerIn: parent
            visible: root.large
            text: root.displayText
            color: root.labelColor
            font.family: Md3Theme.typography.fontFamily
            font.pixelSize: root.fontPx
            font.weight: Font.Medium
        }
    }
}
