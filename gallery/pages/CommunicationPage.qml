import QtQuick
import QtQuick.Layouts
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
            Row {
                spacing: 16
                Item {
                    width: 48; height: 48
                    Md3IconButton { icon: "home" }
                    Md3Badge { anchors.right: parent.right; anchors.top: parent.top; text: "3" }
                }
                Item {
                    width: 48; height: 48
                    Md3IconButton { icon: "favorite" }
                    Md3Badge { anchors.right: parent.right; anchors.top: parent.top; dot: true }
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
                onClicked: snack.show("Message sent")
            }
        }
    }

    // Viewport overlay (not Flickable contentItem) so snackbar sits at screen bottom
    Md3Snackbar {
        id: snack
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 16
        actionText: "Undo"
    }
}
