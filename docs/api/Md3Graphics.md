# Md3Graphics

RHI / alpha-buffer helpers.

- **Source:** `src/Md3/window/md3graphics.h`
- **Extends:** `QObject`
- **Kind:** C++ / QML_ELEMENT (generated from header)

## Overview

| Properties | Signals | Methods | Enums |
|------------|---------|---------|-------|
| 6 | 0 | 4 | 1 |

## Import

```qml
import Md3
```

## Enums

### `Md3Graphics.Backend`

`Md3Graphics.Auto`, `Md3Graphics.D3D11`, `Md3Graphics.D3D12`, `Md3Graphics.Vulkan`, `Md3Graphics.OpenGL`, `Md3Graphics.OpenGLES`, `Md3Graphics.Metal`, `Md3Graphics.Software`

## Properties

| Name | Type | Default | Access | Defined in | Description |
|------|------|---------|--------|------------|-------------|
| `currentBackend` | `string` | `—` | readonly | `Md3Graphics` | Notify: `backendChanged` |
| `preferredBackend` | `string` | `—` | read/write | `Md3Graphics` | Notify: `preferredBackendChanged` |
| `availableBackends` | `var` | `—` | readonly | `Md3Graphics` | Constant |
| `restartRequired` | `bool` | `—` | readonly | `Md3Graphics` | Notify: `restartRequiredChanged` |
| `platformName` | `string` | `—` | readonly | `Md3Graphics` | Constant |
| `alphaBufferEnabled` | `bool` | `—` | readonly | `Md3Graphics` | Notify: `alphaBufferChanged` |

## Signals

_None._

## Methods

| Method | Returns | Defined in | Description |
|--------|---------|------------|-------------|
| `setAlphaBufferEnabled(bool enabled)` | `void` | `Md3Graphics` | Set Alpha Buffer Enabled. |
| `setBackend(const QString &name)` | `bool` | `Md3Graphics` | Set Backend. |
| `normalizeBackendName(const QString &name)` | `string` | `Md3Graphics` | Normalize Backend Name. |
| `isBackendAvailable(const QString &name)` | `bool` | `Md3Graphics` | Is Backend Available. |

## Example

```qml
import Md3

// C++ / host type — typically used from QML as `Md3Graphics { }`
Md3Graphics {
    // see properties / methods above
}
```
