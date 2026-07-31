# QML MD3 — 生产可用 TODO

> **目标：** 让外部团队敢在真实桌面产品里 `find_package(Md3)` 并长期依赖。  
> **视觉：** Material Design 3；WinUI 仅作能力对照，不是 Fluent 换皮。  
> **判断：** 控件覆盖面已够多数业务；**卡生产的是工程可信度、壳层体验、契约与平台验证**，不是再堆 Chart/Gauge。  
> 勾选：`- [ ]` 未做 · `- [x]` 已具备 · `- [~]` 部分具备 · `- [!]` 明确不做

**基线：** 2026-07-31 · **正式 tag `v1.0.0`**（发版清单已走：Windows 打包 + hello-md3）

---

## 0. 生产判断（先看这段）

| 维度 | 现状 | 进生产还要什么 |
|------|------|----------------|
| 控件广度 | 按钮/表单/表/树/壳/反馈/集合已齐 | NavigationView / Flyout 按壳需求补（不阻塞 1.0） |
| 工程可信 | Linux CI + Windows 本机打包/hello 已通 | 盯 CI 绿灯；冒烟升格为硬门禁 |
| 法律/发版 | LICENSE + NOTICE + checklist + **v1.0.0** | 后续按 SemVer 发版 |
| API 契约 | api-stability.md | 破坏性变更走大版本 |
| 平台 | Windows 本机验过；Linux CI | **P1：再钉一另平台矩阵** |
| 无障碍 | 扫描清零 + spot-check 表 | **P1：核心路径人工勾选** |
| 性能 | 有指南；无回归门禁 | **P1：VirtualList/DataTable 冒烟预算** |
| WinUI 剩余 | NavigationView / Flyout / Settings… | **P1/P2：按产品壳需求补** |

**结论：** `find_package(Md3)` + `dist/Md3` 已可对外依赖；壳层一体控件与跨平台矩阵继续按 P1 推进。

---

## 1. P0 — 没有这些，不敢说「生产库」（1–2 周）

### 1.1 法律与发版

- [x] 根目录 **`LICENSE`**（MIT）
- [x] **`NOTICE` / 第三方归因**（Material Icons、HarmonyOS Sans、Qt）
- [x] 发版 checklist：[`docs/getting-started/release-checklist.md`](../getting-started/release-checklist.md)
- [x] README「支持范围」+ 实验 API 指向 `docs/topics/experimental.md`

### 1.2 消费方证明

- [x] **`examples/hello-md3`**：`find_package` / in-tree → 一窗 + Theme + Button + Dialog
- [x] 文档一条龙：[`docs/getting-started/quickstart.md`](../getting-started/quickstart.md)
- [x] **static vs shared** 推荐默认 + 故障对照（`packaging.md`）

### 1.3 CI 与测试底线

- [x] GitHub Actions：**配置 + 编译库**（`build.yml`，Linux + Qt 6.8）
- [x] **qmltest / 冒烟**：Theme、Button、Dialog Esc、PageHost（`tests/smoke`；CI `continue-on-error` 至稳定）
- [x] PR 门禁：代码变更触发 build；纯 `docs/api` 变更可跳过
- [x] `tests/baselines`：选定 3–5 控件的手工基线流程说明

### 1.4 API 契约

- [x] 文档页：**Public vs Private** — [`api-stability.md`](../getting-started/api-stability.md)
- [x] SemVer 规则（同页）
- [x] 弃用策略（同页）
- [x] `1.0.0` **正式稳定 tag**：发版清单走完（Windows 打包 + hello-md3）

---

## 2. P1 — 真产品会踩的坑（2–4 周）

### 2.1 桌面壳（用户第一眼）

- [ ] **`Md3NavigationView`**（或 Scaffold 增强）：`paneDisplayMode` Left / LeftCompact / Top；断点自动折叠
- [ ] **`Md3Flyout`**：锚定、light-dismiss、Esc、焦点归还（别再只靠 Menu/SideSheet 拼）
- [ ] TitleBar **内容槽**官方示例（搜索、账号）
- [ ] Gallery：Navigation / Window 信息架构一页说清

### 2.2 无障碍与键盘

- [x] 核心路径抽检表：Dialog、Menu、Select、DataTable、ListView、CommandBar、PageHost — [`a11y-spotcheck.md`](../topics/a11y-spotcheck.md)
- [~] 静态扫描 `check_a11y_qml.py` 清零（启发式）；人工 Tab/Esc 勾选仍待 Gallery 过一遍
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

- [~] CI 或发布前清单：**Windows**（本机打包 + hello-md3，v1.0.0）+ **Linux CI**；macOS 仍待
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

1. ~~LICENSE + hello-md3 + 编译 CI~~（已完成并打 `v1.0.0`）
2. **NavigationView + Flyout**（桌面产品观感）
3. **a11y 人工勾选**（spot-check 表）+ 性能冒烟场景
4. 再按产品需要补 Settings / AutoSuggest / TeachingTip

图表与仪表盘：**保持优势，不占生产带宽**。

---

## 7. 「生产可用」完成定义

对外可以说 **Production-ready 1.0** 当且仅当：

- [x] P0 工程项已齐（LICENSE、hello、CI、smoke、SemVer 文档）+ **正式 tag `v1.0.0`**
- [ ] P1 壳层至少 **Flyout 或 NavigationView 其一** 可用，TitleBar 示例可抄（不阻塞已打的 1.0 库契约）
- [x] Windows 上 hello-md3 无已知 blocker（Gallery 核心页持续抽检）
- [x] 文档站 / `docs/integration.md` 与安装包路径一致

壳层缺口继续走 P1；库契约与打包路径已按 1.0 对外。

---

## 8. 变更记录

| 日期 | 说明 |
|------|------|
| 2026-07-31 | **v1.0.0**：发版清单（Win 打包 + hello）、CHANGELOG 去 pre-prod、a11y spot-check |
| 2026-07-31 | P0：LICENSE/NOTICE、hello-md3、build CI、smoke、api-stability；docs-sync 改为手动；文档索引清理 |
| 2026-07-31 | **改为生产可用视角**：P0 工程契约优先；WinUI 剩余降为 P2 |
| 2026-07-31 | 集合面：ListView/GridView/ItemsView/Pips/Swipe/PTR + DataTable 就地编辑 |
| 2026-07-31 | 按钮/命令条文档与 api-manual |
| 2026-07-31 | 初版 WinUI 3 能力对标稿 |

参考：

- [docs/integration.md](../getting-started/integration.md) · [docs/packaging.md](../getting-started/packaging.md) · [docs/performance.md](../topics/performance.md) · [docs/a11y.md](../topics/a11y.md) · [docs/a11y-spotcheck.md](../topics/a11y-spotcheck.md)
- [WinUI 3](https://learn.microsoft.com/windows/apps/winui/winui3/)（能力对照，非视觉规范）
