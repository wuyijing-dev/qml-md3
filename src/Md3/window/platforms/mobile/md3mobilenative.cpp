#include "md3windowhelper.h"

#include <QGuiApplication>
#include <QIcon>
#include <QScreen>
#include <QStyleHints>
#include <QWindow>

// Android / iOS / other — compiled when not Win/Apple/Unix desktop.

void Md3WindowHelper::shutdownNative() {}

void Md3WindowHelper::bindWindow(QObject *) {}
void Md3WindowHelper::unbindWindow(QObject *) {}
void Md3WindowHelper::setMaximizeButtonRect(QObject *, qreal, qreal, qreal, qreal) {}
void Md3WindowHelper::clearMaximizeButtonRect(QObject *) {}
void Md3WindowHelper::setCaptionHitRect(QObject *, qreal, qreal, qreal, qreal) {}
void Md3WindowHelper::clearCaptionHitRect(QObject *) {}
void Md3WindowHelper::applyCornerPreference(QObject *, bool) {}
void Md3WindowHelper::showSystemMenu(QObject *, qreal, qreal) {}
void Md3WindowHelper::setImmersiveDarkMode(QObject *, bool) {}
void Md3WindowHelper::setSystemBackdrop(QObject *, int) {}
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
void Md3WindowHelper::setPreferredAppMode(bool) {}

QString Md3WindowHelper::systemAccentColor() const
{
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

bool Md3WindowHelper::moveToMonitor(QObject *, int)
{
    return false;
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
