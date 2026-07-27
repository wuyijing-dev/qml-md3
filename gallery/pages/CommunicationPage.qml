import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import Md3

Item {
    id: page
    anchors.fill: parent

    Flickable {
        id: flick
        anchors.fill: parent
        contentWidth: width
        contentHeight: col.height
        clip: true

        ColumnLayout {
            id: col
            width: flick.width
            spacing: 16

            Text {
                text: "Communication"
                color: Md3Theme.colorScheme.colorOnSurface
                font.pixelSize: Md3Theme.typography.headlineMedium.size
                font.family: Md3Theme.typography.fontFamily
            }

            Text {
                text: qsTr("Badges")
                color: Md3Theme.colorScheme.colorOnSurfaceVariant
                font.pixelSize: Md3Theme.typography.labelMedium.size
            }
            Row {
                spacing: 20
                Md3Badged {
                    badgeText: "3"
                    Md3IconButton { icon: "home" }
                }
                Md3Badged {
                    badgeDot: true
                    Md3IconButton { icon: "favorite" }
                }
                Md3Badged {
                    badgeText: "128"
                    badgeMax: 99
                    badgeSizePreset: Md3Badge.Medium
                    Md3IconButton { icon: "notifications" }
                }
                Md3Badged {
                    badgeText: "9"
                    badgeSizePreset: Md3Badge.Medium
                    badgeColor: Md3Theme.colorScheme.tertiary
                    badgeLabelColor: Md3Theme.colorScheme.colorOnTertiary
                    Md3Button { text: qsTr("Inbox") }
                }
            }

            Text {
                text: "Linear"
                color: Md3Theme.colorScheme.colorOnSurfaceVariant
                font.pixelSize: Md3Theme.typography.labelMedium.size
            }
            Md3LinearProgressIndicator { Layout.fillWidth: true; value: 0.45 }
            Md3LinearProgressIndicator { Layout.fillWidth: true; indeterminate: true }

            Text {
                text: qsTr("Loading indicator")
                color: Md3Theme.colorScheme.colorOnSurfaceVariant
                font.pixelSize: Md3Theme.typography.labelMedium.size
            }
            RowLayout {
                spacing: 24
                Md3LoadingIndicator { sizePreset: Md3LoadingIndicator.Small }
                Md3LoadingIndicator { sizePreset: Md3LoadingIndicator.Medium; label: qsTr("Loading…") }
                Md3LoadingIndicator { sizePreset: Md3LoadingIndicator.Large }
                Md3LoadingIndicator {
                    indeterminate: false
                    value: 0.65
                    label: qsTr("65%")
                }
            }

            Text {
                text: qsTr("Morph loading (expressive)")
                color: Md3Theme.colorScheme.colorOnSurfaceVariant
                font.pixelSize: Md3Theme.typography.labelMedium.size
            }
            RowLayout {
                spacing: 28
                Md3MorphLoadingIndicator { sizePreset: Md3MorphLoadingIndicator.Small }
                Md3MorphLoadingIndicator { }
                Md3MorphLoadingIndicator { sizePreset: Md3MorphLoadingIndicator.Large }
                Md3MorphLoadingIndicator {
                    variant: Md3MorphLoadingIndicator.Contained
                    sizePreset: Md3MorphLoadingIndicator.Small
                }
                Md3MorphLoadingIndicator { variant: Md3MorphLoadingIndicator.Contained }
                Md3MorphLoadingIndicator {
                    variant: Md3MorphLoadingIndicator.Contained
                    sizePreset: Md3MorphLoadingIndicator.Large
                }
            }

            Text {
                text: "Linear wavy / soft / lively (Expressive)"
                color: Md3Theme.colorScheme.colorOnSurfaceVariant
                font.pixelSize: Md3Theme.typography.labelMedium.size
            }
            Md3LinearProgressIndicator {
                Layout.fillWidth: true
                style: Md3LinearProgressIndicator.Wavy
                value: 0.55
            }
            Md3LinearProgressIndicator {
                Layout.fillWidth: true
                style: Md3LinearProgressIndicator.Soft
                value: 0.4
            }
            Md3LinearProgressIndicator {
                Layout.fillWidth: true
                style: Md3LinearProgressIndicator.Lively
                indeterminate: true
            }
            Md3LinearProgressIndicator {
                Layout.fillWidth: true
                style: Md3LinearProgressIndicator.Wavy
                indeterminate: true
            }

            Text {
                text: "Circular"
                color: Md3Theme.colorScheme.colorOnSurfaceVariant
                font.pixelSize: Md3Theme.typography.labelMedium.size
            }
            RowLayout {
                spacing: 24
                Md3CircularProgressIndicator { }
                Md3CircularProgressIndicator { indeterminate: false; value: 0.7 }
            }

            Text {
                text: "Circular wavy / soft / lively"
                color: Md3Theme.colorScheme.colorOnSurfaceVariant
                font.pixelSize: Md3Theme.typography.labelMedium.size
            }
            RowLayout {
                spacing: 24
                Md3CircularProgressIndicator { style: Md3CircularProgressIndicator.Wavy }
                Md3CircularProgressIndicator { style: Md3CircularProgressIndicator.Soft; indeterminate: false; value: 0.55 }
                Md3CircularProgressIndicator { style: Md3CircularProgressIndicator.Lively }
                Md3CircularProgressIndicator {
                    style: Md3CircularProgressIndicator.Wavy
                    indeterminate: false
                    value: 0.65
                }
            }

            Md3Button {
                text: "Show snackbar"
                onClicked: {
                    const win = Window.window
                    if (win && typeof win.showSnackbar === "function")
                        win.showSnackbar(qsTr("Message sent"), { actionText: qsTr("Undo") })
                    else
                        snack.show(qsTr("Message sent"))
                }
            }
            Md3Button {
                text: qsTr("Queue 3 snackbars")
                variant: Md3Button.Outlined
                onClicked: {
                    const win = Window.window
                    if (!win || typeof win.showSnackbar !== "function")
                        return
                    win.showSnackbar(qsTr("First notice"))
                    win.showSnackbar(qsTr("Second notice"), { actionText: qsTr("View") })
                    win.showSnackbar(qsTr("Third notice — stacked / queued via Md3SnackbarHost"))
                }
            }
        }
    }

    // Fallback when not hosted in Md3ApplicationWindow
    Md3Snackbar {
        id: snack
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 16
        actionText: "Undo"
    }
}
