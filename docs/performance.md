# Performance guide (appearance-preserving)

Md3 keeps the look (elevation, ripple, motion tokens) while letting you trade **first paint**, **page revisit speed**, and **RSS**. Those three cannot all be maxed at once.

## Mental model

| Layer | What costs money | Already gated? |
|-------|------------------|----------------|
| **GPU layers** (`layer` + `MultiEffect`) | FBO per masked button / dual-blur shadow | Ripple: only while ink runs. Shadow: off when `elevation === 0`. IconButton mask: always on while the control exists |
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

Start like profile C (no warm / no prefetch). After the window is visible (~80ms), raise L1/L2 and enable neighbor prefetch — see `gallery/Main.qml` `navWarmTimer`.

```qml
Md3ApplicationWindow {
    pageCacheLimit: 1
    pageL2CacheLimit: 1
    pagePrefetch: false
    pagePredictPrefetch: false
    pageWarmStart: false
    pageL2Warm: false
    pageSkeleton: true
    hotReload: false

    Timer {
        interval: 80
        running: parent.visible  // or start from onVisibleChanged
        onTriggered: {
            pageCacheLimit = 6
            pageL2CacheLimit = 8
            pagePrefetch = true
            pagePredictPrefetch = true
        }
    }
}
```

- 首启：不和邻居编译抢 CPU  
- 切页：暖机后近似 Profile B  
- 内存：比纯 Low memory 高，低于启动即 Warm 全部  

---

### E. 冷开不卡 + 可控内存

空壳 / async / L2 warm；L1 保持较小。

### E+（**当前 Gallery 默认**）— 可多占一点内存换切页手感

在 E 基础上：

- 暖机后 **`pageCacheLimit: 6`** + **`pagePrefetch: true`**（±1 邻居活页）
- **`pageIdleTrimMs: 90000`** — 避免几秒无操作就把 L1 裁回 1
- 仍关 `pagePredictPrefetch` / `pageWarmStart`（不全表常驻 Item）

```qml
Md3ApplicationWindow {
    pageAsync: true
    pageSkeleton: true
    pageL2Warm: true
    pageIdleTrimMs: 90000
    pageCacheLimit: 1             // after warm → 6
    pageL2CacheLimit: 32
    pagePrefetch: false           // after warm → true
    pagePredictPrefetch: false
    pageWarmStart: false
    pageLeaveSnapshot: false
    hotReload: false
    progressiveContent: true
}
```

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

2. **Large lists** — `Md3VirtualList` + row without `Md3Shadow` (`elevation: 0` / Flat card). Elevate only FABs, menus, sheets.

3. **Custom chrome** — copy `Md3Ripple`’s pattern: `layer.enabled` only while animating; never leave `MultiEffect` on for every cell in a grid.

4. **Liquid glass** — lower `quality`, `liveSampling: false` for static backdrops.

Qt will skip *painting* many off-screen nodes; it will **not** free FBOs for Items that stay in the tree with layers on. Unload (`Loader.active = false`) is the real “不算特效”.

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
