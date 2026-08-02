# Md3LoadingIndicator

Material 3 Loading indicator — spins a fixed arc (no per-frame Path mutation).

- **Source:** `src/Md3/components/Md3LoadingIndicator.qml`
- **Extends:** `Item`

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 12 | 0 | 0 | 1 |

_Also inherits Qt Quick `Item` members (not listed)._

## Import

```qml
import Md3
```

## Enums

### `Md3LoadingIndicator.Size`

`Md3LoadingIndicator.Small`, `Md3LoadingIndicator.Medium`, `Md3LoadingIndicator.Large`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `sizePreset` | `int (Md3LoadingIndicator.Size)` | `Md3LoadingIndicator.Medium` | read/write | `Md3LoadingIndicator` | Size Preset. |
| `value` | `real` | `0` | read/write | `Md3LoadingIndicator` | Current value. |
| `indeterminate` | `bool` | `true` | read/write | `Md3LoadingIndicator` | Indeterminate. |
| `label` | `string` | `""` | read/write | `Md3LoadingIndicator` | Field / control label. |
| `indicatorColor` | `color` | `Md3Theme.colorScheme.primary` | read/write | `Md3LoadingIndicator` | Indicator Color. |
| `trackColor` | `color` | `Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.primary, 0.2)` | read/write | `Md3LoadingIndicator` | Track Color. |
| `hostWindow` | `var` | `null` | read/write | `Md3LoadingIndicator` | Optional Window for scene-active checks (else OverlayHost). |
| `unloadWhenPageInactive` | `bool` | `true` | read/write | `Md3LoadingIndicator` | Drop Shape geometry while page is off-display. |
| `strokeWidth` | `real` | `{…}` | read/write | `Md3LoadingIndicator` | Stroke Width. |
| `indicatorSize` | `real` | `{…}` | read/write | `Md3LoadingIndicator` | Indicator Size. |
| `sceneActive` | `bool` | `enabled && _treeShown` | readonly | `Md3LoadingIndicator` | Scene Active. |
| `radius` | `real` | `indicatorSize / 2 - strokeWidth` | readonly | `Md3LoadingIndicator` | Corner radius. |

## Signals

_None._

## Methods

_None._

## Example

```qml
import Md3

Md3LoadingIndicator {
    sizePreset: Md3LoadingIndicator.Medium
    value: 0
    indeterminate: true
    label: ""
    indicatorColor: Md3Theme.colorScheme.primary
    trackColor: Md3Theme.colorScheme.withOpacity(Md3Theme.colorScheme.primary, 0.2)
}
```
