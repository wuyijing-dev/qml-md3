#include "md3windowhelper.h"
#include "md3linux_p.h"

#include <QGuiApplication>
#include <QIcon>
#include <QMetaObject>
#include <QSystemTrayIcon>
#include <QWindow>

bool Md3WindowHelper::showSystemTrayIcon(QObject *window, const QUrl &iconUrl, const QString &tooltip)
{
    Q_UNUSED(window);
    if (!QSystemTrayIcon::isSystemTrayAvailable())
        return false;

    const QString path = Md3Linux::resolveIconPath(iconUrl);
    QIcon icon(path);
    if (icon.isNull())
        icon = QGuiApplication::windowIcon();
    if (icon.isNull())
        return false;

    if (!m_linuxTray) {
        auto *tray = new QSystemTrayIcon();
        m_linuxTray = tray;
        QObject::connect(tray, &QSystemTrayIcon::activated, this,
                         [this](QSystemTrayIcon::ActivationReason reason) {
            int mapped = TrayUnknown;
            switch (reason) {
            case QSystemTrayIcon::Trigger: mapped = TrayLeftClick; break;
            case QSystemTrayIcon::DoubleClick: mapped = TrayLeftDoubleClick; break;
            case QSystemTrayIcon::Context: mapped = TrayRightClick; break;
            case QSystemTrayIcon::MiddleClick: mapped = TrayMiddleClick; break;
            default: break;
            }
            emit trayActivated(mapped);
        });
        QObject::connect(tray, &QSystemTrayIcon::messageClicked, this, [this]() {
            emit trayActivated(TrayBalloonClicked);
        });
    }

    auto *tray = static_cast<QSystemTrayIcon *>(m_linuxTray);
    tray->setIcon(icon);
    tray->setToolTip(tooltip);
    tray->show();
    return true;
}

void Md3WindowHelper::hideSystemTrayIcon()
{
    if (!m_linuxTray)
        return;
    auto *tray = static_cast<QSystemTrayIcon *>(m_linuxTray);
    tray->hide();
    delete tray;
    m_linuxTray = nullptr;
}

bool Md3WindowHelper::showTrayNotification(const QString &title, const QString &body, int timeoutMs)
{
    if (m_linuxTray) {
        auto *tray = static_cast<QSystemTrayIcon *>(m_linuxTray);
        if (tray->isVisible()) {
            tray->showMessage(title, body, QSystemTrayIcon::Information,
                              timeoutMs < 0 ? 5000 : timeoutMs);
            emit trayActivated(TrayBalloonShown);
            return true;
        }
    }
    // Fallback: freedesktop Notifications (works without a tray icon).
    return Md3Linux::notify(title, body, timeoutMs < 0 ? 5000 : timeoutMs) != 0;
}
