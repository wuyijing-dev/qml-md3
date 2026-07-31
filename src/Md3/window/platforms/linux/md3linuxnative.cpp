#include "md3windowhelper.h"
#include "md3linux_p.h"

#include <QCoreApplication>
#include <QGuiApplication>
#include <QHash>
#include <QIcon>
#include <QMenu>
#include <QProcess>
#include <QQuickWindow>
#include <QScreen>
#include <QStyleHints>
#include <QWindow>

// Linux / Wayland / X11 — CMake UNIX && !APPLE only.

namespace {

QString readProcessTrimmed(const QString &program, const QStringList &args)
{
    QProcess p;
    p.setProcessChannelMode(QProcess::MergedChannels);
    p.start(program, args, QIODevice::ReadOnly);
    if (!p.waitForFinished(800)) {
        p.kill();
        return {};
    }
    return QString::fromUtf8(p.readAllStandardOutput()).trimmed();
}

Qt::WindowStates toggleMaximized(QWindow *qw)
{
    if (!qw)
        return {};
    if (qw->windowStates() & Qt::WindowMaximized)
        qw->showNormal();
    else
        qw->showMaximized();
    return qw->windowStates();
}

} // namespace

void Md3WindowHelper::shutdownNative()
{
    hideSystemTrayIcon();
}

void Md3WindowHelper::bindWindow(QObject *window)
{
    auto *qw = qobject_cast<QWindow *>(window);
    if (!qw)
        return;
    // Prefer explicit desktop id; never use display name (spaces break D-Bus paths).
    if (!QGuiApplication::desktopFileName().isEmpty()) {
        Md3Linux::setDesktopFileId(QGuiApplication::desktopFileName());
    } else {
        const QString fallback = QCoreApplication::applicationName().isEmpty()
                ? QStringLiteral("appQML_MD3")
                : QCoreApplication::applicationName().replace(QLatin1Char(' '), QLatin1Char('_'));
        QGuiApplication::setDesktopFileName(fallback);
        Md3Linux::setDesktopFileId(fallback);
    }
    applyCornerPreference(qw, true);
    qw->requestActivate();
}

void Md3WindowHelper::unbindWindow(QObject *) {}

void Md3WindowHelper::setMaximizeButtonRect(QObject *, qreal, qreal, qreal, qreal) {}
void Md3WindowHelper::clearMaximizeButtonRect(QObject *) {}
void Md3WindowHelper::setSnapMaximizeRect(QObject *, qreal, qreal, qreal, qreal) {}
void Md3WindowHelper::clearSnapMaximizeRect(QObject *) {}
void Md3WindowHelper::setSnapLayoutsArmed(QObject *, bool) {}
void Md3WindowHelper::setCaptionHitRect(QObject *, qreal, qreal, qreal, qreal) {}
void Md3WindowHelper::clearCaptionHitRect(QObject *) {}

void Md3WindowHelper::applyCornerPreference(QObject *window, bool rounded)
{
    auto *qw = qobject_cast<QWindow *>(window);
    if (qw)
        qw->setProperty("_md3_cornerRounded", rounded);
}

void Md3WindowHelper::showSystemMenu(QObject *window, qreal globalX, qreal globalY)
{
    auto *qw = qobject_cast<QWindow *>(window);
    if (!qw)
        return;

    QMenu menu;
    menu.addAction(QObject::tr("Minimize"), qw, [qw] { qw->showMinimized(); });
    const bool maximized = qw->windowStates() & Qt::WindowMaximized;
    menu.addAction(maximized ? QObject::tr("Restore") : QObject::tr("Maximize"),
                   qw, [qw] { toggleMaximized(qw); });
    const bool fullscreen = qw->windowStates() & Qt::WindowFullScreen;
    menu.addAction(fullscreen ? QObject::tr("Exit Full Screen") : QObject::tr("Full Screen"),
                   qw, [qw, fullscreen] {
        if (fullscreen)
            qw->showNormal();
        else
            qw->showFullScreen();
    });
    menu.addSeparator();
    QAction *pin = menu.addAction(QObject::tr("Always on Top"));
    pin->setCheckable(true);
    pin->setChecked(qw->flags() & Qt::WindowStaysOnTopHint);
    QObject::connect(pin, &QAction::toggled, qw, [qw](bool on) {
        qw->setFlag(Qt::WindowStaysOnTopHint, on);
    });
    menu.addSeparator();
    menu.addAction(QObject::tr("Close"), qw, [qw] { qw->close(); });
    menu.exec(QPoint(qRound(globalX), qRound(globalY)));
}

void Md3WindowHelper::setImmersiveDarkMode(QObject *window, bool dark)
{
    Q_UNUSED(window);
    if (auto *hints = QGuiApplication::styleHints())
        hints->setColorScheme(dark ? Qt::ColorScheme::Dark : Qt::ColorScheme::Light);
}

void Md3WindowHelper::setSystemBackdrop(QObject *window, int backdrop)
{
    auto *qw = qobject_cast<QWindow *>(window);
    if (!qw)
        return;
    qw->setProperty("_md3_waylandBackdrop", backdrop);
    const bool soft = backdrop > 0;
    if (auto *quick = qobject_cast<QQuickWindow *>(qw)) {
        if (soft)
            quick->setColor(Qt::transparent);
    }
    reportNativeStatus(Md3Linux::applyBlurBehind(qw, soft));
}

void Md3WindowHelper::setAlwaysOnTop(QObject *window, bool onTop)
{
    auto *qw = qobject_cast<QWindow *>(window);
    if (!qw)
        return;
    reportNativeStatus(Md3Linux::setKeepAbove(qw, onTop));
}

void Md3WindowHelper::flashTaskbar(QObject *window, bool flash)
{
    auto *qw = qobject_cast<QWindow *>(window);
    if (!qw)
        return;
    reportNativeStatus(Md3Linux::requestAttention(qw, flash));
}

void Md3WindowHelper::setBorderColor(QObject *window, const QString &cssColor)
{
    if (auto *qw = qobject_cast<QWindow *>(window))
        qw->setProperty("_md3_borderColor", cssColor);
}

void Md3WindowHelper::setCaptionTextColor(QObject *window, const QString &cssColor)
{
    if (auto *qw = qobject_cast<QWindow *>(window))
        qw->setProperty("_md3_captionTextColor", cssColor);
}

void Md3WindowHelper::setExcludedFromPeek(QObject *window, bool excluded)
{
    if (auto *qw = qobject_cast<QWindow *>(window))
        qw->setProperty("_md3_excludePeek", excluded);
}

void Md3WindowHelper::setDisallowPeek(QObject *window, bool disallow)
{
    if (auto *qw = qobject_cast<QWindow *>(window))
        qw->setProperty("_md3_disallowPeek", disallow);
}

void Md3WindowHelper::setExcludeFromCapture(QObject *window, bool exclude)
{
    if (auto *qw = qobject_cast<QWindow *>(window))
        qw->setProperty("_md3_excludeFromCapture", exclude);
}

void Md3WindowHelper::setWindowCloaked(QObject *, bool) {}

void Md3WindowHelper::setPreferredAppMode(bool dark)
{
    if (auto *hints = QGuiApplication::styleHints())
        hints->setColorScheme(dark ? Qt::ColorScheme::Dark : Qt::ColorScheme::Light);
}

QString Md3WindowHelper::systemAccentColor() const
{
    QString v = readProcessTrimmed(QStringLiteral("gsettings"),
                                   {QStringLiteral("get"),
                                    QStringLiteral("org.gnome.desktop.interface"),
                                    QStringLiteral("accent-color")});
    if (v.startsWith(QLatin1Char('\'')) && v.endsWith(QLatin1Char('\'')))
        v = v.mid(1, v.size() - 2);
    if (v.startsWith(QLatin1Char('#')) && v.size() >= 7)
        return v.left(7);

    // GNOME 46+ may return named accents — map a few common ones.
    static const QHash<QString, QString> named{
        {QStringLiteral("blue"), QStringLiteral("#3584e4")},
        {QStringLiteral("teal"), QStringLiteral("#2190a4")},
        {QStringLiteral("green"), QStringLiteral("#3a944a")},
        {QStringLiteral("yellow"), QStringLiteral("#c88800")},
        {QStringLiteral("orange"), QStringLiteral("#ed5b00")},
        {QStringLiteral("red"), QStringLiteral("#e62d42")},
        {QStringLiteral("pink"), QStringLiteral("#d56199")},
        {QStringLiteral("purple"), QStringLiteral("#9141ac")},
        {QStringLiteral("slate"), QStringLiteral("#6f8396")},
    };
    if (named.contains(v))
        return named.value(v);

    const QString kde = readProcessTrimmed(
        QStringLiteral("kreadconfig5"),
        {QStringLiteral("--file"), QStringLiteral("kdeglobals"),
         QStringLiteral("--group"), QStringLiteral("General"),
         QStringLiteral("--key"), QStringLiteral("AccentColor")});
    if (kde.contains(QLatin1Char(','))) {
        const QStringList parts = kde.split(QLatin1Char(','));
        if (parts.size() >= 3) {
            return QStringLiteral("#%1%2%3")
                .arg(parts[0].trimmed().toInt(), 2, 16, QLatin1Char('0'))
                .arg(parts[1].trimmed().toInt(), 2, 16, QLatin1Char('0'))
                .arg(parts[2].trimmed().toInt(), 2, 16, QLatin1Char('0'));
        }
    }

    // Plasma 6
    const QString kde6 = readProcessTrimmed(
        QStringLiteral("kreadconfig6"),
        {QStringLiteral("--file"), QStringLiteral("kdeglobals"),
         QStringLiteral("--group"), QStringLiteral("General"),
         QStringLiteral("--key"), QStringLiteral("AccentColor")});
    if (kde6.contains(QLatin1Char(','))) {
        const QStringList parts = kde6.split(QLatin1Char(','));
        if (parts.size() >= 3) {
            return QStringLiteral("#%1%2%3")
                .arg(parts[0].trimmed().toInt(), 2, 16, QLatin1Char('0'))
                .arg(parts[1].trimmed().toInt(), 2, 16, QLatin1Char('0'))
                .arg(parts[2].trimmed().toInt(), 2, 16, QLatin1Char('0'));
        }
    }
    return QStringLiteral("#6750A4");
}

QString Md3WindowHelper::wallpaperSeedColor() const
{
    return systemAccentColor();
}

int Md3WindowHelper::monitorCount() const
{
    return QGuiApplication::screens().size();
}

bool Md3WindowHelper::moveToMonitor(QObject *window, int monitorIndex)
{
    auto *qw = qobject_cast<QWindow *>(window);
    const QList<QScreen *> screens = QGuiApplication::screens();
    if (!qw || monitorIndex < 0 || monitorIndex >= screens.size())
        return false;
    QScreen *screen = screens.at(monitorIndex);
    const QRect ag = screen->availableGeometry();
    qw->setScreen(screen);
    // Wayland compositors may ignore absolute positioning; still request it.
    qw->setPosition(ag.x() + (ag.width() - qw->width()) / 2,
                    ag.y() + (ag.height() - qw->height()) / 2);
    return true;
}

bool Md3WindowHelper::setWindowIcon(QObject *window, const QUrl &iconUrl)
{
    auto *qw = qobject_cast<QWindow *>(window);
    if (!qw || !iconUrl.isValid())
        return false;
    const QString path = Md3Linux::resolveIconPath(iconUrl);
    const QIcon icon(path);
    if (icon.isNull())
        return false;
    qw->setIcon(icon);
    QGuiApplication::setWindowIcon(icon);
    return true;
}