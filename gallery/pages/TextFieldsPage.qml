import QtQuick
import Md3

Flickable {
    id: root
    contentWidth: width
    contentHeight: column.implicitHeight
    clip: true

    property bool md3PageActive: true

    Md3VStack {
        id: column
        width: root.width
        spacing: 20

        Md3Text {
            text: "Text fields"
            role: Md3Text.HeadlineMedium
        }

        Md3TextField {
            width: Math.min(parent.width, 360)
            variant: Md3TextField.Filled
            label: "Filled"
            supportingText: "Supporting text"
        }

        Md3TextField {
            width: Math.min(parent.width, 360)
            variant: Md3TextField.Outlined
            label: "Outlined"
            leadingIcon: "search"
            trailingIcon: "close"
            text: "Clear me"
        }

        Md3Text {
            text: qsTr("Select")
            role: Md3Text.LabelLarge
            tone: Md3Text.OnSurfaceVariant
        }
        Md3Select {
            width: Math.min(parent.width, 360)
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
            width: Math.min(parent.width, 360)
            variant: Md3Select.Filled
            label: qsTr("Priority")
            error: true
            errorText: qsTr("Required")
            model: [qsTr("Low"), qsTr("Medium"), qsTr("High")]
        }

        Md3Select {
            width: Math.min(parent.width, 360)
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

        Md3Text {
            text: qsTr("Number field")
            role: Md3Text.LabelLarge
            tone: Md3Text.OnSurfaceVariant
        }
        Md3HStack {
            id: numberRow
            width: Math.min(column.width, 360)
            spacing: 12
            Md3NumberField {
                width: Math.max(120, numberRow.width - 152)
                label: qsTr("Quantity")
                value: 3
                from: 0
                to: 99
                stepSize: 1
                supportingText: qsTr("↑↓ or steppers")
            }
            Md3NumberField {
                width: 140
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
            width: Math.min(parent.width, 360)
            variant: Md3TextField.Outlined
            label: "Error"
            error: true
            errorText: "Enter a valid value"
            text: "bad@"
        }

        Md3TextField {
            width: Math.min(parent.width, 360)
            variant: Md3TextField.Filled
            label: "Password"
            password: true
        }

        Md3PasswordField {
            width: Math.min(parent.width, 360)
            label: qsTr("Password (strength)")
            supportingText: qsTr("Built-in visibility toggle + strength meter")
        }

        Md3TagField {
            width: Math.min(parent.width, 480)
            label: qsTr("Recipients")
            placeholderText: qsTr("Type and press Enter")
            tags: ["ada@example.com", "design"]
            supportingText: qsTr("Enter / comma to add · Backspace removes last")
        }

        Md3TextField {
            width: Math.min(parent.width, 360)
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
            width: Math.min(parent.width, 360)
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
                        text: qsTr("Submit")
                        enabled: demoForm.canSubmit
                        onClicked: {
                            if (demoForm.submit())
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

        Md3Text {
            text: qsTr("Key sequence")
            role: Md3Text.LabelLarge
            tone: Md3Text.OnSurfaceVariant
        }
        Md3KeySequenceField {
            width: Math.min(parent.width, 360)
            label: qsTr("Command palette")
            placeholderText: qsTr("Press shortcut")
            supportingText: qsTr("Esc/Backspace clears. Function keys can be used alone.")
            reservedShortcuts: ["Ctrl+K", "Ctrl+P", "Shift+Enter"]
            sequence: "Ctrl+K"
        }
        Md3KeySequenceField {
            width: Math.min(parent.width, 360)
            label: qsTr("Refresh project")
            supportingText: qsTr("Requires modifier or F-key.")
            allowSingleKeyFunctionKeys: true
            allowSingleKeyNavigation: false
            allowSingleKeyLetters: false
            sequence: "F5"
        }
    }
}
