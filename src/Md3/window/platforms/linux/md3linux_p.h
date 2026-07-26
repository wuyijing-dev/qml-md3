#pragma once

#include <QString>
#include <QUrl>
#include <QVariantMap>
#include <QtGlobal>

class QWindow;

namespace Md3Linux {

QString desktopFileId();
void setDesktopFileId(const QString &id);

/// Emit Unity/Plasma LauncherEntry Update (dock progress / badge / urgent).
void emitLauncherUpdate(const QVariantMap &properties);

/// org.freedesktop.Notifications.Notify — returns notification id or 0.
uint notify(const QString &title, const QString &body, int timeoutMs,
            const QString &iconName = QString());

QString resolveIconPath(const QUrl &iconUrl);
void applyBlurHint(QWindow *window, bool enable);

} // namespace Md3Linux
