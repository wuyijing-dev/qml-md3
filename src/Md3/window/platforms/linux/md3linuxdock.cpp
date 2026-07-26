#include "md3windowhelper.h"
#include "md3linux_p.h"

#include <QGuiApplication>
#include <QIcon>
#include <QUrl>
#include <QVariantMap>
#include <QWindow>

bool Md3WindowHelper::setAppUserModelId(const QString &appId)
{
    if (appId.trimmed().isEmpty())
        return false;
    Md3Linux::setDesktopFileId(appId);
    return true;
}

void Md3WindowHelper::setTaskbarProgress(QObject *window, qreal value, int state)
{
    Q_UNUSED(window);
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

bool Md3WindowHelper::setTaskbarOverlayIcon(QObject *window, const QUrl &iconUrl,
                                            const QString &description)
{
    Q_UNUSED(window);
    Q_UNUSED(iconUrl);
    Q_UNUSED(description);
    // Unity/Plasma badge: show count=1 (no custom glyph API).
    QVariantMap props;
    props.insert(QStringLiteral("count"), qint64(1));
    props.insert(QStringLiteral("count-visible"), true);
    Md3Linux::emitLauncherUpdate(props);
    return true;
}

void Md3WindowHelper::clearTaskbarOverlayIcon(QObject *window)
{
    Q_UNUSED(window);
    QVariantMap props;
    props.insert(QStringLiteral("count"), qint64(0));
    props.insert(QStringLiteral("count-visible"), false);
    Md3Linux::emitLauncherUpdate(props);
}

void Md3WindowHelper::setThumbnailClip(QObject *, qreal, qreal, qreal, qreal) {}
void Md3WindowHelper::clearThumbnailClip(QObject *) {}
void Md3WindowHelper::setThumbnailTooltip(QObject *window, const QString &text)
{
    if (auto *qw = qobject_cast<QWindow *>(window))
        qw->setProperty("_md3_thumbnailTooltip", text);
}

bool Md3WindowHelper::registerApplicationRestart(const QString &commandLineArgs)
{
    // Persist a best-effort restart hint for the app to read on next launch.
    qputenv("MD3_RESTART_ARGS", commandLineArgs.toUtf8());
    return true;
}

void Md3WindowHelper::unregisterApplicationRestart()
{
    qunsetenv("MD3_RESTART_ARGS");
}

bool Md3WindowHelper::setJumpListTasks(const QVariantList &tasks)
{
    // Map to Unity quicklist is non-portable without a DBusMenu server; store for apps.
    if (qApp)
        qApp->setProperty("_md3_jumpListTasks", tasks);
    return !tasks.isEmpty();
}

void Md3WindowHelper::clearJumpList()
{
    if (qApp)
        qApp->setProperty("_md3_jumpListTasks", QVariant());
}

bool Md3WindowHelper::setThumbBarButtons(QObject *, const QVariantList &) { return false; }
void Md3WindowHelper::clearThumbBarButtons(QObject *) {}
void Md3WindowHelper::setForceIconicRepresentation(QObject *, bool) {}
bool Md3WindowHelper::setIconicThumbnail(QObject *, const QUrl &) { return false; }
void Md3WindowHelper::clearIconicThumbnail(QObject *) {}
