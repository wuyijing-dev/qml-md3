import QtQuick

/// Dual-bound date range calendar (start → end). Same chrome as Md3DatePicker.
Rectangle {
    id: root

    property date startDate: new Date()
    property date endDate: new Date()
    property date viewDate: startDate
    /// Internal: true while choosing the start bound.
    property bool selectingStart: true

    signal accepted(date start, date end)
    signal cancelled()
    signal rangeChanged(date start, date end)

    width: 360
    height: col.implicitHeight
    radius: Md3Theme.shape.extraLarge
    color: Md3Theme.colorScheme.surfaceContainerHigh

    function daysInMonth(year, month) {
        return new Date(year, month + 1, 0).getDate()
    }

    function sameDay(a, b) {
        if (!a || !b || isNaN(a.getTime()) || isNaN(b.getTime()))
            return false
        return a.getFullYear() === b.getFullYear()
                && a.getMonth() === b.getMonth()
                && a.getDate() === b.getDate()
    }

    function dayTime(d) {
        if (!d || isNaN(d.getTime()))
            return NaN
        return new Date(d.getFullYear(), d.getMonth(), d.getDate()).getTime()
    }

    function inRange(d) {
        const t = dayTime(d)
        const a = dayTime(startDate)
        const b = dayTime(endDate)
        if (isNaN(t) || isNaN(a) || isNaN(b))
            return false
        const lo = Math.min(a, b)
        const hi = Math.max(a, b)
        return t >= lo && t <= hi
    }

    function isEndpoint(d) {
        return sameDay(d, startDate) || sameDay(d, endDate)
    }

    function pickDay(day) {
        const d = new Date(viewDate.getFullYear(), viewDate.getMonth(), day)
        if (selectingStart || isNaN(dayTime(startDate))) {
            startDate = d
            endDate = d
            selectingStart = false
        } else {
            if (dayTime(d) < dayTime(startDate)) {
                endDate = startDate
                startDate = d
            } else {
                endDate = d
            }
            selectingStart = true
        }
        rangeChanged(startDate, endDate)
    }

    Column {
        id: col
        width: parent.width
        padding: 12
        spacing: 8

        Text {
            text: {
                const a = root.startDate && !isNaN(root.startDate.getTime())
                        ? Qt.formatDate(root.startDate, "MMM d") : "—"
                const b = root.endDate && !isNaN(root.endDate.getTime())
                        ? Qt.formatDate(root.endDate, "MMM d") : "—"
                return a + " – " + b
            }
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.labelMedium.size
            font.family: Md3Theme.typography.fontFamily
            leftPadding: 12
        }
        Text {
            text: Qt.formatDate(root.viewDate, "MMMM yyyy")
            color: Md3Theme.colorScheme.colorOnSurface
            font.pixelSize: Md3Theme.typography.headlineLarge.size
            font.family: Md3Theme.typography.fontFamily
            leftPadding: 12
        }
        Text {
            leftPadding: 12
            text: root.selectingStart ? qsTr("Select start date") : qsTr("Select end date")
            color: Md3Theme.colorScheme.primary
            font.pixelSize: Md3Theme.typography.labelLarge.size
            font.family: Md3Theme.typography.fontFamily
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 8
            Md3IconButton {
                icon: "arrow_back"
                onClicked: root.viewDate = new Date(root.viewDate.getFullYear(), root.viewDate.getMonth() - 1, 1)
            }
            Md3IconButton {
                icon: "arrow_forward"
                onClicked: root.viewDate = new Date(root.viewDate.getFullYear(), root.viewDate.getMonth() + 1, 1)
            }
        }

        Grid {
            id: grid
            columns: 7
            rowSpacing: 0
            columnSpacing: 0
            width: parent.width - 24
            anchors.horizontalCenter: parent.horizontalCenter

            Repeater {
                model: ["S", "M", "T", "W", "T", "F", "S"]
                Text {
                    required property string modelData
                    width: grid.width / 7
                    height: 40
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: modelData
                    color: Md3Theme.colorScheme.colorOnSurface
                    font.pixelSize: Md3Theme.typography.bodySmall.size
                }
            }

            Repeater {
                model: {
                    const first = new Date(root.viewDate.getFullYear(), root.viewDate.getMonth(), 1)
                    const startPad = first.getDay()
                    const dim = root.daysInMonth(root.viewDate.getFullYear(), root.viewDate.getMonth())
                    const arr = []
                    for (let i = 0; i < startPad; ++i)
                        arr.push(0)
                    for (let d = 1; d <= dim; ++d)
                        arr.push(d)
                    return arr
                }
                delegate: Item {
                    required property int modelData
                    width: grid.width / 7
                    height: 40

                    Rectangle {
                        anchors.verticalCenter: parent.verticalCenter
                        height: 40
                        width: parent.width
                        visible: modelData > 0 && root.inRange(new Date(root.viewDate.getFullYear(), root.viewDate.getMonth(), modelData))
                                 && !root.isEndpoint(new Date(root.viewDate.getFullYear(), root.viewDate.getMonth(), modelData))
                        color: Md3Theme.colorScheme.secondaryContainer
                    }

                    Rectangle {
                        anchors.centerIn: parent
                        width: 40
                        height: 40
                        radius: 20
                        visible: modelData > 0
                        color: {
                            if (modelData <= 0)
                                return "transparent"
                            const d = new Date(root.viewDate.getFullYear(), root.viewDate.getMonth(), modelData)
                            return root.isEndpoint(d) ? Md3Theme.colorScheme.primary : "transparent"
                        }

                        Text {
                            anchors.centerIn: parent
                            text: modelData > 0 ? modelData : ""
                            color: {
                                if (modelData <= 0)
                                    return "transparent"
                                const d = new Date(root.viewDate.getFullYear(), root.viewDate.getMonth(), modelData)
                                if (root.isEndpoint(d))
                                    return Md3Theme.colorScheme.colorOnPrimary
                                if (root.inRange(d))
                                    return Md3Theme.colorScheme.colorOnSecondaryContainer
                                return Md3Theme.colorScheme.colorOnSurface
                            }
                            font.pixelSize: Md3Theme.typography.bodyLarge.size
                        }

                        MouseArea {
                            anchors.fill: parent
                            enabled: modelData > 0
                            onClicked: root.pickDay(modelData)
                        }
                    }
                }
            }
        }

        Row {
            anchors.right: parent.right
            anchors.rightMargin: 12
            spacing: 8
            Md3Button {
                text: qsTr("Cancel")
                variant: Md3Button.Text
                onClicked: root.cancelled()
            }
            Md3Button {
                text: qsTr("OK")
                variant: Md3Button.Text
                enabled: !isNaN(root.dayTime(root.startDate)) && !isNaN(root.dayTime(root.endDate))
                onClicked: root.accepted(root.startDate, root.endDate)
            }
        }
    }
}
