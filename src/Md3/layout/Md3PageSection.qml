import QtQuick
import Md3

/// Page section: title + optional subtitle + content — cuts gallery/form glue.
Item {
    id: root

    property string title: ""
    property string subtitle: ""
    property real spacing: Md3Theme.spacingMd
    property real padding: 0
    property bool fillWidth: true
    /// Optional header trailing slot (icon buttons, etc.) — peer of ListTile trailing.
    property alias trailing: trailingSlot.data
    default property alias content: body.data

    readonly property bool hasTrailing: trailingSlot.children.length > 0

    implicitWidth: Math.max(280, stack.implicitWidth + padding * 2)
    implicitHeight: stack.implicitHeight + padding * 2
    width: fillWidth && parent ? parent.width : implicitWidth
    readonly property Md3HeightSync _heightSync: Md3HeightSync {
        target: root
        enabled: !root.anchors.fill
        policy: Md3HeightSync.AtLeastImplicit
    }

    Md3VStack {
        id: stack
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: root.padding
        spacing: root.spacing
        fillWidth: true

        Md3HStack {
            visible: root.title.length > 0 || root.hasTrailing
            width: parent.width
            spacing: 8
            alignment: Md3HStack.Center

            Column {
                property bool expand: true
                spacing: 2
                width: Math.max(40, parent.width - (root.hasTrailing ? trailingSlot.width + 8 : 0))

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
                id: trailingSlot
                visible: root.hasTrailing
                width: childrenRect.width
                height: Math.max(24, childrenRect.height)
            }
        }

        Md3Text {
            // Subtitle alone (no title) still shows below when header row is hidden.
            visible: root.title.length === 0 && root.subtitle.length > 0 && !root.hasTrailing
            width: parent.width
            text: root.subtitle
            role: Md3Text.BodyMedium
            tone: Md3Text.OnSurfaceVariant
            wrapMode: Text.WordWrap
        }

        Item {
            id: body
            width: parent.width
            height: childrenRect.height
            implicitHeight: childrenRect.height
        }
    }
}
