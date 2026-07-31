# Window appearance（桌面 / 移动端）

Material 3 风格的**窗口外观准则**：按屏幕宽度与设备类型自动选择系统栏 / 紧凑自定义标题栏 / 完整桌面 CSD，并与导航壳（栏 vs 轨）对齐。

核心入口：

| API | 作用 |
|-----|------|
| `Md3Adaptive`（singleton） | 断点、设备类、外观策略 |
| `Md3ApplicationWindow.adaptiveChrome` | 默认 `true`，按策略开闭 CSD |
| `Md3NavigationView` Auto | 使用同一套 600 / 840 断点 |

平台能力（能否做 CSD、caption、移动 OS）仍由 [`Md3WindowCapabilities`](../topics/native-platforms.md) 决定；Adaptive 只在「允许 CSD」的前提下选外观。

## 宽度类（WindowSizeClass）

逻辑像素（与导航 Auto 模式一致）：

| 类 | 宽度 |
|----|------|
| Compact | ≤ 599 |
| Medium | ≤ 839 |
| Expanded | ≤ 1199 |
| Large | ≤ 1599 |
| ExtraLarge | ≥ 1600 |

高度类：Compact ≤ 479、Medium ≤ 899、其余 Expanded（次要，用于 TV/矮窗启发式）。

```qml
import Md3

readonly property int wc: Md3Adaptive.widthClassFor(width)
readonly property string name: Md3Adaptive.widthClassName(wc)
```

`Md3ApplicationWindow` 已暴露只读：`widthClass` / `heightClass` / `deviceClass` / `windowAppearance` 及对应 `*Name`。

## 设备类

| 类 | 判定要点 |
|----|----------|
| Phone | 移动 OS 且宽度 Compact；或桌面窗口 ≤ Compact |
| Tablet | 移动 OS 且宽度 ≥ Expanded；或桌面 Medium |
| Desktop | 桌面 Expanded+ |
| Tv | ExtraLarge 且高度 Compact |

WASM 按 Desktop 处理；移动 OS 优先于「窗口很宽」的桌面模式误判。

## 窗口外观（WindowAppearance）

| 外观 | 何时 | 效果 |
|------|------|------|
| **System** | 无 CSD 能力、移动 OS、WASM | 系统标题栏 / 无无边框；`useCustomChrome === false` |
| **CompactChrome** | 桌面 Phone/Tablet 或宽度 Compact/Medium | 无边框 + 紧凑标题栏（`preferCompactTitleBar`） |
| **DesktopChrome** | 桌面 Expanded+ | 完整 CSD（圆角、resize grip、caption 等按平台） |

应用窗口侧：

```qml
Md3ApplicationWindow {
    adaptiveChrome: true   // 默认；false 则只看 customChrome / Capabilities
    // customChrome: false // 强制系统框，覆盖自适应 CSD
}
```

有效标志：`useCustomChrome`（布局 / flags / 圆角请用它，不要只看 `customChrome`）。

只读提示：

- `preferCompactTitleBar` — 默认标题栏 `compact`
- `preferCaptionButtons` — CSD 时显示 min/max/close
- `preferNavigationBar` / `preferNavigationRail` — 壳层导航密度

## 导航对齐

`Md3NavigationView` 默认断点来自 Adaptive：

- `< 600` → Top（底栏）
- `< 840` → LeftCompact
- 否则 → Left（展开轨）

也可手写：

```qml
Md3NavigationView {
    compactBreakpoint: Md3Adaptive.navigationCompactBreakpoint
    expandedBreakpoint: Md3Adaptive.navigationExpandedBreakpoint
}
```

## 推荐做法

1. **桌面应用**：保留 `adaptiveChrome: true`，让窄窗自动紧凑标题栏，宽窗用完整 CSD。
2. **强制系统栏**：`customChrome: false` 或 `adaptiveChrome: false` 且不启 CSD。
3. **自绘壳**：读 `windowAppearance` / `deviceClass`，不要硬编码 600/840。
4. **移动打包**：Capabilities 已关 CSD → 自动 System；用 `preferNavigationBar` 选底栏。

## Gallery

`gallery/pages/WindowPage.qml` 顶部「自适应」区展示当前 `widthClass` / `deviceClass` / `windowAppearance`；缩放窗口即可验证。
