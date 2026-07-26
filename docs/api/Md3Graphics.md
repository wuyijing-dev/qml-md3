# Md3Graphics

- **Source:** `src/Md3/window/md3graphics.h`
- **QML:** `Md3Graphics` singleton (`QML_SINGLETON`)
- **C++:** `#include "md3graphics.h"`

Process-wide Qt Quick RHI backend selection. Prefer calling `Md3Graphics::applyEarly` (or `Md3::applyEarly` / `Md3::run`) **before** the first `QQuickWindow` / `QGuiApplication`.

## Enum `Md3Graphics::Backend`

`Auto`, `D3D11`, `D3D12`, `Vulkan`, `OpenGL`, `OpenGLES`, `Metal`, `Software`

## Properties

| Name | Type | Access | Description |
|------|------|--------|-------------|
| `currentBackend` | `string` | readonly | Active RHI backend name |
| `preferredBackend` | `string` | read/write | Stored preference |
| `availableBackends` | `string list` | readonly | Backends usable on this platform |
| `restartRequired` | `bool` | readonly | Preference changed but scene graph already running |
| `platformName` | `string` | readonly | QPA platform name |
| `alphaBufferEnabled` | `bool` | read/write (via method) | Default alpha buffer for translucent chrome |

## Signals

| Signal | Description |
|--------|-------------|
| `backendChanged()` | Current backend changed |
| `preferredBackendChanged()` | Preference changed |
| `restartRequiredChanged()` | Restart flag toggled |
| `alphaBufferChanged()` | Alpha buffer preference changed |

## Methods

| Method | Description |
|--------|-------------|
| `static void applyEarly(int &argc, char **argv)` | Parse `--rhi-backend` / `--md3-rhi` and apply before app |
| `void setAlphaBufferEnabled(bool enabled)` | Prefer translucent frames |
| `bool setBackend(const QString &name)` | Apply now if SG idle; else store preference |
| `QString normalizeBackendName(const QString &name) const` | Normalize alias |
| `bool isBackendAvailable(const QString &name) const` | Availability check |

## Example (QML)

```qml
import Md3
Text { text: Md3Graphics.currentBackend }
```
