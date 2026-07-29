import QtQuick

Item {
    id: root

    property var model: [] // [{ icon, text?, colorRole?, enabled? }] — first item nearest primary
    property bool open: false
    property int colorRole: Md3Fab.Primary
    property string icon: "add"
    property string closeIcon: "close"
    property real actionGap: 4

    signal clicked()
    signal actionClicked(int index)

    readonly property var stackedModel: {
        const out = []
        for (let i = model.length - 1; i >= 0; --i)
            out.push({ data: model[i], sourceIndex: i })
        return out
    }

    // Stable footprint — opening must not resize / shift anchors
    implicitWidth: primary.implicitWidth
    implicitHeight: primary.implicitHeight
    width: implicitWidth
    height: implicitHeight
    clip: false

    function toggle() {
        if (!enabled)
            return
        open = !open
    }

    Column {
        id: stack
        // Align mini FAB columns to the primary's visible circle (ignore shadow gutters)
        anchors.horizontalCenter: primary.horizontalCenter
        anchors.bottom: primary.top
        anchors.bottomMargin: root.open ? (root.actionGap - primary.shadowPad - 2) : -(primary.shadowPad + 2)
        spacing: root.actionGap
        opacity: root.open ? 1 : 0
        visible: opacity > 0.01
        z: 1

        Behavior on opacity {
            NumberAnimation {
                duration: Md3Motion.short3
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Md3Motion.standard
            }
        }
        Behavior on anchors.bottomMargin {
            NumberAnimation {
                duration: Md3Motion.short3
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Md3Motion.emphasized
            }
        }

        Repeater {
            model: root.stackedModel
            delegate: Item {
                id: row
                required property int index
                required property var modelData

                readonly property var item: modelData.data
                readonly property int sourceIndex: modelData.sourceIndex

                width: Math.max(actionFab.implicitWidth,
                                (label.visible ? label.implicitWidth + 10 : 0) + actionFab.implicitWidth)
                height: actionFab.implicitHeight
                opacity: root.open ? 1 : 0
                scale: root.open ? 1 : 0.92
                transformOrigin: Item.Bottom

                Behavior on opacity {
                    NumberAnimation {
                        duration: Md3Motion.short3
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Md3Motion.standard
                    }
                }
                Behavior on scale {
                    NumberAnimation {
                        duration: Md3Motion.short3
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Md3Motion.emphasizedDecelerate
                    }
                }

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 10
                    layoutDirection: Qt.RightToLeft

                    Md3Fab {
                        id: actionFab
                        size: Md3Fab.Small
                        shadowPad: 2
                        colorRole: row.item.colorRole !== undefined ? row.item.colorRole
                                                                    : Md3Fab.Secondary
                        icon: row.item.icon !== undefined ? row.item.icon : "add"
                        enabled: root.enabled && root.open && (row.item.enabled !== false)
                        onClicked: {
                            root.actionClicked(row.sourceIndex)
                            root.open = false
                        }
                    }

                    Md3Text {
                        id: label
                        visible: row.item.text !== undefined && String(row.item.text).length > 0
                        text: row.item.text !== undefined ? row.item.text : ""
                        role: Md3Text.LabelLarge
                        tone: Md3Text.OnSurface
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }
    }

    Md3Fab {
        id: primary
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        colorRole: root.colorRole
        icon: root.icon
        iconRotation: root.open ? 45 : 0
        enabled: root.enabled
        onClicked: {
            root.clicked()
            root.toggle()
        }
    }
}
