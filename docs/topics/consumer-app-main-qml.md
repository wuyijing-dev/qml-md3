# Consumer app: Main.qml fails to load

When you build a **consumer app** (not Gallery) on top of a packaged `./Md3` folder, you may see:

```text
QQmlApplicationEngine failed to load component
qrc:/qt/qml/YourApp/qml/Main.qml: No such file or directory
```

or Qt Creator reports **terminated abnormally** right after start with almost no log output.

This is usually **not** a broken Md3 component library. It is a combination of:

1. Wrong QML module resource path for the app entry file
2. Missing shared Md3 runtime beside the executable (Debug builds)
3. Window not shown (`visible` defaults) so the process exits immediately

The working reference in this repo is **`auto_deploy_Qt`** (`D:\QML_MD3\auto_deploy_Qt`).

---

## Recommended CMake (`qt_add_qml_module`)

Use Qt 6.10+ style module registration with an explicit resource prefix and a stable alias for `Main.qml`:

```cmake
find_package(Qt6 REQUIRED COMPONENTS Quick QuickControls2 Widgets SerialPort)
qt_standard_project_setup(REQUIRES 6.10)

list(APPEND CMAKE_PREFIX_PATH "${CMAKE_CURRENT_SOURCE_DIR}/Md3")
find_package(Md3 REQUIRED CONFIG)

qt_add_executable(your_app main.cpp)

set_source_files_properties(Main.qml PROPERTIES QT_RESOURCE_ALIAS Main.qml)

qt_add_qml_module(your_app
    URI YourApp
    VERSION 1.0
    RESOURCE_PREFIX /qt/qml
    QML_FILES
        Main.qml
)

target_link_libraries(your_app PRIVATE
    Qt6::Quick
    Qt6::QuickControls2
    Qt6::Widgets
    Md3::Md3
)

if (TARGET Md3::QmlPlugin)
    target_link_libraries(your_app PRIVATE Md3::QmlPlugin)
endif()

if (Md3_SHARED)
    target_compile_definitions(your_app PRIVATE MD3_SHARED)
endif()

qt_import_qml_plugins(your_app)

# Deploy shared Md3 DLL + qml/Md3 beside the exe (see packaging.md)
if (EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/Md3/lib/cmake/Md3/Md3DeployShared.cmake")
    include("${CMAKE_CURRENT_SOURCE_DIR}/Md3/lib/cmake/Md3/Md3DeployShared.cmake")
endif()
if (COMMAND md3_deploy_shared_runtime)
    md3_deploy_shared_runtime(your_app "${CMAKE_CURRENT_SOURCE_DIR}/Md3")
endif()
```

### Why `QT_RESOURCE_ALIAS Main.qml` matters

Without the alias, Qt may register the entry as:

```text
qrc:/qt/qml/YourApp/qml/Main.qml
```

while `loadFromModule("YourApp", "Main")` and `qmldir` expect:

```text
qrc:/qt/qml/YourApp/Main.qml
```

Setting `QT_RESOURCE_ALIAS Main.qml` keeps the on-disk path (`qml/Main.qml` in build tree) separate from the **resource URL** used at runtime.

Verify after configure/build:

- `build/<YourApp>/qmldir` contains `Main 1.0 qml/Main.qml` and `prefer :/qt/qml/YourApp/`
- `.qt/rcc/*_raw_qml_0.qrc` maps alias `Main.qml`, not `qml/Main.qml`

---

## Recommended `main.cpp` (shared Md3 package)

Do **not** rely on `Md3::run()` alone for packaged shared apps. Mirror `auto_deploy_Qt/main.cpp`:

```cpp
#include "md3.h"

#include <QQmlApplicationEngine>
#include <QQmlError>
#include <QFile>
#include <QUrl>
#include <QDebug>

#if defined(MD3_SHARED)
#  include <QPluginLoader>
#endif

#if defined(Q_OS_LINUX) || defined(Q_OS_WIN)
#  include <QApplication>
#else
#  include <QGuiApplication>
#endif

int main(int argc, char *argv[])
{
    Md3::RunOptions opts;
    opts.organization = QStringLiteral("YourOrg");
    opts.applicationName = QStringLiteral("YourApp");
    opts.applicationVersion = QStringLiteral("1.0.0");

    Md3::applyEarly(argc, argv, opts);

#if defined(Q_OS_LINUX) || defined(Q_OS_WIN)
    QApplication app(argc, argv);
#else
    QGuiApplication app(argc, argv);
#endif

    Md3::initialize(app, opts);

    const QString appDir = QCoreApplication::applicationDirPath();
    QCoreApplication::addLibraryPath(appDir);

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::warnings,
        &app,
        [](const QList<QQmlError> &warnings) {
            for (const QQmlError &e : warnings)
                qWarning("%s", qPrintable(e.toString()));
        });

    engine.addImportPath(appDir + QStringLiteral("/qml"));

#if defined(MD3_SHARED)
    const QString md3Plugin = appDir + QStringLiteral("/qml/Md3/Md3plugin.dll");
    if (QFile::exists(md3Plugin)) {
        QPluginLoader loader(md3Plugin);
        if (!loader.load())
            qCritical("Md3: failed to load %s: %s", qPrintable(md3Plugin),
                      qPrintable(loader.errorString()));
    }
#endif

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    const QString diskMain = appDir + QLatin1Char('/')
                           + QStringLiteral("YourApp")
                           + QStringLiteral("/Main.qml");
    if (QFile::exists(diskMain)) {
        engine.load(QUrl::fromLocalFile(diskMain));
    } else {
        engine.loadFromModule(QStringLiteral("YourApp"), QStringLiteral("Main"));
    }

    if (engine.rootObjects().isEmpty()) {
        qCritical("Failed to load Main.qml (import paths: %s)",
                  qPrintable(engine.importPathList().join(QLatin1String(", "))));
        return 1;
    }

    return app.exec();
}
```

---

## Recommended root QML

Top-level window must be visible, or the event loop may exit immediately:

```qml
import QtQuick
import Md3

Md3ApplicationWindow {
    width: 1200
    height: 760
    visible: true   // required for consumer apps
    title: qsTr("YourApp")
    // ...
}
```

---

## Runtime layout (Windows Debug)

After build, the executable directory should contain at least:

```text
your_app.exe
Md3.dll
qml/
  Md3/
    Md3plugin.dll
    qmldir
    ...
```

If `Md3.dll` or `qml/Md3/` is missing, enable `md3_deploy_shared_runtime` in CMake (see [packaging.md](../getting-started/packaging.md)).

**Debug vs Release:** packaged Md3 may only ship Release `Md3.dll`. For Debug Kit builds, either:

- switch Qt Creator kit to **Release**, or
- package / copy **Debug** `Md3.dll` from `Md3/bin/debug/` if your package provides it

---

## Quick checklist

| Check | Expected |
|-------|----------|
| `Main.qml` alias | `set_source_files_properties(Main.qml PROPERTIES QT_RESOURCE_ALIAS Main.qml)` |
| Module prefix | `RESOURCE_PREFIX /qt/qml` in `qt_add_qml_module` |
| Load API | `engine.loadFromModule("YourApp", "Main")` or disk fallback |
| Shared deploy | `Md3.dll` + `qml/Md3/` next to exe |
| Import path | `engine.addImportPath(appDir + "/qml")` |
| Root window | `visible: true` on `Md3ApplicationWindow` |
| Reference | `auto_deploy_Qt` project in sibling folder |

---

## Related

- [integration.md](../getting-started/integration.md) — `find_package(Md3)` and linking
- [packaging.md](../getting-started/packaging.md) — build `dist/Md3` and deploy shared runtime
- [api/Md3ApplicationWindow.md](api/Md3ApplicationWindow.md) — window shell API
