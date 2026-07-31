import QtQuick
import Md3

/// UX patterns: empty / loading / error / form submit gate / shortcuts.
Md3Page {
    id: page

    property bool _listLoading: false
    property bool _listError: false
    property var _listModel: []

    function _fillDemoList() {
        _listError = false
        _listLoading = false
        _listModel = [
            { title: qsTr("Alpha"), subtitle: qsTr("Ready") },
            { title: qsTr("Beta"), subtitle: qsTr("Ready") },
            { title: qsTr("Gamma"), subtitle: qsTr("Ready") }
        ]
    }

    function _simulateLoad() {
        _listError = false
        _listModel = []
        _listLoading = true
        loadTimer.restart()
    }

    function _simulateError() {
        loadTimer.stop()
        _listLoading = false
        _listModel = []
        _listError = true
    }

    Timer {
        id: loadTimer
        interval: 1200
        onTriggered: page._fillDemoList()
    }

    Flickable {
        id: flick
        anchors.fill: parent
        contentWidth: width
        contentHeight: col.implicitHeight
        clip: true

        Md3VStack {
            id: col
            width: flick.width
            spacing: Md3Theme.spacingXl

            Md3Text {
                text: qsTr("模式")
                role: Md3Text.HeadlineMedium
            }
            Md3Text {
                width: parent.width
                wrapMode: Text.Wrap
                text: qsTr("空态 / 加载 / 错误、表单提交门控、快捷键约定。详见 docs/design-guidelines.md。")
                role: Md3Text.BodyMedium
                tone: Md3Text.OnSurfaceVariant
            }

            Md3PageSection {
                width: parent.width
                title: qsTr("空态 · 加载 · 错误")
                subtitle: qsTr("同一列表容器三种状态切换")

                Md3VStack {
                    width: parent.width
                    spacing: Md3Theme.spacingMd

                    Md3HStack {
                        spacing: Md3Theme.spacingSm
                        Md3Button {
                            text: qsTr("加载")
                            onClicked: page._simulateLoad()
                        }
                        Md3Button {
                            text: qsTr("成功数据")
                            variant: Md3Button.Outlined
                            onClicked: page._fillDemoList()
                        }
                        Md3Button {
                            text: qsTr("失败")
                            variant: Md3Button.Outlined
                            onClicked: page._simulateError()
                        }
                        Md3Button {
                            text: qsTr("清空")
                            variant: Md3Button.Text
                            onClicked: {
                                loadTimer.stop()
                                page._listLoading = false
                                page._listError = false
                                page._listModel = []
                            }
                        }
                    }

                    Item {
                        width: parent.width
                        height: 220

                        Md3SkeletonPane {
                            anchors.fill: parent
                            visible: page._listLoading
                            active: page._listLoading
                            layout: "list"
                        }

                        Md3EmptyState {
                            anchors.fill: parent
                            visible: !page._listLoading && page._listError
                            icon: "error_outline"
                            title: qsTr("无法加载列表")
                            body: qsTr("检查网络后重试，或稍后再试。")
                            actionText: qsTr("重试")
                            onActionClicked: page._simulateLoad()
                        }

                        Md3EmptyState {
                            anchors.fill: parent
                            visible: !page._listLoading && !page._listError && page._listModel.length === 0
                            icon: "inbox"
                            title: qsTr("还没有项目")
                            body: qsTr("创建第一个项目，或切换上方按钮模拟加载。")
                            actionText: qsTr("模拟加载")
                            onActionClicked: page._simulateLoad()
                        }

                        Md3VirtualList {
                            anchors.fill: parent
                            visible: !page._listLoading && !page._listError && page._listModel.length > 0
                            model: page._listModel
                            itemHeight: Md3Theme.tableRowHeight
                            delegate: Component {
                                Md3ListTile {
                                    title: modelData.title
                                    subtitle: modelData.subtitle
                                }
                            }
                        }
                    }
                }
            }

            Md3PageSection {
                width: Math.min(parent.width, 400)
                title: qsTr("表单提交门控")
                subtitle: qsTr("enabled: form.canSubmit — 必填填齐且无错误才可提交")

                Md3Form {
                    id: gateForm
                    width: parent.width
                    requiredFields: ["name", "email"]
                    onSubmitted: function (values) {
                        Md3Notify.snackbar(qsTr("已提交：%1").arg(values.email))
                    }

                    Md3TextField {
                        name: "name"
                        label: qsTr("Name")
                        placeholderText: qsTr("Required")
                    }
                    Md3TextField {
                        name: "email"
                        label: qsTr("Email")
                        placeholderText: "you@example.com"
                    }
                    Md3HStack {
                        spacing: Md3Theme.spacingSm
                        Md3Button {
                            text: qsTr("Submit")
                            enabled: gateForm.canSubmit
                            onClicked: {
                                if (!gateForm.submit())
                                    Md3Notify.snackbar(qsTr("请填写必填项"))
                            }
                        }
                        Md3Button {
                            text: qsTr("标错邮箱")
                            variant: Md3Button.Outlined
                            onClicked: gateForm.setError("email", qsTr("格式无效"))
                        }
                        Md3Button {
                            text: qsTr("清错误")
                            variant: Md3Button.Text
                            onClicked: gateForm.clearErrors()
                        }
                    }
                    Md3Text {
                        text: qsTr("canSubmit=%1  hasErrors=%2").arg(gateForm.canSubmit).arg(gateForm.hasErrors)
                        role: Md3Text.LabelSmall
                        tone: Md3Text.OnSurfaceVariant
                    }
                }
            }

            Md3PageSection {
                width: parent.width
                title: qsTr("快捷键与命令面板")
                subtitle: qsTr("Gallery 全局 Ctrl+K；下方字段演示保留键冲突检测")

                Md3VStack {
                    width: parent.width
                    spacing: Md3Theme.spacingMd

                    Md3Text {
                        width: parent.width
                        wrapMode: Text.Wrap
                        text: qsTr("按 Ctrl+K 打开命令面板，可跳转本页与其它目的地。自定义快捷键勿占用保留序列。")
                        role: Md3Text.BodyMedium
                        tone: Md3Text.OnSurfaceVariant
                    }
                    Md3KeySequenceField {
                        width: Math.min(parent.width, 360)
                        label: qsTr("自定义快捷键")
                        sequence: "Ctrl+Shift+P"
                        reservedShortcuts: ["Ctrl+K", "Ctrl+S", "Ctrl+W", "F11"]
                        supportingText: hasConflict ? qsTr("与保留快捷键冲突")
                                                    : qsTr("保留：Ctrl+K 命令面板等")
                    }
                    Md3Banner {
                        width: parent.width
                        text: qsTr("密度可在「主题」页切换舒适 / 紧凑（Md3Theme.density）。")
                        primaryAction: qsTr("知道了")
                        showClose: true
                    }
                }
            }

            Item { width: parent.width; height: Md3Theme.spacingLg }
        }
    }

    Component.onCompleted: page._listModel = []
}
