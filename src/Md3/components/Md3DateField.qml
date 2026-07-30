import QtQuick
import QtQuick.Window
import Md3

/// Docked MD3 date field: text field + calendar popup (Material docked date picker).
Item {
    id: root

    property alias label: field.label
    property alias supportingText: field.supportingText
    property alias errorText: field.errorText
    property alias error: field.error
    property alias placeholderText: field.placeholderText
    property date selectedDate: new Date()
    property date minimumDate
    property date maximumDate
    property string dateFormat: "yyyy-MM-dd"
    property int weekStartsOn: -1
    property bool controlEnabled: true
    property string accessibleName: ""

    signal accepted(date date)

    readonly property bool pickerOpen: host.visible

    implicitWidth: 280
    implicitHeight: field.implicitHeight
    width: implicitWidth
    height: implicitHeight

    function openPicker() {
        if (!controlEnabled)
            return
        hostEnsureParent()
        picker.selectedDate = selectedDate
        if (minimumDate && !isNaN(minimumDate.getTime()))
            picker.minimumDate = minimumDate
        if (maximumDate && !isNaN(maximumDate.getTime()))
            picker.maximumDate = maximumDate
        if (weekStartsOn >= 0)
            picker.weekStartsOn = weekStartsOn
        picker.dateFormat = dateFormat
        picker.displayMode = Md3DatePicker.Calendar
        picker.yearPickerOpen = false

        const target = _contentItem()
        const p = field.mapToItem(target, 0, field.height + 4)
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
        const win = Window.window
        return (win && win.contentItem) ? win.contentItem : null
    }

    function hostEnsureParent() {
        const target = _contentItem()
        if (!target)
            return
        if (host.parent !== target) {
            host.parent = target
            host.anchors.fill = target
        }
        host.z = 5600
    }

    function applyDate(d) {
        selectedDate = new Date(d.getFullYear(), d.getMonth(), d.getDate())
        field.text = Qt.formatDate(selectedDate, dateFormat)
        accepted(selectedDate)
        closePicker()
    }

    onSelectedDateChanged: field.text = Qt.formatDate(selectedDate, dateFormat)
    Component.onCompleted: field.text = Qt.formatDate(selectedDate, dateFormat)

    Md3TextField {
        id: field
        width: parent.width
        variant: Md3TextField.Outlined
        trailingIcon: "calendar_today"
        clearOnTrailing: false
        enabled: root.controlEnabled
        accessibleName: root.accessibleName.length ? root.accessibleName
                        : (label.length ? label : qsTr("Date"))
        onTrailingClicked: root.openPicker()
        onAccepted: {
            const parsed = Date.fromLocaleString(Qt.locale(), text.trim(), root.dateFormat)
            if (parsed && !isNaN(parsed.getTime()))
                root.applyDate(parsed)
            else
                text = Qt.formatDate(root.selectedDate, root.dateFormat)
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

            Md3DatePicker {
                id: picker
                modal: false
                open: true
                showActions: true
                title: root.label.length ? root.label : qsTr("Select date")
                onAccepted: function (d) { root.applyDate(d) }
                onCancelled: root.closePicker()
            }
        }
    }
}
