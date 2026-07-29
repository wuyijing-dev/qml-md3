import QtQuick

/// Material 3 time picker — dial / keyboard input, hour↔minute, AM/PM, 12h/24h, modal.
Item {
    id: root

    enum DisplayMode { Dial, Input }
    enum DialSelection { Hour, Minute }

    property string title: qsTr("Select time")
    /// 0–23 always stored in 24h
    property int hour: 10
    property int minute: 0
    property bool use24Hour: false
    property int displayMode: Md3TimePicker.Dial
    property int dialSelection: Md3TimePicker.Hour
    property bool showModeToggle: true
    property bool showActions: true
    property string confirmText: qsTr("OK")
    property string dismissText: qsTr("Cancel")
    property bool modal: false
    property bool open: true
    property int minuteStep: 1 // dial snap; 5 matches classic MD clock ticks

    signal accepted(int hour, int minute)
    signal cancelled()
    signal timeChanged(int hour, int minute)

    readonly property bool isPm: hour >= 12
    readonly property int displayHour12: {
        const h = hour % 12
        return h === 0 ? 12 : h
    }
    readonly property int displayHour: use24Hour ? hour : displayHour12
    readonly property real dialAngle: {
        if (dialSelection === Md3TimePicker.Minute)
            return (minute % 60) * 6
        if (use24Hour) {
            // 24h dial: 0–23 mapped around circle (outer feel via 0-23 labels optional)
            return ((hour % 24) % 12) * 30
        }
        return (displayHour12 % 12) * 30
    }

    implicitWidth: 328
    implicitHeight: panel.implicitHeight
    width: modal ? (parent ? parent.width : implicitWidth) : implicitWidth
    height: modal ? (parent ? parent.height : implicitHeight) : implicitHeight
    visible: modal ? open : true

    function setPeriod(pm) {
        if (use24Hour)
            return
        const h12 = displayHour12 // 1–12
        if (pm)
            hour = h12 === 12 ? 12 : h12 + 12
        else
            hour = h12 === 12 ? 0 : h12
        timeChanged(hour, minute)
    }

    function applyDialFromPoint(mx, my, dialSize) {
        const dx = mx - dialSize / 2
        const dy = my - dialSize / 2
        let deg = Math.atan2(dy, dx) * 180 / Math.PI + 90
        if (deg < 0)
            deg += 360
        if (dialSelection === Md3TimePicker.Minute) {
            let m = Math.round(deg / 6) % 60
            if (minuteStep > 1)
                m = Math.round(m / minuteStep) * minuteStep % 60
            minute = m
            timeChanged(hour, minute)
        } else {
            let h = Math.round(deg / 30) % 12
            if (h === 0)
                h = 12
            setHourFrom12(h)
        }
    }

    function setHourFrom12(h12) {
        const n = Math.max(1, Math.min(12, h12))
        if (use24Hour) {
            const pmBand = hour >= 12
            if (pmBand)
                hour = n === 12 ? 12 : n + 12
            else
                hour = n === 12 ? 0 : n
        } else if (isPm) {
            hour = n === 12 ? 12 : n + 12
        } else {
            hour = n === 12 ? 0 : n
        }
        timeChanged(hour, minute)
    }

    function toggleDisplayMode() {
        if (displayMode === Md3TimePicker.Dial) {
            displayMode = Md3TimePicker.Input
            syncInputs()
        } else {
            displayMode = Md3TimePicker.Dial
        }
    }

    function syncInputs() {
        hourField.text = String(use24Hour ? hour : displayHour12).padStart(2, "0")
        minuteField.text = String(minute).padStart(2, "0")
    }

    function commitInputs() {
        let h = parseInt(hourField.text, 10)
        let m = parseInt(minuteField.text, 10)
        if (isNaN(h) || isNaN(m)) {
            syncInputs()
            return false
        }
        m = Math.max(0, Math.min(59, m))
        if (use24Hour) {
            h = Math.max(0, Math.min(23, h))
            hour = h
        } else {
            h = Math.max(1, Math.min(12, h))
            if (isPm)
                hour = h === 12 ? 12 : h + 12
            else
                hour = h === 12 ? 0 : h
        }
        minute = m
        timeChanged(hour, minute)
        syncInputs()
        return true
    }

    function confirm() {
        if (displayMode === Md3TimePicker.Input && !commitInputs())
            return
        accepted(hour, minute)
        if (modal)
            open = false
    }

    function cancel() {
        cancelled()
        if (modal)
            open = false
    }

    Component.onCompleted: syncInputs()
    onHourChanged: if (displayMode === Md3TimePicker.Input) syncInputs()
    onMinuteChanged: if (displayMode === Md3TimePicker.Input) syncInputs()
    onUse24HourChanged: syncInputs()

    Rectangle {
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
            enabled: root.modal && root.open
            cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
            onClicked: root.cancel()
        }
    }

    Rectangle {
        id: panel
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: root.modal ? parent.verticalCenter : undefined
        anchors.top: root.modal ? undefined : parent.top
        width: Math.min(328, root.modal && parent.width > 0 ? parent.width - 48 : 328)
        implicitHeight: col.implicitHeight
        height: implicitHeight
        radius: Md3Theme.shape.extraLarge
        color: Md3Theme.colorScheme.surfaceContainerHigh
        clip: true
        scale: root.modal ? (root.open ? 1 : 0.92) : 1
        opacity: root.modal ? (root.open ? 1 : 0) : 1

        Column {
            id: col
            width: parent.width
            padding: 24
            spacing: 16

            readonly property real contentWidth: width - leftPadding - rightPadding

            // Header + mode toggle (width must exclude Column padding or the icon hangs outside)
            Item {
                width: col.contentWidth
                height: 48
                Text {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: modeToggle.left
                    anchors.rightMargin: 8
                    text: root.title
                    elide: Text.ElideRight
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.family: Md3Theme.typography.fontFamily
                    font.pixelSize: Md3Theme.typography.labelMedium.size
                    font.weight: Font.Medium
                }
                Md3IconButton {
                    id: modeToggle
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    visible: root.showModeToggle
                    icon: root.displayMode === Md3TimePicker.Dial ? "keyboard" : "schedule"
                    accessibleName: qsTr("Toggle input mode")
                    onClicked: root.toggleDisplayMode()
                }
            }

            // Time selectors + period
            Row {
                spacing: 12
                width: col.contentWidth

                Item { width: Math.max(0, (parent.width - timeRow.width - (periodSel.visible ? periodSel.width + 12 : 0)) / 2); height: 1 }

                Row {
                    id: timeRow
                    spacing: 4

                    // Hour chip
                    Rectangle {
                        width: 96
                        height: 80
                        radius: Md3Theme.shape.small
                        color: root.dialSelection === Md3TimePicker.Hour
                               ? Md3Theme.colorScheme.primaryContainer
                               : Md3Theme.colorScheme.surfaceContainerHighest
                        Text {
                            anchors.centerIn: parent
                            text: String(root.displayHour).padStart(2, "0")
                            color: root.dialSelection === Md3TimePicker.Hour
                                   ? Md3Theme.colorScheme.colorOnPrimaryContainer
                                   : Md3Theme.colorScheme.colorOnSurface
                            font.family: Md3Theme.typography.fontFamily
                            font.pixelSize: Md3Theme.typography.displayLarge.size
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                root.dialSelection = Md3TimePicker.Hour
                                if (root.displayMode === Md3TimePicker.Input)
                                    hourField.forceActiveFocus()
                            }
                        }
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: ":"
                        color: Md3Theme.colorScheme.colorOnSurface
                        font.pixelSize: Md3Theme.typography.displayLarge.size
                        font.weight: Font.Bold
                    }

                    // Minute chip
                    Rectangle {
                        width: 96
                        height: 80
                        radius: Md3Theme.shape.small
                        color: root.dialSelection === Md3TimePicker.Minute
                               ? Md3Theme.colorScheme.primaryContainer
                               : Md3Theme.colorScheme.surfaceContainerHighest
                        Text {
                            anchors.centerIn: parent
                            text: String(root.minute).padStart(2, "0")
                            color: root.dialSelection === Md3TimePicker.Minute
                                   ? Md3Theme.colorScheme.colorOnPrimaryContainer
                                   : Md3Theme.colorScheme.colorOnSurface
                            font.family: Md3Theme.typography.fontFamily
                            font.pixelSize: Md3Theme.typography.displayLarge.size
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                root.dialSelection = Md3TimePicker.Minute
                                if (root.displayMode === Md3TimePicker.Input)
                                    minuteField.forceActiveFocus()
                            }
                        }
                    }
                }

                // AM/PM period selector — selected uses primaryContainer (same family as hour/minute chips)
                Rectangle {
                    id: periodSel
                    visible: !root.use24Hour
                    width: 52
                    height: 80
                    radius: Md3Theme.shape.small
                    color: Md3Theme.colorScheme.surfaceContainerHighest
                    border.width: 1
                    border.color: Md3Theme.colorScheme.outline
                    clip: true

                    readonly property real corner: Md3Theme.shape.small

                    Column {
                        anchors.fill: parent
                        anchors.margins: 1 // keep fill inside outline
                        spacing: 0

                        Rectangle {
                            width: parent.width
                            height: (parent.height - 1) / 2
                            color: !root.isPm ? Md3Theme.colorScheme.primaryContainer
                                              : "transparent"
                            topLeftRadius: periodSel.corner
                            topRightRadius: periodSel.corner
                            bottomLeftRadius: 0
                            bottomRightRadius: 0
                            Text {
                                anchors.centerIn: parent
                                text: qsTr("AM")
                                color: !root.isPm ? Md3Theme.colorScheme.colorOnPrimaryContainer
                                                  : Md3Theme.colorScheme.colorOnSurfaceVariant
                                font.family: Md3Theme.typography.fontFamily
                                font.pixelSize: Md3Theme.typography.titleMedium.size
                                font.weight: Font.Medium
                            }
                            MouseArea {
                                cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                                anchors.fill: parent
                                onClicked: root.setPeriod(false)
                            }
                        }
                        Rectangle {
                            width: parent.width
                            height: 1
                            color: Md3Theme.colorScheme.outline
                        }
                        Rectangle {
                            width: parent.width
                            height: (parent.height - 1) / 2
                            color: root.isPm ? Md3Theme.colorScheme.primaryContainer
                                             : "transparent"
                            topLeftRadius: 0
                            topRightRadius: 0
                            bottomLeftRadius: periodSel.corner
                            bottomRightRadius: periodSel.corner
                            Text {
                                anchors.centerIn: parent
                                text: qsTr("PM")
                                color: root.isPm ? Md3Theme.colorScheme.colorOnPrimaryContainer
                                                 : Md3Theme.colorScheme.colorOnSurfaceVariant
                                font.family: Md3Theme.typography.fontFamily
                                font.pixelSize: Md3Theme.typography.titleMedium.size
                                font.weight: Font.Medium
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: root.setPeriod(true)
                            }
                        }
                    }
                }
            }

            // Dial
            Item {
                id: dial
                visible: root.displayMode === Md3TimePicker.Dial
                width: 256
                height: 256
                anchors.horizontalCenter: parent.horizontalCenter

                Rectangle {
                    anchors.fill: parent
                    radius: width / 2
                    color: Md3Theme.colorScheme.surfaceContainerHighest

                    // Hour labels 1–12 or minute ticks 0,5,…55
                    Repeater {
                        model: 12
                        delegate: Item {
                            id: tick
                            required property int index
                            readonly property int value: root.dialSelection === Md3TimePicker.Minute
                                                         ? index * 5 : (index + 1)
                            readonly property real ang: root.dialSelection === Md3TimePicker.Minute
                                                        ? (tick.value % 60) * 6 - 90
                                                        : (tick.value % 12) * 30 - 90
                            readonly property real rad: 100
                            readonly property bool selected: {
                                if (root.dialSelection === Md3TimePicker.Minute) {
                                    const nearest = Math.round(root.minute / 5) * 5 % 60
                                    return tick.value === nearest
                                }
                                return root.displayHour12 === tick.value
                            }
                            x: dial.width / 2 + Math.cos(ang * Math.PI / 180) * rad - 20
                            y: dial.height / 2 + Math.sin(ang * Math.PI / 180) * rad - 20
                            width: 40
                            height: 40

                            Rectangle {
                                anchors.centerIn: parent
                                width: 40
                                height: 40
                                radius: 20
                                color: tick.selected ? Md3Theme.colorScheme.primary : "transparent"
                                Text {
                                    anchors.centerIn: parent
                                    text: root.dialSelection === Md3TimePicker.Minute
                                          ? String(tick.value).padStart(2, "0")
                                          : String(tick.value)
                                    color: tick.selected ? Md3Theme.colorScheme.colorOnPrimary
                                                         : Md3Theme.colorScheme.colorOnSurface
                                    font.family: Md3Theme.typography.fontFamily
                                    font.pixelSize: Md3Theme.typography.bodyLarge.size
                                }
                            }
                        }
                    }

                    // Hand
                    Rectangle {
                        width: 2
                        height: 88
                        radius: 1
                        color: Md3Theme.colorScheme.primary
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.verticalCenter
                        transformOrigin: Item.Bottom
                        rotation: root.dialAngle
                        Behavior on rotation {
                            RotationAnimation {
                                duration: Md3Motion.short4
                                direction: RotationAnimation.Shortest
                                easing.type: Easing.BezierSpline
                                easing.bezierCurve: Md3Motion.emphasized
                            }
                        }
                    }

                    // Thumb at tip
                    Item {
                        anchors.centerIn: parent
                        width: 1
                        height: 1
                        Rectangle {
                            width: 40
                            height: 40
                            radius: 20
                            color: Md3Theme.colorScheme.primary
                            x: Math.cos((root.dialAngle - 90) * Math.PI / 180) * 100 - width / 2
                            y: Math.sin((root.dialAngle - 90) * Math.PI / 180) * 100 - height / 2
                            opacity: 0 // selection circle already on label
                        }
                    }

                    Rectangle {
                        anchors.centerIn: parent
                        width: 8
                        height: 8
                        radius: 4
                        color: Md3Theme.colorScheme.primary
                    }

                    MouseArea {
                        anchors.fill: parent
                        preventStealing: true
                        property bool startedOnHour: false
                        onPressed: function (mouse) {
                            startedOnHour = root.dialSelection === Md3TimePicker.Hour
                            root.applyDialFromPoint(mouse.x, mouse.y, width)
                        }
                        onPositionChanged: function (mouse) {
                            if (pressed)
                                root.applyDialFromPoint(mouse.x, mouse.y, width)
                        }
                        onReleased: {
                            if (startedOnHour && root.dialSelection === Md3TimePicker.Hour)
                                root.dialSelection = Md3TimePicker.Minute
                        }
                    }
                }
            }

            // Input mode fields
            Row {
                visible: root.displayMode === Md3TimePicker.Input
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 8

                Md3TextField {
                    id: hourField
                    width: 96
                    variant: Md3TextField.Outlined
                    label: qsTr("Hour")
                    onAccepted: minuteField.forceActiveFocus()
                }
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: ":"
                    font.pixelSize: 28
                    color: Md3Theme.colorScheme.colorOnSurface
                }
                Md3TextField {
                    id: minuteField
                    width: 96
                    variant: Md3TextField.Outlined
                    label: qsTr("Minute")
                    onAccepted: root.confirm()
                }
            }

            // 24h toggle (desktop convenience)
            Row {
                spacing: 8
                Md3Switch {
                    id: h24
                    checked: root.use24Hour
                    onToggled: function (v) { root.use24Hour = v }
                }
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("24-hour")
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.pixelSize: Md3Theme.typography.bodyMedium.size
                }
            }

            Row {
                visible: root.showActions
                anchors.right: parent.right
                spacing: 8
                Md3Button {
                    text: root.dismissText
                    variant: Md3Button.Text
                    onClicked: root.cancel()
                }
                Md3Button {
                    text: root.confirmText
                    variant: Md3Button.Text
                    onClicked: root.confirm()
                }
            }
        }
    }
}
