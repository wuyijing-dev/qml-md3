import QtQuick
import QtQuick.Layouts
import Md3

Flickable {
    contentWidth: width
    contentHeight: column.height
    clip: true
    ColumnLayout {
        id: column
        width: parent.width
        spacing: 16
        Text {
            text: "Pickers"
            color: Md3Theme.colorScheme.colorOnSurface
            font.pixelSize: Md3Theme.typography.headlineMedium.size
        }
        Md3DatePicker { }
        Md3TimePicker { }
    }
}
