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
    }
}
