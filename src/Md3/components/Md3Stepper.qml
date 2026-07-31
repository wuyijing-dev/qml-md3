import QtQuick
import QtQuick.Layouts
import Md3

/// Step indicator + optional step body pages and Next/Back actions.
Item {
    id: root

    property var model: [] // [{ title, subtitle }]
    property int currentStep: 0
    property bool vertical: false
    /// When true, show Back / Next (or Finish on last step).
    property bool showActions: true
    property string backText: qsTr("Back")
    property string nextText: qsTr("Next")
    property string finishText: qsTr("Finish")
    /// Step body pages (synced with currentStep). Prefer over external StackLayout.
    default property alias pages: stepStack.data

    signal stepChanged(int index)
    signal finished()
    signal backClicked()
    signal nextClicked()

    readonly property bool hasPages: stepStack.children.length > 0
    readonly property bool isFirst: currentStep <= 0
    readonly property bool isLast: currentStep >= Math.max(0, model.length - 1)

    Accessible.role: Accessible.Grouping
    Accessible.name: qsTr("Stepper")

    function goNext() {
        if (isLast) {
            finished()
            nextClicked()
            return
        }
        currentStep = Math.min(model.length - 1, currentStep + 1)
        nextClicked()
        stepChanged(currentStep)
    }

    function goBack() {
        if (isFirst)
            return
        currentStep = Math.max(0, currentStep - 1)
        backClicked()
        stepChanged(currentStep)
    }

    implicitWidth: 400
    implicitHeight: headerLoader.height
                     + (hasPages ? Math.max(120, stepStack.implicitHeight) : 0)
                     + (showActions && hasPages ? 56 : 0)
    width: parent ? parent.width : implicitWidth
    height: hasPages ? (parent ? parent.height : implicitHeight) : headerLoader.height

    ColumnLayout {
        anchors.fill: parent
        spacing: 16

        Loader {
            id: headerLoader
            Layout.fillWidth: true
            Layout.preferredHeight: root.vertical ? Math.max(72, root.model.length * 72) : 72
            sourceComponent: root.vertical ? verticalComp : horizontalComp
        }

        StackLayout {
            id: stepStack
            visible: root.hasPages
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: root.currentStep
        }

        RowLayout {
            visible: root.showActions && root.hasPages
            Layout.fillWidth: true
            spacing: 8

            Md3Button {
                text: root.backText
                variant: Md3Button.Text
                enabled: !root.isFirst
                onClicked: root.goBack()
            }
            Item { Layout.fillWidth: true }
            Md3Button {
                text: root.isLast ? root.finishText : root.nextText
                variant: Md3Button.Filled
                onClicked: root.goNext()
            }
        }
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
            width: parent ? parent.width : root.width
            Repeater {
                model: root.model
                Column {
                    required property int index
                    required property var modelData
                    width: parent.width
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
