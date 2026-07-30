# QML MD3 — 专业组件库完整 TODO

> 目标：让外部团队敢在生产桌面应用里依赖 `Md3`。  
> 原则：**可测、可版本、可接入、默认可访问、性能有承诺** —— 优先于继续堆炫技控件。  
> 勾选约定：`- [ ]` 未做 · `- [x]` 已完成（请随进度改本文件）。

**当前基线（已有）**

- [x] 较大 MD3 / 桌面控件面 + Gallery
- [x] `docs/api` 一控件一页 + `scripts/gen_api_docs.py`
- [x] 打包脚本 / `find_package(Md3)` / `docs/packaging.md` / `docs/integration.md`
- [x] 主题 token、动效、特效等级、部分 a11y 开关
- [x] `CHANGELOG.md` · 版本号 `1.0.0`

---

## P0 — 可信任交付（没有这些不算专业库）

### 0.1 法律与治理

- [ ] 根目录增加明确 `LICENSE`（MIT / Apache-2.0 等，与团队一致）
- [ ] `NOTICE` 或 `THIRD_PARTY.md`：Material Icons、HarmonyOS 字体等授权与归属
- [ ] `CONTRIBUTING.md`：分支、提交、PR、文档/测试最低要求
- [ ] `CODE_OF_CONDUCT.md`（开源协作时）
- [ ] `.github/ISSUE_TEMPLATE`（bug / feature）
- [ ] `.github/PULL_REQUEST_TEMPLATE.md`
- [ ] `SECURITY.md`：漏洞报告渠道

### 0.2 版本与 API 契约

- [ ] 书面 **SemVer** 政策（`docs/versioning.md`）：何为 breaking / minor / patch
- [ ] 标注 **Stable vs Experimental** API（文档页顶栏或属性表徽章）
- [ ] 破坏性变更必须：`CHANGELOG` + `docs/migration/vX.md` + Gallery 对照
- [ ] 发版 checklist（`docs/release-checklist.md`）：测、包、tag、Release 资产、checksum
- [ ] GitHub Release 固定产物结构（Win/Linux shared+static zip、SHA256）
- [ ] 包内 `Md3ConfigVersion.cmake` 与 `CHANGELOG` / 应用 `aboutVersion` 同源

### 0.3 CI / 自动化质量门

- [ ] GitHub Actions：Windows + Linux
- [ ] 固定 Qt 版本矩阵（至少 6.8 LTS 或你们声明的最低版 + 开发版 6.10）
- [ ] PR 必跑：configure + build library（`MD3_BUILD_GALLERY=OFF` 与 ON 各一）
- [ ] PR 必跑：`qmltestrunner` / CTest 冒烟
- [ ] PR 可选：`clang-format` / `qmllint`（有白名单）
- [ ] main 保护：禁止直推；Require CI green
- [ ] Release workflow：打 tag 自动打包上传

### 0.4 自动化测试（从 0 到可回归）

- [ ] `tests/` CMake + CTest 接入
- [ ] 冒烟：`Md3Theme` applySeed / dark / effectsLevel
- [ ] 冒烟：Button / TextField / Switch / Checkbox / Dialog 创建与关键信号
- [ ] 冒烟：`Md3ApplicationWindow` + PageHost 切页不崩溃
- [ ] 控件属性默认值快照（防无意改默认）
- [ ] 键盘：Tab 焦点环、Enter/Space 激活（核心按钮类）
- [ ] 图表：Live 启停、`paused`、特效等级下仍能 advance
- [ ] 视觉基线：Gallery 关键页截图（`tests/baselines`，允许阈值阈值）
- [ ] 性能烟雾：Charts 页 N 秒 CPU/帧时间阈值（或录制指标 JSON）

---

## P1 — 默认可访问与国际化

### 1.1 Accessibility

- [x] 可交互控件强制：`Accessible.name` / `role` / `checkable|checked` 等
- [x] Gallery「无障碍审计」页：列出缺失 Accessible 的实例
- [x] 脚本或测试：扫 QML 中可点击 Item 无 Accessible 的情况
- [x] 焦点：`Md3FocusRing` 在键盘导航路径全覆盖
- [x] 对话框 / 菜单：焦点陷阱与 Esc 关闭一致
- [x] 读屏：`Md3Accessibility.announce` 用于错误/成功反馈有约定
- [x] 高对比 / 减弱动效：写入验收用例（Theme 页 + 自动化）
- [x] 文档：每个控件「键盘操作」小节（`docs/a11y.md`）

### 1.2 i18n

- [x] 全库用户可见字符串 `qsTr` 覆盖率检查脚本
- [x] 提供示例 `md3_zh_CN.ts` / `md3_en.ts` 与加载说明
- [x] Gallery 语言切换演示
- [x] RTL（若目标市场需要）：镜像布局抽查清单

---

## P2 — 性能与平台承诺

### 2.1 性能

- [ ] `docs/performance.md` 增加「官方推荐配置」表（弱机/办公/高刷）
- [x] 首启：空壳出窗 → 再暖页（已有方向）写成可复用 API / 文档样例
- [x] 默认 **启用 qmlcachegen**（`-DMD3_QML_CACHEGEN=OFF` 可关，便于狂改 QML）
- [ ] Charts：Live/Wave 默认档位与 CPU 预算文档化
- [ ] Rail：拖动时禁止 hover 预编译（已部分做）补测试防回归
- [ ] 大列表：强制推荐 `Md3VirtualList`；禁止层叠 `layer.enabled` 的检查清单
- [ ] 性能面板指标导出（便于 CI 对比）

### 2.2 平台矩阵

- [ ] 官方支持矩阵表（README）：OS × Qt × 编译器 × shared/static
- [ ] Windows 10/11 打包与运行冒烟
- [ ] Linux（至少一种主流桌面）打包与运行冒烟
- [ ] macOS（若宣称桌面库跨平台）：窗口/标题栏能力差异文档
- [ ] HiDPI / 混合 DPI 抽查清单
- [ ] Wayland vs X11 已知限制（窗口特效、模糊）集中到 `docs/platform-notes.md`

---

## P3 — 消费方体验（别人怎么用你）

### 3.1 接入

- [ ] 官方最小示例仓库或 `examples/hello-md3/`（`find_package` + 一窗三控件）
- [ ] 5 分钟教程：`docs/quickstart.md`（安装 → Hello → 主题 → 切暗色）
- [ ] 常见失败页：`consumer-app-main-qml` 已有，扩成 FAQ
- [ ] CMake 预设：`CMakePresets.json`（dev / release / package）
- [ ] 版本探测：`Md3.version` 或 C++ `MD3_VERSION_*` 宏公开

### 3.2 设计与模式

- [ ] `docs/design-guidelines.md`：变体选用、密度、桌面间距、何时用 Sheet/Dialog
- [ ] 表单模式：校验、错误展示、提交禁用统一（`Md3Form` 增强 + 文档）
- [ ] 空态 / 加载 / 错误态：组件 + Gallery「模式」页
- [ ] 快捷键与命令面板约定（Gallery 已有雏形 → 抽成指南）
- [ ] 密度 token（comfortable / compact）若桌面要专业级

### 3.3 文档站点（可选但专业）

- [ ] 静态文档站（MkDocs / VitePress）托管 API + 指南
- [ ] 控件页：属性表 + 可运行片段截图 / 视频
- [ ] 搜索 API
- [ ] 中英至少一种完整；另一种摘要也可

---

## P4 — 组件面补齐（桌面专业，而非炫技）

> 只列「生产桌面高频缺口」。图表/液态玻璃已够用则降优先。

### 4.1 数据与表单

- [ ] 统一校验 API（`error` / `supportingText` / `aria` 约定）
- [ ] DataTable：列宽持久化、导出钩子、大数据虚拟化文档
- [ ] TreeView：无障碍树角色与键盘展开
- [ ] 日期时间：本地化格式、键盘输入校验补强
- [ ] 文件/路径：权限失败 UX 统一

### 4.2 导航与窗口

- [ ] PageHost：深链 / URL 路由可选层（文档化）
- [ ] 多窗口 / 多文档：标签撕裂策略文档与稳定 API
- [ ] 系统菜单 / 托盘（若桌面产品需要）评估是否入库

### 4.3 反馈与系统

- [ ] Toast / Snackbar / Dialog 层级与焦点规范一页说清
- [ ] 通知与 `Md3Notify` 与系统通知边界
- [ ] `Md3ReleaseUpdater`：签名校验、增量策略文档（安全）

### 4.4 明确不做 / 实验区

- [ ] `docs/experimental.md`：液态玻璃、部分图表交互标 Experimental
- [ ] 避免无测试、无文档的新控件合入 main

---

## P5 — 工程卫生

- [ ] 根目录清理：忽略 `build*` / 大二进制；Release 不进 git
- [ ] `qmllint` / 静态检查进 CI
- [ ] API 文档 CI：改 QML 未跑 `gen_api_docs` 则失败或自动提交策略
- [ ] 依赖锁定：文档写死 Qt 最低小版本
- [ ] 内部模块边界：foundation / primitives / components / charts / window 依赖图
- [ ] 公共头文件与私有实现分离（C++ 部分）
- [ ] 日志：库内 `qCDebug(md3)` 分类，默认安静

---

## P6 — 社区与产品化（开源或商业）

- [ ] README 徽章：CI、License、Qt 版本、Latest Release
- [ ] 路线图公开（可链本文件）
- [ ] 示例应用截图 / 短视频（Gallery）
- [ ] 若商业：支持分级、SLA、私有镜像说明
- [ ] 若开源：Good First Issue 标签与组件认领

---

## 建议执行顺序（90 天）

| 阶段 | 周期 | 交付 |
|------|------|------|
| **A** | 第 1–2 周 | License、THIRD_PARTY、SemVer 文档、发版 checklist、最小 CI 编译 |
| **B** | 第 3–5 周 | qmltest 冒烟套件、核心 a11y 扫漏、examples/hello |
| **C** | 第 6–8 周 | Release 自动打包、cachegen Release、性能/支持矩阵文档 |
| **D** | 第 9–12 周 | 表单/空态模式、文档站或 MkDocs、迁移指南、视觉基线 |

---

## 完成定义（Definition of Done）

一个「专业版本」至少同时满足：

1. 外部项目 `find_package(Md3)` + Hello 示例 **10 分钟内跑通**  
2. CI 在声明的平台矩阵上 **绿**  
3. 核心控件有 **自动化测试** + API 文档与实现同步  
4. **License / 第三方声明** 齐全  
5. 破坏性变更有 **migration**；Release 有 **可下载产物与校验**  
6. a11y 与性能有 **可执行的验收条目**，不是口号  

---

## 维护

- 本文件路径：`docs/professional-todo.md`
- 大项完成后在 `CHANGELOG` 记一笔「工程化」
- README「Docs」应链接本文
