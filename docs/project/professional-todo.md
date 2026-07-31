# QML MD3 — 生产可用 TODO（摘要）

> 完整历史矩阵已收敛；此处只保留**下一步优先项**。

**基线：** 2026-07-31 · tag `v1.0.0` · WASM experimental 已可配置编译 hello-md3

## 下一步（建议序）

1. [x] **WASM**：CMake 识别 Emscripten、mobile stub、文档；hello-md3 可编
2. [x] **`Md3NavigationView`**：Auto / Left / LeftCompact / Top
3. [ ] **`Md3Flyout`**：锚定、light-dismiss、Esc、焦点归还
4. [ ] a11y 人工抽检（`docs/topics/a11y-spotcheck.md`）+ IconButton 微动效
5. [ ] VirtualList / DataTable 性能冒烟场景

## 壳层对照

| 状态 | 项 |
|------|----|
| 已有 | Rail / Drawer / Bar / Scaffold / **NavigationView** |
| 缺口 | Flyout、TitleBar 内容槽示例 |

参考：[wasm.md](../topics/wasm.md) · [quickstart](../getting-started/quickstart.md)
