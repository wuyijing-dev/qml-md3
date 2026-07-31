# 多文档标签与撕裂（Tear-off）

## 稳定 API（`Md3ApplicationWindow`）

| 属性 / 方法 | 说明 |
|-------------|------|
| `documentTabsEnabled` | 显示 `Md3DocumentTabBar` |
| `documentTabsManaged` | 自动 activate/close/add/reorder/tear-off |
| `documentTabs` | `[{ title, icon?, pageIndex, … }]` |
| `documentTabsTearOff` | 允许拖出标签 |
| `documentTabsClosable` / `ShowAdd` | 关闭 / 新建 |
| `unifiedTitleChrome` | 标题栏与标签同一 `surfaceContainer` 色带（默认 true） |
| `showTitleBackButton` | 有 rail + destinations 时标题栏左侧返回（默认开启） |
| `openTab` / `closeTab` / `addTab` / `moveTab` / `activateTab` | 托管 API |
| `tearOffTab(index, globalX, globalY)` | 撕到新 `Md3TabWindow` |

`Md3DocumentTabBar.tearOffEnabled` + `tabTearOff(index, gx, gy)` 由窗口转发。

## 策略建议

1. **单页多标签**：`pageIndex` 指向 `destinations`；撕裂时复制元数据到 `Md3TabWindow`。  
2. **关到最后一个**：`documentTabsCloseWindowWhenEmpty`（子窗默认 true）。  
3. **不要**在未托管模式下自己改 `documentTabs` 又不调 `navigateTo`——易不同步。  
4. 子窗继续支持撕裂，形成多窗文档工作区。

## 示例

```qml
Md3ApplicationWindow {
    documentTabsEnabled: true
    documentTabsManaged: true
    documentTabsTearOff: true
    destinations: [ /* … */ ]
}
```

Gallery「桌面模式 / 窗口」页可参考标签与窗口能力演示。
