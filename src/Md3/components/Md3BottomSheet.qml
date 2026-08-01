import QtQuick
import Md3

Item {
    id: root

    property bool open: false
    property bool modal: true
    property int layoutMode: Md3ContainerBody.Fit
    property string title: ""
    property string text: ""
    property string confirmText: ""
    property string dismissText: ""
    /// Drag distance (px) before release dismisses the sheet.
    property real dismissDragThreshold: 96
    default property alias content: bodySlot.data

    signal dismissed()
    signal confirmed()

    anchors.fill: parent
    visible: open || sheet.y < height - 0.5 || scrim.opacity > 0.01
    z: 900
    focus: open
    Accessible.role: Accessible.Dialog
    Accessible.name: title.length ? title : qsTr("Bottom sheet")

    property var _restoreFocus: null
    property real _dragOffset: 0
    property bool _dragging: false

    function accept() {
        open = false
        confirmed()
        _restore()
    }

    function reject() {
        open = false
        dismissed()
        _restore()
    }

    function _restore() {
        _dragOffset = 0
        _dragging = false
        const f = _restoreFocus
        _restoreFocus = null
        if (f && typeof f.forceActiveFocus === "function")
            Qt.callLater(function () {
                try { f.forceActiveFocus() } catch (e) { /* destroyed */ }
            })
    }

    onOpenChanged: {
        if (open) {
            _dragOffset = 0
            const win = Md3OverlayHost.resolveWindow(null, root)
            if (win && win.activeFocusItem)
                _restoreFocus = win.activeFocusItem
            forceActiveFocus()
            Qt.callLater(function () {
                if (!open)
                    return
                if (confirmBtn.visible)
                    confirmBtn.forceActiveFocus()
                else if (dismissBtn.visible)
                    dismissBtn.forceActiveFocus()
            })
        } else if (!_dragging) {
            _dragOffset = 0
        }
    }

    Keys.onPressed: function (event) {
        if (!open)
            return
        if (event.key === Qt.Key_Escape) {
            reject()
            event.accepted = true
        } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            if (confirmText.length > 0)
                accept()
            event.accepted = true
        }
    }

    Rectangle {
        id: scrim
        anchors.fill: parent
        visible: root.modal
        color: Md3Theme.colorScheme.scrim
        opacity: root.open ? 0.32 : 0
        Behavior on opacity {
            NumberAnimation {
                duration: Md3Motion.overlayDuration
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Md3Motion.standard
            }
        }
        MouseArea {
            anchors.fill: parent
            enabled: root.open && root.modal
            cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
            onClicked: root.reject()
        }
    }

    readonly property real maxSheetHeight: parent ? parent.height * 0.6 : 480
    readonly property real _chromeH: 36
                                  + (title.length > 0 ? 32 : 0)
                                  + (text.length > 0 ? 28 : 0)
                                  + (confirmText.length > 0 || dismissText.length > 0 ? 52 : 16)

    Rectangle {
        id: sheet
        anchors.left: parent.left
        anchors.right: parent.right
        height: root.layoutMode === Md3ContainerBody.Scroll
                ? root.maxSheetHeight
                : Math.min(root.maxSheetHeight,
                           sheetBody.contentImplicitHeight + root._chromeH)
        y: (root.open ? parent.height - height : parent.height) + root._dragOffset
        radius: 0
        topLeftRadius: Md3Theme.shape.extraLarge
        topRightRadius: Md3Theme.shape.extraLarge
        color: Md3Theme.colorScheme.surfaceContainerLow

        Behavior on y {
            enabled: !root._dragging
            NumberAnimation {
                duration: Md3Motion.spatialDuration
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Md3Motion.emphasized
            }
        }

        // Drag handle hit area (visual bar + dismiss gesture)
        Item {
            id: handleZone
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: 36
            z: 2

            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 16
                width: 32
                height: 4
                radius: 2
                color: Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.colorOnSurfaceVariant, 0.4)
            }

            DragHandler {
                id: sheetDrag
                target: null
                enabled: root.open
                yAxis.enabled: true
                xAxis.enabled: false
                onActiveChanged: {
                    root._dragging = active
                    if (!active) {
                        if (root._dragOffset >= root.dismissDragThreshold)
                            root.reject()
                        else
                            root._dragOffset = 0
                    }
                }
                onTranslationChanged: {
                    if (active)
                        root._dragOffset = Math.max(0, translation.y)
                }
            }
        }

        Md3VStack {
            id: sheetBody
            anchors.top: parent.top
            anchors.topMargin: 36
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.leftMargin: 16
            anchors.rightMargin: 16
            anchors.bottomMargin: 16
            spacing: 12
            fillWidth: true

            // Expose contentImplicitHeight-compatible metric for sheet height.
            readonly property real contentImplicitHeight: implicitHeight

            Md3Text {
                visible: root.title.length > 0
                width: parent.width
                text: root.title
                role: Md3Text.TitleLarge
                wrapMode: Text.WordWrap
            }
            Md3Text {
                visible: root.text.length > 0
                width: parent.width
                text: root.text
                role: Md3Text.BodyMedium
                tone: Md3Text.OnSurfaceVariant
                wrapMode: Text.WordWrap
            }
            Md3ContainerBody {
                id: bodyHost
                width: parent.width
                layoutMode: root.layoutMode
                height: root.layoutMode === Md3ContainerBody.Scroll
                        ? Math.max(80, sheet.height - root._chromeH - 24)
                        : implicitHeight

                Item {
                    id: bodySlot
                    width: parent.width
                    height: childrenRect.height
                    implicitHeight: childrenRect.height
                }
            }
            Md3HStack {
                visible: root.confirmText.length > 0 || root.dismissText.length > 0
                spacing: 8
                Md3Spacer { expand: true }
                Md3Button {
                    id: dismissBtn
                    visible: root.dismissText.length > 0
                    text: root.dismissText
                    variant: Md3Button.Text
                    onClicked: root.reject()
                }
                Md3Button {
                    id: confirmBtn
                    visible: root.confirmText.length > 0
                    text: root.confirmText
                    variant: Md3Button.Text
                    onClicked: root.accept()
                }
            }
        }
    }
}
