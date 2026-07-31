# Md3PullToRefresh

Pull-to-refresh host for a Flickable (touch / trackpad; desktop optional).

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

## Signals

| Signal | Defined in | Description |
|--------|------------|-------------|
| `refreshRequested()` | `Md3PullToRefresh` | — |

## Methods

| Method | Defined in | Description |
|--------|------------|-------------|
| `endRefresh()` | `Md3PullToRefresh` | — |
| `beginRefresh()` | `Md3PullToRefresh` | — |

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
