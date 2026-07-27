#include "md3linux_p.h"

#include <QGuiApplication>
#include <QUrl>
#include <QWindow>

#include <QDBusConnection>
#include <QDBusMessage>
#include <QDBusInterface>
#include <QDBusObjectPath>
#include <QDBusReply>
#include <QVariantMap>
#include <QDebug>

namespace Md3Linux {
namespace {

QString &desktopIdStorage()
{
    static QString id = QStringLiteral("appQML_MD3");
    return id;
}

/// D-Bus object paths may only contain [A-Za-z0-9_].
QString sanitizeDbusPathElement(QString id)
{
    id = id.trimmed();
    if (id.endsWith(QLatin1String(".desktop")))
        id.chop(8);
    QString out;
    out.reserve(id.size());
    for (QChar c : id) {
        // Strict: only ASCII letters/digits → keep; everything else → '_'
        // (spaces in "Md3 Gallery" must never reach the object path).
        const ushort u = c.unicode();
        if ((u >= 'A' && u <= 'Z') || (u >= 'a' && u <= 'z') || (u >= '0' && u <= '9'))
            out.append(c);
        else
            out.append(QLatin1Char('_'));
    }
    while (out.contains(QLatin1String("__")))
        out.replace(QLatin1String("__"), QLatin1String("_"));
    while (out.startsWith(QLatin1Char('_')))
        out.remove(0, 1);
    while (out.endsWith(QLatin1Char('_')))
        out.chop(1);
    if (out.isEmpty() || !out.at(0).isLetter())
        out.prepend(QStringLiteral("app_"));
    return out;
}

bool isValidDbusObjectPath(const QString &path)
{
    if (path.isEmpty() || path == QLatin1String("/"))
        return false;
    if (!path.startsWith(QLatin1Char('/')))
        return false;
    if (path.endsWith(QLatin1Char('/')))
        return false;
    if (path.contains(QLatin1String("//")))
        return false;
    for (qsizetype i = 1; i < path.size(); ++i) {
        const ushort u = path.at(i).unicode();
        const bool ok = (u >= 'A' && u <= 'Z') || (u >= 'a' && u <= 'z')
                     || (u >= '0' && u <= '9') || u == '_' || u == '/';
        if (!ok)
            return false;
    }
    return true;
}

} // namespace

QString desktopFileId()
{
    return desktopIdStorage();
}

void setDesktopFileId(const QString &id)
{
    const QString safe = sanitizeDbusPathElement(id);
    if (safe.isEmpty())
        return;
    desktopIdStorage() = safe;
    // Keep a stable XDG desktop id (no spaces).
    QGuiApplication::setDesktopFileName(safe);
}

void emitLauncherUpdate(const QVariantMap &properties)
{
    if (!QDBusConnection::sessionBus().isConnected())
        return;

    // Prefer stored id; also sanitize applicationName fallbacks so "Md3 Gallery" never lands in the path.
    QString raw = desktopFileId();
    if (raw.isEmpty())
        raw = QGuiApplication::desktopFileName();
    if (raw.isEmpty())
        raw = QGuiApplication::applicationName();
    const QString id = sanitizeDbusPathElement(raw);
    if (id.isEmpty())
        return;
    // Keep storage + XDG id clean for subsequent calls.
    if (desktopIdStorage() != id)
        desktopIdStorage() = id;

    const QString appUri = QStringLiteral("application://%1.desktop").arg(id);
    const QString path = QStringLiteral("/com/canonical/unity/launcherentry/%1").arg(id);
    if (!isValidDbusObjectPath(path)) {
        qWarning("Md3: invalid Unity LauncherEntry path '%s' (skipped)", qPrintable(path));
        return;
    }
    QDBusMessage signal = QDBusMessage::createSignal(
        path,
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

QString setIdleInhibit(bool inhibit, const QString &reason, bool *ok)
{
    if (ok)
        *ok = false;
    if (!QDBusConnection::sessionBus().isConnected())
        return QStringLiteral("无会话总线，无法抑制空闲");

    static uint ssCookie = 0;
    static uint gnomeCookie = 0;
    static QString portalRequest;

    const QString appName = QGuiApplication::applicationName().isEmpty()
            ? QStringLiteral("Md3")
            : QGuiApplication::applicationName();
    const QString why = reason.isEmpty() ? QStringLiteral("Md3 idle inhibit") : reason;

    if (inhibit) {
        // 1) org.freedesktop.ScreenSaver
        {
            QDBusInterface iface(QStringLiteral("org.freedesktop.ScreenSaver"),
                                 QStringLiteral("/org/freedesktop/ScreenSaver"),
                                 QStringLiteral("org.freedesktop.ScreenSaver"),
                                 QDBusConnection::sessionBus());
            if (iface.isValid()) {
                QDBusReply<uint> reply = iface.call(QStringLiteral("Inhibit"), appName, why);
                if (reply.isValid()) {
                    ssCookie = reply.value();
                    if (ok) *ok = true;
                    return QStringLiteral("已抑制空闲（ScreenSaver cookie=%1）").arg(ssCookie);
                }
            }
        }
        // 2) GNOME SessionManager (flags: 8 = idle)
        {
            QDBusInterface iface(QStringLiteral("org.gnome.SessionManager"),
                                 QStringLiteral("/org/gnome/SessionManager"),
                                 QStringLiteral("org.gnome.SessionManager"),
                                 QDBusConnection::sessionBus());
            if (iface.isValid()) {
                QDBusReply<uint> reply = iface.call(QStringLiteral("Inhibit"),
                                                    appName, uint(0), why, uint(8));
                if (reply.isValid()) {
                    gnomeCookie = reply.value();
                    if (ok) *ok = true;
                    return QStringLiteral("已抑制空闲（GNOME SessionManager）");
                }
            }
        }
        // 3) xdg-desktop-portal Inhibit (flags 8 = idle)
        {
            QDBusInterface iface(QStringLiteral("org.freedesktop.portal.Desktop"),
                                 QStringLiteral("/org/freedesktop/portal/desktop"),
                                 QStringLiteral("org.freedesktop.portal.Inhibit"),
                                 QDBusConnection::sessionBus());
            if (iface.isValid()) {
                QVariantMap opts;
                opts.insert(QStringLiteral("reason"), why);
                QDBusReply<QDBusObjectPath> reply = iface.call(
                    QStringLiteral("Inhibit"),
                    desktopFileId(),
                    QString(), // window handle
                    why,
                    uint(8),
                    opts);
                if (reply.isValid()) {
                    portalRequest = reply.value().path();
                    if (ok) *ok = true;
                    return QStringLiteral("已抑制空闲（xdg-desktop-portal）");
                }
            }
        }
        return QStringLiteral("抑制失败：桌面未提供 ScreenSaver/SessionManager/Portal");
    }

    // Uninhibit
    bool cleared = false;
    if (ssCookie) {
        QDBusInterface iface(QStringLiteral("org.freedesktop.ScreenSaver"),
                             QStringLiteral("/org/freedesktop/ScreenSaver"),
                             QStringLiteral("org.freedesktop.ScreenSaver"),
                             QDBusConnection::sessionBus());
        if (iface.isValid())
            iface.call(QStringLiteral("UnInhibit"), ssCookie);
        ssCookie = 0;
        cleared = true;
    }
    if (gnomeCookie) {
        QDBusInterface iface(QStringLiteral("org.gnome.SessionManager"),
                             QStringLiteral("/org/gnome/SessionManager"),
                             QStringLiteral("org.gnome.SessionManager"),
                             QDBusConnection::sessionBus());
        if (iface.isValid())
            iface.call(QStringLiteral("Uninhibit"), gnomeCookie);
        gnomeCookie = 0;
        cleared = true;
    }
    if (!portalRequest.isEmpty()) {
        QDBusInterface iface(QStringLiteral("org.freedesktop.portal.Desktop"),
                             portalRequest,
                             QStringLiteral("org.freedesktop.portal.Request"),
                             QDBusConnection::sessionBus());
        if (iface.isValid())
            iface.call(QStringLiteral("Close"));
        portalRequest.clear();
        cleared = true;
    }
    if (ok) *ok = true;
    return cleared ? QStringLiteral("已允许空闲（已解除抑制）")
                   : QStringLiteral("当前没有活动的空闲抑制（请先点「禁止休眠」）");
}

} // namespace Md3Linux
