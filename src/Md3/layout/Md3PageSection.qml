import QtQuick
import Md3

/// Page section: title + optional subtitle + content — cuts gallery/form glue.
Item {
    id: root

    property string title: ""
    property string subtitle: ""
    property real spacing: 12
    property real padding: 0
    property bool fillWidth: true
    default property alias content: body.data

    implicitWidth: Math.max(280, stack.implicitWidth + padding * 2)
    implicitHeight: stack.implicitHeight + padding * 2
    width: fillWidth && parent ? parent.width : implicitWidth

    Md3VStack {
        id: stack
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: root.padding
        spacing: root.spacing
        fillWidth: true

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
        Item {
            id: body
            width: parent.width
            height: childrenRect.height
            implicitHeight: childrenRect.height
        }
    }
}
