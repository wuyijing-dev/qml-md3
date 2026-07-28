import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Dialogs
import Md3

Item {
    id: root

    Flickable {
        anchors.fill: parent
        contentWidth: width
        contentHeight: column.height
        clip: true
        interactive: !liquidCard.dragging
        boundsBehavior: Flickable.StopAtBounds
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
                text: qsTr("Drag the card. Switch the backdrop image below — glass samples whatever is behind it.")
                color: Md3Theme.colorScheme.colorOnSurfaceVariant
                font.pixelSize: Md3Theme.typography.bodySmall.size
                wrapMode: Text.Wrap
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 8
                Md3Button {
                    text: qsTr("Gradient")
                    variant: Md3Button.Outlined
                    onClicked: glassBackdrop.backgroundImage = ""
                }
                Md3Button {
                    text: qsTr("Photo A")
                    variant: Md3Button.Outlined
                    onClicked: glassBackdrop.backgroundImage = "https://images.unsplash.com/photo-1579546929518-9e396f3cc809?w=1200&q=80"
                }
                Md3Button {
                    text: qsTr("Photo B")
                    variant: Md3Button.Outlined
                    onClicked: glassBackdrop.backgroundImage = "https://images.unsplash.com/photo-1557683316-973635b79489?w=1200&q=80"
                }
                Md3Button {
                    text: qsTr("Photo C")
                    variant: Md3Button.Outlined
                    onClicked: glassBackdrop.backgroundImage = "https://images.unsplash.com/photo-1558591710-4b4a1ae0f04d?w=1200&q=80"
                }
                Md3Button {
                    text: qsTr("Browse…")
                    onClicked: backdropFileDialog.open()
                }
                Item { Layout.fillWidth: true }
            }

            Item {
                id: glassPlayground
                Layout.fillWidth: true
                Layout.preferredHeight: 340
                clip: true

                Item {
                    id: glassBackdrop
                    anchors.fill: parent
                    /// Empty = gradient demo; set a url/file path to use a photo.
                    property url backgroundImage: ""

                    layer.enabled: true
                    layer.smooth: true

                    Rectangle {
                        anchors.fill: parent
                        radius: Md3Theme.shape.large
                        visible: glassBackdrop.backgroundImage.toString().length === 0
                        gradient: Gradient {
                            orientation: Gradient.Horizontal
                            GradientStop { position: 0.0; color: "#3B82F6" }
                            GradientStop { position: 0.3; color: "#A855F7" }
                            GradientStop { position: 0.6; color: "#F43F5E" }
                            GradientStop { position: 1.0; color: "#F59E0B" }
                        }
                    }

                    Image {
                        anchors.fill: parent
                        visible: glassBackdrop.backgroundImage.toString().length > 0
                        source: glassBackdrop.backgroundImage
                        fillMode: Image.PreserveAspectCrop
                        asynchronous: true
                        cache: true
                    }

                    // Soft scrim so overlay labels stay readable on photos.
                    Rectangle {
                        anchors.fill: parent
                        visible: glassBackdrop.backgroundImage.toString().length > 0
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: Qt.rgba(0, 0, 0, 0.15) }
                            GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, 0.35) }
                        }
                    }

                    Repeater {
                        model: glassBackdrop.backgroundImage.toString().length === 0 ? [
                            { t: "Aa", x: 0.08, y: 0.18, s: 42 },
                            { t: "MD3", x: 0.42, y: 0.12, s: 36 },
                            { t: "液态", x: 0.70, y: 0.28, s: 34 },
                            { t: "Glass", x: 0.18, y: 0.58, s: 40 },
                            { t: "2026", x: 0.55, y: 0.62, s: 38 }
                        ] : []
                        delegate: Text {
                            required property var modelData
                            x: modelData.x * glassBackdrop.width
                            y: modelData.y * glassBackdrop.height
                            text: modelData.t
                            color: Qt.rgba(1, 1, 1, 0.92)
                            font.pixelSize: modelData.s
                            font.bold: true
                        }
                    }

                    Repeater {
                        model: glassBackdrop.backgroundImage.toString().length === 0 ? 6 : 0
                        delegate: Rectangle {
                            required property int index
                            width: 56 + (index % 3) * 24
                            height: width
                            radius: width / 2
                            x: 30 + (index * 110) % Math.max(40, glassBackdrop.width - 90)
                            y: 30 + (index * 61) % Math.max(40, glassBackdrop.height - 90)
                            color: Qt.rgba(1, 1, 1, 0.16 + (index % 3) * 0.06)
                            border.width: 2
                            border.color: Qt.rgba(1, 1, 1, 0.35)
                        }
                    }
                }

                Md3LiquidGlass {
                    id: liquidCard
                    sourceItem: glassBackdrop
                    x: 40
                    y: 70
                    width: 270
                    height: 158
                    radius: radiusSlider.value
                    blurAmount: blurSlider.value
                    tintOpacity: tintSlider.value
                    refraction: refractionSlider.value
                    chromaticAberration: chromaSlider.value
                    edgeStrength: edgeSlider.value
                    elevation: elevSlider.value

                    Column {
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width
                        spacing: 6
                        Text {
                            text: qsTr("Liquid Glass")
                            color: "#FFFFFF"
                            style: Text.Outline
                            styleColor: Qt.rgba(0, 0, 0, 0.25)
                            font.family: Md3Theme.typography.fontFamily
                            font.pixelSize: Md3Theme.typography.titleMedium.size
                            font.weight: Font.DemiBold
                        }
                        Text {
                            width: parent.width
                            wrapMode: Text.Wrap
                            text: qsTr("Drag me — watch the lens bend")
                            color: Qt.rgba(1, 1, 1, 0.88)
                            font.family: Md3Theme.typography.fontFamily
                            font.pixelSize: Md3Theme.typography.bodyMedium.size
                        }
                    }
                }
            }

            FileDialog {
                id: backdropFileDialog
                title: qsTr("Choose backdrop image")
                nameFilters: [ qsTr("Images (*.png *.jpg *.jpeg *.bmp *.webp)"), qsTr("All files (*)") ]
                onAccepted: glassBackdrop.backgroundImage = selectedFile
            }

            component GlassParamRow: ColumnLayout {
                property alias label: lab.text
                property alias from: slider.from
                property alias to: slider.to
                property alias value: slider.value
                property alias slider: slider
                Layout.fillWidth: true
                spacing: 0
                RowLayout {
                    Layout.fillWidth: true
                    Text {
                        id: lab
                        Layout.fillWidth: true
                        color: Md3Theme.colorScheme.colorOnSurfaceVariant
                        font.pixelSize: Md3Theme.typography.labelLarge.size
                    }
                    Text {
                        text: slider.value.toFixed(2)
                        color: Md3Theme.colorScheme.colorOnSurface
                        font.pixelSize: Md3Theme.typography.labelLarge.size
                    }
                }
                Md3Slider {
                    id: slider
                    Layout.fillWidth: true
                    from: 0
                    to: 1
                    value: 0.5
                }
            }

            GlassParamRow {
                id: refractionSlider
                label: qsTr("Refraction (lens bend)")
                from: 0; to: 2.2; value: 1.2
            }
            GlassParamRow {
                id: chromaSlider
                label: qsTr("Chromatic aberration")
                from: 0; to: 1; value: 0.5
            }
            GlassParamRow {
                id: blurSlider
                label: qsTr("Frost / blur")
                from: 0; to: 1; value: 0.45
            }
            GlassParamRow {
                id: tintSlider
                label: qsTr("Tint opacity")
                from: 0; to: 0.55; value: 0.08
            }
            GlassParamRow {
                id: edgeSlider
                label: qsTr("Edge / rim")
                from: 0; to: 1; value: 0.85
            }
            GlassParamRow {
                id: radiusSlider
                label: qsTr("Corner radius")
                from: 8; to: 48; value: 28
            }
            GlassParamRow {
                id: elevSlider
                label: qsTr("Elevation")
                from: 0; to: 5; value: 2
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
