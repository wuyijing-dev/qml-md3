import QtQuick

/// Material 3 date range picker — shared chrome with Md3DatePicker (calendar/input/year/min-max).
Item {
    id: root

    enum DisplayMode { Calendar, Input }

    property string title: qsTr("Select dates")
    property date startDate: new Date()
    property date endDate: new Date()
    property date viewDate: startDate
    property date minimumDate
    property date maximumDate
    property int weekStartsOn: {
        switch (Qt.locale().firstDayOfWeek) {
        case Locale.Monday: return 1
        case Locale.Saturday: return 6
        default: return 0
        }
    }
    property int displayMode: Md3DateRangePicker.Calendar
    property bool showModeToggle: true
    property bool showTodayIndicator: true
    property bool showOutsideDays: true
    property bool showActions: true
    property bool yearPickerOpen: false
    property bool selectingStart: true
    property int yearFrom: 1900
    property int yearTo: 2100
    property string confirmText: qsTr("OK")
    property string dismissText: qsTr("Cancel")
    property string dateFormat: "yyyy-MM-dd"
    property bool modal: false
    property bool open: true

    signal accepted(date start, date end)
    signal cancelled()
    signal rangeChanged(date start, date end)

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

    function dayTime(d) {
        const t = stripTime(d)
        return t ? t.getTime() : NaN
    }

    function sameDay(a, b) {
        const x = dayTime(a)
        const y = dayTime(b)
        return !isNaN(x) && x === y
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

    function inRange(d) {
        const t = dayTime(d)
        const a = dayTime(startDate)
        const b = dayTime(endDate)
        if (isNaN(t) || isNaN(a) || isNaN(b))
            return false
        return t >= Math.min(a, b) && t <= Math.max(a, b)
    }

    function isEndpoint(d) {
        return sameDay(d, startDate) || sameDay(d, endDate)
    }

    function weekdayLabels() {
        const base = [qsTr("S"), qsTr("M"), qsTr("T"), qsTr("W"), qsTr("T"), qsTr("F"), qsTr("S")]
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

    function pickDay(d) {
        if (!isDateEnabled(d))
            return
        const day = stripTime(d)
        if (selectingStart || isNaN(dayTime(startDate))) {
            startDate = day
            endDate = day
            selectingStart = false
        } else {
            if (dayTime(day) < dayTime(startDate)) {
                endDate = startDate
                startDate = day
            } else {
                endDate = day
            }
            selectingStart = true
        }
        rangeChanged(startDate, endDate)
        syncInputs()
    }

    function syncInputs() {
        startField.text = Qt.formatDate(startDate, dateFormat)
        endField.text = Qt.formatDate(endDate, dateFormat)
    }

    function parseField(text) {
        const raw = String(text || "").trim()
        let parsed = Date.fromLocaleString(Qt.locale(), raw, dateFormat)
        if (!parsed || isNaN(parsed.getTime())) {
            const iso = Date.parse(raw)
            if (isNaN(iso))
                return null
            parsed = new Date(iso)
        }
        return isDateEnabled(parsed) ? stripTime(parsed) : null
    }

    function commitInputs() {
        const a = parseField(startField.text)
        const b = parseField(endField.text)
        if (!a || !b)
            return false
        if (dayTime(a) <= dayTime(b)) {
            startDate = a
            endDate = b
        } else {
            startDate = b
            endDate = a
        }
        rangeChanged(startDate, endDate)
        syncInputs()
        return true
    }

    function confirm() {
        if (displayMode === Md3DateRangePicker.Input && !commitInputs())
            return
        if (isNaN(dayTime(startDate)) || isNaN(dayTime(endDate)))
            return
        accepted(startDate, endDate)
        if (modal)
            open = false
    }

    function cancel() {
        cancelled()
        if (modal)
            open = false
    }

    function toggleDisplayMode() {
        if (displayMode === Md3DateRangePicker.Calendar) {
            yearPickerOpen = false
            displayMode = Md3DateRangePicker.Input
            syncInputs()
        } else {
            displayMode = Md3DateRangePicker.Calendar
        }
    }

    function pickYear(y) {
        viewDate = new Date(y, viewDate.getMonth(), 1)
        yearPickerOpen = false
    }

    Component.onCompleted: syncInputs()

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
                        text: {
                            const a = !isNaN(root.dayTime(root.startDate))
                                    ? Qt.formatDate(root.startDate, "MMM d") : "—"
                            const b = !isNaN(root.dayTime(root.endDate))
                                    ? Qt.formatDate(root.endDate, "MMM d") : "—"
                            return a + " – " + b
                        }
                        color: Md3Theme.colorScheme.colorOnSurface
                        font.family: Md3Theme.typography.fontFamily
                        font.pixelSize: Md3Theme.typography.headlineLarge.size
                        elide: Text.ElideRight
                    }
                    Text {
                        text: root.selectingStart ? qsTr("Select start date") : qsTr("Select end date")
                        visible: root.displayMode === Md3DateRangePicker.Calendar
                        color: Md3Theme.colorScheme.primary
                        font.family: Md3Theme.typography.fontFamily
                        font.pixelSize: Md3Theme.typography.labelLarge.size
                    }
                }

                Md3IconButton {
                    id: modeToggle
                    visible: root.showModeToggle
                    anchors.right: parent.right
                    anchors.rightMargin: 12
                    anchors.verticalCenter: parent.verticalCenter
                    icon: root.displayMode === Md3DateRangePicker.Calendar ? "edit" : "calendar_today"
                    accessibleName: qsTr("Toggle input mode")
                    onClicked: root.toggleDisplayMode()
                }
            }

            Md3Divider { width: parent.width }

            Row {
                visible: root.displayMode === Md3DateRangePicker.Calendar
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
                        onClicked: root.yearPickerOpen = !root.yearPickerOpen
                    }
                }
                Md3IconButton {
                    icon: "chevron_left"
                    onClicked: root.shiftMonth(-1)
                }
                Md3IconButton {
                    icon: "chevron_right"
                    onClicked: root.shiftMonth(1)
                }
            }

            Flickable {
                id: yearFlick
                visible: root.displayMode === Md3DateRangePicker.Calendar && root.yearPickerOpen
                width: parent.width - 24
                height: visible ? 280 : 0
                anchors.horizontalCenter: parent.horizontalCenter
                clip: true
                contentWidth: width
                contentHeight: yearGrid.implicitHeight

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
                                Text {
                                    anchors.centerIn: parent
                                    text: modelData
                                    color: modelData === root.viewDate.getFullYear()
                                           ? Md3Theme.colorScheme.colorOnPrimary
                                           : Md3Theme.colorScheme.colorOnSurface
                                    font.pixelSize: Md3Theme.typography.bodyLarge.size
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: root.pickYear(modelData)
                                }
                            }
                        }
                    }
                }
                onVisibleChanged: {
                    if (visible) {
                        const idx = root.viewDate.getFullYear() - root.yearFrom
                        contentY = Math.max(0, Math.floor(idx / 3) * 52 - 100)
                    }
                }
            }

            Column {
                visible: root.displayMode === Md3DateRangePicker.Calendar && !root.yearPickerOpen
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
                            readonly property bool endpoint: !empty && root.isEndpoint(cellDate)
                            readonly property bool mid: !empty && root.inRange(cellDate) && !endpoint
                            readonly property bool isToday: !empty && root.showTodayIndicator
                                                           && root.sameDay(cellDate, root.today)
                            readonly property bool dayEnabled: !empty && root.isDateEnabled(cellDate)

                            Rectangle {
                                anchors.verticalCenter: parent.verticalCenter
                                height: 40
                                width: parent.width
                                visible: cell.mid || (cell.endpoint && root.inRange(cell.cellDate)
                                         && !root.sameDay(root.startDate, root.endDate))
                                color: Md3Theme.colorScheme.secondaryContainer
                                opacity: cell.endpoint ? 0.5 : 1
                            }

                            Rectangle {
                                anchors.centerIn: parent
                                width: 40
                                height: 40
                                radius: 20
                                visible: !cell.empty
                                color: cell.endpoint ? Md3Theme.colorScheme.primary : "transparent"
                                border.width: cell.isToday && !cell.endpoint ? 1 : 0
                                border.color: Md3Theme.colorScheme.primary
                                opacity: cell.dayEnabled ? 1 : 0.38

                                Text {
                                    anchors.centerIn: parent
                                    text: cell.empty ? "" : cell.modelData.day
                                    color: {
                                        if (cell.endpoint)
                                            return Md3Theme.colorScheme.colorOnPrimary
                                        if (cell.mid)
                                            return Md3Theme.colorScheme.colorOnSecondaryContainer
                                        if (!cell.inMonth)
                                            return Md3Theme.colorScheme.colorOnSurfaceVariant
                                        if (cell.isToday)
                                            return Md3Theme.colorScheme.primary
                                        return Md3Theme.colorScheme.colorOnSurface
                                    }
                                    font.pixelSize: Md3Theme.typography.bodyLarge.size
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    enabled: cell.dayEnabled
                                    onClicked: root.pickDay(cell.cellDate)
                                }
                            }
                        }
                    }
                }
            }

            Column {
                visible: root.displayMode === Md3DateRangePicker.Input
                width: parent.width - 24
                anchors.horizontalCenter: parent.horizontalCenter
                topPadding: 12
                bottomPadding: 8
                spacing: 12

                Md3TextField {
                    id: startField
                    width: parent.width
                    variant: Md3TextField.Outlined
                    label: qsTr("Start date")
                    supportingText: root.dateFormat
                }
                Md3TextField {
                    id: endField
                    width: parent.width
                    variant: Md3TextField.Outlined
                    label: qsTr("End date")
                    supportingText: root.dateFormat
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
                    enabled: !isNaN(root.dayTime(root.startDate)) && !isNaN(root.dayTime(root.endDate))
                    onClicked: root.confirm()
                }
            }
        }
    }
}
