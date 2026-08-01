# QML MD3 — 生产可用 TODO（摘要）

> 完整历史矩阵已收敛；此处只保留**下一步优先项**。

**基线：** 2026-07-31 · tag `v1.0.0` · WASM experimental 已可配置编译 hello-md3

## 下一步（建议序）

1. [x] **WASM**：CMake 识别 Emscripten、mobile stub、文档；hello-md3 可编
2. [x] **`Md3NavigationView`**：Auto / Left / LeftCompact / Top
3. [x] **`Md3Flyout`**：锚定、light-dismiss、Esc、焦点归还
4. [x] **原生 Win / Wayland**：空闲抑制、数字角标、延迟 Snap、xdg 激活/`app_id`；见 [native-platforms.md](../topics/native-platforms.md)
5. [x] **PySide6**：`python/md3qml` 宿主 + [hello-pyside](../../examples/hello-pyside/) / [gallery-pyside](../../examples/gallery-pyside/)；见 [pyside.md](../topics/pyside.md)
6. [x] **Python 完整宿主 + C ABI + Rust**：`Md3Application` / `doctor` / `run-c`；`md3_capi`；[`rust/md3qml`](../../rust/md3qml/) + [hello-rust](../../examples/hello-rust/)；见 [rust.md](../topics/rust.md)
7. [x] **Android 原生 hooks**：`FLAG_KEEP_SCREEN_ON` / `FLAG_SECURE` / `setBadgeNumber`；CMake `MD3_IS_ANDROID`；见 [android.md](../topics/android.md)
8. [x] a11y 路径加固（Dialog 焦点归还、Esc→back、List/Table Accessible.name、Menu 归还）+ Button/FAB 按下缩放
9. [x] VirtualList / DataTable 性能冒烟（Extras：跳转 2500、列宽 persist、PgUp/Dn）
10. [x] TitleBar/AppToolBar 内容槽示例（WindowPage）+ Sheet light-dismiss + Adaptive safeBottomInset
11. [x] **Electron 对标宿主**：`Md3NativeShell` 单实例 / 开机启动 / 全局快捷键(Win·macOS·Linux) / 协议注册 / 电源锁屏 / `getPath`
12. [x] **Android 扩展**：通知、系统栏颜色、方向、软键盘、Toast/触觉、应用/通知设置、电池优化、shareFile、Material You accent
13. [x] **体验抛光**：CommandBar a11y；Chip/Switch/Checkbox/Segmented 按压缩放；TextField/SearchBar 清空+错误反馈；Snackbar/Toast 滑动关闭/去重；Tooltip focus 延迟；SafeArea 6.9+；Nav 弹簧/长按/返回关抽屉；Skeleton/PageHost 节奏
14. [x] **性能（外观不变）**：按钮 clip FBO 按需；Shadow/Skeleton/Carousel 场景门控；disabled 色缓存；LiquidGlass 默认非 live；布局轮询降频；**DataTable/TreeView 虚拟化**；PageHost prefetch 防抖；Form 事件驱动 — 见 [performance.md](../topics/performance.md)

## 壳层对照

| 状态 | 项 |
|------|----|
| 已有 | Rail / Drawer / Bar / Scaffold / NavigationView / **Flyout** / TitleBar 槽示例 / **NativeShell（全桌面）** / **Android extras** / **SafeArea 6.9+ gate** / CommandBar a11y |
| 后续 | 真机 SafeArea 冒烟；超大 destination 槽池化（可选） |

参考：[wasm.md](../topics/wasm.md) · [android.md](../topics/android.md) · [native-platforms.md](../topics/native-platforms.md) · [quickstart](../getting-started/quickstart.md) · [a11y-spotcheck.md](../topics/a11y-spotcheck.md)
