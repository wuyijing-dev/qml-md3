#include "md3windowhelper.h"
#include "md3win_p.h"

#include <QGuiApplication>
#include <QWindow>

#if defined(Q_OS_WIN)
#  include <windows.h>
#endif

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
    // Historical name: stores the whole caption-button strip so WM_NCHITTEST
    // resize edges do not steal QML hover/click (do not map to HTMAXBUTTON).
    auto *qw = qobject_cast<QWindow *>(window);
    if (!qw)
        return;
    auto *filter = Md3WinNativeFilter::instance();
    filter->registerWindow(qw, this);
    if (Md3WinChromeState *st = filter->stateForWindow(qw))
        st->captionButtons = QRectF(x, y, w, h);
}

void Md3WindowHelper::clearMaximizeButtonRect(QObject *window)
{
    auto *qw = qobject_cast<QWindow *>(window);
    if (!qw)
        return;
    if (Md3WinChromeState *st = Md3WinNativeFilter::instance()->stateForWindow(qw))
        st->captionButtons = QRectF();
}

void Md3WindowHelper::setSnapMaximizeRect(QObject *window, qreal x, qreal y, qreal w, qreal h)
{
    auto *qw = qobject_cast<QWindow *>(window);
    if (!qw)
        return;
    auto *filter = Md3WinNativeFilter::instance();
    filter->registerWindow(qw, this);
    if (Md3WinChromeState *st = filter->stateForWindow(qw))
        st->maximizeButton = QRectF(x, y, w, h);
}

void Md3WindowHelper::clearSnapMaximizeRect(QObject *window)
{
    auto *qw = qobject_cast<QWindow *>(window);
    if (!qw)
        return;
    if (Md3WinChromeState *st = Md3WinNativeFilter::instance()->stateForWindow(qw)) {
        st->maximizeButton = QRectF();
        st->snapArmed = false;
    }
}

void Md3WindowHelper::setSnapLayoutsArmed(QObject *window, bool armed)
{
    auto *qw = qobject_cast<QWindow *>(window);
    if (!qw)
        return;
    auto *filter = Md3WinNativeFilter::instance();
    filter->registerWindow(qw, this);
    if (Md3WinChromeState *st = filter->stateForWindow(qw))
        st->snapArmed = armed;
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
#if defined(Q_OS_WIN)
    // NOTIFYICON_VERSION_4 packs the event in LOWORD(lParam) (HIWORD = icon id).
    // Classic (no SETVERSION) passes the message id in lParam directly — LOWORD still works.
    const UINT event = LOWORD(static_cast<LPARAM>(lParam));
    int reason = TrayUnknown;
    switch (event) {
    case NIN_SELECT:
    case NIN_KEYSELECT:
    case WM_LBUTTONUP:
        reason = TrayLeftClick;
        break;
    case WM_LBUTTONDBLCLK:
        reason = TrayLeftDoubleClick;
        break;
    case WM_CONTEXTMENU:
    case WM_RBUTTONUP:
        reason = TrayRightClick;
        break;
    case WM_MBUTTONUP:
        reason = TrayMiddleClick;
        break;
    case NIN_BALLOONSHOW:
        reason = TrayBalloonShown;
        break;
    case NIN_BALLOONUSERCLICK:
        reason = TrayBalloonClicked;
        break;
    case NIN_BALLOONTIMEOUT:
    case NIN_BALLOONHIDE:
        reason = TrayBalloonTimeout;
        break;
    default:
        break;
    }
    if (reason != TrayUnknown)
        emit trayActivated(reason);
#else
    Q_UNUSED(lParam);
#endif
}

void Md3WindowHelper::handleDpiChanged(QWindow *window)
{
    if (!window)
        return;
    emit dpiChanged(window->devicePixelRatio(), windowDpi(window));
}

bool Md3WindowHelper::setDockBadge(int count)
{
    count = qMax(0, count);
#if QT_VERSION >= QT_VERSION_CHECK(6, 5, 0)
    if (auto *app = qGuiApp)
        app->setBadgeNumber(count);
#endif

#if defined(Q_OS_WIN)
    QWindow *qw = QGuiApplication::focusWindow();
    if (!qw) {
        const auto windows = QGuiApplication::topLevelWindows();
        for (QWindow *w : windows) {
            if (w && w->isVisible() && w->type() == Qt::Window) {
                qw = w;
                break;
            }
        }
    }
    if (!qw) {
        reportNativeStatus(count > 0
                                   ? QStringLiteral("无可用顶层窗口设置任务栏角标")
                                   : QStringLiteral("已清除角标（无窗口）"));
        return count == 0;
    }

    if (count <= 0) {
        clearTaskbarOverlayIcon(qw);
        reportNativeStatus(QStringLiteral("已清除任务栏角标"));
        return true;
    }

    const HWND hwnd = md3HwndOf(qw);
    ITaskbarList3 *tbl = md3TaskbarList3();
    if (!hwnd || !tbl) {
        reportNativeStatus(QStringLiteral("ITaskbarList3 不可用；已尝试 setBadgeNumber"));
        return true;
    }

    const QImage badge = md3MakeBadgeOverlayImage(count, qw->devicePixelRatio());
    HICON hIcon = md3CreateHIconFromImage(badge);
    if (!hIcon) {
        reportNativeStatus(QStringLiteral("角标位图生成失败"));
        return false;
    }
    const QString tip = count > 99 ? QStringLiteral("99+") : QString::number(count);
    const HRESULT hr = tbl->SetOverlayIcon(hwnd, hIcon,
                                           reinterpret_cast<LPCWSTR>(tip.utf16()));
    DestroyIcon(hIcon);
    reportNativeStatus(SUCCEEDED(hr)
                               ? QStringLiteral("已设置任务栏数字角标")
                               : QStringLiteral("SetOverlayIcon 失败"));
    return SUCCEEDED(hr);
#else
    return count == 0;
#endif
}

bool Md3WindowHelper::setIdleInhibit(bool inhibit, const QString &reason)
{
#if defined(Q_OS_WIN)
    Q_UNUSED(reason);
    if (inhibit) {
        ::SetThreadExecutionState(ES_CONTINUOUS | ES_SYSTEM_REQUIRED | ES_DISPLAY_REQUIRED);
        reportNativeStatus(QStringLiteral("已抑制空闲（系统+显示器）"));
        return true;
    }
    ::SetThreadExecutionState(ES_CONTINUOUS);
    reportNativeStatus(QStringLiteral("已恢复空闲计时"));
    return true;
#else
    Q_UNUSED(inhibit);
    Q_UNUSED(reason);
    return false;
#endif
}

bool Md3WindowHelper::blurBehindAvailable() const
{
    return false;
}

bool Md3WindowHelper::openBlurSettings()
{
    reportNativeStatus(QStringLiteral("当前平台无 Linux 合成器模糊设置入口"));
    return false;
}
