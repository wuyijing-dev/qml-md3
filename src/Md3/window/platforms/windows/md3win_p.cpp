#include "md3win_p.h"

#include <QGuiApplication>
#include <QScreen>
#include <cstring>

Md3WinNativeFilter *Md3WinNativeFilter::instance()
{
    static Md3WinNativeFilter *filter = nullptr;
    if (!filter) {
        filter = new Md3WinNativeFilter;
        qApp->installNativeEventFilter(filter);
    }
    return filter;
}

void Md3WinNativeFilter::registerWindow(QWindow *window, Md3WindowHelper *helper)
{
#if defined(Q_OS_WIN)
    if (!window || !helper)
        return;
    const HWND hwnd = md3HwndOf(window);
    if (!hwnd)
        return;
    Md3WinChromeState &st = chromeByHwnd[quintptr(hwnd)];
    st.window = window;
    st.helper = helper;
#else
    Q_UNUSED(window);
    Q_UNUSED(helper);
#endif
}

void Md3WinNativeFilter::unregisterWindow(QWindow *window)
{
#if defined(Q_OS_WIN)
    if (!window)
        return;
    const HWND hwnd = md3HwndOf(window);
    if (hwnd)
        chromeByHwnd.remove(quintptr(hwnd));
#else
    Q_UNUSED(window);
#endif
}

void Md3WinNativeFilter::unregisterHelper(Md3WindowHelper *helper)
{
    if (!helper)
        return;
    for (auto it = chromeByHwnd.begin(); it != chromeByHwnd.end();) {
        if (it.value().helper == helper)
            it = chromeByHwnd.erase(it);
        else
            ++it;
    }
}

Md3WinChromeState *Md3WinNativeFilter::stateForHwnd(quintptr hwnd)
{
    auto it = chromeByHwnd.find(hwnd);
    if (it == chromeByHwnd.end())
        return nullptr;
    return &it.value();
}

Md3WinChromeState *Md3WinNativeFilter::stateForWindow(QWindow *window)
{
#if defined(Q_OS_WIN)
    if (!window)
        return nullptr;
    return stateForHwnd(quintptr(md3HwndOf(window)));
#else
    Q_UNUSED(window);
    return nullptr;
#endif
}

bool Md3WinNativeFilter::nativeEventFilter(const QByteArray &eventType, void *message, qintptr *result)
{
#if defined(Q_OS_WIN)
    Q_UNUSED(eventType);
    auto *msg = static_cast<MSG *>(message);
    if (!msg || !result)
        return false;

    Md3WinChromeState *st = stateForHwnd(quintptr(msg->hwnd));

    // Tray callbacks must be handled even if chrome hit-test state is incomplete.
    if (msg->message == kMd3TrayCallback) {
        Md3WindowHelper *trayHelper = (st && st->helper) ? st->helper.data() : nullptr;
        if (trayHelper) {
            trayHelper->handleTrayMessage(quintptr(msg->lParam));
            *result = 0;
            return true;
        }
        return false;
    }

    if (!st || !st->window)
        return false;

    QWindow *window = st->window;
    Md3WindowHelper *helper = st->helper;

    if (msg->message == WM_NCCALCSIZE && msg->wParam == TRUE) {
        auto *params = reinterpret_cast<NCCALCSIZE_PARAMS *>(msg->lParam);
        if (IsZoomed(msg->hwnd)) {
            MONITORINFO mi{};
            mi.cbSize = sizeof(mi);
            const HMONITOR mon = MonitorFromWindow(msg->hwnd, MONITOR_DEFAULTTONEAREST);
            if (GetMonitorInfoW(mon, &mi))
                params->rgrc[0] = mi.rcWork;
        }
        *result = 0;
        return true;
    }

    if (msg->message == WM_NCHITTEST) {
        POINT pt{ GET_X_LPARAM(msg->lParam), GET_Y_LPARAM(msg->lParam) };
        ScreenToClient(msg->hwnd, &pt);
        const qreal dpr = window->devicePixelRatio();
        const QPointF local(qreal(pt.x) / dpr, qreal(pt.y) / dpr);
        const qreal ww = window->width();
        const qreal wh = window->height();
        constexpr qreal kEdge = 6.0;
        constexpr qreal kCorner = 12.0;
        const bool nearL = local.x() <= kEdge;
        const bool nearR = local.x() >= ww - kEdge;
        const bool nearT = local.y() <= kEdge;
        const bool nearB = local.y() >= wh - kEdge;
        const bool cornerL = local.x() <= kCorner;
        const bool cornerR = local.x() >= ww - kCorner;
        const bool cornerT = local.y() <= kCorner;
        const bool cornerB = local.y() >= wh - kCorner;

        if (!(IsZoomed(msg->hwnd))) {
            if (cornerT && cornerL) { *result = HTTOPLEFT; return true; }
            if (cornerT && cornerR) { *result = HTTOPRIGHT; return true; }
            if (cornerB && cornerL) { *result = HTBOTTOMLEFT; return true; }
            if (cornerB && cornerR) { *result = HTBOTTOMRIGHT; return true; }
            if (nearT) { *result = HTTOP; return true; }
            if (nearB) { *result = HTBOTTOM; return true; }
            if (nearL) { *result = HTLEFT; return true; }
            if (nearR) { *result = HTRIGHT; return true; }
        }

        if (!st->maximizeButton.isEmpty() && st->maximizeButton.contains(local)) {
            *result = HTMAXBUTTON;
            return true;
        }
        if (!st->captionHit.isEmpty() && st->captionHit.contains(local)) {
            *result = HTCAPTION;
            return true;
        }
        return false;
    }

    if (msg->message == WM_COMMAND && helper) {
        if (HIWORD(msg->wParam) == THBN_CLICKED) {
            helper->handleThumbBarClick(int(LOWORD(msg->wParam)));
            *result = 0;
            return true;
        }
    }

    if (msg->message == WM_DPICHANGED && helper) {
        helper->handleDpiChanged(window);
        return false;
    }

    if (msg->message == WM_DWMSENDICONICTHUMBNAIL && helper) {
        const int w = HIWORD(msg->lParam);
        const int h = LOWORD(msg->lParam);
        if (helper->respondIconicThumbnail(msg->hwnd, w, h)) {
            *result = 0;
            return true;
        }
    }

    if (msg->message == WM_DWMSENDICONICLIVEPREVIEWBITMAP && helper) {
        if (helper->respondIconicLivePreview(msg->hwnd)) {
            *result = 0;
            return true;
        }
    }
#else
    Q_UNUSED(eventType);
    Q_UNUSED(message);
    Q_UNUSED(result);
#endif
    return false;
}

QString md3QrcPathFromUrl(const QUrl &iconUrl)
{
    if (!iconUrl.isValid() || iconUrl.isEmpty())
        return {};
    if (iconUrl.isLocalFile())
        return iconUrl.toLocalFile();
    QString p = iconUrl.path();
    if (iconUrl.scheme() == QLatin1String("qrc") || p.startsWith(QLatin1Char(':')))
        return p.startsWith(QLatin1Char(':')) ? p : (QLatin1Char(':') + p);
    QString s = iconUrl.toString();
    if (s.startsWith(QLatin1String("qrc:")))
        return s.mid(3);
    return s;
}

QIcon md3LoadIconMultiSize(const QUrl &iconUrl)
{
    QIcon icon;
    const QString primary = md3QrcPathFromUrl(iconUrl);
    if (primary.isEmpty())
        return icon;

    QString base = primary;
    if (base.endsWith(QLatin1String(".png"), Qt::CaseInsensitive))
        base.chop(4);
    const int sizes[] = { 16, 32, 48, 256 };
    bool added = false;
    for (int s : sizes) {
        const QString candidate = base + QLatin1Char('-') + QString::number(s) + QLatin1String(".png");
        if (QFile::exists(candidate)) {
            icon.addFile(candidate, QSize(s, s));
            added = true;
        }
    }
    if (QFile::exists(primary)) {
        icon.addFile(primary);
        added = true;
    }
    if (!added)
        icon = QIcon(primary);
    return icon;
}

#if defined(Q_OS_WIN)
HWND md3HwndOf(QWindow *qw)
{
    if (!qw)
        return nullptr;
    return reinterpret_cast<HWND>(qw->winId());
}

void md3EnsureWinChromeStyles(QWindow *qw)
{
    const HWND hwnd = md3HwndOf(qw);
    if (!hwnd)
        return;

    LONG style = GetWindowLongW(hwnd, GWL_STYLE);
    style |= WS_THICKFRAME | WS_CAPTION | WS_MAXIMIZEBOX | WS_MINIMIZEBOX | WS_SYSMENU;
    style &= ~(WS_BORDER);
    SetWindowLongW(hwnd, GWL_STYLE, style);

    LONG ex = GetWindowLongW(hwnd, GWL_EXSTYLE);
    ex &= ~(WS_EX_DLGMODALFRAME | WS_EX_CLIENTEDGE | WS_EX_STATICEDGE | WS_EX_WINDOWEDGE
            | WS_EX_LAYERED);
    SetWindowLongW(hwnd, GWL_EXSTYLE, ex);

    const int ncPolicy = DWMNCRP_ENABLED;
    DwmSetWindowAttribute(hwnd, DWMWA_NCRENDERING_POLICY, &ncPolicy, sizeof(ncPolicy));

    const BOOL alpha = TRUE;
    DwmSetWindowAttribute(hwnd, DWMWA_REDIRECTIONBITMAP_ALPHA, &alpha, sizeof(alpha));

    const COLORREF noColor = DWMWA_COLOR_NONE;
    DwmSetWindowAttribute(hwnd, DWMWA_CAPTION_COLOR, &noColor, sizeof(noColor));

    const int roundPref = DWMWCP_ROUND;
    DwmSetWindowAttribute(hwnd, DWMWA_WINDOW_CORNER_PREFERENCE, &roundPref, sizeof(roundPref));

    SetWindowPos(hwnd, nullptr, 0, 0, 0, 0,
                 SWP_FRAMECHANGED | SWP_NOMOVE | SWP_NOSIZE | SWP_NOZORDER | SWP_NOOWNERZORDER);
}

void md3UpdateSystemMenuState(HWND hwnd)
{
    HMENU menu = GetSystemMenu(hwnd, FALSE);
    if (!menu)
        return;
    const bool maximized = IsZoomed(hwnd);
    EnableMenuItem(menu, SC_RESTORE, MF_BYCOMMAND | (maximized ? MF_ENABLED : MF_GRAYED));
    EnableMenuItem(menu, SC_MAXIMIZE, MF_BYCOMMAND | (maximized ? MF_GRAYED : MF_ENABLED));
    EnableMenuItem(menu, SC_MOVE, MF_BYCOMMAND | (maximized ? MF_GRAYED : MF_ENABLED));
    EnableMenuItem(menu, SC_SIZE, MF_BYCOMMAND | (maximized ? MF_GRAYED : MF_ENABLED));
    EnableMenuItem(menu, SC_MINIMIZE, MF_BYCOMMAND | MF_ENABLED);
    EnableMenuItem(menu, SC_CLOSE, MF_BYCOMMAND | MF_ENABLED);
}

COLORREF md3ParseCssColor(const QString &css, bool *ok)
{
    const QColor qc = QColor::fromString(css.trimmed());
    if (qc.isValid()) {
        if (ok)
            *ok = true;
        return RGB(qc.red(), qc.green(), qc.blue());
    }

    QString s = css.trimmed();
    if (s.startsWith(QLatin1Char('#')))
        s = s.mid(1);
    if (s.size() == 8)
        s = s.mid(2);
    if (s.size() == 3)
        s = QString(s[0]) + s[0] + s[1] + s[1] + s[2] + s[2];
    if (s.size() != 6) {
        if (ok)
            *ok = false;
        return 0;
    }
    bool localOk = false;
    const uint rgb = s.toUInt(&localOk, 16);
    if (ok)
        *ok = localOk;
    if (!localOk)
        return 0;
    const int r = int((rgb >> 16) & 0xFF);
    const int g = int((rgb >> 8) & 0xFF);
    const int b = int(rgb & 0xFF);
    return RGB(r, g, b);
}

HICON md3CreateHIconFromImage(const QImage &src)
{
    if (src.isNull())
        return nullptr;
    QImage img = src.convertToFormat(QImage::Format_ARGB32_Premultiplied);
    const int w = img.width();
    const int h = img.height();

    BITMAPINFO bmi{};
    bmi.bmiHeader.biSize = sizeof(BITMAPINFOHEADER);
    bmi.bmiHeader.biWidth = w;
    bmi.bmiHeader.biHeight = -h;
    bmi.bmiHeader.biPlanes = 1;
    bmi.bmiHeader.biBitCount = 32;
    bmi.bmiHeader.biCompression = BI_RGB;

    void *bits = nullptr;
    HDC hdc = GetDC(nullptr);
    HBITMAP hbmColor = CreateDIBSection(hdc, &bmi, DIB_RGB_COLORS, &bits, nullptr, 0);
    ReleaseDC(nullptr, hdc);
    if (!hbmColor || !bits)
        return nullptr;

    memcpy(bits, img.constBits(), size_t(w) * size_t(h) * 4);

    HBITMAP hbmMask = CreateBitmap(w, h, 1, 1, nullptr);
    ICONINFO ii{};
    ii.fIcon = TRUE;
    ii.hbmMask = hbmMask;
    ii.hbmColor = hbmColor;
    HICON hIcon = CreateIconIndirect(&ii);
    DeleteObject(hbmColor);
    if (hbmMask)
        DeleteObject(hbmMask);
    return hIcon;
}

HBITMAP md3CreateHBitmapFromImage(const QImage &src)
{
    if (src.isNull())
        return nullptr;
    QImage img = src.convertToFormat(QImage::Format_ARGB32_Premultiplied);
    const int w = img.width();
    const int h = img.height();
    BITMAPINFO bmi{};
    bmi.bmiHeader.biSize = sizeof(BITMAPINFOHEADER);
    bmi.bmiHeader.biWidth = w;
    bmi.bmiHeader.biHeight = -h;
    bmi.bmiHeader.biPlanes = 1;
    bmi.bmiHeader.biBitCount = 32;
    bmi.bmiHeader.biCompression = BI_RGB;
    void *bits = nullptr;
    HDC hdc = GetDC(nullptr);
    HBITMAP hbmp = CreateDIBSection(hdc, &bmi, DIB_RGB_COLORS, &bits, nullptr, 0);
    ReleaseDC(nullptr, hdc);
    if (!hbmp || !bits)
        return nullptr;
    memcpy(bits, img.constBits(), size_t(w) * size_t(h) * 4);
    return hbmp;
}

ITaskbarList3 *md3TaskbarList3()
{
    static ITaskbarList3 *tbl = nullptr;
    static bool tried = false;
    if (!tried) {
        tried = true;
        if (SUCCEEDED(CoCreateInstance(CLSID_TaskbarList, nullptr, CLSCTX_INPROC_SERVER,
                                       IID_PPV_ARGS(&tbl)))
            && tbl) {
            if (FAILED(tbl->HrInit())) {
                tbl->Release();
                tbl = nullptr;
            }
        }
    }
    return tbl;
}

UINT md3GetDpiForWindow(HWND hwnd)
{
    if (!hwnd)
        return 96;
    if (HMODULE user32 = GetModuleHandleW(L"user32.dll")) {
        using GetDpiForWindowFn = UINT (WINAPI *)(HWND);
        if (auto fn = reinterpret_cast<GetDpiForWindowFn>(GetProcAddress(user32, "GetDpiForWindow")))
            return fn(hwnd);
    }
    return 96;
}
#endif
