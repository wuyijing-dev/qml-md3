#include "md3windowhelper.h"
#include "md3linux_p.h"

#include <QGuiApplication>
#include <QUrl>
#include <QVariantMap>
#include <QWindow>

bool Md3WindowHelper::setAppUserModelId(const QString &appId)
{
    // Wayland/X11 equivalent: desktop file id → xdg app_id.
    if (appId.trimmed().isEmpty())
        return false;
    Md3Linux::setDesktopFileId(appId);
    return true;
}

void Md3WindowHelper::setTaskbarProgress(QObject *window, qreal value, int state)
{
    Q_UNUSED(window);
    // Real on Plasma / Unity-compatible docks via LauncherEntry.
    QVariantMap props;
    switch (state) {
    case ProgressNoProgress:
        props.insert(QStringLiteral("progress-visible"), false);
        props.insert(QStringLiteral("progress"), 0.0);
        props.insert(QStringLiteral("urgent"), false);
        break;
    case ProgressIndeterminate:
        props.insert(QStringLiteral("progress-visible"), true);
        props.insert(QStringLiteral("progress"), 0.0);
        props.insert(QStringLiteral("urgent"), true);
        break;
    case ProgressError:
    case ProgressPaused:
        props.insert(QStringLiteral("progress-visible"), true);
        props.insert(QStringLiteral("progress"), qBound(0.0, double(value), 1.0));
        props.insert(QStringLiteral("urgent"), state == ProgressError);
        break;
    case ProgressNormal:
    default:
        props.insert(QStringLiteral("progress-visible"), true);
        props.insert(QStringLiteral("progress"), qBound(0.0, double(value), 1.0));
        props.insert(QStringLiteral("urgent"), false);
        break;
    }
    Md3Linux::emitLauncherUpdate(props);
}

void Md3WindowHelper::clearTaskbarProgress(QObject *window)
{
    setTaskbarProgress(window, 0, ProgressNoProgress);
}

bool Md3WindowHelper::setTaskbarOverlayIcon(QObject *, const QUrl &, const QString &)
{
    // No custom glyph overlay on Linux — use setDockBadge().
    return false;
}

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

bool Md3WindowHelper::setDockBadge(int count)
{
#if QT_VERSION >= QT_VERSION_CHECK(6, 5, 0)
    if (auto *app = qGuiApp)
        app->setBadgeNumber(qMax(0, count));
#endif
    QVariantMap props;
    props.insert(QStringLiteral("count"), qint64(qMax(0, count)));
    props.insert(QStringLiteral("count-visible"), count > 0);
    Md3Linux::emitLauncherUpdate(props);
    return true;
}

bool Md3WindowHelper::setIdleInhibit(bool inhibit, const QString &reason)
{
    bool ok = false;
    reportNativeStatus(Md3Linux::setIdleInhibit(inhibit, reason, &ok));
    return ok;
}

bool Md3WindowHelper::blurBehindAvailable() const
{
    return Md3Linux::blurBehindAvailable();
}

bool Md3WindowHelper::openBlurSettings()
{
    const QString status = Md3Linux::openCompositorBlurSettings();
    reportNativeStatus(status);
    // Treat as success if we either loaded the effect or opened a settings UI.
    return status.contains(QStringLiteral("已启用")) || status.contains(QStringLiteral("已打开"));
}
