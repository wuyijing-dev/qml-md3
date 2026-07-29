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
                Md3IconButton { icon: "home"; badgeText: "3" }
                Md3IconButton { icon: "favorite"; badgeDot: true }
                Md3IconButton {
                    icon: "notifications"
                    badgeText: "128"
                    badgeMax: 99
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

            Text {
                text: qsTr("Info bar (persistent)")
                color: Md3Theme.colorScheme.colorOnSurfaceVariant
                font.pixelSize: Md3Theme.typography.labelMedium.size
            }
            Md3InfoBar {
                Layout.fillWidth: true
                severity: Md3InfoBar.Informational
                title: qsTr("Sync available")
                message: qsTr("A new device profile is ready to download.")
                actionText: qsTr("View")
                onActionClicked: Md3Notify.snackbar(qsTr("Opening sync…"))
            }
            Md3InfoBar {
                Layout.fillWidth: true
                severity: Md3InfoBar.Warning
                title: qsTr("Storage low")
                message: qsTr("Free up space to keep uploads reliable.")
                actionText: qsTr("Manage")
            }
            Md3InfoBar {
                Layout.fillWidth: true
                severity: Md3InfoBar.Critical
                message: qsTr("Connection lost — changes are queued offline.")
            }

            Text {
                text: qsTr("Toast (multi + position) vs Snackbar (bottom queue)")
                color: Md3Theme.colorScheme.colorOnSurfaceVariant
                font.pixelSize: Md3Theme.typography.labelMedium.size
            }
            RowLayout {
                spacing: 8
                Layout.fillWidth: true
                Md3Button {
                    text: qsTr("Toast")
                    onClicked: Md3Notify.toast(qsTr("Copied to clipboard"), { severity: Md3Toast.Success })
                }
                Md3Button {
                    text: qsTr("Toast warning")
                    variant: Md3Button.Outlined
                    onClicked: Md3Notify.toast(qsTr("Still syncing…"), { severity: Md3Toast.Warning })
                }
                Md3Button {
                    text: qsTr("Queue 3 toasts")
                    variant: Md3Button.Outlined
                    onClicked: {
                        Md3Notify.toast(qsTr("First toast"), { severity: Md3Toast.Success })
                        Md3Notify.toast(qsTr("Second toast"), { severity: Md3Toast.Default })
                        Md3Notify.toast(qsTr("Third toast"), { severity: Md3Toast.Warning })
                    }
                }
            }
            Md3FlowLayout {
                Layout.fillWidth: true
                spacing: 8
                rowSpacing: 8
                Md3Button {
                    text: qsTr("Top center")
                    variant: Md3Button.Text
                    onClicked: Md3Notify.toast(qsTr("Top center"), { position: Md3ToastHost.TopCenter })
                }
                Md3Button {
                    text: qsTr("Top right")
                    variant: Md3Button.Text
                    onClicked: Md3Notify.toast(qsTr("Top right"), { position: Md3ToastHost.TopRight, severity: Md3Toast.Success })
                }
                Md3Button {
                    text: qsTr("Top left")
                    variant: Md3Button.Text
                    onClicked: Md3Notify.toast(qsTr("Top left"), { position: Md3ToastHost.TopLeft })
                }
                Md3Button {
                    text: qsTr("Bottom right")
                    variant: Md3Button.Text
                    onClicked: Md3Notify.toast(qsTr("Bottom right"), { position: Md3ToastHost.BottomRight, severity: Md3Toast.Warning })
                }
                Md3Button {
                    text: qsTr("Bottom left")
                    variant: Md3Button.Text
                    onClicked: Md3Notify.toast(qsTr("Bottom left"), { position: Md3ToastHost.BottomLeft, severity: Md3Toast.Error })
                }
            }

            Md3Button {
                text: "Show snackbar"
                onClicked: Md3Notify.snackbar(qsTr("Message sent"), { actionText: qsTr("Undo") })
            }
            Md3Button {
                text: qsTr("Queue 3 snackbars")
                variant: Md3Button.Outlined
                onClicked: {
                    Md3Notify.snackbar(qsTr("First notice"))
                    Md3Notify.snackbar(qsTr("Second notice"), { actionText: qsTr("View") })
                    Md3Notify.snackbar(qsTr("Third notice — stacked / queued via Md3SnackbarHost"))
                }
            }
            Md3Button {
                text: qsTr("Priority snackbar")
                variant: Md3Button.Text
                onClicked: {
                    Md3Notify.snackbar(qsTr("Low priority (queued)"), { priority: 0 })
                    Md3Notify.snackbar(qsTr("High priority jumps ahead"), { priority: 10, actionText: qsTr("OK") })
                }
            }
        }
    }
}
