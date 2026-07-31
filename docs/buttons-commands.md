# 按钮与命令条

WinUI 对照的按钮 / 工具栏选用约定。属性表见 [api/README.md](api/README.md)；Gallery：**按钮**页。

## 选用一览

| 场景 | 推荐 | WinUI 近似 | 避免 |
|------|------|------------|------|
| 页内主操作 | `Md3Button` Filled | Button | 同一行多个 Filled |
| 开/关状态（有文案） | `Md3ToggleButton` | ToggleButton | 用普通 Button + 自己管 `checked` |
| 开/关状态（仅图标） | `Md3ToggleIconButton` | ToggleButton（图标） | 长文案塞进 IconButton |
| 主操作 + 旁路菜单 | `Md3SplitButton` | SplitButton | 两个独立按钮硬拼 |
| 整钮只开菜单 | `Md3DropDownButton` | DropDownButton | 误用 Split（无主操作时） |
| 行内链接 / 外开 URL | `Md3Hyperlink` | HyperlinkButton | 用 Text Button 冒充链接 |
| 窗顶简单工具条 | `Md3AppToolBar` | — | 需要溢出菜单时仍用它 |
| 主命令 + 次命令溢出 | `Md3CommandBar` | CommandBar | 把次要命令全堆主栏 |
| 命令条内图标项 | `Md3AppBarButton` | AppBarButton | 大号 Filled Button 塞工具栏 |
| 命令条内切换项 | `Md3AppBarToggleButton` | AppBarToggleButton | 用 Switch 占满工具栏高度 |

## Toggle

```qml
Md3ToggleButton {
    text: qsTr("Bold")
    icon: "format_bold"
    checked: true
    onToggled: (on) => applyBold(on)
}

Md3ToggleButton {
    text: qsTr("Outline")
    variant: Md3ToggleButton.Outlined
}
```

图标-only → `Md3ToggleIconButton`。

## DropDown vs Split

| | `Md3DropDownButton` | `Md3SplitButton` |
|--|---------------------|------------------|
| 点击主区 | 打开菜单 | 执行主操作（`clicked`） |
| Chevron | 一体在按钮内 | 独立尾段 |
| 适用 | 「新建…」「导出为…」 | 「保存」+「另存为 / 全部保存」 |

```qml
Md3DropDownButton {
    text: qsTr("New")
    icon: "add"
    menuModel: [
        { text: qsTr("Document"), icon: "description" },
        { text: qsTr("Folder"), icon: "folder" }
    ]
    onMenuItemClicked: (i) => createAt(i)
}
```

## Hyperlink

```qml
Md3Hyperlink {
    text: qsTr("Material Design 3")
    url: "https://m3.material.io/"
}

// 仅导航 / 业务回调：不设 url，或 openExternally: false
Md3Hyperlink {
    text: qsTr("Open settings")
    openExternally: false
    onClicked: stack.push("SettingsPage.qml")
}
```

## CommandBar

挂到 `Md3ApplicationWindow.toolBar`，或页内自用。

```qml
Md3ApplicationWindow {
    toolBar: Md3CommandBar {
        overflowModel: [
            { text: qsTr("Share"), icon: "share" },
            { text: qsTr("Print"), icon: "print" },
            { text: qsTr("Settings"), icon: "settings" }
        ]
        onOverflowItemClicked: (i) => runSecondary(i)

        Md3AppBarButton {
            icon: "save"
            label: qsTr("Save")
            onClicked: save()
        }
        Md3AppBarButton {
            icon: "undo"
            label: qsTr("Undo")
            layout: Md3AppBarButton.IconOnly
        }
        Md3AppBarToggleButton {
            icon: "grid_view"
            label: qsTr("Grid")
            checked: true
        }
    }
}
```

- **主命令**：默认子项（`Md3AppBarButton` / Toggle / 少量 `Md3Button.Text`）。
- **次命令**：`overflowModel` → 右侧 `more_horiz` 菜单。
- 只需任意自定义内容、无溢出：继续用 [`Md3AppToolBar`](api/Md3AppToolBar.md)。

## API 与附录

| 控件 | API | 手写附录 |
|------|-----|----------|
| Toggle | [Md3ToggleButton](api/Md3ToggleButton.md) | [api-manual](api-manual/Md3ToggleButton.md) |
| DropDown | [Md3DropDownButton](api/Md3DropDownButton.md) | [api-manual](api-manual/Md3DropDownButton.md) |
| Hyperlink | [Md3Hyperlink](api/Md3Hyperlink.md) | [api-manual](api-manual/Md3Hyperlink.md) |
| CommandBar | [Md3CommandBar](api/Md3CommandBar.md) | [api-manual](api-manual/Md3CommandBar.md) |
| AppBar | [Md3AppBarButton](api/Md3AppBarButton.md) | [api-manual](api-manual/Md3AppBarButton.md) |
| AppBar Toggle | [Md3AppBarToggleButton](api/Md3AppBarToggleButton.md) | [api-manual](api-manual/Md3AppBarToggleButton.md) |

`python scripts/docs/gen_api_docs.py` 会把 `docs/api-manual/<Type>.md` 拼到对应 API 页末尾。
