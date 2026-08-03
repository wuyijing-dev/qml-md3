import QtQuick
import Md3

/// Modal dialog with optional scrollable body and confirm tone.
Item {
    id: root

    enum ConfirmTone { Primary, Error }

    property bool open: false
    property string title: ""
    property string text: ""
    property string confirmText: qsTr("OK")
    property string dismissText: qsTr("Cancel")
    property bool showDismiss: true
    /// Cap body height; content scrolls when taller.
    property real bodyMaxHeight: 280
    /// Primary (default) or Error/destructive confirm button.
    property int confirmTone: Md3Dialog.Primary
    /// When true (default), close writes ``open = false``. Set false if ``open`` is bound externally.
    property bool writeOpenOnClose: true
    /// Panel width cap (also used as form ``contentWidth``).
    property real preferredWidth: 560
    /// Stable width for children (``parent ? parent.width : 280`` → use this).
    readonly property real contentWidth: panel.width > 1 ? panel.width - 48 : Math.min(preferredWidth, 400)
    /// Custom body between text and action buttons.
    default property alias content: bodySlot.data

    signal confirmed()
    signal dismissed()

    anchors.fill: parent
    visible: open || scrim.opacity > 0
    z: 1000
    focus: open
    Accessible.role: Accessible.Dialog
    Accessible.name: title.length ? title : qsTr("Dialog")
    Accessible.description: text

    property var _focusBeforeOpen: null

    function accept() {
        confirmed()
        if (writeOpenOnClose)
            open = false
    }

    function reject() {
        dismissed()
        if (writeOpenOnClose)
            open = false
    }

    function _restoreFocus() {
        const prev = _focusBeforeOpen
        _focusBeforeOpen = null
        if (prev && typeof prev.forceActiveFocus === "function")
            Qt.callLater(function () {
                try { prev.forceActiveFocus() } catch (e) { /* destroyed */ }
            })
    }

    function _enterShouldAccept() {
        const win = Md3OverlayHost.resolveWindow(null, root)
        const f = win ? win.activeFocusItem : null
        if (!f || f === root || f === panel || f === confirmBtn || f === dismissBtn)
            return true
        if (f.text !== undefined && f.cursorPosition !== undefined && f.readOnly !== true)
            return false
        return true
    }

    onOpenChanged: {
        if (open) {
            const win = Md3OverlayHost.resolveWindow(null, root)
            if (win && win.activeFocusItem)
                _focusBeforeOpen = win.activeFocusItem
            forceActiveFocus()
            Qt.callLater(function () {
                if (!root.open)
                    return
                if (confirmBtn.visible)
                    confirmBtn.forceActiveFocus()
                else if (dismissBtn.visible)
                    dismissBtn.forceActiveFocus()
            })
        } else {
            _restoreFocus()
        }
    }

    Keys.onPressed: function (event) {
        if (!open)
            return
        if (event.key === Qt.Key_Escape) {
            reject()
            event.accepted = true
        } else if ((event.key === Qt.Key_Return || event.key === Qt.Key_Enter)
                   && _enterShouldAccept()) {
            accept()
            event.accepted = true
        }
    }

    Rectangle {
        id: scrim
        anchors.fill: parent
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
            cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
            anchors.fill: parent
            onClicked: root.reject()
        }
    }

    Rectangle {
        id: panel
        anchors.centerIn: parent
        width: Math.min(parent.width - 48, preferredWidth)
        implicitHeight: col.implicitHeight + 24
        height: implicitHeight
        radius: Md3Theme.shape.extraLarge
        color: Md3Theme.colorScheme.surfaceContainerHigh
        scale: root.open ? 1 : 0.9
        opacity: root.open ? 1 : 0

        Behavior on scale {
            NumberAnimation {
                    duration: Md3Motion.menuDuration
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Md3Motion.emphasizedDecelerate
                }
        }
        Behavior on opacity {
            NumberAnimation {
                    duration: Md3Motion.overlayDuration
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Md3Motion.standard
                }
        }

        Md3FocusRing {
            anchors.fill: parent
            anchors.margins: -4
            radius: panel.radius + 4
            focused: root.activeFocus
            controlEnabled: true
            visualFocus: root.activeFocus && Md3Accessibility.showFocusRings
        }

        Column {
            id: col
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 24
            spacing: 16

            Text {
                width: parent.width
                text: root.title
                visible: root.title.length > 0
                color: Md3Theme.colorScheme.colorOnSurface
                font.family: Md3Theme.typography.fontFamily
                font.pixelSize: Md3Theme.typography.headlineSmall.size
                wrapMode: Text.Wrap
            }
            Text {
                width: parent.width
                text: root.text
                visible: root.text.length > 0
                color: Md3Theme.colorScheme.colorOnSurfaceVariant
                font.family: Md3Theme.typography.fontFamily
                font.pixelSize: Md3Theme.typography.bodyMedium.size
                wrapMode: Text.Wrap
            }

            Flickable {
                id: bodyFlick
                width: parent.width
                visible: bodySlot.children.length > 0
                contentWidth: width
                contentHeight: bodySlot.childrenRect.height
                height: Math.min(root.bodyMaxHeight, Math.max(0, contentHeight))
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                interactive: contentHeight > height + 0.5

                Item {
                    id: bodySlot
                    width: bodyFlick.width
                    height: childrenRect.height
                }

                Md3ScrollBar {
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    flickable: bodyFlick
                    orientation: Qt.Vertical
                }
            }

            Row {
                anchors.right: parent.right
                spacing: 8
                Md3Button {
                    id: dismissBtn
                    visible: root.showDismiss
                    text: root.dismissText
                    variant: Md3Button.Text
                    onClicked: root.reject()
                }
                Md3Button {
                    id: confirmBtn
                    text: root.confirmText
                    variant: root.confirmTone === Md3Dialog.Error ? Md3Button.Filled : Md3Button.Text
                    danger: root.confirmTone === Md3Dialog.Error
                    onClicked: root.accept()
                }
            }
        }
    }
}
