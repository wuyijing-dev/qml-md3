import QtQuick
import Md3

/// Empty / no-results placeholder: icon, title, body, optional CTA.
Item {
    id: root

    property string icon: "inbox"
    property string title: qsTr("Nothing here")
    property string body: ""
    property string actionText: ""
    property url illustration: ""
    property real maxContentWidth: 360

    signal actionClicked()

    implicitWidth: Math.min(parent ? parent.width : maxContentWidth, maxContentWidth + 48)
    implicitHeight: col.implicitHeight + 48
    Binding {
        target: root
        property: "height"
        value: root.implicitHeight
        when: !root.anchors.fill
        restoreMode: Binding.RestoreNone
    }
    readonly property Md3HeightSync _heightSync: Md3HeightSync {
        target: root
        enabled: !root.anchors.fill
        policy: Md3HeightSync.AtLeastImplicit
    }

    Accessible.role: Accessible.StaticText
    Accessible.name: title.length ? title : qsTr("Empty state")

    property bool _entered: false
    Component.onCompleted: _entered = true

    Column {
        id: col
        anchors.centerIn: parent
        width: Math.min(root.width - 32, root.maxContentWidth)
        spacing: 12
        opacity: root._entered ? 1 : 0
        scale: root._entered || Md3Theme.reduceMotion ? 1 : 0.97
        transformOrigin: Item.Center
        Behavior on opacity {
            enabled: !Md3Theme.reduceMotion
            NumberAnimation {
                duration: Md3Motion.overlayDuration
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Md3Motion.standard
            }
        }
        Behavior on scale {
            enabled: !Md3Theme.reduceMotion
            NumberAnimation {
                duration: Md3Motion.spatialDuration
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Md3Motion.emphasizedDecelerate
            }
        }

        Image {
            anchors.horizontalCenter: parent.horizontalCenter
            visible: root.illustration.toString().length > 0
            source: root.illustration
            width: 120
            height: 120
            fillMode: Image.PreserveAspectFit
            asynchronous: true
        }

        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            visible: root.illustration.toString().length === 0 && root.icon.length > 0
            width: 72
            height: 72
            radius: 36
            color: Md3Theme.colorScheme.surfaceContainerHighest

            Md3Icon {
                anchors.centerIn: parent
                icon: root.icon
                size: 36
                iconColor: Md3Theme.colorScheme.colorOnSurfaceVariant
            }
        }

        Text {
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.Wrap
            text: root.title
            color: Md3Theme.colorScheme.colorOnSurface
            font.family: Md3Theme.typography.fontFamily
            font.pixelSize: Md3Theme.typography.titleLarge.size
            font.weight: Font.Medium
        }

        Text {
            width: parent.width
            visible: root.body.length > 0
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.Wrap
            text: root.body
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.family: Md3Theme.typography.fontFamily
            font.pixelSize: Md3Theme.typography.bodyMedium.size
        }

        Item { width: 1; height: 4; visible: root.actionText.length > 0 }

        Md3Button {
            anchors.horizontalCenter: parent.horizontalCenter
            visible: root.actionText.length > 0
            text: root.actionText
            onClicked: root.actionClicked()
        }
    }
}
