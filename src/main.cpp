#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QQuickWindow>
#include <QFontDatabase>
#include <QFont>
#include <QFile>
#include <QDir>
#include <QTextStream>
#include <QDebug>

#if defined(Q_OS_WIN)
#  include <windows.h>
// Declared in shobjidl.h / exported from shell32 — avoid pulling COM headers into main.
extern "C" __declspec(dllimport) HRESULT WINAPI
SetCurrentProcessExplicitAppUserModelID(PCWSTR appId);
#  ifndef DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE_V2
#    define DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE_V2 ((DPI_AWARENESS_CONTEXT)-4)
#  endif
#endif

static QString fontLogPath()
{
    return QDir::temp().filePath(QStringLiteral("md3-fonts.log"));
}

static void fontLog(const QString &line)
{
    QFile f(fontLogPath());
    if (f.open(QIODevice::WriteOnly | QIODevice::Append | QIODevice::Text)) {
        QTextStream out(&f);
        out << line << '\n';
    }
    qInfo("%s", qPrintable(line));
}

static int tryLoadFontFile(const QString &path)
{
    if (!QFile::exists(path))
        return -1;
    const int id = QFontDatabase::addApplicationFont(path);
    if (id < 0) {
        fontLog(QStringLiteral("FAIL addApplicationFont: %1").arg(path));
        return -1;
    }
    const QStringList families = QFontDatabase::applicationFontFamilies(id);
    fontLog(QStringLiteral("OK %1 -> %2").arg(path, families.join(QLatin1Char(','))));
    return id;
}

static int loadFontsFromDir(const QString &dir, const QStringList &files)
{
    int loaded = 0;
    for (const QString &file : files) {
        if (tryLoadFontFile(dir + file) >= 0)
            ++loaded;
    }
    return loaded;
}

static void loadMd3Fonts()
{
    QFile::remove(fontLogPath());
    fontLog(QStringLiteral("Md3 font loader starting"));

    const QStringList files = {
        QStringLiteral("Roboto-Regular.ttf"),
        QStringLiteral("Roboto-Medium.ttf"),
        QStringLiteral("Roboto-Bold.ttf"),
        QStringLiteral("MaterialIcons-Regular.ttf"),
        QStringLiteral("MaterialIconsOutlined-Regular.otf"),
    };

    // 1) Executable-owned qrc (registered with the app, available immediately)
    // 2) Files copied next to the Md3 QML module
    // 3) Md3 module qrc (may be late/stripped for static libs)
    const QStringList dirs = {
        QStringLiteral(":/md3/fonts/"),
        QCoreApplication::applicationDirPath() + QStringLiteral("/Md3/resources/fonts/"),
        QStringLiteral(":/qt/qml/Md3/resources/fonts/"),
        QStringLiteral(":/Md3/resources/fonts/"),
        QStringLiteral(":/resources/fonts/"),
    };

    int loaded = 0;
    for (const QString &dir : dirs) {
        const int n = loadFontsFromDir(dir, files);
        if (n > 0) {
            loaded = n;
            fontLog(QStringLiteral("Using font dir: %1 (%2 files)").arg(dir).arg(n));
            break;
        }
    }

    const QStringList families = QFontDatabase::families();
    const bool hasRoboto = families.contains(QStringLiteral("Roboto"));
    const bool hasIcons = families.contains(QStringLiteral("Material Icons"));
    const bool hasOutlined = families.contains(QStringLiteral("Material Icons Outlined"));
    fontLog(QStringLiteral("hasRoboto=%1 hasIcons=%2 hasOutlined=%3 loaded=%4")
                .arg(hasRoboto)
                .arg(hasIcons)
                .arg(hasOutlined)
                .arg(loaded));

    if (hasRoboto) {
        QFont font(QStringLiteral("Roboto"));
        font.setStyleStrategy(QFont::PreferAntialias);
        font.setHintingPreference(QFont::PreferFullHinting);
        QGuiApplication::setFont(font);
    } else {
        fontLog(QStringLiteral("WARNING: Roboto not registered; UI will use system default"));
    }
}

int main(int argc, char *argv[])
{
#if defined(Q_OS_WIN)
    // Prefer Per-Monitor V2 before QGuiApplication (manifest also embeds this).
    using SetDpiCtxFn = BOOL (WINAPI *)(DPI_AWARENESS_CONTEXT);
    if (HMODULE user32 = GetModuleHandleW(L"user32.dll")) {
        if (auto setDpi = reinterpret_cast<SetDpiCtxFn>(
                GetProcAddress(user32, "SetProcessDpiAwarenessContext")))
            setDpi(DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE_V2);
    }
#endif

    // Required for Win11 Mica/Acrylic (and rounded transparent frames) to composite
    // under the Qt Quick scene — must be set before the first QQuickWindow.
    QQuickWindow::setDefaultAlphaBuffer(true);

#if defined(Q_OS_WIN)
    // Stable taskbar / jump-list identity for the Gallery (before any HWND)
    SetCurrentProcessExplicitAppUserModelID(L"QML_MD3.Md3Gallery");
#endif

    QGuiApplication app(argc, argv);
    QCoreApplication::setOrganizationName(QStringLiteral("QML_MD3"));
    QCoreApplication::setApplicationName(QStringLiteral("Md3 Gallery"));
    QCoreApplication::setApplicationVersion(QStringLiteral("0.1.0"));

    QQuickStyle::setStyle(QStringLiteral("Basic"));
    loadMd3Fonts();

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.loadFromModule("Gallery", "Main");
    return app.exec();
}
