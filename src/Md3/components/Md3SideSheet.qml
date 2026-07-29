import QtQuick

/// Modal/standard side sheet — slides from start (left) or end (right).
Item {
    id: root

    enum Edge { Start, End }

    property bool open: false
    property bool modal: true
    property int edge: Md3SideSheet.End
    property real sheetWidth: 360
    property string title: ""
    property string text: ""
    property int layoutMode: Md3ContainerBody.Fit
    default property alias content: customSlot.data

    signal dismissed()

    readonly property bool fromEnd: edge === Md3SideSheet.End
    readonly property real panelWidth: Math.min(sheetWidth, Math.max(240, width * 0.92))
    // Resizing the owner window changes `sheet.x` (because `sheet.x` depends on `parent.width`).
    // Without guarding, `Behavior on x` would animate during resize even when open=false,
    // which makes the sheet briefly become visible.
    property bool _transitioning: false

    anchors.fill: parent
    visible: open || _transitioning
    z: 960
    clip: true

    function dismiss() {
        open = false
        dismissed()
    }

    onOpenChanged: {
        _transitioning = true
        transitionTimer.restart()
    }

    Timer {
        id: transitionTimer
        interval: Md3Motion.spatialDuration + 80
        repeat: false
        onTriggered: root._transitioning = false
    }

    Rectangle {
        id: scrim
        anchors.fill: parent
        visible: root.modal
        color: Md3Theme.colorScheme.scrim
        opacity: root.open ? 0.32 : 0
        Behavior on opacity {
            NumberAnimation {
                id: scrimFade
                duration: Md3Motion.overlayDuration
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Md3Motion.standard
            }
        }
        MouseArea {
            anchors.fill: parent
            enabled: root.open && root.modal
            cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
            onClicked: root.dismiss()
        }
    }

    Md3Shadow {
        anchors.fill: sheet
        elevation: root.open ? 2 : 0
        cornerRadius: Md3Theme.shape.large
        opacity: sheet.opacity
    }

    Rectangle {
        id: sheet
        width: root.panelWidth
        height: parent.height
        y: 0
        x: {
            if (root.fromEnd)
                return root.open ? parent.width - width : parent.width
            return root.open ? 0 : -width
        }
        color: Md3Theme.colorScheme.surfaceContainerLow
        topLeftRadius: root.fromEnd ? Md3Theme.shape.large : 0
        bottomLeftRadius: root.fromEnd ? Md3Theme.shape.large : 0
        topRightRadius: root.fromEnd ? 0 : Md3Theme.shape.large
        bottomRightRadius: root.fromEnd ? 0 : Md3Theme.shape.large

        // Resize the owner window changes `sheet.x` (because `sheet.x` depends on `parent.width`).
        // We only want to animate when `open` toggles; resize should update x instantly.
        Behavior on x {
            enabled: root._transitioning
            NumberAnimation {
                id: sheetSlide
                duration: Md3Motion.spatialDuration
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Md3Motion.emphasized
            }
        }

        Column {
            anchors.fill: parent
            anchors.margins: 0
            spacing: 0

            Item {
                width: parent.width
                height: root.title.length > 0 ? 64 : 12
                visible: height > 12

                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 24
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: closeBtn.left
                    anchors.rightMargin: 8
                    text: root.title
                    elide: Text.ElideRight
                    color: Md3Theme.colorScheme.colorOnSurface
                    font.family: Md3Theme.typography.fontFamily
                    font.pixelSize: Md3Theme.typography.titleLarge.size
                }

                Md3IconButton {
                    id: closeBtn
                    anchors.right: parent.right
                    anchors.rightMargin: 8
                    anchors.verticalCenter: parent.verticalCenter
                    icon: "close"
                    accessibleName: qsTr("Close")
                    onClicked: root.dismiss()
                }
            }

            Md3ContainerBody {
                id: sheetBody
                width: parent.width
                height: parent.height - (root.title.length > 0 ? 64 : 12)
                layoutMode: root.layoutMode
                padding: 24

                Md3VStack {
                    width: parent.width
                    spacing: 12
                    fillWidth: true

                    Md3Text {
                        visible: root.text.length > 0
                        width: parent.width
                        text: root.text
                        role: Md3Text.BodyMedium
                        tone: Md3Text.OnSurfaceVariant
                        wrapMode: Text.WordWrap
                    }
                    Item {
                        id: customSlot
                        width: parent.width
                        height: childrenRect.height
                        implicitHeight: childrenRect.height
                    }
                }
            }
        }
    }
}
