#pragma once

#include "md3windowhelper.h"

#include <QAbstractNativeEventFilter>
#include <QColor>
#include <QFile>
#include <QHash>
#include <QIcon>
#include <QImage>
#include <QPointer>
#include <QString>
#include <QUrl>
#include <QWindow>

#if defined(Q_OS_WIN)
#  include <windows.h>
#  include <windowsx.h>
#  include <dwmapi.h>
#  include <shellapi.h>
#  include <shobjidl.h>
#  include <propkey.h>
#  include <propvarutil.h>

#  ifndef WDA_EXCLUDEFROMCAPTURE
#    define WDA_EXCLUDEFROMCAPTURE 0x00000011
#  endif
#  ifndef WDA_NONE
#    define WDA_NONE 0x00000000
#  endif
#  ifndef DWMWA_WINDOW_CORNER_PREFERENCE
#    define DWMWA_WINDOW_CORNER_PREFERENCE 33
#  endif
#  ifndef DWMWCP_DONOTROUND
#    define DWMWCP_DONOTROUND 1
#  endif
#  ifndef DWMWCP_ROUND
#    define DWMWCP_ROUND 2
#  endif
#  ifndef DWMWA_USE_IMMERSIVE_DARK_MODE
#    define DWMWA_USE_IMMERSIVE_DARK_MODE 20
#  endif
#  ifndef DWMWA_BORDER_COLOR
#    define DWMWA_BORDER_COLOR 34
#  endif
#  ifndef DWMWA_COLOR_DEFAULT
#    define DWMWA_COLOR_DEFAULT 0xFFFFFFFF
#  endif
#  ifndef DWMWA_COLOR_NONE
#    define DWMWA_COLOR_NONE 0xFFFFFFFE
#  endif
#  ifndef DWMWA_SYSTEMBACKDROP_TYPE
#    define DWMWA_SYSTEMBACKDROP_TYPE 38
#  endif
#  ifndef DWMWA_REDIRECTIONBITMAP_ALPHA
#    define DWMWA_REDIRECTIONBITMAP_ALPHA 39
#  endif
#  ifndef DWMWA_CAPTION_COLOR
#    define DWMWA_CAPTION_COLOR 35
#  endif
#  ifndef DWMWA_TEXT_COLOR
#    define DWMWA_TEXT_COLOR 36
#  endif
#  ifndef DWMWA_CLOAK
#    define DWMWA_CLOAK 13
#  endif
#  ifndef DWMSBT_AUTO
#    define DWMSBT_AUTO 0
#  endif
#  ifndef DWMSBT_NONE
#    define DWMSBT_NONE 1
#  endif
#  ifndef DWMSBT_MAINWINDOW
#    define DWMSBT_MAINWINDOW 2
#  endif
#  ifndef DWMSBT_TRANSIENTWINDOW
#    define DWMSBT_TRANSIENTWINDOW 3
#  endif
#  ifndef DWMSBT_TABBEDWINDOW
#    define DWMSBT_TABBEDWINDOW 4
#  endif
#  ifndef DWMNCRP_ENABLED
#    define DWMNCRP_ENABLED 2
#  endif
#  ifndef DWMWA_NCRENDERING_POLICY
#    define DWMWA_NCRENDERING_POLICY 2
#  endif
#  ifndef DWMWA_FORCE_ICONIC_REPRESENTATION
#    define DWMWA_FORCE_ICONIC_REPRESENTATION 7
#  endif
#  ifndef DWMWA_HAS_ICONIC_BITMAP
#    define DWMWA_HAS_ICONIC_BITMAP 10
#  endif
#  ifndef DWMWA_DISALLOW_PEEK
#    define DWMWA_DISALLOW_PEEK 11
#  endif
#  ifndef DWMWA_EXCLUDED_FROM_PEEK
#    define DWMWA_EXCLUDED_FROM_PEEK 12
#  endif
#  ifndef WM_DWMSENDICONICTHUMBNAIL
#    define WM_DWMSENDICONICTHUMBNAIL 0x0323
#  endif
#  ifndef WM_DWMSENDICONICLIVEPREVIEWBITMAP
#    define WM_DWMSENDICONICLIVEPREVIEWBITMAP 0x0326
#  endif
#  ifndef THBN_CLICKED
#    define THBN_CLICKED 0x1800
#  endif
#  ifndef NIN_SELECT
#    define NIN_SELECT (WM_USER + 0)
#  endif
#  ifndef NIN_KEYSELECT
#    define NIN_KEYSELECT (WM_USER + 1)
#  endif
#  ifndef NIN_BALLOONSHOW
#    define NIN_BALLOONSHOW (WM_USER + 2)
#  endif
#  ifndef NIN_BALLOONHIDE
#    define NIN_BALLOONHIDE (WM_USER + 3)
#  endif
#  ifndef NIN_BALLOONTIMEOUT
#    define NIN_BALLOONTIMEOUT (WM_USER + 4)
#  endif
#  ifndef NIN_BALLOONUSERCLICK
#    define NIN_BALLOONUSERCLICK (WM_USER + 5)
#  endif

inline constexpr UINT kMd3TrayCallback = WM_APP + 0x4D33;

HWND md3HwndOf(QWindow *qw);
void md3EnsureWinChromeStyles(QWindow *qw);
void md3UpdateSystemMenuState(HWND hwnd);
COLORREF md3ParseCssColor(const QString &css, bool *ok);
HICON md3CreateHIconFromImage(const QImage &src);
HBITMAP md3CreateHBitmapFromImage(const QImage &src);
ITaskbarList3 *md3TaskbarList3();
UINT md3GetDpiForWindow(HWND hwnd);
#endif // Q_OS_WIN

QString md3QrcPathFromUrl(const QUrl &iconUrl);
QIcon md3LoadIconMultiSize(const QUrl &iconUrl);

/// Per-HWND chrome hit-test state (supports multiple top-level windows).
struct Md3WinChromeState
{
    QPointer<QWindow> window;
    QPointer<Md3WindowHelper> helper;
    QRectF maximizeButton;
    QRectF captionHit;
};

class Md3WinNativeFilter : public QAbstractNativeEventFilter
{
public:
    QHash<quintptr, Md3WinChromeState> chromeByHwnd;

    static Md3WinNativeFilter *instance();
    void registerWindow(QWindow *window, Md3WindowHelper *helper);
    void unregisterWindow(QWindow *window);
    void unregisterHelper(Md3WindowHelper *helper);
    Md3WinChromeState *stateForHwnd(quintptr hwnd);
    Md3WinChromeState *stateForWindow(QWindow *window);

    bool nativeEventFilter(const QByteArray &eventType, void *message, qintptr *result) override;
};
