import QtQuick

Rectangle {
    id: root

    property date selectedDate: new Date()
    property date viewDate: selectedDate
    property bool modal: false

    signal accepted(date date)
    signal cancelled()

    width: 360
    height: col.implicitHeight
    radius: Md3Theme.shape.extraLarge
    color: Md3Theme.colorScheme.surfaceContainerHigh

    function daysInMonth(year, month) {
        return new Date(year, month + 1, 0).getDate()
    }

    function sameDay(a, b) {
        return a.getFullYear() === b.getFullYear()
                && a.getMonth() === b.getMonth()
                && a.getDate() === b.getDate()
    }

    Column {
        id: col
        width: parent.width
        padding: 12
        spacing: 8

        Text {
            text: Qt.formatDate(root.selectedDate, "ddd, MMM d")
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
                    visible: true

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
                            return root.sameDay(d, root.selectedDate) ? Md3Theme.colorScheme.primary : "transparent"
                        }

                        Text {
                            anchors.centerIn: parent
                            text: modelData > 0 ? modelData : ""
                            color: {
                                if (modelData <= 0)
                                    return "transparent"
                                const d = new Date(root.viewDate.getFullYear(), root.viewDate.getMonth(), modelData)
                                return root.sameDay(d, root.selectedDate)
                                       ? Md3Theme.colorScheme.colorOnPrimary
                                       : Md3Theme.colorScheme.colorOnSurface
                            }
                            font.pixelSize: Md3Theme.typography.bodyLarge.size
                        }

                        MouseArea {
                            anchors.fill: parent
                            enabled: modelData > 0
                            onClicked: {
                                root.selectedDate = new Date(root.viewDate.getFullYear(), root.viewDate.getMonth(), modelData)
                            }
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
                text: "Cancel"
                variant: Md3Button.Text
                onClicked: root.cancelled()
            }
            Md3Button {
                text: "OK"
                variant: Md3Button.Text
                onClicked: root.accepted(root.selectedDate)
            }
        }
    }
}
