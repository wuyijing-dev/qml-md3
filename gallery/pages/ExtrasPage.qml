import QtQuick
import QtQuick.Layouts
import Md3

Flickable {
    contentWidth: width
    contentHeight: column.height
    clip: true
    ColumnLayout {
        id: column
        width: parent.width
        spacing: 16
        Text {
            text: "Enterprise extras"
            color: Md3Theme.colorScheme.colorOnSurface
            font.pixelSize: Md3Theme.typography.headlineMedium.size
        }
        Md3Banner {
            Layout.fillWidth: true
            text: "Your password expires in 3 days."
            primaryAction: "Update"
            secondaryAction: "Dismiss"
        }
        Md3Tooltip {
            text: "Tooltip label"
            Md3Button { text: "Hover me" }
        }
        Md3ExpansionTile {
            Layout.fillWidth: true
            title: "Advanced"
            subtitle: "More options"
            Text {
                text: "Expanded content"
                color: Md3Theme.colorScheme.colorOnSurfaceVariant
                leftPadding: 16
            }
        }
        Md3Stepper {
            Layout.fillWidth: true
            currentStep: 1
            model: [
                { title: "Details" },
                { title: "Review" },
                { title: "Confirm" }
            ]
        }
        Md3DataTable {
            Layout.fillWidth: true
            columns: [
                { title: "Name", role: "name", width: 140 },
                { title: "Role", role: "role", width: 120 },
                { title: "Status", role: "status", width: 100 }
            ]
            rows: [
                { name: "Ada", role: "Admin", status: "Active" },
                { name: "Alan", role: "Editor", status: "Away" },
                { name: "Grace", role: "Viewer", status: "Active" }
            ]
        }
        Md3Carousel {
            Layout.fillWidth: true
            model: [
                { title: "One", color: Md3Theme.colorScheme.primaryContainer },
                { title: "Two", color: Md3Theme.colorScheme.secondaryContainer },
                { title: "Three", color: Md3Theme.colorScheme.tertiaryContainer }
            ]
        }
    }
}
