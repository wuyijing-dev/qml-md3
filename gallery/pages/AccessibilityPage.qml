import QtQuick
import QtQuick.Layouts
import Md3

Flickable {
    id: root
    contentWidth: width
    contentHeight: col.height
    clip: true

    property var scanFindings: []
    property int scanCount: -1

    function refreshScanHint() {
        const xhr = new XMLHttpRequest()
        xhr.onreadystatechange = function () {
            if (xhr.readyState !== XMLHttpRequest.DONE)
                return
            if (xhr.status !== 200 && xhr.status !== 0)
                return
            try {
                const data = JSON.parse(xhr.responseText)
                scanCount = data.count !== undefined ? data.count : (data.findings || []).length
                scanFindings = data.findings || []
            } catch (e) {
                scanCount = -1
                scanFindings = []
            }
        }
        xhr.open("GET", "qrc:/gallery/data/a11y-scan.json")
        xhr.send()
    }

    Component.onCompleted: refreshScanHint()

    ColumnLayout {
        id: col
        width: root.width
        spacing: 16

        Text {
            text: qsTr("无障碍与国际化")
            color: Md3Theme.colorScheme.colorOnSurface
            font.pixelSize: Md3Theme.typography.headlineMedium.size
            font.family: Md3Theme.typography.fontFamily
        }
        Text {
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            text: qsTr("验收焦点环、读屏播报、高对比/减弱动效、对话框 Esc，以及界面语言。详见 docs/a11y.md 与 docs/i18n.md。")
            color: Md3Theme.colorScheme.colorOnSurfaceVariant
            font.pixelSize: Md3Theme.typography.bodyMedium.size
        }

        Md3Card {
            Layout.fillWidth: true
            title: qsTr("界面语言")
            subtitle: qsTr("Md3I18n — 加载 :/md3/i18n/md3_<lang>.qm 并 retranslate")
            Column {
                width: parent.width
                spacing: 12
                Md3SegmentedButton {
                    id: langSeg
                    model: [
                        { text: "English" },
                        { text: qsTr("简体中文") }
                    ]
                    currentIndex: Md3I18n.language === "zh_CN" ? 1 : 0
                    onSelectionChanged: {
                        Md3I18n.language = currentIndex === 1 ? "zh_CN" : "en"
                        Md3Accessibility.announce(qsTr("语言：%1").arg(Md3I18n.languageLabel(Md3I18n.language)))
                    }
                }
                Connections {
                    target: Md3I18n
                    function onLanguageChanged() {
                        langSeg.currentIndex = Md3I18n.language === "zh_CN" ? 1 : 0
                    }
                }
                Text {
                    width: parent.width
                    wrapMode: Text.WordWrap
                    text: qsTr("当前 language=%1。下列目录字符串会随语言切换：%2 / %3 / %4")
                        .arg(Md3I18n.language)
                        .arg(qsTr("OK"))
                        .arg(qsTr("Cancel"))
                        .arg(qsTr("Dialog"))
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.pixelSize: Md3Theme.typography.bodySmall.size
                }
            }
        }

        Md3Card {
            Layout.fillWidth: true
            title: qsTr("读屏播报约定")
            Column {
                width: parent.width
                spacing: 8
                Row {
                    spacing: 8
                    Md3Button {
                        text: qsTr("announce")
                        onClicked: Md3Accessibility.announce(qsTr("状态已更新"))
                    }
                    Md3Button {
                        text: qsTr("成功")
                        variant: Md3Button.FilledTonal
                        onClicked: Md3Accessibility.announceSuccess(qsTr("已保存"))
                    }
                    Md3Button {
                        text: qsTr("错误")
                        variant: Md3Button.Outlined
                        onClicked: Md3Accessibility.announceError(qsTr("邮箱格式无效"))
                    }
                }
                Text {
                    width: parent.width
                    wrapMode: Text.WordWrap
                    text: qsTr("liveMessage: %1").arg(Md3Accessibility.liveMessage)
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.pixelSize: Md3Theme.typography.bodySmall.size
                }
            }
        }

        Md3Card {
            Layout.fillWidth: true
            title: qsTr("焦点环（请用 Tab）")
            subtitle: qsTr("showFocusRings=%1").arg(Md3Accessibility.showFocusRings)
            Row {
                spacing: 8
                Md3Button { text: qsTr("一") }
                Md3Button { text: qsTr("二"); variant: Md3Button.FilledTonal }
                Md3IconButton { icon: "settings"; text: qsTr("设置") }
                Md3Switch { text: qsTr("开关") }
            }
        }

        Md3Card {
            Layout.fillWidth: true
            title: qsTr("对话框 Esc / Enter")
            Md3Button {
                text: qsTr("打开对话框")
                onClicked: demoDialog.open = true
            }
        }

        Md3Card {
            Layout.fillWidth: true
            title: qsTr("验收清单 — 高对比 / 减弱动效")
            Column {
                width: parent.width
                spacing: 12
                RowLayout {
                    width: parent.width
                    Text {
                        text: qsTr("高对比度")
                        Layout.fillWidth: true
                        color: Md3Theme.colorScheme.colorOnSurface
                    }
                    Md3Switch {
                        checked: Md3Theme.highContrast
                        accessibleName: qsTr("高对比度")
                        onToggled: function (on) {
                            Md3Theme.highContrast = on
                            Md3Accessibility.announce(on ? qsTr("已开启高对比度") : qsTr("已关闭高对比度"))
                        }
                    }
                }
                RowLayout {
                    width: parent.width
                    Text {
                        text: qsTr("减弱动效")
                        Layout.fillWidth: true
                        color: Md3Theme.colorScheme.colorOnSurface
                    }
                    Md3Switch {
                        checked: Md3Theme.reduceMotion
                        accessibleName: qsTr("减弱动效")
                        onToggled: function (on) {
                            Md3Theme.reduceMotion = on
                            Md3Accessibility.announce(on ? qsTr("已开启减弱动效") : qsTr("已关闭减弱动效"))
                        }
                    }
                }
                RowLayout {
                    width: parent.width
                    Text {
                        text: qsTr("显示焦点环")
                        Layout.fillWidth: true
                        color: Md3Theme.colorScheme.colorOnSurface
                    }
                    Md3Switch {
                        checked: Md3Accessibility.showFocusRings
                        accessibleName: qsTr("显示焦点环")
                        onToggled: function (on) { Md3Accessibility.showFocusRings = on }
                    }
                }
                Text {
                    width: parent.width
                    wrapMode: Text.WordWrap
                    text: qsTr("验收：开启高对比后描边更强；开启减弱动效后过渡近乎瞬时；Tab 可见焦点环。测完请恢复减弱动效以免影响 Gallery 演示。")
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.pixelSize: Md3Theme.typography.bodySmall.size
                }
            }
        }

        Md3Card {
            Layout.fillWidth: true
            title: qsTr("静态审计（脚本）")
            subtitle: scanCount >= 0
                      ? qsTr("快照：%1 个文件可能缺少 Accessible（启发式）").arg(scanCount)
                      : qsTr("未加载 docs/a11y-scan.json 快照")
            Column {
                width: parent.width
                spacing: 8
                Text {
                    width: parent.width
                    wrapMode: Text.WordWrap
                    text: qsTr("在仓库根目录运行：\npython scripts/check_a11y_qml.py --json docs/a11y-scan.json\npython scripts/check_qstr_coverage.py --json docs/i18n-scan.json\n然后复制 docs/a11y-scan.json → gallery/data/ 并重建 Gallery。")
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.pixelSize: Md3Theme.typography.bodySmall.size
                    font.family: Md3Theme.typography.fontFamily
                }
                Text {
                    width: parent.width
                    wrapMode: Text.WordWrap
                    visible: scanFindings.length > 0
                    text: {
                        const max = Math.min(scanFindings.length, 24)
                        let lines = []
                        for (let i = 0; i < max; ++i) {
                            const f = scanFindings[i]
                            lines.push("• " + f.file + " — " + (f.issues || []).join(", "))
                        }
                        if (scanFindings.length > max)
                            lines.push(qsTr("…另有 %1 项，见 JSON").arg(scanFindings.length - max))
                        return lines.join("\n")
                    }
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.pixelSize: Md3Theme.typography.bodySmall.size
                }
                Text {
                    width: parent.width
                    wrapMode: Text.WordWrap
                    text: qsTr("继承 Md3AbstractButton / Md3SelectionControl 的控件已自带 Accessible；脚本会跳过它们。")
                    color: Md3Theme.colorScheme.colorOnSurfaceVariant
                    font.pixelSize: Md3Theme.typography.bodySmall.size
                }
            }
        }

        Md3Card {
            Layout.fillWidth: true
            title: qsTr("RTL 抽查")
            subtitle: qsTr("完整镜像请用主题页 RTL preview；此处仅说明清单")
            Text {
                width: parent.width
                wrapMode: Text.WordWrap
                text: qsTr("• Rail / 列表图标方向\n• 对话框与菜单不被裁切\n• 强制 LTR 的控件（如部分图表）需单独关闭 LayoutMirroring")
                color: Md3Theme.colorScheme.colorOnSurfaceVariant
                font.pixelSize: Md3Theme.typography.bodySmall.size
            }
        }
    }

    Md3Dialog {
        id: demoDialog
        title: qsTr("无障碍对话框")
        text: qsTr("按 Esc 关闭，按 Enter 确认。焦点应落在确认按钮。")
        confirmText: qsTr("确认")
        dismissText: qsTr("取消")
        onConfirmed: Md3Accessibility.announceSuccess(qsTr("已确认"))
        onDismissed: Md3Accessibility.announce(qsTr("已取消"))
    }
}
