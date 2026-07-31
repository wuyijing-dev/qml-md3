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
#include <QFontInfo>
#include <QFile>
#include <QFileInfo>
#include <QUrl>
#include <QDebug>
#include <QSet>
#include <QCoreApplication>

#if defined(Q_OS_WIN)
#  include <windows.h>
extern "C" __declspec(dllimport) HRESULT WINAPI
SetCurrentProcessExplicitAppUserModelID(PCWSTR appId);
#  ifndef DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE_V2
#    define DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE_V2 ((DPI_AWARENESS_CONTEXT)-4)
#  endif
#endif

// From qt_add_resources(Md3 "md3_fonts" / "md3_icons" …) — forces registration
// even if the static qml-module resource object was not pulled into the link.
static void ensureMd3FontResources()
{
    Q_INIT_RESOURCE(md3_fonts);
}

static void ensureMd3IconResources()
{
    Q_INIT_RESOURCE(md3_icons);
}

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

static bool addFontFile(const QString &path)
{
    if (!QFile::exists(path))
        return false;
    const int id = QFontDatabase::addApplicationFont(path);
    if (id < 0) {
        qWarning("Md3: addApplicationFont failed for %s", qPrintable(path));
        return false;
    }
    const QStringList fams = QFontDatabase::applicationFontFamilies(id);
    qInfo("Md3: loaded font %s → %s", qPrintable(path),
          qPrintable(fams.join(QLatin1String(", "))));
    return true;
}

static bool loadOneFont(const QString &file, const QStringList &dirs, QSet<QString> *got)
{
    if (got->contains(file))
        return true;
    for (const QString &dir : dirs) {
        if (addFontFile(dir + file)) {
            got->insert(file);
            return true;
        }
    }
    return false;
}

namespace {

constexpr QLatin1StringView kUiFontFamily("HarmonyOS Sans SC");

} // namespace

int loadFonts()
{
    static int cached = -1;
    if (cached >= 0)
        return cached;

    ensureMd3FontResources();
    ensureMd3IconResources();

    // Required: Regular. Optional Medium/Bold if bundled or placed under app fonts/.
    static const QStringList uiRequired = {
        QStringLiteral("HarmonyOS_SansSC_Regular.ttf"),
    };
    static const QStringList uiOptional = {
        QStringLiteral("HarmonyOS_SansSC_Medium.ttf"),
        QStringLiteral("HarmonyOS_SansSC_Bold.ttf"),
    };
    static const QStringList iconFiles = {
        QStringLiteral("MaterialIcons-Regular.ttf"),
        QStringLiteral("MaterialIconsOutlined-Regular.otf"),
    };

    QStringList dirs = {
        QStringLiteral(":/md3/fonts/resources/fonts/"),
        QStringLiteral(":/qt/qml/Md3/resources/fonts/"),
        QStringLiteral(":/Md3/resources/fonts/"),
        QStringLiteral(":/resources/fonts/"),
        QStringLiteral(":/md3/fonts/"),
    };

    if (QCoreApplication::instance()) {
        const QString appDir = QCoreApplication::applicationDirPath();
        dirs << appDir + QStringLiteral("/fonts/")
             << appDir + QStringLiteral("/../resources/fonts/")
             << appDir + QStringLiteral("/../../resources/fonts/")
             << appDir + QStringLiteral("/../src/Md3/resources/fonts/")
             << appDir + QStringLiteral("/../../src/Md3/resources/fonts/");
    }

    QSet<QString> got;
    int loaded = 0;

    // UI Regular first, then optional weights — before Material Icons.
    for (const QString &file : uiRequired) {
        if (loadOneFont(file, dirs, &got))
            ++loaded;
    }
    for (const QString &file : uiOptional) {
        if (loadOneFont(file, dirs, &got))
            ++loaded;
    }

    const QString uiFamily = QString(kUiFontFamily);
    const bool hasUiFont = QFontDatabase::families().contains(uiFamily);
    if (!hasUiFont) {
        qWarning("Md3: %s failed to load (%d files ok). Using system UI font.",
                 qPrintable(uiFamily), loaded);
    }

    QStringList families;
    if (hasUiFont)
        families << uiFamily;
#if defined(Q_OS_WIN)
    families << QStringLiteral("Segoe UI")
             << QStringLiteral("Microsoft YaHei UI");
#elif defined(Q_OS_MACOS)
    families << QStringLiteral("PingFang SC")
             << QStringLiteral("Helvetica Neue");
#else
    families << QStringLiteral("Noto Sans CJK SC")
             << QStringLiteral("WenQuanYi Micro Hei")
             << QStringLiteral("DejaVu Sans");
#endif
    families << QStringLiteral("Sans Serif");

    QFont font;
#if QT_VERSION >= QT_VERSION_CHECK(6, 0, 0)
    font.setFamilies(families);
#else
    if (!families.isEmpty())
        font.setFamily(families.first());
#endif
    font.setStyleHint(QFont::SansSerif);
    font.setStyleStrategy(QFont::PreferAntialias);
    // NoHinting + Qt distance-field text: smoother edges than Native+VerticalHinting.
    font.setHintingPreference(QFont::PreferNoHinting);
    QGuiApplication::setFont(font);

#if QT_VERSION >= QT_VERSION_CHECK(6, 8, 0)
    if (hasUiFont) {
        QFontDatabase::addApplicationFallbackFontFamily(QChar::Script_Han, uiFamily);
        QFontDatabase::addApplicationFallbackFontFamily(QChar::Script_Latin, uiFamily);
    }
#endif

    {
        QFont probe(hasUiFont ? uiFamily : families.value(0));
        probe.setStyleStrategy(QFont::PreferAntialias);
        const QFontInfo info(probe);
        qInfo("Md3: probe family=\"%s\" style=\"%s\"",
              qPrintable(info.family()), qPrintable(info.styleName()));
    }

    for (const QString &file : iconFiles) {
        if (loadOneFont(file, dirs, &got))
            ++loaded;
    }

    // QtRendering (distance field) anti-aliases better than Native on GPU UIs.
    QQuickWindow::setTextRenderType(QQuickWindow::QtTextRendering);

    qInfo("Md3: loadFonts done, %d faces, hasUiFont=%d, appFont=%s",
          loaded, int(hasUiFont),
          qPrintable(QGuiApplication::font().families().join(QLatin1Char(','))));

    cached = loaded;
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

#if defined(Q_OS_LINUX)
    {
        QString desk = opts.desktopFileName;
        if (desk.isEmpty())
            desk = opts.applicationName;
        // Sanitize: D-Bus object paths reject spaces (e.g. "Md3 Gallery").
        QString safe;
        for (QChar c : desk.trimmed()) {
            const ushort u = c.unicode();
            if ((u >= 'A' && u <= 'Z') || (u >= 'a' && u <= 'z') || (u >= '0' && u <= '9'))
                safe.append(c);
            else
                safe.append(QLatin1Char('_'));
        }
        while (safe.contains(QLatin1String("__")))
            safe.replace(QLatin1String("__"), QLatin1String("_"));
        while (safe.startsWith(QLatin1Char('_')))
            safe.remove(0, 1);
        while (safe.endsWith(QLatin1Char('_')))
            safe.chop(1);
        if (safe.isEmpty())
            safe = QStringLiteral("Md3_App");
        QGuiApplication::setDesktopFileName(safe);
    }
#endif

    if (opts.loadFonts)
        loadFonts();
    else
        ensureMd3IconResources();
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
    if (QCoreApplication::instance()) {
        engine.addImportPath(QCoreApplication::applicationDirPath() + QStringLiteral("/qml"));
    }
    for (const QString &p : opts.qmlImportPaths) {
        if (!p.isEmpty())
            engine.addImportPath(p);
    }
    // Re-run after the engine exists so late-registered qml-module qrcs are seen.
    if (opts.loadFonts)
        loadFonts();

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    const QString diskMain = QCoreApplication::instance()
            ? QCoreApplication::applicationDirPath()
              + QLatin1Char('/')
              + moduleUri
              + QLatin1Char('/')
              + mainComponent
              + QStringLiteral(".qml")
            : QString();
    if (QFile::exists(diskMain)) {
        engine.load(QUrl::fromLocalFile(diskMain));
    } else {
#if QT_VERSION >= QT_VERSION_CHECK(6, 0, 0)
        engine.loadFromModule(moduleUri, mainComponent);
#else
        const QString qrcMain = QStringLiteral("qrc:/")
                + moduleUri
                + QLatin1Char('/')
                + mainComponent
                + QStringLiteral(".qml");
        engine.load(QUrl(qrcMain));
#endif
    }
    if (engine.rootObjects().isEmpty())
        return 1;
    return app.exec();
}

int runQmlFile(int argc, char **argv, const QString &qmlFile, const RunOptions &opts)
{
    applyEarly(argc, argv, opts);

#if defined(Q_OS_LINUX)
    QApplication app(argc, argv);
#else
    QGuiApplication app(argc, argv);
#endif

    initialize(app, opts);

    QQmlApplicationEngine engine;
    if (QCoreApplication::instance()) {
        engine.addImportPath(QCoreApplication::applicationDirPath() + QStringLiteral("/qml"));
        const QFileInfo fi(qmlFile);
        if (fi.exists())
            engine.addImportPath(fi.absolutePath());
    }
    for (const QString &p : opts.qmlImportPaths) {
        if (!p.isEmpty())
            engine.addImportPath(p);
    }
    if (opts.loadFonts)
        loadFonts();

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.load(QUrl::fromLocalFile(qmlFile));
    if (engine.rootObjects().isEmpty())
        return 1;
    return app.exec();
}

} // namespace Md3
