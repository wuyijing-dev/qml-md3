import QtQuick

Rectangle {
    id: root

    property int hour: 10
    property int minute: 0
    property bool isPm: false
    property bool use24Hour: false
    property bool dialMode: true

    signal accepted(int hour, int minute)
    signal cancelled()

    width: 328
    height: col.implicitHeight
    radius: Md3Theme.shape.extraLarge
    color: Md3Theme.colorScheme.surfaceContainerHigh

    readonly property int displayHour: use24Hour ? hour : ((hour % 12) === 0 ? 12 : hour % 12)

    Column {
        id: col
        width: parent.width
        padding: 24
        spacing: 20

        Text {
            text: "Select time"
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.labelMedium.size
            font.family: Md3Theme.typography.fontFamily
        }

        Row {
            spacing: 8
            Text {
                text: String(root.displayHour).padStart(2, "0") + ":" + String(root.minute).padStart(2, "0")
                color: Md3Theme.colorScheme.colorOnSurface
                font.pixelSize: Md3Theme.typography.displaySmall.size
                font.family: Md3Theme.typography.fontFamily
            }
            Column {
                visible: !root.use24Hour
                spacing: 4
                Md3Button {
                    text: "AM"
                    variant: root.isPm ? Md3Button.Outlined : Md3Button.FilledTonal
                    onClicked: root.isPm = false
                }
                Md3Button {
                    text: "PM"
                    variant: root.isPm ? Md3Button.FilledTonal : Md3Button.Outlined
                    onClicked: root.isPm = true
                }
            }
        }

        Item {
            width: 256
            height: 256
            anchors.horizontalCenter: parent.horizontalCenter
            visible: root.dialMode

            Rectangle {
                anchors.fill: parent
                radius: width / 2
                color: Md3Theme.colorScheme.surfaceContainerHighest

                // Hour marks 1-12
                Repeater {
                    model: 12
                    Text {
                        required property int index
                        property int h: index + 1
                        text: h
                        color: Md3Theme.colorScheme.colorOnSurface
                        font.pixelSize: 16
                        property real ang: (h % 12) * 30 - 90
                        property real rad: 100
                        x: parent.width / 2 + Math.cos(ang * Math.PI / 180) * rad - width / 2
                        y: parent.height / 2 + Math.sin(ang * Math.PI / 180) * rad - height / 2
                    }
                }

                Rectangle {
                    width: 4
                    height: 80
                    radius: 2
                    color: Md3Theme.colorScheme.primary
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.verticalCenter
                    transformOrigin: Item.Bottom
                    rotation: (root.displayHour % 12) * 30
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
                    onClicked: function (mouse) {
                        const dx = mouse.x - width / 2
                        const dy = mouse.y - height / 2
                        let deg = Math.atan2(dy, dx) * 180 / Math.PI + 90
                        if (deg < 0)
                            deg += 360
                        let h = Math.round(deg / 30) % 12
                        if (h === 0)
                            h = 12
                        if (root.use24Hour)
                            root.hour = h % 24
                        else
                            root.hour = root.isPm ? (h % 12) + 12 : (h % 12)
                    }
                }
            }
        }

        Row {
            anchors.right: parent.right
            spacing: 8
            Md3Button {
                text: "Cancel"
                variant: Md3Button.Text
                onClicked: root.cancelled()
            }
            Md3Button {
                text: "OK"
                variant: Md3Button.Text
                onClicked: root.accepted(root.hour, root.minute)
            }
        }
    }
}
