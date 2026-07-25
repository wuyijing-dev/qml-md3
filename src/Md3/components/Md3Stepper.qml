import QtQuick

Item {
    id: root

    property var model: [] // [{ title, subtitle }]
    property int currentStep: 0
    property bool vertical: false

    width: parent ? parent.width : 400
    height: vertical ? model.length * 72 : 72

    Loader {
        anchors.fill: parent
        sourceComponent: root.vertical ? verticalComp : horizontalComp
    }

    Component {
        id: horizontalComp
        Row {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 0
            Repeater {
                model: root.model
                Row {
                    required property int index
                    required property var modelData
                    spacing: 8
                    Rectangle {
                        width: 24
                        height: 24
                        radius: 12
                        color: index <= root.currentStep ? Md3Theme.colorScheme.primary
                                                         : Md3Theme.colorScheme.surfaceContainerHighest
                        Text {
                            anchors.centerIn: parent
                            text: index + 1
                            color: index <= root.currentStep ? Md3Theme.colorScheme.colorOnPrimary
                                                             : Md3Theme.colorScheme.colorOnSurfaceVariant
                            font.pixelSize: 12
                        }
                    }
                    Text {
                        text: modelData.title !== undefined ? modelData.title : ""
                        color: Md3Theme.colorScheme.colorOnSurface
                        font.pixelSize: Md3Theme.typography.bodyMedium.size
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Rectangle {
                        visible: index < root.model.length - 1
                        width: 24
                        height: 1
                        anchors.verticalCenter: parent.verticalCenter
                        color: Md3Theme.colorScheme.outlineVariant
                    }
                }
            }
        }
    }

    Component {
        id: verticalComp
        Column {
            spacing: 0
            Repeater {
                model: root.model
                Column {
                    required property int index
                    required property var modelData
                    width: root.width
                    Row {
                        spacing: 12
                        Rectangle {
                            width: 24
                            height: 24
                            radius: 12
                            color: index <= root.currentStep ? Md3Theme.colorScheme.primary
                                                             : Md3Theme.colorScheme.surfaceContainerHighest
                            Text {
                                anchors.centerIn: parent
                                text: index + 1
                                color: index <= root.currentStep ? Md3Theme.colorScheme.colorOnPrimary
                                                                 : Md3Theme.colorScheme.colorOnSurfaceVariant
                                font.pixelSize: 12
                            }
                        }
                        Column {
                            Text {
                                text: modelData.title !== undefined ? modelData.title : ""
                                color: Md3Theme.colorScheme.colorOnSurface
                                font.pixelSize: Md3Theme.typography.bodyLarge.size
                            }
                            Text {
                                text: modelData.subtitle !== undefined ? modelData.subtitle : ""
                                color: Md3Theme.colorScheme.colorOnSurfaceVariant
                                font.pixelSize: Md3Theme.typography.bodySmall.size
                            }
                        }
                    }
                    Rectangle {
                        visible: index < root.model.length - 1
                        width: 1
                        height: 24
                        x: 11
                        color: Md3Theme.colorScheme.outlineVariant
                    }
                }
            }
        }
    }
}
