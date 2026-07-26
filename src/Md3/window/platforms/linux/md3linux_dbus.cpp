#include "md3linux_p.h"

#include <QGuiApplication>
#include <QUrl>
#include <QWindow>

#include <QDBusConnection>
#include <QDBusMessage>
#include <QDBusInterface>
#include <QDBusReply>
#include <QVariantMap>

namespace Md3Linux {
namespace {

QString &desktopIdStorage()
{
    static QString id = QStringLiteral("appQML_MD3");
    return id;
}

} // namespace

QString desktopFileId()
{
    return desktopIdStorage();
}

void setDesktopFileId(const QString &id)
{
    QString clean = id.trimmed();
    if (clean.endsWith(QLatin1String(".desktop")))
        clean.chop(8);
    if (clean.isEmpty())
        return;
    desktopIdStorage() = clean;
    QGuiApplication::setDesktopFileName(clean);
}

void emitLauncherUpdate(const QVariantMap &properties)
{
    if (!QDBusConnection::sessionBus().isConnected())
        return;

    const QString appUri = QStringLiteral("application://%1.desktop").arg(desktopFileId());
    QDBusMessage signal = QDBusMessage::createSignal(
        QStringLiteral("/com/canonical/unity/launcherentry/%1").arg(desktopFileId()),
        QStringLiteral("com.canonical.Unity.LauncherEntry"),
        QStringLiteral("Update"));
    signal << appUri << properties;
    QDBusConnection::sessionBus().send(signal);
}

uint notify(const QString &title, const QString &body, int timeoutMs, const QString &iconName)
{
    if (!QDBusConnection::sessionBus().isConnected())
        return 0;

    QDBusInterface iface(QStringLiteral("org.freedesktop.Notifications"),
                         QStringLiteral("/org/freedesktop/Notifications"),
                         QStringLiteral("org.freedesktop.Notifications"),
                         QDBusConnection::sessionBus());
    if (!iface.isValid())
        return 0;

    const QString appName = QGuiApplication::applicationName().isEmpty()
            ? QStringLiteral("Md3")
            : QGuiApplication::applicationName();

    QDBusReply<uint> reply = iface.call(
        QStringLiteral("Notify"),
        appName,
        uint(0),
        iconName,
        title,
        body,
        QStringList(),
        QVariantMap(),
        timeoutMs);
    return reply.isValid() ? reply.value() : 0;
}

QString resolveIconPath(const QUrl &iconUrl)
{
    if (!iconUrl.isValid())
        return {};
    QString path = iconUrl.toLocalFile();
    if (path.isEmpty()) {
        if (iconUrl.scheme() == QLatin1String("qrc"))
            path = QLatin1Char(':') + iconUrl.path();
        else
            path = iconUrl.toString();
    }
    return path;
}

void applyBlurHint(QWindow *window, bool enable)
{
    if (!window)
        return;
    // Best-effort hints for KWin / compositor blur rules (X11 + some Wayland clients).
    window->setProperty("_KDE_NET_WM_BLUR_BEHIND_REGION", enable);
    window->setProperty("KWinForceBlur", enable);
    window->setProperty("_md3_blurBehind", enable);
}

} // namespace Md3Linux
