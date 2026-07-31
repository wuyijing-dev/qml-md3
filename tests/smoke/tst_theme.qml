import QtQuick
import QtTest
import Md3

TestCase {
    name: "Md3Theme"
    when: windowShown

    function test_colorScheme_exists() {
        verify(Md3Theme.colorScheme !== undefined)
        verify(Md3Theme.colorScheme.primary !== undefined)
    }

    function test_toggle_dark() {
        const before = Md3Theme.dark
        Md3Theme.dark = !before
        compare(Md3Theme.dark, !before)
        Md3Theme.dark = before
    }
}
