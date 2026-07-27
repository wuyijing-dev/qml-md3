# Md3::run / initialize (C++)

Header: `md3.h` (`#include "md3.h"`)

Bootstrap helpers for fonts, Basic style, and early RHI/alpha setup.

## `Md3::RunOptions`

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `organization` | `QString` | `"Md3"` | `QCoreApplication::setOrganizationName` |
| `applicationName` | `QString` | `"Md3 App"` | Application name |
| `applicationVersion` | `QString` | `"0.1.0"` | Application version |
| `style` | `QString` | `"Basic"` | `QQuickStyle::setStyle` |
| `loadFonts` | `bool` | `true` | Load HarmonyOS Sans SC Regular (+ optional Medium/Bold if present) and Material Icons from Md3 qrc / app `fonts/` |
| `alphaBuffer` | `bool` | `true` | `QQuickWindow::setDefaultAlphaBuffer` before app |
| `appUserModelId` | `QString` | empty | Windows only: AppUserModelID |

## Functions

| API | Description |
|-----|-------------|
| `void applyEarly(int &argc, char **argv, const RunOptions &opts = {})` | Call **before** `QGuiApplication`. DPI (Win), alpha buffer, `Md3Graphics::applyEarly`. |
| `int loadFonts()` | Register Regular (required) and Medium/Bold (optional) from `:/md3/fonts/resources/fonts/` and fallbacks. Returns count loaded. Sets app font to HarmonyOS Sans SC when available. |
| `void initialize(QCoreApplication &app, const RunOptions &opts = {})` | After app exists: org/name/version, style, fonts. |
| `int run(int argc, char **argv, const QString &moduleUri, const QString &mainComponent = "Main", const RunOptions &opts = {})` | One-shot: `applyEarly` → app → `initialize` → `loadFromModule` → `exec()`. |

## Example

```cpp
#include "md3.h"

int main(int argc, char *argv[]) {
    Md3::RunOptions opts;
    opts.applicationName = QStringLiteral("MyApp");
    return Md3::run(argc, argv, QStringLiteral("MyApp"), QStringLiteral("Main"), opts);
}
```

Split form:

```cpp
Md3::applyEarly(argc, argv);
QGuiApplication app(argc, argv);
Md3::initialize(app);
QQmlApplicationEngine engine;
engine.loadFromModule("MyApp", "Main");
return app.exec();
```

See also: [Md3Graphics](Md3Graphics.md), [../integration.md](../integration.md)
