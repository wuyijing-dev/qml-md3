#include "md3windowhelper.h"
#include "md3win_p.h"

#include <QGuiApplication>
#include <QWindow>

// Windows-only translation unit (CMake WIN32). Tray / DPI host handlers.

void Md3WindowHelper::shutdownNative()
{
    hideSystemTrayIcon();
    clearThumbIcons();
    clearIconicBitmap();
    clearWinIcons();
    Md3WinNativeFilter::instance()->unregisterHelper(this);
}

void Md3WindowHelper::bindWindow(QObject *window)
{
    auto *qw = qobject_cast<QWindow *>(window);
    if (!qw)
        return;
    md3EnsureWinChromeStyles(qw);
    applyCornerPreference(qw, true);
    Md3WinNativeFilter::instance()->registerWindow(qw, this);
}

void Md3WindowHelper::unbindWindow(QObject *window)
{
    auto *qw = qobject_cast<QWindow *>(window);
    if (!qw)
        return;
    Md3WinNativeFilter::instance()->unregisterWindow(qw);
}

void Md3WindowHelper::setMaximizeButtonRect(QObject *window, qreal x, qreal y, qreal w, qreal h)
{
    auto *qw = qobject_cast<QWindow *>(window);
    if (!qw)
        return;
    auto *filter = Md3WinNativeFilter::instance();
    filter->registerWindow(qw, this);
    if (Md3WinChromeState *st = filter->stateForWindow(qw))
        st->maximizeButton = QRectF(x, y, w, h);
}

void Md3WindowHelper::clearMaximizeButtonRect(QObject *window)
{
    auto *qw = qobject_cast<QWindow *>(window);
    if (!qw)
        return;
    if (Md3WinChromeState *st = Md3WinNativeFilter::instance()->stateForWindow(qw))
        st->maximizeButton = QRectF();
}

void Md3WindowHelper::setCaptionHitRect(QObject *window, qreal x, qreal y, qreal w, qreal h)
{
    auto *qw = qobject_cast<QWindow *>(window);
    if (!qw)
        return;
    auto *filter = Md3WinNativeFilter::instance();
    filter->registerWindow(qw, this);
    if (Md3WinChromeState *st = filter->stateForWindow(qw))
        st->captionHit = QRectF(x, y, w, h);
}

void Md3WindowHelper::clearCaptionHitRect(QObject *window)
{
    auto *qw = qobject_cast<QWindow *>(window);
    if (!qw)
        return;
    if (Md3WinChromeState *st = Md3WinNativeFilter::instance()->stateForWindow(qw))
        st->captionHit = QRectF();
}

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

bool Md3WindowHelper::setDockBadge(int count)
{
#if QT_VERSION >= QT_VERSION_CHECK(6, 5, 0)
    if (auto *app = qGuiApp) {
        app->setBadgeNumber(qMax(0, count));
        return true;
    }
#endif
    Q_UNUSED(count);
    return false;
}

bool Md3WindowHelper::setIdleInhibit(bool, const QString &)
{
    return false;
}

bool Md3WindowHelper::blurBehindAvailable() const
{
    return false;
}
