import QtQuick
import Md3

Column {
    id: root

    property string title: ""
    property string subtitle: ""
    property bool expanded: false
    property int layoutMode: Md3ContainerBody.Fit
    // Use Item.enabled (do not redeclare — triggers propertyCache override warning)

    width: parent ? parent.width : 320
    spacing: 0

    Accessible.role: Accessible.Button
    Accessible.name: title.length ? title : qsTr("Expansion tile")

    Md3ListTile {
        width: parent.width
        title: root.title
        subtitle: root.subtitle
        trailingIcon: "expand_more"
        trailingRotation: root.expanded ? 180 : 0
        enabled: root.enabled
        onClicked: root.expanded = !root.expanded
    }

    Item {
        id: body
        width: parent.width
        height: root.expanded ? adaptiveBody.implicitHeight : 0
        clip: true
        opacity: root.expanded ? 1 : 0

        Behavior on height {
            NumberAnimation {
                duration: Md3Motion.spatialDuration
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Md3Motion.emphasized
            }
        }
        Behavior on opacity {
            NumberAnimation {
                duration: Md3Motion.short3
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Md3Motion.standard
            }
        }

        Md3ContainerBody {
            id: adaptiveBody
            width: parent.width
            layoutMode: root.layoutMode

            Column {
                id: contentCol
                width: parent.width
                padding: 16
            }
        }
    }

    default property alias content: contentCol.data
}
