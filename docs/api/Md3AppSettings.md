# Md3AppSettings

QSettings facade for QML.

- **Source:** `src/Md3/diagnostics/md3appsettings.h`
- **Extends:** `QObject`
- **Kind:** C++ / QML_ELEMENT (generated from header)

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 2 | 0 | 4 | 0 |

## Import

```qml
import Md3
```

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `organization` | `string` | `—` | read/write | `Md3AppSettings` | Notify: `organizationChanged` |
| `application` | `string` | `—` | read/write | `Md3AppSettings` | Notify: `applicationChanged` |

## Signals

_None._

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `setValue(const QString &key, const QVariant &value)` | `void` | `Md3AppSettings` | Set Value. |
| `contains(const QString &key)` | `bool` | `Md3AppSettings` | Contains. |
| `remove(const QString &key)` | `void` | `Md3AppSettings` | Remove. |
| `sync()` | `void` | `Md3AppSettings` | Sync. |

## Example

```qml
import Md3

// C++ / host type — typically used from QML as `Md3AppSettings { }`
Md3AppSettings {
    // see properties / methods above
}
```
