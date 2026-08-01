# QML MD3 — 生产可用 TODO（摘要）

> 完整历史矩阵已收敛；此处只保留**下一步优先项**。

**基线：** 2026-08-02 · tag `v1.1.0` · 性能生命周期 + 系统圆角；WASM / Android 仍 experimental

## 已完成（至 1.1.0）

1. [x] **WASM**：CMake 识别 Emscripten、mobile stub、文档；hello-md3 可编
2. [x] **`Md3NavigationView`** / **`Md3Flyout`**
3. [x] **原生 Win / Wayland / NativeShell**（全桌面）
4. [x] **PySide6 / C ABI / Rust** 宿主
5. [x] **Android hooks + extras**（通知、系统栏、IME…）
6. [x] a11y / 体验抛光 / VirtualList·DataTable 冒烟
7. [x] **性能（外观不变）**：`md3PageActive` / Gate / DeferredSection / charts·gauges；会话防抖 — [performance.md](../topics/performance.md)
8. [x] **系统圆角**：Win DWM + macOS layer clip，跳过 MultiEffect chrome FBO — [native-platforms.md](../topics/native-platforms.md)

## 下一步（建议序）

1. [ ] **Android 真机冒烟**：按 [android.md](../topics/android.md) Device smoke 表走完并记 OEM 差异
2. [ ] **Linux 弱机 Gallery**：圆角开/关拖窗对比；可选默认 `cornerRadius: 0` 配置档
3. [ ] **PyPI 预览**：`md3qml` 预发布 + 固定 quickstart（仍非官方必选项）
4. [ ] **macOS vibrancy**（可选）：真实 `NSVisualEffectView`，今日仅透明钩子
5. [ ] WASM：保持 experimental，无明确客户不深挖

## 壳层对照

| 状态 | 项 |
|------|----|
| 已有 | Rail / Drawer / Bar / Scaffold / NavigationView / Flyout / TitleBar / NativeShell / Android extras / SafeArea 6.9+ / system corners (Win·macOS) |
| 后续 | Android 真机 SafeArea/通知/沉浸栏冒烟；Linux 圆角 FBO 策略产品化 |

参考：[wasm.md](../topics/wasm.md) · [android.md](../topics/android.md) · [native-platforms.md](../topics/native-platforms.md) · [performance.md](../topics/performance.md) · [release-checklist.md](../getting-started/release-checklist.md)
