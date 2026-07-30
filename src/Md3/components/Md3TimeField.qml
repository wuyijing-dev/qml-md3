import QtQuick
import Md3

/// Docked MD3 time field: text field + time picker popup (peer of Md3DateField).
Item {
    id: root

    property alias label: field.label
    property alias supportingText: field.supportingText
    property alias errorText: field.errorText
    property alias error: field.error
    property alias placeholderText: field.placeholderText
    /// 0–23
    property int hour: 10
    /// 0–59
    property int minute: 0
    property bool use24Hour: false
    property bool controlEnabled: true
    property string accessibleName: ""
    property string name: ""
    /// Optional explicit Window for overlay reparent (else Window.window).
    property var overlayWindow: null

    signal accepted(int hour, int minute)

    readonly property bool pickerOpen: host.visible

    implicitWidth: 200
    implicitHeight: field.implicitHeight
    width: implicitWidth
    height: implicitHeight

    Accessible.role: Accessible.EditableText
    Accessible.name: accessibleName.length ? accessibleName : (label.length ? label : qsTr("Time field"))

    function formatTime(h, m) {
        const hh = Math.max(0, Math.min(23, h | 0))
        const mm = Math.max(0, Math.min(59, m | 0))
        if (use24Hour) {
            return String(hh).padStart(2, "0") + ":" + String(mm).padStart(2, "0")
        }
        const pm = hh >= 12
        let h12 = hh % 12
        if (h12 === 0)
            h12 = 12
        return String(h12) + ":" + String(mm).padStart(2, "0") + (pm ? " PM" : " AM")
    }

    function openPicker() {
        if (!controlEnabled)
            return
        hostEnsureParent()
        picker.hour = hour
        picker.minute = minute
        picker.use24Hour = use24Hour
        picker.displayMode = Md3TimePicker.Dial
        picker.dialSelection = Md3TimePicker.Hour

        const target = _contentItem()
        if (!target)
            return
        const p = Md3OverlayHost.mapToOverlay(field, 0, field.height + 4, root.overlayWindow)
        const pw = picker.implicitWidth
        const ph = picker.implicitHeight
        host.panelX = Math.max(8, Math.min(p.x, target.width - pw - 8))
        host.panelY = Math.max(8, Math.min(p.y, target.height - ph - 8))
        host.visible = true
    }

    function closePicker() {
        host.visible = false
    }

    function _contentItem() {
        return Md3OverlayHost.contentItem(root.overlayWindow, root)
    }

    function hostEnsureParent() {
        Md3OverlayHost.ensureHostParent(host, root.overlayWindow, root, 5600)
    }

    function applyTime(h, m) {
        hour = h
        minute = m
        field.text = formatTime(hour, minute)
        accepted(hour, minute)
        closePicker()
    }

    function syncField() {
        field.text = formatTime(hour, minute)
    }

    onHourChanged: syncField()
    onMinuteChanged: syncField()
    onUse24HourChanged: syncField()
    Component.onCompleted: syncField()

    Md3TextField {
        id: field
        width: parent.width
        variant: Md3TextField.Outlined
        trailingIcon: "schedule"
        clearOnTrailing: false
        enabled: root.controlEnabled
        accessibleName: root.accessibleName.length ? root.accessibleName
                        : (label.length ? label : qsTr("Time"))
        onTrailingClicked: root.openPicker()
        onAccepted: {
            // Accept "H:MM", "HH:MM", optional AM/PM
            let t = String(text || "").trim().toUpperCase()
            let pm = null
            if (t.endsWith("AM") || t.endsWith("PM")) {
                pm = t.endsWith("PM")
                t = t.slice(0, -2).trim()
            }
            const parts = t.split(":")
            if (parts.length < 2) {
                syncField()
                return
            }
            let h = parseInt(parts[0], 10)
            let m = parseInt(parts[1], 10)
            if (!isFinite(h) || !isFinite(m)) {
                syncField()
                return
            }
            if (pm !== null) {
                if (h === 12)
                    h = pm ? 12 : 0
                else
                    h = pm ? h + 12 : h
            }
            root.applyTime(Math.max(0, Math.min(23, h)), Math.max(0, Math.min(59, m)))
        }
    }

    Item {
        id: host
        visible: false
        parent: root
        width: 0
        height: 0
        property real panelX: 0
        property real panelY: 0

        Rectangle {
            anchors.fill: parent
            color: "transparent"
            MouseArea {
                anchors.fill: parent
                enabled: host.visible
                cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                onClicked: root.closePicker()
            }
        }

        Item {
            x: host.panelX
            y: host.panelY
            width: picker.implicitWidth
            height: picker.implicitHeight

            Md3Shadow {
                anchors.fill: parent
                elevation: 3
                cornerRadius: Md3Theme.shape.extraLarge
            }

            Md3TimePicker {
                id: picker
                modal: false
                open: true
                showActions: true
                title: root.label.length ? root.label : qsTr("Select time")
                onAccepted: function (h, m) { root.applyTime(h, m) }
                onCancelled: root.closePicker()
            }
        }
    }
}
