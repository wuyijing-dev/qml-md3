# Performance guide (appearance-preserving)

Md3 keeps the look (elevation, ripple, motion tokens) while letting you trade **first paint**, **page revisit speed**, and **RSS**. Those three cannot all be maxed at once.

## Cross-platform lessons (iOS / Android / Qt)

Industry UI stacks converge on the same rules Md3 applies:

| Platform | Core idea | Md3 mapping |
|----------|-----------|-------------|
| **SwiftUI** ([Apple](https://developer.apple.com/documentation/xcode/understanding-and-improving-swiftui-performance)) | Narrow invalidation; keep body cheap; avoid whole-list updates | Prefer property tokens over JS in hot bindings; virtualize lists; don’t rebuild models every frame |
| **Jetpack Compose** ([Android](https://developer.android.com/develop/ui/compose/performance/bestpractices)) | Skip composition/layout; defer state reads to draw | Animate opacity/transform without re-layout; gate live timers with `Md3TreeVisibility` |
| **Qt Quick** ([Qt docs](https://doc.qt.io/qt-6/qtquick-performance.html)) | Batching; avoid JS during animation; Animator on render thread; no permanent FBO | `layer.enabled` only while ink runs; `RotationAnimator` for loaders; no heavy bindings on animating props |

## Library wins shipped (appearance-preserving)

1. **Button family clip FBOs** — armed only while masked ripple runs (`effectsRippleMasked && ripple.layersNeeded`).
2. **`Md3Shadow`** — elevation Behavior gated by `effectsLiveMotion`; no blur work when elevation/effects off.
3. **`Md3Skeleton` / Carousel / Form** — scene / window active gates; layout size-watch 48→120 ms.
4. **`Md3ColorScheme.disabledContent/Container`** — cached colors (no per-eval `Qt.rgba`).
5. **`Md3LiquidGlass.liveSampling`** — default `false` (opt-in for video); drag still samples live.
6. **`Md3StateOverlay`** — opacity Behavior skipped under `reduceMotion`.
7. **`Md3TreeView`** — `ListView { reuseItems }` + 160ms debounced `flatRows` rebuild.
8. **`Md3DataTable`** — free, scroll, **and frozen** bodies use **`TableView`** (row **and** column virtualization) via `Md3TableGridModel`.
9. **`Md3PageHost`** — prefetch coalesced (120ms); launch mask geometry only while morphing; **sparse slots** when `model.length > sparseSlotThreshold` (default 40, skipped for `cacheMode: "all"`).
10. **`Md3Form.liveGate`** — event-wired field signals + 48ms debounce (poll only if no named fields).
11. **Progress / Loading** — tree-visibility poll 500→2000ms + `Qt.application` state Connections.
12. **`Md3DocumentTabBar` ghost** — `layer.enabled` only while ghost visible.
13. **`Md3Chart`** — rebuild coalesced on event-loop tick; skipped while `!chartActive`, flushed on re-show.
14. **Canvas gauges** — `Md3TreeVisibility` gate + pending paint flush (Wave / Needle / Knob / …).
15. **`Md3HStack` / `Md3AnimatedFlow` / `Md3GridLayout`** — child `implicit*Changed` hooks; no 120ms size poll.
16. **`Md3TextField` suggestions** — geometry sync on open / size / scroll parents / window resize (no 16ms poll).
17. **`Md3ItemsView`** — only the active Stack/Grid host is loaded.
18. **`Md3Shadow`** — Balanced (`effectsLevel` 1) uses key blur only; High keeps ambient+key.
19. **`Md3LiquidGlass`** — body/mask FBOs only while visible with non-zero size.
20. **`Md3ContainerBody` / `Md3ScrollView`** — deferred content measure (no `height ↔ childrenRect` polish loop).
21. **Canvas gauges** — visibility poll backs off to 6s while opacity-hidden.

---

| Layer | What costs money | Already gated? |
|-------|------------------|----------------|
| **GPU layers** (`layer` + `MultiEffect`) | FBO per masked button / dual-blur shadow | Ripple: only while ink runs. **Buttons / IconButton / AppBar / Toggle / Split / ButtonGroup**: clip mask FBO only while `ripple.layersNeeded` (idle = no FBO). Shadow: off when `elevation === 0` / `effectsLevel === 0`; Balanced = key blur only, High = ambient+key. LiquidGlass layers only while visible |
| **Scene Graph** | Draw calls for on-screen items | Off-screen *drawing* is usually culled; **FBOs still exist** if the Item is alive with `layer.enabled` |
| **PageHost L1** | Live page Items in RAM | Default `arc` + `pageCacheLimit: 1` |
| **PageHost L2** | Compiled `Component` (cheap to re-instantiate) | Default limit `1` |
| **Within page** | Charts / tables / long forms | `Md3DeferredSection` + `progressiveContent` |

“看不见不渲染也不算特效” ≈ **不要让重控件以 `layer.enabled: true` 活在树里**（滚动出视野仍占 FBO）。做法：出屏用 `Loader { active: false }` / `Md3DeferredSection` / 列表用 `Md3VirtualList`，而不是只设 `visible: false` 却保留 layer。

---

## Three ready profiles

Set on `Md3ApplicationWindow` (or bind the same props on a bare `Md3PageHost`).

### A. Low memory (默认偏这个)

```qml
Md3ApplicationWindow {
    pageCacheMode: "arc"
    pageCacheLimit: 1
    pageL2Cache: true
    pageL2CacheLimit: 1
    pageL2Warm: false
    pagePrefetch: false
    pagePredictPrefetch: false
    pageWarmStart: false
    pageLeaveSnapshot: false
    pageAsync: false
    pageSkeleton: true
    progressiveContent: true
    pageTransition: "fade"
    pageTransitionDuration: 100
}
```

- 切换页：冷开有骨架 / 短淡入，**不是**秒开  
- 内存：最低合理 RSS  
- 首启：最快之一（不要开 `hotReload` / `pageL2Warm`）

### B. Instant page switch（秒开）

```qml
Md3ApplicationWindow {
    pageCacheMode: "lru"          // or "arc"
    pageCacheLimit: 6             // keep several pages alive
    pageL2CacheLimit: 8
    pagePrefetch: true            // ±1 neighbor as L1/L2
    pagePredictPrefetch: true
    pageWarmStart: true           // optional: compile destinations early
    pageL2Warm: false             // still avoid compiling *all* unless needed
    pageLeaveSnapshot: false
    pageSkeleton: false
    pageTransition: "none"        // or very short fade
    pageTransitionDuration: 0
    progressiveContent: true      // still defer heavy *within* page
}
```

- 切换页：再访近似秒开（RAM 换时间）  
- 内存：明显升高（每页含阴影/图表时更甚）  
- 首启：`pageWarmStart` / 预取会让**第一次**稍慢或后台吃 CPU

### C. Fast first open（首启）

```qml
Md3ApplicationWindow {
    // same as Low memory, plus:
    hotReload: false              // CRITICAL in shipping builds
    persistSession: false         // or delay restore
    pageWarmStart: false
    pageL2Warm: false
    pagePrefetch: false
    progressiveContent: true
    pageSkeleton: true
}
```

App `main.cpp` side:

- Prefer `Md3::run` / delayed non-critical init  
- Don’t load chart samples / network until first needed page  
- Release: no QML disk cache clears, no hot-reload watcher  

Gallery historically used `hotReload: true` for开发 — that **clears component cache** and slows reopen; keep it Debug-only.

---

### D. Fast first open + snappy switches（推荐 Gallery）

Start lean (`pageCacheLimit: 1`). After first show, `pageNavWarm: true` raises L1/L2 and neighbor prefetch:

```qml
Md3ApplicationWindow {
    pageCacheLimit: 1
    pageL2CacheLimit: 1
    pagePrefetch: false
    pagePredictPrefetch: false
    pageWarmStart: false
    pageL2Warm: true
    pageSkeleton: true
    pageNavWarm: true          // built-in deferred warm (~80ms)
    // pageNavWarmCacheLimit: 6
    // pageNavWarmL2CacheLimit: -1  // → max(32, destinations.length)
    hotReload: false

    pageSourceBase: Qt.resolvedUrl("./pages/")
    destinations: [
        { title: "Home", icon: "home", source: "HomePage.qml" }
    ]
}
```

Relative `source` paths resolve via `resolvedPageSourceBase` (hot-reload disk tree when enabled).

- 首启：不和邻居编译抢 CPU  
- 切页：暖机后近似 Profile B  
- 内存：比纯 Low memory 高，低于启动即 Warm 全部  

---

### E. 冷开不卡 + 可控内存

空壳 / async / L2 warm；L1 保持较小。

### F. Seamless open（无感：不显示 skeleton / busy）

关掉可见 loading，用 **同步首屏 + 常驻近邻** 换「空白/骨架」：

```qml
Md3ApplicationWindow {
    pageSkeleton: false          // 关键：不要骨架屏
    pageAsync: false             // 首屏同步孵化，避免 Loader 空窗
    pageCacheLimit: 6
    pageL2CacheLimit: 32
    pagePrefetch: true
    pageL2Warm: true
    pageWarmStart: false         // 冷启别全表预编译（会拖第一帧）
    pageTransition: "none"
    pageTransitionDuration: 0
    pageNavWarm: true
    pageIdleTrimMs: 90000
    progressiveContent: true     // 页内重块仍 DeferredSection
}
```

Gallery 默认用短 **fade**（仍无骨架、同步首屏）；要完全无动画时再设 `pageTransition: "none"`。

| 现象 | 原因 | 处理 |
|------|------|------|
| 切页闪骨架 | `pageSkeleton: true` | 设 `false` |
| 切页白一下再出内容 | `pageAsync: true` 且无骨架；或 `pageTransitionDuration: 0` 却仍用 fade（会闪一帧 t=0） | `pageAsync: false`；无动画用 `pageTransition: "none"`（或 duration≤0，Host 会强制 instant） |
| 回访仍慢 | `pageCacheLimit: 1` 被 idle trim | `pageCacheLimit ≥ 4` + `pageIdleTrimMs` 加大 |
| 冷启卡住 | `pageWarmStart: true` / 重页同步 | 关 warmStart；重页用 `Md3DeferredSection` |
| 页内仍 “Loading” | DataTable `loading` / 业务态 | 与 PageHost 无关，别和骨架混为一谈 |

Gallery 当前默认偏 **Profile F**（无感），内存高于纯 Low memory。

Page author pattern (Charts already):

```qml
Flickable {
    ColumnLayout {
        Text { text: qsTr("Title") /* shell — sync */ }
        Md3DeferredSection {
            preferredHeight: 280
            delayMs: 0
            asynchronous: true
            sourceComponent: heavyBlock
        }
    }
}
```

| 手段 | 冷开手感 | RSS |
|------|----------|-----|
| qmlcachegen | ↑↑ | ≈0 |
| pageAsync + skeleton | ↑（不假死） | ≈0 |
| pageL2Warm（全表 Component） | 任意页首次更顺 | 低 |
| L1=6 + prefetch（E+） | 近邻/回访明显快 | **中等**（可接受） |
| L1=6+prefetch / warmStart | 回访很快 | **易炸** |
| DeferredSection 空壳 | 首屏立刻 | ↓ |

---

## Official device tiers（弱机 / 办公 / 高刷）

`Md3Theme.effectsLevel`（0 流畅 / 1 均衡 / 2 画质）是 Live 图与 Wave 的**默认档位**。应用侧在设置页暴露三档即可；弱机默认 `0`，办公笔记本 `1`，高刷桌面可 `2`。

| 场景 | `effectsLevel` | 页面壳推荐 | Live/Wave 默认 FPS |
|------|----------------|------------|-------------------|
| 弱机 / 集显 / 电池优先 | `0` | Profile A / E（`pageCacheLimit: 1`，关 predict） | **15** |
| 办公本（默认） | `1` | Profile E+（暖机后 L1=6 + neighbor prefetch） | **24** |
| 高刷 / 外接显卡 | `2` | Profile B 或 E+；可开 `pagePredictPrefetch` | **0**（跟显） |

`reduceMotion: true` 时 `effectsLiveMotion` 为 false，Live / Wave 定时器全部停。

---

## Charts：Live / Wave 默认档位与 CPU 预算

实现入口：

| 控件 | 开关 | FPS 覆盖 | 主题门控 |
|------|------|----------|----------|
| `Md3LineChart`（及同类 live 图） | `live: true` | `liveFps`（0 = 用主题） | `Md3Theme.effectsLiveMotion` + `chartActive` |
| `Md3WaveGauge` | `animated`（默认跟 `!reduceMotion`） | `animationFps`（0 = 用主题） | `effectsLiveMotion` + `effectivelyShown` |

主题默认（`Md3Theme.qml`）：

| `effectsLevel` | `effectsLiveFps` | 含义 |
|----------------|------------------|------|
| 0 Low | `15` | ~66 ms/帧，多块 Live 时仍可控 |
| 1 Balanced | `24` | 办公默认；约每帧一次 `advanceLive` / `canvas.requestPaint` |
| 2 High | `0` | `FrameAnimation` 跟显示器刷新（60/120/144） |

### CPU 预算（经验值，单页同时可见）

| 预算档 | 同时 Live 曲线 | 同时 Wave | 建议 |
|--------|----------------|-----------|------|
| 弱机 | ≤ 1 | ≤ 1 | `effectsLevel: 0`；屏外用 `Md3DeferredSection` / 卸 Loader |
| 办公 | ≤ 2–3 | ≤ 2 | 默认；多余的关 `live` / `animated` 或降 `liveFps: 12` |
| 高刷 | 按需 | 按需 | `effectsLevel: 2`；仍避免**不可见**控件继续跑（Wave 已 walk 父链 `visible`/`opacity`） |

强制降载示例：

```qml
Md3LineChart {
    live: true
    liveFps: Md3Theme.effectsLow ? 10 : 0   // 显式封顶；0 = 跟主题
}
Md3WaveGauge {
    animated: chartVisible                   // 页不可见时关掉
    animationFps: 20                         // 覆盖主题
}
```

---

## Rail：拖动时禁止 hover 预编译

`pagePredictPrefetch: true` 时，Rail 悬停会 `prefetchHint` → 延迟 L2 编译。**拖动 / 惯性滚动 Rail 时禁止**，否则会卡顿 flick。

已实现（回归由 `scripts/checks/check_perf_guards.py` 锁定）：

1. `Md3NavigationRail`：`onEntered` 仅在 `!scrolling` 时发 `destinationHovered`
2. `Md3WindowBody`：收到 hover 时若 `rail.scrolling` 直接 return
3. `onScrollingChanged` → `host.clearAllPrefetchHints()`（取消已排队的 Timer）

消费方自定义 Rail 时请同样调用：拖动开始清 hint，悬停前查 `scrolling`。

---

## Off-screen: don’t pay for effects

1. **Long pages** — wrap below-the-fold blocks:

```qml
Md3DeferredSection {
    preferredHeight: 320
    delayMs: 0
    sourceComponent: Component {
        Md3LineChart { /* … */ }
    }
}
```

2. **Large lists（强制推荐）** — 见下一节检查清单；行内无 `Md3Shadow`（`elevation: 0` / Flat）。Elevate 只留给 FAB、菜单、Sheet。

3. **Custom chrome** — copy `Md3Ripple`’s pattern: `layer.enabled` only while animating; never leave `MultiEffect` on for every cell in a grid.

4. **Liquid glass** — lower `quality`, `liveSampling: false` for static backdrops.

Qt will skip *painting* many off-screen nodes; it will **not** free FBOs for Items that stay in the tree with layers on. Unload (`Loader.active = false`) is the real “不算特效”.

---

## 大列表检查清单：`Md3VirtualList` + 禁止层叠 `layer.enabled`

**规则：** 模型行数 ≥ ~100，或行内有图标/徽章/多 Text 时，**用 `Md3VirtualList`（或自写 `ListView { reuseItems: true }`）**，不要用 `Repeater` / `Column` 全量实例化。

### 必做

- [ ] 列表根用 `Md3VirtualList`（`reuseItems` 已开）或等价虚拟化
- [ ] 固定 `itemHeight`（或稳定高度），避免每行隐式高度抖动
- [ ] `cacheBufferPx` 按需（默认 800）；弱机可降到 200–400
- [ ] 行 delegate：**不要** `layer.enabled: true` / `MultiEffect` / 双模糊阴影常驻
- [ ] 行 `elevation: 0`；需要分隔用 `Md3Divider` 或底边，不用每行 `Md3Shadow`
- [ ] 行内动画（ripple）仅在进行中开 layer（对照 `Md3Ripple`）

### 禁止

- [ ] 禁止在虚拟列表 **每一行** 叠 `layer.enabled` + `layer.effect`
- [ ] 禁止父级 `layer.enabled` 再包一整棵 ListView（整表一张 FBO，滚动更贵）
- [ ] 禁止 `visible: false` 却保留带 layer 的行 Item 常驻（应靠复用/卸载）
- [ ] 禁止在 delegate 里再嵌套大 `Repeater` 全量子树

### 推荐写法

```qml
Md3VirtualList {
    model: bigModel
    itemHeight: 56
    cacheBufferPx: Md3Theme.effectsLow ? 240 : 800
    delegate: Component {
        Md3ListTile {
            // elevation stays 0; no layer.enabled here
            text: modelData.title
            onClicked: list.itemActivated(listIndex, modelData)
        }
    }
}
```

静态守卫：`python scripts/checks/check_perf_guards.py`（Rail hover + 文档锚点）。

---

## C++：什么时候值得写

| 值得 C++ | 不明显 / 别先做 |
|----------|----------------|
| 大表 / 树：`QAbstractItemModel` + 角色 | 把单个 `Md3Button` 改成 C++（外观同款，收益极小） |
| 持久化、路径、压缩、网络（已有 `Md3AppSettings` 等） | 页面切换逻辑从 PageHost 重写成 C++ |
| 图表点列、过滤排序（`Md3ChartData` 方向） | 为微优化重写 Theme 单例 |

JS `var model: [...]` 上千行时，C++ model + `Md3VirtualList` 比“全部改 C++ 控件”更有效。

---

## Measure before tuning

Title-bar speed button → `Md3PerformancePanel`:

- FPS / frame time while scrolling a dense page  
- Private bytes before/after raising `pageCacheLimit`  
- Toggle **页内渐进** (`progressiveContent`) A/B  

If FPS is fine but switch feels slow → raise L1 cache (profile B).  
If RSS is high → profile A + DeferredSection + no list shadows.  
If first window is slow → profile C + kill hot reload.

---

## Quick decision

```
要冷开不卡且可多占一点内存？ → Profile E+：L1=6 + prefetch + idleTrim 拉长 + L2 warm
要冷开不卡且内存更省？     → Profile E：cachegen + pageAsync + pageL2Warm + L1≤3 + DeferredSection 空壳
要秒开翻页（可接受内存）？ → 提高 pageCacheLimit + prefetch（Profile B）
要省内存极限？         → cacheLimit=1，关 prefetch，列表无 elevation
要首启快？             → 关 hotReload / warmStart，progressiveContent=true
要看不见不算特效？     → Loader/DeferredSection/VirtualList，别只靠 visible
```
