import QtQuick

/// Material 3 date picker — calendar / input, year grid, min/max, today, week start.
/// Inline by default. Set `modal: true` and `open` with anchors.fill on a host for dialog overlay.
Item {
    id: root

    enum DisplayMode { Calendar, Input }

    property string title: qsTr("Select date")
    property date selectedDate: new Date()
    property date viewDate: selectedDate
    property date minimumDate
    property date maximumDate
    /// 0 = Sunday … 6 = Saturday
    property int weekStartsOn: {
        switch (Qt.locale().firstDayOfWeek) {
        case Locale.Monday: return 1
        case Locale.Saturday: return 6
        default: return 0
        }
    }
    property int displayMode: Md3DatePicker.Calendar
    property bool showModeToggle: true
    property bool showTodayIndicator: true
    property bool showOutsideDays: true
    property bool showActions: true
    property bool yearPickerOpen: false
    property int yearFrom: 1900
    property int yearTo: 2100
    property string confirmText: qsTr("OK")
    property string dismissText: qsTr("Cancel")
    property string dateFormat: "yyyy-MM-dd"
    property bool modal: false
    property bool open: true

    signal accepted(date date)
    signal cancelled()
    signal dateClicked(date date)

    readonly property date today: {
        const n = new Date()
        return new Date(n.getFullYear(), n.getMonth(), n.getDate())
    }

    implicitWidth: 360
    implicitHeight: panel.implicitHeight
    width: modal ? (parent ? parent.width : implicitWidth) : implicitWidth
    height: modal ? (parent ? parent.height : implicitHeight) : implicitHeight
    visible: modal ? open : true

    function daysInMonth(year, month) {
        return new Date(year, month + 1, 0).getDate()
    }

    function stripTime(d) {
        if (!d || isNaN(d.getTime()))
            return null
        return new Date(d.getFullYear(), d.getMonth(), d.getDate())
    }

    function sameDay(a, b) {
        const x = stripTime(a)
        const y = stripTime(b)
        return !!(x && y && x.getTime() === y.getTime())
    }

    function hasMin() { return !!(minimumDate && !isNaN(minimumDate.getTime())) }
    function hasMax() { return !!(maximumDate && !isNaN(maximumDate.getTime())) }

    function isDateEnabled(d) {
        const t = stripTime(d)
        if (!t)
            return false
        if (hasMin() && t.getTime() < stripTime(minimumDate).getTime())
            return false
        if (hasMax() && t.getTime() > stripTime(maximumDate).getTime())
            return false
        return true
    }

    function clampToBounds(d) {
        let t = stripTime(d) || stripTime(new Date())
        if (hasMin() && t.getTime() < stripTime(minimumDate).getTime())
            t = stripTime(minimumDate)
        if (hasMax() && t.getTime() > stripTime(maximumDate).getTime())
            t = stripTime(maximumDate)
        return t
    }

    function weekdayLabels() {
        const base = [
            qsTr("S"), qsTr("M"), qsTr("T"), qsTr("W"),
            qsTr("T"), qsTr("F"), qsTr("S")
        ]
        const out = []
        for (let i = 0; i < 7; ++i)
            out.push(base[(weekStartsOn + i) % 7])
        return out
    }

    function calendarCells() {
        const y = viewDate.getFullYear()
        const m = viewDate.getMonth()
        const first = new Date(y, m, 1)
        const startPad = (first.getDay() - weekStartsOn + 7) % 7
        const dim = daysInMonth(y, m)
        const prevDim = daysInMonth(y, m - 1)
        const cells = []
        for (let i = 0; i < startPad; ++i) {
            const day = prevDim - startPad + i + 1
            cells.push({ day: day, date: new Date(y, m - 1, day), inMonth: false })
        }
        for (let d = 1; d <= dim; ++d)
            cells.push({ day: d, date: new Date(y, m, d), inMonth: true })
        const fill = (7 - (cells.length % 7)) % 7
        for (let i = 1; i <= fill; ++i)
            cells.push({ day: i, date: new Date(y, m + 1, i), inMonth: false })
        if (!showOutsideDays) {
            for (let i = 0; i < cells.length; ++i) {
                if (!cells[i].inMonth)
                    cells[i] = { day: 0, date: null, inMonth: false }
            }
        }
        return cells
    }

    function shiftMonth(delta) {
        viewDate = new Date(viewDate.getFullYear(), viewDate.getMonth() + delta, 1)
    }

    function selectDate(d) {
        if (!isDateEnabled(d))
            return
        selectedDate = stripTime(d)
        viewDate = new Date(selectedDate.getFullYear(), selectedDate.getMonth(), 1)
        dateClicked(selectedDate)
        inputField.text = Qt.formatDate(selectedDate, dateFormat)
    }

    function commitInput() {
        const raw = String(inputField.text || "").trim()
        let parsed = Date.fromLocaleString(Qt.locale(), raw, dateFormat)
        if (!parsed || isNaN(parsed.getTime())) {
            const iso = Date.parse(raw)
            if (isNaN(iso)) {
                inputField.text = Qt.formatDate(selectedDate, dateFormat)
                return false
            }
            parsed = new Date(iso)
        }
        if (!isDateEnabled(parsed)) {
            inputField.text = Qt.formatDate(selectedDate, dateFormat)
            return false
        }
        selectDate(parsed)
        return true
    }

    function confirm() {
        if (displayMode === Md3DatePicker.Input && !commitInput())
            return
        selectedDate = clampToBounds(selectedDate)
        accepted(selectedDate)
        if (modal)
            open = false
    }

    function cancel() {
        cancelled()
        if (modal)
            open = false
    }

    function toggleDisplayMode() {
        if (displayMode === Md3DatePicker.Calendar) {
            yearPickerOpen = false
            displayMode = Md3DatePicker.Input
            inputField.text = Qt.formatDate(selectedDate, dateFormat)
        } else {
            displayMode = Md3DatePicker.Calendar
        }
    }

    function pickYear(y) {
        viewDate = new Date(y, viewDate.getMonth(), 1)
        yearPickerOpen = false
    }

    onSelectedDateChanged: {
        if (!yearPickerOpen)
            viewDate = new Date(selectedDate.getFullYear(), selectedDate.getMonth(), 1)
        inputField.text = Qt.formatDate(selectedDate, dateFormat)
    }

    Component.onCompleted: {
        selectedDate = clampToBounds(selectedDate)
        viewDate = new Date(selectedDate.getFullYear(), selectedDate.getMonth(), 1)
        inputField.text = Qt.formatDate(selectedDate, dateFormat)
    }

    // Scrim (modal)
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
            onClicked: root.cancel()
        }
    }

    Rectangle {
        id: panel
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: root.modal ? parent.verticalCenter : undefined
        anchors.top: root.modal ? undefined : parent.top
        width: Math.min(360, root.modal && parent.width > 0 ? parent.width - 48 : 360)
        implicitHeight: col.implicitHeight
        height: implicitHeight
        radius: Md3Theme.shape.extraLarge
        color: Md3Theme.colorScheme.surfaceContainerHigh
        clip: true
        scale: root.modal ? (root.open ? 1 : 0.92) : 1
        opacity: root.modal ? (root.open ? 1 : 0) : 1
        Behavior on scale {
            enabled: root.modal
            NumberAnimation {
                duration: Md3Motion.menuDuration
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Md3Motion.emphasizedDecelerate
            }
        }
        Behavior on opacity {
            enabled: root.modal
            NumberAnimation {
                duration: Md3Motion.overlayDuration
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Md3Motion.standard
            }
        }

        Column {
            id: col
            width: parent.width
            padding: 12
            spacing: 4

            Item {
                width: parent.width
                height: Math.max(headerCol.implicitHeight, 48)

                Column {
                    id: headerCol
                    anchors.left: parent.left
                    anchors.leftMargin: 24
                    anchors.right: modeToggle.left
                    anchors.rightMargin: 8
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 2
                    Text {
                        text: root.title
                        color: Md3Theme.colorScheme.colorOnSurfaceVariant
                        font.family: Md3Theme.typography.fontFamily
                        font.pixelSize: Md3Theme.typography.labelMedium.size
                        font.weight: Font.Medium
                    }
                    Text {
                        width: parent.width
                        text: Qt.formatDate(root.selectedDate, "ddd, MMM d")
                        color: Md3Theme.colorScheme.colorOnSurface
                        font.family: Md3Theme.typography.fontFamily
                        font.pixelSize: Md3Theme.typography.headlineLarge.size
                        elide: Text.ElideRight
                    }
                }

                Md3IconButton {
                    id: modeToggle
                    visible: root.showModeToggle
                    anchors.right: parent.right
                    anchors.rightMargin: 12
                    anchors.verticalCenter: parent.verticalCenter
                    icon: root.displayMode === Md3DatePicker.Calendar ? "edit" : "calendar_today"
                    accessibleName: qsTr("Toggle input mode")
                    onClicked: root.toggleDisplayMode()
                }
            }

            Md3Divider { width: parent.width }

            Row {
                visible: root.displayMode === Md3DatePicker.Calendar
                width: parent.width - 8
                leftPadding: 4

                Item {
                    width: parent.width - 96
                    height: 48
                    Row {
                        anchors.verticalCenter: parent.verticalCenter
                        leftPadding: 8
                        spacing: 4
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: Qt.formatDate(root.viewDate, "MMMM yyyy")
                            color: Md3Theme.colorScheme.colorOnSurfaceVariant
                            font.family: Md3Theme.typography.fontFamily
                            font.pixelSize: Md3Theme.typography.titleSmall.size
                            font.weight: Font.Medium
                        }
                        Md3Icon {
                            anchors.verticalCenter: parent.verticalCenter
                            icon: root.yearPickerOpen ? "arrow_drop_up" : "arrow_drop_down"
                            size: 20
                            iconColor: Md3Theme.colorScheme.colorOnSurfaceVariant
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.yearPickerOpen = !root.yearPickerOpen
                    }
                }

                Md3IconButton {
                    icon: "chevron_left"
                    enabled: {
                        if (!root.hasMin())
                            return true
                        const prevLast = new Date(root.viewDate.getFullYear(), root.viewDate.getMonth(), 0)
                        return prevLast.getTime() >= root.stripTime(root.minimumDate).getTime()
                    }
                    onClicked: root.shiftMonth(-1)
                }
                Md3IconButton {
                    icon: "chevron_right"
                    enabled: {
                        if (!root.hasMax())
                            return true
                        const nextFirst = new Date(root.viewDate.getFullYear(), root.viewDate.getMonth() + 1, 1)
                        return nextFirst.getTime() <= root.stripTime(root.maximumDate).getTime()
                    }
                    onClicked: root.shiftMonth(1)
                }
            }

            Flickable {
                id: yearFlick
                visible: root.displayMode === Md3DatePicker.Calendar && root.yearPickerOpen
                width: parent.width - 24
                height: visible ? 280 : 0
                anchors.horizontalCenter: parent.horizontalCenter
                clip: true
                contentWidth: width
                contentHeight: yearGrid.implicitHeight
                boundsBehavior: Flickable.StopAtBounds

                Grid {
                    id: yearGrid
                    width: yearFlick.width
                    columns: 3
                    rowSpacing: 4
                    columnSpacing: 4

                    Repeater {
                        model: {
                            const arr = []
                            for (let y = root.yearFrom; y <= root.yearTo; ++y)
                                arr.push(y)
                            return arr
                        }
                        delegate: Item {
                            required property int modelData
                            width: (yearGrid.width - 8) / 3
                            height: 48
                            Rectangle {
                                anchors.centerIn: parent
                                width: Math.min(72, parent.width - 4)
                                height: 36
                                radius: 18
                                color: modelData === root.viewDate.getFullYear()
                                       ? Md3Theme.colorScheme.primary : "transparent"
                                border.width: modelData === root.today.getFullYear()
                                              && modelData !== root.viewDate.getFullYear() ? 1 : 0
                                border.color: Md3Theme.colorScheme.primary
                                Text {
                                    anchors.centerIn: parent
                                    text: modelData
                                    color: modelData === root.viewDate.getFullYear()
                                           ? Md3Theme.colorScheme.colorOnPrimary
                                           : Md3Theme.colorScheme.colorOnSurface
                                    font.family: Md3Theme.typography.fontFamily
                                    font.pixelSize: Md3Theme.typography.bodyLarge.size
                                }
                                MouseArea {
                                    cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                                    anchors.fill: parent
                                    onClicked: root.pickYear(modelData)
                                }
                            }
                        }
                    }
                }

                onVisibleChanged: {
                    if (!visible)
                        return
                    const idx = root.viewDate.getFullYear() - root.yearFrom
                    contentY = Math.max(0, Math.floor(idx / 3) * 52 - 100)
                }
            }

            Column {
                visible: root.displayMode === Md3DatePicker.Calendar && !root.yearPickerOpen
                width: parent.width - 24
                anchors.horizontalCenter: parent.horizontalCenter

                Row {
                    id: dowRow
                    width: parent.width
                    Repeater {
                        model: root.weekdayLabels()
                        Text {
                            required property string modelData
                            width: dowRow.width / 7
                            height: 40
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            text: modelData
                            color: Md3Theme.colorScheme.colorOnSurface
                            font.family: Md3Theme.typography.fontFamily
                            font.pixelSize: Md3Theme.typography.bodySmall.size
                            font.weight: Font.Medium
                        }
                    }
                }

                Grid {
                    id: dayGrid
                    width: parent.width
                    columns: 7

                    Repeater {
                        model: root.calendarCells()
                        delegate: Item {
                            id: cell
                            required property var modelData
                            width: dayGrid.width / 7
                            height: 48

                            readonly property var cellDate: modelData.date
                            readonly property bool inMonth: !!modelData.inMonth
                            readonly property bool empty: !cellDate
                            readonly property bool selected: !empty && root.sameDay(cellDate, root.selectedDate)
                            readonly property bool isToday: !empty && root.showTodayIndicator
                                                           && root.sameDay(cellDate, root.today)
                            readonly property bool dayEnabled: !empty && root.isDateEnabled(cellDate)

                            Rectangle {
                                anchors.centerIn: parent
                                width: 40
                                height: 40
                                radius: 20
                                visible: !cell.empty
                                color: cell.selected ? Md3Theme.colorScheme.primary : "transparent"
                                border.width: cell.isToday && !cell.selected ? 1 : 0
                                border.color: Md3Theme.colorScheme.primary
                                opacity: cell.dayEnabled ? 1 : 0.38

                                Text {
                                    anchors.centerIn: parent
                                    text: cell.empty ? "" : cell.modelData.day
                                    color: {
                                        if (cell.selected)
                                            return Md3Theme.colorScheme.colorOnPrimary
                                        if (!cell.inMonth)
                                            return Md3Theme.colorScheme.colorOnSurfaceVariant
                                        if (cell.isToday)
                                            return Md3Theme.colorScheme.primary
                                        return Md3Theme.colorScheme.colorOnSurface
                                    }
                                    font.family: Md3Theme.typography.fontFamily
                                    font.pixelSize: Md3Theme.typography.bodyLarge.size
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    enabled: cell.dayEnabled
                                    cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                                    onClicked: root.selectDate(cell.cellDate)
                                }
                            }
                        }
                    }
                }
            }

            Column {
                visible: root.displayMode === Md3DatePicker.Input
                width: parent.width - 24
                anchors.horizontalCenter: parent.horizontalCenter
                topPadding: 16
                bottomPadding: 8
                spacing: 8

                Text {
                    text: qsTr("Enter date (%1)").arg(root.dateFormat)
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.family: Md3Theme.typography.fontFamily
                    font.pixelSize: Md3Theme.typography.bodySmall.size
                }

                Md3TextField {
                    id: inputField
                    width: parent.width
                    variant: Md3TextField.Outlined
                    label: qsTr("Date")
                    onAccepted: root.confirm()
                }
            }

            Row {
                visible: root.showActions
                anchors.right: parent.right
                anchors.rightMargin: 4
                topPadding: 8
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
