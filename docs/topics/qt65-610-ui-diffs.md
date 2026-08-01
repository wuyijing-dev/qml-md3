# Qt 6.5 / 6.8 / 6.10 UI 差异备忘（编写指南）

面向 Md3 组件作者：把 **会改变像素结果** 的差异集中在这里。策略始终是 **一套严格语义（以 6.8 Column 行为为基准）+ C++ 规定**，而不是在 QML 里写 `if (Qt.version…)`。

配套实现：`Md3QtCompat` / `Md3HeightSync`（C++），见 [Md3QtCompat.md](../api-manual/Md3QtCompat.md)、[qt-version-matrix.md](qt-version-matrix.md)。

官方来源：[What's new 6.5](https://doc.qt.io/qt-6.5/whatsnew65.html) · [6.8](https://doc.qt.io/qt-6.8/whatsnew68.html) · [6.10](https://doc.qt.io/qt-6.10/whatsnew610.html)

---

## 1. 布局几何（最容易踩坑）

| 现象 | 涉及版本 | Md3 规定 |
|------|----------|----------|
| `Column` / `Row` 按子项 **`height`/`width` 占位**；`height: 0` 且仅有 `implicitHeight` 时行会塌缩、重叠 | 全线皆然；**6.8 Gallery 上最先暴露** | 布局壳用 `Md3HeightSync`（`AtLeastImplicit`）；控件保证真实 `height` |
| `Flickable.contentHeight: col.height` 在 col 高度为 0 时整页不可滚 | 全线 | 优先 `contentHeight: col.implicitHeight`（或 `childrenRect`） |
| `ColumnLayout` / `RowLayout` **禁止**绑定子项 `x/y/width/height` | 全线文档约束 | 用 `Layout.preferred*` / `implicit*`；Md3 自有壳用手动布局 |
| `Layout.horizontalStretchFactor` / `verticalStretchFactor` | **≥ 6.5** | 可用；勿在 6.5 假定不存在 |
| `Layout.useDefaultSizePolicy`（`SizePolicyImplicit` / `Explicit`） | **≥ 6.8** | **不要**在公共 API 依赖；需要时走 C++/feature 探测或仅 Gallery 6.8+ 演示 |
| `AA_QtQuickUseDefaultSizePolicy` 应用属性 | **≥ 6.8** | 默认不改；改了会让 Controls/Layout 默认尺寸策略整体偏移 |
| nested VStack `height: 0`、HStack 用 `height` 测子项 → 横排重叠 | 全线 | `Md3QtCompat.preferredHeight` = `max(h, ih)` |
| Card `bodySlot` + `anchors.fill` → fill 子项高度 0、上下锚点叠在一起 | 6.8 严格路径 | `Md3HeightSync.Exact` + `expand`；Card 根用 `AtLeastImplicit`（勿 `height: implicitHeight`，会盖掉显式高度） |
| DataTable `height` ↔ `bodyHeight` 绑定环 | 6.8 易炸；6.10 可能“看起来没事” | **禁止**互绑；用 `_resolvedBodyHeight`；根 `AtLeastImplicit` 仅抬升未设高度 |
| HStack `height: implicitHeight` 与 `anchors.fill` 互殴 | 6.8/6.10 | `Binding when: !anchors.fill` + `AtLeastImplicit`（对齐 VStack） |
| `Row` 上手动改 `y`/`height` → polish 环警告 | 全线 | `Md3HStack` 用 `Item` 手摆；Card header 用 `Md3HStack` + `expand` 标题列 |

**编写口诀**

1. 给 Column/Flickable 吃的是 **height**，不是“只有 implicit”。
2. 测量兄弟用 **`preferredHeight/Width`**，不要只读 `height`。
3. 新 API 若标了 `since 6.8/6.9/6.10`，公共组件默认路径 **不许依赖**；可选增强放在 C++ `#if MD3_QT_AT_LEAST_*` 或文档化实验页。

---

## 2. 文本与字体（影响行高 / 中英混排）

| API / 行为 | 引入 | 影响 | Md3 建议 |
|------------|------|------|----------|
| `font.contextFontMerging` / `QFont::ContextFontMerging` | **6.8** | 回落字体按整串选，混排更稳，可能更贵 | 默认勿在组件里强制；需要统一时在 `Md3::initialize` / 主题层用 C++ 设 |
| `font.preferTypoLineMetrics` / `PreferTypoLineMetrics` | **6.8** | OpenType 行距可能变，**implicitHeight 会变** | 同一产品线要么全开要么全关；改则全 kit 回归行高 |
| `QFontDatabase::addApplicationFallbackFontFamily` | **6.8** | Han/脚本回落 | 已在 `md3.cpp` 用 `MD3_QT_AT_LEAST_68` |
| `font.features` | 6.6 | OpenType features | 可用（最低 6.5 时勿依赖 6.6-only 路径除非探测） |
| `font.variableAxes` | 6.7 | 可变字体轴 | 同上 |
| Windows DirectWrite 默认字体引擎 | **6.8 Windows** | 字形/度量与旧 GDI 不同 | CI 应用 6.8+ Windows 看真字；勿假设 6.5 GDI 像素一致 |

---

## 3. 效果 / Shapes / 视觉模块

| 项 | 6.5 | 6.8 | 6.10 | Md3 |
|----|-----|-----|------|-----|
| `QtQuick.Effects` / MultiEffect | 模块落地 | 继续 | 继续 | CMake：优先 `Qt6::QuickEffects`，否则 `QuickEffectsPrivate` |
| `QtQuick.Shapes` 链接目标 | 常为 Private | 常为 Private | 常有 public `QuickShapes`（部分 kit 仍 Private） | 同上，统一链接解析 |
| Graphical Effects（Qt5 风格） | 已淘汰 | 已淘汰 | 已淘汰 | 只用 MultiEffect / 自研 shader |
| VectorImage / svgtoqml | — | **6.8** 正式向 | 继续；**6.10** Lottie→QML TP | Gallery 可选，库核心不依赖 |

---

## 4. Controls / 窗口 / 安全区

| 项 | 版本 | 说明 | Md3 |
|----|------|------|-----|
| Material 3 风格大改（官方 Material style） | **6.5** | Button/TextField/Dialog 等视觉更新 | Md3 **自绘**，不受官方 Material 换皮影响；勿混用两套视觉预期 |
| Controls.impl 类型不再“意外可见” | **6.8** | 不能再靠 `import Controls` 摸到 PaddedRectangle 等 | 禁止依赖 impl |
| `SearchField` | **6.10** | 官方控件 | 勿在 Md3 公共 API 直接依赖；可用自有 TextField |
| `SafeArea` attached / `Qt.ExpandedClientAreaHint` | **6.9+**（文档 6.10 常见） | 扩展客户区 + 安全边距 | **6.5/6.8 无此 API**；窗口边距继续用 `Md3Adaptive` / 平台 chrome，6.10 增强另开 feature gate |
| FluentWinUI3 对比度 | **6.10** | 官方风格 | 与 Md3 无关 |
| `loadFromModule(uri, type)` | **6.5+** | 模块加载 | C++/Python 宿主已用 |

---

## 5. 模型 / 视图（列表与表格）

| 项 | 版本 | 说明 | Md3 |
|----|------|------|-----|
| TableView 编辑代理、行列拖拽缩放、多选、`layoutChanged` | **6.5** | 表格交互增强 | DataTable 若包 TableView，行为以 6.5 为底线测试 |
| TableView 行列程序化/交互移动 | **6.8** | 再增强 | 可选 |
| `TreeModel` / `SortFilterProxyModel`（QML） | **6.10**（部分 TP） | 便利模型 | 公共组件勿硬依赖 TP 类型 |
| `FlexboxLayout` | **6.10** TP | CSS flex 风布局 | **禁止**进 Md3 公共布局；继续 VStack/HStack/Grid |
| `Synchronizer` | **6.10** TP | 无绑定属性同步 | 实验页可用 |

---

## 6. 构建 / 模块发现（间接影响 UI 是否加载对）

| Policy | 引入 | NEW 行为 | Md3 |
|--------|------|----------|-----|
| **QTP0001** | 6.5 | 资源前缀 `:/qt/qml/` | 已 `qt_policy NEW` |
| **QTP0004** | **6.8** | 子目录额外 qmldir，隐式 import=模块 | 已 NEW；子目录组件互见 |
| **QTP0005** | 6.8 | DEPENDENCIES 可用 target | 已处理 |

忘记设 QTP0004 时：6.8+ 告警，且子目录 QML **看不见** 兄弟类型 → 运行期“控件丢失/回落成 Item”，看起来像 UI bug。

---

## 7. 编写清单（新组件 / 改布局时）

- [ ] 在 **Column / Flickable** 链路中：根与中间壳有真实 `height`（或挂了 `Md3HeightSync`）
- [ ] 子项测量用 `Md3QtCompat.preferredHeight/Width`，不假设 `height === implicitHeight`
- [ ] 不用 `Layout.useDefaultSizePolicy`、`SafeArea`、`FlexboxLayout`、`SearchField` 作为 **6.5 基线** 路径
- [ ] 字体策略（TypoLineMetrics / ContextFontMerging）只在 C++ 主题入口统一开关
- [ ] Effects/Shapes 不写死 public 或 Private CMake 名
- [ ] 在 **6.5 + 6.8 + 6.10** 各跑一次 Gallery 相关页（至少 Containment / Card / DataTable / 文本）
- [ ] 禁止 `if (qtMinor >= 8)` 改变布局几何；差异进 C++ `Md3QtCompat` / `MD3_QT_AT_LEAST_*`

---

## 8. 版本 → 能力速查（UI 相关）

| 能力 | 6.5 | 6.8 | 6.10 |
|------|-----|-----|------|
| stretchFactor on Layout | ✓ | ✓ | ✓ |
| useDefaultSizePolicy | — | ✓ | ✓ |
| contextFontMerging / preferTypoLineMetrics | — | ✓ | ✓ |
| addApplicationFallbackFontFamily | — | ✓ | ✓ |
| MultiEffect 模块 | ✓ | ✓ | ✓ |
| QTP0004 子目录 qmldir | 警告/无 | ✓ | ✓ |
| SafeArea / ExpandedClientArea | — | — | ✓*（自 6.9） |
| SearchField / FlexboxLayout / TreeModel QML | — | — | ✓ / TP |
| QuickEffects **public** CMake 目标 | 少见 | 少见 | 常见 |

\*6.9 引入；以安装的 6.10 kit 为准。
