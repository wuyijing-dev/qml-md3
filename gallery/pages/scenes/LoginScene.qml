import QtQuick
import Md3

Md3Page {
    Md3VStack {
        anchors.centerIn: parent
        width: Math.min(parent.width - 48, 360)
        spacing: 16

        Md3Text {
            text: "Sign in"
            role: Md3Text.HeadlineMedium
        }
        Md3TextField {
            width: parent.width
            variant: Md3TextField.Outlined
            label: "Email"
            leadingIcon: "person"
        }
        Md3TextField {
            width: parent.width
            variant: Md3TextField.Outlined
            label: "Password"
            password: true
        }
        Md3Button {
            width: parent.width
            text: "Continue"
        }
        Md3Button {
            width: parent.width
            text: "Create account"
            variant: Md3Button.Text
        }
    }
}
