import QtQuick
import QtQuick.Layouts
import Md3

Item {
    ColumnLayout {
        anchors.centerIn: parent
        width: Math.min(parent.width - 48, 360)
        spacing: 16
        Text {
            text: "Sign in"
            color: Md3Theme.colorScheme.colorOnSurface
            font.pixelSize: Md3Theme.typography.headlineMedium.size
            font.family: Md3Theme.typography.fontFamily
        }
        Md3TextField {
            Layout.fillWidth: true
            variant: Md3TextField.Outlined
            label: "Email"
            leadingIcon: "person"
        }
        Md3TextField {
            Layout.fillWidth: true
            variant: Md3TextField.Outlined
            label: "Password"
            password: true
        }
        Md3Button {
            Layout.fillWidth: true
            text: "Continue"
        }
        Md3Button {
            Layout.fillWidth: true
            text: "Create account"
            variant: Md3Button.Text
        }
    }
}
