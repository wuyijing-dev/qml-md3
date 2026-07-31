# QML MD3 — 生产可用 TODO

> **目标：** 让外部团队敢在真实桌面产品里 `find_package(Md3)` 并长期依赖。  
> **视觉：** Material Design 3；WinUI 仅作能力对照，不是 Fluent 换皮。  
> **判断：** 控件覆盖面已够多数业务；**卡生产的是工程可信度、壳层体验、契约与平台验证**，不是再堆 Chart/Gauge。  
> 勾选：`- [ ]` 未做 · `- [x]` 已具备 · `- [~]` 部分具备 · `- [!]` 明确不做

**基线：** 2026-07-31 · 声明版本 `1.0.0`（契约与 CI 未齐前，对外仍按「准 1.0」沟通）

---

## 0. 生产判断（先看这段）

| 维度 | 现状 | 进生产还要什么 |
|------|------|----------------|
| 控件广度 | 按钮/表单/表/树/壳/反馈/集合已齐 | 少补壳层一体控件即可 |
| 工程可信 | 几乎无编译 CI、无 qmltest | **P0：CI + hello 样例** |
| 法律/发版 | CHANGELOG 有；**无根目录 LICENSE** | **P0：许可证 + 发版 checklist** |
| API 契约 | 生成文档全；破坏性变更无流程 | **P0：公开 API / SemVer 规则** |
| 平台 | 文档矩阵有；CI 未钉死 | **P1：Win + 一另平台绿灯** |
| 无障碍 | 约定文档有；无审计清单勾选 | **P1：核心路径键盘/读屏抽检** |
| 性能 | 有指南；无回归门禁 | **P1：VirtualList/DataTable 冒烟预算** |
| WinUI 剩余 | NavigationView / Flyout / Settings… | **P2：按产品壳需求补，不阻塞打包发版** |

**结论：** 内部工具 / 自研桌面 App 现在就能用；要「对外可依赖的库」，优先把下面 **P0** 做完，再谈更多控件。

---

## 1. P0 — 没有这些，不敢说「生产库」（1–2 周）

### 1.1 法律与发版

- [ ] 根目录 **`LICENSE`**（建议 MIT 或与 Qt 消费方友好的许可证；写清字体/图标二次许可）
- [ ] **`NOTICE` / 第三方归因**（Material Icons、若有 KF 等）
- [ ] 发版 checklist：`CHANGELOG` 条目、版本号、`find_package` 安装包、Gallery 冒烟、文档站同步
- [ ] README「支持范围」：Qt 最低版本、官方仅保证的 OS、实验 API 指向 `docs/experimental.md`

### 1.2 消费方证明

- [ ] **`examples/hello-md3`**：干净工程 `find_package(Md3)` → 一窗 + Theme + Button + Dialog
- [ ] 文档一条龙：从 zip/`dist/Md3` 到跑起来 ≤ 10 分钟（Windows 为主，附 Linux）
- [ ] 明确 **static vs shared** 推荐默认（与 `docs/packaging.md` 一致，加故障对照）

### 1.3 CI 与测试底线

- [ ] GitHub Actions：**配置 + 编译库**（至少 Windows 或 Linux 一条；Gallery 可选矩阵）
- [ ] **qmltest / 冒烟**：Theme 单例、Button 点击、Dialog Esc、PageHost 推页（5–15 个用例即可）
- [ ] PR 门禁：编译失败不可合；文档-only 可跳过重构建（可选）
- [ ] `tests/baselines`：选定 3–5 个控件做视觉基线流程（可先手工，后自动化）

### 1.4 API 契约

- [ ] 文档页：**Public vs Private**（`private/`、playground、实验件不进 SemVer 承诺）
- [ ] SemVer 规则：何为 breaking（删属性 / 改枚举序 / 改默认交互）
- [ ] 弃用策略：`/// @deprecated` + Gallery 警告 + 至少一个次版本过渡
- [ ] `1.0.0` 真正 tag：上述 P0 勾完再打；在此之前 CHANGELOG 标 Pre-production

---

## 2. P1 — 真产品会踩的坑（2–4 周）

### 2.1 桌面壳（用户第一眼）

- [ ] **`Md3NavigationView`**（或 Scaffold 增强）：`paneDisplayMode` Left / LeftCompact / Top；断点自动折叠
- [ ] **`Md3Flyout`**：锚定、light-dismiss、Esc、焦点归还（别再只靠 Menu/SideSheet 拼）
- [ ] TitleBar **内容槽**官方示例（搜索、账号）
- [ ] Gallery：Navigation / Window 信息架构一页说清

### 2.2 无障碍与键盘

- [ ] 核心路径抽检表：Dialog、Menu、Select、DataTable、ListView、CommandBar、PageHost
- [ ] 每条：Tab 序、Esc、Enter/Space、`Accessible.name` 非空
- [ ] `reduceMotion` / `highContrast` Gallery 开关演示 + 回归勾选

### 2.3 性能与大数据

- [ ] VirtualList **5k+**、DataTable **分页/冻结列** Gallery 固定场景 + 文档预算（见 `performance.md`）
- [ ] Overlay/Menu 泄漏与重复 `popup` 压力：开关 100 次不涨句柄（手工或脚本）
- [ ] 默认 Gallery「无感打开」配置写入消费方推荐（已有 Profile F，升格为 integration 默认建议）

### 2.4 国际化与主题

- [ ] 库内 `qsTr` 覆盖审计；至少 **en + zh_CN** 打包进模块
- [ ] 动态换肤 / 种子色切换：无闪白、无丢弹层宿主
- [ ] 高 DPI / 混缩放：Win11 125%–150% 抽检 TitleBar 与焦点环

### 2.5 平台

- [ ] CI 或发布前清单：**Windows**（主）+ **Linux 或 macOS** 至少一端编译通过
- [ ] `docs/qt-version-matrix.md` 与 CI kit 对齐（钉死「官方支持 = 6.8+」若 5.15 仅 bootstrap）

---

## 3. P2 — 产品完整度（按业务选做）

### 3.1 输入与设置

- [ ] AutoSuggest 统一信号（`querySubmitted` / `suggestionChosen`）
- [ ] `Md3Rating`
- [ ] `Md3SettingsSection` / SettingsExpander 模式
- [ ] NumberField spin + validation mode 文档化
- [ ] CalendarView 多选（若日历产品需要）
- [ ] Select **editable** Combo 模式

### 3.2 反馈与教学

- [ ] `Md3TeachingTip`（单点锚定；与 Tour/InfoBar 分层写进 `feedback.md`）
- [ ] CommandBarFlyout（选区工具条，可后置）

### 3.3 集合增强（可选）

- [ ] TreeView 拖放排序 / 多列树
- [ ] ItemsView waterfall
- [ ] ListView 与 Swipe 更紧的合成示例（Gallery 场景页）

### 3.4 明确不做 / 边界文档

- [!] SemanticZoom
- [!] WebView2 / Ink / Map 入库
- [ ] `docs` 增加 **「库边界」**：媒体、浏览器、地图由消费方自嵌；图表为增值非 WinUI 对等物

---

## 4. P3 — 锦上添花（不阻塞发版）

- [ ] Gallery 按 Basics / Collections / Dialogs / Navigation 重排
- [ ] 每控件 API 页统一「WinUI 对照」附录（`api-manual` 继续扩）
- [ ] 视觉回归 CI（baselines PNG）
- [ ] 设计令牌导出（JSON / CSS 变量）供非 Qt 设计稿对齐
- [ ] 贡献指南 `CONTRIBUTING.md`（qmllint、文档生成、提交约定）

---

## 5. WinUI 能力快照（已齐 / 剩余）

> 详细矩阵历史见 Git；此处只保留**还影响生产壳**的剩余项。

| 状态 | 项 |
|------|----|
| 已齐（可依赖） | Button 族、CommandBar、表单主控件、List/Grid/Items、Carousel Flip、Pips、Swipe、PTR、AnnotatedScrollbar、DataTable 编辑、Tree、Tab/多窗、Dialog/Menu/InfoBar… |
| 壳层缺口 | NavigationView 一体、Flyout、TitleBar 内容槽示例 |
| 设置/表单缺口 | AutoSuggest 统一 API、Settings 分区、Rating |
| 不做 | SemanticZoom、WebView2、Ink、Map |

路线图遗留（原 W1–W5）并入上文 P0–P2，不再单独按「对标周」排期。

---

## 6. 建议执行序（若只做一件事）

1. **LICENSE + hello-md3 + 编译 CI**（本周就能提升「敢用」指数）  
2. **qmltest 冒烟 + Public API 说明**  
3. **NavigationView + Flyout**（桌面产品观感）  
4. **a11y 抽检 + 性能冒烟场景**  
5. 再按产品需要补 Settings / AutoSuggest / TeachingTip  

图表与仪表盘：**保持优势，不占生产带宽**。

---

## 7. 「生产可用」完成定义

对外可以说 **Production-ready 1.0** 当且仅当：

- [ ] P0 全部勾选（许可证、hello、CI 编译、冒烟测试、SemVer/公开 API 说明、正式 tag）
- [ ] P1 壳层至少 **Flyout 或 NavigationView 其一** 可用，TitleBar 示例可抄
- [ ] Windows 上 hello-md3 与 Gallery 核心页无已知 blocker
- [ ] 文档站 / `docs/integration.md` 与安装包路径一致

未满足前：README 使用 **「可用 / 准生产」** 措辞，避免「稳定 1.0 全平台保证」。

---

## 8. 变更记录

| 日期 | 说明 |
|------|------|
| 2026-07-31 | **改为生产可用视角**：P0 工程契约优先；WinUI 剩余降为 P2；保留壳层为 P1 |
| 2026-07-31 | 集合面：ListView/GridView/ItemsView/Pips/Swipe/PTR + DataTable 就地编辑 |
| 2026-07-31 | 按钮/命令条文档与 api-manual |
| 2026-07-31 | 初版 WinUI 3 能力对标稿 |

参考：

- [docs/integration.md](integration.md) · [docs/packaging.md](packaging.md) · [docs/performance.md](performance.md) · [docs/a11y.md](a11y.md)
- [WinUI 3](https://learn.microsoft.com/windows/apps/winui/winui3/)（能力对照，非视觉规范）
