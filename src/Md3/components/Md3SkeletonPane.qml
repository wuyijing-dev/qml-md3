import QtQuick

/// Full-pane skeleton used by Md3PageHost while a destination loads.
Item {
    id: root

    property bool active: true
    /// "page" | "list" | "cards"
    property string layout: "page"

    Column {
        anchors.fill: parent
        anchors.margins: 4
        spacing: 16

        Row {
            spacing: 12
            visible: root.layout !== "list"
            Md3Skeleton {
                variant: Md3Skeleton.Circular
                width: 40
                height: 40
                active: root.active
            }
            Column {
                spacing: 8
                anchors.verticalCenter: parent.verticalCenter
                Md3Skeleton {
                    variant: Md3Skeleton.Text
                    width: 140
                    height: 14
                    active: root.active
                }
                Md3Skeleton {
                    variant: Md3Skeleton.Text
                    width: 96
                    height: 10
                    active: root.active
                }
            }
        }

        Md3Skeleton {
            variant: Md3Skeleton.Rounded
            width: parent.width
            height: root.layout === "cards" ? 120 : 18
            active: root.active
        }

        Md3Skeleton {
            visible: root.layout === "page" || root.layout === "list"
            variant: Md3Skeleton.Text
            width: parent.width * 0.92
            height: 12
            active: root.active
        }
        Md3Skeleton {
            visible: root.layout === "page" || root.layout === "list"
            variant: Md3Skeleton.Text
            width: parent.width * 0.78
            height: 12
            active: root.active
        }
        Md3Skeleton {
            visible: root.layout === "page"
            variant: Md3Skeleton.Text
            width: parent.width * 0.64
            height: 12
            active: root.active
        }

        Flow {
            visible: root.layout === "cards" || root.layout === "page"
            width: parent.width
            spacing: 12
            Repeater {
                model: root.layout === "cards" ? 4 : 2
                Md3Skeleton {
                    variant: Md3Skeleton.Rounded
                    width: Math.max(120, (parent.width - 12) / 2)
                    height: 88
                    active: root.active
                }
            }
        }

        Column {
            visible: root.layout === "list"
            width: parent.width
            spacing: 12
            Repeater {
                model: 5
                Row {
                    spacing: 12
                    width: parent.width
                    Md3Skeleton {
                        variant: Md3Skeleton.Circular
                        width: 36
                        height: 36
                        active: root.active
                    }
                    Column {
                        spacing: 8
                        anchors.verticalCenter: parent.verticalCenter
                        Md3Skeleton {
                            variant: Md3Skeleton.Text
                            width: 180
                            height: 12
                            active: root.active
                        }
                        Md3Skeleton {
                            variant: Md3Skeleton.Text
                            width: 120
                            height: 10
                            active: root.active
                        }
                    }
                }
            }
        }
    }
}
