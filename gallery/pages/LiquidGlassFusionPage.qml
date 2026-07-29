import QtQuick
import Md3

Md3PageSection {
    id: root
    title: qsTr("液态玻璃 · 水滴融合")
    subtitle: qsTr("两块玻璃在同一 SDF 场中融合；拖近后会拉出液态桥接，边缘会拾取背景色形成高光。")

    Column {
        width: root.width
        spacing: 16

        Md3Text {
            width: parent.width
            wrapMode: Text.Wrap
            role: Md3Text.BodyMedium
            tone: Md3Text.OnSurfaceVariant
            text: qsTr("把 Glass A / Glass B 拖到一起观察融合。下方滑杆可调节融合强度与边缘光谱强度。")
        }

        Md3LiquidGlassFusionPlayground {
            id: playground
            width: Math.min(root.width, 760)
            height: 420
            fusionStrength: fusionSlider.value
        }

        Md3Slider {
            id: fusionSlider
            width: parent.width
            label: qsTr("Body fusion (SDF smooth-min)")
            from: 0.04
            to: 0.28
            value: 0.14
            showValue: true
        }

        Md3Text {
            width: parent.width
            role: Md3Text.BodySmall
            tone: Md3Text.OnSurfaceVariant
            text: qsTr("默认 Md3LiquidGlass 已改为通透玻璃（低雾面、低染色、更强边缘光谱）。单块卡片仍用 Containment 页演示。")
        }
    }
}
