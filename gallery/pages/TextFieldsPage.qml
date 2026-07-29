import QtQuick
import QtQuick.Layouts
import Md3

Flickable {
    id: root
    contentWidth: width
    contentHeight: column.height
    clip: true

    ColumnLayout {
        id: column
        width: root.width
        spacing: 20

        Text {
            text: "Text fields"
            color: Md3Theme.colorScheme.colorOnSurface
            font.pixelSize: Md3Theme.typography.headlineMedium.size
            font.family: Md3Theme.typography.fontFamily
        }

        Md3TextField {
            Layout.fillWidth: true
            Layout.maximumWidth: 360
            variant: Md3TextField.Filled
            label: "Filled"
            supportingText: "Supporting text"
        }

        Md3TextField {
            Layout.fillWidth: true
            Layout.maximumWidth: 360
            variant: Md3TextField.Outlined
            label: "Outlined"
            leadingIcon: "search"
            trailingIcon: "close"
            text: "Clear me"
        }

        Text {
            text: qsTr("Select")
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.labelLarge.size
        }
        Md3Select {
            Layout.fillWidth: true
            Layout.maximumWidth: 360
            label: qsTr("Role")
            placeholderText: qsTr("Choose a role")
            leadingIcon: "badge"
            model: [
                { text: qsTr("Admin"), icon: "admin_panel_settings" },
                { text: qsTr("Editor"), icon: "edit" },
                { text: qsTr("Viewer"), icon: "visibility" }
            ]
            supportingText: qsTr("Field-style ComboBox with label / helper")
        }
        Md3Select {
            Layout.fillWidth: true
            Layout.maximumWidth: 360
            variant: Md3Select.Filled
            label: qsTr("Priority")
            error: true
            errorText: qsTr("Required")
            model: [qsTr("Low"), qsTr("Medium"), qsTr("High")]
        }

        Md3Select {
            Layout.fillWidth: true
            Layout.maximumWidth: 360
            label: qsTr("Tags (multi + search)")
            placeholderText: qsTr("Pick tags")
            searchable: true
            multiSelect: true
            leadingIcon: "sell"
            model: [
                { text: qsTr("Design"), icon: "palette" },
                { text: qsTr("Engineering"), icon: "code" },
                { text: qsTr("Product"), icon: "inventory_2" },
                { text: qsTr("Marketing"), icon: "campaign" },
                { text: qsTr("Support"), icon: "support_agent" },
                { text: qsTr("Research"), icon: "science" }
            ]
            supportingText: qsTr("Searchable multi-select")
        }

        Text {
            text: qsTr("Number field")
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.labelLarge.size
        }
        RowLayout {
            Layout.fillWidth: true
            Layout.maximumWidth: 360
            spacing: 12
            Md3NumberField {
                Layout.fillWidth: true
                label: qsTr("Quantity")
                value: 3
                from: 0
                to: 99
                stepSize: 1
                supportingText: qsTr("↑↓ or steppers")
            }
            Md3NumberField {
                Layout.preferredWidth: 140
                variant: Md3NumberField.Filled
                label: qsTr("Price")
                value: 12.5
                from: 0
                to: 999
                stepSize: 0.5
                decimals: 1
                prefix: "$"
            }
        }

        Md3TextField {
            Layout.fillWidth: true
            Layout.maximumWidth: 360
            variant: Md3TextField.Outlined
            label: "Error"
            error: true
            errorText: "Enter a valid value"
            text: "bad@"
        }

        Md3TextField {
            Layout.fillWidth: true
            Layout.maximumWidth: 360
            variant: Md3TextField.Filled
            label: "Password"
            password: true
        }

        Md3TextField {
            Layout.fillWidth: true
            Layout.maximumWidth: 360
            variant: Md3TextField.Outlined
            label: qsTr("城市（AutoComplete）")
            supportingText: qsTr("↑↓ 选择 · Enter 确认 · Esc 关闭")
            autoComplete: true
            accessibleName: qsTr("城市")
            accessibleDescription: qsTr("带自动完成的城市输入")
            suggestions: [
                "Beijing", "Shanghai", "Guangzhou", "Shenzhen",
                "Hangzhou", "Chengdu", "Wuhan", "Nanjing",
                { label: "Hong Kong", value: "Hong Kong" },
                { label: "Taipei", value: "Taipei" }
            ]
        }

        Md3PageSection {
            Layout.fillWidth: true
            Layout.maximumWidth: 360
            title: qsTr("Form (name + validate)")
            subtitle: qsTr("Fields with `name` get errors from Md3Form automatically.")

            Md3Form {
                id: demoForm
                width: parent.width
                requiredFields: ["email", "role"]

                Md3TextField {
                    name: "email"
                    label: qsTr("Email")
                    placeholderText: "you@example.com"
                }
                Md3Select {
                    name: "role"
                    label: qsTr("Role")
                    placeholderText: qsTr("Choose a role")
                    model: [qsTr("Admin"), qsTr("Editor"), qsTr("Viewer")]
                }
                Md3NumberField {
                    name: "seats"
                    label: qsTr("Seats")
                    value: 1
                    from: 1
                    to: 99
                }
                Md3HStack {
                    spacing: 8
                    Md3Button {
                        text: qsTr("Validate")
                        onClicked: {
                            if (demoForm.validate())
                                Md3Notify.snackbar(qsTr("Form OK"))
                            else
                                Md3Notify.snackbar(qsTr("Fix required fields"))
                        }
                    }
                    Md3Button {
                        text: qsTr("Clear errors")
                        variant: Md3Button.Outlined
                        onClicked: demoForm.clearErrors()
                    }
                }
            }
        }

        Text {
            text: qsTr("Key sequence")
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.labelLarge.size
        }
        Md3KeySequenceField {
            Layout.fillWidth: true
            Layout.maximumWidth: 360
            label: qsTr("Command palette")
            placeholderText: qsTr("Press shortcut")
            supportingText: qsTr("Esc/Backspace clears. Function keys can be used alone.")
            reservedShortcuts: ["Ctrl+K", "Ctrl+P", "Shift+Enter"]
            sequence: "Ctrl+K"
        }
        Md3KeySequenceField {
            Layout.fillWidth: true
            Layout.maximumWidth: 360
            label: qsTr("Refresh project")
            supportingText: qsTr("Requires modifier or F-key.")
            allowSingleKeyFunctionKeys: true
            allowSingleKeyNavigation: false
            allowSingleKeyLetters: false
            sequence: "F5"
        }
    }
}
