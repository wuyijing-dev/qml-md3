import QtQuick
import QtTest
import Md3

TestCase {
    name: "Md3PageHost"
    when: windowShown

    Md3PageHost {
        id: host
        width: 320
        height: 240
        pageTransition: "none"
        cacheMode: "none"
        model: [
            { title: "One", source: "" },
            { title: "Two", source: "" }
        ]
    }

    function test_initial_index() {
        compare(host.currentIndex, 0)
    }

    function test_set_current_index() {
        host.currentIndex = 1
        compare(host.currentIndex, 1)
        host.currentIndex = 0
    }
}
