#include "md3windowhelper.h"
#include "md3win_p.h"

#include <QGuiApplication>
#include <QQuickWindow>
#include <QScreen>
#include <QWindow>

Md3WindowHelper::Md3WindowHelper(QObject *parent)
    : QObject(parent)
{
}

Md3WindowHelper::~Md3WindowHelper()
{
#if defined(Q_OS_WIN)
    hideSystemTrayIcon();
    clearThumbIcons();
    clearIconicBitmap();
    clearWinIcons();
    Md3WinNativeFilter::instance()->unregisterHelper(this);
#endif
}

QString Md3WindowHelper::platformId() const
{
#if defined(Q_OS_WIN)
    return QStringLiteral("windows");
#elif defined(Q_OS_MACOS)
    return QStringLiteral("macos");
#elif defined(Q_OS_LINUX)
    return QStringLiteral("linux");
#elif defined(Q_OS_ANDROID)
    return QStringLiteral("android");
#elif defined(Q_OS_IOS)
    return QStringLiteral("ios");
#else
    return QStringLiteral("unknown");
#endif
}

bool Md3WindowHelper::wayland() const
{
    const QString platform = QGuiApplication::platformName();
    return platform.contains(QLatin1String("wayland"), Qt::CaseInsensitive);
}

bool Md3WindowHelper::xcb() const
{
    const QString platform = QGuiApplication::platformName();
    return platform.contains(QLatin1String("xcb"), Qt::CaseInsensitive)
           || platform.contains(QLatin1String("x11"), Qt::CaseInsensitive);
}

qreal Md3WindowHelper::trafficLightsInset() const
{
#if defined(Q_OS_MACOS)
    return 78.0;
#else
    return 0.0;
#endif
}

bool Md3WindowHelper::customChromeRecommended() const
{
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    return false;
#else
    return true;
#endif
}

bool Md3WindowHelper::captionButtonsRecommended() const
{
#if defined(Q_OS_MACOS) || defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    return false;
#else
    return true;
#endif
}

qreal Md3WindowHelper::windowCornerRadius() const
{
#if defined(Q_OS_WIN)
    return 12.0;
#elif defined(Q_OS_MACOS)
    return 10.0;
#elif defined(Q_OS_LINUX)
    return 12.0;
#else
    return 0.0;
#endif
}

bool Md3WindowHelper::roundedCornersRecommended() const
{
#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    return false;
#else
    return true;
#endif
}

#define MD3_WIN_CAP(name) \
bool Md3WindowHelper::name() const \
{ \
    return platformId() == QLatin1String("windows"); \
}

MD3_WIN_CAP(snapLayoutsSupported)
MD3_WIN_CAP(systemBackdropSupported)
MD3_WIN_CAP(systemMenuSupported)
MD3_WIN_CAP(immersiveDarkModeSupported)
MD3_WIN_CAP(taskbarProgressSupported)
MD3_WIN_CAP(taskbarOverlaySupported)
MD3_WIN_CAP(jumpListSupported)
MD3_WIN_CAP(thumbBarSupported)
MD3_WIN_CAP(iconicThumbnailSupported)
MD3_WIN_CAP(systemTraySupported)
MD3_WIN_CAP(perMonitorDpiV2Supported)
MD3_WIN_CAP(alwaysOnTopSupported)
MD3_WIN_CAP(thumbnailClipSupported)
MD3_WIN_CAP(applicationRestartSupported)
MD3_WIN_CAP(preferredAppModeSupported)
MD3_WIN_CAP(windowCloakSupported)
MD3_WIN_CAP(systemAccentSupported)

#undef MD3_WIN_CAP

void Md3WindowHelper::bindWindow(QObject *window)
{
    auto *qw = qobject_cast<QWindow *>(window);
    if (!qw)
        return;

#if defined(Q_OS_WIN)
    md3EnsureWinChromeStyles(qw);
    applyCornerPreference(qw, true);
    Md3WinNativeFilter::instance()->registerWindow(qw, this);
#else
    Q_UNUSED(qw);
#endif
}

void Md3WindowHelper::unbindWindow(QObject *window)
{
#if defined(Q_OS_WIN)
    auto *qw = qobject_cast<QWindow *>(window);
    if (!qw)
        return;
    Md3WinNativeFilter::instance()->unregisterWindow(qw);
#else
    Q_UNUSED(window);
#endif
}

void Md3WindowHelper::setMaximizeButtonRect(QObject *window, qreal x, qreal y, qreal w, qreal h)
{
#if defined(Q_OS_WIN)
    auto *qw = qobject_cast<QWindow *>(window);
    if (!qw)
        return;
    auto *filter = Md3WinNativeFilter::instance();
    filter->registerWindow(qw, this);
    if (Md3WinChromeState *st = filter->stateForWindow(qw))
        st->maximizeButton = QRectF(x, y, w, h);
#else
    Q_UNUSED(window);
    Q_UNUSED(x);
    Q_UNUSED(y);
    Q_UNUSED(w);
    Q_UNUSED(h);
#endif
}

void Md3WindowHelper::clearMaximizeButtonRect(QObject *window)
{
#if defined(Q_OS_WIN)
    auto *qw = qobject_cast<QWindow *>(window);
    if (!qw)
        return;
    if (Md3WinChromeState *st = Md3WinNativeFilter::instance()->stateForWindow(qw))
        st->maximizeButton = QRectF();
#else
    Q_UNUSED(window);
#endif
}

void Md3WindowHelper::setCaptionHitRect(QObject *window, qreal x, qreal y, qreal w, qreal h)
{
#if defined(Q_OS_WIN)
    auto *qw = qobject_cast<QWindow *>(window);
    if (!qw)
        return;
    auto *filter = Md3WinNativeFilter::instance();
    filter->registerWindow(qw, this);
    if (Md3WinChromeState *st = filter->stateForWindow(qw))
        st->captionHit = QRectF(x, y, w, h);
#else
    Q_UNUSED(window);
    Q_UNUSED(x);
    Q_UNUSED(y);
    Q_UNUSED(w);
    Q_UNUSED(h);
#endif
}

void Md3WindowHelper::clearCaptionHitRect(QObject *window)
{
#if defined(Q_OS_WIN)
    auto *qw = qobject_cast<QWindow *>(window);
    if (!qw)
        return;
    if (Md3WinChromeState *st = Md3WinNativeFilter::instance()->stateForWindow(qw))
        st->captionHit = QRectF();
#else
    Q_UNUSED(window);
#endif
}

qreal Md3WindowHelper::devicePixelRatio(QObject *window) const
{
    auto *qw = qobject_cast<QWindow *>(window);
    return qw ? qw->devicePixelRatio() : qreal(1);
}

int Md3WindowHelper::windowDpi(QObject *window) const
{
#if defined(Q_OS_WIN)
    auto *qw = qobject_cast<QWindow *>(window);
    return int(md3GetDpiForWindow(md3HwndOf(qw)));
#else
    auto *qw = qobject_cast<QWindow *>(window);
    if (!qw || !qw->screen())
        return 96;
    return qRound(qw->screen()->logicalDotsPerInch());
#endif
}

void Md3WindowHelper::setPersistentSceneGraph(QObject *window, bool persistent)
{
    auto *qw = qobject_cast<QQuickWindow *>(window);
    if (!qw)
        return;
    qw->setPersistentSceneGraph(persistent);
    qw->setPersistentGraphics(persistent);
}

#if defined(Q_OS_WIN)
void Md3WindowHelper::handleThumbBarClick(int buttonId)
{
    emit thumbBarButtonClicked(buttonId);
}

void Md3WindowHelper::handleTrayMessage(quintptr lParam)
{
    int reason = TrayUnknown;
    switch (lParam) {
    case WM_LBUTTONUP: reason = TrayLeftClick; break;
    case WM_LBUTTONDBLCLK: reason = TrayLeftDoubleClick; break;
    case WM_RBUTTONUP: reason = TrayRightClick; break;
    case WM_MBUTTONUP: reason = TrayMiddleClick; break;
    case NIN_BALLOONSHOW: reason = TrayBalloonShown; break;
    case NIN_BALLOONUSERCLICK: reason = TrayBalloonClicked; break;
    case NIN_BALLOONTIMEOUT:
    case NIN_BALLOONHIDE: reason = TrayBalloonTimeout; break;
    default: break;
    }
    emit trayActivated(reason);
}

void Md3WindowHelper::handleDpiChanged(QWindow *window)
{
    if (!window)
        return;
    emit dpiChanged(window->devicePixelRatio(), windowDpi(window));
}
#endif
