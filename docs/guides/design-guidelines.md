# 设计与交互模式指南

面向桌面 Qt Quick 应用的选用约定。细节 API 见 [api/README.md](../api/README.md)；反馈控件分工见 [feedback.md](feedback.md)。

## 控件变体选用

| 场景 | 推荐 | 避免 |
|------|------|------|
| 页内主操作（唯一） | `Md3Button` **Filled** | 同一行多个 Filled |
| 次要 / 并行操作 | **Outlined** 或 **Text** | 与 Filled 同等视觉权重 |
| 开关状态（文案） | `Md3ToggleButton` | 普通 Button 自管 checked |
| 工具栏图标操作 | `Md3IconButton` / `Md3ToggleIconButton` | 长文案塞进 IconButton |
| 整钮菜单 / 主操作+菜单 | `Md3DropDownButton` / `Md3SplitButton` | 两个按钮硬拼 |
| 行内链接 | `Md3Hyperlink` | Text Button 冒充链接 |
| 窗顶命令条（含溢出） | `Md3CommandBar` + `Md3AppBarButton` | 次要命令全堆主栏 |
| 窗顶简单自定义条 | `Md3AppToolBar` | 需要 Secondary/overflow 仍用它 |
| 列表行操作 | Text / Icon，或行尾 `Md3IconButton` | 行内大 Filled |
| 悬浮主创建 | `Md3Fab` / `Md3ExtendedFab` | 一页多个 FAB |
| 筛选 / 选择标签 | `Md3FilterChip` / `Md3AssistChip` | 用 Button 冒充 Chip |
| 危险操作 | 文案明确 + 确认 Dialog；按钮可用 error 色容器 | 仅靠红色图标无确认 |

同一视觉层级只保留 **一个** 高强调按钮。按钮族详细对照见 [buttons-commands.md](buttons-commands.md)。

## 密度与桌面间距

全局：`Md3Theme.density`（`0` 舒适 / `1` 紧凑）与 `Md3DataTable.Density` 对齐。

| Token | Comfortable | Compact | 用途 |
|-------|-------------|---------|------|
| `spacingXs` | 4 | 4 | 紧邻图标与标签 |
| `spacingSm` | 8 | 6 | 同行控件 |
| `spacingMd` | 12 | 8 | 表单字段、小节内 |
| `spacingLg` | 16 | 12 | 相关区块 |
| `spacingXl` | 24 | 16 | 大区块分隔 |
| `pagePadding` | 20 | 12 | 页边距（可绑 `pagePadding`） |
| `controlHeight` | 40 | 36 | 控件高度提示 |
| `tableRowHeight` | 52 | 40 | 表格行提示 |

```qml
Md3Theme.setDensity(1)   // 紧凑
pagePadding: Md3Theme.pagePadding
Md3Form { spacing: Md3Theme.spacingMd }
Md3DataTable {
    density: Md3Theme.densityCompact ? Md3DataTable.Compact
                                     : Md3DataTable.Comfortable
}
```

**选用：** 触控 / 营销向 UI → 舒适；IDE、运维台、宽表 → 紧凑。不要在同一窗口混用两套密度除非分区明确（如侧栏舒适、主表紧凑）。

## Sheet vs Dialog

| 需求 | 选用 | 说明 |
|------|------|------|
| 短确认 / 双按钮决策 | `Md3Dialog` | 阻塞当前任务，Esc 关闭 |
| 系统级独立窗（可拖出主窗） | `Md3DialogWindow` | 多显示器、长期对照 |
| 自底向上的次要选项 / 移动感 | `Md3BottomSheet` | 桌面少用；选项 ≤ 一屏 |
| 详情 / 筛选 / 不离开列表上下文 | `Md3SideSheet` | 桌面首选「旁路编辑」 |
| 多步创建 / 接近整页编辑 | `Md3FullscreenDialog` | 类似「新建向导」 |
| 临时成功 / 失败一句 | Snackbar / Toast | 见 [feedback.md](feedback.md)，不要用 Dialog |

规则：能 Side Sheet 完成的不要上模态 Dialog；破坏性操作必须确认。

## 表单：校验、错误、提交禁用

约定：

1. 字段设 `name`，放入 `Md3Form`；必填列入 `requiredFields`。
2. 错误写入 `errors`（或 `setError`）→ 自动落到字段 `error` / `errorText`。
3. 主提交按钮：`enabled: form.canSubmit`（必填已填且当前无错误）。
4. 点击提交用 `form.submit()`（内部 `validate()`，成功发 `submitted(values)`），或自写 `validate()` + 业务校验后再 `setError`。

```qml
Md3Form {
    id: form
    requiredFields: ["email", "role"]
    liveGate: true   // 默认：输入时刷新 canSubmit

    Md3TextField { name: "email"; label: qsTr("Email") }
    Md3Select { name: "role"; label: qsTr("Role"); model: [...] }

    Md3Button {
        text: qsTr("Save")
        enabled: form.canSubmit
        onClicked: form.submit()
    }
    onSubmitted: (values) => { /* API */ }
}
```

自定义规则（邮箱格式等）：在 `submit` 前或 `onSubmitted` 前调用 `setError("email", qsTr("Invalid"))`，并依赖 `canSubmit` / `hasErrors`。清空用 `clearErrors()`。

Gallery：**模式**页 + **文本框**页的 Form 小节。

## 空态 / 加载 / 错误态

| 状态 | 组件 | 何时 |
|------|------|------|
| 首次无数据 | `Md3EmptyState`（图标 + 标题 + 可选操作） | 列表/表为零且非错误 |
| 页/区加载中 | `Md3Skeleton` / `Md3SkeletonPane`，或 `pageSkeleton` | 已知布局时优先骨架，而非转圈挡整页 |
| 局部忙碌 | `Md3LoadingIndicator` / Progress | 短操作、按钮旁 |
| 页级可恢复错误 | `Md3EmptyState`（error 文案 + 重试）或 `Md3Banner` | 保持页结构 |
| 全局瞬时失败 | `Md3Notify.snackbar` / InfoBar | 不打断编辑中的表单 |

不要：空列表仍渲染 0 高的表头无说明；加载失败只 `console.log`。

Gallery：**模式**页集中演示。

## 快捷键与命令面板

| 约定 | 做法 |
|------|------|
| 打开命令面板 | 默认 **Ctrl+K**（与 Gallery / 常见 IDE 一致） |
| 面板内容 | `Md3CommandPalette.model: [{ title, subtitle?, icon?, action }]` |
| 保留快捷键 | 用 `Md3KeySequenceField.reservedShortcuts` 标出 Ctrl+K、Ctrl+S 等，冲突时 `hasConflict` |
| 导航类命令 | 与 Rail/`destinations` 同源生成，避免两套入口 |
| 发现性 | 设置页列出全局 Shortcut；状态栏可提示 “Ctrl+K” |

```qml
Shortcut {
    sequence: "Ctrl+K"
    onActivated: commandPalette.open = !commandPalette.open
}
Md3CommandPalette {
    model: commandItems
    onActivated: (item) => { if (item.action) item.action() }
}
```

勿把唯一关键路径只绑在无提示的快捷键上；鼠标路径必须并存。
