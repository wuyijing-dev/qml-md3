import QtQuick

Column {
    id: root

    property string title: ""
    property string subtitle: ""
    property bool expanded: false
    property bool enabled: true

    width: parent ? parent.width : 320
    spacing: 0

    Md3ListTile {
        width: parent.width
        title: root.title
        subtitle: root.subtitle
        trailingIcon: "expand_more"
        enabled: root.enabled
        onClicked: root.expanded = !root.expanded
    }

    // Rotate trailing via rotation on a proxy — list tile icon is static; animate body instead
    Item {
        id: body
        width: parent.width
        height: root.expanded ? contentCol.implicitHeight : 0
        clip: true

        Behavior on height {
            NumberAnimation {
                    duration: Md3Motion.spatialDuration
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Md3Motion.emphasized
                }
        }

        Column {
            id: contentCol
            width: parent.width
            padding: 16
            default property alias children: contentCol.data
        }
    }

    default property alias content: contentCol.data
}
