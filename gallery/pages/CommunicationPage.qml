import QtQuick
import Md3

Md3Page {
    id: page

    Flickable {
        id: flick
        anchors.fill: parent
        contentWidth: width
        contentHeight: col.implicitHeight
        clip: true

        Md3VStack {
            id: col
            width: flick.width
            spacing: 16

            Md3Text {
                text: "Communication"
                role: Md3Text.HeadlineMedium
            }

            Md3Text {
                text: qsTr("Badges")
                role: Md3Text.LabelLarge
                tone: Md3Text.OnSurfaceVariant
            }
            Md3HStack {
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

            Md3Text {
                text: "Linear"
                role: Md3Text.LabelLarge
                tone: Md3Text.OnSurfaceVariant
            }
            Md3DeferredSection {
                preferredHeight: 220
                delayMs: 24
                asynchronous: true
                sourceComponent: Component {
                    Md3VStack {
                        width: parent ? parent.width : 400
                        spacing: 16
                        Md3LinearProgressIndicator { width: parent.width; value: 0.45 }
                        Md3LinearProgressIndicator { width: parent.width; indeterminate: true }
                        Md3Text {
                            text: qsTr("Loading indicator")
                            role: Md3Text.LabelLarge
                            tone: Md3Text.OnSurfaceVariant
                        }
                        Md3HStack {
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
                        Md3Text {
                            text: qsTr("Morph loading (expressive)")
                            role: Md3Text.LabelLarge
                            tone: Md3Text.OnSurfaceVariant
                        }
                        Md3HStack {
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
                    }
                }
            }

            Md3Text {
                text: "Linear wavy / soft / lively (Expressive)"
                role: Md3Text.LabelLarge
                tone: Md3Text.OnSurfaceVariant
            }
            Md3LinearProgressIndicator {
                width: parent.width
                style: Md3LinearProgressIndicator.Wavy
                value: 0.55
            }
            Md3LinearProgressIndicator {
                width: parent.width
                style: Md3LinearProgressIndicator.Soft
                value: 0.4
            }
            Md3LinearProgressIndicator {
                width: parent.width
                style: Md3LinearProgressIndicator.Lively
                indeterminate: true
            }
            Md3LinearProgressIndicator {
                width: parent.width
                style: Md3LinearProgressIndicator.Wavy
                indeterminate: true
            }

            Md3Text {
                text: "Circular"
                role: Md3Text.LabelLarge
                tone: Md3Text.OnSurfaceVariant
            }
            Md3HStack {
                spacing: 24
                Md3CircularProgressIndicator { }
                Md3CircularProgressIndicator { indeterminate: false; value: 0.7 }
            }

            Md3Text {
                text: "Circular wavy / soft / lively"
                role: Md3Text.LabelLarge
                tone: Md3Text.OnSurfaceVariant
            }
            Md3HStack {
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

            Md3Text {
                text: qsTr("Info bar (persistent)")
                role: Md3Text.LabelLarge
                tone: Md3Text.OnSurfaceVariant
            }
            Md3InfoBar {
                width: parent.width
                severity: Md3InfoBar.Informational
                title: qsTr("Sync available")
                message: qsTr("A new device profile is ready to download.")
                actionText: qsTr("View")
                onActionClicked: Md3Notify.snackbar(qsTr("Opening sync…"))
            }
            Md3InfoBar {
                width: parent.width
                severity: Md3InfoBar.Warning
                title: qsTr("Storage low")
                message: qsTr("Free up space to keep uploads reliable.")
                actionText: qsTr("Manage")
            }
            Md3InfoBar {
                width: parent.width
                severity: Md3InfoBar.Critical
                message: qsTr("Connection lost — changes are queued offline.")
            }

            Md3Text {
                text: qsTr("Toast (multi + position) vs Snackbar (bottom queue)")
                role: Md3Text.LabelLarge
                tone: Md3Text.OnSurfaceVariant
            }
            Md3HStack {
                spacing: 8
                width: parent.width
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
                width: parent.width
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
