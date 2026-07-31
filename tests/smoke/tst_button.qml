import QtQuick
import QtTest
import Md3

TestCase {
    name: "Md3Button"
    when: windowShown

    Md3Button {
        id: btn
        text: "Go"
        property int clicks: 0
        onClicked: clicks++
    }

    function test_click_increments() {
        const n = btn.clicks
        mouseClick(btn)
        compare(btn.clicks, n + 1)
    }

    function test_accessible_name() {
        compare(btn.accessibleName, "Go")
    }
}
