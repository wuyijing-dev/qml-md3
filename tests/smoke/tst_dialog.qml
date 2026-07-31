import QtQuick
import QtTest
import Md3

TestCase {
    name: "Md3Dialog"
    when: windowShown

    Item {
        id: host
        width: 400
        height: 300

        Md3Dialog {
            id: dlg
            anchors.fill: parent
            title: "T"
            text: "Body"
            property int dismissedCount: 0
            onDismissed: dismissedCount++
        }
    }

    function test_esc_dismisses() {
        dlg.open = true
        tryCompare(dlg, "open", true)
        keyClick(Qt.Key_Escape)
        tryCompare(dlg, "open", false)
        verify(dlg.dismissedCount >= 1)
    }
}
