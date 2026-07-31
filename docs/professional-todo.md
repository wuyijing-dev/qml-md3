# QML MD3 — WinUI 3 功能对标 TODO

> **对标目标：** [WinUI 3 / Windows App SDK](https://learn.microsoft.com/windows/apps/winui/winui3/) 桌面控件与 Fluent 模式（参考 WinUI 3 Gallery）。  
> **视觉语言：** 仍走 Material Design 3；本文件只谈 **能力面 / 交互模式 / 桌面壳**，不做 Fluent 换皮。  
> **原则：** 生产桌面高频优先；WinUI 专属（WebView2 / Ink / Map）可标「可选」或「不跟」。  
> 勾选：`- [ ]` 未做 · `- [x]` 已有可用等价（名称可不同）· `- [~]` 部分覆盖

**基线日期：** 2026-07-31 · 库版本 `1.0.0`

---

## 0. 对标说明

| WinUI 概念 | Md3 近似 |
|------------|----------|
| `NavigationView` | `Md3NavigationRail` + `Md3NavigationDrawer` + `Md3PageHost` / `Md3Scaffold` |
| `TitleBar` + caption | `Md3TitleBar` + `Md3CaptionButtons` + `Md3ApplicationWindow` |
| `TabView` | `Md3DocumentTabBar` + `Md3TabWindow`（撕离） |
| `ContentDialog` / `Flyout` | `Md3Dialog` / `Md3FullscreenDialog` / `Md3Menu` / `Md3SideSheet` |
| `InfoBar` / `TeachingTip` | `Md3InfoBar` / `Md3Banner` / `Md3Tour` / `Md3Snackbar`·`Md3Toast` |
| `ItemsRepeater` / `ListView` | `Md3VirtualList` / `Md3ListTile` |
| `TreeView` | `Md3TreeView` |
| `DataGrid`（社区/Toolkit） | `Md3DataTable` |
| Mica / Acrylic | `systemBackdrop` / 液态玻璃（实验）— 能力有，策略见 `docs/experimental.md` |

**明确不跟（或极低优先）：** `WebView2`、`MapControl`、`InkCanvas`/`InkToolbar`、`MediaPlayerElement` 完整壳、商店 Inking 栈。

---

## 1. 对标矩阵（WinUI → Md3）

### 1.1 按钮与命令

| WinUI | Md3 | 状态 | 缺口 / 下一步 |
|-------|-----|------|----------------|
| Button | `Md3Button` | [x] | — |
| ToggleButton | `Md3ToggleButton` + `Md3ToggleIconButton` | [x] | 文本 Filled/Outlined；图标仍用 ToggleIconButton |
| SplitButton | `Md3SplitButton` | [x] | — |
| DropDownButton | `Md3DropDownButton` | [x] | 整钮开菜单 + chevron；与 Split 主操作分离 |
| HyperlinkButton | `Md3Hyperlink` | [x] | 可选 `url` → `Qt.openUrlExternally` |
| AppBarButton / CommandBar | `Md3AppBarButton` / `Md3CommandBar` | [x] | 主命令槽 + `overflowModel` 次命令 |
| AppBarToggleButton | `Md3AppBarToggleButton` | [x] | `checkable` 工具栏项 |

### 1.2 输入与选择

| WinUI | Md3 | 状态 | 缺口 / 下一步 |
|-------|-----|------|----------------|
| TextBox | `Md3TextField` | [x] | — |
| PasswordBox | `Md3PasswordField` | [x] | — |
| NumberBox | `Md3NumberField` | [x] | 对齐 WinUI：spin、validation mode |
| AutoSuggestBox | TextField autocomplete / Search | [~] | 统一 **AutoSuggest** API（querySubmitted / suggestionChosen） |
| RichEditBox | — | [ ] | 可选：轻量 `Md3RichText` 或明确不做 |
| ComboBox | `Md3Select` / `Md3Option` | [x] | editable ComboBox 模式 |
| CheckBox | `Md3Checkbox` | [x] | — |
| RadioButtons | `Md3Radio` + `Md3RadioGroup` | [x] | — |
| ToggleSwitch | `Md3Switch` | [x] | — |
| Slider | `Md3Slider` / `Md3RangeSlider` | [x] | — |
| ColorPicker | `Md3ColorPicker` | [x] | — |
| CalendarView | DatePicker 内嵌 | [~] | 独立 **日历视图**（多选日期） |
| CalendarDatePicker | `Md3DateField` / `Md3DatePicker` | [x] | — |
| DatePicker | `Md3DateField` | [x] | — |
| TimePicker | `Md3TimeField` / `Md3TimePicker` | [x] | — |
| PersonPicture | `Md3Avatar` / Group | [x] | — |

### 1.3 集合与数据

| WinUI | Md3 | 状态 | 缺口 / 下一步 |
|-------|-----|------|----------------|
| ListView | `Md3VirtualList` + `Md3ListTile` | [~] | 分组头、多选模式、swipe |
| GridView | `Md3GridLayout` + cards | [~] | 数据驱动 **GridView**（虚拟化 + selection） |
| ItemsView | — | [ ] | 统一 Items 布局策略（stack/grid/waterfall） |
| ItemsRepeater | VirtualList 底层 | [~] | 公开更原语的 repeater API（若需要） |
| TreeView | `Md3TreeView` | [x] | 拖放节点、多列树 |
| FlipView | `Md3Carousel` | [~] | 单页翻转 + 指示点对齐 Pips |
| PipsPager | — | [ ] | `Md3PipsPager` |
| SemanticZoom | — | [ ] | 可选（桌面低频） |
| AnnotatedScrollBar | `Md3ScrollBar` | [~] | 标注刻度 / 字母索引 |
| Pull-to-refresh | — | [ ] | 触摸场景；桌面可降优先 |
| Swipe | — | [ ] | 列表项滑动操作 |
| DataGrid（Toolkit） | `Md3DataTable` | [x] | 单元格编辑、冻结列 UX 再对齐 |

### 1.4 导航与窗口壳（桌面核心）

| WinUI | Md3 | 状态 | 缺口 / 下一步 |
|-------|-----|------|----------------|
| NavigationView | Rail + Drawer + PageHost | [~] | **一体 NavigationView**（顶/左模式、页脚、自动 pane） |
| BreadcrumbBar | `Md3Breadcrumb` | [x] | — |
| TabView | `Md3DocumentTabBar` + TabWindow | [x] | Tab 预览、拖入合并 |
| TitleBar | `Md3TitleBar` | [x] | 与内容区交互控件混排（Win11 式） |
| MenuBar | `Md3MenuBar` | [x] | — |
| SplitView | `Md3SplitView` | [x] | — |
| SelectorBar / Segmented | `Md3SegmentedButton` | [x] | — |
| Frame / 页面栈 | `Md3PageHost` + `Md3Page` | [x] | 深链适配文档已有；补 Gallery 对照 WinUI Frame |
| 多窗口 | `Md3DialogWindow` / TabWindow | [x] | — |

### 1.5 对话框、浮层与反馈

| WinUI | Md3 | 状态 | 缺口 / 下一步 |
|-------|-----|------|----------------|
| ContentDialog | `Md3Dialog` | [x] | — |
| Flyout | Menu / SideSheet / 自定义 Popup | [~] | 轻量 **`Md3Flyout`**（锚定 + light-dismiss） |
| MenuFlyout | `Md3Menu` | [x] | — |
| CommandBarFlyout | — | [ ] | 选区工具条浮层（文本/图片编辑场景） |
| TeachingTip | `Md3Tour` / Tooltip | [~] | 单点 **TeachingTip**（箭头锚定 + 步骤可选） |
| InfoBar | `Md3InfoBar` / Banner | [x] | — |
| InfoBadge | IconButton badge / `Md3Badge` | [x] | — |
| ProgressBar | `Md3LinearProgressIndicator` | [x] | — |
| ProgressRing | `Md3CircularProgressIndicator` / Loading | [x] | — |
| ToolTip | `Md3Tooltip` | [x] | — |
| Expander | `Md3ExpansionTile` | [x] | SettingsExpander 式分组 |

### 1.6 媒体 / 系统 / 实验（策略）

| WinUI | Md3 策略 | 状态 |
|-------|----------|------|
| WebView2 | 不入库；消费方自嵌 | [ ] 文档「边界」一节 |
| Ink* | 不跟 | [ ] 写入不做清单 |
| MapControl | 不跟 | [ ] |
| MediaPlayerElement | 可选薄封装或示例 | [ ] |
| Mica/Acrylic | backdrop API 已有 | [~] Gallery 默认策略与 Win11 对齐文档 |

---

## 2. 功能迭代路线（按 WinUI Gallery 场景）

### W1 — 桌面壳对齐（2–3 周）

- [ ] `Md3NavigationView`（或增强 Scaffold）：`paneDisplayMode` = Left / LeftCompact / Top；自动折叠阈值
- [ ] `Md3Flyout`：锚定控件、light-dismiss、Esc、焦点归还
- [x] `Md3DropDownButton` / `Md3Hyperlink`
- [ ] TitleBar **内容槽**（搜索框、账号头像）官方示例
- [ ] Gallery：对照 WinUI「Navigation / Window」页信息架构

### W2 — 集合与编辑（3–4 周）

- [ ] `Md3ListView`：多选、分组、空态、键盘多选
- [ ] `Md3GridView`：虚拟化网格选择
- [ ] `Md3PipsPager` + Carousel/Flip 指示对齐
- [ ] DataTable：**单元格就地编辑**、剪贴板导出钩子 Gallery 演示
- [ ] TreeView：拖放排序（可选）

### W3 — 输入与设置页模式（2 周）

- [ ] AutoSuggest 统一信号（对齐 AutoSuggestBox）
- [ ] `Md3Rating`
- [ ] `Md3SettingsSection` / SettingsExpander 模式（WinUI Settings 页）
- [ ] CalendarView 多选 / 黑名单日期
- [ ] NumberBox spin + 校验模式对齐文档

### W4 — 教学与命令面（1–2 周）

- [ ] `Md3TeachingTip`
- [x] CommandBar + overflow（`Md3CommandBar` / `Md3AppBarButton`）
- [ ] CommandBarFlyout（文本选区场景可后置）
- [ ] Tour / TeachingTip 与 InfoBar 层级规范一页

### W5 — 工程对等 WinUI Gallery（持续）

- [ ] `examples/hello-md3`（find_package + 一窗）
- [ ] Gallery 按 WinUI 分类重排导航（Basics / Collections / Dialogs / Navigation / Media）
- [ ] 每个对标控件：Gallery 页 + `docs/api` + 「WinUI 对照」小节
- [ ] 最小 CI：编译库 + qmltest 冒烟
- [ ] LICENSE / SemVer / 发版 checklist（交付可信）

---

## 3. 本季度建议优先级（执行序）

1. **W1 壳与 Flyout / NavigationView** — 桌面产品第一眼像「系统应用」  
2. **W2 ListView / GridView / Pips** — 数据应用刚需  
3. **W5 hello + CI** — 敢被依赖  
4. **W3 Settings / Rating / AutoSuggest** — 设置页与表单  
5. **W4 TeachingTip / CommandBar** — 打磨  

图表 / 仪表盘已超出 WinUI 默认面，**保持优势，不占用对标带宽**（除非 WinUI Gallery 场景需要）。

---

## 4. 验收标准（对标完成定义）

对每个标为「要做」的 WinUI 控件：

1. Gallery 有可点示例（含键盘路径）  
2. `docs/api/Md3Xxx.md` 有属性表 + **WinUI 对照名**  
3. 焦点 / Esc / 读屏名不低于现有 Md3 控件基线  
4. 不强制视觉 Fluent；交互语义可对照 WinUI 文档  

整库「WinUI 桌面高频对齐」完成线：

- [ ] W1–W4 主控件全 `[x]` 或明确 `[ ] 不做`  
- [ ] Gallery 导航可按 WinUI 分类浏览  
- [ ] 对外 quickstart + 冒烟 CI 绿灯  

---

## 5. 变更记录

| 日期 | 说明 |
|------|------|
| 2026-07-31 | 废除旧「专业库堆栈」TODO；改为 WinUI 3 能力对标稿 |

参考：

- [Windows controls and patterns](https://learn.microsoft.com/windows/apps/design/controls/)  
- [WinUI 3](https://learn.microsoft.com/windows/apps/winui/winui3/)  
- [WinUI Gallery](https://github.com/microsoft/WinUI-Gallery)
