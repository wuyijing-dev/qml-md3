#include "md3.h"
#include "md3graphics.h"

#if defined(Q_OS_LINUX)
#  include <QApplication>
#else
#  include <QGuiApplication>
#endif
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QQuickWindow>
#include <QFontDatabase>
#include <QFont>
#include <QFile>
#include <QCoreApplication>

#if defined(Q_OS_WIN)
#  include <windows.h>
extern "C" __declspec(dllimport) HRESULT WINAPI
SetCurrentProcessExplicitAppUserModelID(PCWSTR appId);
#  ifndef DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE_V2
#    define DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE_V2 ((DPI_AWARENESS_CONTEXT)-4)
#  endif
#endif

namespace Md3 {

void applyEarly(int &argc, char **argv, const RunOptions &opts)
{
#if defined(Q_OS_WIN)
    using SetDpiCtxFn = BOOL (WINAPI *)(DPI_AWARENESS_CONTEXT);
    if (HMODULE user32 = GetModuleHandleW(L"user32.dll")) {
        if (auto setDpi = reinterpret_cast<SetDpiCtxFn>(
                GetProcAddress(user32, "SetProcessDpiAwarenessContext")))
            setDpi(DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE_V2);
    }
    if (!opts.appUserModelId.isEmpty()) {
        SetCurrentProcessExplicitAppUserModelID(
            reinterpret_cast<LPCWSTR>(opts.appUserModelId.utf16()));
    }
#endif

    if (opts.alphaBuffer)
        QQuickWindow::setDefaultAlphaBuffer(true);

    Md3Graphics::applyEarly(argc, argv);
}

int loadFonts()
{
    static const QStringList files = {
        QStringLiteral("Roboto-Regular.ttf"),
        QStringLiteral("Roboto-Medium.ttf"),
        QStringLiteral("Roboto-Bold.ttf"),
        QStringLiteral("MaterialIcons-Regular.ttf"),
        QStringLiteral("MaterialIconsOutlined-Regular.otf"),
    };
    static const QStringList dirs = {
        QStringLiteral(":/qt/qml/Md3/resources/fonts/"),
        QStringLiteral(":/Md3/resources/fonts/"),
        QStringLiteral(":/resources/fonts/"),
        QStringLiteral(":/md3/fonts/"),
    };

    int loaded = 0;
    for (const QString &dir : dirs) {
        int n = 0;
        for (const QString &file : files) {
            const QString path = dir + file;
            if (QFile::exists(path) && QFontDatabase::addApplicationFont(path) >= 0)
                ++n;
        }
        if (n > 0) {
            loaded = n;
            break;
        }
    }

    if (QFontDatabase::families().contains(QStringLiteral("Roboto"))) {
        QFont font(QStringLiteral("Roboto"));
        font.setStyleStrategy(QFont::PreferAntialias);
        font.setHintingPreference(QFont::PreferFullHinting);
        QGuiApplication::setFont(font);
    }
    return loaded;
}

void initialize(QCoreApplication &app, const RunOptions &opts)
{
    Q_UNUSED(app)
    if (!opts.organization.isEmpty())
        QCoreApplication::setOrganizationName(opts.organization);
    if (!opts.applicationName.isEmpty())
        QCoreApplication::setApplicationName(opts.applicationName);
    if (!opts.applicationVersion.isEmpty())
        QCoreApplication::setApplicationVersion(opts.applicationVersion);

    if (!opts.style.isEmpty())
        QQuickStyle::setStyle(opts.style);

    if (opts.loadFonts)
        loadFonts();
}

int run(int argc, char **argv,
        const QString &moduleUri,
        const QString &mainComponent,
        const RunOptions &opts)
{
    applyEarly(argc, argv, opts);

#if defined(Q_OS_LINUX)
    QApplication app(argc, argv);
#else
    QGuiApplication app(argc, argv);
#endif

    initialize(app, opts);

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.loadFromModule(moduleUri, mainComponent);
    return app.exec();
}

} // namespace Md3
