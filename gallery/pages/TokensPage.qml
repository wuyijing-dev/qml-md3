import QtQuick
import Md3

Flickable {
    id: root
    contentWidth: width
    contentHeight: column.implicitHeight
    clip: true
    flickableDirection: Flickable.VerticalFlick

    property bool md3PageActive: true

    Md3VStack {
        id: column
        width: root.width
        spacing: 24

        Md3Text {
            text: "Design tokens"
            role: Md3Text.HeadlineMedium
        }

        Md3Text {
            text: "Color roles"
            role: Md3Text.TitleSmall
        }

        Md3FlowLayout {
            width: parent.width
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
                    Md3Text {
                        anchors.centerIn: parent
                        text: modelData.name
                        role: Md3Text.LabelSmall
                        tone: Md3Text.Custom
                        customColor: modelData.on
                    }
                }
            }
        }

        Md3Text {
            text: "Typography"
            role: Md3Text.TitleSmall
        }

        Md3VStack {
            spacing: 8
            Repeater {
                model: [
                    { role: Md3Text.DisplaySmall, label: "displaySmall" },
                    { role: Md3Text.HeadlineSmall, label: "headlineSmall" },
                    { role: Md3Text.TitleLarge, label: "titleLarge" },
                    { role: Md3Text.BodyLarge, label: "bodyLarge" },
                    { role: Md3Text.LabelLarge, label: "labelLarge" }
                ]
                delegate: Md3Text {
                    required property var modelData
                    text: modelData.label + " — The quick brown fox"
                    role: modelData.role
                }
            }
        }

        Md3Text {
            text: "Shape scale"
            role: Md3Text.TitleSmall
        }

        Md3HStack {
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
                    Md3Text {
                        anchors.centerIn: parent
                        text: modelData.name
                        role: Md3Text.LabelSmall
                        tone: Md3Text.Custom
                        customColor: Md3Theme.colorScheme.colorOnPrimaryContainer
                    }
                }
            }
        }
    }
}
