#pragma once

#include <QString>
#include <QUrl>
#include <QVariantMap>
#include <QtGlobal>

class QWindow;

namespace Md3Linux {

QString desktopFileId();
void setDesktopFileId(const QString &id);

void emitLauncherUpdate(const QVariantMap &properties);

uint notify(const QString &title, const QString &body, int timeoutMs,
            const QString &iconName = QString());

QString resolveIconPath(const QUrl &iconUrl);

/// Compositor blur (KF6 KWindowEffects / X11 atom). Returns user-facing status.
QString applyBlurBehind(QWindow *window, bool enable);
bool blurBehindAvailable();

/// Keep-above via KF6 when possible, else Qt flag. Returns status.
QString setKeepAbove(QWindow *window, bool onTop);

/// forceActiveWindow / requestActivate. Returns status.
QString forceRaise(QWindow *window);

/// Mark urgent on dock + alert + optional notify. Returns status.
QString requestAttention(QWindow *window, bool on);

/// ScreenSaver / GNOME SessionManager / desktop portal. Returns status; ok via out param.
QString setIdleInhibit(bool inhibit, const QString &reason, bool *ok = nullptr);

} // namespace Md3Linux
