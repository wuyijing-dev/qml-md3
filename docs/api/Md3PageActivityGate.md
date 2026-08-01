# Md3PageActivityGate

Tracks ancestor `md3PageActive` (injected by `Md3PageHost`) so heavy widgets can unload off-display.

- **Source:** `src/Md3/foundation/Md3PageActivityGate.qml`
- **Extends:** `Item` (zero-size helper)

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Description |
|------|------|---------|--------|-------------|
| `watchItem` | `Item` | `parent` | read/write | Start of ancestor walk for `md3PageActive` |
| `unloadWhenPageInactive` | `bool` | `true` | read/write | When false, `contentActive` stays true |
| `pageActive` | `bool` | `true` | read/write | Mirrors nearest page injectable |
| `contentActive` | `bool` | `!unloadWhenPageInactive \|\| pageActive` | readonly | Use this to gate models / Loaders |

## Usage

```qml
Item {
    id: heavy
    Md3PageActivityGate {
        id: pageGate
        watchItem: heavy
    }
    Loader {
        active: pageGate.contentActive
        sourceComponent: expensiveChart
    }
}
```

Page roots must declare `property bool md3PageActive: true` (or use `Md3Page`) so PageHost can inject.

## Components that auto-follow

DataTable, VirtualList, ListView, GridView, TreeView, ItemsView, Carousel, CodeBlock, Sparkline, FileDropZone, Form, DatePicker, DateRangePicker, TimePicker, DeferredSection, BulletChart, Shape gauges (Gauge/Ring/Half/ArcBand), Canvas gauges (via `pageGate` + scene checks).

Charts using `Md3Chart.chartActive` also require page active via `Md3TreeVisibility.isSceneActive`.
