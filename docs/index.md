# QML MD3 文档

Material Design 3 组件库（Qt Quick / QML）。站点：[QML_MD3_Document](https://wuyijing-dev.github.io/QML_MD3_Document/)。

文档按用途分目录（不再堆在 `docs/` 根下）：

| 目录 | 内容 |
|------|------|
| [`getting-started/`](getting-started/quickstart.md) | 快速开始、集成、打包、API 契约、发版清单 |
| [`guides/`](guides/design-guidelines.md) | 设计与模式 |
| [`topics/`](topics/a11y.md) | 性能 / 无障碍 / i18n 等专题 |
| [`api/`](api/README.md) · [`api-manual/`](api-manual/README.md) | 控件 API（生成表 + 手写附录） |
| [`project/`](project/professional-todo.md) | 生产 TODO、发行说明（维护用） |

许可：开源 **LGPL-3.0** 或 **商业许可 / 认证** — 见 [licensing](licensing.md)。

## 入门

- [快速开始](getting-started/quickstart.md)
- [集成](getting-started/integration.md)
- [打包](getting-started/packaging.md)
- [API 稳定性](getting-started/api-stability.md)
- [发版清单](getting-started/release-checklist.md)
- [许可与认证](licensing.md)

## 设计与模式

- [设计指南](guides/design-guidelines.md) · [按钮与命令](guides/buttons-commands.md) · [集合与列表](guides/collections.md)
- [布局](guides/layout.md) · [窗口外观（自适应）](guides/window-appearance.md) · [少写胶水](guides/glue-less-api.md) · [反馈层级](guides/feedback.md)
- [模块边界](guides/module-boundaries.md) · [令牌](guides/tokens.md)

## 专题

- [性能](topics/performance.md) · [无障碍](topics/a11y.md) · [无障碍抽检](topics/a11y-spotcheck.md) · [国际化](topics/i18n.md)
- [DataTable](topics/datatable.md) · [深链](topics/routing.md) · [多文档](topics/multi-document.md) · [托盘](topics/tray.md) · [原生平台](topics/native-platforms.md) · [NativeShell](api-manual/Md3NativeShell.md)
- [校验](topics/validation.md) · [更新安全](topics/release-updater.md)
- [Qt 版本矩阵](topics/qt-version-matrix.md) · [WebAssembly](topics/wasm.md) · [实验性 API](topics/experimental.md)
- [消费方 Main.qml](topics/consumer-app-main-qml.md) · [文档托管](topics/mkdocs-hosting.md)

## API

- [控件 API 索引](api/README.md)（`python tools/gen_api_docs.py`；手写附录在 [api-manual/](api-manual/)）
- [**v1.1.1 宿主锁说明**](api-manual/host-lock-1.1.1.md)（C++ / PySide / Rust 能力边界）

## 维护

- [生产 TODO](project/professional-todo.md)
