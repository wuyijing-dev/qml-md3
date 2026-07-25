import QtQuick
import QtQuick.Layouts
import Md3

Flickable {
    id: root
    contentWidth: width
    contentHeight: column.height
    clip: true
    flickableDirection: Flickable.VerticalFlick

    ColumnLayout {
        id: column
        width: root.width
        spacing: 24

        Text {
            text: "Design tokens"
            color: Md3Theme.colorScheme.colorOnSurface
            font.family: Md3Theme.typography.fontFamily
            font.pixelSize: Md3Theme.typography.headlineMedium.size
        }

        Text {
            text: "Color roles"
            color: Md3Theme.colorScheme.colorOnSurface
            font.pixelSize: Md3Theme.typography.titleMedium.size
            font.weight: Font.Medium
        }

        Flow {
            Layout.fillWidth: true
            spacing: 8

            Repeater {
                model: [
                    { name: "primary", c: Md3Theme.colorScheme.primary, on: Md3Theme.colorScheme.colorOnPrimary },
                    { name: "primaryContainer", c: Md3Theme.colorScheme.primaryContainer, on: Md3Theme.colorScheme.colorOnPrimaryContainer },
                    { name: "secondary", c: Md3Theme.colorScheme.secondary, on: Md3Theme.colorScheme.colorOnSecondary },
                    { name: "secondaryContainer", c: Md3Theme.colorScheme.secondaryContainer, on: Md3Theme.colorScheme.colorOnSecondaryContainer },
                    { name: "tertiary", c: Md3Theme.colorScheme.tertiary, on: Md3Theme.colorScheme.colorOnTertiary },
                    { name: "error", c: Md3Theme.colorScheme.error, on: Md3Theme.colorScheme.colorOnError },
                    { name: "surface", c: Md3Theme.colorScheme.surface, on: Md3Theme.colorScheme.colorOnSurface },
                    { name: "surfaceContainer", c: Md3Theme.colorScheme.surfaceContainer, on: Md3Theme.colorScheme.colorOnSurface },
                    { name: "outline", c: Md3Theme.colorScheme.outline, on: Md3Theme.colorScheme.surface }
                ]
                delegate: Rectangle {
                    required property var modelData
                    width: 140
                    height: 64
                    radius: Md3Theme.shape.small
                    color: modelData.c
                    border.width: 1
                    border.color: Md3Theme.colorScheme.outlineVariant
                    Text {
                        anchors.centerIn: parent
                        text: modelData.name
                        color: modelData.on
                        font.pixelSize: 11
                        font.family: Md3Theme.typography.fontFamily
                    }
                }
            }
        }

        Text {
            text: "Typography"
            color: Md3Theme.colorScheme.colorOnSurface
            font.pixelSize: Md3Theme.typography.titleMedium.size
            font.weight: Font.Medium
        }

        Column {
            spacing: 8
            Repeater {
                model: [
                    { role: "displaySmall", size: Md3Theme.typography.displaySmall.size },
                    { role: "headlineSmall", size: Md3Theme.typography.headlineSmall.size },
                    { role: "titleLarge", size: Md3Theme.typography.titleLarge.size },
                    { role: "bodyLarge", size: Md3Theme.typography.bodyLarge.size },
                    { role: "labelLarge", size: Md3Theme.typography.labelLarge.size }
                ]
                delegate: Text {
                    required property var modelData
                    text: modelData.role + " — The quick brown fox"
                    color: Md3Theme.colorScheme.colorOnSurface
                    font.family: Md3Theme.typography.fontFamily
                    font.pixelSize: modelData.size
                }
            }
        }

        Text {
            text: "Shape scale"
            color: Md3Theme.colorScheme.colorOnSurface
            font.pixelSize: Md3Theme.typography.titleMedium.size
            font.weight: Font.Medium
        }

        Row {
            spacing: 12
            Repeater {
                model: [
                    { name: "xs", r: Md3Theme.shape.extraSmall },
                    { name: "sm", r: Md3Theme.shape.small },
                    { name: "md", r: Md3Theme.shape.medium },
                    { name: "lg", r: Md3Theme.shape.large },
                    { name: "xl", r: Md3Theme.shape.extraLarge }
                ]
                delegate: Rectangle {
                    required property var modelData
                    width: 56
                    height: 56
                    radius: modelData.r
                    color: Md3Theme.colorScheme.primaryContainer
                    Text {
                        anchors.centerIn: parent
                        text: modelData.name
                        color: Md3Theme.colorScheme.colorOnPrimaryContainer
                        font.pixelSize: 12
                    }
                }
            }
        }
    }
}
