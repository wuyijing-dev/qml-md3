#include "md3windowhelper.h"
#include "md3win_p.h"

#include <QCoreApplication>
#include <QDir>
#include <QGuiApplication>
#include <QPixmap>
#include <QScreen>
#include <QVariantMap>
#include <QWindow>

#include <cstring>

#if defined(Q_OS_WIN)
#  include <windows.h>
#endif

bool Md3WindowHelper::setWindowIcon(QObject *window, const QUrl &iconUrl)
{
    auto *qw = qobject_cast<QWindow *>(window);
    if (!qw)
        return false;

    const QIcon icon = md3LoadIconMultiSize(iconUrl);
    if (icon.isNull())
        return false;

    qw->setIcon(icon);
    QGuiApplication::setWindowIcon(icon);

#if defined(Q_OS_WIN)
    const HWND hwnd = md3HwndOf(qw);
    if (!hwnd)
        return true;

    SendMessageW(hwnd, WM_SETICON, ICON_BIG, 0);
    SendMessageW(hwnd, WM_SETICON, ICON_SMALL, 0);
    clearWinIcons();

    const UINT dpi = md3GetDpiForWindow(hwnd);
    using GetSystemMetricsForDpiFn = int (WINAPI *)(int, UINT);
    GetSystemMetricsForDpiFn metricsForDpi = nullptr;
    if (HMODULE user32 = GetModuleHandleW(L"user32.dll"))
        metricsForDpi = reinterpret_cast<GetSystemMetricsForDpiFn>(
            GetProcAddress(user32, "GetSystemMetricsForDpi"));
    const int cxBig = metricsForDpi ? metricsForDpi(SM_CXICON, dpi) : GetSystemMetrics(SM_CXICON);
    const int cyBig = metricsForDpi ? metricsForDpi(SM_CYICON, dpi) : GetSystemMetrics(SM_CYICON);
    const int cxSm = metricsForDpi ? metricsForDpi(SM_CXSMICON, dpi) : GetSystemMetrics(SM_CXSMICON);
    const int cySm = metricsForDpi ? metricsForDpi(SM_CYSMICON, dpi) : GetSystemMetrics(SM_CYSMICON);
    const qreal dpr = qw->devicePixelRatio();
    const QPixmap bigPm = icon.pixmap(QSize(qMax(cxBig, 32), qMax(cyBig, 32)), dpr);
    const QPixmap smallPm = icon.pixmap(QSize(qMax(cxSm, 16), qMax(cySm, 16)), dpr);
    HICON hIconBig = md3CreateHIconFromImage(bigPm.toImage());
    HICON hIconSmall = md3CreateHIconFromImage(smallPm.toImage());
    m_iconBig = hIconBig;
    m_iconSmall = hIconSmall;
    if (hIconBig)
        SendMessageW(hwnd, WM_SETICON, ICON_BIG, reinterpret_cast<LPARAM>(hIconBig));
    if (hIconSmall)
        SendMessageW(hwnd, WM_SETICON, ICON_SMALL, reinterpret_cast<LPARAM>(hIconSmall));
    DrawMenuBar(hwnd);
#endif
    return true;
}

#if defined(Q_OS_WIN)
void Md3WindowHelper::clearWinIcons()
{
    if (m_iconBig) {
        DestroyIcon(static_cast<HICON>(m_iconBig));
        m_iconBig = nullptr;
    }
    if (m_iconSmall) {
        DestroyIcon(static_cast<HICON>(m_iconSmall));
        m_iconSmall = nullptr;
    }
}
#endif
