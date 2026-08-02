# Md3ChartData

Chart series / downsampling.

- **Source:** `src/Md3/charts/md3chartdata.h`
- **Extends:** `QObject`
- **Kind:** C++ / QML_ELEMENT (generated from header)

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 4 | 0 | 4 | 0 |

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `points` | `var` | `—` | readonly | `Md3ChartData` | Notify: `pointsChanged` |
| `rawCount` | `int` | `—` | readonly | `Md3ChartData` | Notify: `pointsChanged` |
| `pointCount` | `int` | `—` | readonly | `Md3ChartData` | Notify: `pointsChanged` |
| `targetPoints` | `int` | `—` | read/write | `Md3ChartData` | Notify: `targetPointsChanged` |

## Signals

_None._

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `fillSine(int count, qreal mid = 50.0, qreal amp1 = 30.0, qreal amp2 = 12.0, qreal noise = 6.0)` | `void` | `Md3ChartData` | Fill Sine. |
| `setFloatValues(const QByteArray &floats)` | `void` | `Md3ChartData` | Set Float Values. |
| `setValues(const QVariantList &values)` | `void` | `Md3ChartData` | Set Values. |
| `clear()` | `void` | `Md3ChartData` | Clear value / selection. |

## Example

```qml
import Md3

// C++ / host type — typically used from QML as `Md3ChartData { }`
Md3ChartData {
    // see properties / methods above
}
```
