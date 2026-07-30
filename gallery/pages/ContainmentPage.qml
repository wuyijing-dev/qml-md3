import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Dialogs
import QtMultimedia
import Md3

Item {
    id: root

    Flickable {
        anchors.fill: parent
        contentWidth: width
        contentHeight: column.height
        clip: true
        interactive: glassPlayground.dragCount === 0 && fusionPlayground.dragCount === 0
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
            Md3Text {
                Layout.fillWidth: true
                text: qsTr("Md3 容器组件默认支持 `layoutMode`（Fit / Scroll）：内容可自适应高度，或在固定高度区域内滚动。`Md3AdaptiveContainer` 仍可用于独立列布局场景。")
                role: Md3Text.BodyMedium
                tone: Md3Text.OnSurfaceVariant
                wrapMode: Text.WordWrap
            }

            Md3PageSection {
                Layout.fillWidth: true
                title: qsTr("ScrollView")
                subtitle: qsTr("Themed Md3ScrollBar overlays on a Flickable.")

                Md3ScrollView {
                    width: parent.width
                    height: 160
                    Column {
                        width: parent.width
                        spacing: 8
                        Repeater {
                            model: 24
                            Text {
                                required property int index
                                text: qsTr("Scrollable row %1").arg(index + 1)
                                color: Md3Theme.colorScheme.colorOnSurface
                                font.pixelSize: Md3Theme.typography.bodyMedium.size
                            }
                        }
                    }
                }
            }

            Md3PageSection {
                Layout.fillWidth: true
                title: qsTr("布局组件（VStack / HStack / Flow / Grid）")
                subtitle: qsTr("对齐、padding、expand spacer、Card.title 等 API 减少样板代码。")

                Md3Card {
                    width: parent.width
                    variant: Md3Card.Outlined
                    Md3VStack {
                        width: parent.width
                        spacing: 12
                        Md3HStack {
                            spacing: 8
                            Md3Button { text: qsTr("确认") }
                            Md3Button { text: qsTr("取消"); variant: Md3Button.Outlined }
                            Md3Spacer { expand: true }
                            Md3Text {
                                text: qsTr("HStack + expand")
                                tone: Md3Text.OnSurfaceVariant
                            }
                        }
                        Md3FlowLayout {
                            spacing: 8
                            rowSpacing: 8
                            Repeater {
                                model: 6
                                delegate: Md3SuggestionChip {
                                    text: qsTr("Flow %1").arg(index + 1)
                                }
                            }
                        }
                        Md3GridLayout {
                            minCellWidth: 140
                            minCellHeight: 84
                            spacing: 8
                            Repeater {
                                model: 4
                                delegate: Md3Card {
                                    title: qsTr("Grid %1").arg(index + 1)
                                    variant: Md3Card.Filled
                                }
                            }
                        }
                    }
                }
            }
            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 240
                spacing: 12
                Md3Card {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    variant: Md3Card.Outlined
                    layoutMode: Md3ContainerBody.Fit
                    title: qsTr("Fit 模式")
                    subtitle: qsTr("容器高度跟随内容增长，适合卡片说明、设置面板和轻量表单。")
                    Md3AnimatedFlow {
                        width: parent.width
                        Repeater {
                            model: 6
                            delegate: Md3SuggestionChip {
                                text: qsTr("标签 %1").arg(index + 1)
                            }
                        }
                    }
                }
                Md3Card {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    variant: Md3Card.Outlined
                    layoutMode: Md3ContainerBody.Scroll
                    title: qsTr("Scroll 模式")
                    Column {
                        width: parent.width
                        spacing: 12
                        Repeater {
                            model: 10
                            delegate: Md3Text {
                                width: parent ? parent.width : 240
                                text: qsTr("第 %1 段内容：当容器高度固定时，内容超出区域会在容器内部滚动，而不是把外层页面撑大。").arg(index + 1)
                                tone: Md3Text.OnSurfaceVariant
                                wrapMode: Text.WordWrap
                            }
                        }
                    }
                }
            }
            Md3AnimatedFlow {
                Layout.fillWidth: true
                spacing: 12
                rowSpacing: 12
                Md3Card {
                    title: "Elevated"
                    variant: Md3Card.Elevated
                    width: 180
                    height: 100
                }
                Md3Card {
                    title: "Filled"
                    variant: Md3Card.Filled
                    width: 180
                    height: 100
                }
                Md3Card {
                    title: "Outlined"
                    variant: Md3Card.Outlined
                    width: 180
                    height: 100
                }
            }

            Column {
                Layout.fillWidth: true
                width: root.width
                Md3ListTile { title: "One line"; leadingIcon: "person"; trailingIcon: "chevron_right"; showDivider: true }
                Md3ListTile { title: "Two line"; subtitle: "Supporting"; leadingIcon: "settings"; showDivider: true }
                Md3ListTile { title: "Three line"; subtitle: "Subtitle"; supportingText: "Extra supporting text."; leadingIcon: "info" }
                Md3ListTile {
                    title: qsTr("Alex Chen")
                    subtitle: qsTr("Design lead")
                    leadingAvatar: "AC"
                    trailingIcon: "chevron_right"
                    showDivider: true
                }
                Md3ListTile {
                    title: qsTr("Dark theme")
                    leadingIcon: "dark_mode"
                    showDivider: true
                    trailing: Md3Switch { checked: Md3Theme.dark }
                }
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
        Md3Checkbox { text: qsTr("Don't show again") }
    }
    Md3BottomSheet {
        id: sheet
        anchors.fill: parent
        title: qsTr("Options")
        text: qsTr("Bottom sheet content")
        confirmText: qsTr("Done")
    }

    Md3SideSheet {
        id: sideSheet
        anchors.fill: parent
        title: qsTr("Side sheet")
        text: qsTr("Use side sheets for secondary detail without leaving the page.")
        edge: Md3SideSheet.End
        Md3Button {
            text: qsTr("Done")
            onClicked: sideSheet.dismiss()
        }
    }

    Md3DialogWindow {
        id: winDlg
        title: "Settings dialog"
        width: 520
        height: 380
        dialogText: "Separate top-level window with custom chrome, pin (always-on-top), and standard actions."
        windowIcon: Md3AppIcons.window
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
            Md3Switch {
                id: notifySwitch
                text: qsTr("Enable notifications")
                checked: true
            }
            Md3Slider {
                width: parent.width
                label: qsTr("Volume")
                showValue: true
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
