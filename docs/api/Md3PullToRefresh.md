# Md3PullToRefresh

Pull-to-refresh host for a Flickable (touch / trackpad; desktop via overscroll or `beginRefresh()`).

- **Source:** `src/Md3/components/Md3PullToRefresh.qml`
- **Extends:** `Item`

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `flickable` | `Flickable` | `null` | read/write | `Md3PullToRefresh` | — |
| `refreshing` | `bool` | `false` | read/write | `Md3PullToRefresh` | — |
| `triggerDistance` | `real` | `72` | read/write | `Md3PullToRefresh` | — |
| `refreshingText` | `string` | `qsTr("Refreshing…")` | read/write | `Md3PullToRefresh` | — |
| `pullText` | `string` | `qsTr("Pull to refresh")` | read/write | `Md3PullToRefresh` | — |
| `releaseText` | `string` | `qsTr("Release to refresh")` | read/write | `Md3PullToRefresh` | — |
| `showManualRefresh` | `bool` | `false` | read/write | `Md3PullToRefresh` | Show a compact control for mouse / keyboard hosts that cannot overscroll easily. |
| `manualRefreshText` | `string` | `qsTr("Refresh")` | read/write | `Md3PullToRefresh` | — |

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `refreshRequested()` | `Md3PullToRefresh` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `endRefresh()` | `Md3PullToRefresh` | — |
| `beginRefresh()` | `Md3PullToRefresh` | — |
| `attachOverscroll()` | `Md3PullToRefresh` | Enable DragOverBounds on the flickable so desktop drag can arm the gesture. |

## Example

```qml
import Md3

Md3PullToRefresh {
    flickable: null
    refreshing: false
    triggerDistance: 72
    refreshingText: qsTr("Refreshing…")
    pullText: qsTr("Pull to refresh")
}
```

## WinUI 对照

| WinUI | Md3 |
|-------|-----|
| RefreshContainer | `Md3PullToRefresh` |

绑定 `flickable`；`onRefreshRequested` 后调用 `endRefresh()`。
