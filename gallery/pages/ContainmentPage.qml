import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import Md3

Item {
    id: root

    Flickable {
        anchors.fill: parent
        contentWidth: width
        contentHeight: column.height
        clip: true
        interactive: !liquidCard.dragging
        ColumnLayout {
            id: column
            width: root.width
            spacing: 16
            Text {
                text: "Containment"
                color: Md3Theme.colorScheme.colorOnSurface
                font.pixelSize: Md3Theme.typography.headlineMedium.size
            }
            RowLayout {
                spacing: 12
                Md3Card {
                    variant: Md3Card.Elevated
                    Layout.preferredWidth: 180
                    Layout.preferredHeight: 100
                    Text { text: "Elevated"; color: Md3Theme.colorScheme.colorOnSurface }
                }
                Md3Card {
                    variant: Md3Card.Filled
                    Layout.preferredWidth: 180
                    Layout.preferredHeight: 100
                    Text { text: "Filled"; color: Md3Theme.colorScheme.colorOnSurface }
                }
                Md3Card {
                    variant: Md3Card.Outlined
                    Layout.preferredWidth: 180
                    Layout.preferredHeight: 100
                    Text { text: "Outlined"; color: Md3Theme.colorScheme.colorOnSurface }
                }
            }

            Text {
                text: qsTr("Liquid Glass")
                color: Md3Theme.colorScheme.colorOnSurfaceVariant
                font.pixelSize: Md3Theme.typography.labelLarge.size
            }
            Text {
                Layout.fillWidth: true
                text: qsTr("Drag the glass card — backdrop blur, edge highlight, and specular follow the pointer.")
                color: Md3Theme.colorScheme.colorOnSurfaceVariant
                font.pixelSize: Md3Theme.typography.bodySmall.size
                wrapMode: Text.Wrap
            }
            Item {
                id: glassPlayground
                Layout.fillWidth: true
                Layout.preferredHeight: 320
                clip: true

                Rectangle {
                    id: glassBackdrop
                    anchors.fill: parent
                    radius: Md3Theme.shape.large
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0.0; color: "#5B8DEF" }
                        GradientStop { position: 0.35; color: "#C084FC" }
                        GradientStop { position: 0.65; color: "#FB7185" }
                        GradientStop { position: 1.0; color: "#FBBF24" }
                    }

                    // Decorative shapes so refraction/blur reads clearly while dragging.
                    Repeater {
                        model: 8
                        delegate: Rectangle {
                            required property int index
                            width: 70 + (index % 3) * 28
                            height: width
                            radius: width / 2
                            x: 24 + (index * 97) % Math.max(40, glassBackdrop.width - 100)
                            y: 20 + (index * 53) % Math.max(40, glassBackdrop.height - 100)
                            color: Qt.rgba(1, 1, 1, 0.18 + (index % 4) * 0.05)
                        }
                    }

                    Text {
                        anchors.left: parent.left
                        anchors.bottom: parent.bottom
                        anchors.margins: 16
                        text: qsTr("Backdrop")
                        color: Qt.rgba(1, 1, 1, 0.7)
                        font.pixelSize: Md3Theme.typography.labelLarge.size
                    }
                }

                Md3LiquidGlass {
                    id: liquidCard
                    sourceItem: glassBackdrop
                    x: 36
                    y: 56
                    width: 260
                    height: 150

                    Column {
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width
                        spacing: 6
                        Text {
                            text: qsTr("Liquid Glass")
                            color: Md3Theme.colorScheme.colorOnSurface
                            font.family: Md3Theme.typography.fontFamily
                            font.pixelSize: Md3Theme.typography.titleMedium.size
                            font.weight: Font.Medium
                        }
                        Text {
                            width: parent.width
                            wrapMode: Text.Wrap
                            text: qsTr("Drag me across the colors")
                            color: Md3Theme.colorScheme.colorOnSurfaceVariant
                            font.family: Md3Theme.typography.fontFamily
                            font.pixelSize: Md3Theme.typography.bodyMedium.size
                        }
                    }
                }
            }
            Column {
                Layout.fillWidth: true
                width: root.width
                Md3ListTile { width: parent.width; title: "One line"; leadingIcon: "person"; trailingIcon: "chevron_right"; showDivider: true }
                Md3ListTile { width: parent.width; title: "Two line"; subtitle: "Supporting"; leadingIcon: "settings"; showDivider: true }
                Md3ListTile { width: parent.width; title: "Three line"; subtitle: "Subtitle"; supportingText: "Extra supporting text."; leadingIcon: "info" }
            }
            Md3Button { text: "Open dialog"; onClicked: dlg.open = true }
            Md3Button { text: "Open bottom sheet"; variant: Md3Button.Outlined; onClicked: sheet.open = true }
            Md3Button { text: qsTr("Open side sheet"); variant: Md3Button.FilledTonal; onClicked: sideSheet.open = true }
            Md3Button {
                text: "Open dialog window"
                variant: Md3Button.FilledTonal
                onClicked: winDlg.openDialog(Window.window)
            }
            Md3Button {
                text: "Open modeless window"
                variant: Md3Button.Outlined
                onClicked: modelessDlg.openDialog(Window.window)
            }
            Text {
                Layout.fillWidth: true
                text: "Dialog window = separate OS window (like QWidget::QDialog). Pin button keeps it always-on-top."
                color: Md3Theme.colorScheme.colorOnSurfaceVariant
                font.pixelSize: Md3Theme.typography.bodySmall.size
                wrapMode: Text.Wrap
            }
        }
    }

    Md3Dialog {
        id: dlg
        anchors.fill: parent
        title: "Dialog"
        text: "This is a Material 3 dialog."
    }
    Md3BottomSheet {
        id: sheet
        anchors.fill: parent
        Text {
            text: "Bottom sheet content"
            color: Md3Theme.colorScheme.colorOnSurface
            padding: 8
        }
    }

    Md3SideSheet {
        id: sideSheet
        anchors.fill: parent
        title: qsTr("Side sheet")
        edge: Md3SideSheet.End
        Column {
            anchors.fill: parent
            anchors.margins: 24
            spacing: 12
            Text {
                width: parent.width
                wrapMode: Text.Wrap
                text: qsTr("Use side sheets for secondary detail without leaving the page.")
                color: Md3Theme.colorScheme.colorOnSurfaceVariant
                font.family: Md3Theme.typography.fontFamily
                font.pixelSize: Md3Theme.typography.bodyMedium.size
            }
            Md3Button {
                text: qsTr("Done")
                onClicked: sideSheet.dismiss()
            }
        }
    }

    Md3DialogWindow {
        id: winDlg
        title: "Settings dialog"
        width: 520
        height: 380
        dialogText: "Separate top-level window with custom chrome, pin (always-on-top), and standard actions."
        windowIcon: "qrc:/md3/icons/app-icon.png"
        onConfirmed: console.log("dialog window accepted")
        onDismissed: console.log("dialog window dismissed")

        Column {
            anchors.fill: parent
            spacing: 12
            Md3TextField {
                width: parent.width
                label: "Display name"
                text: "QML MD3"
            }
            Row {
                spacing: 12
                Md3Switch {
                    id: notifySwitch
                    checked: true
                    accessibleName: "Enable notifications"
                }
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Enable notifications"
                    color: Md3Theme.colorScheme.colorOnSurface
                    font.pixelSize: Md3Theme.typography.bodyMedium.size
                }
            }
            Md3Slider {
                width: parent.width
                from: 0
                to: 100
                value: 42
            }
        }
    }

    Md3DialogWindow {
        id: modelessDlg
        title: "Inspector"
        width: 420
        height: 300
        dialogModality: Qt.NonModal
        showStandardButtons: false
        showMinimizeButton: true
        showMaximizeButton: true
        showPinButton: true
        dialogText: "Modeless secondary window — can stay open beside the main app."

        Text {
            anchors.fill: parent
            text: "Drag, resize, pin, or maximize like a normal tool window."
            color: Md3Theme.colorScheme.colorOnSurface
            wrapMode: Text.Wrap
            font.pixelSize: Md3Theme.typography.bodyMedium.size
        }
    }
}
