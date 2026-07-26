#include "md3windowhelper.h"

#include <QGuiApplication>
#include <QIcon>
#include <QProcess>
#include <QQuickWindow>
#include <QScreen>
#include <QStyleHints>
#include <QWindow>

// Linux / Wayland / X11 — compiled only via CMake on UNIX && !APPLE.

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

} // namespace

void Md3WindowHelper::shutdownNative() {}

void Md3WindowHelper::bindWindow(QObject *) {}
void Md3WindowHelper::unbindWindow(QObject *) {}
void Md3WindowHelper::setMaximizeButtonRect(QObject *, qreal, qreal, qreal, qreal) {}
void Md3WindowHelper::clearMaximizeButtonRect(QObject *) {}
void Md3WindowHelper::setCaptionHitRect(QObject *, qreal, qreal, qreal, qreal) {}
void Md3WindowHelper::clearCaptionHitRect(QObject *) {}

void Md3WindowHelper::applyCornerPreference(QObject *window, bool rounded)
{
    auto *qw = qobject_cast<QWindow *>(window);
    if (qw)
        qw->setProperty("_md3_cornerRounded", rounded);
}

void Md3WindowHelper::showSystemMenu(QObject *, qreal, qreal) {}

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
    if (backdrop > 0) {
        if (auto *quick = qobject_cast<QQuickWindow *>(qw))
            quick->setColor(Qt::transparent);
    }
}

void Md3WindowHelper::setBorderColor(QObject *, const QString &) {}
void Md3WindowHelper::setCaptionTextColor(QObject *, const QString &) {}
void Md3WindowHelper::setExcludedFromPeek(QObject *, bool) {}
void Md3WindowHelper::setDisallowPeek(QObject *, bool) {}
void Md3WindowHelper::setExcludeFromCapture(QObject *, bool) {}

void Md3WindowHelper::setAlwaysOnTop(QObject *window, bool onTop)
{
    if (auto *qw = qobject_cast<QWindow *>(window))
        qw->setFlag(Qt::WindowStaysOnTopHint, onTop);
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
    qw->setPosition(ag.x() + (ag.width() - qw->width()) / 2,
                    ag.y() + (ag.height() - qw->height()) / 2);
    return true;
}

void Md3WindowHelper::flashTaskbar(QObject *window, bool flash)
{
    if (auto *qw = qobject_cast<QWindow *>(window))
        qw->alert(flash ? 0 : -1);
}

bool Md3WindowHelper::setAppUserModelId(const QString &) { return false; }
void Md3WindowHelper::setTaskbarProgress(QObject *, qreal, int) {}
void Md3WindowHelper::clearTaskbarProgress(QObject *) {}
bool Md3WindowHelper::setTaskbarOverlayIcon(QObject *, const QUrl &, const QString &) { return false; }
void Md3WindowHelper::clearTaskbarOverlayIcon(QObject *) {}
void Md3WindowHelper::setThumbnailClip(QObject *, qreal, qreal, qreal, qreal) {}
void Md3WindowHelper::clearThumbnailClip(QObject *) {}
void Md3WindowHelper::setThumbnailTooltip(QObject *, const QString &) {}
bool Md3WindowHelper::registerApplicationRestart(const QString &) { return false; }
void Md3WindowHelper::unregisterApplicationRestart() {}
bool Md3WindowHelper::setJumpListTasks(const QVariantList &) { return false; }
void Md3WindowHelper::clearJumpList() {}
bool Md3WindowHelper::setThumbBarButtons(QObject *, const QVariantList &) { return false; }
void Md3WindowHelper::clearThumbBarButtons(QObject *) {}
void Md3WindowHelper::setForceIconicRepresentation(QObject *, bool) {}
bool Md3WindowHelper::setIconicThumbnail(QObject *, const QUrl &) { return false; }
void Md3WindowHelper::clearIconicThumbnail(QObject *) {}

bool Md3WindowHelper::setWindowIcon(QObject *window, const QUrl &iconUrl)
{
    auto *qw = qobject_cast<QWindow *>(window);
    if (!qw || !iconUrl.isValid())
        return false;
    QString path = iconUrl.toLocalFile();
    if (path.isEmpty()) {
        if (iconUrl.scheme() == QLatin1String("qrc"))
            path = QLatin1Char(':') + iconUrl.path();
        else
            path = iconUrl.toString();
    }
    const QIcon icon(path);
    if (icon.isNull())
        return false;
    qw->setIcon(icon);
    return true;
}

bool Md3WindowHelper::showSystemTrayIcon(QObject *, const QUrl &, const QString &) { return false; }
void Md3WindowHelper::hideSystemTrayIcon() {}
bool Md3WindowHelper::showTrayNotification(const QString &, const QString &, int) { return false; }
