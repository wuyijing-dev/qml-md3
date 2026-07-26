#include "md3windowhelper.h"
#include "md3win_p.h"

#include <QGuiApplication>
#include <QPixmap>
#include <QWindow>

#include <cstring>

bool Md3WindowHelper::showSystemTrayIcon(QObject *window, const QUrl &iconUrl, const QString &tooltip)
{
#if defined(Q_OS_WIN)
    auto *qw = qobject_cast<QWindow *>(window);
    const HWND hwnd = md3HwndOf(qw);
    if (!hwnd)
        return false;

    const QIcon icon = md3LoadIconMultiSize(iconUrl);
    if (icon.isNull())
        return false;
    const QPixmap pm = icon.pixmap(QSize(16, 16), qw->devicePixelRatio());
    HICON hIcon = md3CreateHIconFromImage(pm.toImage());
    if (!hIcon)
        return false;

    if (m_trayIcon) {
        DestroyIcon(static_cast<HICON>(m_trayIcon));
        m_trayIcon = nullptr;
    }
    m_trayIcon = hIcon;
    m_trayHwnd = hwnd;

    NOTIFYICONDATAW nid{};
    nid.cbSize = sizeof(nid);
    nid.hWnd = hwnd;
    nid.uID = 1;
    nid.uFlags = NIF_MESSAGE | NIF_ICON | NIF_TIP;
    nid.uCallbackMessage = kMd3TrayCallback;
    nid.hIcon = hIcon;
    const int tipLen = qMin(127, tooltip.size());
    if (tipLen > 0)
        memcpy(nid.szTip, tooltip.utf16(), size_t(tipLen) * sizeof(WCHAR));

    BOOL ok = FALSE;
    if (m_trayAdded)
        ok = Shell_NotifyIconW(NIM_MODIFY, &nid);
    else {
        ok = Shell_NotifyIconW(NIM_ADD, &nid);
        if (ok) {
            nid.uVersion = NOTIFYICON_VERSION_4;
            Shell_NotifyIconW(NIM_SETVERSION, &nid);
            m_trayAdded = true;
        }
    }
    return ok == TRUE;
#else
    Q_UNUSED(window);
    Q_UNUSED(iconUrl);
    Q_UNUSED(tooltip);
    return false;
#endif
}

void Md3WindowHelper::hideSystemTrayIcon()
{
#if defined(Q_OS_WIN)
    if (!m_trayAdded)
        return;
    HWND hwnd = static_cast<HWND>(m_trayHwnd);
    if (hwnd) {
        NOTIFYICONDATAW nid{};
        nid.cbSize = sizeof(nid);
        nid.hWnd = hwnd;
        nid.uID = 1;
        Shell_NotifyIconW(NIM_DELETE, &nid);
    }
    m_trayAdded = false;
    m_trayHwnd = nullptr;
    if (m_trayIcon) {
        DestroyIcon(static_cast<HICON>(m_trayIcon));
        m_trayIcon = nullptr;
    }
#endif
}

bool Md3WindowHelper::showTrayNotification(const QString &title, const QString &body, int timeoutMs)
{
#if defined(Q_OS_WIN)
    if (!m_trayAdded || !m_trayHwnd)
        return false;
    const HWND hwnd = static_cast<HWND>(m_trayHwnd);
    if (!hwnd)
        return false;

    NOTIFYICONDATAW nid{};
    nid.cbSize = sizeof(nid);
    nid.hWnd = hwnd;
    nid.uID = 1;
    nid.uFlags = NIF_INFO;
    nid.dwInfoFlags = NIIF_INFO;
    nid.uTimeout = UINT(qMax(0, timeoutMs));
    const int titleLen = qMin(63, title.size());
    const int bodyLen = qMin(255, body.size());
    if (titleLen > 0)
        memcpy(nid.szInfoTitle, title.utf16(), size_t(titleLen) * sizeof(WCHAR));
    if (bodyLen > 0)
        memcpy(nid.szInfo, body.utf16(), size_t(bodyLen) * sizeof(WCHAR));
    return Shell_NotifyIconW(NIM_MODIFY, &nid) == TRUE;
#else
    Q_UNUSED(title);
    Q_UNUSED(body);
    Q_UNUSED(timeoutMs);
    return false;
#endif
}
